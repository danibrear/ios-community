class TopicController < ApplicationController

  attr_accessor :id

  def initWithTopic(id)
    @id = id
    BubbleWrap::HTTP.get(topic_path(id), headers: current_user_headers) do |response|
      if response.ok?
        @data = BubbleWrap::JSON.parse(response.body.to_str)
        add_spice_buttons
        test_layout
      else
      end
    end
    self
  end

  def add_spice_buttons
    if current_user
      @vote_array = [UIImage.imageNamed("spice_up.png"), UIImage.imageNamed("spice_down.png")]

      @segmented_control = UISegmentedControl.alloc.initWithItems(@vote_array)
      @segmented_control.segmentedControlStyle = UISegmentedControlStyleBar
      @segmented_control.delegate = self
      @segmented_control.addTarget(self, action:"topic_spiced", forControlEvents:UIControlEventValueChanged)

      case @data[:spiced_topic]
      when 1
        @segmented_control.selectedSegmentIndex = 0
      when -1
        @segmented_control.selectedSegmentIndex = 1
      end
      #self.navigationController.toolbar.addSubview(@segmented_control)
      #self.navigationController.setToolbarHidden(false, animated:true)
      self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(@segmented_control)
    end
  end

  def topic_spiced
    value = case @segmented_control.selectedSegmentIndex
            when 0
              1
            when 1
              -1
            end
    BubbleWrap::HTTP.post(spice_path, headers: current_user_headers, payload: {class: "Topic", id: @id, value: value, show_label:false}) do |response|
      if response.ok?
        puts "saved!"
      else
        puts "failed..."
      end
    end
  end

  def test_layout

    set_title_holder
    set_root_post
    set_comment_divider
    set_comments

    add_bottom_padding

  end

  def add_bottom_padding
    self.view.setContentSize([self.view.frame.size.width, self.view.contentSize.height += PADDING*5])
  end

  def set_title_holder
    @title_holder = UIView.alloc.initWithFrame(CGRectMake(0,0,self.view.frame.size.width, 100))
    @title_holder.backgroundColor = "#F0F0F0".to_color
    @title_holder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    
    @title = UILabel.alloc.initWithFrame(CGRectMake(PADDING,PADDING,self.view.frame.size.width, 15))
    @title.backgroundColor = UIColor.clearColor
    @title.text = remove_crap(@data[:subject])
    @title.numberOfLines = 0
    @title.font = UIFont.systemFontOfSize(LARGE_FONT)
    @title.sizeToFit
    @title.textColor = "#333333".to_color
    @title.frame = [[@title.frame.origin.x, @title.frame.origin.y], [@title_holder.frame.size.width - PADDING*2, @title.frame.size.height]]


    @author = UILabel.alloc.initWithFrame(CGRectZero)
    @author.text = "By: #{@data[:author][:name]}"
    @author.font = UIFont.systemFontOfSize(NORMAL_FONT)
    @author.textColor = "#999999".to_color
    @author.backgroundColor = UIColor.clearColor
    @author.sizeToFit
    @author.frame = [[PADDING, @title.frame.origin.y + @title.frame.size.height + PADDING/2],
                     [self.view.frame.size.width-PADDING, @author.frame.size.height + PADDING]]

    @title_holder.addSubview(@title)
    @title_holder.addSubview(@author)
    @title_holder.frame = [[@title_holder.origin.x, @title_holder.origin.y],[@title_holder.frame.size.width, @title.frame.size.height + @author.frame.size.height + PADDING*2]]
    @title_holder.sizeToFit

    self.view.addSubview(@title_holder)
    self.view.setContentSize([self.view.frame.size.width, self.view.contentSize.height += @title_holder.frame.size.height])
  end

  def set_root_post
    @root_post_holder = UIView.alloc.initWithFrame(CGRectMake(0,@title_holder.origin.y + @title_holder.frame.size.height, self.view.frame.size.width,0))

    @post = UILabel.alloc.initWithFrame(CGRectMake(PADDING/2,0,@root_post_holder.frame.size.width-PADDING, 0))
    @post.text = remove_html(remove_crap(@data[:root_post][:text]))
    @post.font = UIFont.systemFontOfSize(NORMAL_FONT)
    @post.textColor = UIColor.blackColor
    @post.numberOfLines = 0
    @post.sizeToFit
    @root_post_holder.addSubview(@post)
    @root_post_holder.frame = [[@root_post_holder.origin.x+PADDING/2, @root_post_holder.origin.y], [@root_post_holder.frame.size.width-PADDING, @post.frame.size.height + PADDING]]

    self.view.addSubview(@root_post_holder)
    self.view.setContentSize([self.view.frame.size.width, self.view.contentSize.height += @root_post_holder.frame.size.height])
  end

  def set_comment_divider
    @divider = UIImageView.alloc.initWithImage(UIImage.imageNamed "comments_divider.png")
    @divider.center = [self.view.center.x, @root_post_holder.origin.y + @root_post_holder.frame.size.height]
    self.view.addSubview(@divider)
    self.view.setContentSize([self.view.frame.size.width, self.view.contentSize.height += @divider.frame.size.height])
  end

  def set_comments
    @comment_list_holder = UIView.alloc.initWithFrame([[PADDING, @divider.origin.y + @divider.frame.size.height], [self.view.frame.size.width-PADDING*2, 0]])
    @post_data = @data[:posts]
    @last_comment = nil
    @post_data.each do |post|
      #set up the y for this comment
      y = @last_comment.origin.y + @last_comment.frame.size.height + PADDING rescue PADDING

      @comment_holder = UIView.alloc.initWithFrame(CGRectMake(0, y, @comment_list_holder.frame.size.width, 0))
      @comment_holder.backgroundColor = "#F0F0F0".to_color
      @comment_holder.layer.borderColor = UIColor.lightGrayColor.CGColor
      @comment_holder.layer.borderWidth = 1
      @comment_holder.layer.cornerRadius = 3

      the_text = remove_html(remove_crap(post[:text]))
      the_author = post[:author][:name]

      author = UILabel.alloc.initWithFrame(CGRectMake(PADDING, PADDING, @comment_holder.frame.size.width, 0))
      author.text = the_author
      author.numberOfLines = 0
      author.font = UIFont.boldSystemFontOfSize(NORMAL_FONT)
      author.backgroundColor = UIColor.clearColor
      author.sizeToFit

      comment = UILabel.alloc.initWithFrame(CGRectMake(PADDING, PADDING + author.frame.size.height, @comment_holder.frame.size.width-PADDING*3, 0))
      comment.text = the_text
      comment.font = UIFont.systemFontOfSize(NORMAL_FONT)
      comment.backgroundColor = UIColor.clearColor
      comment.numberOfLines = 0
      comment.sizeToFit

      @comment_holder.addSubview(author)
      @comment_holder.addSubview(comment)

      @comment_holder.frame = [@comment_holder.origin, [@comment_holder.frame.size.width, author.frame.size.height + comment.frame.size.height + PADDING*2]]

      @comment_list_holder.addSubview(@comment_holder)
      @comment_list_holder.frame = [@comment_list_holder.origin, [@comment_list_holder.frame.size.width, @comment_list_holder.frame.size.height + @comment_holder.frame.size.height + PADDING]]

      @last_comment = @comment_holder
    end

    self.view.addSubview(@comment_list_holder)
    self.view.setContentSize([self.view.frame.size.width, self.view.contentSize.height += @comment_list_holder.frame.size.height])
  end

  def viewDidLoad
    super
    self.view = UIScrollView.alloc.initWithFrame(self.view.bounds)
    self.view.backgroundColor = UIColor.whiteColor
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

  end
end
