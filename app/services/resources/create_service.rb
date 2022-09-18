class Resources::CreateService
  def initialize(params)
    @command = params[:cmd]
    @arguments = parse_command
  end

  def call
    return create_folder if has_one_argument?
    return handle_two_arguments if has_two_arguments?
    return create_file_without_parent if has_three_arguments? && without_parent?

    raise "Invalid command!"
  end

  private

  attr_accessor :command, :arguments

  def has_one_argument?
    arguments.size == 1
  end

  def has_two_arguments?
    arguments.size == 2
  end

  def has_three_arguments?
    arguments.size == 3
  end

  def create_folder
    path = arguments[0]

    Folders::CreateService.new(path: path).call
  end

  def create_folder_without_parent
    _, path = arguments

    Folders::CreateService.new(path: path, without_parent: true).call
  end

  def create_file
    path, data = arguments

    Files::CreateService.new(path: path, data: data).call
  end

  def create_file_without_parent
    _, path, data = arguments

    Files::CreateService.new(path: path, data: data, without_parent: true).call
  end

  def handle_two_arguments
    return create_folder_without_parent if without_parent?

    create_file
  end

  def without_parent?
    arguments[0] == WITHOUT_PARENT_ARGUMENT
  end

  def parse_command
    _prefix, *arguments = command.split

    arguments
  end
end
