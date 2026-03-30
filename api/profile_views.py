from rest_framework import status
from rest_framework.decorators import api_view, permission_classes, parser_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser

from profiles.models import UserProfile, PRODUCER_TYPES
from movies.models import Movie
from music.models import Track


def _profile_data(user):
    profile, _ = UserProfile.objects.get_or_create(user=user)
    return {
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'is_prod': profile.is_prod,
        'producer_types': profile.producer_types,
        'bio': profile.bio,
        'photo': profile.photo.url if profile.photo else None,
    }


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def me(request):
    return Response(_profile_data(request.user))


@api_view(['PATCH'])
@permission_classes([IsAuthenticated])
def update_profile(request):
    profile, _ = UserProfile.objects.get_or_create(user=request.user)
    data = request.data

    if 'is_prod' in data:
        profile.is_prod = bool(data['is_prod'])

    if 'producer_types' in data:
        types = data['producer_types']
        if not isinstance(types, list):
            return Response({'error': 'producer_types must be a list.'}, status=status.HTTP_400_BAD_REQUEST)
        valid = [t for t, _ in PRODUCER_TYPES]
        invalid = [t for t in types if t not in valid]
        if invalid:
            return Response(
                {'error': f"Invalid types: {invalid}. Valid: {valid}"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        profile.producer_types = types

    if 'bio' in data:
        profile.bio = data['bio']

    profile.save()
    return Response(_profile_data(request.user))


# ── Producer submissions ──────────────────────────────────────────────────────

def _require_prod(user, *allowed_types):
    profile, _ = UserProfile.objects.get_or_create(user=user)
    if not profile.is_prod:
        return 'You must be a producer to submit content.'
    if allowed_types:
        if not any(profile.has_type(t) for t in allowed_types):
            return f"Required producer type(s): {list(allowed_types)}"
    return None


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def submit_track(request):
    err = _require_prod(request.user, 'musician')
    if err:
        return Response({'error': err}, status=status.HTTP_403_FORBIDDEN)

    d = request.data
    title = d.get('title', '').strip()
    if not title:
        return Response({'error': 'Title is required.'}, status=status.HTTP_400_BAD_REQUEST)

    track = Track.objects.create(
        title=title,
        artist_name=d.get('artist_name', request.user.username),
        genre=d.get('genre', 'other'),
        youtube_url=d.get('youtube_url', ''),
        spotify_url=d.get('spotify_url', ''),
        soundcloud_url=d.get('soundcloud_url', ''),
        tiktok_url=d.get('tiktok_url', ''),
        apple_music_url=d.get('apple_music_url', ''),
        featured=False,
    )
    return Response({'id': track.id, 'title': track.title, 'status': 'pending review'},
                    status=status.HTTP_201_CREATED)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def submit_movie(request):
    err = _require_prod(request.user, 'actor', 'actress', 'director', 'producer')
    if err:
        return Response({'error': err}, status=status.HTTP_403_FORBIDDEN)

    d = request.data
    title = d.get('title', '').strip()
    if not title:
        return Response({'error': 'Title is required.'}, status=status.HTTP_400_BAD_REQUEST)

    movie = Movie.objects.create(
        title=title,
        description=d.get('description', ''),
        genre=d.get('genre', 'other'),
        trailer_url=d.get('trailer_url', ''),
        youtube_url=d.get('youtube_url', ''),
        tiktok_url=d.get('tiktok_url', ''),
        instagram_url=d.get('instagram_url', ''),
        featured=False,
    )
    return Response({'id': movie.id, 'title': movie.title, 'status': 'pending review'},
                    status=status.HTTP_201_CREATED)
