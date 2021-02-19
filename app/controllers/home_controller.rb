class HomeController < ApplicationController
  def index; end

  def search
    @promotions = Promotion.where('LOWER(name) like ? OR LOWER(code) like ?',
                                  "%#{params[:q].downcase}%", "%#{params[:q].downcase}%")
    @qpromotion = params[:q] if @promotions.empty?
  end
end
