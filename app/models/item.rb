class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :data, type: String
  belongs_to :folder
end
