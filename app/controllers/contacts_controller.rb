class ContactsController < ApplicationController
  include ApplicationHelper  
  respond_to :json
  before_action :authenticate_user!

  
  def index
    resources = current_user.customers.find(params[:customer_id]).contacts.all

    puts resources

    value = ContactSerializer.new(resources).serializable_hash[:data].map{|data| data[:attributes]}

    render json: success( "Success at retreving contacts!", value) 
   
  end

   #POST
   def create 
  
    begin   
      p = contact_params   
      new_contact = current_user.customers.find(params[:customer_id]).contacts.build(p)

      if new_contact.valid? then
        new_contact.save
        render json: success( "Successfully created a contact", nil)      
      else    
        render json: fail("Error creating contact",new_contact.errors)  
      end 

    rescue Exception => e 
      render json: fail(e.message)  
    end 
  end



   #GET
   def show    

    begin
    
      resource = current_user.customers.find(params[:customer_id]).contacts.find(params[:contact_id])

      contactJson = ContactSerializer.new(resource).serializable_hash
    
      render json: success("successfully retrieved contact information", contactJson)

    rescue Exception => e
       render json: fail("Error retrieving contact information",e.message) 
    end
       
  end

  def update     


    begin
      p = contact_params
      contact = current_user.customers.find(params[:customer_id]).contacts.find(params[:contact_id])

      if contact.update(p) then
        render json: success("Successfully updated contact", contact)            
      else
        render json: fail("Unable to save changes", contact.errors )       
      end

    rescue Exception => e
      render json: fail("Error retrieving contact information",e.message) 
    end

  end


   #DELETE
   def destroy  
    
    begin  
      current_user.customers.find(params[:customer_id]).contacts.find(params[:contact_id]).destroy  
      render json: success("Contact successfully removed",nil)  
    rescue ActiveRecord::RecordNotFound
      render json: fail("Contact not found in database")       
    rescue ActiveRecord::DeleteRestrictionError 
      #An assumption is made here that the Contact has contacts
      render json: fail("Cannot remove a Contact with contacts")      
    rescue ActiveRecord::RecordNotDestroyed
      render json: fail("Cannot delete a Contact that has contacts!")
    rescue
      render json: fail("Unable to delete Contact. Contact administrator")     
    end

  end

  private
    def contact_params
      params.require(:contact).permit(:name, :firstname, :email,
        :tel, :ext)
    end

end
