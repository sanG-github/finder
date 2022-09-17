class Folder
  include Mongoid::Document
  include Mongoid::Timestamps
  include PathHelper

  field :name, type: String
  field :path, type: String

  has_many :items, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: { scope: :path },
            format: { with: /\A[a-zA-Z0-9 _-]+\z/ }

  before_save :validate_present_path

  def current_path
    path + SEPARATOR + name
  end

  def sub_folders
    Folder.where(path: current_path)
  end

  private

  def validate_present_path
    if self.name.present?
      path, name = separate_path_and_name
    else
      path = self.path
      name = self.name
    end

    path == SEPARATOR && name.blank? || Folder.find_by!(name: name, path: path)
  end
end
