const { test, expect } = require('../test_helper');

test.describe('User Login', () => {
  test.beforeEach(async ({ page }) => {
    // Clear any existing session
    await page.context().clearCookies();
  });

  test('should allow a registered user to login successfully', async ({ page, railsHelper }) => {
    const userEmail = 'test@example.com';
    const password = 'Password123!';

    await railsHelper.goto('/users/sign_in');
    await railsHelper.takeScreenshot('login-page');

    // Fill out the login form
    await page.fill('input[name="user[email]"]', userEmail);
    await page.fill('input[name="user[password]"]', password);
    
    await railsHelper.takeScreenshot('login-form-filled');

    // Submit the form
    await page.click('input[type="submit"]');
    
    // Wait for redirect to dashboard
    await page.waitForURL('**/dashboard', { timeout: 10000 });
    await railsHelper.takeScreenshot('login-success');

    // Verify user is logged in
    expect(await railsHelper.isLoggedIn()).toBeTruthy();
    
    // Check for dashboard content
    await expect(page.locator('h1, .dashboard')).toBeVisible();
  });

  test('should show error for invalid credentials', async ({ page, railsHelper }) => {
    await railsHelper.goto('/users/sign_in');

    // Fill out form with invalid credentials
    await page.fill('input[name="user[email]"]', 'invalid@example.com');
    await page.fill('input[name="user[password]"]', 'wrongpassword');
    
    await page.click('input[type="submit"]');
    
    // Wait for error message
    await railsHelper.waitForFlashMessage();
    await railsHelper.takeScreenshot('login-invalid-credentials-error');
    
    // Check for error message
    await expect(page.locator('.alert, .error')).toBeVisible();
    
    // Verify user is not logged in
    expect(await railsHelper.isLoggedIn()).toBeFalsy();
  });

  test('should show validation errors for empty form', async ({ page, railsHelper }) => {
    await railsHelper.goto('/users/sign_in');

    // Try to submit empty form
    await page.click('input[type="submit"]');
    await railsHelper.takeScreenshot('login-validation-errors');

    // Check for validation errors
    expect(await railsHelper.hasValidationErrors()).toBeTruthy();
  });

  test('should allow user to logout', async ({ page, railsHelper }) => {
    const userEmail = 'test@example.com';
    const password = 'Password123!';

    // First login
    await railsHelper.login(userEmail, password);
    expect(await railsHelper.isLoggedIn()).toBeTruthy();
    
    await railsHelper.takeScreenshot('before-logout');

    // Logout
    await railsHelper.logout();
    
    // Wait for redirect to home page
    await page.waitForURL('**/', { timeout: 10000 });
    await railsHelper.takeScreenshot('after-logout');

    // Verify user is logged out
    expect(await railsHelper.isLoggedIn()).toBeFalsy();
    
    // Check for login link
    await expect(page.locator('a[href="/users/sign_in"]')).toBeVisible();
  });
});