module Api
  class BaseController < ActionController::API
    doorkeeper_for :all

    private

    # Find the user that owns the access token
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
