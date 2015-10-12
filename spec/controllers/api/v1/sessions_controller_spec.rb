require 'rails_helper'

RSpec.describe Api::V1::SessionsController, :type => :controller do

  let! (:user) {create(:user, email: "test@gmail.com", password: "password")}
  let (:valid_token) {{authentication_token: user.authentication_token}}
  let (:invalid_token) {{authentication_token: 'BAD_TOKEN'}}
  let (:sign_in_param) do
      {
        user:{
          email: 'test@gmail.com',
          password: 'password',
        }
      }
  end
    let (:invalid_password_param) do
      {
        user:{
          email: 'test@gmail.com',
          password: 'bad password'
        }
      }
  end

    let (:invalid_email_param) do
      {
        user:{
          email: 'wrong_email@gmail.com',
          password: 'bad password'
        }
      }
  end

  describe 'POST create' do
    context 'with valid params' do
      subject {post :create, sign_in_param}
      it 'returns 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'json matches the schema' do
        subject
        expect(json).to match_response_schema JsonSchema::Api::V1.current_user
      end

    end

    context 'with invalid password' do
      subject {post :create, invalid_password_param}
      it 'returns 401' do
        subject
        expect(response.status).to eq(401)
      end

      it 'doesn\'t crete new user' do
        expect{subject}.to change{User.count}.by 0
      end

      it 'results expose errors' do
        subject
        expect(json["error"]).not_to be_empty
      end

      it 'retruns correct error message' do
        subject
        expect(json["error"]).to eq('The email and password combination is not correct.')
      end
    end

    context 'with invalid email' do
      subject {post :create, invalid_email_param}
      it 'returns 401' do
        subject
        expect(response.status).to eq(401)
      end

      it 'doesn\'t crete new user' do
        expect{subject}.to change{User.count}.by 0
      end

      it 'results expose errors' do
        subject
        expect(json["error"]).not_to be_empty
      end

      it 'retruns correct error message' do
        subject
        expect(json["error"]).to eq('The email and password combination is not correct.')
      end
    end
  end

 fdescribe 'Sign out' do
    context 'with valid params' do
      subject {delete :destroy, {id: user}.merge(valid_token)}
      it 'returns 200' do
        subject
        expect(response.status).to eq(200)
      end

      it 'reset the authentication_token' do
        expect{subject}.to change{user.reload.authentication_token}
      end
    end

    context 'with invalid params' do
      subject {delete :destroy, {id: user}.merge(invalid_token)}
      it 'returns 401' do
        subject
        expect(response.status).to eq(401)
      end

      it 'doesn\'t reset the authentication_token' do
        expect{subject}.to_not change{user.reload.authentication_token}
      end
    end
  end


end