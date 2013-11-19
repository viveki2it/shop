module Analytics::RealInstallsHelper
  def colour_user(user)
    if user.created_at > (Time.now - 30.days)
      '#B0FFB9'
    else
      'white'
    end
  end
end
