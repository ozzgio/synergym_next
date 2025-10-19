# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /users/sign_up' do
    context 'with valid parameters' do
      it 'creates a new user' do
        user_attributes = attributes_for(:user, :athlete)

        expect {
          post user_registration_path, params: { user: user_attributes }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Welcome! You have signed up successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        invalid_attributes = attributes_for(:user, email: nil)

        expect {
          post user_registration_path, params: { user: invalid_attributes }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'POST /users/sign_in' do
    let(:user) { create(:user, :athlete) }

    context 'with valid credentials' do
      it 'signs in the user' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Signed in successfully')
      end
    end

    context 'with invalid credentials' do
      it 'does not sign in the user' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrongpassword'
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('Invalid Email or password')
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    let(:user) { create(:user, :athlete) }

    before do
      sign_in user
    end

    it 'signs out the user' do
      delete destroy_user_session_path

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Signed out successfully')
    end
  end
end
