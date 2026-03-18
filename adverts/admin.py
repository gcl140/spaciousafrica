from django.contrib import admin
from .models import Advert


@admin.register(Advert)
class AdvertAdmin(admin.ModelAdmin):
    list_display = ['title', 'client', 'featured', 'created_at']
    list_filter = ['featured', 'created_at']
    search_fields = ['title', 'client']
    list_editable = ['featured']
