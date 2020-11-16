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
  def show    

    begin
    
      resource = current_user.customers.find(params[:id])  

      customerJson = CustomerSerializer.new(resource).serializable_hash
    
      render json: success("successfully retrieved customer information", customerJson)

    rescue Exception => e
       render json: fail("Error retrieving customer information",e.message) 
    end
       
  end


  def update     

    if current_user != nil then
      customer_info = customer_params
      customer = current_user.customers.find(params[:id]);

      if customer != nil then
        if customer.update(customer_info) then
          render json: success("Successfully updated customer", customer)            
        else
          render json: fail("Unable to save changes", customer.errors )       
        end
      else

      end      
    else
      render json: fail("Fatal internal error: current_user is nil")        
    end
  end

  #DELETE
  def destroy

    id = params[:id]   
    
    begin    
      current_user.customers.find(id).destroy     
      render json: success("Customer successfully removed",nil)  
    rescue ActiveRecord::RecordNotFound
      render json: fail("Customer not found in database")       
    rescue ActiveRecord::DeleteRestrictionError 
      #An assumption is made here that the customer has contacts
      render json: fail("Cannot remove a customer with contacts")      
    rescue ActiveRecord::RecordNotDestroyed
      render json: fail("Cannot delete a customer that has contacts!")
    rescue
      render json: fail("Unable to delete customer. Contact administrator")     
    end

  end


  private
    def customer_params
      params.require(:customer).permit(:name, :relationshipstart, :addresscity,
        :addresspostalcode, :addressstreet, :addressapt, :activitytype,
      :infoemail)
    end  

 


end
