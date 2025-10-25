const { test, expect } = require('../test_helper');

test.describe('Dashboard Navigation', () => {
  test.beforeEach(async ({ page }) => {
    // Clear any existing session
    await page.context().clearCookies();
  });

  test.describe('Athlete Dashboard', () => {
    test('should display athlete-specific content', async ({ page, railsHelper }) => {
      const userEmail = 'athlete@example.com';
      const password = 'Password123!';

      // Login as athlete
      await railsHelper.login(userEmail, password);
      await railsHelper.takeScreenshot('athlete-dashboard');

      // Check for athlete-specific elements
      await expect(page.locator('h1')).toContainText('Athlete');
      
      // Check for navigation elements specific to athletes
      await expect(page.locator('nav, .navigation')).toBeVisible();
      
      // Check for common dashboard elements
      await expect(page.locator('.dashboard, .profile, .stats')).toBeVisible();
    });

    test('should allow navigation to athlete-specific sections', async ({ page, railsHelper }) => {
      const userEmail = 'athlete@example.com';
      const password = 'Password123!';

      await railsHelper.login(userEmail, password);
      
      // Test navigation to different sections
      const navigationLinks = page.locator('nav a, .navigation a');
      const linkCount = await navigationLinks.count();
      
      for (let i = 0; i < linkCount; i++) {
        const link = navigationLinks.nth(i);
        const href = await link.getAttribute('href');
        
        if (href && !href.includes('sign_out')) {
          await link.click();
          await page.waitForLoadState('networkidle');
          await railsHelper.takeScreenshot(`athlete-navigation-${i}`);
          
          // Verify page loaded successfully
          await expect(page.locator('body')).toBeVisible();
        }
      }
    });
  });

  test.describe('Trainer Dashboard', () => {
    test('should display trainer-specific content', async ({ page, railsHelper }) => {
      const userEmail = 'trainer@example.com';
      const password = 'Password123!';

      // Login as trainer
      await railsHelper.login(userEmail, password);
      await railsHelper.takeScreenshot('trainer-dashboard');

      // Check for trainer-specific elements
      await expect(page.locator('h1')).toContainText('Trainer');
      
      // Check for trainer-specific features
      await expect(page.locator('.clients, .athletes, .training-plans')).toBeVisible();
    });

    test('should allow access to trainer management features', async ({ page, railsHelper }) => {
      const userEmail = 'trainer@example.com';
      const password = 'Password123!';

      await railsHelper.login(userEmail, password);
      
      // Look for trainer-specific management features
      const managementElements = page.locator('[data-testid*="manage"], .manage, .admin, .clients');
      
      if (await managementElements.count() > 0) {
        await managementElements.first().click();
        await page.waitForLoadState('networkidle');
        await railsHelper.takeScreenshot('trainer-management-feature');
        
        // Verify management interface loaded
        await expect(page.locator('body')).toBeVisible();
      }
    });
  });

  test.describe('Admin Dashboard', () => {
    test('should display admin-specific content', async ({ page, railsHelper }) => {
      const userEmail = 'admin@example.com';
      const password = 'Password123!';

      // Login as admin
      await railsHelper.login(userEmail, password);
      await railsHelper.takeScreenshot('admin-dashboard');

      // Check for admin-specific elements
      await expect(page.locator('h1')).toContainText('Admin');
      
      // Check for admin-specific features
      await expect(page.locator('.admin-panel, .users, .settings, .reports')).toBeVisible();
    });

    test('should allow access to administrative functions', async ({ page, railsHelper }) => {
      const userEmail = 'admin@example.com';
      const password = 'Password123!';

      await railsHelper.login(userEmail, password);
      
      // Look for administrative functions
      const adminElements = page.locator('[data-testid*="admin"], .admin, .settings, .users');
      
      if (await adminElements.count() > 0) {
        await adminElements.first().click();
        await page.waitForLoadState('networkidle');
        await railsHelper.takeScreenshot('admin-function');
        
        // Verify admin interface loaded
        await expect(page.locator('body')).toBeVisible();
      }
    });
  });

  test('should prevent access to unauthorized dashboards', async ({ page, railsHelper }) => {
    const userEmail = 'athlete@example.com';
    const password = 'Password123!';

    // Login as athlete
    await railsHelper.login(userEmail, password);
    
    // Try to access admin dashboard directly
    await page.goto('/dashboard/admin');
    await railsHelper.takeScreenshot('unauthorized-admin-access');
    
    // Should be redirected or shown error
    const currentUrl = page.url();
    expect(currentUrl).not.toContain('/dashboard/admin');
    
    // Check for error or redirect
    const hasError = await page.locator('.error, .alert, .unauthorized').count() > 0;
    const isRedirected = await page.locator('h1').isVisible();
    
    expect(hasError || isRedirected).toBeTruthy();
  });
});