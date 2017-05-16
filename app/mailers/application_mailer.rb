class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com",
          bcc: ["yuval@selffer.com", "uri@selffer.com"]
  layout 'mailer'
end
