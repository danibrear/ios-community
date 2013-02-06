class ApplicationController < UIViewController
  include ApplicationHelper
  include RoutesHelper

  PADDING = 10

  def loadView
    super
    self.setModalPresentationStyle(UIModalPresentationPageSheet)
    self.setModalTransitionStyle(UIModalTransitionStyleCoverVertical)
  end

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    self.navigationController.navigationBar.tintColor = "#fe5200".to_color;
  end

  def profile_controller
    @profile_controller ||= ProfileController.alloc.init
  end

  def messages_controller
    @messages_controller ||= MessagesController.alloc.init
  end

  def login_controller
    @login_controller ||= create_login_controller
  end

  def channel_controller
    @channel_controller ||= ChannelController.alloc.init
  end

  def remove_crap(str)
    str.gsub(/(\n|\t)+/, " ").gsub(/<\.+>/, " ")
  end

  private

  def create_login_controller
    l = LoginViewController.alloc.initWithNibName(nil, bundle:nil)
    unc = UINavigationController.alloc.initWithRootViewController(l)
    unc.navigationBar.tintColor = "#fe5200".to_color
    unc
  end

end
