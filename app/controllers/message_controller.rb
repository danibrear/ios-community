class MessageController < ApplicationController

  attr_accessor :id

  def initWithId(id)
    @id = id

    BubbleWrap::HTTP.get(message_path(id), headers: current_user_headers) do |response|

      if response.ok?
        @data = BubbleWrap::JSON.parse(response.body.to_str)
        @root = @data[:message]
        @messages = @data[:messages]
        self.title = @root[:subject]
        show_messages

        show_form
      else
        alert = UIAlertView.alloc.initWithTitle("Error Loading Message", delegate:self, cancelButtonTitle:"That sucks", otherButtonTitles:nil)
        alert.show
      end
    end
    self
  end

  def show_messages

    @messages_holder = UIView.alloc.initWithFrame(CGRectMake(0,0,self.view.frame.size.width, 0))
    @last_message = nil
    @poster = @messages.first[:name] if @messages.first
    colors = ["#dae8fe".to_color, "#defed7".to_color]
    @messages.each do |message|
      y = @last_message.origin.y + @last_message.frame.size.height + PADDING rescue PADDING

      @message = UIView.alloc.initWithFrame([[PADDING/2,y], [@messages_holder.frame.size.width-PADDING, 0]])

      @message.backgroundColor = @poster == message[:name] ? colors[0] : colors[1]
      @message.layer.cornerRadius = 5

      author = UILabel.alloc.initWithFrame(CGRectMake(PADDING, PADDING, @message.frame.size.width - PADDING*2, 0))
      author.text = message[:name]
      author.font = UIFont.boldSystemFontOfSize(NORMAL_FONT)
      author.backgroundColor = UIColor.clearColor
      author.sizeToFit

      post = UILabel.alloc.initWithFrame(CGRectMake(PADDING, PADDING + author.frame.size.height, @message.frame.size.width - PADDING*2, 0))
      post.text = message[:text]
      post.numberOfLines = 0
      post.backgroundColor = UIColor.clearColor
      post.font = UIFont.systemFontOfSize(NORMAL_FONT)
      post.sizeToFit

      @message.addSubview(author)
      @message.addSubview(post)
      @message.frame = CGRectMake(@message.origin.x, @message.origin.y, @message.frame.size.width, author.frame.size.height + post.frame.size.height + PADDING*2)

      @messages_holder.addSubview(@message)
      @messages_holder.frame = CGRectMake(@messages_holder.origin.x,
                                          @messages_holder.origin.y,
                                          @messages_holder.frame.size.width,
                                          @messages_holder.frame.size.height + @message.frame.size.height + PADDING)
      @last_message = @message
    end

    self.view.addSubview(@messages_holder)
    self.view.setContentSize([self.view.frame.size.width, self.view.contentSize.height += @messages_holder.frame.size.height])
  end

  def show_form
    @form_holder = UIView.alloc.initWithFrame(CGRectMake(0, @messages_holder.origin.y + @messages_holder.frame.size.height, self.view.frame.size.width, 0))

    @reply_field = UITextView.alloc.initWithFrame(CGRectMake(PADDING, PADDING, @form_holder.frame.size.width - PADDING*2, 125))
    @reply_field.editable = true
    @reply_field.layer.borderColor = UIColor.lightGrayColor.CGColor
    @reply_field.layer.borderWidth = 1

    @reply_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @reply_button.setTitle("Reply", forState:UIControlStateNormal)
    @reply_button.sizeToFit
    @reply_button.frame = CGRectMake(@reply_field.origin.x + @reply_field.frame.size.width - @reply_button.frame.size.width,
                                     @reply_field.origin.y + @reply_field.frame.size.height + PADDING,
                                     @reply_button.frame.size.width,
                                     @reply_button.frame.size.height)


    @form_holder.addSubview(@reply_field)
    @form_holder.addSubview(@reply_button)
    @form_holder.frame = CGRectMake(@form_holder.origin.x, @form_holder.origin.y, @form_holder.frame.size.width, @reply_button.frame.size.height + @reply_field.frame.size.height + PADDING)

    self.view.addSubview(@form_holder)
    self.view.setContentSize([self.view.frame.size.width, self.view.contentSize.height += @form_holder.frame.size.height + PADDING])
  end

  def viewDidLoad
    super
    self.view = UIScrollView.alloc.initWithFrame(self.view.bounds)
    self.view.backgroundColor = UIColor.whiteColor
  end
end
