class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_time_zone
  before_action :set_and_authorize_budget, except: [:index, :new, :create]

  def index
    respond_to do |f|
      f.html
      f.json { render :json => { active: current_user.budgets.active, inactive: current_user.budgets.inactive,  completed: current_user.budgets.completed } }
    end
  end

  def new
    @budget = current_user.budgets.build
    render layout: false
  end

  def create
    @budget = current_user.budgets.build(budget_params)
    @budget.save ? (render :show, layout: false, status: 201) : (render :new, layout: false, status: 422)
  end

  def show
    render layout: false
  end

  def edit
    render layout: false
  end

  def update
    @budget.update(budget_params) ? (render :show, layout: false) : (render :edit, layout: false, status: 422)
  end

  def destroy
    @budget.destroy
    redirect_to user_budgets_path
  end

  private

  def set_and_authorize_budget
    @budget = Budget.find(params[:id])
    authorize @budget
  end

  def budget_params
    params.require(:budget).permit(:name, :start_date, :end_date, :limit, :categories_attributes => [:title])
  end

  # Ensure that users are not able to interact with budgets until they have timezones in order to avoid issues with dates.

  def require_time_zone
    redirect_to edit_user_time_zone_path, :alert => "Please set your timezone." unless current_user.time_zone
  end

end
