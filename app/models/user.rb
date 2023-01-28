class User < ApplicationRecord
    require "securerandom"
    belongs_to :user_type
    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, on: :create
    validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\z/,
        message: "only allows letters and numbers" }
    def to_param
        username
    end
end
