import uuid
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .models import Applicant, AcademicRecord, AdmissionApplication, ProgramPreference
from .serializers import (
    ApplicantSerializer, AcademicRecordSerializer,
    AdmissionApplicationSerializer
)

@api_view(['POST', 'GET'])
@permission_classes([IsAuthenticated])
def applicant_profile(request):
    if request.method == 'GET':
        try:
            applicant = Applicant.objects.get(user=request.user)
            return Response(ApplicantSerializer(applicant).data)
        except Applicant.DoesNotExist:
            return Response({}, status=status.HTTP_404_NOT_FOUND)

    applicant, _ = Applicant.objects.get_or_create(user=request.user)
    serializer = ApplicantSerializer(applicant, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_academic_record(request):
    try:
        applicant = Applicant.objects.get(user=request.user)
    except Applicant.DoesNotExist:
        return Response({'error': 'Complete your profile first.'}, status=400)

    serializer = AcademicRecordSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(applicant=applicant)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_academic_records(request):
    try:
        applicant = Applicant.objects.get(user=request.user)
        records = AcademicRecord.objects.filter(applicant=applicant)
        from .serializers import AcademicRecordSerializer
        return Response(AcademicRecordSerializer(records, many=True).data)
    except Applicant.DoesNotExist:
        return Response([])

@api_view(['POST', 'GET'])
@permission_classes([IsAuthenticated])
def admission_application(request):
    if request.method == 'GET':
        try:
            applicant = Applicant.objects.get(user=request.user)
            apps = AdmissionApplication.objects.filter(applicant=applicant)
            return Response(AdmissionApplicationSerializer(apps, many=True).data)
        except Applicant.DoesNotExist:
            return Response([])

    try:
        applicant = Applicant.objects.get(user=request.user)
    except Applicant.DoesNotExist:
        return Response({'error': 'Complete your profile first.'}, status=400)

    app_number = 'APP-2026-' + str(uuid.uuid4())[:8].upper()
    admission_type = request.data.get('admission_type', 'Regular')
    preferences_data = request.data.get('preferences', [])

    application = AdmissionApplication.objects.create(
        applicant=applicant,
        application_number=app_number,
        admission_type=admission_type
    )

    for pref in preferences_data:
        ProgramPreference.objects.create(
            application=application,
            program=pref.get('program',''),
            preference_order=pref.get('preference',''),
            department=pref.get('department','Faculty of Computing & IT')
        )

    return Response({
        'application_id': application.id,
        'application_number': application.application_number,
        'status': application.status
    }, status=status.HTTP_201_CREATED)
