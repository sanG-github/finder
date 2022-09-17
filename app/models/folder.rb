class Folder
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :path, type: String

  has_many :items

  validates :path, presence: true
  validates :name,
            presence: true,
            uniqueness: { scope: :path },
            format: { with: /\A[a-zA-Z0-9 _-]+\z/ }
end
