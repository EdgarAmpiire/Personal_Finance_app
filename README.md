# Personal Finance App

A simple personal finance tracker built with Ruby on Rails.  
It supports user authentication, accounts, transactions, and categories, with a dashboard to view your data.

---

## Features

- **Authentication**
  - Sign up / Sign in / Sign out
  - Sessions-based login

- **Accounts**
  - Create and manage multiple accounts (e.g. Cash, Bank, Mobile Money)
  - Account ownership enforced per user

- **Transactions**
  - Create, edit, delete transactions
  - Transactions belong to an account and a category which is optional
  - Amount stored as `amount_cents` (integer) for accuracy

- **Categories**
  - Create categories for classifying transactions (other)
  - Suggested defaults

- **Dashboard**
  - Summary view of your finances (accounts + transactions)

- **Quality / Security**
  - Tests with Minitest
  - Brakeman security scanning
  - RuboCop style checks

---

## Tech Stack

- **Ruby on Rails** (Rails 8)
- **PostgreSQL**
- **TailwindCSS**
- **Minitest**
- **Brakeman**
- **RuboCop**

---

## Requirements

- Ruby (use whatever version your project is configured for)
- Bundler
- PostgreSQL running locally

---

## Setup

### 1) Clone and install gems

```bash
git clone <your-repo-url>
cd personal_finance_app
bundle install
```

### 2) Configure database

- Make sure Postgres is running

```bash
pg-isready
```

- If postgres is not running, start it
```bash
brew services start postgresql@16
pg_isready
```
### 3) Create and migrate database

```bash
bin/rails db:create db:migrate
```

### 4) Start the app

```bash
bin/dev
```
- App runs on:
    http://localhost:3000


## Linting & Security Checks

### Rubocop

```bash
bin/rubocop
```

## Brakeman
```bash
bin/brakeman --no-pager
```

## Notes
- Transactions store the amount as integer cents (amount_cents) to avoid floating-point issues.

- Ownership checks ensure users can only access their own records (accounts, transactions, categories).

- If you get a database connection error, confirm Postgres is running:
```bash
pg_isready
```

## Credits
Built by **Edgar Ampiire** 