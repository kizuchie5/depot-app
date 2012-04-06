class StoreController < ApplicationController
  def index
    @products = Product.all
    @time = Time.now
  end
end
