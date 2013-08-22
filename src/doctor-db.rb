#!/usr/bin/ruby


require 'rubygems'
require 'cobravsmongoose'
require 'xmpp4r/client'

require '../config/private/db-config.rb'

include Jabber

$user_db = []

if File.exists?( $SETTINGS[:base_user_db] ) then
	xml = ""
	File.open($SETTINGS[:base_user_db] , 'r' ) do |file|
		file.each_line do |line|
			xml += line
		end
	end
	$user_db = CobraVsMongoose.xml_to_hash(xml)['save']['user']
end


local_jid = JID.new $SETTINGS[:jid]
$xmpp_connection = Client.new local_jid
$xmpp_connection.connect
$xmpp_connection.auth $SETTINGS[:password]
$xmpp_connection.send Presence.new

$xmpp_connection.add_message_callback do |message|
	body = message.body
	puts message.from
	hash = CobraVsMongoose.xml_to_hash body

	unless hash.empty? then
		puts message.to_s
		puts hash.inspect

		case hash['internal']['@method']
			when 'post'
				handle_xmpp_post hash, message.from

			when 'get'
				handle_xmpp_get hash, message.from

			when 'admin'
				puts "admin admin admin admin admin admin"
				handle_xmpp_admin hash, message.from

			else
				puts "Is there another xmpp method?"
		end
	end
end


def handle_xmpp_post hash, source
	case hash['internal']['@key']
		when 'user_db'
			puts hash['internal']['user']
			$user_db = hash['internal']['user'].clone
		
		when 'user'
			name = hash['internal']['user']['@name']
			$user_db.each do |user|
				if user['@name'] == name then
					hash['internal']['user'].each do |key, value|
						user[key] = value
					end
				end
			end

		else
			puts "error"
	end

end



def handle_xmpp_get hash, source
	case hash['internal']['@key']
		when 'user_db'
			puts
			puts
			puts "sending user_db"
			resp = {
				'internal' => {
					'@method' => 'post',
					'@key' => 'user_db',
					'user' => $user_db
				}
			}
			
			puts
			puts source
			puts 

			m = Message.new source
			m.body = CobraVsMongoose.hash_to_xml resp
			m.type = :normal
	
			puts
			puts
			puts m.to_s
			puts
			puts
			puts

			$xmpp_connection.send m

		else
			"sadf"
	end
end


def handle_xmpp_admin hash, source
	case hash['internal']['@key']
		when 'save'
		save

		when 'load'
			#TODO: implement
		
		else

	end
end


def save
	puts "1"
	to_save = {
		'save' => {
			'user' => $user_db
		}
	}
	puts "2"

	File.open($SETTINGS[:base_user_db], 'w') do |file|
		file.puts CobraVsMongoose.hash_to_xml to_save
	end
	puts "3"
end

Thread.stop


