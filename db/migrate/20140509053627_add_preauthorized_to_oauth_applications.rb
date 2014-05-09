class AddPreauthorizedToOauthApplications < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :preauthorized, :boolean
  end
end
