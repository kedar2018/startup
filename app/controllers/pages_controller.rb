class PagesController < ApplicationController

  def home
    @about_us = About.first
    @services = Service.all
  end

  def about
    @about_us = About.first
 render layout: "about" 
  end

  def services
    @services = Service.all
  end

  def team
  end

  def price
  end

  def contact
  end

  def blog
  end

  def detail
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
