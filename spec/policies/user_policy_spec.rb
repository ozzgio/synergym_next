# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, record) }

  let(:record) { create(:user, :athlete) }

  context 'for an admin' do
    let(:user) { create(:user, :admin) }

    it { expect(subject.index?).to be true }
    it { expect(subject.show?).to be true }
    it { expect(subject.create?).to be true }
    it { expect(subject.new?).to be true }
    it { expect(subject.update?).to be true }
    it { expect(subject.edit?).to be true }
    it { expect(subject.destroy?).to be true }
  end

  context 'for a trainer' do
    let(:user) { create(:user, :trainer) }

    it { expect(subject.index?).to be false }
    it { expect(subject.show?).to be false }
    it { expect(subject.create?).to be false }
    it { expect(subject.new?).to be false }
    it { expect(subject.update?).to be false }
    it { expect(subject.edit?).to be false }
    it { expect(subject.destroy?).to be false }
  end

  context 'for an athlete' do
    let(:user) { create(:user, :athlete) }

    it { expect(subject.index?).to be false }
    it { expect(subject.show?).to be false }
    it { expect(subject.create?).to be false }
    it { expect(subject.new?).to be false }
    it { expect(subject.update?).to be false }
    it { expect(subject.edit?).to be false }
    it { expect(subject.destroy?).to be false }
  end

  context 'for a guest (not signed in)' do
    let(:user) { nil }

    it { expect(subject.index?).to be false }
    it { expect(subject.show?).to be false }
    it { expect(subject.create?).to be false }
    it { expect(subject.new?).to be false }
    it { expect(subject.update?).to be false }
    it { expect(subject.edit?).to be false }
    it { expect(subject.destroy?).to be false }
  end
end
