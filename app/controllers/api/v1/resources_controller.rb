class Api::V1::ResourcesController < ApplicationController
  include ValidateCommand

  def cr
    validate_create_command!
    result = Resources::CreateService.new(params: params).call

    render json: result
  end

  def rm
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
