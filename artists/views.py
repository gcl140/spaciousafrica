from django.shortcuts import render, get_object_or_404
from .models import Artist


def artist_list(request):
    category = request.GET.get('category', '')
    artists = Artist.objects.all()
    if category:
        artists = artists.filter(category=category)
    categories = Artist.CATEGORY_CHOICES
    return render(request, 'artists/artist_list.html', {'artists': artists, 'categories': categories, 'active_category': category})


def artist_detail(request, pk):
    artist = get_object_or_404(Artist, pk=pk)
    related = Artist.objects.exclude(pk=pk).filter(category=artist.category)[:4]
    return render(request, 'artists/artist_detail.html', {'artist': artist, 'related': related})
