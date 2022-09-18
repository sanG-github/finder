class Files::DeleteService
  include PathHelper

  def initialize(path:, name: nil)
    @path = path
    @name = name
  end

  def call
    check_valid_path

    @path, @name = separate_path_and_name if name.blank?

    folder = Folder.find_by_path(path)
    file = Item.find_by(folder_id: folder&.id, name: name)

    file&.destroy
  end

  private

  attr_reader :path, :name
end
