class LoansController < ApplicationController
    before_action :librarian_permission, only: [:show, :destroy, :update, :create]
    before_action :set_loan, only: [:show, :destroy]

    # GET /loans
    def index
        begin
            if @current_user.member?
                @loans = Loan.all.where(user_id: @current_user.id).paginate(page: params[:page], per_page: params[:page_size])
            else
                @loans = Loan.all.paginate(page: params[:page], per_page: params[:page_size])
            end
            render json: @loans,include: '*',  status: :ok
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # GET /loans/{id}
    def show
        render json: @loan, include: '*', status: :ok
    end

    # POST /loans
    def create
        Loan.transaction do
            begin
                loan_data = loan_params
                loan_data["user_id"] = params[:data][:relationships][:user][:data][:id]
                loan_data["book_id"] = params[:data][:relationships][:book][:data][:id]

                #Make new Loan and lock the table to prevent rental of the same book
                loan = Loan.lock.new(user_id: loan_data[:user_id], book_id: loan_data[:book_id])
                book = loan.book
                member = loan.user
                #Check if the user is a member
                if member.member?
                    #Check if a maximum is reached
                    if member.max_number_of_loans?
                        render json: { error: 'The user has reached the maximum book borrowing limit.' }, status: :unprocessable_entity             
                    else
                        #Check if the book is out of stock
                        if !book.out_of_stock?
                            if loan.save!
                                render json: loan, status: :created
                            else
                                render json: loan.errors, status: :unprocessable_entity
                            end
                        else
                            render json: { error: 'Not enough books available' }, status: :unprocessable_entity
                        end
                    end
                else
                    render json: { error: 'User is not a member' }, status: :unprocessable_entity
                end
            rescue => e
                logger.error "#{e.message}"
                render json: { errors: 'Server error' }, status: :internal_server_error
            end
            
        end
    end

    # PUT /loan/{:id}

    def update
        Loan.transaction do
            begin
                loan_data = loan_params
                loan_data["user_id"] = params[:data][:relationships][:user][:data][:id]
                loan_data["book_id"] = params[:data][:relationships][:book][:data][:id]

                #Make update in Loan and lock the table to prevent rental of the same book

                loan = Loan.lock.find(params[:id])

                #Chek if book is changed
                if loan.book_id != loan_data[:book_id].to_i
                    book = Book.find(loan_data[:book_id])
                    if book.out_of_stock?
                        render json: { error: 'Not enough books available' }, status: :unprocessable_entity
                    end
                end
                
                #Check if user is changed
                if loan.user_id != loan_data[:user_id].to_i
                    user = User.find(loan_data[:user_id])
                    if !user.member?
                        render json: { error: 'User is not a member' }, status: :unprocessable_entity
                    end
                    if user.max_number_of_loans?
                        render json: { error: 'The user has reached the maximum book borrowing limit.' }, status: :unprocessable_entity    
                    end
                end

                unless loan.update!(loan_data)
                    render json: { errors: @loan.errors.full_messages},
                        status: :unprocessable_entity
                end
            rescue ActiveRecord::RecordNotFound
                logger.error "#{e.message}"
                render json: {errors: "Record not found"}, status: :not_found
            rescue => e
                logger.error "#{e.message}"
                render json: { errors: 'Server error' }, status: :internal_server_error
            end
        end     
        
          
    end

    # DELETE /loans/{:id}
    def destroy
        begin
            @loan.destroy
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    private
        def loan_params
            params.require(:data).require(:attributes).permit(:book_id, :user_id, :is_returned)
        end
        def set_loan
            begin
                @loan = Loan.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                logger.error "#{e.message}"
                render json: { errors: 'Loan not found' }, status: :not_found
            end
        end
end
