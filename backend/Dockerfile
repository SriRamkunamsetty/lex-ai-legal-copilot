FROM python:3.12-slim

WORKDIR /app

COPY backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt && \
    adduser --disabled-password --gecos "" lexuser

COPY backend/app /app/app
COPY backend/alembic.ini /app/alembic.ini
COPY backend/alembic /app/alembic
COPY assets/corpus/indian_law_corpus_v1.json /app/assets/corpus/indian_law_corpus_v1.json
COPY assets/corpus/packs /app/assets/corpus/packs

ENV LEX_CORPUS_PATH=/app/assets/corpus/indian_law_corpus_v1.json \
    LEX_PACKS_DIR=/app/assets/corpus/packs \
    LEX_ENVIRONMENT=production

USER lexuser
EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
