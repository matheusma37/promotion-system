class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      redirect_to @promotion
    else
      render 'new'
    end
  end

  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update(promotion_params)
      redirect_to @promotion
    else
      render 'edit'
    end
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    if @promotion.destroy
      flash[:notice] = 'Promoção deletada com sucesso'
    else
      flash[:alert] = 'Não foi possível deletar essa promoção'
    end

    redirect_to promotions_path
  end

  def generate_coupons
    promotion = Promotion.find(params[:id])
    1.upto(promotion.coupon_quantity) do |code|
      Coupon.create!(
        code: "#{promotion.code}-#{format('%04d', code)}",
        promotion: promotion
      )
    end
    flash[:notice] = 'Cupons gerados com sucesso'
    redirect_to promotion
  end

  private

  def promotion_params
    params.require(:promotion).permit(:name, :description, :code,
                                      :discount_rate, :coupon_quantity,
                                      :expiration_date)
  end
end
