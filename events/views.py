from django.shortcuts import render, get_object_or_404
from django.utils import timezone
from .models import Event


def event_list(request):
    now = timezone.now().date()
    upcoming = Event.objects.filter(event_date__gte=now)
    past = Event.objects.filter(event_date__lt=now).order_by('-event_date')
    return render(request, 'events/event_list.html', {'upcoming': upcoming, 'past': past})


def event_detail(request, pk):
    event = get_object_or_404(Event, pk=pk)
    return render(request, 'events/event_detail.html', {'event': event})
