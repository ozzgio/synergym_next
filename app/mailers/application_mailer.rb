class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("DEVISE_MAILER_SENDER", "no-reply@synergym.com")
  layout "mailer"
end
