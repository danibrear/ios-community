class ApplicationController < UIViewController
  include ApplicationHelper
  include RoutesHelper

  PADDING = 10

  X_LARGE_FONT = 20
  LARGE_FONT = 16
  NORMAL_FONT = 14
  SMALL_FONT = 12

  def loadView
    super
    self.setModalPresentationStyle(UIModalPresentationPageSheet)
    self.setModalTransitionStyle(UIModalTransitionStyleCoverVertical)
  end

  def current_user_headers
    headers = {}
    if current_user
      headers = {"spiceworks-communty"=> current_user.session}
    end
    headers
  end

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    self.navigationController.navigationBar.tintColor = "#fe5200".to_color;
  end

  def format_date(string)
    puts string
    date_formatter = NSDateFormatter.alloc.init
    date_formatter.setDateFormat("yyyy-MM-dd'T'HH:mm:ss'+00:00'")
    date = date_formatter.dateFromString string
    date_formatter.setDateFormat("MMM dd yy HH:mm")

    date_formatter.stringFromDate(date)
  end

  def profile_controller
    @profile_controller ||= ProfileController.alloc.init
  end

  def messages_index_controller
    @messages_index_controller ||= MessagesIndexController.alloc.init
  end

  def login_controller
    @login_controller ||= create_login_controller
  end

  def channel_controller
    @channel_controller ||= ChannelController.alloc.init
  end

  def remove_crap(str)
    str.gsub(/(\n|\t)/, " ")
  end

  def remove_html(str)
    str.gsub(/<.+>/, "").gsub("&#39;", "'").gsub("&nbsp;", " ")
  end

  private

  def create_login_controller
    l = LoginViewController.alloc.initWithNibName(nil, bundle:nil)
    unc = UINavigationController.alloc.initWithRootViewController(l)
    unc.navigationBar.tintColor = "#fe5200".to_color
    unc
  end

end
