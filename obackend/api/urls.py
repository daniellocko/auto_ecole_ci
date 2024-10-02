from django.urls import include, path
from rest_framework import routers
from rest_framework_simplejwt import views as jwt_views
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework.routers import DefaultRouter
from django.conf.urls import include
from django.conf import settings
from django.conf.urls.static import static
from api.views import SearchView, enrollment,payment,instructor,get_instructor,login,update_instructor,delete_instructor
router = routers.DefaultRouter()
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('', include(router.urls)),
    path('enrollment', enrollment),
    path('payment', payment),
    path('search/', SearchView.as_view(), name='search'),
    path('payment', payment),
    path('instructor', instructor),
    path('update_instructor', update_instructor),
    path('get_instructor', get_instructor),
    path('delete_instructor', delete_instructor),
    path('login', login, name='login'),
    path('user/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('user/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)