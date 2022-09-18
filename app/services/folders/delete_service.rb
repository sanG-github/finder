class Folders::DeleteService
  include PathHelper

  def initialize(path:, name: nil)
    @path = path
    @name = name
  end

  def call
    check_valid_path

    folder = name.blank? ? Folder.find_by_path(path) : Folder.find_by(path: path, name: name)

    folder&.destroy
  end

  private

  attr_reader :path, :name, :without_parent
end
