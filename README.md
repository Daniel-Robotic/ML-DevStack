
# 🧠 ML DevStack

Среда разработки для машинного обучения, включающая:

- 📓 **Jupyter Lab** — интерактивные ноутбуки
- 🧪 **MLflow** — управление экспериментами
- ☁️ **MinIO** — хранение моделей и артефактов
- 🏷 **Label Studio** — ручная разметка данных
- 🐘 **PostgreSQL** — база данных
- 🐳 **Docker Compose** — для удобного запуска

---

## 📁 Структура проекта

```
.
├── conda-environment.yml           # окружение conda (Jupyter + ML)
├── docker-compose.yaml             # описание всех сервисов
├── Dockerfile.jupyter              # Dockerfile для Jupyter сервера
├── Dockerfile.mlflow               # Dockerfile для MLflow
├── entrypoint.sh                   # скрипт запуска Jupyter
├── jupyter-notebooks/              # директория для ноутбуков
├── labelstudio-data/               # данные Label Studio
├── minio-data/                     # артефакты MinIO
├── pg-data/                        # данные PostgreSQL
└── postgres-init/
    └── create_multiple_dbs.sql     # SQL для создания нескольких БД
```

---

## 🛠 Подготовка

Перед первым запуском создайте нужные папки:

```bash
mkdir -p jupyter-notebooks labelstudio-data minio-data pg-data
```

---

## ⚙️ Настройки через `.env`

Создайте файл `.env` в корне и укажите:

```env
# MINIO
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=password

# PostgreSQL
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
POSTGRES_HOST_AUTH_METHOD=trust

# Label Studio
DJANGO_DB=default
POSTGRE_NAME=labelstudio
POSTGRE_USER=postgres
POSTGRE_PASSWORD=password
POSTGRE_PORT=5432
POSTGRE_HOST=postgres
LABEL_STUDIO_HOST=0.0.0.0
LABEL_STUDIO_DISABLE_SIGNUP_WITHOUT_LINK=true
LABEL_STUDIO_USERNAME=admin@labelstudio.ru
LABEL_STUDIO_PASSWORD=password
JSON_LOG=1

# Jupyter
JUPYTER_TOKEN=token
JUPYTER_RAW_PASSWORD=password

# MLflow
MLFLOW_DATABASE=mlflow
MLFLOW_BUCKET_NAME=mlflow-bucket
MLFLOW_S3_ENDPOINT_URL=http://minio:9000
MLFLOW_TRACKING_URL=http://mlflow:5000
MLFLOW_S3_IGNORE_TLS=True
MLFLOW_AWS_ACCESS_KEY_ID=examplekey
MLFLOW_AWS_SECRET_ACCESS_KEY=examplesecret
```

---

## 🔧 Conda окружение для Jupyter

Файл `conda-environment.yml` содержит все нужные библиотеки, включая поддержку GPU:

```yaml
name: remote_jupyter_env
channels:
  - nvidia
  - pytorch
  - conda-forge
  - defaults

dependencies:
  - python=3.12
  - jupyter
  - notebook
  - jupyterlab
  - ipykernel
  - ipywidgets
  - jupyterlab_widgets
  - widgetsnbextension

  # Core ML
  - numpy
  - pandas
  - scikit-learn
  - matplotlib
  - seaborn
  - plotly
  - openpyxl
  - pyarrow
  - xgboost
  - catboost
  - lightgbm

  # PyTorch + CUDA
  - pytorch
  - torchvision
  - torchaudio
  - pytorch-cuda=12.1

  # TensorFlow GPU
  - tensorflow

  # pip-инструменты
  - pip
  - pip:
      - pytorch-lightning
      - torchmetrics
      - timm
      - torchinfo
      - torchsummary
      - captum
      - optuna
      - mlflow
      - wandb
      - tensorboard
      - label-studio-ml
      - debugpy
      - pandas-profiling
      - scikit-optimize
      - seaborn-image
      - ultralytics
```

Чтобы добавить новые библиотеки:

1. Добавьте их в `conda-environment.yml`
2. Пересоберите контейнер Jupyter:

```bash
docker compose build jupyter
```

---

## 📦 PostgreSQL: создание баз

Файл `postgres-init/create_multiple_dbs.sql` создаёт БД при первом запуске:

```sql
CREATE DATABASE labelstudio;
CREATE DATABASE mlflow;
```

---

## 🚀 Запуск

```bash
docker compose up -d --build
```

---

## 🌍 Доступ к сервисам

| Сервис        | URL                              | Доступ                                     |
|---------------|----------------------------------|--------------------------------------------|
| 📦 MinIO      | http://localhost:9001            | `minioadmin` / `password`                  |
| 🏷 LabelStudio| http://localhost:8080            | `admin@labelstudio.ru` / `password`        |
| 📓 Jupyter    | http://localhost:8888            | `token=token` или пароль `password`        |
| 🧪 MLflow     | http://localhost:5050            | открытый доступ                            |

---

## 🧹 Удаление и очистка

```bash
docker compose down -v
rm -rf jupyter-notebooks minio-data labelstudio-data pg-data
```

---

## 💬 Подсказки

- MLflow использует PostgreSQL и MinIO — всё настраивается через `.env`.
- Jupyter запускается с токеном и паролем (`entrypoint.sh`).
- MinIO setup автоматически создаёт бакеты и сервисные ключи.
