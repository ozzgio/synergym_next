const { test, expect } = require('@playwright/test');

// Custom test helpers for our Rails application
class RailsE2EHelper {
  constructor(page) {
    this.page = page;
  }

  // Navigate to a specific path
  async goto(path) {
    await this.page.goto(path);
  }

  // Login with email and password
  async login(email, password) {
    await this.goto('/users/sign_in');
    await this.page.fill('input[name="user[email]"]', email);
    await this.page.fill('input[name="user[password]"]', password);
    await this.page.click('input[type="submit"]');
    await this.page.waitForURL('**/dashboard');
  }

  // Register a new user
  async register(email, password, firstName, lastName) {
    await this.goto('/users/sign_up');
    await this.page.fill('input[name="user[first_name]"]', firstName);
    await this.page.fill('input[name="user[last_name]"]', lastName);
    await this.page.fill('input[name="user[email]"]', email);
    await this.page.fill('input[name="user[password]"]', password);
    await this.page.fill('input[name="user[password_confirmation]"]', password);
    await this.page.click('input[type="submit"]');
  }

  // Logout
  async logout() {
    await this.page.click('a[href="/users/sign_out"]');
  }

  // Check if user is logged in
  async isLoggedIn() {
    return await this.page.locator('a[href="/users/sign_out"]').isVisible();
  }

  // Take screenshot with timestamp
  async takeScreenshot(name) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    await this.page.screenshot({ 
      path: `spec/e2e/screenshots/${name}-${timestamp}.png`,
      fullPage: true 
    });
  }

  // Wait for Rails flash message
  async waitForFlashMessage() {
    await this.page.waitForSelector('.flash, .alert, .notice', { timeout: 5000 });
  }

  // Check for Rails validation errors
  async hasValidationErrors() {
    return await this.page.locator('.field_with_errors, .error').count() > 0;
  }
}

// Extend test with our helper
test.extend({
  railsHelper: async ({ page }, use) => {
    const helper = new RailsE2EHelper(page);
    await use(helper);
  }
});

module.exports = { test, expect, RailsE2EHelper };