class Api::V1::UserSerializer < ActiveModel::Serializer

  attributes :id, :first_name, :last_name, :profile_image_url

  def profile_image_url
    URI.unescape(object.profile_image.url(:thumb))
  end

end
