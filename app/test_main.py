from fastapi.testclient import TestClient
from main import app

# สร้าง TestClient เพื่อจำลองการเรียกใช้งาน API
client = TestClient(app)

# ทดสอบว่าหน้าแรก (Root) ทำงานถูกต้อง
def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["status"] == "Online"

# ทดสอบว่าหน้า Health Check ทำงานถูกต้อง
def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

# ทดสอบว่าหน้า Metrics ส่งข้อมูลให้ Prometheus ได้จริง
def test_metrics_endpoint():
    response = client.get("/metrics")
    assert response.status_code == 200
    assert "http_requests_total" in response.text
