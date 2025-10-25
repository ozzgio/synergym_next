class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  enum :role, { athlete: 0, trainer: 1, admin: 2 }

  # Scopes for easier querying
  scope :trainers, -> { where(role: :trainer) }
  scope :athletes, -> { where(role: :athlete) }
  scope :admins, -> { where(role: :admin) }

  # Custom validations (Devise already handles password validation)
  validates :email, presence: true, uniqueness: { case_insensitive: true }
  validates :first_name, presence: true, if: -> { oauth_connected? }
  validates :last_name, presence: true, if: -> { oauth_connected? }

  # OAuth validations
  validates :provider, presence: true, if: -> { uid.present? }
  validates :uid, presence: true, if: -> { provider.present? }
  validates :provider, inclusion: { in: [ "google_oauth2", "github" ] }, allow_blank: true
  validates :uid, uniqueness: { scope: :provider }, if: -> { provider.present? && uid.present? }

  # Class methods for OAuth
  class << self
    # Find or create a user from OAuth data
    def from_omniauth(auth)
      where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
        user.email = auth.dig(:info, :email)
        user.password = Devise.friendly_token[0, 20] # Random password for OAuth users
        # Set default role for OAuth users (can be customized as needed)
        user.role = :athlete
      end
    end

    # Find or create a user from OAuth data with specified role
    def from_omniauth_with_role(auth, role)
      where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
        user.email = auth.dig(:info, :email)
        user.password = Devise.friendly_token[0, 20] # Random password for OAuth users
        # Set the specified role for OAuth users
        user.role = role
      end
    end

    # Find user by OAuth provider and UID
    def find_for_oauth(auth)
      where(provider: auth[:provider], uid: auth[:uid]).first
    end

    # Find user by email and connect OAuth account
    def connect_oauth(email, auth)
      user = find_by(email: email)
      return unless user

      user.update(provider: auth[:provider], uid: auth[:uid])
      user
    end
  end

  # Instance methods for OAuth
  def oauth_connected?
    provider.present? && uid.present?
  end

  def profile_complete?
    first_name.present? && last_name.present?
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def disconnect_oauth
    update(provider: nil, uid: nil)
  end

  def oauth_provider_name
    case provider
    when "google_oauth2"
      "Google"
    when "github"
      "GitHub"
    else
      provider&.humanize
    end
  end

  # Extract profile data from OAuth response
  def extract_profile_from_oauth(auth)
    return unless auth.present?

    # Extract names from OAuth data
    info = auth.dig(:info) || {}

    profile_data = {}

    # Try to get name from various sources
    if info[:name].present?
      name_parts = info[:name].split(" ", 2)
      profile_data[:first_name] = name_parts[0]
      profile_data[:last_name] = name_parts[1] || ""
    end

    # Use specific first/last name fields if available
    profile_data[:first_name] = info[:first_name] if info[:first_name].present?
    profile_data[:last_name] = info[:last_name] if info[:last_name].present?

    # Extract profile photo
    profile_data[:profile_photo_url] = info[:image] if info[:image].present?

    profile_data
  end

  # Update user information from OAuth data
  def update_from_oauth(auth)
    return unless auth.present?

    # Extract and update profile data
    profile_data = extract_profile_from_oauth(auth)

    # Update email if it has changed
    email = auth.dig(:info, :email)
    update_data = { email: email } if email.present? && email != self.email

    # Update other OAuth fields
    update_data ||= {}
    update_data.merge!(provider: auth[:provider], uid: auth[:uid])
    update_data.merge!(profile_data) if profile_data.present?

    update(update_data) if update_data.present?
  end

  # Connect OAuth account to existing user
  def connect_oauth_account(auth)
    return unless auth.present?

    profile_data = extract_profile_from_oauth(auth)
    update_data = {
      provider: auth[:provider],
      uid: auth[:uid]
    }
    update_data.merge!(profile_data) if profile_data.present?

    update(update_data)
  end

  # Update profile information
  def update_profile(first_name:, last_name:, profile_photo_url: nil)
    update_data = {
      first_name: first_name,
      last_name: last_name
    }
    update_data[:profile_photo_url] = profile_photo_url if profile_photo_url.present?

    update(update_data)
  end

  # Methods to handle Google OAuth callbacks
  def self.from_google_oauth(auth)
    return nil unless auth.present?

    # Check if user already exists with this Google account
    user = find_for_oauth(auth)

    if user
      # User exists with this Google account, update info and return it
      user.update_from_oauth(auth)
      return user
    end

    # Check if user exists with same email
    existing_user = find_by(email: auth.dig(:info, :email))
    if existing_user
      # Connect Google account to existing user
      existing_user.connect_oauth_account(auth)
      return existing_user
    end

    # Create new user from Google OAuth data
    from_omniauth(auth)
  end

  def google_oauth_data
    return nil unless oauth_connected? && provider == "google_oauth2"

    {
      provider: provider,
      uid: uid,
      connected_at: updated_at
    }
  end

  def github_oauth_data
    return nil unless oauth_connected? && provider == "github"

    {
      provider: provider,
      uid: uid,
      connected_at: updated_at
    }
  end

  # Methods to handle GitHub OAuth callbacks
  def self.from_github_oauth(auth)
    return nil unless auth.present?

    # Check if user already exists with this GitHub account
    user = find_for_oauth(auth)

    if user
      # User exists with this GitHub account, update info and return it
      user.update_from_oauth(auth)
      return user
    end

    # Check if user exists with same email
    existing_user = find_by(email: auth.dig(:info, :email))
    if existing_user
      # Connect GitHub account to existing user
      existing_user.connect_oauth_account(auth)
      return existing_user
    end

    # Create new user from GitHub OAuth data
    from_omniauth(auth)
  end
end
