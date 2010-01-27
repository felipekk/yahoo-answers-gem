require 'yahoo'

##
# Yahoo! Answers API
#
# http://developer.yahoo.com/answers/V1/questionSearch.html

class Yahoo::Answers < Yahoo

  Question = Struct.new :id, :type, :subject, :content, :date, :timestamp, :link, :category_id, :category, :user_id,
                        :user_nick, :user_photo_url, :num_answers, :num_comments, :answer, :answerer_id,
                        :answerer_nick, :answer_timestamp, :answer_award_timestamp

  def initialize(*args) # :nodoc:
    @host = 'answers.yahooapis.com'
    @service_name = 'AnswersService'
    @version = 'V1'
    super
  end

  ##
  # Searches the web for <tt>:query</tt> and returns up to <tt>:results</tt> results
  #
  # <tt>:results</tt> defaults to 10 questions, maximum per Yahoo! Answers API is 50
  #
  # All options on http://developer.yahoo.com/answers/V1/questionSearch.html can be used

  def search(options)
    params = { :results => 10 }.merge(options)
    get :questionSearch, params
  end

  def parse_response(xml) # :nodoc:
    results = []

    xml.xpath('//xmlns:Question').each do |r|
      result = Question.new

      result.id = r.attribute('id').content
      result.type = r.attribute('type').content
      result.subject = r.at_xpath('xmlns:Subject').content
      result.content = r.at_xpath('xmlns:Content').content
      result.date = r.at_xpath('xmlns:Date').content
      result.timestamp = r.at_xpath('xmlns:Timestamp').content.to_i
      result.link = r.at_xpath('xmlns:Link').content
      result.category_id = r.at_xpath('xmlns:Category').attribute('id').content.to_i
      result.category = r.at_xpath('xmlns:Category').content
      result.user_id = r.at_xpath('xmlns:UserId').content
      result.user_nick = r.at_xpath('xmlns:UserNick').content
      result.user_photo_url = r.at_xpath('xmlns:UserPhotoURL').content
      result.num_answers = r.at_xpath('xmlns:NumAnswers').content.to_i
      result.num_comments = r.at_xpath('xmlns:NumComments').content.to_i
      result.answer = r.at_xpath('xmlns:ChosenAnswer').content
      result.answerer_id = r.at_xpath('xmlns:ChosenAnswererId').content
      result.answerer_nick = r.at_xpath('xmlns:ChosenAnswererNick').content
      result.answer_timestamp = r.at_xpath('xmlns:ChosenAnswerTimestamp').content.to_i
      result.answer_award_timestamp = r.at_xpath('xmlns:ChosenAnswerAwardTimestamp').content.to_i

      results << result
    end

    return results
  end
end

##
# A Result contains the following fields
#
# +id+:: unique id of the question
# +type+:: state of the question (answered, open, ...)
# +subject+:: question subject
# +content+:: question text
# +date+:: pre-formatted date of when the question was submitted
# +timestamp+:: unix timestamp of when the question was submitted
# +link+:: link to the question
# +category+:: category that the question is listed under
# +category_id+:: unique id of the category
# +user_id+:: unique id of the user who posted the question
# +user_nick+:: nickname of the user who posted the question
# +user_photo_url+:: URL of the user's photo
# +num_answers+:: number of answers to the question
# +num_comments+:: number of comments to the question
# +answer+:: the text of the chosen answer
# +answer_timestamp+:: unix time of when the answer was submitted
# +answer_award_timestamp+:: unix time of when the answer was given an award
# +answerer_id+:: unique id of the user who submitted the answer
# +answerer_nick+:: nickname of the user who submitted the answer

class Yahoo::Answers::Result; end