class StoreController < ApplicationController
  def index
  	@products = Product.order(:title)
  	@page_title = "Store Bookshelf"
  end
end
