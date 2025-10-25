# Helper module to mock OmniAuth responses in tests
module OmniauthMockHelper
  # Mock Google OAuth2 response
  def mock_google_oauth2_response
    {
      provider: "google_oauth2",
      uid: "123456789",
      info: {
        name: "John Doe",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg"
      },
      credentials: {
        token: "fake_token_123",
        refresh_token: "fake_refresh_token",
        expires_at: Time.now.to_i + 3600
      },
      extra: {
        raw_info: {
          sub: "123456789",
          email: "john.doe@example.com",
          email_verified: true,
          name: "John Doe",
          picture: "https://example.com/image.jpg"
        }
      }
    }
  end

  # Mock GitHub OAuth response
  def mock_github_oauth_response
    {
      provider: "github",
      uid: "987654321",
      info: {
        name: "Jane Smith",
        email: "jane.smith@example.com",
        image: "https://avatars.githubusercontent.com/u/987654321"
      },
      credentials: {
        token: "fake_github_token",
        expires: false
      },
      extra: {
        raw_info: {
          id: 987654321,
          login: "janesmith",
          name: "Jane Smith",
          email: "jane.smith@example.com",
          avatar_url: "https://avatars.githubusercontent.com/u/987654321"
        }
      }
    }
  end

  # Setup OmniAuth mock for integration tests
  def setup_omniauth_mock(provider, response_data)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(response_data)
  end

  # Cleanup OmniAuth mock
  def cleanup_omniauth_mock
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth.clear
  end
end
