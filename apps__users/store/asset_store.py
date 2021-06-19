
from apps__users.models import Asset
from utils.context import Context
from utils.api_errors import ApiError
from typing import List

class AssetStore:
  def __init__(self):
    self.model =  Asset

  def create(self, context: Context, args: dict) -> (Asset, ApiError): # type: ignore
    try:
      # print(args)
      created_data = Asset(
        name=args['name'],
				description=args['description'],
				documents=args['documents'],
				is_archived=args['is_archived'],
      )
      created_data.save()
      return created_data, None
    except Exception as e:
      return None, ApiError(str(e))

  def update(self, context: Context, args: dict) -> (Asset, ApiError): # type: ignore
    try:
      # print(args)
      id = args['id']
      gotten_data = Asset.objects.filter(pk=id)[0]
      gotten_data.name= args['name']
      gotten_data.description= args['description']
      gotten_data.documents= args['documents']
      gotten_data.is_archived= args['is_archived']
      gotten_data.save()
      return gotten_data, None
    except Exception as e:
      return None, ApiError(str(e))


  def archive(self, context: Context, args: dict) -> (Asset, ApiError): # type: ignore
    try:
      # print('=====ARCHIVE======', args)
      id = args['id']
      gotten_data = Asset.objects.filter(pk=id)[0]
      gotten_data.is_deleted = True
      gotten_data.save()
      return gotten_data, None
    except Exception as e:
      return None, ApiError(str(e))

  def delete(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    try:
      # print(args)
      id = args['id']
      gotten_data = Asset.objects.filter(pk=id)[0]
      gotten_data.delete()
      return {'message': 'Record Deleted Successfully'}, None
    except Exception as e:
      return None, ApiError(str(e))

  def info(self, context: Context, args: dict) -> (Asset, ApiError): # type: ignore
    try:
      # print(args)
      id = args['id']
      gotten_data = Asset.objects.filter(pk=id)[0]
      return gotten_data, None
    except Exception as e:
      return None, ApiError(str(e))


  def list(self, context: Context, args: dict) -> (List[Asset], ApiError): # type: ignore
    try:
      return Asset.objects.all(), None
    except Exception as e:
      return None, ApiError(str(e))

  ##################### MANY TO MANY FUNCTION SECTION BEGIN ##############################
  

  def add_documents(self, context: Context, args: dict) -> (Asset, ApiError): # type: ignore
    try:
      pk, documents_array = args['id'], args['documents_array']
      # print('===documents ARRAY =====', documents_array)
      data_to_update = Asset.objects.filter(pk=pk)[0]
      data_to_update.documents.add(*documents_array)
      data_to_update.save()
      return data_to_update, None
    except Exception as e:
      return None, ApiError(str(e))

     


  def add_documents_test(self, context: Context, args: dict) -> (Asset, ApiError): # type: ignore
    try:
      pk, documents_test_array = args['id'], args['documents_test_array']
      # print('===documents_test ARRAY =====', documents_test_array)
      data_to_update = Asset.objects.filter(pk=pk)[0]
      data_to_update.documents_test.add(*documents_test_array)
      data_to_update.save()
      return data_to_update, None
    except Exception as e:
      return None, ApiError(str(e))

     
  #################### MANY TO MANY FUNCTION SECTION END ##############################

