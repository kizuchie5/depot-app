class ApplicationController < ActionController::Base
  #before_filter :authorize
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

  protected

    def authorize
      unless User.find_by_id(session[:user.id])
        redirect_to login_url, :notice => "Please log in"
      end
    end
end
