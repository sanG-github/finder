class FolderSerializer < ActiveModel::Serializer
  attributes :current_path, :size, :created_at, :sub_folders

  has_many :items, key: :files

  def sub_folders
    object.sub_folders.map do |folder|
      {
        path: folder.path,
        name: folder.name,
        size: folder.size,
        created_at: folder.created_at
      }
    end
  end
end
