class TopicController < ApplicationController

  def initWithTopic(id)
    BubbleWrap::HTTP.get(topic_path(id)) do |response|
      if response.ok?
        @data = BubbleWrap::JSON.parse(response.body.to_str)
        self.title = remove_crap(@data[:subject])
        setup_show_data
      else
      end
    end
    self
  end

  def setup_show_data

    self
    self.view.backgroundColor = UIColor.whiteColor
    @title = UILabel.alloc.initWithFrame(CGRectZero)
    @title.text = remove_crap(@data[:subject])
    @title.font = UIFont.boldSystemFontOfSize(20)
    @title.textColor = "#333333".to_color
    @title.numberOfLines = 0
    @title.backgroundColor = UIColor.clearColor
    @title.frame = CGRectMake(PADDING/2,PADDING/2,self.view.frame.size.width-50, 50)

    @author = UILabel.alloc.initWithFrame(CGRectZero)
    @author.text = "By: #{@data[:author][:name]}"
    @author.font = UIFont.systemFontOfSize(12)
    @author.textColor = "#999999".to_color
    @author.backgroundColor = UIColor.clearColor
    @author.frame = [[PADDING/2, @title.frame.origin.y + @title.frame.size.height + PADDING/2],
                     [self.view.frame.size.width-PADDING, @author.text.sizeWithFont(UIFont.systemFontOfSize(12)).height + PADDING]]
    @title_holder = UIView.alloc.initWithFrame(CGRectMake(0,0,self.view.frame.size.width, @title.frame.size.height+PADDING + @author.frame.size.height))
    @title_holder.backgroundColor = "#F0F0F0".to_color

    @title_holder.addSubview(@title)
    @title_holder.addSubview(@author)

    @post = UITextView.alloc.initWithFrame(CGRectZero)
    @post.text = remove_crap(@data[:root_post][:text]).kv_decodeHTMLCharacterEntities
    self.view.backgroundColor = UIColor.whiteColor
    @post.font = UIFont.systemFontOfSize(12)
    @post.textColor = UIColor.blackColor
    @post.editable = false
    @post.sizeToFit
    size = @post.text.sizeWithFont(UIFont.systemFontOfSize(20), constrainedToSize:CGSizeMake(self.view.frame.size.width, 5000), lineBreakMode:UILineBreakModeTailTruncation)
    @post.frame =[[0,@title_holder.frame.size.height], [self.view.frame.size.width,size.height]]

    self.view.addSubview(@title_holder)
    self.view.addSubview(@post)

    self.view.frame = [[0,@title_holder.frame.size.height], [self.view.frame.size.width, @title_holder.frame.size.height + size.height + PADDING]]
  end

  def viewDidLoad
    super
    self.view = UIScrollView.alloc.initWithFrame(CGRectZero)
    self.view.backgroundColor = UIColor.whiteColor
  end
end
