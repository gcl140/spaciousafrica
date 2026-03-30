from django.contrib import admin
from .models import UserProfile


@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'is_prod', 'producer_types']
    list_filter = ['is_prod']
    list_editable = ['is_prod']
    search_fields = ['user__username', 'user__email']
