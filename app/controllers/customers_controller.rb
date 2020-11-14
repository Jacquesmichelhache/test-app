class CustomersController < ApplicationController
  include ApplicationHelper  
  respond_to :json
  before_action :authenticate_user!


  def index
    resources = current_user.customers.all    

    render json: {
      status: {code: 200, message: 'Success at retreving customers!'},
      data: CustomerSerializer.new(resources).serializable_hash[:data].map{|data| data[:attributes]}
    }
  end

  def new
   
  end

  def activity_types
    activityTypes = Customer.activitytypes
    render json: success( "Successfully retrieved activity types", activityTypes) 
  end

  #POST
  def create
    #returns a success message
    new_customer = nil
    p = customer_params

    #validate the model before commiting the changes
    begin
      p[:relationshipstart] = DateTime.strptime(p[:relationshipstart], "%m/%d/%Y")  
    rescue
      
    end  

    begin
      new_customer = current_user.customers.build(p)

      if new_customer.valid? then
        new_customer.save
        render json: success( "Successfully created a customer", nil)      
      else    
        render json: fail("Error creating customer",new_customer.errors)  
      end 

    rescue Exception => e 
      render json: fail(e.message)  
    end 
  end

  #GET
  def edit
       
  end


  def update

  end


  def destroy

  end


  private
  def customer_params
    params.require(:customer).permit(:name, :relationshipstart, :addresscity,
      :addresspostalcode, :addressstreet, :addressapt, :activitytype,
    :infoemail)
  end  


end
