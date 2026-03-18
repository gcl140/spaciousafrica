from django.shortcuts import render, get_object_or_404
from .models import Movie


def movie_list(request):
    genre = request.GET.get('genre', '')
    movies = Movie.objects.all()
    if genre:
        movies = movies.filter(genre=genre)
    genres = Movie.GENRE_CHOICES
    return render(request, 'movies/movie_list.html', {'movies': movies, 'genres': genres, 'active_genre': genre})


def movie_detail(request, pk):
    movie = get_object_or_404(Movie, pk=pk)
    related = Movie.objects.exclude(pk=pk).filter(genre=movie.genre)[:3]
    return render(request, 'movies/movie_detail.html', {'movie': movie, 'related': related})
