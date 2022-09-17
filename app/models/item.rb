class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :data, type: String

  belongs_to :folder

  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9 _-]+\z/ }
end
