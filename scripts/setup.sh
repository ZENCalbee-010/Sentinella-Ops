#!/bin/bash

# สคริปต์สำหรับการติดตั้ง Sentinella-Ops ในเครื่อง Local
# ใช้คำสั่งนี้เพื่อเตรียม Environment ทั้งหมดให้พร้อมรัน

echo "🚀 กำลังเริ่มต้นเตรียมระบบ Sentinella-Ops..."

# 1. ตรวจสอบว่ามี Docker ติดตั้งอยู่หรือไม่
if ! [ -x "$(command -v docker)" ]; then
  echo '❌ ข้อผิดพลาด: ไม่พบ Docker โปรดติดตั้งก่อนเริ่มใช้งาน' >&2
  exit 1
fi

# 2. ตรวจสอบว่ามี Docker Compose ติดตั้งอยู่หรือไม่
if ! [ -x "$(command -v docker-compose)" ]; then
  echo '❌ ข้อผิดพลาด: ไม่พบ Docker Compose' >&2
  exit 1
fi

# 3. สร้างไดเรกทอรีที่จำเป็น (ถ้ายังไม่มี)
mkdir -p monitoring/grafana-provisioning/dashboards
mkdir -p monitoring/grafana-provisioning/datasources

# 4. Build และเริ่มการทำงานของ Services ทั้งหมด
echo "📦 กำลัง Build และรัน Services ด้วย Docker Compose..."
docker-compose up -d --build

echo "✅ ติดตั้งสำเร็จ!"
echo "------------------------------------------------"
echo "🌐 API: http://localhost:8000"
echo "📊 Prometheus: http://localhost:9090"
echo "📈 Grafana: http://localhost:3000 (User/Pass: admin/admin)"
echo "------------------------------------------------"
