import torch
import torch.hub
import torchvision
import torchvision.models as models
from torch.utils.mobile_optimizer import optimize_for_mobile
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader




### MOBILENET

torch.hub.set_dir('mobilenet_v2')
model = models.mobilenet_v2(weights=models.MobileNet_V2_Weights.DEFAULT)
model.eval()

# if torch.cuda.is_available():
#     device = torch.device("cuda")
#     model.to(device)
#     model = nn.DataParallel(model)
#     optimizer = optim.SGD(model.parameters(), lr=0.001)
#     print("Model moved to GPU and using data parallelism")
# else:
#     optimizer = optim.SGD(model.parameters(), lr=0.001)
#     print("GPU is not available, using CPU instead")

# quant_min=0, quant_max=127
model.qconfig = torch.quantization.get_default_qconfig('qnnpack')
torch.quantization.prepare(model, inplace=True)
torch.quantization.convert(model, inplace=True)

# example = torch.rand(1, 3, 224, 224)
# traced_script_module = torch.jit.trace(model, example)
# torchscript_model_optimized = optimize_for_mobile(traced_script_module)
# torchscript_model_optimized.save("mobilenet_v2_quantized.pt")


#### RESNET

# torch.hub.set_dir('resnet50')
# model = models.resnet50(pretrained=True)
# model.eval()
# example = torch.rand(1, 3, 224, 224)
# traced_script_module = torch.jit.trace(model, example)
# torchscript_model_optimized = optimize_for_mobile(traced_script_module)
# torchscript_model_optimized.save("resnet50.pt")

# torch.hub.set_dir('squeezenet')
# model = models.squeezenet1_0(pretrained=True)
# model.eval()


### SQUEEZENET

# model.qconfig = torch.quantization.get_default_config('fbgemm')
# torch.quantization.prepare(model, inplace=True)
# torch.quantization.convert(model, inplace=True)

# example = torch.rand(1, 3, 224, 224)
# traced_script_module = torch.jit.trace(model, example)
# torchscript_model_optimized = optimize_for_mobile(traced_script_module)
# torchscript_model_optimized.save("squeezenet1_0_quantized.pt")

