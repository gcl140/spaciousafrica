from django.contrib import admin
from .models import Event


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ['title', 'venue', 'city', 'event_date', 'is_free', 'featured']
    list_filter = ['is_free', 'featured', 'event_date']
    search_fields = ['title', 'venue', 'city']
    list_editable = ['featured']
