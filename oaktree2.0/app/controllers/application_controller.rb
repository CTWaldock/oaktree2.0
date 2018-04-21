class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception
  before_filter :set_user_time_zone

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_url, :alert => "You don't have access to that budget."
  end

  private

  # Users require a timezone in order for budgets to work properly.

  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user.try(:time_zone)
  end

end
