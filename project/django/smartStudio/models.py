import datetime
from django.db import models
# class Album(models.Model):
#     name = models.CharField(max_length=100)
#     description = models.TextField(blank=True)
#     created_at = models.DateTimeField(auto_now_add=True)

#     def __str__(self):
#         return self.name

class Photo(models.Model):
    image = models.ImageField()
    title = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    Category=models.CharField(max_length=100)
    date_taken = models.DateField(default=datetime.date.today, blank=True)
    def __str__(self):
        return self.title
class DuplicatedPhotos(models.Model):
    image = models.ForeignKey(Photo, on_delete=models.CASCADE)

    def __str__(self):
        return str(self.image)
class FavoritePhotos(models.Model):
    image = models.ForeignKey(Photo, on_delete=models.CASCADE)

    def __str__(self):
        return str(self.image)