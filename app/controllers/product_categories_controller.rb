class ProductCategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @product_categories = ProductCategory.all
  end

  def show
    @product_category = ProductCategory.find(params[:id])
  end
end
