ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "shopofme.com",
  :user_name            => "reports@shopofme.com",
  :password             => "p8tbA4cAFFfE",
  :authentication       => "plain",
  :enable_starttls_auto => true
}