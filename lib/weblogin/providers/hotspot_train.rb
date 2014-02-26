require 'nokogiri'
require 'rest-client'
require 'uri'

class LogInto::HotSpot_Train
  def is_mine? response
    response.args[:url] =~ /http:\/\/([a-zA-Z0-9.]+\.|)railnet.train/
  end

  def login_with_response response
    # get some fields that are set anyway
    url = URI.parse(response.args[:url])
    cookie = response.args[:headers][:cookie]
    body = response.body
    login( url, cookie, body )
  end

  def login url, cookie, body
    # find out the real url of the rail site
    dom = Nokogiri::parse(body)
    redirecters = dom.css("meta").map{|i| i.attributes["content"]}.compact
    redirecter = redirecters[0].value
    referer_part = redirecter.match(/URL=(.*)/)[1]
    referer = URI::join(url, referer_part).to_s

    # load the rail site, say hello (just for the sake of saying hello)
    hotspot_train = RestClient.get referer, Cookie: cookie
    # now load the hotspot (finally)
    LogInto::HotSpot.new.login referer, cookie, body
  end
end
