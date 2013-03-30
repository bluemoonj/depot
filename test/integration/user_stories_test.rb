require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  fixtures :products
  
  LineItem.delete_all
  Order.delete_all
  ruby_book = products(:ruby)
  
  # visit index page
  get "/"
  assert_response :success
  assert_template 'index'
  
  # add a product to shopping cart with Ajax
  xml_http_request :post, '/line_items', product_id: ruby_book.id
  assert_response :success
  
  cart = Cart.find(session[:cart_id])
  assert_equal 1, cart.line_items.size
  assert_equal ruby_book, cart.line_items[0].product
  
  # checkout
  get "/orders/new"
  assert_response :success
  assert_template "new"
  
  # fill in shipping form and redirect
  post_via_redirect "/orders", order: { name: "Dave Thomas",
  										address: "123 The Street",
  										email: "dave@example.com",
  										pay_type: "Check" }
  										
  assert_response :success
  assert_template "index"
  cart = Cart.find(session[:cart_id])
  assert_equal 0, cart.line_items.size
  
  mail = ActionMailer::Base.deliveries.last
  assert_equal ["dave@example.com"], mail.to
  assert_equal 'Sam ruby <depot@example.com', mail[:from].value
  assert_equal "Pragmatic Store Order Confirmation", mail.subject
  
end
