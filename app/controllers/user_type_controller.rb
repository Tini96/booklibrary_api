class UserTypeController < ApplicationController
  skip_before_action :authenticate_request, only: [:index]
  def index
    begin
      @user_types = UserType.all
      render json: @user_types, status: :ok
    rescue => e
      logger.error "#{e.message}"
      render json: { errors: 'Server error' }, status: :internal_server_error
    end
  end
end