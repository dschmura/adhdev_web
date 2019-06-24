class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  # Include any view helpers from your main app to use in mailers here
  add_template_helper(ApplicationHelper)
end
