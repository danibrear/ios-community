class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    if current_user
      @window.rootViewController = UINavigationController.alloc.initWithRootViewController(main_view_controller)
    else
      @window.rootViewController = UINavigationController.alloc.initWithRootViewController(login_view_controller)
    end
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def login_view_controller
    @login_view_controller ||= LoginViewController.alloc.init
  end

  def main_view_controller
    @main_view_controller ||= MainViewController.alloc.init
  end
end
