#!/usr/bin/ruby

require 'rubygems'
require 'xmpp4r/client'
require 'sinatra'
require 'erb'
require '../config/private/web-config.rb'

get '/' do
	refresh_local_db
	erb :index
end


def refresh_local_db
	
end

def connect_to_xmpp
	
end


