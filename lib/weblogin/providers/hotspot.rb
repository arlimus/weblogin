require 'nokogiri'
require 'rest-client'
require 'uri'

class LogInto::HotSpot
  def is_mine? response
    # eg: https://hotspot.t-mobile.net/wlan/start.do?ts=1381305999133
    ( response.args[:url] =~ /https:\/\/hotspot.t-mobile.net\/wlan\/start.do/ ) or
    ( response.args[:url] =~ /https:\/\/hotspot.t-mobile.net\/landing\/TD\/Telekom\// )
  end

  def login_with_response response
    # get some fields that are set anyway
    url = URI.parse(response.args[:url])
    cookie = response.args[:headers][:cookie]
    body = response.body
    login( url, cookie, body )
  end

  def login url, cookie, body
    # load the hotspot start page
    hotspot_url = "https://hotspot.t-mobile.net/wlan/start.do"
    hotspot = RestClient.get hotspot_url, Referer: url.to_s, Cookie: cookie

    # parse the main site and get the login form
    hdom = Nokogiri::parse(hotspot.body)
    hform = hdom.css("form").find{|i|i.attributes["id"].value == "f_login"}

    # get all of the fields from the login form in simple directory
    fields = Hash[ hform.css("input").map{|i| [i.attributes["name"].value, i.attributes["value"].to_s]} ]
    # add our two fields
    fields["username"] = provider_user "hotspot"
    fields["password"] = provider_password "hotspot"
    
    # now send the login to the hotspot site
    begin 
      res = RestClient.post hotspot_url, fields, {
        Referer: url.to_s, 
        Cookie: cookie
      }
    rescue => e
      # it may break out, but this usually also happends for HTTP 302
      puts "Broke out: #{e.response}"
    end

  end
end
