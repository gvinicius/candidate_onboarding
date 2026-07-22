import { test, expect } from "@playwright/test";
import path from "path";

test.describe("Candidate Onboarding — CV Upload", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/");
  });

  test("shows upload screen on root", async ({ page }) => {
    await expect(page).toHaveTitle(/Upload your CV/i);
    await expect(page.getByText("Start your application")).toBeVisible();
    await expect(page.getByText("Drag & drop your CV here")).toBeVisible();
  });

  test("shows file type info", async ({ page }) => {
    await expect(page.getByText("PDF, DOC, DOCX")).toBeVisible();
    await expect(page.getByText("25 MB")).toBeVisible();
  });

  test("has consent checkbox", async ({ page }) => {
    const consent = page.locator("#consent_checkbox");
    await expect(consent).toBeVisible();
  });

  test("has Continue manually link", async ({ page }) => {
    const link = page.getByRole("link", { name: /continue manually/i });
    await expect(link).toBeVisible();
  });

  test("Continue manually navigates to profile", async ({ page }) => {
    await page.getByRole("link", { name: /continue manually/i }).click();
    await expect(page).toHaveURL(/\/onboarding\/profile/);
    await expect(page.getByText("Review & Complete Profile")).toBeVisible();
  });

  test("full upload flow: PDF → redirects to profile", async ({ page }) => {
    const fileInput = page.locator("input[type='file']");
    await fileInput.setInputFiles(path.join(__dirname, "../../spec/fixtures/files/sample.pdf"));
    await expect(page.getByText("sample.pdf")).toBeVisible();

    await page.locator("#consent_checkbox").check();

    await page.getByRole("button", { name: /analyse cv/i }).click();

    // Upload → status (job runs inline in test) → immediate redirect to profile
    await expect(page).toHaveURL(/\/onboarding\/profile/, { timeout: 15000 });
    await expect(page.getByText("Review & Complete Profile")).toBeVisible();
    await expect(page.locator("input[name='candidate_profile[first_name]']")).toHaveValue("Test");
  });
});

test.describe("Candidate Onboarding — Profile Form", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/onboarding/profile");
  });

  test("shows all sections", async ({ page }) => {
    await expect(page.getByText("1. Personal Details")).toBeVisible();
    await expect(page.getByText("2. Job Preferences")).toBeVisible();
    await expect(page.getByText("3. Employment & Compensation")).toBeVisible();
    await expect(page.getByText("4. Education")).toBeVisible();
    await expect(page.getByText("5. Work Experience")).toBeVisible();
    await expect(page.getByText("6. Skills")).toBeVisible();
    await expect(page.getByText("7. Availability")).toBeVisible();
    await expect(page.getByText("8. Additional Information")).toBeVisible();
  });

  test("save button is present", async ({ page }) => {
    await expect(page.getByRole("button", { name: /save profile/i })).toBeVisible();
  });

  test("can fill and submit personal details", async ({ page }) => {
    await page.fill("input[name='candidate_profile[first_name]']", "Jan");
    await page.fill("input[name='candidate_profile[last_name]']", "de Vries");
    await page.fill("input[name='candidate_profile[email]']", "jan@example.com");
    await page.fill("input[name='candidate_profile[city]']", "Amsterdam");

    await expect(page.locator("input[name='candidate_profile[first_name]']")).toHaveValue("Jan");
  });

  test("job function select shows options", async ({ page }) => {
    const select = page.locator("select[name='candidate_profile[job_function_id]']");
    await expect(select).toBeVisible();
    const options = (await select.locator("option").allTextContents()).map(t => t.trim());
    expect(options).toContain("Dental hygienist");
    expect(options).toContain("General dentist");
  });

  test("can add education entry", async ({ page }) => {
    const addBtn = page.getByRole("button", { name: /add education/i });
    await expect(addBtn).toBeVisible();
  });

  test("can add work experience entry", async ({ page }) => {
    const addBtn = page.getByRole("button", { name: /add work experience/i });
    await expect(addBtn).toBeVisible();
  });
});
