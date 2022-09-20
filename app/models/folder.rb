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
  after_update :move_related_resources, if: proc { |folder| folder.path_previously_changed? }
  after_update :update_related_resources, if: proc { |folder| folder.name_previously_changed? }
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

  def size
    files_size = items.reduce(0) { |sum, file| sum + file.data&.size }

    sub_folders_size = sub_folders&.reduce(0) do |sum, folder|
      sum + folder.size
    end

    files_size + sub_folders_size
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

  def move_related_resources
    previous_path = self.path_previously_was
    previous_path = previous_path + (path == SEPARATOR ? "" : SEPARATOR) + name
    new_path = self.path

    Folder.where(path: previous_path).each { |folder| folder.update(path: new_path) }
  end

  def update_related_resources
    previous_name = self.name_previously_was
    previous_path = path + (path == SEPARATOR ? "" : SEPARATOR) + previous_name

    Folder.where(path: previous_path).each { |folder| folder.update(path: self.current_path) }
  end
end
