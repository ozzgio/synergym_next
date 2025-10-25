# Configure session store for OAuth to work properly
Rails.application.config.session_store :cookie_store,
  key: "_synergym_next_session",
  same_site: :lax,
  secure: Rails.env.production?,
  httponly: true,
  expire_after: 1.day
