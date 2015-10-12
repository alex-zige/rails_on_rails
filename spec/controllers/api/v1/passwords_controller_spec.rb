require 'rails_helper'

RSpec.describe Api::V1::PasswordsController, :type => :controller do

  let (:user) {create(:user)}
  let (:other_user) {create(:user)}
  let (:valid_token) {{authentication_token: user.authentication_token}}
  let (:invalid_token) {{authentication_token: 'BAD_TOKEN'}}
  let (:user_params) do
      {
        user:{
          email: user.email
        }
      }
  end

    let (:invalid_user_params) do
      {
        user:{
          email: Faker::Internet.email
        }
      }
  end

  describe 'Reset password' do
    context 'with valid params' do
      subject {post :create, user_params}
      it 'returns 200' do
        subject
        expect(response.status).to eq(200)
      end

      it 'send password reset email' do
        expect{subject}.to change{ ActionMailer::Base.deliveries.count}.by(1)
      end
    end

    context 'with Invalid params' do
      subject {post :create, invalid_user_params}
      it 'returns 422' do
        subject
        expect(response.status).to eq(422)
      end

      it 'doesn\'t send password reset email' do
        expect{subject}.to change{ ActionMailer::Base.deliveries.count}.by(0)
      end

      it 'returns errors' do
        subject
        expect(json['error']).not_to be_empty
      end
    end
  end

end