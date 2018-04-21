class StaticController < ApplicationController

  def home
    user_signed_in? ? (redirect_to user_budgets_path) : (redirect_to new_user_session_path)
  end

end
