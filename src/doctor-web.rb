#!/usr/bin/ruby

require 'rubygems'
require 'xmpp4r/client'
require 'sinatra'
require 'erb'
require 'cobravsmongoose'

require '../config/private/web-config.rb'

include Jabber


local_jid = JID.new $SETTINGS[:jid]
@xmpp_connection = Client.new local_jid
@xmpp_connection.connect
@xmpp_connection.auth $SETTINGS[:password]
@xmpp_connection.send Presence.new

$USER_DB = []


get '/' do
	refresh_local_db
	erb :index
end


def refresh_local_db
	message = Message.new $SETTINGS[:master_jid], "request.user_db"
end




