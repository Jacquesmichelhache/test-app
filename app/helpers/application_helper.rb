module ApplicationHelper


  def success(message_in = "", value_in = {})
    return {status:"success",data:{value:value_in,message: message_in}}
  end
  
  def fail(message_in, value_in = {})
    return {status:"error", data:{value: value_in, message:message_in}}
  end

end

