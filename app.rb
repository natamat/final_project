require 'bundler' #require bundler
Bundler.require #require everything in bundler in gemfile
require './lib/sat-scrape.rb'
require './lib/sat-twilio.rb'

get '/' do
  @sat_question = SAT.new 
  erb :index
end