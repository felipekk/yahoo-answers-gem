require 'helper'

class Yahoo::TestAnswers < Test::Unit::TestCase

  context "given a response" do
    setup do
      URI::HTTP.responses = []
      URI::HTTP.responses << <<-EOF.strip
<?xml version="1.0" encoding="utf-8" standalone="yes" ?>
<ResultSet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:yahoo:answers" xsi:schemaLocation="urn:yahoo:answers http://answers.yahooapis.com/AnswersService/V1/QuestionResponse.xsd">
    <Question id="20080217202924AAkuKbJ" type="Answered">
        <Subject>***cars?***?</Subject>
        <Content>has anyone seen the new go smart cars? i dont like them. to me it looks like a car that got cut in half. my mom wants to buy one for me. wat do u think of them?</Content>
        <Date>2008-02-17 20:29:24</Date>
        <Timestamp>1203308964</Timestamp>
        <Link>http://answers.yahoo.com/question/?qid=20080217202924AAkuKbJ</Link>
        <Category id="396545312">Buying and Selling</Category>
        <UserId>xryGBiRVaa</UserId>
        <UserNick>@13x</UserNick>
        <UserPhotoURL/>
        <NumAnswers>3</NumAnswers>
        <NumComments>6</NumComments>
        <ChosenAnswer>I think there an oxymoron. Smart people do not buy them. You would be better off buying Barbies Corvette.</ChosenAnswer>
        <ChosenAnswererId>4e22efbfa0c39c853547002dfd47db5faa</ChosenAnswererId>
        <ChosenAnswererNick>Just Me</ChosenAnswererNick>
        <ChosenAnswerTimestamp>1203310721</ChosenAnswerTimestamp>
        <ChosenAnswerAwardTimestamp>1203558774</ChosenAnswerAwardTimestamp>
    </Question>
    <Question id="20100110090837AACoHlh" type="Open">
        <Subject>How can i determine the speed of the cars?</Subject>
        <Content>I just wanted to know, generally, how can i figure out what the speed of two cars was before they got into an accident, to determine which car was speeding. I know skid marks were left and the conditions were dry, level and smooth.</Content>
        <Date>2010-01-10 09:08:37</Date>
        <Timestamp>1263143317</Timestamp>
        <Link>http://answers.yahoo.com/question/?qid=20100110090837AACoHlh</Link>
        <Category id="396545317">Other - Cars and Transportation</Category>
        <UserId>EkIFD4K4aa</UserId>
        <UserNick>nhh</UserNick>
        <UserPhotoURL>http://l.yimg.com/a/i/identity/nopic_48.gif</UserPhotoURL>
        <NumAnswers>1</NumAnswers>
        <NumComments>0</NumComments>
        <ChosenAnswer/>
        <ChosenAnswererId/>
        <ChosenAnswererNick/>
        <ChosenAnswerTimestamp/>
        <ChosenAnswerAwardTimestamp/>
    </Question>
</ResultSet>
<!-- ws13.ydn.ac4.yahoo.com compressed/chunked Wed Jan 27 08:50:07 PST 2010 -->
      EOF
      URI::HTTP.uris = []

      @answer = Yahoo::Answers.new 'APP_ID'
    end

    context "when doing a search" do
      setup do
        @results = @answer.search(:query => 'cars')
      end

      should("have two results") { assert_equal 2, @results.size }

      context "the first result" do
        setup do
          @result = @results.first
        end

        should("have correct id") { assert_equal "20080217202924AAkuKbJ", @result.id }
        should("have correct type") { assert_equal "Answered", @result.type }
        should("have correct subject") { assert_equal "***cars?***?", @result.subject }
        should("have correct content") { assert_equal "has anyone seen the new go smart cars? i dont like them. to me it looks like a car that got cut in half. my mom wants to buy one for me. wat do u think of them?", @result.content }
        should("have correct date") { assert_equal "2008-02-17 20:29:24", @result.date }
        should("have correct timestamp") { assert_equal 1203308964, @result.timestamp }
        should("have correct link") { assert_equal "http://answers.yahoo.com/question/?qid=20080217202924AAkuKbJ", @result.link }
        should("have correct category id") { assert_equal 396545312, @result.category_id }
        should("have correct category") { assert_equal "Buying and Selling", @result.category }
        should("have correct user id") { assert_equal "xryGBiRVaa", @result.user_id }
        should("have correct user nick") { assert_equal "@13x", @result.user_nick }
        should("have blank user photo url") { assert_equal "", @result.user_photo_url }
        should("have correct num answers") { assert_equal 3, @result.num_answers }
        should("have correct num comments") { assert_equal 6, @result.num_comments }
        should("have correct answer") { assert_equal "I think there an oxymoron. Smart people do not buy them. You would be better off buying Barbies Corvette.", @result.answer }
        should("have correct answer timestamp") { assert_equal 1203310721, @result.answer_timestamp }
        should("have correct answerer id") { assert_equal "4e22efbfa0c39c853547002dfd47db5faa", @result.answerer_id }
        should("have correct answerer nick") { assert_equal "Just Me", @result.answerer_nick }
      end

      context "the last result" do
        setup do
          @result = @results.last
        end

        should("have correct user photo url") { assert_equal "http://l.yimg.com/a/i/identity/nopic_48.gif", @result.user_photo_url }
        should("have blank answer") { assert_equal "", @result.answer }
        should("have correct answer timestamp") { assert_equal 0, @result.answer_timestamp }
        should("have correct answer award timestamp") { assert_equal 0, @result.answer_award_timestamp }
      end
    end
  end
end
