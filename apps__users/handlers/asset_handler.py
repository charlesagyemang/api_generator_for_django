
from utils.route_handler import RouteHandler
from apps__users.services.asset_service import AssetService
from utils.api_responses import ApiResponse
from utils.context import Context
import json

class AssetHandler(RouteHandler):
  def __init__(self):
    super().__init__()
    self.service = AssetService()
    self.registerRoutes()

  def registerRoutes(self):
    self.add('/assets.info', self.info)
    self.add('/assets.create', self.create)
    self.add('/assets.update', self.update)
    self.add('/assets.list', self.list)
    self.add('/assets.delete', self.delete)
    self.add('/assets.archive', self.archive)
    self.add('/assets.test', self.test)
    # MANY TO MANY ROUTE SECTION
     
		self.add('/assets.add.documents', self.add_documents)
		self.add('/assets.add.files', self.add_files)
		self.add('/assets.add.reports', self.add_reports)


  def test(self, request):
    context: Context = request.context
    args: dict = context.args
    data,err = self.service.test(context, args)
    if err:
      return err
    return ApiResponse(data=data)

  def info(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    self.validator.expect('id', str, is_required=True)
    args, err = self.validator.verify(args, strict=True)
    if err:
      return err
    response, err = self.service.info(context, args)
    if err:
      return err
    return ApiResponse(data=response)


  def list(self, request):
    context: Context = request.context
    args: dict = context.args
    roles, err = self.service.list(context, args)
    if err:
      return err
    return ApiResponse(data=roles)

  def delete(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    self.validator.expect('id', str, is_required=True)
    args, err = self.validator.verify(args, strict=True)
    if err:
      return err
    response, err = self.service.delete(context, args)
    if err:
      return err
    return ApiResponse(data=response)

  def archive(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    print(' HAndler =====ARCHIVE======', args)
    self.validator.expect('id', str, is_required=True)
    args, err = self.validator.verify(args, strict=True)
    if err:
      return err
    response, err = self.service.archive(context, args)
    if err:
      return err
    return ApiResponse(data=response)

  def create(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    self.validator.expect('name', str, is_required=True)
		self.validator.expect('description', str, is_required=False)
		self.validator.expect('is_archived', bool, is_required=False)
		self.validator.expect('info', json, is_required=False)
    args, err = self.validator.verify(args, strict=True)
    if err:
      return err
    response, err = self.service.create(context, args)
    if err:
      return err
    return ApiResponse(data=response)


  def update(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    self.validator.expect('id', str, is_required=True)
		self.validator.expect('name', str, is_required=False)
		self.validator.expect('description', str, is_required=False)
		self.validator.expect('is_archived', bool, is_required=False)
		self.validator.expect('info', json, is_required=False)
    args, err = self.validator.verify(args, strict=True)
    if err:
      return err
    response, err = self.service.update(context, args)
    if err:
      return err
    return ApiResponse(data=response)
    

  ##################### MANY TO MANY FUNCTION SECTION BEGIN ##############################
  

  def add_documents(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    self.validator.expect('id', str, is_required=True)
    self.validator.expect('documents_array', json, is_required=True)
    args, err = self.validator.verify(args, strict=True)
    # print('====== ARGS ======', args)
    if err:
      return err
    args['documents_array'] = json.loads(args['documents_array'])
    response, err = self.service.add_documents(context, args)
    if err:
      return err
    return ApiResponse(data=response)

     


  def add_files(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    self.validator.expect('id', str, is_required=True)
    self.validator.expect('files_array', json, is_required=True)
    args, err = self.validator.verify(args, strict=True)
    # print('====== ARGS ======', args)
    if err:
      return err
    args['files_array'] = json.loads(args['files_array'])
    response, err = self.service.add_files(context, args)
    if err:
      return err
    return ApiResponse(data=response)

     


  def add_reports(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    self.validator.expect('id', str, is_required=True)
    self.validator.expect('reports_array', json, is_required=True)
    args, err = self.validator.verify(args, strict=True)
    # print('====== ARGS ======', args)
    if err:
      return err
    args['reports_array'] = json.loads(args['reports_array'])
    response, err = self.service.add_reports(context, args)
    if err:
      return err
    return ApiResponse(data=response)

     
  ##################### MANY TO MANY FUNCTION SECTION END ##############################

