module PathHelper
  def separate_path_and_name
    *base_path, name = path.split(SEPARATOR)
    base_path = base_path.join(SEPARATOR)

    [base_path.presence || SEPARATOR, name]
  end

  def check_valid_path!
    raise "Invalid path" unless /\A(\/[a-zA-Z0-9 _-]+)+\z/.match?(path)
  end
end
