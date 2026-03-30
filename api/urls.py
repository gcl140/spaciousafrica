from django.urls import path
from . import views
from . import auth_views
from . import profile_views
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    # Auth
    path('auth/register/', auth_views.register, name='api-register'),
    path('auth/login/', auth_views.login, name='api-login'),
    path('auth/token/refresh/', TokenRefreshView.as_view(), name='api-token-refresh'),
    path('auth/me/', auth_views.me, name='api-me'),
    path('auth/profile/', profile_views.update_profile, name='api-profile-update'),

    # Producer submissions
    path('submit/track/', profile_views.submit_track, name='api-submit-track'),
    path('submit/movie/', profile_views.submit_movie, name='api-submit-movie'),

    # Stats
    path("stats/", views.stats, name="api-stats"),

    # Movies
    path("movies/", views.MovieListView.as_view(), name="api-movies"),
    path("movies/featured/", views.FeaturedMoviesView.as_view(), name="api-movies-featured"),
    path("movies/<int:pk>/", views.MovieDetailView.as_view(), name="api-movie-detail"),

    # Music
    path("music/", views.TrackListView.as_view(), name="api-music"),
    path("music/featured/", views.FeaturedTracksView.as_view(), name="api-music-featured"),
    path("music/<int:pk>/", views.TrackDetailView.as_view(), name="api-track-detail"),

    # Artists
    path("artists/", views.ArtistListView.as_view(), name="api-artists"),
    path("artists/featured/", views.FeaturedArtistsView.as_view(), name="api-artists-featured"),
    path("artists/<int:pk>/", views.ArtistDetailView.as_view(), name="api-artist-detail"),

    # Events
    path("events/", views.EventListView.as_view(), name="api-events"),
    path("events/upcoming/", views.UpcomingEventsView.as_view(), name="api-events-upcoming"),
    path("events/<int:pk>/", views.EventDetailView.as_view(), name="api-event-detail"),

    # Products / Shop
    path("products/", views.ProductListView.as_view(), name="api-products"),
    path("products/<int:pk>/", views.ProductDetailView.as_view(), name="api-product-detail"),
    path("orders/", views.OrderCreateView.as_view(), name="api-order-create"),

    # Gallery
    path("gallery/", views.GalleryListView.as_view(), name="api-gallery"),
    path("projects/", views.NewProjectListView.as_view(), name="api-projects"),
]
