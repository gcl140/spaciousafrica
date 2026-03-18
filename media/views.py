from django.shortcuts import render
from .models import MediaItem


def media_list(request):
    items = MediaItem.objects.all()
    return render(request, 'media/media_list.html', {'items': items})
