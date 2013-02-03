class AppDelegate

  include ApplicationHelper
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    navigation_controller = UINavigationController.alloc.initWithRootViewController(main_view_controller)
    #if current_user
       @window.rootViewController = navigation_controller
    #else
    #  @window.rootViewController = UINavigationController.alloc.initWithRootViewController(login_view_controller)
    #end


    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def main_view_controller
    @main_view_controller ||= MainViewController.alloc.init
  end
end
