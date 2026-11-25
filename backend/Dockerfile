FROM python:3.12-slim

WORKDIR /app

COPY backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY backend/app /app/app
COPY assets/corpus/indian_law_corpus_v1.json /app/assets/corpus/indian_law_corpus_v1.json

ENV LEX_CORPUS_PATH=/app/assets/corpus/indian_law_corpus_v1.json
EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
