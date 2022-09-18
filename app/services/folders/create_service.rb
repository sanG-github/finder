class Folders::CreateService < BaseService
  include PathHelper

  def initialize(path:, name: nil, without_parent: false)
    @path = path
    @name = name
    @without_parent = without_parent
  end

  def call
    check_valid_path

    @path, @name = separate_path_and_name if name.blank?

    create_folder_without_parent! if without_parent

    Folder.create!(path: path, name: name)
  end

  private

  attr_reader :path, :name, :without_parent
end
