import datetime
import os
import logging
import random
import requests
import json
from rest_framework.exceptions import ValidationError
from rest_framework.status import HTTP_201_CREATED
from rest_framework.response import Response
from rest_framework.decorators import api_view, renderer_classes
from django_otp import devices_for_user,user_has_device
from django_otp.oath import totp
from rest_framework_simplejwt.tokens import RefreshToken
from django.shortcuts import get_object_or_404
from django.core.exceptions import ObjectDoesNotExist
from django.conf import settings
from api.serializers import InstructorRegistrationSerializer, InstructorSerializer, LoginSerializer, PaymentRequestSerializer, ReturnUserSerializer, StudentFilterSerializer, UserFilterSerializer, UserRegistrationSerializer,\
	UserSerializer,StudentSerializer,EnrollmentSerializer,PaymentSerializer
from .models import Enrollment, Instructor, Payment, Student, User
from django.db import transaction
from django.db.models import Q
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token

from obackend.settings import COUT , DEFAULT_PWD, \
	PAYMENT_URL,PAYMENT_MERCHANT_ID,PAYMENT_APIKEY,PAYMENT_ENV,PAYMENT_CURRENCY
logger = logging.getLogger(__name__)

# faire inscription
# Creation user
# Creation eleve
# Creation inscription 
# class userService:
# 	"""
	
# 	"""
# 	def _create_user(self,request_data):
# 		return user

class inscriptionService:
	"""
	"""
	def delete_student(self,input_data):
		try:
			user_query = Q()
			user_query &= Q(id=input_data.get('id'))
			student = Student.objects.filter(user_query).first()
			student.delete()
		except Exception as e:
			raise e
	
	def _get_instructor_from_user(self,user_id):
		try:
			return Instructor.objects.get(user__id=user_id)
		except Exception as e:
			raise e
	
	def get_students(self,input_data):
		try:			
			srch_srz = StudentFilterSerializer(data=input_data)
			srch_srz.is_valid(raise_exception=True)

			nom = srch_srz.validated_data.get('name')
			email = srch_srz.validated_data.get('email')
			
			
			student_query = Q()
			if nom:
				student_query &= (Q(first_name__icontains=nom) | Q(last_name__icontains=nom))
			if email:
				student_query &= Q(email=email)
			
			if srch_srz.validated_data.get('user') != 0:
				instructor = self._get_instructor_from_user(srch_srz.validated_data.get('user'))
				student_query &= Q(instructor=instructor.id)

			logger.info(f"Student query: {student_query}")
			students = Student.objects.filter(student_query)
			return StudentSerializer(instance=students,many=True).data
		except Exception as e:
			raise e
		
	def fetch_instructor(self,input_data):
		try:
			user_query = Q()
			user_query &= Q(id=input_data.get('id'))
			instructor = Instructor.objects.filter(user_query).first()

			if not instructor:
				return None
			
			return InstructorSerializer(instance=instructor, context={'request': input_data.get('request')}).data

		
		except Exception as e:
			raise e
		
	def get_users(self,input_data):
		try:
			srch_srz = UserFilterSerializer(data=input_data)
			srch_srz.is_valid(raise_exception=True)

			email = srch_srz.validated_data.get('email')

			user_query = Q()
			if email:
				user_query &= Q(email=email)

			users = User.objects.filter(user_query)
			return UserSerializer(instance=users,many=True).data
		
		except Exception as e:
			raise e


	@transaction.atomic
	def _define_password(self,user_id,password):
		"""
		"""
		try:
			logger.info(f'I repeat password {password}')
			user = User.objects.get(pk=user_id)
			user.set_password(password)
			user.save()
		except Exception as e:
			raise e
		
	@transaction.atomic
	def _create_user(self,input_data):
		try:
			user_srz = UserSerializer(data=input_data)
			user_srz.is_valid(raise_exception=True)
			user_instance = user_srz.save()
			user_instance.set_password(DEFAULT_PWD)
			user_instance.save()
			return user_instance
		except Exception as e:
			raise e
	

	@transaction.atomic
	def _create_eleve(self,input_data):
		try:
			logger.info('Eleve creation...')
			eleve_srz = StudentSerializer(data=input_data)
			eleve_srz.is_valid(raise_exception=True)
			eleve_instance = eleve_srz.save()
			return eleve_instance
		except Exception as e:
			raise e
	

	@transaction.atomic
	def _create_instructor(self,input_data):
		try:
			logger.info('Insctructor creation...')
			instructor_srz = InstructorSerializer(data=input_data)
			instructor_srz.is_valid(raise_exception=True)
			instructor_instance = instructor_srz.save()
			return instructor_instance
		except Exception as e:
			raise e
		
	
	@transaction.atomic
	def _update_instructor(self,input_data):
		try:
			logger.debug('Insctructor update...')
			logger.info('Insctructor update...')

			instructor = Instructor.objects.get(pk=input_data.get('id'))
			user_instance = User.objects.get(id=instructor.user.id)
			logger.info(user_instance)

			# Assign the User instance to input_data
			input_data['user'] = user_instance

			# Log input_data to check it
			logger.info(input_data)

			# Update or create the Instructor instance
			instructor, created = Instructor.objects.update_or_create(user=user_instance, defaults=input_data)
			logger.info(f"Instructor created: {created}")
			return InstructorSerializer(instance=instructor).data
			# instructor_srz = InstructorSerializer(data=input_data)
			
			# instructor_srz.is_valid(raise_exception=True)
			# logger.debug(instructor_srz.validated_data)
			# logger.info(instructor_srz.validated_data)
			return 1 #Instructor(input_data).save()
			# instructor_srz = InstructorSerializer(data=input_data)

			# logging.error(
			# 		input_data
			# )

			# instructor_srz.is_valid(raise_exception=True)
			# instructor_instance = instructor_srz.save()
			# return instructor_instance
		except Exception as e:
			raise e
	


	# def get_status(self,):
	# 	configuration = self.getConfig()
	# 	api = MoyenPaiement.objects.filter(code='orange').first()
	# 	operation = None

	# 	if api:
	# 		headers = {
	# 			'Authorization': 'Basic ' + str(api.apiPassword),
	# 			'Content-Type': 'application/x-www-form-urlencoded'
	# 		}
	# 		values = {}
	# 		values['grant_type'] ='client_credentials'
	# 		jvalues = values#json.dumps(values)
	# 		url = api.apiEndpoint + '/oauth/v3/token/'
	# 		r =requests.post(url,jvalues,headers=headers)
	# 		if r.status_code == 200:
	# 			result = json.loads(r.text)
	# 			return result['access_token']
	# 	return None
	

	def create_payment_intent(self,request_data):
		try:
			# Run Payment Intent			
			create_intent_url = PAYMENT_URL + "payment-intents"
			headers = {
				'merchantId': PAYMENT_MERCHANT_ID,
				'environment': PAYMENT_ENV, 
				'ApiKey':PAYMENT_APIKEY,
				'Content-Type': 'application/json'
			}
			reference = str(random.randint(100, 999))+'-'+request_data.get('reference')

			values = {}
			values = {
				'customerReference': str(reference), 
				'purchaseReference': str(reference), 
				'amount': int(request_data.get('amount')),  
				'currency': PAYMENT_CURRENCY
			}

			jvalues = json.dumps(values)
			rq_intent =requests.post(create_intent_url,data=jvalues,headers=headers)

			logger.info('Intent request sent')
			logger.info(f'Intent request result --- {rq_intent.status_code} ')
		
			return rq_intent
		except Exception as e:
			raise e

	def make_payment(self,request_data,intent_dict):
		try:
			headers = {
				'merchantId': PAYMENT_MERCHANT_ID,
				'environment': PAYMENT_ENV, 
				'ApiKey':PAYMENT_APIKEY,
				'Content-Type': 'application/json'
			}

			# Run Payment request
			make_payment_url = PAYMENT_URL + f"payment-intents/{intent_dict.get('id')}/payments"
			values = {}
			values['amount'] = request_data.get('amount')
			values['token'] = intent_dict.get('token')
			values['paymentMethod'] = "mobile_money"
			values['country'] = "CI"
			values['provider'] = request_data.get('provider')
			values['mobileMoney'] = {
				"msisdn" : request_data.get('mobile'),
				"otp" : request_data.get('otp'),
			}

			jvalues = json.dumps(values)
			rq_payment =requests.post(make_payment_url,data=jvalues,headers=headers)

			logger.info('Payment request sent')
			logger.info(f'Payment request result code --- {rq_payment.status_code} ')

			return rq_payment
		except Exception as e:
			raise e

	@transaction.atomic
	def send_payment_request(self,request_data):
		try:
			# Check if submitted data is correct 
			chk_srz = PaymentRequestSerializer(data=request_data)
			chk_srz.is_valid(raise_exception=True)

			# Run Payment Intent			
			create_intent_url = PAYMENT_URL + "payment-intents"
			headers = {
				'merchantId': PAYMENT_MERCHANT_ID,
				'environment': PAYMENT_ENV, 
				'ApiKey':PAYMENT_APIKEY,
				'Content-Type': 'application/json'
			}
			reference = str(random.randint(100, 999))+'-'+request_data.get('reference')

			values = {}
			values = {
				'customerReference': str(reference), 
				'purchaseReference': str(reference), 
				'amount': int(request_data.get('amount')),  
				'currency': PAYMENT_CURRENCY
			}

			jvalues = json.dumps(values)
			rq_intent =requests.post(create_intent_url,data=jvalues,headers=headers)

			logger.info('Intent request sent')
			logger.info(f'Intent request result --- {rq_intent.status_code} ')
			rq_intent = self.create_payment_intent(request_data)
			
			if rq_intent.status_code == HTTP_201_CREATED:
				response_dict = json.loads(rq_intent.text)
				rq_payment = self.make_payment(request_data)

				# Run Payment request
				make_payment_url = PAYMENT_URL + f"payment-intents/{response_dict.get('id')}/payments"
				values = {}
				values['amount'] = request_data.get('amount')
				values['token'] = response_dict.get('token')
				values['paymentMethod'] = "mobile_money"
				values['country'] = "CI"
				values['provider'] = request_data.get('provider')
				values['mobileMoney'] = {
					"msisdn" : request_data.get('mobile'),
					"otp" : request_data.get('otp'),
				}
				jvalues = json.dumps(values)
				rq_payment =requests.post(make_payment_url,data=jvalues,headers=headers)

				logger.info('Payment request sent')
				logger.info(f'Payment request result code --- {rq_payment.status_code} ')

				if rq_payment.status_code == HTTP_201_CREATED:
					# Request successfull
					response_dict = json.loads(rq_payment.text)

					# Check payment status
					payment_data = {
						'enrollment':request_data.get('reference'), 
						'payment_date': datetime.date.today(),  
						'amount': response_dict.get('amount'),
						'fees': response_dict.get('payments')[0].get('fees')[0].get('amount'),
						'currency': response_dict.get('payments')[0].get('currency'),
						'customer_reference':response_dict.get('customerReference') ,
						'payment_ref_id': response_dict.get('id') ,
						'purchase_reference':response_dict.get('purchaseReference'),
						'payment_token': response_dict.get('token'),
						'methode': 'mobile_money',
						'provider': response_dict.get('provider'),  # Replace with the actual provider
						'mobile':response_dict.get('payments')[0].get('number'),  # Replace with the actual phone number
						'payment_status':response_dict.get('status')  # Replace with the actual payment status
					}
					main_srz = PaymentSerializer(data=payment_data)
					main_srz.is_valid(raise_exception=True)
					payment_instance = main_srz.save()
					logger.info(f'Payment {request_data.get('reference')} trace saved !')
					# Payment trace saved

					#Update student payment info
					payment_instance.enrollment.student.amount_paid = payment_instance.enrollment.student.amount_paid + \
					request_data.get('amount')
					
					if payment_instance.enrollment.student.amount_paid >= COUT:
						payment_instance.enrollment.student.enrollement_completed = True
					else:
						payment_instance.enrollment.student.enrollement_completed = False

					payment_instance.enrollment.student.save()
					
					return PaymentSerializer(instance=payment_instance,many=False)
				else:
					raise  ValidationError(rq_payment.text)
			else:
				# Payment failed 
				raise  ValidationError(rq_intent.text)
		except Exception as e:
			raise e
		
	def payment(self,request_data):
		"""
		"""

		try:
			main_srz = PaymentRequestSerializer(data=request_data)
			main_srz.is_valid(raise_exception=True)
			payment_instance = main_srz.save()

			payment_instance.enrollment.student.amount_paid = payment_instance.enrollment.student.amount_paid + \
				main_srz.validated_data.get('amount')
			payment_instance.enrollment.student.save()

			if payment_instance.enrollment.student.amount_paid >= COUT:
				payment_instance.enrollment.student.enrollement_completed = True
			else:
				payment_instance.enrollment.student.enrollement_completed = False

			return StudentSerializer(instance=payment_instance.enrollment.student).data
		except Exception as e:
			raise e


	
	
	@transaction.atomic
	def instructor_subscription(self,request_data):
		"""
		instructor_subscription
		"""
		try:
			data_srz = InstructorRegistrationSerializer(data=request_data)
			data_srz.is_valid(raise_exception=True)
			clean_data = data_srz.validated_data
			
			# Create user first
			logger.info('User creation...')
			user_data = {
				'username':clean_data.get('telephone'), 
				'first_name':clean_data.get('first_name'), 
				'last_name':clean_data.get('last_name'), 
				'email':clean_data.get('email'), 
				'is_instructor':True, 
				'is_student':False, 
			}
			logger.info(user_data)
			user_account = self._create_user(user_data)
			logger.info('User created !')

			logger.info('Define password...')
			logger.info(f"Password is {clean_data.get('password')}")
			self._define_password(user_account.id,clean_data.get('password'))
			logger.info('Password defined !')
			
			pid = str(random.randint(10000000000, 99999999999))

			# Create instructor then
			instructor_data = {
				'name':clean_data.get('name'), 
				'logo':clean_data.get('logo') or None,
				'telephone':clean_data.get('telephone'), 
				'pID':pid,
				'capp':clean_data.get('capp'),
				'user':user_account.id
			}

			logger.info('Instructor creation...')
			ins_account = self._create_instructor(instructor_data)
			logger.info(f'Instructor created  {ins_account} !')

			return InstructorSerializer(instance=ins_account).data

		except Exception as e:
			transaction.set_rollback(True)
			raise e


	@transaction.atomic
	def enrollment(self,request_data):
		"""
		"""
		try:
			request_data['is_instructor'] =False
			request_data['is_student'] =True
			instructor_user_id = request_data['user']
			main_srz = UserRegistrationSerializer(data=request_data)
			main_srz.is_valid(raise_exception=True)
			clean_data = main_srz.validated_data

			logger.info(clean_data)
			logger.info('User creation...')

			user_data = {
				'username':f"s-{clean_data.get('telephone')}", 
				'first_name':clean_data.get('first_name'), 
				'last_name':clean_data.get('last_name'), 
				'email':clean_data.get('email'), 
				'password':clean_data.get('telephone'), 
				'password2':clean_data.get('telephone'), 
				'is_instructor':False,
				'is_student':True
			}
			user_account = self._create_user(user_data)
			logger.info(f'User created {user_account.id} !')


			logger.info('Define user password...')
			self._define_password(user_account.id,clean_data.get('telephone'))
			logger.info('User password defined')
			#self._define_password(user_account.id,'0709030780')

			logger.info('Student creation...')
			qid = str(random.randint(10000000000, 99999999999))
			eleve_data =  {
				'user':user_account.id, 
				'email':clean_data.get('email'), 
				'telephone':clean_data.get('telephone'), 
				'first_name':clean_data.get('first_name'), 
				'last_name':clean_data.get('last_name'), 
				'date_of_birth':clean_data.get('date_of_birth'), 
				'enrollment_date':clean_data.get('enrollment_date'),
				'num_piece':clean_data.get('num_piece'),
				'amount_paid':0,
				'qid':qid, 
				'instructor':self._get_instructor_from_user(instructor_user_id).id, 
			}
			
			eleve_account = self._create_eleve(eleve_data)
			logger.info(f'Student created {eleve_account.id}')
			

			enrollment_data = {
				'student':eleve_account.id,
				'enrollment_date':clean_data.get('enrollment_date'),
			}			
			enrollment_srz = EnrollmentSerializer(data=enrollment_data)
			enrollment_srz.is_valid(raise_exception=True)
			enrollment_instance = enrollment_srz.save()

			#transaction.set_rollback(True)
			return EnrollmentSerializer(instance=enrollment_instance).data
		except Exception as e:
			transaction.set_rollback(True)
			raise e


	def login(self,request_data):
		try:
			serializer = LoginSerializer(data=request_data)
			serializer.is_valid(raise_exception=True)
			clean_data = serializer.validated_data

			username = clean_data.get('username')
			password = clean_data.get('password')

			#user = User.objects.filter(username=username).first()
			
			user = authenticate(username=username, password=password)
			
			if user is not None:
				student = None
				instructor = None
				if user.is_instructor:
					instructor = Instructor.objects.filter(user=user).first()
				elif user.is_student:
					student = Student.objects.filter(user=user).first()

				refresh = RefreshToken.for_user(user)
				logger.info(user)
				data = {
					"code":"1",
					"user":user,
					"instructor":instructor,
					"student":student,
					"token": str(refresh.access_token),
					"refresh": str(refresh),
					"message":"LOGIN_SUCCESS",
				}
				return ReturnUserSerializer(instance=data).data
			else:
				data = {
					"code":"-1",
					"user":None,
					"token": None,
					"refresh": None,
					"instructor":None,
					"student":None,
					"message":"LOGIN_FAILED"
				}
				return ReturnUserSerializer(instance=data).data


		except Exception as e:
			raise e