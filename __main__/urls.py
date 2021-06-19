from django.contrib import admin #type: ignore
from django.urls import path #type: ignore
from apps__investments.handlers.investment import InvestmentHandler

# app__users routes Begin ###########
from apps__users.handlers.role_handler import RoleHandler
from apps__users.handlers.permission_handler import PermissionHandler
from apps__users.handlers.userprofile_handler import UserProfileHandler
from apps__users.handlers.usergroup_handler import UserGroupHandler
from apps__users.handlers.auth_handler import AuthHandler
# app__users routes End ###########


urlpatterns = [
    path('admin/', admin.site.urls),
]


### Adding some custom route handlers
ROUTE_HANDLERS = [
  InvestmentHandler(),
  RoleHandler(),
  PermissionHandler(),
  UserProfileHandler(),
  UserGroupHandler(),
  AuthHandler(), 
]

for handler in ROUTE_HANDLERS:
  urlpatterns.extend(handler.get_routes_to_views())
