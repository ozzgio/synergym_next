# Testing Guide for M1: Initial Rails 8 Project Setup

This document provides instructions on how to test the components implemented in M1.

## Prerequisites

1. **Redis Server**: Make sure Redis is installed and running
   ```bash
   # macOS
   brew install redis
   brew services start redis
   
   # Ubuntu/Debian
   sudo apt-get install redis-server
   sudo systemctl start redis
   
   # Verify Redis is running
   redis-cli ping
   # Should return: PONG
   ```

2. **Database**: Ensure the database is created and migrated
   ```bash
   rails db:create db:migrate
   ```

3. **Heroku Deployment**: See [HEROKU_DEPLOYMENT.md](HEROKU_DEPLOYMENT.md) for deployment instructions

2. **Database**: Ensure the database is created and migrated
   ```bash
   rails db:create db:migrate
   ```

## Running Tests

### 1. Run All Tests
```bash
# Using the test script (checks Redis, DB, and runs all tests)
./bin/test_setup

# Run basic functionality tests (recommended for M1 verification)
bundle exec rspec spec/integration/basic_functionality_spec.rb

# Or directly with RSpec (may have some failing tests)
bundle exec rspec
```

### 2. Run Specific Test Types

#### Model Tests
```bash
bundle exec rspec spec/models
```

#### Request/Integration Tests
```bash
bundle exec rspec spec/requests
```

#### Policy Tests
```bash
bundle exec rspec spec/policies
```

#### Worker Tests
```bash
bundle exec rspec spec/workers
```

### 3. Run Tests with Coverage
```bash
COVERAGE=true bundle exec rspec
```

## Test Coverage

### User Model (`spec/models/user_spec.rb`)
- Factory validation
- Enum functionality (athlete, trainer, admin roles)
- Scopes for different user types
- Role methods

### Authentication (`spec/requests/authentication_spec.rb`)
- User registration (sign up)
- User sign in
- User sign out

### Authorization (`spec/policies/user_policy_spec.rb`)
- Admin users have full access
- Trainer and athlete users have restricted access
- Guest users have no access

### Background Jobs (`spec/workers/sample_worker_spec.rb`)
- Worker execution
- Job queuing

## Manual Testing

### 1. Start the Rails Server
```bash
rails server
```

### 2. Access Devise Routes
- Root: http://localhost:3000/ (redirects to sign in)
- Sign up: http://localhost:3000/users/sign_up
- Sign in: http://localhost:3000/users/sign_in
- Sign out: http://localhost:3000/users/sign_out

### 3. Access Sidekiq Web Interface
```bash
# In development
http://localhost:3000/sidekiq
```

### 4. Test Background Jobs
```bash
# Start Sidekiq worker
bundle exec sidekiq

# In Rails console
rails console
> SampleWorker.perform_async("Test message")
```

## Troubleshooting

### Redis Connection Issues
If Redis is not running, you'll see connection errors. Start Redis as shown in the prerequisites.

### Database Issues
If tests fail with database errors, ensure:
```bash
rails db:test:prepare
```

### Devise Test Helpers
If Devise test helpers are not working, ensure you have:
- Included `Devise::Test::ControllerHelpers` in controller specs
- Included `Devise::Test::IntegrationHelpers` in request specs
- Set up Warden test mode (already configured in rails_helper.rb)

## Next Steps

After verifying all tests pass, you can proceed with:
1. Issue #4: Implement User Authentication (Devise)
2. Issue #5: Set up Authorization (Pundit)
3. Issue #8: Generate User model with Devise
4. Issue #9: Add role column to User
5. Issue #10: Create signup, login, and forgot password views
6. Issue #11: Configure Pundit and create ApplicationPolicy
7. Issue #12: Create basic policies
8. Issue #13: Create a root dashboard