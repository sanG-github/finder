class Files::CreateService < BaseService
  include PathHelper

  def initialize(path:, data:, without_parent: false)
    @path = path
    @data = data
    @without_parent = without_parent
  end

  def call
    Item.with_session do
      check_valid_path
      check_existed_folder

      @path, @name = separate_path_and_name

      create_folder_without_parent! if without_parent
      create_file!
    end
  end

  private

  attr_reader :path, :data, :without_parent, :name

  def check_existed_folder
    folder = Folder.find_by_path(path)

    raise "Conflict with existed folder!" if folder
  end

  def create_file!
    folder = Folder.find_by_path!(path)

    Item.create!(data: data, name: name, folder_id: folder.id)
  end
end
