class StaticPagesController < ApplicationController
  def home
    
    
    
  end

  def help
  end

  def about
  end

  def contact
  end
  
  def adminsection
    @orders = Order.all
  end
  
  def paid
    @order = Order.last#should pass in parameter to get customer order
    @order.update_attribute(:status, "This has been paid")
  end
end
