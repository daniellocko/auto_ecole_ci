from django.core.exceptions import NON_FIELD_ERRORS, ValidationError
from django.db import connections

from rest_framework import serializers
from django.contrib.auth import authenticate, get_user_model
from django_filters import rest_framework as filters
from django.db.models import Avg,Max,Count,Q
from django.core.validators import RegexValidator
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError as DjangoValidationError

from api.models import *
import logging

logger = logging.getLogger(__name__)


class UserSerializer(serializers.ModelSerializer):
	class Meta:
		model = User
		fields = ['id', 'username', 'email', 'first_name', 'last_name', 'is_instructor', 'is_student']

class InstructorSerializer(serializers.ModelSerializer):
	logo_url = serializers.SerializerMethodField()
	class Meta:
		model = Instructor
		fields = ['id', 'user', 'name','telephone','logo','logo_url','pID','capp']

	def get_logo_url(self, obj):
		if obj.logo:
			return obj.logo.url
		return None


class StudentSerializer(serializers.ModelSerializer):
	class Meta:
		model = Student
		fields = ['id', 'user','num_piece','last_name','telephone','first_name','email','date_of_birth' , 'amount_paid' , 'enrollement_completed','qid', 'instructor']

class EnrollmentSerializer(serializers.ModelSerializer):
	class Meta:
		model = Enrollment
		fields = ['id', 'student','enrollment_date']

class PaymentSerializer(serializers.ModelSerializer):
	class Meta:
		model = Payment
		
		fields = ['enrollment', 'payment_date', 'amount', 'fees', 'currency', 'customer_reference', \
			'payment_ref_id', 'purchase_reference', 'payment_token', \
			'methode', 'provider', 'mobile','payment_status']


class PaymentRequestSerializer(serializers.Serializer):
	amount = serializers.DecimalField(max_digits=10,decimal_places=2)
	mobile = serializers.CharField(max_length=10)
	reference = serializers.CharField(max_length=100)
	otp = serializers.CharField(max_length=10,required=False, allow_blank=True)
	provider = serializers.CharField(max_length=10)


class UserRegistrationSerializer(serializers.Serializer):
	email = serializers.EmailField()
	first_name = serializers.CharField(max_length=100)
	last_name = serializers.CharField(max_length=100)
	telephone = serializers.CharField(max_length=10)
	num_piece = serializers.CharField(max_length=10)
	enrollment_date = serializers.DateField()
	date_of_birth = serializers.DateField()
	is_instructor = serializers.BooleanField()
	is_student = serializers.BooleanField()
	
class StudentFilterSerializer(serializers.Serializer):
	email = serializers.EmailField(required=False, allow_blank=True)
	name = serializers.CharField(max_length=100,required=False, allow_blank=True)
	instructor = serializers.CharField(max_length=100,required=False, allow_blank=True)
	user = serializers.IntegerField(default=0)

	class Meta:
		fields = ['email', 'name', 'instructor', 'user']


class UserFilterSerializer(serializers.Serializer):
	email = serializers.EmailField(required=False, allow_blank=True)
	class Meta:
		fields = ['email']


class InstructorRegistrationSerializer(serializers.Serializer):
	name = serializers.CharField(max_length=100)
	capp = serializers.CharField(max_length=100)
	logo = serializers.ImageField(required=False)
	email = serializers.EmailField()
	first_name = serializers.CharField(max_length=100)
	last_name = serializers.CharField(max_length=100)
	telephone = serializers.CharField(max_length=10)
	password = serializers.CharField(
		max_length=50, 
		min_length=4, 
		write_only=True
	)
	password2 = serializers.CharField(max_length=100)
			
	def validate(self, data):
		"""
		Check that the two password entries match.
		"""
		if data['password'] != data['password2']:
			raise serializers.ValidationError("Passwords do not match.")
		return data
	
	def validate_password(self, value):
		"""
		Validate password against Django's built-in password validators.
		"""
		try:
			validate_password(value)
		except DjangoValidationError as e:
			raise serializers.ValidationError(e.messages)
		return value

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(max_length=128, write_only=True)

class ReturnUserSerializer(serializers.Serializer):
	code = serializers.CharField(max_length=1)
	message = serializers.CharField(max_length=150)
	user = UserSerializer()  # Use the UserSerializer for the user field
	token = serializers.CharField(max_length=150)
	refresh = serializers.CharField(max_length=150)
	student = StudentSerializer()
	instructor = InstructorSerializer()