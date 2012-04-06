class ApplicationController < ActionController::Base
  protect_from_forgery

  private
            #if cart_id is not found, creates cart and returns it
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
end
