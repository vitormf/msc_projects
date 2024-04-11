import coremltools
import onnxmltools

# Load a Core ML model
file = '/Users/vitor/resilio/mestrado/git/msc_projects/EnergyBenchmarks/EnergyBenchmarks/src/Benchmarks/MachineLearning/MobileNet/CoreML/models/MobileNetV2_apple.mlmodel'
coreml_model = coremltools.utils.load_spec(file)

# Convert the Core ML model into ONNX
onnx_model = onnxmltools.convert_coreml(coreml_model, 'Example Model')

# Save as protobuf
onnxmltools.utils.save_model(onnx_model, 'coreml.onnx')