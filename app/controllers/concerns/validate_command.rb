module ValidateCommand
  def verify_command!(regex, command)
    valid_command = regex.match?(command)

    raise "Invalid command" unless valid_command
  end
end
