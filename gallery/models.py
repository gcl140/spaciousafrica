from django.db import models


class GalleryItem(models.Model):
    CATEGORY_CHOICES = [
        ("gallery", "Gallery"),
        ("bts", "Behind The Scenes"),
        ("artists", "Artists"),
        ("events", "Events"),
    ]

    title = models.CharField(max_length=300)
    image = models.ImageField(upload_to="gallery/")
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default="gallery")
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.title} ({self.get_category_display()})"


class NewProject(models.Model):
    CATEGORY_CHOICES = [
        ("movie", "Movie"),
        ("music", "Music"),
        ("series", "Series"),
        ("other", "Other"),
    ]
    STATUS_CHOICES = [
        ("upcoming", "Upcoming"),
        ("in_production", "In Production"),
        ("released", "Released"),
    ]

    title = models.CharField(max_length=300)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default="movie")
    description = models.TextField()
    thumbnail = models.ImageField(upload_to="projects/", null=True, blank=True)
    release_date = models.DateField(null=True, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="upcoming")
    teaser_url = models.URLField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.title} ({self.get_status_display()})"
