#!/usr/bin/ruby

require 'rubygems'
require 'xmpp4r/client'
require 'sinatra'
require 'erb'
require 'cobravsmongoose'

require '../config/private/web-config.rb'

include Jabber


$user_db = []

local_jid = JID.new $SETTINGS[:jid]
$xmpp_connection = Client.new local_jid
$xmpp_connection.connect
$xmpp_connection.auth $SETTINGS[:password]
$xmpp_connection.send Presence.new

$xmpp_connection.add_message_callback do |message|
	xml = message.body
	hash = CobraVsMongoose.xml_to_hash xml

	case hash['method']
		when 'post'
			handle_xmpp_post hash

		when 'get'
			handle_xmpp_get hash
		
		else
			puts "Is there another xmpp method"
	end
			
end



get '/' do
	refresh_local_db
	erb :index
end


def refresh_local_db
	hash = {
		"internal" => {
			"@method" => "get",
			"@key" => "user_db"
		}
	}

	message = Message::new( $SETTINGS[:master_jid] )
	message.body = CobraVsMongoose.hash_to_xml(hash)
	message.type = :normal
#	message.subject = "asdf"
	
	puts
	puts
	puts
	puts message.inspect
	puts
	puts
	puts message.class
	puts
	puts
	puts message.to_s
	puts 
	puts
	puts hash.inspect
	puts
	puts
	puts CobraVsMongoose.hash_to_xml(hash)
	puts
	puts

	$xmpp_connection.send message
end


def handle_xmpp_post hash
	case hash['key']
		when 'user_db'
			$user_db = hash['value']

		when 'update_exists'
			refresh_local_db

		else
			puts 'Is there another key?'
	end
end





