from django.contrib import admin
from .models import Artist


@admin.register(Artist)
class ArtistAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'featured', 'created_at']
    list_filter = ['category', 'featured']
    search_fields = ['name', 'bio']
    list_editable = ['featured']
