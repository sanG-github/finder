class Resources::FindService
  include PathHelper

  def initialize(path:, name:)
    @path = path
    @name = name
  end

  def call
    return unless path && name

    sub_folders = Folder.where(path: /#{path}.*\z/)

    valid_folders = sub_folders.where(name: /.*#{name}.*/)
    valid_files = Item.where(:folder_id.in => sub_folders.pluck(:id), name: /.*#{name}.*/)

    {
      sub_folders: valid_folders,
      files: valid_files
    }
  end

  private

  attr_accessor :path, :name
end
