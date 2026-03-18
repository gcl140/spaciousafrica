from django.db import models


class MediaItem(models.Model):
    CATEGORY_CHOICES = [
        ("tv", "TV"),
        ("podcast", "Podcast"),
        ("streaming", "Streaming"),
        ("other", "Other"),
    ]

    title = models.CharField(max_length=300)
    description = models.TextField(blank=True)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES, default="other")
    thumbnail = models.ImageField(upload_to="media_items/", null=True, blank=True)
    link = models.URLField(blank=True)
    coming_soon = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return self.title
