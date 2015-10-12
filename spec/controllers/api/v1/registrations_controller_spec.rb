require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, :type => :controller do

  let (:user) {create(:user)}
  let (:other_user) {create(:user)}
  let (:valid_token) {{authentication_token: user.authentication_token}}
  let (:invalid_token) {{authentication_token: 'BAD_TOKEN'}}
  let (:new_user_params) do
      {
        user:{
          email: Faker::Internet.email,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          password: Devise.friendly_token.first(8),
        }
      }
  end

    let (:invalid_user_params) do
      {
        user:{
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          password: Devise.friendly_token.first(8),
        }
      }
  end

  describe 'Sign up' do
    context 'with valid params' do
      subject {post :create, new_user_params}
      it 'returns 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'create new user' do
        expect{subject}.to change{User.count}.by 1
      end
      it 'json matches the schema' do
        subject
        expect(json).to match_response_schema JsonSchema::Api::V1.current_user
      end

    end

    context 'with invalid params' do
      subject {post :create, invalid_user_params}
      it 'returns 422' do
        subject
        expect(response.status).to eq(422)
      end

      it 'doesn\'t crete new user' do
        expect{subject}.to change{User.count}.by 0
      end

      it 'results expose errors' do
        subject
        expect(json["error"]).not_to be_empty
      end
    end
  end

end