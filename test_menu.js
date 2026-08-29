const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext({
    viewport: { width: 393, height: 851 } // Pixel 5 dimensions
  });
  const page = await context.newPage();
  
  await page.goto('http://localhost:8080/');
  await page.waitForTimeout(4000); // Wait for loader to disappear
  
  // Click hamburger
  await page.click('.hamburger-menu');
  await page.waitForTimeout(1000); // Wait for drawer animation
  
  // Open dropdown
  await page.click('.drawer-dropdown-btn');
  await page.waitForTimeout(1000); // Wait for accordion animation
  
  await page.screenshot({ path: 'drawer_menu.png' });
  
  await browser.close();
})();
