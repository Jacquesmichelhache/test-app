class ContactSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :firstname, :email, :tel, :ext, :id
end
