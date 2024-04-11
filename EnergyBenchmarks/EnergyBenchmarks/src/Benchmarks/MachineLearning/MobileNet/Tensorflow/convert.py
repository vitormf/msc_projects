import coremltools
import tensorflow as tf

model_path = 'ssd_mobilenet_v2_2'

keras_model =  tf.keras.models.load_model(model_path)

model = coremltools.convert(keras_model, convert_to="mlprogram")

model.save("ssd_mobilenet_v2_2_coreml")

# WARNING:root:scikit-learn version 1.0.2 is not supported. Minimum required version: 0.17. Maximum required version: 0.19.2. Disabling scikit-learn conversion API.
# WARNING:root:TensorFlow version 2.9.1 has not been tested with coremltools. You may run into unexpected errors. TensorFlow 2.6.2 is the most recent version that has been tested.
# WARNING:root:Keras version 2.9.0 has not been tested with coremltools. You may run into unexpected errors. Keras 2.6.0 is the most recent version that has been tested.
# WARNING:root:Torch version 1.12.0 has not been tested with coremltools. You may run into unexpected errors. Torch 1.10.2 is the most recent version that has been tested.
# pip install scipy
# pip install coremltools scikit-learn==0.19.2 keras==2.6.0 torch==1.10.2
# pip install tensorflow==2.6.2
# pip install https://files.pythonhosted.org/packages/ed/11/037887c5cbac5af3124050fb6348e67caa038734cc9673b11c31c8939072/tensorflow-1.14.0-cp37-cp37m-macosx_10_11_x86_64.whl  