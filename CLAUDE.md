# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Rails 7.2.2.1** event management system ("Lodging" application) built with **Ruby 3.3.6** and **PostgreSQL**. The primary domain is managing events with multiple modalities, participants, accommodations (stays), payments, and air tickets. The application tracks billing, generates reports, and manages participant deposits.

## Tech Stack

- **Framework**: Rails 7.2.2.1
- **Language**: Ruby 3.3.6
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Authorization**: CanCanCan
- **View Layer**: Slim templates, Bootstrap 3
- **Frontend**: jQuery, Backbone.js, CoffeeScript, Turbolinks
- **Key Gems**: Draper (decorators), Paranoia (soft deletes), Kaminari (pagination), CarrierWave (file uploads), Annotate (schema comments)
- **Database Features**: Observers (bed_observer), paranoid deletion, change logs
- **Locale**: Spanish (es) by default, timezone: Bogota

## Core Models & Relationships

### Main Domain Models
- **Event**: Represents a gathering with date range, places, and modalities. Uses soft deletes (paranoia). Delegates display logic to EventDecorator.
- **Modality**: A variant/track within an event (e.g., different program options). Has spaces and belongs to event.
- **Participant**: A guest enrolled in event modalities. Has spaces, payments, stays, air_ticket. Tracks deposit_state (pending/given/refunded).
- **Guest**: Core person record. Can have multiple participants. Supports auto_edit/auto_update actions for self-service updates.
- **Space**: Instance of a modality for a participant. Has amount (cost). Participates in billing calculations.
- **Payment**: Billable item with reason (Evento/Estadia) and amount. Polymorphic (belongs to Participant or Booking).
- **Stay**: Accommodation with start_at, end_at, and per-diem amount. Participates in stay billing.
- **AirTicket**: Flight booking for a participant.

### Hosting/Infrastructure Models
- **Booking**: Accommodations reservation (legacy or guest-facing). Has payments, next_deposit_state actions.
- **House**: Property with rooms.
- **Room**: Within a house, contains beds.
- **Bed**: Physical accommodation unit.
- **Location**: Geographic/venue reference. Has a calendar view.
- **Place**: Physical venue associated with events.

### Audit Models
- **ChangeLog**: Polymorphic audit log. Created on participant add/remove; can be marked reviewed. Associates with events for deletion tracking.
- **Configuration**: Settings or feature toggles.

## Key Conventions

### Scopes & Filtering
Participants and events have extensive scope chains (by_modality, by_guest, by_country, by_outside, after_date, by_international, by_confirmed). These are commonly chained in controller queries and reports.

### Decorators
Models delegate view-layer formatting to decorators:
- `Event#decorator` → `EventDecorator`
- `Participant#decorator` → `ParticipantDecorator`

Use decorators for currency display, date formatting, and human-readable labels.

### Deposit State Machine
Participants have a simple state machine: pending → given → refunded → pending. Helper methods: `deposit_pending?`, `deposit_given?`, `deposit_refunded?`. Use `#next_deposit_state` and `#next_deposit_state_action` for workflows.

### Billing Logic
All amounts are in a shared currency (not specified in schema; assume local). Calculate totals via sum queries on spaces/stays/payments, grouped by reason (Evento vs. Estadia). Due amounts = spaces/stays minus corresponding payments.

## Running the Application

### Setup
```bash
bundle install
rails db:create db:migrate
```

### Development Server
```bash
rails s
# OR use the provided start_server script (requires sudo, starts PostgreSQL)
./start_server
```
Server runs on http://localhost:3000. Uses Puma per config/puma.rb.

### Database
PostgreSQL. Migrations stored in `db/migrate/`. Schema format is SQL (`schema.sql`), not Ruby. Database names: events_development, events_test, events_production. Current user in config/database.yml: `cesarvalderrama`.

### Environment Variables
Configure in `.env` or `config/environments/*`. Timezone and locale set in `config/application.rb`.

## Testing

### Minitest (Primary)
Tests live in `test/` directory using Rails default Minitest.
```bash
# Run all tests
rails test

# Run a single test file
rails test test/models/participant_test.rb

# Run a specific test
rails test test/models/participant_test.rb:ParticipantTest::test_confirmation
```
Fixtures defined in `test/fixtures/*.yml`. Helper setup in `test/test_helper.rb`.

### RSpec (Secondary/Legacy)
RSpec files exist in `spec/` (factories, models, rails_helper) but RSpec is **not in Gemfile.lock**. If RSpec is needed, add it. Current setup uses Minitest.

### Running Database Tests
Ensure database is created for test environment:
```bash
RAILS_ENV=test rails db:create db:migrate
```

## Routes & Controllers

### Key Route Groups
- **Events**: Full CRUD + custom actions (new_import, import, report_detail, report_general, report_composition, report_payment_methods, duplicate).
- **Participants**: Nested under events. Nested resources: air_tickets, payments, stays.
- **Guests**: Full CRUD + auto_edit/auto_update for self-service. Not_access_allowed and auto_update_success actions.
- **Bookings**: Standalone; next_deposit_state action. Nested payments.
- **Accommodations**: Places, Houses, Rooms, Beds, Locations (with calendar view).
- **Reports**: Namespace for reporting; bookings index and monthly_guests collection action.
- **Auth**: Devise routes for user sessions/registrations (custom controllers in app/controllers/users/).

### Root Route
`root 'bookings#index'` — landing page displays bookings.

## Reporting

Reports generate summaries for admin and event organizers:
- **report_detail**: Per-event participant detail.
- **report_general**: Event-level overview.
- **report_composition**: Breakdown by participant type/category.
- **report_payment_methods**: Aggregated by payment method (Evento, Estadia, Sede, etc.).
- **monthly_guests**: Historical guest bookings.

Reports use gem 'caxlsx' and 'caxlsx_rails' for Excel export. Decorators format display values.

## File Organization

```
app/
  controllers/       # 23 controllers, plus users/* for Devise
  models/            # 26 core models
  views/             # Views organized by controller
  decorators/        # Draper decorators for model display logic
  helpers/           # Controller helpers
  observers/         # bed_observer for Side effects
  uploaders/         # CarrierWave uploaders
  assets/            # CSS, JS, images
config/
  routes.rb          # Route definitions
  database.yml       # Database config (update credentials for new envs)
  puma.rb            # Server config
  environments/      # Environment-specific settings
  initializers/      # Rails initializers
db/
  migrate/           # Migrations (SQL format, run via rake db:migrate)
spec/               # RSpec tests (legacy; not installed)
test/               # Minitest tests (primary), fixtures
lib/                # Custom libraries and tasks
public/             # Static assets, uploads
```

## Common Tasks

### Adding a Participant to an Event
1. Requires guest record with valid billing data (name, email, country).
2. Create participant linked to guest.
3. Create participant_spaces to associate with modalities.
4. Participant can have stays, payments, air_ticket.
5. Decorator renders display values (amounts, dates, due totals).

### Generating a Report
1. Controller fetches scoped participants/bookings.
2. Decorator aggregates/formats data.
3. XLSX export via caxlsx_rails (see existing report actions).
4. Change logs auditable events; mark reviewed if appropriate.

### Schema Changes
Migrations use SQL format. After migration, run `bundle exec annotate --models` to update schema comments in model files.

### Authorization
CanCanCan defines user abilities in `app/models/ability.rb`. Check current_user permissions before controller actions.

## Important Notes

### Locale & Internationalization
All UI text should reference Spanish locale. Date/currency formatting via decorators. Time zone: Bogota (UTC-5).

### Soft Deletes
Models using `acts_as_paranoid` (Event, Participant, et al.) are never truly deleted—only marked deleted. Queries exclude soft-deleted records by default; use `with_deleted` scope if needed.

### Change Tracking
ParticipantDecorator and ChangeLog handle audit trails. Participant creation/destruction logged via `add_create_log` / `add_destroy_log` callbacks. Author tracked via `author_id` attr_accessor.

### Payment Calculations
Payment reason field is a string (Evento, Estadia, Sede). Always sum by reason when splitting event vs. accommodation costs. Reconcile against spaces/stays amounts to calculate due balances.

### Database Credentials
`config/database.yml` hardcodes user as `cesarvalderrama`. Update for your local setup or use environment variable override (e.g., `PGUSER` env var).
