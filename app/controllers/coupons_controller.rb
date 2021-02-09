class CouponsController < ApplicationController
  def inactivate
    coupon = Coupon.find(params[:id])
    coupon.inactive! if coupon.active?
    redirect_to coupon.promotion
  end
end