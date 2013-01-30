class MessagesViewController < UITableViewController

  def init
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Messages", image: UIImage.imageNamed("messages.png"), tag:3)
    self
  end
end
