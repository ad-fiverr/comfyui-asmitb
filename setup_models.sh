#!/bin/bash
# =============================================================================
# setup_models.sh - Configuración de Modelos AsmitB
# =============================================================================

# Token actualizado según tu solicitud
HF_TOKEN="${HF_TOKEN}"
HF_TOKEN_loras="${HF_TOKEN_loras}"
COMFYUI_DIR="/workspace/ComfyUI"

echo "================================================"
echo "  ComfyUI Model Setup — AsmitB Edition"
echo "================================================"

# PASO 1: Persistencia de ComfyUI
if [ ! -f "${COMFYUI_DIR}/main.py" ]; then
    echo "[ Copiando ComfyUI base a /workspace... ]"
    mkdir -p ${COMFYUI_DIR}
    cp -rn /ComfyUI/. ${COMFYUI_DIR}/
fi

# PASO 2: Preparar Directorios
mkdir -p ${COMFYUI_DIR}/models/loras \
         ${COMFYUI_DIR}/models/checkpoints \
         ${COMFYUI_DIR}/models/diffusion_models \
         ${COMFYUI_DIR}/models/text_encoders \
         ${COMFYUI_DIR}/models/upscale_models \
         ${COMFYUI_DIR}/models/vae \
         ${COMFYUI_DIR}/models/ultralytics/bbox \
         ${COMFYUI_DIR}/models/ultralytics/segm \
         ${COMFYUI_DIR}/models/loras/asmitb_zimage_face_v1 \
         ${COMFYUI_DIR}/models/loras/asmitb-zimagev1 \
         ${COMFYUI_DIR}/models/loras/asmitb-sdxl \
         ${COMFYUI_DIR}/models/sams \
         ${COMFYUI_DIR}/models/sam3 
         

# ── Funciones de descarga ─────────────────────────────────────────────────────

download_if_missing() {
    local url="$1" dest="$2" auth="$3"
    if [ -f "$dest" ] && [ -s "$dest" ]; then return 0; fi
    echo "  Descargando: $(basename $dest)"
    if [ -n "$auth" ]; then
        wget -q --show-progress --header="Authorization: Bearer $auth" -O "$dest" "$url"
    else
        wget -q --show-progress -O "$dest" "$url"
    fi
}

download_hf_repo() {
    local repo="$1" dest_dir="$2"
    echo "  Descargando repo HF: $repo en $dest_dir"
    HF_TOKEN=${HF_TOKEN} huggingface-cli download "$repo" --local-dir "$dest_dir" --local-dir-use-symlinks False
}

echo "Instalando huggingface_hub..."
pip install -U huggingface_hub

echo "Auth with Hugging Face..."
# Usamos el comando de Python para el login con el token proporcionado
python3 -c "from huggingface_hub import login; login(token="$HF_TOKEN_loras")"

# ── SECCIÓN DE DESCARGAS (Nuevos Comandos Integrados) ─────────────────────────

# --- LORAS ---
echo "[ LoRAs ]"
cd ${COMFYUI_DIR}/models/loras && rm -rf split_files/
echo "Cleaning folder files..."
rm -rf split_files/

# Nota: El comando oficial es 'huggingface-cli download'

# Civitai Instagram Filter
download_if_missing "https://civitai.red/api/download/models/2617751?type=Model&format=SafeTensor&token=e3a803e3831ec4832fd75d014b2d385e" \
    "instagram-filter.safetensors"


mkdir asmitb_zimage_face_v1
cd ${COMFYUI_DIR}/models/loras/asmitb_zimage_face_v1
download_if_missing "https://huggingface.co/exjadev/asmitb_zimage_face_v1/resolve/main/asmitb_zimage_face_v1/asmitb_zimage_face_v1_000001600.safetensors" \
    "asmitb_zimage_face_v1_000001600.safetensors"

mkdir asmitb_zimage_v1
cd ${COMFYUI_DIR}/models/loras/asmitb_zimage_v1
download_if_missing "https://huggingface.co/exjadev/asmitb-zimagev1/resolve/main/asmitb_zimage_v1/asmitb_zimage_v1_000002700.safetensors" \
    "asmitb_zimage_v1_000002700.safetensors"


mkdir asmitb-sdxl
cd ${COMFYUI_DIR}/models/loras/asmitb-sdxl
download_if_missing "https://huggingface.co/exjadev/asmitb-sdxl/resolve/main/asmitb-000018.safetensors" \
    "asmitb-000018.safetensors"

cd ${COMFYUI_DIR}/models/loras/
download_if_missing "https://civitai.red/api/download/models/2749020?type=Model&format=SafeTensor&token=e3a803e3831ec4832fd75d014b2d385e" \
    "NippleDiffusion.safetensors"
download_if_missing "https://civitai.red/api/download/models/2960754?type=Model&format=SafeTensor&token=e3a803e3831ec4832fd75d014b2d385e" \
    "PussyDiffusion.safetensors"
download_if_missing "https://civitai.red/api/download/models/2617751?type=Model&format=SafeTensor&token=e3a803e3831ec4832fd75d014b2d385e" \
    "Realistic_Nudes.safetensors"




# --- CHECKPOINTS ---
echo "[ Checkpoints ]"
cd ${COMFYUI_DIR}/models/checkpoints && rm -rf split_files/
download_if_missing "https://civitai.red/api/download/models/2755468?type=Model&format=SafeTensor&size=full&fp=fp16&token=e3a803e3831ec4832fd75d014b2d385e" \
    "sdxl_nsfw.safetensors"

# --- DIFFUSION MODELS ---
echo "[ Diffusion Models ]"
cd ${COMFYUI_DIR}/models/diffusion_models && rm -rf split_files/
download_if_missing "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors" \
    "z_image_turbo_bf16.safetensors"
download_if_missing "https://civitai.red/api/download/models/2985440?type=Model&format=SafeTensor&token=e3a803e3831ec4832fd75d014b2d385e" \
    "snofsSexNudesAndOtherFunStuff_v14Distilled.safetensors"
download_if_missing "https://huggingface.co/black-forest-labs/FLUX.2-klein-9b-fp8/resolve/main/flux-2-klein-9b-fp8.safetensors" \
    "flux-2-klein-9b-fp8.safetensors"


# --- TEXT ENCODERS ---
echo "[ Text Encoders ]"
cd ${COMFYUI_DIR}/models/text_encoders && rm -rf split_files/
download_if_missing "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors" \
    "qwen_3_4b.safetensors"
download_if_missing "https://huggingface.co/silveroxides/FLUX.2-dev-fp8_scaled/resolve/3e947e2aac04fdd8fea4be33a06842f2935fc161/qwen3_8b_abliterated_v2-fp8mixed.safetensors" \
    "qwen3_8b_abliterated_v2-fp8mixed.safetensors"

# ── BBOX Ultralytics ──────────────────────────────────────────────────────────
echo ""
echo "[ BBOX Ultralytics ]"
cd ${COMFYUI_DIR}/models/ultralytics/bbox && rm -rf split_files/
download_if_missing "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt" \
    "face_yolov8m.pt"
download_if_missing "https://huggingface.co/ashllay/YOLO_Models/resolve/main/bbox/female_breast-v4.2.pt" \
    "female_breast-v4.2.pt"
download_if_missing "https://huggingface.co/ashllay/YOLO_Models/resolve/main/bbox/vagina-v3.2.pt" \
    "vagina-v3.2.pt"
download_if_missing "https://huggingface.co/ashllay/YOLO_Models/resolve/main/bbox/full_eyes_detect_v1.pt" \
    "full_eyes_detect_v1.pt"
download_if_missing "https://huggingface.co/ashllay/YOLO_Models/resolve/main/bbox/full_eyes_detect_v1.pt" \
    "full_eyes_detect_v1.pt"



echo "[ BBOX Ultralytics SEGM ]"
cd ${COMFYUI_DIR}/models/ultralytics/segm
download_if_missing "https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8m-seg.pt" \
    "person_yolov8m-seg.pt"







# ── Upscaler Models ──────────────────────────────────────────────────────────
echo ""
echo "[ Upscaler Models ]"
cd ${COMFYUI_DIR}/models/upscale_models && rm -rf split_files/
download_if_missing "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth" \
    "4x_foolhardy_Remacri.pth"

# --- VAE ---
echo "[ VAE ]"
cd ${COMFYUI_DIR}/models/vae && rm -rf split_files/
download_if_missing "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors" \
    "ae.safetensors"
download_if_missing "https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/vae/flux2-vae.safetensors" \
    "flux2-vae.safetensors"

# --- SAM3 ---
echo "[ SAM3 ]"
cd ${COMFYUI_DIR}/models/sam3
download_if_missing "https://huggingface.co/facebook/sam3/resolve/main/sam3.pt" \
    "sam3.pt" "$HF_TOKEN"


    # ── SAMS (ReActor/Segment Anything) ──────────────────────────────────────────
echo "[ SAM3 ]"
cd ${COMFYUI_DIR}/models/sams
download_if_missing "https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/sams/sam_vit_b_01ec64.pth" \
    "sam_vit_b_01ec64.pth" 

download_if_missing "https://huggingface.co/HCMUE-Research/SAM-vit-h/resolve/main/sam_vit_h_4b8939.pth" \
    "sam_vit_h_4b8939.pth" 

# ── Lanzar ComfyUI ────────────────────────────────────────────────────────────
echo ""
echo "================================================"
echo "  Setup full. starting ComfyUI..."
echo "================================================"

chmod -R 777 /workspace/ComfyUI

exec python /workspace/ComfyUI/main.py --listen 0.0.0.0 --port 8188 --enable-manager