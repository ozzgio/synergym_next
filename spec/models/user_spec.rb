# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  # Associations will be added when workout_logs model is created
  # describe 'Associations' do
  #   it { should have_many(:workout_logs) }
  # end

  describe 'Enums' do
    it { should define_enum_for(:role).with_values(athlete: 0, trainer: 1, admin: 2) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:encrypted_password) }
  end

  describe 'Scopes' do
    let!(:admin) { create(:user, :admin) }
    let!(:trainer) { create(:user, :trainer) }
    let!(:athlete) { create(:user, :athlete) }

    it 'returns only trainers' do
      expect(User.trainers).to include(trainer)
      expect(User.trainers).not_to include(admin, athlete)
    end

    it 'returns only athletes' do
      expect(User.athletes).to include(athlete)
      expect(User.athletes).not_to include(admin, trainer)
    end

    it 'returns only admins' do
      expect(User.admins).to include(admin)
      expect(User.admins).not_to include(trainer, athlete)
    end
  end

  describe 'Role methods' do
    context 'when user is an admin' do
      let(:user) { build(:user, :admin) }

      it 'returns true for admin?' do
        expect(user.admin?).to be true
      end

      it 'returns false for trainer?' do
        expect(user.trainer?).to be false
      end

      it 'returns false for athlete?' do
        expect(user.athlete?).to be false
      end
    end

    context 'when user is a trainer' do
      let(:user) { build(:user, :trainer) }

      it 'returns true for trainer?' do
        expect(user.trainer?).to be true
      end

      it 'returns false for admin?' do
        expect(user.admin?).to be false
      end

      it 'returns false for athlete?' do
        expect(user.athlete?).to be false
      end
    end

    context 'when user is an athlete' do
      let(:user) { build(:user, :athlete) }

      it 'returns true for athlete?' do
        expect(user.athlete?).to be true
      end

      it 'returns false for admin?' do
        expect(user.admin?).to be false
      end

      it 'returns false for trainer?' do
        expect(user.trainer?).to be false
      end
    end
  end
end
