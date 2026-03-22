# RecipeApp

Find your meal.

## What is in this repository?

This repository currently contains:

- a static frontend in `frontend/`
- Supabase/Postgres schema files in `supabase/`

It does **not** currently contain a backend server implementation for `/recipes` and `/recipes/:id`.
That means the frontend can run immediately, but it will only show real data after you point it at a running API.

## How to run the application exactly

### Option 1: Run the frontend locally

From the repository root:
## Frontend recipe browser

A minimal frontend app is available in `frontend/`.

### Run locally

```bash
cd frontend
python3 -m http.server 4173
```

Then open this URL in your browser:

```text
http://localhost:4173
```

When the page opens:

1. Find the **API Base URL** field.
2. Enter the URL of your backend API.
3. Click **Load Recipes**.

If your API is running locally on port `3000`, use:

```text
http://localhost:3000
```

### Option 2: Run the frontend in GitHub Codespaces

From the repository root inside the Codespace terminal:

```bash
cd frontend
python3 -m http.server 4173 --bind 0.0.0.0
```

Then:

1. Open the **Ports** tab in Codespaces.
2. Make sure port `4173` is forwarded.
3. Open the forwarded URL for port `4173`.
4. In the app, set **API Base URL** to your backend URL.

If your backend is also running inside the same Codespace on port `3000`:

1. Forward port `3000` too.
2. Copy the forwarded URL for port `3000`.
3. Paste that URL into **API Base URL**.
4. Click **Load Recipes**.

Example backend URL in Codespaces:

```text
https://<your-codespace-name>-3000.app.github.dev
```

## What backend API the frontend expects

The frontend calls these endpoints:
Then open `http://localhost:4173`.

### API expectations

The UI calls:

- `GET /recipes?q=&locale=`
- `GET /recipes/:id?locale=`

Example list request:

```text
http://localhost:3000/recipes?q=pasta&locale=en
```

Example details request:

```text
http://localhost:3000/recipes/123?locale=en
```

## Important note

If you only start the static frontend server, the page will load but recipe requests will fail until a real backend API is available.
Configure the API base URL in the page (defaults to `http://localhost:3000`).
