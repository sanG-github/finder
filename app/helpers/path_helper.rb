module PathHelper
  def separate_path_and_name
    *base_path, name = path.split(SEPARATOR)
    base_path = base_path.join(SEPARATOR)

    [base_path.presence || SEPARATOR, name]
  end

  def check_valid_path
    raise "Invalid path, path must start with /" if path[0] != '/'
    raise "Invalid path" unless /\A(\/[a-zA-Z0-9 _-]+)+\z/.match?(path)
  end

  def check_sub_path(path, destination_path)
    raise "Cannot move to sub folder itself" if destination_path.start_with?(path) && path != SEPARATOR
  end
end
