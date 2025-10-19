# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SampleWorker, type: :worker do
  let(:message) { 'Test message' }

  it 'processes the job' do
    expect(Rails.logger).to receive(:info).with("SampleWorker processing: #{message}")

    # Directly call the perform method
    worker = described_class.new
    worker.perform(message)
  end

  it 'can be instantiated' do
    worker = described_class.new
    expect(worker).to be_a(described_class)
  end
end
