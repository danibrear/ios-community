class MainViewController < UITableViewController

  CELL_ID = "CELL_ID"

  def init
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Home", image:UIImage.imageNamed("home.png"), tag:1)
    self
  end

  def viewDidLoad

  end
end
