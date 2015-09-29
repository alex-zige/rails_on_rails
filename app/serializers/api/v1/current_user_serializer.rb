class Api::V1::CurrentUserSerializer < Api::V1::SimpleUserSerializer
  #Expose current user only data
  attributes :email, :authentication_token

end
