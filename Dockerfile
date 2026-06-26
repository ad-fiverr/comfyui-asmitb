FROM ls250824/run-comfyui-image:21052026

ENV DEBIAN_FRONTEND=noninteractive
# ComfyUI ya esta en /ComfyUI en la imagen base
# setup_models.sh lo copiara a /workspace/ComfyUI al primer arranque

RUN apt-get update -qq && apt-get install -y -qq git wget && \
    pip install -q gdown && \
    rm -rf /var/lib/apt/lists/*

# Custom Nodes en /ComfyUI (se copian al workspace en el primer arranque)
RUN cd /ComfyUI/custom_nodes && \
    rm -rf rgthree-comfy ComfyUI-Impact-Pack ComfyUI_essentials ComfyUI-GGUF ComfyUI-Impact-Subpack cg-use-everywhere ComfyMath ComfyUI-mxToolkit comfyui-crystools ComfyUI_LayerStyle ComfyUI_Fill-Nodes ComfyUI-Image-Saver ComfyUI-AdvancedLivePortrait && \
    git clone --depth=1 https://github.com/rgthree/rgthree-comfy && \
    git clone --depth=1 https://github.com/ltdrdata/ComfyUI-Impact-Pack && \
    git clone --depth=1 https://github.com/cubiq/ComfyUI_essentials && \
    git clone --depth=1 https://github.com/city96/ComfyUI-GGUF && \
    git clone --depth=1 https://github.com/ltdrdata/ComfyUI-Impact-Subpack && \
    git clone --depth=1 https://github.com/evanspearman/ComfyMath && \
    git clone --depth=1 https://github.com/chrisgoringe/cg-use-everywhere && \
    git clone --depth=1 https://github.com/pythongosssss/ComfyUI-Custom-Scripts && \
    git clone --depth=1 https://github.com/Smirnov75/ComfyUI-mxToolkit && \
    git clone --depth=1 https://github.com/crystian/comfyui-crystools && \
    git clone --depth=1 https://github.com/chflame163/ComfyUI_LayerStyle && \
    git clone --depth=1 https://github.com/filliptm/ComfyUI_Fill-Nodes && \
    git clone --depth=1 https://github.com/farizrifqi/ComfyUI-Image-Saver && \
    git clone --depth=1 https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait
    

RUN for dir in rgthree-comfy ComfyUI-Impact-Pack ComfyUI_essentials ComfyUI-GGUF ComfyUI-Impact-Subpack cg-use-everywhere ComfyMath ComfyUI-Custom-Scripts ComfyUI-mxToolkit comfyui-crystools ComfyUI_LayerStyle ComfyUI_Fill-Nodes ComfyUI-Image-Saver ComfyUI-AdvancedLivePortrait; do \
      REQ="/ComfyUI/custom_nodes/${dir}/requirements.txt"; \
      if [ -f "$REQ" ]; then pip install -q -r "$REQ"; fi; \
    done



RUN rm -rf /ComfyUI/ComfyUI-Login /ComfyUI/ComfyUI-login


RUN mkdir -p /ComfyUI/user/default/workflows
COPY nsfw-ultratozimage-asmitb.json /ComfyUI/user/default/workflows/nsfw-workflow.json
COPY nsfw-ultratozimage-asmitb_v2.json /ComfyUI/user/default/workflows/nsfw-workflow_v2.json
COPY sfw-comfyui-workflow-asmitb.json /ComfyUI/user/default/workflows/sfw-workflow.json


RUN apt-get update -qq && apt-get install -y -qq git wget dos2unix && \
    pip install -q gdown huggingface_hub comfyui-manager && \
    rm -rf /var/lib/apt/lists/*

COPY setup_models.sh /setup_models.sh
RUN dos2unix /setup_models.sh && chmod +x /setup_models.sh


EXPOSE 8188
CMD ["/setup_models.sh"]