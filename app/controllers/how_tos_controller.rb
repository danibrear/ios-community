class HowTosController < ApplicationController

  def viewDidLoad
    super
    self.title = "How Tos"
    home_image = UIImage.imageNamed "home_white.png"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage(home_image, style:UIBarButtonItemStyleBordered, target:self, action:'home_pressed')
  end
  def home_pressed
    self.navigationController.popToRootViewControllerAnimated(true)
  end
end
