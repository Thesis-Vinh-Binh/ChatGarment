#! /bin/bash

conda init
source ~/.bashrc

source /opt/miniforge3/etc/profile.d/conda.sh
conda activate chatgarment

BASE_DIR=/workspace/ChatGarment/runs/try_7b_lr1e_4_v3_garmentcontrol_4h100_v4_final

if [ -z "$2" ]; then
    $2 = "close_image_scan"
fi

if [ -z "$1" ]; then
    echo "Please input the method you want to run
    # 1: CoT
    # 2: Prompt support
    # 3: retrievalerence"
    exit 1
fi

echo "Must ensure data before running this"

if ! echo There are total $(ls /workspace/CloSe/data/$2 -1 | wc -l) images to run; then
    echo "Please download data"
    exit 1 
fi

echo "Running demo with methods: $1 with data: $2"

if [[ "$1" == *1* ]]; then
    echo "Running CoT"
    ./scripts/v1_5/evaluate_garment_v2_imggen_2step.sh /workspace/CloSe/data/$2/
    cd ${BASE_DIR}
    zip -r $2_cg_cot.zip $2_cg_cot
    if ! rclone copy ${BASE_DIR}/$2_cg_cot.zip remote:Thesis; then
        echo "Failed to copy to remote"
    fi
    echo "Successfully copied to remote"
    rm -rf ${BASE_DIR}/$2_cg_cot.zip
    cd /workspace/ChatGarment/
fi

if [[ "$1" == *2* ]]; then
    echo "Running Prompt support"
    ./scripts/v1_5/evaluate_garment_v2_imggen_blip.sh /workspace/CloSe/data/$2/
    cd ${BASE_DIR}
    zip -r $2_cg_blip.zip $2_cg_blip
    if ! rclone copy ${BASE_DIR}/$2_cg_blip.zip remote:Thesis; then
        echo "Failed to copy to remote"
    fi
    echo "Successfully copied to remote"
    rm -rf ${BASE_DIR}/$2_cg_blip.zip
    cd /workspace/ChatGarment/
fi

if [[ "$1" == *3* ]]; then
    echo "Running retrieval"
    ./scripts/v1_5/evaluate_garment_v2_imggen_retrieval.sh /workspace/CloSe/data/$2/
    cd ${BASE_DIR}
    zip -r $2_cg_retrieval.zip $2_cg_retrieval
    if ! rclone copy ${BASE_DIR}/$2_cg_retrieval.zip remote:Thesis; then
        echo "Failed to copy to remote"
    fi
    echo "Successfully copied to remote"
    rm -rf ${BASE_DIR}/$2_cg_retrieval.zip
    cd /workspace/ChatGarment/
fi


# ./scripts/v1_5/evaluate_garment_v2_imggen_2step.sh /workspace/CloSe/data/close_image_scan/
# ./scripts/v1_5/evaluate_garment_v2_imggen_blip.sh /workspace/CloSe/data/close_image_scan/
# ./scripts/v1_5/evaluate_garment_v2_imggen_retrievalerence.sh /workspace/CloSe/data/close_image_scan/

# zip -r /





