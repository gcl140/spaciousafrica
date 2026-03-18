from django.urls import path
from . import views

urlpatterns = [
    path('', views.advert_list, name='advert_list'),
    path('<int:pk>/', views.advert_detail, name='advert_detail'),
]
