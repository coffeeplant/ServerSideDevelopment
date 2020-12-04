class CartController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    
    # build logic to pass the cart data to the view
    
    if session[:cart] then #if sessions/cart exists then
      
      # if does exist then all the items to be displayed on the cart index page are all the items in that cart
      @cart = session[:cart] # @cart is an instance variable
      
    else
      #if the cart doesn't exist then set the cart to be an empty object
      @cart = {}  #this is a JSON object
    end
  end
  
  
  def add
    # find the id of the product to be added to the cart when someone presses the button
    id = params[:id] #button will give the id in param, find the product
    
    #Find the cart to put the product in or make a new cart
    if session[:cart] then # if cart exists just use it
      cart = session[:cart] #make the cart then be an empty cart
    else
      
      session[:cart] = {} #if the cart does not exist at time of button pushing then make one
    cart = session[:cart]
    end
    
    #control the products in the cart
    
    if cart[id] then # see is the product in the cart
      cart[id] = cart[id] + 1 # if it is then increase quantity by one 
    else 
      cart[id] = 1 #if it is not in the cart then add one now
    end
    # send the user somewhere now that the item is added
    
    redirect_to :action => :index 
    
  end
  
  
  def clearcart
    
    session[:cart] = nil
     redirect_to :action => :index
    
  end
  
  def remove
    
    id = params[:id]
    cart = session[:cart]
    cart.delete id
    
    redirect_to :root
    
  end
  
  
  def decrease
    
    id = params[:id]
    cart = session[:cart]
    
    if cart[id] == 1 then 
      
      cart.delete id
      
    else 
    
    cart[id] = cart[id] -1
    
    end
  
    redirect_to :action => :index
  
  end
  
  def createOrder
      
    #Step 1 Find user information
    
    @user = User.find(current_user.id) #@user is instance variable,
    #uppercase indictaes the table to search/find in
    
    #Step 2 Make a new order and link that order with the current user
    
    @order = @user.orders.build(:order_date => DateTime.now, :status => 'Pending')
      #Pending is hard-coded, for project can put in selection from drop-down list, 
      # so any parameter can go here
      #DateTime is from server not browser/user
    @order.save
    
    #Step 3 - Save each order item from the cart into the orderitems table
    @cart = session[:cart] || {} #this gets the items from the users cart session
    #bit at end '|| {}' is ruby syntax to take all info from cart session
    
    @cart.each do | id, quantity | 
      
      item = Item.find_by_id(id)
      
    @orderitem = @order.orderitems.build(
      :item_id => item.id, 
      :title => item.title,
      :description => item.description, 
      :quantity => quantity,#this is not from the items table, it's made in the cart,
      :price => item.price )
    @orderitem.save
    
    end
    
    @orders = Order.all
    
    @orderitems = Orderitem.where(order_id: Order.last)
    #this is using limiting functionality but in Ruby, SQL ex in createOrder.html
    #this is runing twice, need to fix, SQL and Ruby statements doing same thing
    
  end  
  
  
  
  
  
end
