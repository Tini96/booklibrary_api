class AuthorsController < ApplicationController
    before_action :librarian_permission
    before_action :set_author, only: [:show, :destroy, :update]

    # GET/books
    def index
        begin
            if params[:term]
                # Using ransack to filter the query by term
                @term = Author.joins(:books).ransack(params[:term])
                @authors = @term.result(distinct: true).where("authors.name LIKE :term OR books.title LIKE :term", term: "%#{params[:term]}%").paginate(page: params[:page], per_page: params[:page_size])
            else
                @authors = Author.all.paginate(page: params[:page], per_page: params[:page_size])
            end
            render json: @authors, include: '*', status: :ok
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # GET /author/{id}
    def show
        render json: @author, include: '*', status: :ok
    end

    # POST /author
    def create
        begin
            @author = Author.new(author_params)
            if @author.save
                render json: @author, status: :created
            else
                render json: { errors: @author.errors.full_messages },
                status: :unprocessable_entity
            end
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # PUT /author/{:id}

    def update
        begin
            author_data = author_params
            unless @author.update(author_data)
                render json: { errors: @author.errors.full_messages},
                    status: :unprocessable_entity
            end
            
            render json: @author,  status: :ok 
        rescue => e
            logger.error "#{e.message}"
            render json: { errors: 'Server error' }, status: :internal_server_error
        end
    end

    # DELETE /author/{:id}
    def destroy
        @author.destroy
    end

    private
        def author_params
            params.require(:data).require(:attributes).permit(:name, books_attributes: [:id, :title, :number_of_hard_copies, :_destroy])
        end
        def set_author
            begin
                @author = Author.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                logger.error "#{e.message}"
                render json: { errors: 'Author not found' }, status: :not_found
            end
        end
end
