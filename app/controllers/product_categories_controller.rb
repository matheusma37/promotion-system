class ProductCategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @product_categories = ProductCategory.all
  end

  def show
    @product_category = ProductCategory.find(params[:id])
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)
    if @product_category.save
      flash[:notice] = 'Categoria criada com sucesso'
      redirect_to @product_category
    else
      flash[:alert] = 'Não foi possível criar a categoria'
      render 'new'
    end
  end

  def edit
    @product_category = ProductCategory.find(params[:id])
  end

  def update
    @product_category = ProductCategory.find(params[:id])
      if @product_category.update(product_category_params)
        flash[:notice] = 'Categoria atualizada com sucesso'
        redirect_to @product_category
      else
        flash[:alert] = 'Não foi possível atualizar a categoria'
        render 'edit'
      end
  end

  private

  def product_category_params
    params.require(:product_category).permit(:name, :code)
  end
end
