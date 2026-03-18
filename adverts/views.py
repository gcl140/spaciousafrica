from django.shortcuts import render, get_object_or_404
from .models import Advert


def advert_list(request):
    adverts = Advert.objects.all()
    return render(request, 'adverts/advert_list.html', {'adverts': adverts})


def advert_detail(request, pk):
    advert = get_object_or_404(Advert, pk=pk)
    related = Advert.objects.exclude(pk=pk)[:3]
    return render(request, 'adverts/advert_detail.html', {'advert': advert, 'related': related})
