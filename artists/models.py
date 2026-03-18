from django.db import models


class Artist(models.Model):
    CATEGORY_CHOICES = [
        ("musician", "Musician"),
        ("actor", "Actor"),
        ("actress", "Actress"),
        ("director", "Director"),
        ("producer", "Producer"),
        ("other", "Other"),
    ]

    name = models.CharField(max_length=200)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES, default="musician")
    bio = models.TextField()
    photo = models.ImageField(upload_to="artists/", null=True, blank=True)
    instagram_url = models.URLField(blank=True)
    youtube_url = models.URLField(blank=True)
    tiktok_url = models.URLField(blank=True)
    spotify_url = models.URLField(blank=True)
    featured = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["name"]

    def __str__(self):
        return f"{self.name} ({self.get_category_display()})"
