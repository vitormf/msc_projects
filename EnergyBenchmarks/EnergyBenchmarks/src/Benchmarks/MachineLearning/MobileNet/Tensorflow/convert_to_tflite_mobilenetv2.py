import urllib

import coremltools as ct
import cv2
import numpy as np
import tensorflow as tf
from tensorflow.keras.applications.mobilenet_v2 import (MobileNetV2,
                                                        decode_predictions,
                                                        preprocess_input)
from tensorflow.keras.preprocessing import image
from tflite_support.metadata_writers import image_classifier, writer_utils

print("###################\nfetching keras model")

keras_model = MobileNetV2(
    weights="imagenet",
    input_shape=(224, 224, 3,),
    classes=1000,
)

print("###################\nfetching labels")

label_url = 'https://storage.googleapis.com/download.tensorflow.org/data/ImageNetLabels.txt'
class_labels = urllib.request.urlopen(label_url).read().splitlines()
class_labels = class_labels[1:]  # remove the first class which is background
assert len(class_labels) == 1000

# make sure entries of class_labels are strings
for i, label in enumerate(class_labels):
    if isinstance(label, bytes):
        class_labels[i] = label.decode("utf8")

with open('mobilenet_v2_labels.txt', 'w') as labels_file:
    for label in class_labels:
        labels_file.write(label + "\n")

# image_input = ct.ImageType(shape=(1, 224, 224, 3,),
#                            bias=[-1, -1, -1], scale=1/127)

# set class labels
# classifier_config = ct.ClassifierConfig(class_labels)

# Convert the model using the Unified Conversion API to an ML Program
# model = ct.convert(
#     keras_model,
#     convert_to="mlprogram",
#     inputs=[image_input],
#     classifier_config=classifier_config,
# )

# model.save("ssd_mobilenet_v2_2.mlpackage")

print("###################\nconverting to tflite")


def representative_data_gen():
    # Define a generator function that yields representative datasets
    for i in range(200):
        image_path = f"./tiny_imagenet_val/{i}.jpg"
        # Load the image and preprocess it
        img = image.load_img(image_path, target_size=(224, 224))
        x = image.img_to_array(img)
        x = np.expand_dims(x, axis=0)
        x = preprocess_input(x)

        # Yield the preprocessed input tensor
        yield [x]


def rep_data_gen():
    dir_val = './tiny_imagenet_val/'
    a = []
    for i in range(9000):
        file_name = f"{i}.jpg"
        img = cv2.imread(dir_val + file_name)
        img = cv2.resize(img, (127.5, 127.5))
        img = img / 255.0
        img = img.astype(np.float32)
        a.append(img)
    a = np.array(a)
    print(a.shape)  # a is np array of 160 3D images
    img = tf.data.Dataset.from_tensor_slices(a).batch(1)
    # return img.as_numpy_iterator()
    # for i in img.take(200):
    for i in img:
        print(i)
        yield [i]


converter = tf.lite.TFLiteConverter.from_keras_model(keras_model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
# converter.representative_dataset = tf.keras.utils.image_dataset_from_directory(dir_val,
#                                                                                batch_size=4000,
#                                                                                image_size=(64, 64))
converter.representative_dataset = representative_data_gen
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
converter.inference_input_type = tf.uint8
converter.inference_output_type = tf.uint8
tflite_model = converter.convert()
with open('keras_mobilenet_v2.tflite', 'wb') as file:
    file.write(tflite_model)

print('###################\ngenerating model with metadata')


ImageClassifierWriter = image_classifier.MetadataWriter
# Normalization parameters are required when processing the image
# https://www.tensorflow.org/lite/convert/metadata#normalization_and_quantization_parameters)
_INPUT_NORM_MEAN = 127.5
_INPUT_NORM_STD = 127.5
_TFLITE_MODEL_PATH = "keras_mobilenet_v2.tflite"
_LABELS_FILE = "mobilenet_v2_labels.txt"
_TFLITE_METADATA_MODEL_PATHS = "keras_mobilenet_v2_with_metadata.tflite"

# Create the metadata writer
metadata_generator = ImageClassifierWriter.create_for_inference(
    writer_utils.load_file(_TFLITE_MODEL_PATH), [_INPUT_NORM_MEAN], [
        _INPUT_NORM_STD], [_LABELS_FILE]
)

# Verify the metadata generated
print(metadata_generator.get_metadata_json())

# Integrate the metadata into the TFlite model
writer_utils.save_file(metadata_generator.populate(),
                       _TFLITE_METADATA_MODEL_PATHS)

print('done')
