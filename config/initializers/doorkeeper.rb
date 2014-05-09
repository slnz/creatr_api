Doorkeeper.configure do
  enable_application_owner confirmation: false

  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  skip_authorization do |_resource_owner, client|
    client.application.preauthorized?
  end

  admin_authenticator do
    if current_user
      redirect_to(not_authorized_url) unless current_user.role.is?(:admin)
    else
      redirect_to(new_user_session_url)
    end
  end

  if Rails.env.test?
    resource_owner_from_credentials do |_routes|
      request.params[:user] = { email: request.params[:username],
                                password: request.params[:password] }
      request.env['devise.allow_params_authentication'] = true
      request.env['warden'].authenticate!(scope: :user)
    end
  end

end
