class Resources::DeleteService
  def initialize(params: )
    @command = params[:cmd]
    @paths = parse_command
  end

  def call
    validate_all_paths

    paths.each do |path|
      Folders::DeleteService.new(path: path).call
      Files::DeleteService.new(path: path).call
    end
  end

  private

  attr_reader :command, :paths

  def validate_all_paths
    paths.each do |path|
      raise "Invalid path" unless /\A(\/[a-zA-Z0-9 _-]+)+\z/.match?(path)
    end
  end

  def parse_command
    _prefix, *paths = command.split

    paths
  end
end
