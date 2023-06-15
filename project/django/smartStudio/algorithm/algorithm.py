import cv2
class_names_path = 'smartStudio/algorithm/files/thing.names'
model_path = 'smartStudio/algorithm/files/frozen_inference_graph.pb'
config_path = 'smartStudio/algorithm/files/ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt'
image_path = 'smartStudio/algorithm/images/elephant.jpg'
def get_category(imageurl):
    classnames = []
    with open(class_names_path, 'rt') as f:
        classnames = f.read().rstrip('\n').split('\n')
    mapping = {
    'person': 'person',
    'bicycle': 'thing',
    'car': 'thing',
    'motorcycle': 'thing',
    'airplane': 'thing',
    'bus': 'thing',
    'train': 'thing',
    'truck': 'thing',
    'boat': 'thing',
    'traffic light': 'thing',
    'fire hydrant': 'thing',
    'street sign': 'thing',
    'stop sign': 'thing',
    'parking meter': 'thing',
    'bench': 'thing',
    'bird': 'animals',
    'cat': 'animals',
    'dog': 'animals',
    'horse': 'animals',
    'sheep': 'animals',
    'cow': 'animals',
    'elephant': 'animals',
    'bear': 'animals',
    'zebra': 'animals',
    'giraffe': 'animals',
    'hat': 'thing',
    'backpack': 'thing',
    'umbrella': 'thing',
    'shoe': 'thing',
    'eye glasses': 'thing',
    'handbag': 'thing',
    'tie': 'thing',
    'suitcase': 'thing',
    'frisbee': 'thing',
    'skis': 'thing',
    'snowboard': 'thing',
    'sports ball': 'thing',
    'kite': 'thing',
    'baseball bat': 'thing',
    'baseball glove': 'thing',
    'skateboard': 'thing',
    'surfboard': 'thing',
    'tennis racket': 'thing',
    'bottle': 'thing',
    'plate': 'thing',
    'wine glass': 'thing',
    'cup': 'thing',
    'fork': 'thing',
    'knife': 'thing',
    'spoon': 'thing',
    'bowl': 'thing',
    'banana': 'thing',
    'apple': 'thing',
    'sandwich': 'food',
    'orange': 'food',
    'broccoli': 'food',
    'carrot': 'food',
    'hot dog': 'food',
    'pizza': 'food',
    'donut': 'food',
    'cake': 'food',
    'chair': 'thing',
    'couch': 'thing',
    'potted plant': 'thing',
    'bed': 'thing',
    'mirror': 'thing',
    'dining table': 'thing',
    'window': 'thing',
    'desk': 'thing',
    'toilet': 'thing',
    'door': 'thing',
    'tv': 'thing',
    'laptop': 'thing',
    'mouse': 'thing',
    'remote': 'thing',
    'keyboard': 'thing',
    'cell phone': 'thing',
    'microwave': 'thing',
    'oven': 'thing',
    'toaster': 'thing',
    'sink': 'thing',
    'refrigerator': 'thing',
    'blender': 'thing',
    'book': 'thing',
    'clock': 'thing',
    'vase': 'thing',
    'scissors': 'thing',
    'teddy bear': 'thing',
    'hair drier': 'thing',
    'toothbrush': 'thing',
    'hair brush': 'thing'
}
    required_classes = ['person', 'animals', 'food', 'thing']
    detected_objects = []

    net = cv2.dnn_DetectionModel(model_path, config_path)
    net.setInputSize(320, 230)
    net.setInputScale(1.0/127.5)
    net.setInputMean((127.5, 127.5, 127.5))
    net.setInputSwapRB(True)

    img = cv2.imread(image_path)
    classIds, confs, bbox = net.detect(img, confThreshold=0.5)

    if len(classIds) > 0:
        for classId, confidence, box in zip(classIds.flatten(), confs.flatten(), bbox):
            class_name = classnames[classId - 1]
            target_class = mapping.get(class_name, 'thing')
            if target_class in required_classes:
                detected_objects.append(target_class)
    print (detected_objects)
    category=process_detected_objects(detected_objects)
    return (category)
def process_detected_objects(detected_objects):
    if 'person' in detected_objects:
        return 'person'
    elif 'animals' in detected_objects:
        return 'animals'
    elif 'food' in detected_objects:
        return 'food'
    else:
        return 'thing'
print(get_category(image_path))