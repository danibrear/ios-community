class ProfileController < ApplicationController
  def viewDidLoad
    super
    self.title = "#{current_user.name}'s Profile"
    home_image = UIImage.imageNamed "home_white.png"
    #space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(home_image, style:UIBarButtonItemStyleBordered, target:self, action:'home_pressed')

    add_log_out_button if current_user
  end

  def add_log_out_button

    @logout_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @logout_button.setTitle("Logout", forState:UIControlStateNormal)
    @logout_button.setTitle("Logging out...", forState:UIControlStateDisabled)
    @logout_button.sizeToFit
    @logout_button.frame = [[0,0],[self.view.frame.size.width-PADDING*2, 40]]
    @logout_button.center = [self.view.center.x, @logout_button.frame.size.height]
    gradient = create_gradient
    gradient.frame = [[0,0], [@logout_button.frame.size.width, @logout_button.frame.size.height]]
    @logout_button.layer.insertSublayer(gradient, atIndex:1)
    @logout_button.titleLabel.shadowColor = UIColor.darkGrayColor
    @logout_button.titleLabel.font = UIFont.boldSystemFontOfSize(20)
    @logout_button.setTitleColor("#FFFFFF".to_color, forState:UIControlStateNormal)
    @logout_button.titleLabel.shadowColor = UIColor.blackColor;
    @logout_button.titleLabel.shadowOffset = CGSizeMake(-1.0, -1.0);
    @logout_button.addTarget(self, action:"logout_pressed", forControlEvents:UIControlEventTouchUpInside)

    self.view.addSubview(@logout_button)

  end

  def create_gradient
    gradient = CAGradientLayer.layer
    gradient.cornerRadius = 5
    gradient.colors = ['#ee5f5b'.to_color.CGColor, "#bd362f".to_color.CGColor]
    gradient
  end

  def logout_pressed
    user = User.find
    user.destroy
    self.navigationController.viewControllers.first.reset_view
    self.navigationController.popToRootViewControllerAnimated(true)
  end

  def home_pressed
    self.navigationController.popToRootViewControllerAnimated(true)
  end
end
