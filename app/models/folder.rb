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
  after_destroy :remove_sub_folders, :remove_files_inside

  def self.find_by_path(path)
    *file_path, file_name = path.split(SEPARATOR)
    file_path = file_path.join(SEPARATOR).presence || SEPARATOR

    find_by(path: file_path, name: file_name)
  end

  def self.find_by_path!(path)
    *file_path, file_name = path.split(SEPARATOR)
    file_path = file_path.join(SEPARATOR).presence || SEPARATOR

    find_by!(path: file_path, name: file_name)
  end

  def current_path
    path + (path == SEPARATOR ? "" : SEPARATOR) + name
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

  def remove_sub_folders
    self.sub_folders.destroy
  end

  def remove_files_inside
    self.items.destroy
  end
end
