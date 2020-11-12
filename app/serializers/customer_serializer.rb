class CustomerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :relationshipstart, :addresscity, :infoemail
end
