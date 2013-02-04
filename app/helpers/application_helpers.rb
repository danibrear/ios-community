module ApplicationHelper
  def current_user
    User.find
  end
end
