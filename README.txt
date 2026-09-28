SK Wi-Fi Portal — Vercel + Supabase

FILES
- index.html: public Wi-Fi portal; announcement is view-only
- admin.html: protected Supabase login + announcement editor
- api/config.js: reads Vercel environment variables
- supabase-setup.sql: database/storage/RLS setup
- vercel.json: /admin route

SETUP
1. In Supabase SQL Editor, run supabase-setup.sql.
2. In Supabase Authentication > Users, create the authorized admin user. Do not put its password in GitHub.
3. In Vercel Project Settings > Environment Variables add:
   SUPABASE_URL = your Supabase project URL
   SUPABASE_ANON_KEY = your Supabase anon/publishable key
   Never add the service_role key to HTML or GitHub.
4. Upload this project to GitHub and deploy/import it in Vercel.
5. Public portal: /
6. Admin portal: /admin

SECURITY
The browser receives only the Supabase anon key. RLS policies protect write operations; only authenticated users can publish/update. The service_role key is not used. For a larger staff team, add an explicit admin-role table/policy rather than authorizing every authenticated account.
