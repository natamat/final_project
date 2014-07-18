require 'rubygems' 
require 'twilio-ruby'
require 'nokogiri'
require 'open-uri'
require_relative 'sat-scrape.rb'

class Text
  def initialize(to)
    @to = to

  end

  def send 
    sat_questions = SAT.new
    account_sid = 'ACe330ba04d082392df4cb3511dcb72cec'
    auth_token = '2008ea097713e401a16c54029058da82'
    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.account.messages.create(
     :from => '+18152642023',
    :to => @to,
    :body => "INSTRUCTIONS: #{sat_questions.instructions}QUESTION: #{sat_questions.question} ANSWER CHOICES: #{sat_questions.answer_choices}. To check your answers or view them, please visit: http://sat.collegeboard.org/practice/sat-question-of-the-day" 
  )
  end
end 