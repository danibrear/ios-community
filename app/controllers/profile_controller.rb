class ProfileController < ApplicationController
  def viewDidLoad
    super
    self.title = ""
    home_image = UIImage.imageNamed "home_white.png"
    #space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(home_image, style:UIBarButtonItemStyleBordered, target:self, action:'home_pressed')

    add_log_out_button if current_user
  end

  def add_log_out_button
    @logout_button = UIButton.buttonWithType(UIButton)
  end

  def home_pressed
    self.navigationController.popToRootViewControllerAnimated(true)
  end
end
