class MainViewController < ApplicationController

  include BubbleWrap::KVO

  def viewDidLoad
    self.view = UIScrollView.alloc.initWithFrame(self.view.bounds)
    super
    puts "here we #{current_user}"
    self.title = "Spiceworks"
    profile_image = UIImage.imageNamed "profile_button.png"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithImage(profile_image, style:UIBarButtonItemStyleBordered, target:self, action: 'profile_push')
    init_personal_squares
    add_divider if current_user
    pull_channel_json
  end

  def pull_channel_json
    BubbleWrap::HTTP.get(channel_url) do |response|
      if response.ok?
        general_squares(BubbleWrap::JSON.parse(response.body.to_str))
        init_general_squares
        num_squares = @general_squares.count + @personal_squares.count
        self.view.setContentSize(CGSizeMake(self.view.frame.size.width, (num_squares.to_f/3)*(self.view.frame.size.width.to_f/3)+ (num_squares.to_f/3)*PADDING))
      end
    end
  end

  def reset_view
    self.view.subviews.each do |subview|
      subview.removeFromSuperview
    end
    init_personal_squares
    add_divider if current_user
    init_general_squares
  end

  def add_divider
    divider = UIImageView.alloc.initWithImage(UIImage.imageNamed "divider.png")
    height = self.view.frame.size.width/3
    vertical_offset = ((personal_squares.count.to_f/3).ceil)*height
    divider.center = [self.view.center.x, vertical_offset]
    self.view.addSubview(divider)
  end

  def general_squares(json)
    @general_squares = Array.new.tap do |a|
      json.each do |group|
        img = group[:image_path].nil? ? "news.png" : group[:image_path]
        a << {name: group[:name], image: img, controller: ChannelController.alloc.initWithNibName(nil, bundle:nil), id:group[:id]}
      end
    end
  end

  def personal_squares
    @personal_squares = Array.new.tap do |a|
      a << {name:"Activity", image: "news.png", controller: nil} if current_user
      a << {name:"Messages", image: "mail.png", controller: messages_index_controller} if current_user
      a << {name:"Profile",  image: "user.png", controller: profile_controller} if current_user
    end
  end

  def init_personal_squares
    row = 0
    col = 0

    height = width = (self.view.frame.size.width - PADDING*4) / 3
    personal_squares.each do |square|
      button = create_button(square, row, col, height, width, 0)
      self.view.addSubview(button)
      col >= 2 ? (col = 0; row += 1) : col += 1
    end
  end

  def create_button(square, row, col, height, width, vertical_offset)
    button = UIButton.buttonWithType(UIButtonTypeCustom)
    image = UIImage.imageNamed(square[:image])
    button.setTitle(square[:name], forState:UIControlStateNormal)
    button.setImage(image, forState:UIControlStateNormal)
    button.titleLabel.font = (UIFont.systemFontOfSize(13))
    button.setTitleColor(UIColor.blackColor, forState:UIControlStateNormal)
    button.frame = [
      [col * width + (PADDING * (col+1)), row * height + (PADDING*(row+1)) + vertical_offset],
      [width, height]]

    image_size = button.imageView.frame.size
    title_size = button.titleLabel.frame.size
    button.setImageEdgeInsets([0,PADDING + button.imageView.frame.size.width/2,50,PADDING + button.imageView.frame.size.width/2])
    button.setTitleEdgeInsets([PADDING*2,-1*(button.imageView.frame.size.width),0,0])
    button.when(UIControlEventTouchUpInside) do
      square[:controller].set_channel_info(square[:id]) if square[:controller].is_a? ChannelController and square[:controller].needs_update?
      self.navigationController.pushViewController(square[:controller], animated: true)
    end
  end

  def init_general_squares
    row = 0
    col = 0

    height = width = (self.view.frame.size.width - PADDING*4) / 3
    vertical_offset = ((personal_squares.count.to_f/3).ceil)*height + PADDING
    @general_squares.each do |square|
      button = create_button(square, row, col, height, width, vertical_offset)
      self.view.addSubview(button)
      col >= 2 ? (col = 0; row += 1) : col += 1
    end

  end

  def profile_push
    if current_user
      self.navigationController.pushViewController(profile_controller, animated: true)
    else
      login_controller.topViewController.set_container(self)
      self.presentModalViewController(login_controller, animated:true)

    end
  end
end
