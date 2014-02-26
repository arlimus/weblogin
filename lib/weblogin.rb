require 'uri'

# quicly get all submodules
# http://www.natontesting.com/2010/06/30/how-to-get-the-submodules-of-a-ruby-module/
class Module
  def submodules
    constants.collect {|const_name| const_get(const_name)}.select {|const| const.class == Module}
  end

  def subclasses
    constants.collect {|const_name| const_get(const_name)}.select {|const| const.class == Class}
  end
end

# base module for all construction workers/monkeys
module LogInto
end

class Weblogin
  def self.version; 0.3 end

  def initialize
    # include all helper modules
    # 1. collect all folders where helper modules are
    global = __FILE__.sub(/.rb$/,'')
    dirs = [global]
    # 2. include all helper files from the folders
    dirs.each do |d|
      $:.unshift(d)
      Dir[File::join(d,"providers","*.rb")].
        map{|i| i.sub /\.rb$/, ''}.
        each{|i| require i}
    end
    # 3. instantiate helper modules
    @helpers = LogInto.subclasses.map do |c|
        add_methods_to_provider(c)
        c.new
      end
  end

  def autodetect_login

    # try to log into a typical site
    first = RestClient.get "http://www.google.com"
    if first.args[:url] == "http://www.google.com"
      puts "looks good, you can reach ya'r internet mate"
      exit 0
    end

    h = @helpers.find do |helper|
        helper.is_mine?(first)
      end
    # if we can't handle it, exit
    if h.nil?
      puts "can't find any helper to handle this weblogin"
      puts "site points to: #{first.args[:url]}"
      exit 0
    end

    # invoke the handler to log us in
    puts "using helper: #{h.class}"
    h.login_with_response first
  end

end
