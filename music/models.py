from django.db import models


class Track(models.Model):
    GENRE_CHOICES = [
        ("afrobeats", "Afrobeats"),
        ("hiphop", "Hip Hop"),
        ("rnb", "R&B"),
        ("gospel", "Gospel"),
        ("pop", "Pop"),
        ("jazz", "Jazz"),
        ("other", "Other"),
    ]

    title = models.CharField(max_length=300)
    artist_name = models.CharField(max_length=200)
    genre = models.CharField(max_length=50, choices=GENRE_CHOICES, default="other")
    release_date = models.DateField(null=True, blank=True)
    thumbnail = models.ImageField(upload_to="music/", null=True, blank=True)
    youtube_url = models.URLField(blank=True)
    spotify_url = models.URLField(blank=True)
    soundcloud_url = models.URLField(blank=True)
    tiktok_url = models.URLField(blank=True)
    apple_music_url = models.URLField(blank=True)
    featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.title} - {self.artist_name}"
