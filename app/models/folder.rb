class Folder
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :path, type: String
end
