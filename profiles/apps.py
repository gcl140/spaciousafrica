from django.apps import AppConfig


class ProfilesConfig(AppConfig):
    name = 'profiles'

    def ready(self):
        import profiles.models  # noqa: F401 — registers signals
