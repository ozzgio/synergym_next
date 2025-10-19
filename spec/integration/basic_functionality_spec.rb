# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Basic Functionality' do
  describe 'User model' do
    it 'can create a user with valid attributes' do
      user = create(:user, :trainer)
      expect(user).to be_valid
      expect(user.trainer?).to be true
    end

    it 'can create different user roles' do
      admin = create(:user, :admin)
      trainer = create(:user, :trainer)
      athlete = create(:user, :athlete)

      expect(admin.admin?).to be true
      expect(trainer.trainer?).to be true
      expect(athlete.athlete?).to be true
    end
  end

  describe 'Application Policy' do
    it 'allows admin users to perform all actions' do
      admin = create(:user, :admin)
      user = create(:user, :athlete)
      policy = ApplicationPolicy.new(admin, user)

      expect(policy.index?).to be true
      expect(policy.show?).to be true
      expect(policy.create?).to be true
      expect(policy.update?).to be true
      expect(policy.destroy?).to be true
    end

    it 'does not allow non-admin users to perform actions' do
      trainer = create(:user, :trainer)
      user = create(:user, :athlete)
      policy = ApplicationPolicy.new(trainer, user)

      expect(policy.index?).to be false
      expect(policy.show?).to be false
      expect(policy.create?).to be false
      expect(policy.update?).to be false
      expect(policy.destroy?).to be false
    end
  end

  describe 'Routes', type: :routing do
    it 'includes devise routes for users' do
      expect(get: '/users/sign_in').to route_to('devise/sessions#new')
      expect(get: '/users/sign_up').to route_to('devise/registrations#new')
      expect(post: '/users').to route_to('devise/registrations#create')
    end

    it 'includes sidekiq web route in development' do
      # Sidekiq web route is only available in development/staging
      if Rails.env.development? || Rails.env.staging?
        expect(get: '/sidekiq').to route_to('sidekiq/web#index')
      else
        skip 'Sidekiq web route only available in development/staging'
      end
    end
  end

  describe 'Sidekiq Worker' do
    it 'can be instantiated' do
      worker = SampleWorker.new
      expect(worker).to be_a(SampleWorker)
    end
  end
end
