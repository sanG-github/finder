class Api::V1::ResourcesController < ApplicationController
  include ValidateCommand

  def find
    validate_find_command!

    name, path = parse_find_command
    result = Resources::FindService.new(path: path, name: name).call

    render json: result
  end

  def cr
    validate_create_command!
    result = Resources::CreateService.new(params: params).call

    render json: {
      resource: result,
      message: "Created successfully!"
    }
  end

  def mv
    validate_move_command!

    path, destination_path = parse_move_command
    result = Resources::MoveService.new(path: path, destination_path: destination_path).call

    render json: {
      resource: result,
      message: "Moved successfully!"
    }
  end

  def up
    validate_update_command!

    result = Resources::UpdateService.new(params: params).call

    render json: {
      resource: result,
      message: "Updated successfully!"
    }
  end

  def rm
    validate_delete_command!
    result = Resources::DeleteService.new(params: params).call

    render json: {
      resource: result,
      message: "Removed successfully!"
    }
  end

  private

  def validate_find_command!
    regex_create = /\Afind /

    verify_command!(regex_create, params[:cmd])
  end

  def validate_create_command!
    regex_create = /\Acr /

    verify_command!(regex_create, params[:cmd])
  end

  def validate_move_command!
    regex_create = /\Amv /

    verify_command!(regex_create, params[:cmd])
  end

  def validate_update_command!
    regex_create = /\Aup /

    verify_command!(regex_create, params[:cmd])
  end

  def validate_delete_command!
    regex_create = /\Arm /

    verify_command!(regex_create, params[:cmd])
  end

  def parse_move_command
    _prefix, path, destination_path, *extra_arguments = params[:cmd].split

    raise "Invalid command" if extra_arguments.any? || path.blank? || destination_path.blank?

    [path, destination_path]
  end

  def parse_find_command
    _prefix, name, path, *extra_arguments = params[:cmd].split

    raise "Invalid command" if extra_arguments.any? || name.blank? || path.blank?

    [name, path]
  end
end
