class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :data, type: String

  belongs_to :folder

  validates :name,
            presence: true,
            format: { with: /\A[a-zA-Z0-9 _-]+\z/ },
            uniqueness: { scope: :folder_id }

  def self.find_by_path_name(path, name)
    folder = Folder.find_by_path(path)

    find_by(folder_id: folder&.id, name: name)
  end

  def self.find_by_path_name!(path, name)
    folder = Folder.find_by_path!(path)

    find_by!(folder_id: folder.id, name: name)
  end

  def current_path
    folder.current_path + SEPARATOR + name
  end
end
