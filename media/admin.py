from django.contrib import admin
from .models import MediaItem


@admin.register(MediaItem)
class MediaItemAdmin(admin.ModelAdmin):
    list_display = ['title', 'category', 'coming_soon', 'created_at']
    list_filter = ['category', 'coming_soon']
    search_fields = ['title']
    list_editable = ['coming_soon']
