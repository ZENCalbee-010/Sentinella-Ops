from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

# เริ่มต้นสร้าง FastAPI App
app = FastAPI(
    title="Sentinella API",
    description="Production-Ready API with Real-time Monitoring",
    version="1.0.0"
)

# Endpoint สำหรับหน้าแรก (Root) เพื่อเช็คว่า API รันได้ปกติ
@app.get("/")
def read_root():
    return {
        "status": "Online",
        "service": "Sentinella-Ops",
        "version": "1.0.0",
        "message": "Welcome to the Secure-CI/CD Pipeline Demo"
    }

# Endpoint สำหรับ Health Check (ใช้ใน Docker และ Deployment)
@app.get("/health")
def health_check():
    return {"status": "healthy", "checks": {"database": "up", "cache": "up"}}

# ตั้งค่าการส่งข้อมูล Metrics ไปที่ Prometheus เพื่อนำไปทำ Dashboard ใน Grafana
Instrumentator().instrument(app).expose(app)
