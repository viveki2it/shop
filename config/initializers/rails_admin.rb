RailsAdmin.config do |config|
  config.main_app_name = ["ShopOfMe", "Admin"]
  config.current_user_method { current_admin_user }
  config.included_models = ["AdminUser","Invite","LandingPageLayout","LandingPageVariant","Signup", "Retailer"]

  config.authenticate_with do
    authenticate_admin_user!
  end
  config.label_methods << :to_s
end
