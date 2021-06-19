from django.contrib import admin #type: ignore
from django.urls import path #type: ignore
from apps__investments.handlers.investment import InvestmentHandler #type: ignore
from apps__users.handlers.asset_handler import AssetHandler#just added 

# app__users routes Begin ###########
from apps__users.handlers.role_handler import RoleHandler #type: ignore
from apps__users.handlers.permission_handler import PermissionHandler #type: ignore
from apps__users.handlers.userprofile_handler import UserProfileHandler #type: ignore
from apps__users.handlers.usergroup_handler import UserGroupHandler #type: ignore
from apps__users.handlers.auth_handler import AuthHandler #type: ignore
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
  AssetHandler(), #just added 
]

for handler in ROUTE_HANDLERS:
  urlpatterns.extend(handler.get_routes_to_views())
