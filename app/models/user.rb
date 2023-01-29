class User < ApplicationRecord
    require "securerandom"
    MAX_NUMBER_LOANS = 3
    belongs_to :user_type
    has_many :loans
    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, on: :create
    validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\z/,
        message: "only allows letters and numbers" }


    def to_param
        username
    end


    public
        def member?
            puts self.user_type_id 
            puts self.id
            self.user_type_id == UserType.find_by_type_name("Member").id
        end

        def max_number_of_loans?
            self.loans.where(is_returned: false).count == MAX_NUMBER_LOANS
        end
end
