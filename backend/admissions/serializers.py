from rest_framework import serializers
from .models import Applicant, AcademicRecord, AdmissionApplication, ProgramPreference

class ApplicantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Applicant
        exclude = ['user', 'created_at', 'updated_at']

class AcademicRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = AcademicRecord
        exclude = ['applicant', 'created_at']

class ProgramPreferenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProgramPreference
        exclude = ['application']

class AdmissionApplicationSerializer(serializers.ModelSerializer):
    preferences = ProgramPreferenceSerializer(many=True, read_only=True)
    class Meta:
        model = AdmissionApplication
        fields = '__all__'
