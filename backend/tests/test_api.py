from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health_endpoint():
    response = client.get('/api/v1/health')
    assert response.status_code == 200
    assert response.json()['status'] == 'ok'


def test_list_recipes_contract():
    response = client.get('/api/v1/recipes?limit=1')
    assert response.status_code == 200
    data = response.json()
    assert 'items' in data
    assert len(data['items']) == 1
    assert 'nextCursor' in data


def test_recipe_not_found_contract():
    response = client.get('/api/v1/recipes/00000000-0000-0000-0000-000000000000')
    assert response.status_code == 404
    data = response.json()
    assert data['code'] == 'recipe_not_found'
    assert 'traceId' in data


def test_validation_error_contract():
    response = client.get('/api/v1/recipes?limit=1000')
    assert response.status_code == 400
    data = response.json()
    assert data['code'] == 'validation_error'
    assert 'traceId' in data
