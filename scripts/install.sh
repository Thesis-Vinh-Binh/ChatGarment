#! /bin/bash

conda init
source ~/.bashrc

conda create -n chatgarment python=3.10 -y
source /opt/miniforge3/etc/profile.d/conda.sh
conda activate chatgarment
pip install --upgrade pip  # enable PEP 660 support

cd /workspace/ChatGarment
pip install -e ".[train]"
pip install flash-attn==2.6.2 --no-build-isolation openai

mkdir -p /workspace/ChatGarment/checkpoints/try_7b_lr1e_4_v3_garmentcontrol_4h100_v4_final/ && cd "$_"
python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='Thesis-VinhBinh/ChatGarment', filename='pytorch_model.bin', local_dir='.')"

# demo run try this, if fail raise the comments here
if ! ./scripts/v1_5/evaluate_garment_v2_imggen_2step.sh example_data/example_imgs/; then
    echo "Please nano pytorch.py to change those before uint64"
    echo "  if not hasattr(torch, "uint64"):
    #     torch.uint64 = torch.int64
    # if not hasattr(torch, "uint32"):
    #     torch.uint32 = torch.int32
    # if not hasattr(torch, "uint16"):
    #     torch.uint16 = torch.int16"
    exit 1
fi
