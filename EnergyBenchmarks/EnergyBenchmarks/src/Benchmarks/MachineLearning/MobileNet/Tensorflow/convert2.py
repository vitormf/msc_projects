import tfcoreml

tfcoreml.convert(tf_model_path='ssd_mobilenet_v2_2/saved_model.pb',
                 mlmodel_path='ssd_mobilenet_v2_2.mlmodel',
                 output_feature_names=['softmax:0'],  # name of the output tensor (appended by ":0")
                 input_name_shape_dict={'input:0': [1, 227, 227, 3]},  # map from input tensor name (placeholder op in the graph) to shape
                 minimum_ios_deployment_target='12') # one of ['12', '11.2']