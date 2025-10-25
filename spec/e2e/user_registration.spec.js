const { test, expect } = require('../test_helper');

test.describe('User Registration', () => {
  test.beforeEach(async ({ page }) => {
    // Clear any existing session
    await page.context().clearCookies();
  });

  test('should allow a new user to register successfully', async ({ page, railsHelper }) => {
    const timestamp = Date.now();
    const userEmail = `testuser${timestamp}@example.com`;
    const firstName = 'Test';
    const lastName = 'User';
    const password = 'Password123!';

    await railsHelper.goto('/users/sign_up');
    await railsHelper.takeScreenshot('registration-page');

    // Fill out the registration form
    await page.fill('input[name="user[first_name]"]', firstName);
    await page.fill('input[name="user[last_name]"]', lastName);
    await page.fill('input[name="user[email]"]', userEmail);
    await page.fill('input[name="user[password]"]', password);
    await page.fill('input[name="user[password_confirmation]"]', password);
    
    await railsHelper.takeScreenshot('registration-form-filled');

    // Submit the form
    await page.click('input[type="submit"]');
    
    // Wait for redirect to dashboard or success message
    await page.waitForURL('**/dashboard', { timeout: 10000 });
    await railsHelper.takeScreenshot('registration-success');

    // Verify user is logged in
    expect(await railsHelper.isLoggedIn()).toBeTruthy();
    
    // Check for welcome message or successful registration
    await expect(page.locator('h1, .welcome, .flash')).toBeVisible();
  });

  test('should show validation errors for invalid registration data', async ({ page, railsHelper }) => {
    await railsHelper.goto('/users/sign_up');

    // Try to submit empty form
    await page.click('input[type="submit"]');
    await railsHelper.takeScreenshot('registration-validation-errors');

    // Check for validation errors
    expect(await railsHelper.hasValidationErrors()).toBeTruthy();
    
    // Check for error messages
    await expect(page.locator('.field_with_errors, .error')).toBeVisible();
  });

  test('should show error for duplicate email', async ({ page, railsHelper }) => {
    const userEmail = 'duplicate@example.com';
    const password = 'Password123!';

    await railsHelper.goto('/users/sign_up');

    // Fill out form with existing email
    await page.fill('input[name="user[first_name]"]', 'Existing');
    await page.fill('input[name="user[last_name]"]', 'User');
    await page.fill('input[name="user[email]"]', userEmail);
    await page.fill('input[name="user[password]"]', password);
    await page.fill('input[name="user[password_confirmation]"]', password);
    
    await page.click('input[type="submit"]');
    
    // Should show error for existing email
    await railsHelper.waitForFlashMessage();
    await railsHelper.takeScreenshot('registration-duplicate-email-error');
    
    // Check for error message
    await expect(page.locator('.alert, .error')).toContainText('email');
  });
});