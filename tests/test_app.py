def test_get_request(client):
    response = client.get("/")
    assert b"<title>Medication List</title>" in response.data
    assert b"<h1>Medication List</h1>" in response.data


def test_post_request(client):
    response = client.post("/add",  follow_redirects=True, data={
        "name": "ibuprofen",
        "dosage": "200mg",
    })
    assert response.status_code == 200
