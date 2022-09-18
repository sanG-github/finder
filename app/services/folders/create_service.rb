class Folders::CreateService < BaseService
  include PathHelper

  def initialize(path:, name: nil, without_parent: false)
    @path = path
    @name = name
    @without_parent = without_parent
  end

  def call
    Folder.with_session do
      check_valid_path
      @path, @name = separate_path_and_name if name.blank?
      check_existed_file

      create_folder_without_parent! if without_parent

      Folder.create!(path: path, name: name)
    end
  end

  private

  attr_reader :path, :name, :without_parent

  def check_existed_file
    file = Item.find_by_path_name(path, name)

    raise "Conflict with existed file!" if file
  end
end
