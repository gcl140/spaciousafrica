from rest_framework import generics
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.utils import timezone


class LimitMixin:
    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())
        limit = request.query_params.get("limit")
        if limit is not None:
            try:
                queryset = queryset[: int(limit)]
            except (ValueError, TypeError):
                pass
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

from movies.models import Movie
from music.models import Track
from artists.models import Artist
from events.models import Event
from wear.models import Product, Order
from gallery.models import GalleryItem, NewProject

from .serializers import (
    MovieSerializer, TrackSerializer, ArtistSerializer, EventSerializer,
    ProductSerializer, OrderSerializer, GalleryItemSerializer, NewProjectSerializer,
)


@api_view(["GET"])
def stats(request):
    data = {
        "movies": Movie.objects.count(),
        "tracks": Track.objects.count(),
        "artists": Artist.objects.count(),
        "events": Event.objects.filter(event_date__gte=timezone.now().date()).count(),
        "products": Product.objects.filter(stock__gt=0).count(),
        "gallery": GalleryItem.objects.count(),
    }
    return Response(data)


# Movies
class MovieListView(LimitMixin, generics.ListAPIView):
    serializer_class = MovieSerializer

    def get_queryset(self):
        qs = Movie.objects.all()
        genre = self.request.query_params.get("genre")
        if genre:
            qs = qs.filter(genre=genre)
        return qs


class MovieDetailView(generics.RetrieveAPIView):
    queryset = Movie.objects.all()
    serializer_class = MovieSerializer


class FeaturedMoviesView(LimitMixin, generics.ListAPIView):
    queryset = Movie.objects.filter(featured=True)
    serializer_class = MovieSerializer


# Music
class TrackListView(LimitMixin, generics.ListAPIView):
    serializer_class = TrackSerializer

    def get_queryset(self):
        qs = Track.objects.all()
        genre = self.request.query_params.get("genre")
        if genre:
            qs = qs.filter(genre=genre)
        return qs


class TrackDetailView(generics.RetrieveAPIView):
    queryset = Track.objects.all()
    serializer_class = TrackSerializer


class FeaturedTracksView(LimitMixin, generics.ListAPIView):
    queryset = Track.objects.filter(featured=True)
    serializer_class = TrackSerializer


# Artists
class ArtistListView(LimitMixin, generics.ListAPIView):
    serializer_class = ArtistSerializer

    def get_queryset(self):
        qs = Artist.objects.all()
        category = self.request.query_params.get("category")
        if category:
            qs = qs.filter(category=category)
        return qs


class ArtistDetailView(generics.RetrieveAPIView):
    queryset = Artist.objects.all()
    serializer_class = ArtistSerializer


class FeaturedArtistsView(LimitMixin, generics.ListAPIView):
    queryset = Artist.objects.filter(featured=True)
    serializer_class = ArtistSerializer


# Events
class EventListView(LimitMixin, generics.ListAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer


class EventDetailView(generics.RetrieveAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer


class UpcomingEventsView(LimitMixin, generics.ListAPIView):
    serializer_class = EventSerializer

    def get_queryset(self):
        return Event.objects.filter(event_date__gte=timezone.now().date())


# Products
class ProductListView(LimitMixin, generics.ListAPIView):
    serializer_class = ProductSerializer

    def get_queryset(self):
        qs = Product.objects.all()
        in_stock = self.request.query_params.get("in_stock")
        if in_stock == "true":
            qs = qs.filter(stock__gt=0)
        return qs


class ProductDetailView(generics.RetrieveAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer


class OrderCreateView(generics.CreateAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer


# Gallery
class GalleryListView(LimitMixin, generics.ListAPIView):
    serializer_class = GalleryItemSerializer

    def get_queryset(self):
        qs = GalleryItem.objects.all()
        category = self.request.query_params.get("category")
        if category:
            qs = qs.filter(category=category)
        return qs


class NewProjectListView(LimitMixin, generics.ListAPIView):
    queryset = NewProject.objects.all()
    serializer_class = NewProjectSerializer
