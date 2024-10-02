from django.db import models
import uuid
from django.db import models, IntegrityError, transaction
from django.core import validators
from django.utils import timezone
from datetime import date, datetime
from django.contrib.auth.models import AbstractUser
import os
from django.utils.text import slugify


class BaseModel(models.Model):
	id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
	created_on = models.DateTimeField(default=timezone.now, editable=False, db_index=True)
	updated_on = models.DateTimeField(default=timezone.now, editable=False, db_index=True)
	is_active = models.BooleanField(default=True)
	is_deleted = models.BooleanField(default=False)
	created_uid = models.UUIDField(editable=False,blank=True,null=True)
	updated_uid = models.UUIDField(editable=False,blank=True,null=True)

	class Meta:
		abstract = True

	def save(self, *args, **kwargs):
		self.updated_on = timezone.now()
		super().save(*args, **kwargs)


class User(AbstractUser):
	is_instructor = models.BooleanField(default=False)
	is_student = models.BooleanField(default=False)

class Instructor(BaseModel):
	
	def upload_to(instance, filename):
		print('-----')
		print(filename)
		base, extension = os.path.splitext(filename)
		# Générer un nouveau nom de fichier avec un UUID
		new_filename = f"{slugify(instance.name)}{extension}"
		# Retourner le chemin où enregistrer l'image, par exemple dans 'images' avec la nouvelle date et l'heure
		return os.path.join('images/', new_filename)
	
	user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='instructor_profile')
	name = models.CharField(max_length=100,blank=True,null=True)
	logo = models.ImageField(upload_to=upload_to,null=True, blank=True)
	pID =  models.CharField(max_length=100,null=True,blank=True)
	telephone = models.CharField(max_length=10, blank=True,)
	capp =  models.CharField(max_length=100,null=True,blank=True)

	def __str__(self):
		return self.user.get_full_name()


class Student(BaseModel):
	user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='student_profile')
	instructor = models.ForeignKey(Instructor, on_delete=models.CASCADE,null=True)
	email = models.EmailField(blank=True)
	telephone = models.CharField(max_length=10, blank=True,)
	num_piece = models.CharField(max_length=10, blank=True,)
	last_name = models.CharField(max_length=100, blank=True,)
	first_name = models.CharField(max_length=255, blank=True)
	date_of_birth = models.DateField()
	amount_paid = models.DecimalField(max_digits=10, decimal_places=2,default=0)
	enrollement_completed = models.BooleanField(default=False)
	qid =  models.CharField(max_length=100,null=True,blank=True)

class Enrollment(BaseModel):
	student = models.ForeignKey(Student, on_delete=models.CASCADE)
	enrollment_date = models.DateField(auto_now_add=True)
	#completed = models.BooleanField(default=False)
	
	def __str__(self):
		return f"{self.student.user.get_full_name()} - {self.course.name}"


class Payment(BaseModel):
	enrollment = models.ForeignKey(Enrollment, on_delete=models.CASCADE)
	payment_date = models.DateField(null=True)
	amount = models.DecimalField(max_digits=10, decimal_places=2,default=0)
	fees = models.DecimalField(max_digits=10, decimal_places=2,default=0)
	currency = models.CharField(max_length=10,default='XOF')
	customer_reference = models.CharField(max_length=100,default="EPIK",)
	payment_ref_id = models.CharField(max_length=50,null=True)
	#merchant_id = models.CharField(max_length=50)
	#mode = models.CharField(max_length=20)
	purchase_reference = models.CharField(max_length=100,null=True)
	payment_token = models.CharField(max_length=255,null=True)
	methode = models.CharField(max_length=255,null=True)
	provider =models.CharField(max_length=255,null=True)
	mobile = models.CharField(max_length=10,null=True)
	payment_status = models.CharField(max_length=10,null=True)
	

	def __str__(self):
		return f"{self.enrollment.student.user.get_full_name()} - {self.amount}"



