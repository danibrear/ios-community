class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    nav_controller = UINavigationController.alloc.initWithRootViewController(main_view_controller)
    @window.rootViewController = UITabBarController.alloc.init
    @window.rootViewController.viewControllers = [nav_controller, groups_view_controller, messages_view_controller]
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def messages_view_controller
    @messages_view_controller ||= MessagesViewController.alloc.init
  end

  def main_view_controller
    @main_view_controller ||= MainViewController.alloc.init
  end

  def groups_view_controller
    @groups_view_controller ||= GroupsViewController.alloc.init
  end
end
