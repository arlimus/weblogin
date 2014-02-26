require 'nokogiri'
require 'rest-client'
require 'uri'

class LogInto::HotSpot_Airport
  def is_mine? response
    # eg: https://hotspot.t-mobile.net/wlan/start.do?ts=1381305999133
    response.args[:url] =~ /https:\/\/hotspot\.t-mobile\.net\/landing\/TD\/Airport/
  end

  def login_with_response response
    # get some fields that are set anyway
    url = URI.parse(response.args[:url])
    cookie = response.args[:headers][:cookie]
    body = response.body
    login( url, cookie, body )
  end

  def login url, cookie, body
    LogInto::HotSpot.new.login url.to_s, cookie
  end
end
