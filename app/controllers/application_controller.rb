class ApplicationController < ActionController::API
    include JsonWebToken

    before_action :authenticate_request

    private 
        def authenticate_request
            begin
                header = request.headers["Authorization"]
                header = header.split(" ").last if header
                decoded = jwt_decode(header)
                @current_user = User.find(decoded[:user_id])
                rescue ActiveRecord::RecordNotFound => e
                    render json: { errors: "unauthorized"}, status: :unauthorized
            rescue
                render json: { errors: "unauthorized"}, status: :unauthorized
            end
        end

        def librarian_permission
            if UserType.find_by_type_name("Librarian").id != @current_user.user_type_id
                render json: { errors: "Forbidden"}, status: :unauthorized
            end
        end
end
