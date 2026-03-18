from django.contrib import admin
from .models import Track


@admin.register(Track)
class TrackAdmin(admin.ModelAdmin):
    list_display = ['title', 'artist_name', 'genre', 'release_date', 'featured']
    list_filter = ['genre', 'featured']
    search_fields = ['title', 'artist_name']
    list_editable = ['featured']
