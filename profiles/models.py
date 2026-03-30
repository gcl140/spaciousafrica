from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver


PRODUCER_TYPES = [
    ('musician', 'Musician'),
    ('actor', 'Actor'),
    ('actress', 'Actress'),
    ('director', 'Director'),
    ('producer', 'Producer'),
    ('writer', 'Writer'),
    ('photographer', 'Photographer'),
]


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    is_prod = models.BooleanField(default=False)
    producer_types = models.JSONField(default=list, blank=True)  # e.g. ["musician", "actor"]
    bio = models.TextField(blank=True)
    photo = models.ImageField(upload_to='profiles/', null=True, blank=True)

    def __str__(self):
        return f"{self.user.username} ({'producer' if self.is_prod else 'consumer'})"

    def has_type(self, t):
        return t in (self.producer_types or [])


@receiver(post_save, sender=User)
def create_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.get_or_create(user=instance)
