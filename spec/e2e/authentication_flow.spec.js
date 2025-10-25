const { test, expect } = require('../test_helper');

test.describe('Authentication Flow', () => {
  test.beforeEach(async ({ page }) => {
    // Clear any existing session
    await page.context().clearCookies();
  });

  test('should complete full authentication cycle', async ({ page, railsHelper }) => {
    const timestamp = Date.now();
    const userEmail = `flowtest${timestamp}@example.com`;
    const firstName = 'Flow';
    const lastName = 'Test';
    const password = 'Password123!';

    // Start at home page
    await railsHelper.goto('/');
    await railsHelper.takeScreenshot('home-page');

    // Navigate to registration
    await page.click('a[href="/users/sign_up"]');
    await railsHelper.takeScreenshot('navigate-to-registration');

    // Register new user
    await railsHelper.register(userEmail, password, firstName, lastName);
    await railsHelper.takeScreenshot('registration-complete');

    // Verify user is logged in after registration
    expect(await railsHelper.isLoggedIn()).toBeTruthy();

    // Logout
    await railsHelper.logout();
    await railsHelper.takeScreenshot('after-logout');

    // Verify user is logged out
    expect(await railsHelper.isLoggedIn()).toBeFalsy();

    // Login again
    await railsHelper.login(userEmail, password);
    await railsHelper.takeScreenshot('login-after-logout');

    // Verify user is logged in again
    expect(await railsHelper.isLoggedIn()).toBeTruthy();

    // Navigate to dashboard
    await page.goto('/dashboard');
    await railsHelper.takeScreenshot('dashboard-after-login');

    // Verify dashboard content
    await expect(page.locator('h1, .dashboard')).toBeVisible();
  });

  test('should handle session persistence', async ({ page, railsHelper }) => {
    const userEmail = 'session@example.com';
    const password = 'Password123!';

    // Login
    await railsHelper.login(userEmail, password);
    expect(await railsHelper.isLoggedIn()).toBeTruthy();

    // Navigate to different pages
    await page.goto('/');
    await railsHelper.takeScreenshot('home-while-logged-in');

    // Check if user is still logged in
    expect(await railsHelper.isLoggedIn()).toBeTruthy();

    // Navigate back to dashboard
    await page.goto('/dashboard');
    await railsHelper.takeScreenshot('dashboard-return');

    // Verify still logged in
    expect(await railsHelper.isLoggedIn()).toBeTruthy();
  });

  test('should handle password reset flow', async ({ page, railsHelper }) => {
    const userEmail = 'reset@example.com';

    // Navigate to login page
    await railsHelper.goto('/users/sign_in');
    
    // Click forgot password link
    await page.click('a[href*="password"], a[href*="reset"]');
    await railsHelper.takeScreenshot('forgot-password-page');

    // Fill in email for password reset
    await page.fill('input[name*="email"]', userEmail);
    await page.click('input[type="submit"]');
    await railsHelper.takeScreenshot('password-reset-requested');

    // Should show confirmation message
    await expect(page.locator('.notice, .flash, .success')).toBeVisible();
  });

  test('should handle OAuth/Google authentication if available', async ({ page, railsHelper }) => {
    await railsHelper.goto('/users/sign_in');
    await railsHelper.takeScreenshot('login-with-oauth');

    // Check if OAuth buttons are present
    const oauthButton = page.locator('a[href*="google"], a[href*="oauth"], button[data-provider]');
    
    if (await oauthButton.count() > 0) {
      // Note: Actual OAuth testing would require additional setup
      // This test just verifies the button is present
      await expect(oauthButton.first()).toBeVisible();
      await railsHelper.takeScreenshot('oauth-button-present');
    } else {
      // Skip OAuth test if not configured
      test.skip();
    }
  });

  test('should protect authenticated routes', async ({ page, railsHelper }) => {
    // Try to access dashboard without logging in
    await railsHelper.goto('/dashboard');
    await railsHelper.takeScreenshot('protected-route-redirect');

    // Should be redirected to login page
    const currentUrl = page.url();
    expect(currentUrl).toContain('/users/sign_in');

    // Try to access other protected routes
    const protectedRoutes = [
      '/dashboard/athlete',
      '/dashboard/trainer',
      '/dashboard/admin'
    ];

    for (const route of protectedRoutes) {
      await page.goto(route);
      await page.waitForTimeout(1000); // Wait for potential redirect
      
      const url = page.url();
      // Should redirect to login or show error
      expect(url.includes('/users/sign_in') || await page.locator('.error, .unauthorized').count() > 0).toBeTruthy();
    }
  });

  test('should handle session expiration gracefully', async ({ page, railsHelper }) => {
    const userEmail = 'session@example.com';
    const password = 'Password123!';

    // Login
    await railsHelper.login(userEmail, password);
    expect(await railsHelper.isLoggedIn()).toBeTruthy();

    // Clear session cookies to simulate expiration
    await page.context().clearCookies();
    
    // Try to access protected route
    await page.goto('/dashboard');
    await page.waitForTimeout(2000);
    await railsHelper.takeScreenshot('session-expired');

    // Should be redirected to login
    const currentUrl = page.url();
    expect(currentUrl).toContain('/users/sign_in');
    
    // Should show message about session expiration
    const hasFlashMessage = await page.locator('.alert, .notice, .flash').count() > 0;
    // Note: This depends on application implementation
  });
});