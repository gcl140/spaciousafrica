from django.shortcuts import render, get_object_or_404
from .models import Track


def track_list(request):
    genre = request.GET.get('genre', '')
    tracks = Track.objects.all()
    if genre:
        tracks = tracks.filter(genre=genre)
    genres = Track.GENRE_CHOICES
    return render(request, 'music/track_list.html', {'tracks': tracks, 'genres': genres, 'active_genre': genre})


def track_detail(request, pk):
    track = get_object_or_404(Track, pk=pk)
    related = Track.objects.exclude(pk=pk).filter(genre=track.genre)[:3]
    return render(request, 'music/track_detail.html', {'track': track, 'related': related})
