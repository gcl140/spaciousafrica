from django.contrib import admin
from django.urls import path, include, re_path
from django.conf import settings
from django.views.static import serve as static_serve

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('core.urls')),
    path('movies/', include('movies.urls')),
    path('music/', include('music.urls')),
    path('adverts/', include('adverts.urls')),
    path('releases/', include('releases.urls')),
    path('wear/', include('wear.urls')),
    path('artists/', include('artists.urls')),
    path('events/', include('events.urls')),
    path('gallery/', include('gallery.urls')),
    path('api/', include('api.urls')),
    # served here (not gated on DEBUG) since there's no separate web server fronting media on this single-box tunnel setup
    re_path(r'^media/(?P<path>.*)$', static_serve, {'document_root': settings.MEDIA_ROOT}),
]
