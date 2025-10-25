# SynergyM

A professional Rails application for athlete and trainer management.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## E2E Testing

This project includes end-to-end testing setup using Playwright MCP server.

### E2E Test Structure

- **Location**: `spec/e2e/`
- **Framework**: Playwright with MCP server integration
- **Test Coverage**:
  - User registration and login flows
  - Dashboard navigation for different user roles (athlete, trainer, admin)
  - Authentication flows and session management
  - Form validation and error handling

### Running E2E Tests

1. Start the Rails development server:
   ```bash
   bundle exec rails server -p 3000
   ```

2. Use the Playwright MCP server to run tests:
   - Tests are executed via MCP server tools
   - Screenshots are automatically captured for validation
   - Test results are saved in `spec/e2e/screenshots/`

### E2E Test Features

- **Screenshot Capture**: Automatic screenshots at key test steps
- **Multi-browser Support**: Chrome, Firefox, Safari
- **Role-based Testing**: Different test scenarios for athlete, trainer, and admin roles
- **Authentication Testing**: Complete login/logout flows and session management

For detailed E2E testing documentation, see [`spec/e2e/README.md`](spec/e2e/README.md).

## Development Setup

### Ruby Version

- Ruby 3.x (specified in `.ruby-version`)

### System Dependencies

- Rails 8.0.3
- PostgreSQL
- Redis (for Sidekiq)

### Configuration

1. Copy `.env.example` to `.env` and configure environment variables
2. Run `bundle install` to install Ruby gems
3. Set up the database: `rails db:create db:migrate`
4. Start the development server: `rails server`

### Database

```bash
rails db:create
rails db:migrate
rails db:seed  # Optional: load seed data
```

### Running Tests

```bash
# Run RSpec tests
bundle exec rspec

# Run specific test types
bundle exec rspec spec/models
bundle exec rspec spec/controllers
bundle exec rspec spec/integration
```

### Services

- **Background Jobs**: Sidekiq with Redis
- **Caching**: Rails caching with Redis
- **Asset Pipeline**: Propshaft

### Deployment

See [`docs/HEROKU_DEPLOYMENT.md`](docs/HEROKU_DEPLOYMENT.md) for deployment instructions.

#### Quick Deploy to Heroku

Click the "Deploy to Heroku" button above for one-click deployment, or follow the manual deployment steps in the guide.

## Authentication System

This application implements a comprehensive authentication system with the following features:

### User Authentication
- **Devise**: Standard Rails authentication with email/password
- **OAuth**: Social login via Google and GitHub
- **Role-based Access**: Athlete, Trainer, and Admin roles
- **Profile Management**: User profiles with photos and personal information

### Authorization
- **Pundit**: Role-based authorization policies
- **Dashboard Access**: Role-specific dashboard views
- **API Protection**: Secure API endpoints with proper authorization

### Security Features
- **CSRF Protection**: Built-in Rails CSRF protection
- **Session Management**: Secure session handling
- **Password Recovery**: Email-based password reset
- **Account Confirmation**: Email verification for new accounts

### OAuth Providers
- **Google OAuth2**: Full Google account integration
- **GitHub OAuth**: GitHub account login
- **Role Selection**: Multi-step OAuth flow with role selection
- **Profile Sync**: Automatic profile data synchronization

### User Roles
- **Athlete**: Access to athlete-specific features and dashboard
- **Trainer**: Management tools and client dashboard
- **Admin**: Full system administration capabilities

### Email Configuration
- **Development**: Letter Opener for email preview
- **Production**: SendGrid integration for email delivery
- **Templates**: Customizable email templates for all authentication events

## Testing

The application includes comprehensive testing coverage:

### Model Tests
- User model validation and authentication methods
- OAuth integration testing
- Role-based access control testing

### Controller Tests
- Authentication flow testing
- Authorization policy testing
- Dashboard access control testing

### Integration Tests
- End-to-end user registration and login flows
- Dashboard navigation for different user roles
- Authentication flows and session management
- Form validation and error handling

### E2E Testing
- Playwright-based end-to-end testing
- Multi-browser support (Chrome, Firefox, Safari)
- Automatic screenshot capture for test validation
- Role-based testing scenarios
- Complete authentication flow testing

## Documentation

Comprehensive documentation is available in the `docs/` directory:

- [`docs/API.md`](docs/API.md) - API documentation
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) - System architecture
- [`docs/EMAIL_CONFIGURATION.md`](docs/EMAIL_CONFIGURATION.md) - Email setup guide
- [`docs/FRONTEND_ARCHITECTURE.md`](docs/FRONTEND_ARCHITECTURE.md) - Frontend structure
- [`docs/HEROKU_DEPLOYMENT.md`](docs/HEROKU_DEPLOYMENT.md) - Deployment guide
- [`docs/IMPROVEMENTS_SUMMARY.md`](docs/IMPROVEMENTS_SUMMARY.md) - Feature summary
- [`docs/PASSWORD_RECOVERY_TESTING.md`](docs/PASSWORD_RECOVERY_TESTING.md) - Password recovery testing
- [`docs/PASSWORD_RESET_SETUP.md`](docs/PASSWORD_RESET_SETUP.md) - Password reset setup
- [`docs/TESTING.md`](docs/TESTING.md) - Testing guide
- [`docs/VISUAL_GUIDE.md`](docs/VISUAL_GUIDE.md) - Visual guide

## Features

### Core Features
- User registration and authentication
- Role-based access control (Athlete, Trainer, Admin)
- OAuth integration (Google, GitHub)
- Profile management
- Dashboard system
- Email notifications
- Password recovery

### Technical Features
- Rails 8.0.3 with modern asset pipeline
- PostgreSQL database with proper indexing
- Redis caching and background jobs
- Sidekiq for asynchronous processing
- RSpec testing framework
- Playwright E2E testing
- Pundit authorization
- Tailwind CSS for responsive design

## Getting Started

1. Clone the repository
2. Install dependencies: `bundle install`
3. Configure environment: Copy `.env.example` to `.env`
4. Set up database: `rails db:create db:migrate`
5. Start server: `rails server`
6. Visit `http://localhost:3000`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License.
