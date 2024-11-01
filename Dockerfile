FROM python:3.9-slim-bullseye

WORKDIR /multilingo_ai

COPY . .

RUN pip install  --no-cache-dir -r /multilingo_ai/requirements.txt

ENV GEMINI_API_KEY=${GEMINI_API_KEY}

EXPOSE 8000

CMD ["python", "main.py"]