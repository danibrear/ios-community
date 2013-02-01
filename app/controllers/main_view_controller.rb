class MainViewController < UIViewController

  padding = 10

  def viewDidLoad
    self.title = "Spiceworks"
    profile_image = UIImage.imageNamed "user.png"
    self.navigationItem.titleView = UIBarButtonItem.alloc.initWithImage(profile_image, style:UIBarButtonItemStyleBordered, target:self, action: 'profile_push')
  end

  def profile_push
    self.view.backgroundColor = UIColor.whiteColor
  end
end
