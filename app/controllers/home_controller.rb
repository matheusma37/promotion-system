class HomeController < ApplicationController
  def index; end

  def search
    @promotions = Promotion.where('LOWER(name) like ? OR LOWER(code) like ?',
                                  "%#{params[:q].downcase}%", "%#{params[:q].downcase}%")
    @coupons = Coupon.where('LOWER(code) like ?', "%#{params[:q].downcase}%")
    @q = params[:q]
  end
end
