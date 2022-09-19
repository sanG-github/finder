module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_exception
    rescue_from Mongoid::Errors::DocumentNotFound, with: :handle_record_not_found
    rescue_from Mongoid::Errors::Validations, with: :handle_standard_exception

    def handle_record_not_found
      render json: {
        success: false,
        message: "Folder/File not found!"
      }, status: 404
    end

    def handle_standard_exception(error)
      render json: {
        success: false,
        message: error.message
      }, status: :unprocessable_entity
    end
  end
end
