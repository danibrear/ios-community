class ApplicationHelper
  def current_user
    @current_user ||= User.find()
  end
end
