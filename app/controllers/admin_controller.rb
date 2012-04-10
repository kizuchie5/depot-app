class AdminController < ApplicationController
  def index
    @total_orders = Order.count
    @time = Time.now
  end
end
