from django.db import models


class Movie(models.Model):
    GENRE_CHOICES = [
        ("action", "Action"),
        ("drama", "Drama"),
        ("comedy", "Comedy"),
        ("thriller", "Thriller"),
        ("documentary", "Documentary"),
        ("short", "Short Film"),
        ("other", "Other"),
    ]

    title = models.CharField(max_length=300)
    description = models.TextField()
    genre = models.CharField(max_length=50, choices=GENRE_CHOICES, default="other")
    release_date = models.DateField(null=True, blank=True)
    thumbnail = models.ImageField(upload_to="movies/", null=True, blank=True)
    trailer_url = models.URLField(blank=True)
    youtube_url = models.URLField(blank=True)
    tiktok_url = models.URLField(blank=True)
    instagram_url = models.URLField(blank=True)
    featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return self.title
