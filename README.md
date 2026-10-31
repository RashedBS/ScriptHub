# ScriptHub

A mobile-friendly community website for Roblox Lua creators. Users can create accounts, publish public or private scripts, search scripts, like public scripts, and comment.

## 1. Create your Supabase project
1. Open https://supabase.com/ and create a project.
2. In the project dashboard, open **SQL Editor** → **New query**.
3. Copy all of `supabase/schema.sql` into the editor and run it.
4. Open **Project Settings** → **API** (or **Data API**) and copy the **Project URL** and the public **anon / publishable key**.

## 2. Connect the website
1. Open `index.html`.
2. Find `SUPABASE_URL` and paste your Project URL between the quotes.
3. Find `SUPABASE_ANON_KEY` and paste your public anon/publishable key between the quotes.
4. Save and commit the file.

**Important:** Only use the public anon/publishable key in browser code. Never put your Supabase service_role or secret key in this website.

## 3. Publish on Netlify
1. Open https://app.netlify.com/ and choose **Add new site** → **Import an existing project**.
2. Connect GitHub and choose `RashedBS/ScriptHub`.
3. Set the build command to blank and publish directory to `.`.
4. Deploy. Netlify will publish the files from the `main` branch.

If your existing Netlify site is already connected to this repository, just push commits and Netlify should redeploy automatically.

## Features in this starter
- Email/password sign up and sign in
- Public and private scripts
- Script / LocalScript / ModuleScript types
- Lua editor with syntax highlighting
- Search, personal scripts, liked scripts
- Likes and comments
- Supabase row-level security policies

## Notes
- Supabase email confirmation may need to be confirmed before signing in.
- User profiles are created automatically; comments currently show a generic community label rather than exposing email addresses.
- Do not publish scripts containing secrets, passwords, private data, or code you do not have permission to share.
