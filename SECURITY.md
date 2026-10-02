# Security checklist
- Never put payment merchant secrets in `app.js` or browser storage.
- Keep only Supabase anon/publishable keys in the client; enforce RLS on every table.
- Verify payment webhooks server-side and make them idempotent.
- Rate-limit login, coupons, support and order creation.
- Validate prices server-side; never trust totals submitted by the browser.
- Use Postgres transactions for order creation, coupon redemption and refunds.
- Store only minimum customer data and define retention/deletion policies.
- Require verified roles for admin, restaurant and driver dashboards.
- Use signed upload URLs for restaurant/menu media.
