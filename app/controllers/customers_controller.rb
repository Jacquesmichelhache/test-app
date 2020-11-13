class CustomersController < ApplicationController
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

  def create

  end

  def edit

  end


  def update

  end


  def destroy

  end



end
