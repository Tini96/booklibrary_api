class BooksController < ApplicationController
    before_action :librarian_permission, only: [:show, :destroy, :update, :create, :out_of_stock]
    before_action :set_book, only: [:show, :destroy, :update]

    # GET/books
    def index
        begin
            if params[:term]
                # Using ransack to filter the query by term
                @term = Book.joins(:author).ransack(params[:term])
                @books = @term.result(distinct: true).where("books.title LIKE :term OR authors.name LIKE :term", term: "%#{params[:term]}%").paginate(page: params[:page], per_page: params[:page_size])
            else
                @books = Book.all.paginate(page: params[:page], per_page: params[:page_size])
            end
            render json: @books, include: '*', status: :ok
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # GET /books/{id}
    def show
        logger.info "Book #{@book.title} was successfully retrieved"
        render json: @book, include: '*', status: :ok
    end

    # POST /books
    def create
        begin
            book_data = book_params
            book_data["author_id"] = params[:data][:relationships][:author][:data][:id]
            @book = Book.new(book_data)
            if @book.save
                render json: @book,  status: :created
            else
                render json: { errors: @book.errors.full_messages },
                status: :unprocessable_entity
            end
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # PUT /books/{:id}

    def update
        begin
            book_data = book_params
            book_data["author_id"] = params[:data][:relationships][:author][:data][:id]
            unless @book.update(book_data)
                render json: { errors: @book.errors.full_messages},
                    status: :unprocessable_entity
            end
            
            render json: @book,  status: :ok 
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # DELETE /books/{:id}
    def destroy
        begin
            @book.destroy
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # GET /out-of-stock

    def out_of_stock
        begin
            books_loaned = Loan.where(is_returned: false).group(:book_id).count
            books_out_of_stock = books_loaned.select { |book_id, count| count == Book.find(book_id).hard_copies }.keys
            books = Book.where(id: books_out_of_stock).paginate(page: params[:page], per_page: params[:page_size])

            render json: books, include: '*', status: :ok
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    private
        def book_params
            params.require(:data).require(:attributes).permit(:title, :hard_copies)
        end
        def set_book
            begin
                @book = Book.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                logger.error "#{e.message}"
                render json: { errors: 'Book not found' }, status: :not_found
            end
        end
end
