class Api::V1::ItemsController < ApplicationController
  include ValidateCommand

  def cat
    validate_cat_command!
    file = Files::FindByPathService.new(path: parse_path).call

    render json: file
  end

  private

  def parse_path
    _prefix, path, *extra_arguments = params[:cmd].split
    raise "Invalid command" if extra_arguments.any?

    path
  end

  def validate_cat_command!
    regex_create = /\Acat /

    verify_command!(regex_create, params[:cmd])
  end
end
