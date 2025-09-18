# 🟣 GenLayer Validator – Dockerized Setup

This repository provides a **Dockerized setup** for running a **GenLayer Validator Node** with GenVM modules and WebDriver support.

Running a validator ensures the **security and reliability** of the GenLayer network.  
This guide shows how to set up your node in containers using `docker-compose`.

---

## 📂 Directory Layout

```bash
genlayer-validator/
├── Dockerfile
├── docker-compose.yml
├── README.md
├── configs/
│   └── node/
│       └── config.yaml        # Node configuration (must edit before running)
├── data/                      # Chain state & validator keys
└── logs/                      # Rotated logs
```

---

## ⚙️ System Requirements

- **OS:** 64-bit Linux (Ubuntu/Debian/CentOS)
- **RAM:** 16 GB+
- **CPU:** 8 cores / 16 threads
- **Storage:** 128 GB SSD/NVMe
- **Network:** 100 Mbps+ (1 Gbps recommended)
- **GPU:** *Optional* (only if running LLM locally)

---

## 🛠️ Setup

### 1. Clone Repository

```bash
git clone https://github.com/your-org/genlayer-validator-docker.git
cd genlayer-validator-docker
```

### 2. Configure Node

Edit the file:

```bash
configs/node/config.yaml
```

At minimum, update:

```yaml
rollup:
  zksyncurl: "https://your-zksync-rpc"
  zksyncwebsocketurl: "wss://your-zksync-ws"
```

### 3. Environment Variables

Create a `.env` file to store secrets:

```bash
NODE_PASSWORD=your_node_password
HEURISTKEY=your_heurist_api_key
COMPUT3KEY=your_comput3_api_key
IOINTELLIGENCE_API_KEY=your_ionet_api_key
```

Only **one LLM provider** is required.

---

## 🐳 Running with Docker

### Build & Start

```bash
docker compose build
docker compose up -d
```

### Logs

```bash
docker logs -f genlayer-validator
```

---

## 🔑 Validator Key Management

### Generate a new validator key

```bash
docker exec -it genlayer-validator genlayernode account new   -c /opt/genlayer/configs/node/config.yaml   --setup   --password "${NODE_PASSWORD}"
```

### Backup validator key

```bash
docker exec -it genlayer-validator genlayernode account export   --password "${NODE_PASSWORD}"   --address "0xYourValidatorAddress"   --passphrase "your_backup_passphrase"   --path "/opt/genlayer/data/validator-backup.key"   -c /opt/genlayer/configs/node/config.yaml
```

Copy the backup file safely from `./data/`.

### Restore validator key

```bash
docker exec -it genlayer-validator genlayernode account import   --password "${NODE_PASSWORD}"   --passphrase "your_backup_passphrase"   --path "/opt/genlayer/data/validator-backup.key"   -c /opt/genlayer/configs/node/config.yaml   --setup
```

---

## 📊 Monitoring

Metrics are exposed on port **9153**.

### Check metrics

```bash
curl http://localhost:9153/metrics
```

### Prometheus scrape config

```yaml
- job_name: "genlayer-validator"
  static_configs:
    - targets: ["localhost:9153"]
```

---

## ⬆️ Updating Node

1. Change version in `docker-compose.yml`:

```yaml
args:
  GENLAYER_VERSION: v0.3.11
```

2. Rebuild and restart:

```bash
docker compose build --no-cache validator
docker compose up -d
```

---

## 🧩 Advanced Notes

- WebDriver runs automatically in a separate container (`selenium/standalone-chrome`).
- GenVM modules (`llm`, `web`) are managed automatically (`genvm.manage_modules: true`).
- Use `docker exec` to run `genlayernode doctor` inside the container to check health.

---

## 📎 Useful Commands

```bash
# Check node health
docker exec -it genlayer-validator genlayernode doctor

# Attach interactive shell
docker exec -it genlayer-validator bash

# Stop node
docker compose down
```

---

## ✅ Summary

You now have a **fully containerized GenLayer Validator Node** with:

- Dockerfile + docker-compose
- LLM provider integration
- WebDriver module
- Validator key management
- Prometheus-ready monitoring

For production, ensure:
- Keys are backed up securely
- Metrics & logs are monitored
- Node version is kept up-to-date
