"""
Django command to create super user
"""
import os
import random
from unicodedata import name
from django.core.management import BaseCommand
from django.utils.translation import gettext_lazy as _

from api.models import User
import logging
logger = logging.getLogger(__name__)

class Command(BaseCommand):

    def handle(self, *args, **options):
        if User.objects.filter(is_superuser=True).count() == 0:
            username =  os.environ.get('ADMIN_USER')
            email =  os.environ.get('ADMIN_EMAIL')
            password =  os.environ.get('ADMIN_PASS')
            
            logger.info('Creating super user for %s (%s)' % (username, email))
            admin = User.objects.create_superuser(email=email, username=username, password=password)
            admin.is_active = True
            admin.is_admin = True
            admin.save()
        else:
            logger.info(_('Admin accounts can only be initialized if no Accounts exist'))