class PagesController < ApplicationController

  def home
    @about_us = About.first
    @services = Service.all
  end

  def about
    @about_us = About.first
    render layout: "about" 
  end

  def download_resources
    @resources = Resource.all
  end



  def services
    @services = Service.all
  end

  def products
    @products = Product.all
  end

  def product_detail
    @product = Product.find_by_title(params[:id])
  end

  def team
  end

  def price
  end

  def contact
  end

  def blog
   @blogs = Blog.all
  end

  def detail
   @service = Service.find_by_title(params[:id])
    render layout: "about" 
  end

  def feature
  end

  def quote
     @services = Service.all
  end

  def service
  end

   def testimonials; end


end
