# RecipeApp

Find your meal.

## Frontend recipe browser

A minimal frontend app is available in `frontend/`.

### Run locally

```bash
cd frontend
python3 -m http.server 4173
```

Then open `http://localhost:4173`.

### API expectations

The UI calls:

- `GET /recipes?q=&locale=`
- `GET /recipes/:id?locale=`

Configure the API base URL in the page (defaults to `http://localhost:3000`).
