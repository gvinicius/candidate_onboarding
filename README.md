# Candidate Onboarding

Dental recruitment candidate onboarding platform. Candidates upload their CV, Anthropic AI parses it, and they review/complete their profile.

## Stack

- **Ruby** 3.3.4
- **Rails** 8.1.3
- **PostgreSQL** 16+

## Setup

```bash
bundle install
bin/rails db:create db:migrate db:seed
```

## Run

```bash
bin/rails server
```

Set `ANTHROPIC_API_KEY` in your environment or enter it on the upload screen.

## Tests

```bash
# RSpec (unit + request specs)
DB_PASSWORD=postgres bundle exec rspec

# Playwright E2E
DB_PASSWORD=postgres npx playwright test
```
