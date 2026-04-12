from django.urls import path
from . import views

urlpatterns = [
    path('profile/', views.applicant_profile, name='applicant-profile'),
    path('academic/', views.add_academic_record, name='add-academic'),
    path('academic/list/', views.get_academic_records, name='academic-list'),
    path('application/', views.admission_application, name='application'),
]
