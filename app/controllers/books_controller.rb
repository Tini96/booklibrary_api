class BooksController < ApplicationController
    before_action :librarian_permission, only: [:show, :destroy, :update, :create]
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
        puts(book_data)
        book_data["author_id"] = params[:data][:relationships][:author][:data][:id]
        @book = Book.new(book_data)
        if @book.save
            render json: @book, include: '*', status: :created
        else
            render json: { errors: @book.errors.full_messages },
            status: :unprocessable_entity
        end
    end

    # PUT /books/{:id}

    def update
        book_data = book_params
        book_data["author_id"] = params[:data][:relationships][:author][:data][:id]
        @book
        unless @book.update(book_data)
            render json: { errors: @book.errors.full_messages},
                status: :unprocessable_entity
        end
        
        render json: @book, include: '*', status: :ok 
    end

    # DELETE /books/{:id}
    def destroy
        @book.destroy
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
