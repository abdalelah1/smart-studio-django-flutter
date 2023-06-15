import os
from django.conf import settings
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from requests import Response
from rest_framework.decorators import api_view
import cv2
from .detect_images import find_duplicate_photos ,calculate_hash


from smartStudio.serializers import PhotoSerializer
from .models import *
from django.http import JsonResponse
# Create your views here.
from django.http import HttpResponse
@csrf_exempt
def upload_image(request):
    if request.method == 'POST' and request.FILES.get('image'):
        image = request.FILES['image']
        title = request.POST.get('title', '')
        photo = Photo(title=title, image=image)
        photo.save()
        
        category = get_category(photo.image.path)  # Obtain category after saving the photo
        photo.Category = category  # Update the category field of the photo
        photo.save()  # Save the photo again with the updated category
        duplicate_photos = find_duplicate_photos(settings.MEDIA_ROOT)
        image_hash = calculate_hash(photo.image.path)
        if image_hash in duplicate_photos:
            # Create a DuplicatedPhotos instance for the duplicate photo
            duplicated_photo = DuplicatedPhotos(image=photo)
            duplicated_photo.save() 
        
        print("category is", category)
        
        return JsonResponse({'message': 'Image saved successfully.'})
    
    return JsonResponse({'error': 'Invalid request.'}, status=400)
@csrf_exempt
def delete_photo(request, photo_id):
    try:
        photo = Photo.objects.get(id=photo_id)
        file_path = photo.image.path
        photo.delete()
        if os.path.exists(file_path):
            os.remove(file_path)
        return JsonResponse({'message': 'Image deleted successfully.'})
    except Photo.DoesNotExist:
        return JsonResponse({'error': 'Image not found.'}, status=404)
@api_view(['GET'])
def get_all_photos(request):
    photos = Photo.objects.all()
    serializer = PhotoSerializer(photos, many=True)
    return JsonResponse(serializer.data, safe=False)
def get_category(image_path):
    class_names_path = 'smartStudio/algorithm/files/thing.names'
    model_path = 'smartStudio/algorithm/files/frozen_inference_graph.pb'
    config_path = 'smartStudio/algorithm/files/ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt'
    
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
    
    category = process_detected_objects(detected_objects)
    return category

def process_detected_objects(detected_objects):
    if 'person' in detected_objects:
        return 'person'
    elif 'animals' in detected_objects:
        return 'animals'
    elif 'food' in detected_objects:
        return 'food'
    else:
        return 'thing'
    
@csrf_exempt
def fetch_photos_by_category(request):
    print(request.GET.get('category'))
    if request.method == 'GET':
        category = request.GET.get('category')
        photos = Photo.objects.filter(Category=category)
        
        # Serialize the photos data
        serialized_photos = []
        for photo in photos:
            serialized_photo = {
                'id': photo.id,
                'title': photo.title,
                'description': photo.description,
                'image': photo.image.url,
                'Category': photo.Category
            }
            serialized_photos.append(serialized_photo)

        return JsonResponse(serialized_photos, safe=False)
    else:
        return JsonResponse({'error': 'Invalid request method.'}, status=400)

def get_all_duplicate_photos(request):
    duplicate_photos = DuplicatedPhotos.objects.all()
    serialized_photos = []

    for duplicate_photo in duplicate_photos:
        photo = duplicate_photo.image
        serialized_photo = {
            'id': photo.id,
            'image': photo.image.url,
            'title': photo.title,
            'description': photo.description,
            'category': photo.Category,
            'date_taken': photo.date_taken,
        }
        serialized_photos.append(serialized_photo)

    return JsonResponse(serialized_photos, safe=False)
@csrf_exempt
def add_to_favorite(request, photo_id):
    print("from add to favorite")
    try:
        photo = Photo.objects.get(id=photo_id)
        favorite_photo, created = FavoritePhotos.objects.get_or_create(image=photo)
        
        if created:
            return JsonResponse({'message': 'Image added to favorites successfully.'})
        else:
            return JsonResponse({'message': 'Image is already in favorites.'})
    
    except Photo.DoesNotExist:
        return JsonResponse({'error': 'Image not found.'}, status=404)
@csrf_exempt
def check_favorite(request, photo_id):
    try:
        photo = Photo.objects.get(id=photo_id)
        is_favorite = FavoritePhotos.objects.filter(image=photo).exists()
        print("is_favorite",is_favorite)
        print("is_favorite",is_favorite)
        return JsonResponse({'is_favorite': is_favorite})
    
    except Photo.DoesNotExist:
        return JsonResponse({'error': 'Image not found.'}, status=404)
def remove_from_favorite(request, photo_id):
    try:
        favorite_photo = FavoritePhotos.objects.get(image_id=photo_id)
        favorite_photo.delete()
        return JsonResponse({'message': 'Photo removed from favorites.'})
    except FavoritePhotos.DoesNotExist:
        return JsonResponse({'error': 'Photo not found in favorites.'}, status=404)
