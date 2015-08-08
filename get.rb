#!/usr/local/bin/ruby
# encoding: UTF-8
require 'webrick/cgi'
require 'open-uri'
require "cgi"


cgi = CGI.new;
path = cgi['path']
request = cgi['req'];


Controller_port = "8080"
Controller_url = "http://localhost:"+Controller_port+"/requests/status.json"	# VLCの操作した結果はJSONで受け取れる
Controller_url_playlist = "http://localhost:"+Controller_port+"/requests/playlist.json"	# プレイリスト取得用(uri取得用)

Open_options = { :http_basic_authentication => ["","oyas"] }



class MyCGI < WEBrick::CGI
	def do_GET(req, res)
		cgi = CGI.new;
		request = cgi['req'];

		res['Access-Control-Allow-Origin'] = '*'
		case request
		when "status"
			res["content-type"] = "application/json"
			res.body = open( Controller_url, Open_options ).read
		when "playlist"
			res["content-type"] = "application/json"
			res.body = open( Controller_url_playlist, Open_options ).read
		end
	end
end

MyCGI.new.start()

