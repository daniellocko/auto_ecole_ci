from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth import get_user_model
from .models import Instructor, Student
import logging
logger = logging.getLogger(__name__)


User = get_user_model()

# @receiver(post_save, sender=User)
# def create_user_profile(sender, instance, created, **kwargs):
#     logger.info('Signal on the way.....')
#     if created:
        
#         if instance.is_instructor:
#             Instructor.objects.create(user=instance)
#         elif instance.is_student:
#             Student.objects.create(user=instance)

# @receiver(post_save, sender=User)
# def save_user_profile(sender, instance, **kwargs):
#     if instance.is_instructor:
#         instance.instructor_profile.save()
#     elif instance.is_student:
#         instance.student_profile.save()
