class ApplicationController < ActionController::API
    include JsonWebToken

    before_action :authenticate_request


    private 
        # Method that decodes token and cheks if user is authorized
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
        # Permission method that cheks if user ia a librarian
        def librarian_permission
            if UserType.find_by_type_name("Librarian").id != @current_user.user_type_id
                render json: { errors: "Forbidden"}, status: :unauthorized
            end
        end
end
