# Generated by Django 4.0.4 on 2023-06-15 10:03

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('smartStudio', '0005_rename_category_photo_category'),
    ]

    operations = [
        migrations.CreateModel(
            name='FavoritePhotos',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='smartStudio.photo')),
            ],
        ),
        migrations.CreateModel(
            name='DuplicatedPhotos',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='smartStudio.photo')),
            ],
        ),
    ]
