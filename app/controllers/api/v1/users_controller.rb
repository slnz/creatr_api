module Api
  module V1
    class UsersController < Api::V1::BaseController
      # GET /me.json
      def me
        respond_with current_resource_owner
      end
    end
  end
end
