const apiBaseInput = document.getElementById('apiBase');
const searchInput = document.getElementById('search');
const localeInput = document.getElementById('locale');
const loadBtn = document.getElementById('loadBtn');
const recipeList = document.getElementById('recipeList');
const details = document.getElementById('details');

function getDefaultApiBase() {
  const hostMatch = window.location.host.match(/^(.*)-4173(\.app\.github\.dev)$/);
  if (hostMatch) {
    return `https://${hostMatch[1]}-8000${hostMatch[2]}/api/v1`;
  }
  return 'http://localhost:3000';
}

const localApiBase = localStorage.getItem('recipeApiBase');
apiBaseInput.value = localApiBase || getDefaultApiBase();

let recipes = [];
let selectedRecipeId;

function escapeHtml(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

function renderList() {
  if (!recipes.length) {
    recipeList.innerHTML = '<li>No recipes found.</li>';
    return;
  }

  recipeList.innerHTML = recipes
    .map(
      (recipe) => `
      <li class="recipe-item ${recipe.id === selectedRecipeId ? 'active' : ''}" data-id="${escapeHtml(recipe.id)}">
        <strong>${escapeHtml(recipe.title || 'Untitled')}</strong>
        <div class="meta">Prep: ${escapeHtml(recipe.prepTimeMinutes ?? recipe.prep_time_minutes ?? '-') } min</div>
      </li>`
    )
    .join('');
}

function renderDetails(recipe) {
  const ingredients = (recipe.ingredients || [])
    .map((i) => `<li>${escapeHtml(i.quantity ?? '')} ${escapeHtml(i.unit ?? '')} ${escapeHtml(i.ingredient_name ?? i.name ?? '')}</li>`)
    .join('');

  const steps = (recipe.steps || [])
    .map((s) => `<li>${escapeHtml(s.instruction ?? '')}</li>`)
    .join('');

  details.innerHTML = `
    <h3>${escapeHtml(recipe.title || 'Untitled')}</h3>
    <p>${escapeHtml(recipe.description || '')}</p>
    <p class="meta">Servings: ${escapeHtml(recipe.servings ?? '-')}</p>
    <h4>Ingredients</h4>
    <ol>${ingredients || '<li>No ingredients.</li>'}</ol>
    <h4>Steps</h4>
    <ol>${steps || '<li>No steps.</li>'}</ol>
  `;
}

async function loadRecipes() {
  const apiBase = apiBaseInput.value.trim().replace(/\/$/, '');
  const search = searchInput.value.trim();
  const locale = localeInput.value.trim() || 'en';

  if (!apiBase) {
    details.textContent = 'Please provide API base URL.';
    return;
  }

  localStorage.setItem('recipeApiBase', apiBase);
  details.textContent = 'Loading recipes...';

  const url = new URL(`${apiBase}/recipes`);
  if (search) url.searchParams.set('q', search);
  url.searchParams.set('locale', locale);

  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`List request failed (${response.status})`);

    const data = await response.json();
    recipes = Array.isArray(data) ? data : data.items || [];
    selectedRecipeId = recipes[0]?.id;

    renderList();

    if (selectedRecipeId) {
      await loadRecipeDetails(selectedRecipeId);
    } else {
      details.textContent = 'No recipes available.';
    }
  } catch (error) {
    details.textContent = `Unable to load recipes: ${error.message}`;
    recipes = [];
    renderList();
  }
}

async function loadRecipeDetails(recipeId) {
  const apiBase = apiBaseInput.value.trim().replace(/\/$/, '');
  const locale = localeInput.value.trim() || 'en';

  details.textContent = 'Loading details...';

  const url = new URL(`${apiBase}/recipes/${encodeURIComponent(recipeId)}`);
  url.searchParams.set('locale', locale);

  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`Details request failed (${response.status})`);

    const recipe = await response.json();
    selectedRecipeId = recipeId;
    renderList();
    renderDetails(recipe);
  } catch (error) {
    details.textContent = `Unable to load recipe details: ${error.message}`;
  }
}

recipeList.addEventListener('click', async (event) => {
  const item = event.target.closest('[data-id]');
  if (!item) return;
  await loadRecipeDetails(item.dataset.id);
});

loadBtn.addEventListener('click', loadRecipes);

loadRecipes();
