const { test, expect } = require('../test_helper');

test.describe('Setup Verification', () => {
  test('should verify Rails application is running', async ({ page, railsHelper }) => {
    // Navigate to home page
    await railsHelper.goto('/');
    await railsHelper.takeScreenshot('home-page-verification');

    // Check if the page loads successfully
    await expect(page.locator('body')).toBeVisible();
    
    // Check for common Rails elements
    const title = await page.title();
    expect(title).toBeTruthy();
    
    // Look for navigation or main content
    const hasNavigation = await page.locator('nav, .navigation, header').count() > 0;
    const hasMainContent = await page.locator('main, .main, .content').count() > 0;
    
    expect(hasNavigation || hasMainContent).toBeTruthy();
  });

  test('should verify authentication pages are accessible', async ({ page, railsHelper }) => {
    // Test login page
    await railsHelper.goto('/users/sign_in');
    await railsHelper.takeScreenshot('login-page-verification');
    
    // Check for login form elements
    await expect(page.locator('input[name*="email"]')).toBeVisible();
    await expect(page.locator('input[name*="password"]')).toBeVisible();
    await expect(page.locator('input[type="submit"]')).toBeVisible();

    // Test registration page
    await railsHelper.goto('/users/sign_up');
    await railsHelper.takeScreenshot('registration-page-verification');
    
    // Check for registration form elements
    await expect(page.locator('input[name*="email"]')).toBeVisible();
    await expect(page.locator('input[name*="password"]')).toBeVisible();
    await expect(page.locator('input[type="submit"]')).toBeVisible();
  });

  test('should verify screenshot functionality', async ({ page, railsHelper }) => {
    await railsHelper.goto('/');
    
    // Take a test screenshot
    await railsHelper.takeScreenshot('setup-verification-test');
    
    // If we get here without errors, screenshot functionality works
    expect(true).toBeTruthy();
  });

  test('should verify test helper functionality', async ({ page, railsHelper }) => {
    await railsHelper.goto('/');
    
    // Test helper methods
    const isLoggedIn = await railsHelper.isLoggedIn();
    expect(typeof isLoggedIn).toBe('boolean');
    
    // Test navigation
    await railsHelper.goto('/users/sign_in');
    const currentUrl = page.url();
    expect(currentUrl).toContain('/users/sign_in');
  });
});