require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  # A user goes to the index page. They select a product, adding it to their
  # cart, and check out, filling in their details on the checkout form. When
  # they submit, an order is created containing their information, along with a
  # single line item corresponding to the product they added to their cart.

 test "buying a product" do
  LineItem.delete_all
  Order.delete_all
  ruby_book = products(:ruby)

  #goes to store index page

  get "/"
  assert_response :success
  assert_template "index"

  #selects a product and add it to cart

  xml_http_request :post, '/line_items', :product_id => ruby_book.id
  assert_response :success

  cart = Cart.find(session[:cart_id])
  assert_equal 1, cart.line_items.size
  assert_equal ruby_book, cart.line_items[0].product

  # will then check out

  get "/orders/new"
  assert_response :success
  assert_template "new"

  # fills in details on check out form, posts data..
  # (app will create the order and redirect to index page)

  #ship_date_expected = Time.now.to_date
  post_via_redirect "/orders",
                    :order => { :name     => "Ruby on Rails",
                                :address  => "Ubuntu City",
                                :email    => "depot@app.com",
                                :pay_type => "Check" }
  assert_response :success
  assert_template "index"
  cart = Cart.find(session[:cart_id])
  assert_equal 0, cart.line_items.size
  #assert_equal ship_date_expected, order.ship_date.to_date


  # end of user's purchase

  # check database if it contains the new order

  orders = Order.all
  assert_equal 1, orders.size
  order = orders[0]

  assert_equal "Ruby on Rails",  order.name
  assert_equal "Ubuntu City",    order.address
  assert_equal "depot@app.com",  order.email
  assert_equal "Check",          order.pay_type

  assert_equal 1, order.line_items.size
  line_item = order.line_items[0]
  assert_equal ruby_book, line_item.product

  # verify that the mail is correctly addressed and has expected subject line

  mail = ActionMailer::Base.deliveries.last
  assert_equal ["depot@app.com"], mail.to
  assert_equal "Kizuchie Kim <depot@junsuheart.com>", mail[:from].value
  assert_equal "Pragmatic Store Order Confirmation", mail.subject
 end

  test "should mail the admin when error occurs" do
    get "/carts/wibble"
    assert_response :redirect  # should redirect to...
    assert_template "/"        # store index

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["xiahjunsu.kiuch@gmail.com"], mail.to
    assert_equal "Kizuchie Kim <depot@junsuheart.com>", mail[:from].value
    assert_equal "An error occurred!", mail.subject
  end

end
