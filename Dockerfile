FROM nvidia/cuda:12.8.0-cudnn-runtime-ubuntu22.04

ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# LD_LIBRARY_PATH: primeiro as bibliotecas do pip (nvidia-*), depois o sistema
ENV LD_LIBRARY_PATH="/app/lib/python3.10/site-packages/nvidia/cublas/lib:/app/lib/python3.10/site-packages/nvidia/cuda_runtime/lib:/app/lib/python3.10/site-packages/nvidia/cudnn/lib:/usr/local/cuda-12.8/lib64:/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"

ENV MAX_GPU_JOBS=6
ENV GPU_WORKERS=6
ENV MIX_WORKERS=20

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ffmpeg \
    espeak-ng \
    python3 \
    python3-venv \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN python3 -m venv /app

COPY requirements.txt .
RUN /app/bin/python3 -m pip install --no-cache-dir -r requirements.txt

# Remover onnxruntime CPU que o piper-tts possa ter instalado
RUN /app/bin/python3 -m pip uninstall -y onnxruntime onnxruntime-cpu 2>/dev/null || true

# >>>>>>>>> FORÇAR ONNX RUNTIME GPU 1.21.1 (pode ter sido substituído) <<<<<<<<<
RUN /app/bin/python3 -m pip install --no-cache-dir --force-reinstall --no-deps onnxruntime-gpu==1.21.1

# Verificação final
RUN /app/bin/python3 -c "\
import onnxruntime; \
print('Versão final:', onnxruntime.__version__); \
print('Providers:', onnxruntime.get_available_providers()); \
assert 'CUDAExecutionProvider' in onnxruntime.get_available_providers(), 'CUDA NÃO disponível!'"


EXPOSE 8000

ENTRYPOINT []
