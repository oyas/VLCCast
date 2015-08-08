#!/usr/bin/ruby
require 'webrick'
require 'open-uri'


# 設定
Controller_port = "8080"
Controller_url_status = "http://localhost:"+Controller_port+"/requests/status.json"	# VLCの操作した結果はJSONで受け取れる
Controller_url_playlist = "http://localhost:"+Controller_port+"/requests/playlist.json"	# プレイリスト取得用(uri取得用)

Open_options = { :http_basic_authentication => ["","pass"] }

# /get を処理するサーブレット
class GetreqServlet < WEBrick::HTTPServlet::AbstractServlet
	def do_GET(req, res)
		res['Access-Control-Allow-Origin'] = '*'
		case req.query_string
		when "status"
			res["content-type"] = "application/json"
			res.body = open( Controller_url_status, Open_options ).read
		when "playlist"
			res["content-type"] = "application/json"
			res.body = open( Controller_url_playlist, Open_options ).read
		end
	end
end

# サーバー準備
srv = WEBrick::HTTPServer.new({
	:DocumentRoot => './',
	:BindAddress => '127.0.0.1',
	:Port => 20080,
})

srv.mount('/get', GetreqServlet)

trap("INT"){ srv.shutdown }
srv.start
