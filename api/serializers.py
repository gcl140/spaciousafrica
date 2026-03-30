from rest_framework import serializers
from movies.models import Movie
from music.models import Track
from artists.models import Artist
from events.models import Event
from wear.models import Product, ProductCategory, Order
from gallery.models import GalleryItem, NewProject


class MovieSerializer(serializers.ModelSerializer):
    class Meta:
        model = Movie
        fields = [
            "id", "title", "description", "genre", "release_date",
            "thumbnail", "trailer_url", "youtube_url", "tiktok_url",
            "instagram_url", "featured", "created_at",
        ]


class TrackSerializer(serializers.ModelSerializer):
    class Meta:
        model = Track
        fields = [
            "id", "title", "artist_name", "genre", "release_date",
            "thumbnail", "youtube_url", "spotify_url", "soundcloud_url",
            "tiktok_url", "apple_music_url", "featured", "created_at",
        ]


class ArtistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Artist
        fields = [
            "id", "name", "category", "bio", "photo",
            "instagram_url", "youtube_url", "tiktok_url", "spotify_url",
            "featured", "created_at",
        ]


class EventSerializer(serializers.ModelSerializer):
    is_upcoming = serializers.SerializerMethodField()

    class Meta:
        model = Event
        fields = [
            "id", "title", "description", "venue", "city",
            "event_date", "event_time", "ticket_url", "image",
            "featured", "is_free", "is_upcoming", "created_at",
        ]

    def get_is_upcoming(self, obj):
        return obj.is_upcoming()


class ProductCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductCategory
        fields = ["id", "name", "slug"]


class ProductSerializer(serializers.ModelSerializer):
    category = ProductCategorySerializer(read_only=True)
    is_in_stock = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = [
            "id", "name", "category", "description", "price",
            "image", "available_sizes", "stock", "featured",
            "is_in_stock", "created_at",
        ]

    def get_is_in_stock(self, obj):
        return obj.is_in_stock()


class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = [
            "id", "product", "customer_name", "customer_email",
            "customer_phone", "quantity", "size", "shipping_address",
            "total_price", "status", "created_at",
        ]


class GalleryItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = GalleryItem
        fields = ["id", "title", "image", "category", "description", "created_at"]


class NewProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = NewProject
        fields = [
            "id", "title", "category", "description", "thumbnail",
            "release_date", "status", "teaser_url", "created_at",
        ]
