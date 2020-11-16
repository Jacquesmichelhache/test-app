class ContactsController < ApplicationController
  include ApplicationHelper  
  respond_to :json
  before_action :authenticate_user!

  
  def index
    resources = current_user.customers.all    

    render json: {
      status: {code: 200, message: 'Success at retreving contacts!'},
      data: ContactSerializer.new(resources).serializable_hash[:data].map{|data| data[:attributes]}
    }
  end




  private
    def contact_params
      params.require(:contact).permit(:name, :firstname, :email,
        :tel, :ext)
    end

end
