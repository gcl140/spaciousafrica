from django.db import models
from django.utils import timezone


class Event(models.Model):
    title = models.CharField(max_length=300)
    description = models.TextField()
    venue = models.CharField(max_length=300)
    city = models.CharField(max_length=100, blank=True)
    event_date = models.DateField()
    event_time = models.TimeField(null=True, blank=True)
    ticket_url = models.URLField(blank=True)
    image = models.ImageField(upload_to="events/", null=True, blank=True)
    featured = models.BooleanField(default=False)
    is_free = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["event_date"]

    def __str__(self):
        return f"{self.title} - {self.event_date}"

    def is_upcoming(self):
        return self.event_date >= timezone.now().date()
