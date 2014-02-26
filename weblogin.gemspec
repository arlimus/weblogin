# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'weblogin'

spec = Gem::Specification.new do |s|
  s.name = 'weblogin'
  s.licenses = ['MPLv2']
  s.version = Weblogin::version
  s.platform = Gem::Platform::RUBY
  s.summary = "weblogin helper"
  s.description = s.summary
  s.author = "Dominik Richter"
  s.email = "dominik.richter@googlemail.com"
  s.homepage = 'https://github.com/arlimus/weblogin'

  s.add_dependency 'thor'
  s.add_dependency 'rest-client'
  s.add_dependency 'nokogiri'

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
