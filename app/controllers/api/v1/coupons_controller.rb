module Api
  module V1
    class CouponsController < ApiController
      def show
        coupon = Coupon.find_by_code(params[:id])

        return render status: :not_found, json: { msg: 'coupon not found' } if coupon.nil?

        render json: coupon.as_json(
          only: %i[code status],
          include: {
            promotion: {
              only: %i[discount_rate expiration_date]
            }
          }
        ), status: :ok
      end
    end
  end
end
