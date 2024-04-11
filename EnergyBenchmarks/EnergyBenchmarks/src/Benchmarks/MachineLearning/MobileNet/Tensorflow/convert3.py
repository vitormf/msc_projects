import tensorflow as tf

path = "ssd_mobilenet_v2_2/saved_model.pb"

# Load the protobuf file from the disk and parse it to retrieve the
# graph_def
with tf.io.gfile.GFile(path, "rb") as f:
    graph_def = tf.compat.v1.GraphDef()
    graph_def.ParseFromString(f.read())

# Import the graph_def into a new Graph
with tf.Graph().as_default() as graph:
    tf.import_graph_def(graph_def, name="")