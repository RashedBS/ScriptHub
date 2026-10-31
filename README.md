# ScriptHub

A mobile-friendly dark community website for Roblox Lua creators.

## Supabase setup
1. Open your Supabase project → **SQL Editor** → **New query**.
2. Copy the complete current contents of `supabase/schema.sql` into the editor and run it.
3. If you already ran an older version of the schema, run the updated file again to apply the folder and social-permission updates.
4. In **Project Settings → API**, copy the Project URL and public anon/publishable key.

## Website connection
The Supabase Project URL and public publishable key are already configured in `index.html` for the current project. Only use a public anon/publishable key in browser code. Never expose a service_role or secret key.

## Deployment
The site is deployed through Netlify from the `main` branch. New commits should trigger a new deploy automatically. Check the Netlify **Deploys** tab and wait for **Published**.

## Features
- Email/password sign-up and sign-in
- Public and private scripts
- Script, LocalScript, and ModuleScript categories
- Lua editor with syntax highlighting
- Search, personal library, and liked scripts
- Create folders and save scripts into folders
- Like scripts/posts and see like counts
- Comment threads with nested replies
- Like comments and replies
- Folder likes
- Custom in-page folder dialog
- Dark responsive interface, motion effects, and optional button sounds
- Supabase row-level security

## Notes
- Supabase email confirmation may need to be completed before signing in.
- Comments use a generic creator label rather than exposing email addresses.
- Do not publish scripts containing passwords, API keys, private data, or code you do not have permission to share.
- The browser's address bar and navigation controls are part of Chrome/Android and cannot be replaced by website code. ScriptHub's own dialogs and controls are custom website UI.
