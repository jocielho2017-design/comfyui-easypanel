# Versão do VPS sem GPU NVIDIA
# Se você tiver um VPS com GPU, a linha FROM precisa ser ajustada.
FROM python:3.10-slim-bullseye

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y git wget libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho
WORKDIR /app

# Clona o repositório do ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Define o diretório de trabalho para dentro do ComfyUI
WORKDIR /app/ComfyUI

# Clona o WanVideoWrapper para a pasta de custom_nodes
RUN git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git custom_nodes/ComfyUI-WanVideoWrapper

# Instala as dependências Python do ComfyUI
RUN pip install -r requirements.txt

# Instala as dependências do WanVideoWrapper
RUN pip install -r custom_nodes/ComfyUI-WanVideoWrapper/requirements.txt

# Expõe a porta que o ComfyUI usará
EXPOSE 8188

# Comando para iniciar o ComfyUI, escutando em todas as interfaces de rede
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]