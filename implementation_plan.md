# Implementation Plan: Sentinella-Ops DevOps Toolchain

This plan outlines the steps to build "Sentinella-Ops," a professional-grade DevOps toolchain project featuring a secure CI/CD pipeline, containerized deployment, and real-time observability.

## User Review Required

> [!IMPORTANT]
> **GitHub Secrets**: For the CI/CD pipeline to fully function (pushing to a registry), you will need to configure `DOCKER_USERNAME` and `DOCKER_PASSWORD` (or equivalent for GHCR) in your GitHub repository secrets. I will provide placeholders for these.

> [!NOTE]
> **Port Mapping**: The default setup will use port `8000` for the API, `9090` for Prometheus, and `3000` for Grafana. Ensure these ports are available on your machine.

## Proposed Changes

---

### Phase 1: Application Development
Build the core FastAPI backend with built-in metrics.

#### [NEW] [main.py](file:///c:/GitHub/Sentinella-Ops/app/main.py)
- Implement FastAPI application.
- Integrate `prometheus-fastapi-instrumentator`.
- Define `/`, `/health`, and `/metrics` (auto-exposed) endpoints.

#### [NEW] [test_main.py](file:///c:/GitHub/Sentinella-Ops/app/test_main.py)
- Unit tests using `pytest` and `httpx`.
- Test root and health endpoints.

#### [NEW] [requirements.txt](file:///c:/GitHub/Sentinella-Ops/app/requirements.txt)
- Dependencies: `fastapi`, `uvicorn`, `prometheus-fastapi-instrumentator`, `pytest`, `httpx`.

---

### Phase 2: Containerization & Orchestration
Enable consistent deployment across environments.

#### [NEW] [Dockerfile](file:///c:/GitHub/Sentinella-Ops/Dockerfile)
- Multi-stage build (Builder stage + Final stage).
- Use `python:3.11-slim` for a minimal attack surface.

#### [NEW] [docker-compose.yml](file:///c:/GitHub/Sentinella-Ops/docker-compose.yml)
- Define `app`, `prometheus`, and `grafana` services.
- Configure networking and volumes for persistence.

---

### Phase 3: Observability Configuration
Setup the monitoring stack for real-time insights.

#### [NEW] [prometheus.yml](file:///c:/GitHub/Sentinella-Ops/monitoring/prometheus.yml)
- Configure scrape job for the `app` service.

#### [NEW] [Dashboard & Provisioning](file:///c:/GitHub/Sentinella-Ops/monitoring/grafana-dashboard.json)
- Create a professional Grafana dashboard JSON.
- [NEW] `monitoring/provisioning/datasources/datasource.yml`: Auto-configure Prometheus as a source.
- [NEW] `monitoring/provisioning/dashboards/dashboard_provider.yml`: Auto-load the FastAPI dashboard.

---

### Phase 4: CI/CD Pipeline
Automate testing, security, and delivery.

#### [NEW] [pipeline.yml](file:///c:/GitHub/Sentinella-Ops/.github/workflows/pipeline.yml)
- **CI Phase**: Linting/Testing.
- **Security Phase**: Trivy Vulnerability Scan (Critical/High).
- **Build Phase**: Docker Build/Push (with Tagging).
- **CD Phase**: Simulated deployment notification.

---

### Phase 5: Documentation
Polish the project for a professional portfolio.

#### [NEW] [README.md](file:///c:/GitHub/Sentinella-Ops/README.md)
- Professional project overview.
- Architecture diagram (Mermaid).
- Quickstart guide and technical decisions breakdown.

## Open Questions

1. **Registry Preference**: Should I configure the pipeline to push to **GitHub Container Registry (GHCR)** or **Docker Hub**? GHCR is usually easier as it uses the `GITHUB_TOKEN`.
2. **Infrastructure-as-Code (IaC)**: Would you like me to include a basic **Terraform** script for a cloud instance (e.g., AWS EC2 or DigitalOcean Droplet) at this stage?

## Verification Plan

### Automated Tests
- Run `pytest` locally to verify app logic.
- Run `docker-compose up -d` to verify all services start and communicate.
- Check `localhost:8000/metrics` for Prometheus data.

### Manual Verification
- Access Grafana at `localhost:3000` (admin/admin) and verify the dashboard is pre-populated.
- Verify the GitHub Actions file starts a run upon push (to be done by the user).
