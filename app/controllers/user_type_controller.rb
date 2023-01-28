class UserTypeController < ApplicationController
  skip_before_action :authenticate_request, only: [:index]
  def index
    @user_types = UserType.all
    render json: @user_types, status: :ok
  end
end