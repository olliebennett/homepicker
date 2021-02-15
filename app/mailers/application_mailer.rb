# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('EMAIL_FROM_ADDRESS', 'from@example.com')
  layout 'mailer'
end
