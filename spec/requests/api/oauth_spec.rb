# spec/requests/api/oauth_spec.rb
require 'spec_helper'
require 'rack/oauth2'

describe 'OAuth' do

  describe 'auth ok' do
    let(:auth) { authenticate }
    it 'success' do
      expect(auth[:access_token]).to_not be_expired
    end
  end

  describe 'auth not ok' do
    context 'due to expired token' do
      let(:auth) { authenticate }
      it 'respond with error' do
        server_token = auth[:app].
                                  access_tokens.
                                  find_by resource_owner_id: auth[:user].id
        server_token.expires_in = 0
        server_token.save!
        get api_v1_default_path,
            'access_token' => auth[:access_token].try(:token)

        expect(
               response.header['WWW-Authenticate']
               ).to eq('Bearer realm="Doorkeeper", ' \
                       'error="invalid_token", ' \
                       'error_description="The access token expired"')
      end
    end

    context 'due to revoked token' do
      let(:auth) { authenticate }
      it 'respond with error' do
        server_token = auth[:app].
                                  access_tokens.
                                  find_by resource_owner_id: auth[:user].id
        server_token.revoked_at = 1.minute.ago
        server_token.save!
        get api_v1_default_path,
            'access_token' => auth[:access_token].try(:token)

        expect(
               response.header['WWW-Authenticate']
               ).to eq('Bearer realm="Doorkeeper", ' \
                       'error="invalid_token", ' \
                       'error_description="The access token was revoked"')
      end
    end

    context 'due to invalid credentials' do
      it 'respond with error' do
        expect { authenticate(1234) }.to raise_error(OAuth2::Error)
      end
    end
  end
end
