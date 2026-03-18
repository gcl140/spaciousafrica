from django.shortcuts import render, redirect
from django.contrib import messages
from .models import ContactMessage
from movies.models import Movie
from music.models import Track
from artists.models import Artist
from events.models import Event
from gallery.models import NewProject
from django.utils import timezone


def home(request):
    featured_movies = Movie.objects.filter(featured=True)[:3]
    featured_tracks = Track.objects.filter(featured=True)[:3]
    featured_artists = Artist.objects.filter(featured=True)[:6]
    upcoming_events = Event.objects.filter(event_date__gte=timezone.now().date()).order_by('event_date')[:3]
    upcoming_projects = NewProject.objects.filter(status__in=['upcoming', 'in_production'])[:4]
    context = {
        'featured_movies': featured_movies,
        'featured_tracks': featured_tracks,
        'featured_artists': featured_artists,
        'upcoming_events': upcoming_events,
        'upcoming_projects': upcoming_projects,
    }
    return render(request, 'core/home.html', context)


def about(request):
    return render(request, 'core/about.html')


def contact(request):
    if request.method == 'POST':
        name = request.POST.get('name', '').strip()
        email = request.POST.get('email', '').strip()
        subject = request.POST.get('subject', '').strip()
        message = request.POST.get('message', '').strip()
        if name and email and subject and message:
            ContactMessage.objects.create(
                name=name, email=email, subject=subject, message=message
            )
            messages.success(request, "Your message has been sent! We'll get back to you soon.")
            return redirect('contact')
        else:
            messages.error(request, 'Please fill in all fields.')
    return render(request, 'core/contact.html')
