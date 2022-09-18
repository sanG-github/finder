class Resources::MoveService
  include PathHelper

  def initialize(path:, destination_path:)
    @path = path
    @destination_path = destination_path
  end

  def call
    validate_paths

    folder_path, name = separate_path_and_name

    check_sub_path(folder_path, destination_path)
    check_valid_destination

    @resource = get_resource(folder_path, name)
    raise "Provided file/folder does not exist!" unless resource

    move_file! if resource.is_a?(Item)
    move_folder! if resource.is_a?(Folder)
  end

  private

  attr_reader :path, :destination_path, :resource

  def destination_folder
    @destination_folder ||= Folder.find_by_path(destination_path)
  end

  def get_resource(folder_path, name)
    Item.find_by_path_name(folder_path, name) || Folder.find_by_path(path)
  end

  def move_file!
    resource.update!(folder_id: destination_folder.id)
  end

  def move_folder!
    Folder.with_session do
      resource.update!(path: destination_path)
    end
  end

  def validate_paths
    raise "Invalid path" unless /\A(\/[a-zA-Z0-9 _-]+)+\z/.match?(path)
    raise "Invalid destination path" unless /\A(\/[a-zA-Z0-9 _-]+)+\z/.match?(destination_path)
  end

  def check_valid_destination
    raise "The destination path is not existed" unless destination_folder
  end
end
