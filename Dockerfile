# Usar uma imagem base sem suporte a CUDA para CPUs
FROM python:3.10-slim-bullseye AS base

# Instalar dependências do sistema necessárias
RUN apt-get update && apt-get install -y \
    git wget libgl1 libglib2.0-0 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Configurar ambiente Python
ENV PYTHONUNBUFFERED=1
ENV PATH="/usr/bin:${PATH}"

# Clonar ComfyUI
WORKDIR /app
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /app/ComfyUI

# Instalar dependências do ComfyUI
RUN pip install -r requirements.txt

# Clonar ComfyUI-WanVideoWrapper na pasta custom_nodes
RUN git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git custom_nodes/ComfyUI-WanVideoWrapper

# Instalar dependências do ComfyUI-WanVideoWrapper e onnx
RUN pip install -r custom_nodes/ComfyUI-WanVideoWrapper/requirements.txt onnx onnxruntime

# Clonar ComfyUI-VideoHelperSuite na pasta custom_nodes
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git custom_nodes/ComfyUI-VideoHelperSuite

# Instalar dependências do ComfyUI-VideoHelperSuite
RUN pip install -r custom_nodes/ComfyUI-VideoHelperSuite/requirements.txt

# Expor a porta que o ComfyUI usa (padrão 8188 )
EXPOSE 8188

# Comando para iniciar o ComfyUI
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--cpu"]
