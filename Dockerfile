# Stage 1: ขั้นตอนการ Build dependencies
FROM python:3.11-slim as builder

WORKDIR /build

# ติดตั้ง dependencies สำหรับการ build (ถ้ามี package ที่ต้อง compile)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY app/requirements.txt .
# ติดตั้ง library ลงใน .local เพื่อเตรียมก๊อปปี้ไปที่ Stage ถัดไป
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: ขั้นตอนการสร้าง Production Image (เน้นขนาดเล็กและปลอดภัย)
FROM python:3.11-slim

WORKDIR /app

# สร้าง User ใหม่เพื่อความปลอดภัย (ไม่ใช้ root ในการรันแอป)
RUN groupadd -r sentinella && useradd -r -g sentinella sentinella

# ก๊อปปี้เฉพาะไฟล์ที่จำเป็นมาจาก builder stage
COPY --from=builder /root/.local /home/sentinella/.local
COPY app/ .

# ตั้งค่า PATH และสิทธิ์การเข้าถึงไฟล์
ENV PATH=/home/sentinella/.local/bin:$PATH
RUN chown -r sentinella:sentinella /app /home/sentinella

# สลับมาใช้ User ที่สร้างไว้
USER sentinella

EXPOSE 8000

# ระบบตรวจสอบสถานะพยาบาลของ Container (Healthcheck)
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# คำสั่งรันแอป
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
