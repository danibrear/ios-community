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

    @logout_button = UIButton.buttonWithType(UIButtonTypeCustom)
    @logout_button.setTitle("Logout", forState:UIControlStateNormal)
    @logout_button.setTitle("Logging out...", forState:UIControlStateDisabled)
    @logout_button.sizeToFit
    @logout_button.frame = [[0,0],[self.view.frame.size.width-PADDING*2, 40]]
    @logout_button.center = [self.view.center.x, @logout_button.frame.size.height]
    @logout_button.setBackgroundImage(UIImage.imageNamed("iphone_delete_button.png", stretchableImageWithLeftCapWidth: 12.0, topCapHeight: 0), forState: UIControlStateNormal)
    @logout_button.titleLabel.shadowColor = UIColor.darkGrayColor
    @logout_button.titleLabel.font = UIFont.boldSystemFontOfSize(20)
    @logout_button.addTarget(self, action:"logout_pressed", forControlEvents:UIControlEventTouchUpInside)

    self.view.addSubview(@logout_button)

  end

  def logout_pressed
    user = User.find
    user.destroy
  end

  def home_pressed
    self.navigationController.popToRootViewControllerAnimated(true)
  end
end
