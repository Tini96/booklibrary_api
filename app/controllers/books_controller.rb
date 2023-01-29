class BooksController < ApplicationController
    before_action :librarian_permission, only: [:show, :destroy, :update, :create, :out_of_stock]
    before_action :set_book, only: [:show, :destroy, :update]

    # GET/books
    def index
        if params[:term]
            @term = Book.joins(:author).ransack(params[:term])
            @books = @term.result(distinct: true).where("books.title LIKE :term OR authors.name LIKE :term", term: "%#{params[:term]}%").paginate(page: params[:page], per_page: params[:page_size])
        else
            @books = Book.all.paginate(page: params[:page], per_page: params[:page_size])
        end
        render json: @books, include: '*', status: :ok
    end

    # GET /books/{id}
    def show
        render json: @book, include: '*', status: :ok
    end

    # POST /books
    def create
        book_data = book_params
        book_data["author_id"] = params[:data][:relationships][:author][:data][:id]
        @book = Book.new(book_data)
        if @book.save
            render json: @book,  status: :created
        else
            render json: { errors: @book.errors.full_messages },
            status: :unprocessable_entity
        end
    end

    # PUT /books/{:id}

    def update
        book_data = book_params
        book_data["author_id"] = params[:data][:relationships][:author][:data][:id]
        unless @book.update(book_data)
            render json: { errors: @book.errors.full_messages},
                status: :unprocessable_entity
        end
        
        render json: @book,  status: :ok 
    end

    # DELETE /books/{:id}
    def destroy
        @book.destroy
    end

    # GET /out-of-stock

    def out_of_stock

        books_loaned = Loan.where(is_returned: false).group(:book_id).count
        books_out_of_stock = books_loaned.select { |book_id, count| count == Book.find(book_id).hard_copies }.keys
        books = Book.where(id: books_out_of_stock).paginate(page: params[:page], per_page: params[:page_size])

        render json: books, include: '*', status: :ok
    end

    private
        def book_params
            params.require(:data).require(:attributes).permit(:title, :hard_copies)
        end
        def set_book
            @book = Book.find(params[:id])
            if !@book
                render json: { errors: 'Book not found' }, status: :not_found
            end
        end
end
