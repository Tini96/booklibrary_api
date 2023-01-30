class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    before_action :set_user, only: [:show, :destroy, :update]
    before_action :librarian_permission, only: [:show, :destroy, :update, :index]

    # GET /users
    def index
        begin
            @users = User.all.paginate(page: params[:page], per_page: params[:page_size])
            render json: @users, include: '*', status: :ok
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # GET /users/{username}
    def show
        render json: @user, include: '*', status: :ok
    end

    # POST /users
    def create
        begin
            user_data = user_params
            user_data["user_type_id"] = params[:data][:relationships]["user-type"][:data][:id]
            @user = User.new(user_data)
            if @user.save
                render json: @user, status: :created
            else
                render json: { errors: @user.errors.full_messages },
                status: :unprocessable_entity
            end
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # PUT /users/{username}
    def update
        begin
            user_data = user_params
            user_data["user_type_id"] = params[:data][:relationships]["user-type"][:data][:id]
            unless @user.update(user_data)
                render json: { errors: @user.errors.full_messages},
                    status: :unprocessable_entity
            end
            
            render json: @user, status: :ok
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end 
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
            begin
                @user = User.find_by_username(params[:username])
                raise ActiveRecord::RecordNotFound, "User not found with username: #{params[:username]}" if !@user
            rescue ActiveRecord::RecordNotFound => e
                logger.error "#{e.message}"
                render json: { errors: e.message }, status: :not_found
            end
        end
end

