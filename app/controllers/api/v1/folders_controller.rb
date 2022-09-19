class Api::V1::FoldersController < ApplicationController
  include ValidateCommand

  def ls
    validate_ls_command!
    folder = Folder.find_by_path!(parse_path)

    render json: folder, serializer: ::FolderSerializer
  end

  private

  def parse_path
    _prefix, path, *extra_arguments = params[:cmd].split
    raise "Invalid command" if extra_arguments.any? || !path

    path
  end

  def validate_ls_command!
    regex_create = /\Als /

    verify_command!(regex_create, params[:cmd])
  end
end
