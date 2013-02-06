class ChannelController < ApplicationController

  attr_accessor :updated

  LOADING_TAG = 10
  TAB_BAR_TAG = 11

  #Tab Bar Tags

  FOLLOWERS_TAG = 20
  GROUPS_TAG =    21
  TOPICS_TAG =    22
  HOW_TOS_TAG =   23


  def needs_update?
    !@updated
  end

  def set_channel_info(id)
    @updated = true
    @id = id
    BubbleWrap::HTTP.get(channel_show_path(id)) do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body.to_str)
        self.title = json[:name]
        label = self.view.viewWithTag(LOADING_TAG)
        label.removeFromSuperview if label

        init_tab_bar(json)

        init_windows(json)

      else
        puts "failed to get the json"
      end
    end
  end

  def text_to_image(text)
    font = UIFont.systemFontOfSize(20)
    size = text.sizeWithFont(font)

    UIGraphicsBeginImageContextWithOptions(size,false,0.0)

    text.drawAtPoint( CGPointMake(0.0, 0.0), withFont: font)

    img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    img
  end

  def init_windows(json)
    topics = json[:hottest_topics]

    row = 0
    tab_bar = self.view.viewWithTag(TAB_BAR_TAG)
    offset_top = tab_bar.frame.size.height rescue 0


    #oh god here is this...
    topics.each_with_index do |topic, ndx|
      if topics.count % 2 != 0 and ndx == topics.count-1
        width = self.view.frame.size.width
      else
        width = self.view.frame.size.width.to_f/2
      end
      height = self.view.frame.size.width.to_f/4
      hot_button = UIButton.buttonWithType(UIButtonTypeCustom)
      hot_button.setTitle(topic[:subject], forState:UIControlStateNormal)
      hot_button.setTitleColor(UIColor.blackColor, forState:UIControlStateNormal)
      hot_button.layer.addSublayer(gradient)
      hot_button.titleLabel.font = UIFont.boldSystemFontOfSize(12)
      hot_button.titleLabel.numberOfLines = 2
      hot_button.titleLabel.sizeToFit
      hot_button.titleEdgeInsets= UIEdgeInsetsMake(3,3,3,3)
      hot_button.setContentHorizontalAlignment(UIControlContentHorizontalAlignmentLeft)
      hot_button.setContentVerticalAlignment(UIControlContentVerticalAlignmentTop)
      hot_button.layer.setBorderColor("#AAAAAA".to_color.CGColor)
      hot_button.layer.setCornerRadius(5)
      hot_button.layer.setBorderWidth(1)
      hot_button.layer.setMasksToBounds(true)
      hot_button.frame = [[(ndx%2)*width, height*row + offset_top],[width, height]]
      subtext = UILabel.alloc.initWithFrame(CGRectZero)
      subtext.backgroundColor = UIColor.clearColor
      subtext.text = topic[:excerpt].gsub(/(\n|\t)+/, "")
      subtext.font = UIFont.systemFontOfSize(10)
      subtext.numberOfLines = 0
      subtext.frame = [[PADDING.to_f/2, hot_button.titleLabel.frame.origin.y + hot_button.titleLabel.frame.size.height], [hot_button.frame.size.width-PADDING, 50]]
      hot_button.addSubview(subtext)
      row += (ndx%2) #only increment every other time

      hot_button.when(UIControlEventTouchUpInside)do
        topic_controller = saved_topics(topic[:id])
        self.navigationController.pushViewController(topic_controller, animated:true)
      end
      self.view.addSubview(hot_button)
    end
  end

  def saved_topics(id)
    @saved_topics ||= {}
    @saved_topics[id] ||= TopicController.alloc.initWithTopic(id)
  end

  def gradient
    gradient = CAGradientLayer.layer
    gradient.frame = view.bounds
    gradient.colors = [UIColor.whiteColor.CGColor, "#000000".to_color.CGColor]
    gradient
  end

  def init_tab_bar(json)
    tab_bar = UITabBar.alloc.initWithFrame(CGRectZero)
    tab_bar.items = [
      create_custom_tab_bar_item("Followers", text_to_image(json[:follower_count].to_s), FOLLOWERS_TAG),
      create_custom_tab_bar_item("Groups", text_to_image(json[:group_count].to_s), GROUPS_TAG),
      create_custom_tab_bar_item("Topics", text_to_image(json[:topic_count].to_s), TOPICS_TAG),
      create_custom_tab_bar_item("How-Tos", text_to_image(json[:how_to_count].to_s), HOW_TOS_TAG)
    ]

    tab_bar.setTag(TAB_BAR_TAG)
    tab_bar.frame = [[0,0],
                     [self.view.frame.size.width, 50]]

    tab_bar.delegate = self
    self.view.addSubview(tab_bar)
  end

  def viewWillAppear(animated)
    tab_bar = self.view.viewWithTag(TAB_BAR_TAG)
    tab_bar.selectedItem = nil if tab_bar
  end

  def sub_pages(page, controller)
    @sub_pages ||= {}
    @sub_pages[page] ||= controller.alloc.initWithChannelId(@id)
  end

  def tabBar(tabBar, didSelectItem:item)

    controller = nil
    case item.tag
    when FOLLOWERS_TAG

    when GROUPS_TAG
    when TOPICS_TAG
      controller = sub_pages('topics', TopicIndexController)
    when HOW_TOS_TAG
    end
    puts "controller is: #{controller}"
      self.navigationController.pushViewController(controller, animated: true)
  end

  def create_custom_tab_bar_item(title, img, tag)
    utbi = UITabBarItem.alloc.initWithTitle(title, image:img, tag:tag)
    utbi.setTitlePositionAdjustment(UIOffsetMake(0,-1*PADDING.to_f/2))
    utbi
  end

  def viewDidLoad
    super
    home_image = UIImage.imageNamed "home_white.png"
    #space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(home_image, style:UIBarButtonItemStyleBordered, target:self, action:'home_pressed')
    loading_icon = UILabel.alloc.initWithFrame(CGRectZero)
    loading_icon.text = "Please Wait..."
    loading_icon.font = UIFont.systemFontOfSize(18)
    loading_icon.sizeToFit
    loading_icon.setTag(LOADING_TAG)
    loading_icon.center = [self.view.center.x, self.view.frame.origin.y + 150]

    self.view.addSubview(loading_icon)
  end

  def home_pressed
    self.navigationController.popToRootViewControllerAnimated(true)
  end
end
