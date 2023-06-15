from django.urls import path,include
from .api import *
from .views import *
urlpatterns = [
    # Other URL patterns
    path('api/endpoint', check_connection, name='check_connection'),
    path('api/upload', upload_image, name='upload_image'),
    path('api/photos', get_all_photos, name='get_all_photos'),
    path('api/category/', fetch_photos_by_category, name='get_photos_by_category'),
    path('api/photos/<int:photo_id>/delete/', delete_photo, name='delete_photo'),
    path('api/duplicated',get_all_duplicate_photos,name="get_all_duplicate_photos"),
    path('api/favorite/<int:photo_id>',add_to_favorite,name="add_to_favorite"),
    path('api/checkFavorite/<int:photo_id>',check_favorite,name="check_favorite"),
    path('api/removeFromFavorite/<int:photo_id>/', remove_from_favorite, name='remove_from_favorite'),

]