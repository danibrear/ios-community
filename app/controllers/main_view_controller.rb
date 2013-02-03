class MainViewController < ApplicationController

  PADDING = 10
  def viewDidLoad
    super
    self.title = "Spiceworks"
    profile_image = UIImage.imageNamed "profile_button.png"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithImage(profile_image, style:UIBarButtonItemStyleBordered, target:self, action: 'profile_push')
    init_squares
  end

  def squares
    @squares = []
    @squares << {name:"Activity", image: "news.png", controller: nil} if current_user
    @squares << {name:"Messages", image: "mail.png", controller: messages_controller} if current_user
    @squares << {name:"Profile",  image: "user.png", controller: profile_controller} if current_user
    @squares << {name:"Topics",   image: "note.png", controller: topics_controller}
    @squares << {name:"Groups",   image: "groups.png", controller: groups_controller}
    @squares << {name:"How-tos",  image: "how-tos.png", controller: how_tos_controller}
    @squares
  end

  def init_squares
    row = 0
    col = 0

    height = width = (self.view.frame.size.width - PADDING*4) / 3
    squares.each do |square|
      button = UIButton.buttonWithType(UIButtonTypeCustom)
      image = UIImage.imageNamed(square[:image])
      button.setTitle(square[:name], forState:UIControlStateNormal)
      button.setImage(image, forState:UIControlStateNormal)
      button.titleLabel.font = (UIFont.fontWithName("Helvetica", size:13))
      button.setTitleColor(UIColor.blackColor, forState:UIControlStateNormal)
      button.frame = [
        [col * width + (PADDING * (col+1)), row * height + (PADDING*(row+1))],
        [width, height]]

      image_size = button.imageView.frame.size
      title_size = button.titleLabel.frame.size
      button.setImageEdgeInsets([0,PADDING + button.imageView.frame.size.width/2,50,PADDING + button.imageView.frame.size.width/2])
      button.setTitleEdgeInsets([PADDING*2,-1*(button.imageView.frame.size.width),0,0])
      button.when(UIControlEventTouchUpInside) do
        self.navigationController.pushViewController(square[:controller], animated: true)
      end
      self.view.addSubview(button)
      col >= 2 ? (col = 0; row += 1) : col += 1
    end
  end

  def profile_push
    if current_user
      self.navigationController.pushViewController(profile_controller, animated: true)
    else
      self.presentModalViewController(login_controller, animated:true)

    end
  end
end
