# frozen_string_literal: true

class SampleWorker
  include Sidekiq::Worker

  def perform(message)
    Rails.logger.info "SampleWorker processing: #{message}"
    # This is just a sample worker for testing purposes
    # In a real application, you would do actual work here
  end
end
