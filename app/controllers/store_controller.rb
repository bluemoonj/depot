class StoreController < ApplicationController
  def index
  	@products = Product.order(:title)
  	@page_title = "Store Bookshelf"
  	
  	@cart = current_cart
  	
  	# increase access counter
  	if session[:counter].nil?
  		session[:counter] = 1
  	else
  		session[:counter] += 1
  	end
  end
end
