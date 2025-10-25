# E2E Testing with Playwright MCP Server

This directory contains end-to-end tests for the SynergyM application using the Playwright MCP server.

## Setup

The E2E tests are configured to work with the Playwright MCP server, which provides browser automation capabilities without requiring local Playwright installation.

## Test Structure

- `test_helper.js` - Custom helper class with Rails-specific methods
- `user_registration.spec.js` - Tests for user registration flow
- `user_login.spec.js` - Tests for user login/logout functionality
- `dashboard_navigation.spec.js` - Tests for dashboard navigation by user role
- `authentication_flow.spec.js` - Complete authentication cycle tests
- `screenshots/` - Directory for test screenshots (auto-generated)

## Running Tests

Tests are executed using the Playwright MCP server tools:

1. Start your Rails development server:
   ```bash
   bundle exec rails server -p 3000
   ```

2. Use the MCP Playwright server to run tests:
   - Navigate to application pages
   - Fill forms and interact with UI elements
   - Take screenshots for validation

## Test Features

### Screenshot Capture
- Screenshots are automatically captured at key test steps
- Screenshots are saved with timestamps in the `screenshots/` directory
- Full-page screenshots are taken for comprehensive visibility

### User Role Testing
- Tests cover different user roles: athlete, trainer, admin
- Role-specific dashboard content verification
- Authorization and access control testing

### Authentication Testing
- Complete registration flow
- Login/logout functionality
- Session management
- Password reset flow
- Protected route verification

## Configuration

The `playwright.config.js` file contains:
- Base URL configuration (http://localhost:3000)
- Browser settings (Chrome, Firefox, Safari)
- Screenshot and video capture settings
- Automatic Rails server startup for tests

## Test Data

Tests use timestamped email addresses to avoid conflicts:
- `testuser${timestamp}@example.com`
- `flowtest${timestamp}@example.com`

## Best Practices

1. Tests use the custom `RailsE2EHelper` class for consistent interactions
2. Each test includes screenshot capture for visual verification
3. Tests are isolated and clean up session data between runs
4. Page elements are selected using semantic selectors when possible

## Debugging

- Screenshots are captured on failures and key steps
- Test names include timestamps for easy identification
- Visual regression can be performed by comparing screenshots