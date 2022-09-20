class Resources::UpdateService
  include PathHelper

  def initialize(params:)
    @command = params[:cmd]
    @arguments = parse_command
  end

  def call
    return handle_update_file_content! if update_file_content?

    handle_update_name!
  end

  private

  attr_accessor :command, :arguments

  def update_file_content?
    arguments.size == 3
  end

  def get_resource(path)
    *folder_path, name = path.split(SEPARATOR)
    folder_path = folder_path.join(SEPARATOR).presence || SEPARATOR

    Item.find_by_path_name(folder_path, name) || Folder.find_by_path(path)
  end

  def handle_update_file_content!
    path, new_name, data = arguments
    file = get_resource(path)

    raise "Cannot find the file in determine PATH!" unless file && file.is_a?(Item)

    file.update!(data: data, name: new_name)
  end

  def handle_update_name!
    path, new_name = arguments
    resource = get_resource(path)

    raise "Resource not found!" unless resource

    resource.update!(name: new_name)
  end

  def parse_command
    cmd, file_content = command.split("'") if command.include?("'")
    cmd, file_content = command.split("\"") if command.include?("\"")

    _prefix, *arguments = cmd&.split || command&.split

    raise "Invalid command" if arguments.size != 2

    (arguments << file_content).compact
  end
end
