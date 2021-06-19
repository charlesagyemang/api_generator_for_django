module Generator
  def self.generate(model_name, associations, directory, fields)
    route_name = "#{model_name.downcase}s"
base_handler_data_head = """
from utils.route_handler import RouteHandler
from #{directory}.services.#{model_name.downcase}_service import #{model_name}Service
from utils.api_responses import ApiResponse
from utils.context import Context
import json

class #{model_name}Handler(RouteHandler):
  def __init__(self):
    super().__init__()
    self.service = #{model_name}Service()
    self.registerRoutes()

  def registerRoutes(self):
    self.add('/#{route_name}.info', self.info)
    self.add('/#{route_name}.create', self.create)
    self.add('/#{route_name}.update', self.update)
    self.add('/#{route_name}.list', self.list)
    self.add('/#{route_name}.delete', self.delete)
    self.add('/#{route_name}.archive', self.archive)
    self.add('/#{route_name}.test', self.test)
    self.add('/#{route_name}.add.#{associations}', self.add_associations)


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
    #{fields[:form_fields_data_create]}
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
    #{fields[:form_fields_data_update]}
    args, err = self.validator.verify(args, strict=True)
    if err:
      return err
    response, err = self.service.update(context, args)
    if err:
      return err
    return ApiResponse(data=response)


  def add_associations(self, request):
    context: Context = request.context
    args: dict = context.args
    # verify the body of the incoming request
    self.validator.expect('id', str, is_required=True)
    self.validator.expect('#{associations}_array', json, is_required=True)
    args, err = self.validator.verify(args, strict=True)
    # print('====== ARGS ======', args)
    if err:
      return err
    args['#{associations}_array'] = json.loads(args['#{associations}_array'])
    response, err = self.service.add_associations(context, args)
    if err:
      return err
    return ApiResponse(data=response)
"""

# CREATE SERVICE
base_service_data = """
from #{directory}.store.#{model_name.downcase}_store import #{model_name}Store
from utils.context import Context
from utils.api_responses import ApiResponse
from utils.api_errors import ApiError
from utils.common import serialize, serialize_all

class #{model_name}Service:
  def __init__(self):
    self.store =  #{model_name}Store()

  def test(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    return {'Welcome': 'Akwaaba To #{model_name} Route'}, None

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

  def add_associations(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    # print('==== INIT ARGS =====', args)
    response, err = self.store.add_associations(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None
"""


base_store_data = """
from #{directory}.models import #{model_name}
from utils.context import Context
from utils.api_errors import ApiError
from typing import List

class #{model_name}Store:
  def __init__(self):
    self.model =  #{model_name}

  def create(self, context: Context, args: dict) -> (#{model_name}, ApiError): # type: ignore
    try:
      # print(args)
      created_data = #{model_name}(
        #{fields[:create_fields_data]}
      )
      created_data.save()
      return created_data, None
    except Exception as e:
      return None, ApiError(str(e))

  def update(self, context: Context, args: dict) -> (#{model_name}, ApiError): # type: ignore
    try:
      # print(args)
      id = args['id']
      gotten_data = #{model_name}.objects.filter(pk=id)[0]
      #{fields[:update_fields_data]}
      gotten_data.save()
      return gotten_data, None
    except Exception as e:
      return None, ApiError(str(e))


  def archive(self, context: Context, args: dict) -> (#{model_name}, ApiError): # type: ignore
    try:
      # print('=====ARCHIVE======', args)
      id = args['id']
      gotten_data = #{model_name}.objects.filter(pk=id)[0]
      gotten_data.is_deleted = True
      gotten_data.save()
      return gotten_data, None
    except Exception as e:
      return None, ApiError(str(e))

  def delete(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    try:
      # print(args)
      id = args['id']
      gotten_data = #{model_name}.objects.filter(pk=id)[0]
      gotten_data.delete()
      return {'message': 'Record Deleted Successfully'}, None
    except Exception as e:
      return None, ApiError(str(e))

  def info(self, context: Context, args: dict) -> (#{model_name}, ApiError): # type: ignore
    try:
      # print(args)
      id = args['id']
      gotten_data = #{model_name}.objects.filter(pk=id)[0]
      return gotten_data, None
    except Exception as e:
      return None, ApiError(str(e))


  def list(self, context: Context, args: dict) -> (List[#{model_name}], ApiError): # type: ignore
    try:
      return #{model_name}.objects.all(), None
    except Exception as e:
      return None, ApiError(str(e))

  def add_associations(self, context: Context, args: dict) -> (#{model_name}, ApiError): # type: ignore
    try:
      pk, associations_array = args['id'], args['#{associations}_array']
      # print('===PERMISSIONS ARRAY =====', permissions_array)
      data_to_update = #{model_name}.objects.filter(pk=pk)[0]
      data_to_update.#{associations}.add(*associations_array)
      data_to_update.save()
      return data_to_update, None
    except Exception as e:
      return None, ApiError(str(e))
"""



File.open("#{directory}/handlers/#{model_name.downcase}_handler.py", 'w') { |f| f.write base_handler_data_head }
File.open("#{directory}/services/#{model_name.downcase}_service.py", 'w') { |f| f.write base_service_data }
File.open("#{directory}/store/#{model_name.downcase}_store.py", 'w') { |f| f.write base_store_data }
  end
end
