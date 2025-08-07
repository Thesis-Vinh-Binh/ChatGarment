import os
import shutil

folder = '/workspace/ChatGarmentDataset/dataset'
output = '/workspace/image_retrieval_dataset'
midfix = 'motion_0/imgs/0/img'

assert midfix != ''
os.makedirs(output, exist_ok=True)

for file in os.listdir(folder):
    image_path = os.path.join(folder, file, midfix)
    if os.path.exists(image_path):
        os.makedirs(os.path.join(output, file), exist_ok=True)
        for image in os.listdir(image_path) and image.endswith('.png'):
            shutil.copy(os.path.join(image_path, image), os.path.join(output, file, image))


# run this command zip -r image_retrieval_dataset.zip image_retrieval_dataset
os.system('zip -r image_retrieval_dataset.zip image_retrieval_dataset')
os.system('rclone copy image_retrieval_dataset.zip remote:Thesis')
print('Done')