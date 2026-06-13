from django.db import models
from django.conf import settings
from academics.models import DegreeProgram

class Applicant(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='applicant_profile'
    )
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    father_name = models.CharField(max_length=100, blank=True)
    cnic = models.CharField(max_length=15, blank=True)
    date_of_birth = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=10, blank=True)
    phone = models.CharField(max_length=20, blank=True)
    religion = models.CharField(max_length=50, blank=True)
    nationality = models.CharField(max_length=50, default='Pakistani')
    marital_status = models.CharField(max_length=20, blank=True)
    perm_country = models.CharField(max_length=50, blank=True)
    perm_state = models.CharField(max_length=50, blank=True)
    perm_city = models.CharField(max_length=50, blank=True)
    perm_address = models.TextField(blank=True)
    emergency_name = models.CharField(max_length=100, blank=True)
    emergency_relation = models.CharField(max_length=50, blank=True)
    emergency_phone = models.CharField(max_length=20, blank=True)
    guardian_name = models.CharField(max_length=100, blank=True)
    guardian_cnic = models.CharField(max_length=13, blank=True)
    guardian_relation = models.CharField(max_length=50, blank=True)
    profile_image = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'admissions_applicant'

    def __str__(self):
        return f'{self.first_name} {self.last_name}'

class AcademicRecord(models.Model):
    GRADING_CHOICES = [('marks','Marks'),('cgpa','CGPA')]
    applicant = models.ForeignKey(
        Applicant, on_delete=models.CASCADE,
        related_name='academic_records'
    )
    authority = models.CharField(max_length=200)
    qualification_level = models.CharField(max_length=50)
    qualification = models.CharField(max_length=200)
    institute = models.CharField(max_length=200)
    roll_number = models.CharField(max_length=20, blank=True)
    start_year = models.IntegerField()
    end_year = models.IntegerField()
    grading_system = models.CharField(max_length=10, choices=GRADING_CHOICES, default='marks')
    obtained = models.DecimalField(max_digits=7, decimal_places=2)
    total = models.DecimalField(max_digits=7, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'admissions_academic_record'

class AdmissionApplication(models.Model):
    STATUS_CHOICES = [
         ('draft', 'Draft'),
        ('pending', 'Pending'),
        ('under_review', 'Under Review'),
        ('documents_pending', 'Documents Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
        ('waitlist', 'Waitlist'),
        ('registered', 'Registered'),
    ]
    ADMISSION_TYPE_CHOICES = [
        ('Regular','Regular'),
        ('Lateral','Lateral'),
        ('Migration','Migration'),
    ]
    applicant = models.ForeignKey(
        Applicant, on_delete=models.CASCADE,
        related_name='applications'
    )
    program = models.ForeignKey(
        DegreeProgram, on_delete=models.RESTRICT,
        related_name='applications'
    )
    application_number = models.CharField(max_length=50, unique=True)
    admission_type = models.CharField(max_length=20, choices=ADMISSION_TYPE_CHOICES, default='Regular')
    session_year          = models.IntegerField(null=True, blank=True)
    session_type          = models.CharField(
        max_length=20,
        choices=[('spring', 'Spring'), ('fall', 'Fall'), ('summer', 'Summer')],
        blank=True
    )
    applied_under_quota   = models.CharField(
        max_length=30,
        choices=[
            ('open_merit', 'Open Merit'),
            ('minority', 'Minority'),
            ('disabled', 'Disabled'),
            ('sports', 'Sports'),
        ],
        default='open_merit'
    )
    is_fee_paid           = models.BooleanField(default=False)
    is_eligible           = models.BooleanField(null=True, blank=True)
    is_documents_verified = models.BooleanField(default=False)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    submitted_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'admissions_application'

class ProgramPreference(models.Model):
    application = models.ForeignKey(
        AdmissionApplication, on_delete=models.CASCADE,
        related_name='preferences'
    )
    program = models.CharField(max_length=200)
    preference_order = models.CharField(max_length=30)
    department = models.CharField(max_length=200, default='Faculty of Computing & IT')

    class Meta:
        db_table = 'admissions_program_preference'

class ApplicantDocument(models.Model):
    DOCUMENT_TYPE_CHOICES = [
        ('matric_certificate', 'Matric Certificate'),
        ('fsc_certificate', 'FSc Certificate'),
        ('cnic_front', 'CNIC Front'),
        ('cnic_back', 'CNIC Back'),
        ('photo', 'Passport Photo'),
        ('domicile', 'Domicile'),
        ('father_cnic', 'Father CNIC'),
        ('other', 'Other'),
    ]

    document_id          = models.AutoField(primary_key=True)
    applicant            = models.ForeignKey(Applicant, on_delete=models.CASCADE, related_name='documents')
    document_type        = models.CharField(max_length=50, choices=DOCUMENT_TYPE_CHOICES)
    file_name            = models.CharField(max_length=255)
    file_path            = models.CharField(max_length=500)
    file_size            = models.IntegerField()
    file_type            = models.CharField(max_length=50)
    uploaded_at          = models.DateTimeField(auto_now_add=True)
    is_verified          = models.BooleanField(default=False)
    verified_by          = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True, blank=True,
        related_name='verified_documents'
    )
    verified_at          = models.DateTimeField(null=True, blank=True)
    verification_remarks = models.TextField(blank=True)

    class Meta:
        db_table = 'applicant_document'
        unique_together = ['applicant', 'document_type']


class AdmissionDecision(models.Model):
    DECISION_CHOICES = [
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
        ('waitlist', 'Waitlist'),
    ]

    decision_id           = models.AutoField(primary_key=True)
    application           = models.OneToOneField(AdmissionApplication, on_delete=models.RESTRICT, related_name='decision')
    decision              = models.CharField(max_length=20, choices=DECISION_CHOICES)
    decided_by            = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.RESTRICT,
        related_name='admission_decisions'
    )
    decision_date         = models.DateField(auto_now_add=True)
    merit_score           = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    merit_position        = models.IntegerField(null=True, blank=True)
    remarks               = models.TextField(blank=True)
    registration_deadline = models.DateField(null=True, blank=True)
    offered_section       = models.CharField(max_length=20, blank=True)
    rejection_reason      = models.TextField(blank=True)
    created_at            = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'admissions_decision'


class AdmissionLog(models.Model):
    ACTION_CHOICES = [
        ('created', 'Created'),
        ('submitted', 'Submitted'),
        ('reviewed', 'Reviewed'),
        ('documents_verified', 'Documents Verified'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
        ('waitlisted', 'Waitlisted'),
    ]

    log_id          = models.AutoField(primary_key=True)
    application     = models.ForeignKey(AdmissionApplication, on_delete=models.CASCADE, related_name='logs')
    action_type     = models.CharField(max_length=50, choices=ACTION_CHOICES)
    performed_by    = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.RESTRICT,
        related_name='admission_logs'
    )
    previous_status = models.CharField(max_length=30, blank=True)
    new_status      = models.CharField(max_length=30, blank=True)
    remarks         = models.TextField(blank=True)
    timestamp       = models.DateTimeField(auto_now_add=True)
    ip_address      = models.GenericIPAddressField(null=True, blank=True)

    class Meta:
        db_table = 'admissions_log'
