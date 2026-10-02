# Security
- Never commit Supabase Service Role Key.
- Never put payment provider secrets in browser code.
- Keep payment creation and webhook verification in Edge Functions.
- Review RLS policies before production launch.
- Verify driver identity/documents before enabling live dispatch.
- Add rate limits, fraud checks and audit review before opening public traffic.
