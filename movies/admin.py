from django.contrib import admin
from .models import Movie


@admin.register(Movie)
class MovieAdmin(admin.ModelAdmin):
    list_display = ['title', 'genre', 'release_date', 'featured', 'created_at']
    list_filter = ['genre', 'featured', 'release_date']
    search_fields = ['title', 'description']
    list_editable = ['featured']
