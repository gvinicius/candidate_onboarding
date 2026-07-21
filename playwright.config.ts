import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./tests/e2e",
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: 1,
  reporter: "html",
  use: {
    baseURL: "http://localhost:3001",
    trace: "on-first-retry",
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
  ],
  webServer: {
    command: "RAILS_ENV=test DB_PASSWORD=postgres bin/rails db:seed && RAILS_ENV=test DB_PASSWORD=postgres bin/rails server -p 3001",
    url: "http://localhost:3001/up",
    reuseExistingServer: !process.env.CI,
    timeout: 30000,
  },
});
