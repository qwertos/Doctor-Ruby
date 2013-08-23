#!/usr/bin/ruby

require 'rubygems'
require 'xmpp4r/client'
require 'cobravsmongoose'

require '../config/private/scan-config.rb'

include Jabber


local_jid = JID.new $SETTINGS[:jid]
$xmpp_connection = Client.new local_jid
$xmpp_connection.connect
$xmpp_connection.auth $SETTINGS[:password]
$xmpp_connection.send Presence.new

$xmpp_connection.add_message_callback do |message|
	body = message.body
	
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
				handle_xmpp_admin hash, message.from

			else
				puts "Is there another XMPP method?"

		end
	end
end


def handle_xmpp_get hash, source
	case hash['internal']['@key']
		
		else

	end
end


def handle_xmpp_post hash, source
	case hash['internal']['@key']
		
		else

	end
end


def handle_xmpp_admin hash, source
	case hash['internal']['@key']
		
		else

	end
end


def start_poller
	loop do
		
	end
end


# TODO: figure out if i am testing stdout, stderr, or exit value
def ping addr
	result = `#{sprintf( $SETTINGS[:cmd], addr )}`
	return result == 0
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
  

  $xmpp_connection.send message
end


