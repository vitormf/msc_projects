import numpy as np
import tensorflow as tf
from tensorflow.keras.applications.mobilenet_v2 import (MobileNetV2,
                                                        decode_predictions,
                                                        preprocess_input)
from tensorflow.keras.preprocessing import image


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


# Load the pre-trained MobileNetV2 model
model = MobileNetV2(weights='imagenet')

# Save the model as a TensorFlow SavedModel
saved_model_dir = 'mobilenetv2_saved_model'
tf.saved_model.save(model, saved_model_dir)

# Convert the SavedModel to a TensorFlow Lite model
converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)

# Add metadata to the TensorFlow Lite model
labels = {i: name for i, name in enumerate(
    decode_predictions(np.eye(1000), top=1000)[0])}
converter.target_spec.supported_ops = [
    tf.lite.OpsSet.TFLITE_BUILTINS, tf.lite.OpsSet.SELECT_TF_OPS]
converter.experimental_new_converter = True
# Replace with your representative dataset function
converter.representative_dataset = representative_data_gen
converter.target_spec.supported_types = [tf.float32]
converter.inference_input_type = tf.float32
converter.inference_output_type = tf.float32
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()
tflite_model_file = 'keras_mobilenet_v2.tflite'
with open(tflite_model_file, 'wb') as f:
    f.write(tflite_model)

# Save the labels metadata as a text file
labels_file = 'mobilenet_v2_labels.txt'
with open(labels_file, 'w') as f:
    for i in range(len(labels)):
        f.write('{}\n'.format(labels[i]))

# Embed the labels metadata into the TensorFlow Lite model
model_with_metadata = tf.lite.TFLiteConverter.read_tflite_model(
    tflite_model_file)
model_with_metadata.metadata_tags = {
    "serving": {
        "tags": ["mobilenetv2"],
        "signature_def": {
            "signature_def": {
                "serving_default": {
                    "inputs": {"input": {"dtype": "DT_FLOAT", "shape": [-1, 224, 224, 3]}},
                    "outputs": {"output": {"dtype": "DT_FLOAT", "shape": [-1, 1000]}},
                    "method_name": "tensorflow/serving/predict"
                }
            }
        },
        "label_files": [labels_file]
    }
}

# Save the TensorFlow Lite model with embedded labels metadata
tflite_model_metadata_file = 'keras_mobilenet_v2_with_metadata.tflite'
with open(tflite_model_metadata_file, 'wb') as f:
    f.write(model_with_metadata)
