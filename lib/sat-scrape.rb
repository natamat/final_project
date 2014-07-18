require 'nokogiri'
require 'open-uri'

class SAT
  def initialize 
  

    sqotd = "http://sat.collegeboard.org/practice/sat-question-of-the-day"
    doc = Nokogiri::HTML(open(sqotd))

    @instructions = doc.css("#qotdQuestionContainer").first.children[1].children.children.children.children.text
    @question = doc.css(".questionStem").children.children[1,23].text
    @answer_choices = doc.css("#qotdChoicesFields").children.children.children.children.text
  end 

  def instructions
    @instructions
  end

  def question
    @question
  end
  def answer_choices
    @answer_choices
    
  end



end 