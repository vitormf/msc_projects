import urllib

import coremltools as ct
import tensorflow as tf

keras_model = tf.keras.applications.ResNet50(
    weights="imagenet",
    input_shape=(224, 224, 3,),
    classes=1000,
)

label_url = 'https://storage.googleapis.com/download.tensorflow.org/data/ImageNetLabels.txt'
class_labels = urllib.request.urlopen(label_url).read().splitlines()
class_labels = class_labels[1:]  # remove the first class which is background
assert len(class_labels) == 1000

# make sure entries of class_labels are strings
for i, label in enumerate(class_labels):
    if isinstance(label, bytes):
        class_labels[i] = label.decode("utf8")

image_input = ct.ImageType(shape=(1, 224, 224, 3,),
                           bias=[-1, -1, -1], scale=1/127)

# set class labels
classifier_config = ct.ClassifierConfig(class_labels)

# Convert the model using the Unified Conversion API to an ML Program
model = ct.convert(
    keras_model,
    convert_to="mlprogram",
    inputs=[image_input],
    classifier_config=classifier_config,
)


model.save("tf_to_coreml_resnet50.mlpackage")
