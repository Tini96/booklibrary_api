class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    before_action :set_user, only: [:show, :destroy, :update]
    before_action :librarian_permission, only: [:index]

    # GET /users
    def index
        @users = User.all
        render json: @users, include: '*', status: :ok
    end

    # GET /users/{username}
    def show
        render json: @user, include: '*', status: :ok
    end

    # POST /users
    def create
        user_data = user_params
        user_data["user_type_id"] = params[:data][:relationships]["user-type"][:data][:id]
        @user = User.new(user_data)
        if @user.save
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages },
            status: :unprocessable_entity
        end
    end

    # PUT /users/{username}
    def update
        user_data = user_params
        user_data["user_type_id"] = params[:data][:relationships]["user-type"][:data][:id]
        unless @user.update(user_data)
            render json: { errors: @user.errors.full_messages},
                status: :unprocessable_entity
        end
        
        render json: @user, status: :ok 
    end

    # DELETE /users/{username}
    def destroy
        @user.destroy
    end

    private
        def user_params
            params.require(:data).require(:attributes).permit(:name, :username, :email, :user_type_id, :password)
        end
        def set_user
            @user = @current_user
            if !@user
                render json: { errors: 'User not found' }, status: :not_found
            end
        end
end

