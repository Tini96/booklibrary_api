class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    # POST /auth/login
    def login
        begin
            @user = User.find_by_email(params[:email])
            if @user&.authenticate(params[:password])
                token = jwt_encode(user_id: @user.id)
                render json: {token: token}, status: :ok
            else
                render json: {error: 'unauthorized'}, status: :unauthorized
            end
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

end
