class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email
  belongs_to :user_type, serializer: UserTypeSerializer
end
