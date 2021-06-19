
from apps__users.store.asset_store import AssetStore
from utils.context import Context
from utils.api_responses import ApiResponse
from utils.api_errors import ApiError
from utils.common import serialize, serialize_all

class AssetService:
  def __init__(self):
    self.store =  AssetStore()

  def test(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    return {'Welcome': 'Akwaaba To Asset Route'}, None

  def info(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    response, err = self.store.info(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None

  def create(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    # print('==== INIT ARGS =====', args)
    response, err = self.store.create(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None

  def update(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    # print('==== INIT ARGS =====', args)
    response, err = self.store.update(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None

  def archive(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    print('==== SERVICE INIT ARGS =====', args)
    response, err = self.store.archive(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None

  def delete(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    # print('==== INIT ARGS =====', args)
    response, err = self.store.delete(context, args)
    if err:
      return None, err
    return response, None

  def list(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    response, err = self.store.list(context, args)
    if err:
      return None, err
    return serialize_all(response), None

  ##################### MANY TO MANY FUNCTION SECTION BEGIN ##############################
  

  def add_documents(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    # print('==== INIT ARGS =====', args)
    response, err = self.store.add_documents(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None
     


  def add_files(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    # print('==== INIT ARGS =====', args)
    response, err = self.store.add_files(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None
     


  def add_reports(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    # print('==== INIT ARGS =====', args)
    response, err = self.store.add_reports(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None
     
  ##################### MANY TO MANY FUNCTION SECTION END ##############################

