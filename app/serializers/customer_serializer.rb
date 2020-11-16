class CustomerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :relationshipstart, :activitytype, :infoemail, :id, :addresscity, :addresspostalcode,
  :addressstreet, :addressapt
end
