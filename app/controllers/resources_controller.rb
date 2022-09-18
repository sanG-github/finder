class ResourcesController < ApplicationController
  extend ValidateCommand

  def create
    validate_create_command!
    result = Resources::CreateService.new(params: params).call

    render json: result
  end

  def destroy
    validate_delete_command!
    result = Resources::DeleteService.new(params: params).call

    render json: result
  end

  private

  def validate_create_command!
    regex_create = /\Acr /

    verify_command!(regex_create, params[:cmd])
  end

  def validate_delete_command!
    regex_create = /\Arm /

    verify_command!(regex_create, params[:cmd])
  end
end
