from rest_framework.decorators import api_view, action, permission_classes,authentication_classes,renderer_classes
from rest_framework.permissions import IsAuthenticated,IsAdminUser,AllowAny
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from django.views.decorators.csrf import csrf_exempt
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.renderers import JSONRenderer
from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED,HTTP_400_BAD_REQUEST,HTTP_200_OK,HTTP_202_ACCEPTED,HTTP_500_INTERNAL_SERVER_ERROR
from django.utils.translation import gettext_lazy as _

from api.serializers import EnrollmentSerializer, InstructorSerializer, UserRegistrationSerializer
from api.services import inscriptionService
from django.db import transaction
from rest_framework import status

import logging
logger = logging.getLogger(__name__)

inscription_service = inscriptionService()


@csrf_exempt
@renderer_classes((JSONRenderer,))
@permission_classes([IsAuthenticated,])
@api_view(['POST'])
@transaction.atomic
def instructor(request):
	try:
		result = inscription_service.instructor_subscription(request.data)
		return Response(data=result,status=HTTP_200_OK)
	except Exception as e:
		logger.error(e)
		raise e
	
@csrf_exempt
@renderer_classes((JSONRenderer,))
@permission_classes([IsAuthenticated,])
@api_view(['POST'])
@transaction.atomic
def update_instructor(request):
	try:
		result = inscription_service._update_instructor(request.data)
		return Response(data=result,status=HTTP_200_OK)
	except Exception as e:
		logger.error(e)
		raise e
	
@csrf_exempt
@renderer_classes((JSONRenderer,))
@permission_classes([IsAuthenticated,])
@api_view(['POST'])
@transaction.atomic
def enrollment(request):
	try:
		logger.info('Enrollment')
		if not request.user.is_instructor:
			return Response(data={'Message':'NOT_VALID_INSTRUCTOR'},status=HTTP_400_BAD_REQUEST)
		
		request.data['user'] = request.user.id
		result = inscription_service.enrollment(request.data)
		return Response(data=result,status=HTTP_200_OK)
	except Exception as e:
		logger.error(e)
		raise e


@csrf_exempt
@renderer_classes((JSONRenderer,))
@permission_classes([IsAuthenticated,])
@api_view(['POST'])
@transaction.atomic
def payment(request):
	try:
		result = inscription_service.send_payment_request(request.data)
		return Response(data=result,status=HTTP_200_OK)
	except Exception as e:
		logger.error(e)
		raise e
	


@csrf_exempt
@renderer_classes((JSONRenderer,))
@permission_classes([IsAuthenticated,])
@api_view(['POST'])
@transaction.atomic
def delete_instructor(request):
	try:

		input_data = request.data
		input_data['request'] = request
		inscription_service.delete_student(input_data)
		return Response(status=HTTP_200_OK)
	except Exception as e:
		logger.error(e)
		return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@csrf_exempt
@renderer_classes((JSONRenderer,))
@permission_classes([IsAuthenticated,])
@api_view(['POST'])
@transaction.atomic
def get_instructor(request):
	try:

		input_data = request.data
		input_data['request'] = request

		result = inscription_service.fetch_instructor(input_data)
		if not result:
			return Response({'error': 'Instructor not found'}, status=status.HTTP_404_NOT_FOUND)
		
		return Response(data=result,status=HTTP_200_OK)
	except Exception as e:
		logger.error(e)
		return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



@csrf_exempt
@permission_classes((AllowAny,))
@api_view(['POST'])
def login(request):
	try:
		result = inscription_service.login(request.data)
		return Response(data=result,status=HTTP_200_OK)
	except Exception as e:
		logger.error(e)
		return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



from rest_framework.views import APIView

@permission_classes([IsAuthenticated,])
class SearchView(APIView):
	renderer_classes = [JSONRenderer]
	permission_classes = [IsAuthenticated,]

	@transaction.atomic
	def search_student(self, request, *args, **kwargs):
		try:
			query_params = request.query_params.copy()
			query_params['user'] =  request.user.id
			result = inscription_service.get_students(query_params)
			return Response(data=result, status=HTTP_200_OK)
		except Exception as e:
			logger.error(e)
			raise e
	
	@transaction.atomic
	def search_user(self, request, *args, **kwargs):
		try:
			result = inscription_service.get_users(request.query_params)
			return Response(data=result,status=HTTP_200_OK)
		except Exception as e:
			logger.error(e)
			raise e
		
	
	def get(self, request, *args, **kwargs):
		search_type = request.query_params.get('type')
		if search_type == 'student':
			return self.search_student(request, *args, **kwargs)
		elif search_type == 'user':
			return self.search_user(request, *args, **kwargs)
		else:
			return Response({'detail': 'Invalid search type.'}, status=HTTP_400_BAD_REQUEST)


