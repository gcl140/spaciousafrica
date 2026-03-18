from django.contrib import admin
from .models import GalleryItem, NewProject


@admin.register(GalleryItem)
class GalleryItemAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'created_at']
    list_filter = ['category']
    search_fields = ['title']


@admin.register(NewProject)
class NewProjectAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'status', 'release_date', 'created_at']
    list_filter = ['category', 'status']
    search_fields = ['title']
    list_editable = ['status']
