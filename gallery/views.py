from django.shortcuts import render
from .models import GalleryItem, NewProject


def gallery(request):
    category = request.GET.get('category', '')
    items = GalleryItem.objects.all()
    if category:
        items = items.filter(category=category)
    categories = GalleryItem.CATEGORY_CHOICES
    return render(request, 'gallery/gallery.html', {'items': items, 'categories': categories, 'active_category': category})


def projects(request):
    upcoming = NewProject.objects.filter(status__in=['upcoming', 'in_production'])
    released = NewProject.objects.filter(status='released')
    return render(request, 'gallery/projects.html', {'upcoming': upcoming, 'released': released})
