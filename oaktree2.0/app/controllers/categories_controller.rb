class CategoriesController < ApplicationController
  before_action :set_and_authorize_category

  def show
    render json: @category
  end

  def destroy
    @budget = @category.budget
    @category.destroy
    render 'budgets/show', layout: false
  end

  private

  def set_and_authorize_category
    @category = Category.find(params[:id])
    authorize @category
  end


end
