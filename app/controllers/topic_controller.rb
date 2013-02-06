class TopicController < ApplicationController

  def initWithTopic(id)
    BubbleWrap::HTTP.get(topic_path(id)) do |response|

    end
  end
  def viewDidLoad
    super
  end
end
