# frozen_string_literal: true

module ControllerHelpers
  def sign_in(user)
    if request.present?
      sign_in user if defined?(sign_in)
    else
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
  end

  def sign_out(user)
    sign_out user if defined?(sign_out)
  end

  def current_user
    @current_user ||= begin
      if defined?(subject)
        subject.current_user
      else
        @controller.current_user
      end
    end
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :request
end
