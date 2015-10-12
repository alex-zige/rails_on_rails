require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe Api::V1::UsersController, :type => :controller do

  let (:user) {create(:user)}
  let (:other_user) {create(:user)}
  let (:valid_token) {{authentication_token: user.authentication_token}}
  let (:invalid_token) {{authentication_token: 'BAD_TOKEN'}}
  let (:update_user_params) do
      {
        user:{
          email: 'new_email@gmail.com',
          first_name: 'new_first_name',
          last_name: 'new_last_name'
        }
      }
  end

  describe "#show" do
    context 'with valid token' do
      subject {get :show, {id: other_user}.merge(valid_token)}
      it 'returns 200' do
        subject
        expect(response.status).to eq (200)
      end

      it 'response matches json' do
        subject
        expect(json).to match_response_schema(JsonSchema::Api::V1.user)
      end
    end
    context 'with invalid token' do
      subject {get :show, {id: other_user}.merge(invalid_token)}
      it 'returns 401' do
        subject
        expect(response.status).to eq (401)
      end
    end
  end

  describe "#me" do
    context 'with valid token' do
      subject {get :me, {id: user}.merge(valid_token)}
      it 'returns 200' do
        subject
        expect(response.status).to eq (200)
      end

      it 'response matches json' do
        subject
        expect(json).to match_response_schema(JsonSchema::Api::V1.current_user)
      end
    end
    context 'with invalid token' do
      subject {get :me, {id: user}.merge(invalid_token)}
      it 'returns 401' do
        subject
        expect(response.status).to eq (401)
      end
    end
  end

  describe "#update" do
    subject {put :update, {id: user}.merge(update_user_params).merge(valid_token)}
    it 'returns 200' do
      subject
      expect(response.status).to eq (200)
    end

    it 'response matches json' do
      subject
      expect(json).to match_response_schema(JsonSchema::Api::V1.current_user)
    end

    it 'update user info' do
      subject
      expect(user.reload.email).to eq('new_email@gmail.com')
      expect(user.reload.first_name).to eq('new_first_name')
      expect(user.reload.last_name).to eq('new_last_name')
    end

  end
end