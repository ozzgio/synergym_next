# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardPolicy, type: :policy do
  let(:athlete) { create(:user, :athlete) }
  let(:trainer) { create(:user, :trainer) }
  let(:admin) { create(:user, :admin) }

  subject { described_class.new(user, :dashboard) }

  context 'for athlete users' do
    let(:user) { athlete }

    it { is_expected.to permit_action(:athlete) }
    it { is_expected.not_to permit_action(:trainer) }
    it { is_expected.not_to permit_action(:admin) }
  end

  context 'for trainer users' do
    let(:user) { trainer }

    it { is_expected.not_to permit_action(:athlete) }
    it { is_expected.to permit_action(:trainer) }
    it { is_expected.not_to permit_action(:admin) }
  end

  context 'for admin users' do
    let(:user) { admin }

    it { is_expected.not_to permit_action(:athlete) }
    it { is_expected.to permit_action(:trainer) }
    it { is_expected.to permit_action(:admin) }
  end

  context 'for unauthenticated users' do
    let(:user) { nil }

    it { is_expected.not_to permit_action(:athlete) }
    it { is_expected.not_to permit_action(:trainer) }
    it { is_expected.not_to permit_action(:admin) }
  end
end
