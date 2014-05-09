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

end
