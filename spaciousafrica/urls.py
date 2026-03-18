from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('core.urls')),
    path('movies/', include('movies.urls')),
    path('music/', include('music.urls')),
    path('adverts/', include('adverts.urls')),
    path('media/', include('media.urls')),
    path('wear/', include('wear.urls')),
    path('artists/', include('artists.urls')),
    path('events/', include('events.urls')),
    path('gallery/', include('gallery.urls')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
