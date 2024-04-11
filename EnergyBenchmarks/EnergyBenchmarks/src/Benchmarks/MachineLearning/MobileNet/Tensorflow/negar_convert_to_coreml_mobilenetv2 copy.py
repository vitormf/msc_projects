import urllib

import coremltools as ct
import tensorflow as tf
import tensorflow_hub as hub

# tf_model = tf.keras.applications.MobileNetV2(
#     input_shape=None,
#     alpha=1.0,
#     include_top=True,
#     weights="imagenet",
#     input_tensor=None,
#     pooling=None,
#     classes=1000,
#     classifier_activation="softmax"
# )

# model = ct.convert(tf_model)
# print(model.get_spec())
# model.save("ssd_mobilenet_v2_2.mlmodel")


# #set the labels to classifier config
# label_url = 'https://storage.googleapis.com/download.tensorflow.org/data/ImageNetLabels.txt'
# class_labels = urllib.request.urlopen(label_url).read().splitlines()#make sure entries of class_labels are strings
# # class_labels = class_labels[0:1000]
# for i, label in enumerate(class_labels):
#     if isinstance(label, bytes):
#         class_labels[i] = label.decode("utf8")
#         print(f"{i}: {class_labels[i]}")
# classifier_config = ct.ClassifierConfig(class_labels)#assign the input model as image type
# #the model has an input range of [0,1]. hence assign the scale
# scale = 1/255.0
# image_input = ct.ImageType(name="input_1", shape=(1, 224, 224, 3), scale=scale)#convert keras model to CoreML Model
# mlmodel = ct.convert(tf_model,convert_to="mlprogram",inputs=[image_input],classifier_config = classifier_config)#save the model
# # mlmodel = ct.convert(tf_model,convert_to="mlprogram",inputs=[image_input])#save the model
# mlmodel.save("ssd_mobilenet_v2_2.mlpackage")


# input {
#     name: "input_1"
#     type {
#       multiArrayType {
#         shape: 1
#         shape: 224
#         shape: 224
#         shape: 3
#         dataType: FLOAT32
#         shapeRange {
#           sizeRanges {
#             lowerBound: 1
#             upperBound: -1
#           }
#           sizeRanges {
#             lowerBound: 224
#             upperBound: 224
#           }
#           sizeRanges {
#             lowerBound: 224
#             upperBound: 224
#           }
#           sizeRanges {
#             lowerBound: 3
#             upperBound: 3
#           }
#         }
#       }
#     }
#   }


# keras_model = tf.keras.applications.MobileNetV2(
#     weights="imagenet", 
#     input_shape=(224, 224, 3,),
#     classes=1000,
# )

keras_model = tf.keras.models.load_model(('negar_mobilenet_v2_tinyimagenet.h5'), custom_objects={'KerasLayer': hub.KerasLayer})



print("model:")
print(keras_model)


label_url = 'https://storage.googleapis.com/download.tensorflow.org/data/ImageNetLabels.txt'
class_labels = urllib.request.urlopen(label_url).read().splitlines()
class_labels = class_labels[1:] # remove the first class which is background
assert len(class_labels) == 1000

# make sure entries of class_labels are strings
for i, label in enumerate(class_labels):
  if isinstance(label, bytes):
    class_labels[i] = label.decode("utf8")

image_input = ct.ImageType(shape=(1, 224, 224, 3,),
                           bias=[-1,-1,-1], scale=1/127)

# set class labels
classifier_config = ct.ClassifierConfig(class_labels)

# Convert the model using the Unified Conversion API to an ML Program
model = ct.convert(
    keras_model, 
    convert_to="mlprogram",
    inputs=[image_input], 
    classifier_config=classifier_config,
    compute_units=ct.ComputeUnit.CPU_ONLY,
)


model.save("negar_mobilenet_tinyimagenet.mlpackage")