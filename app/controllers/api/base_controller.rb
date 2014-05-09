class Api::BaseController < ActionController::API
  doorkeeper_for :all
end
