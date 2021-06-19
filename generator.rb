module Helper
  def self.insert_in_line(line_number, data, other_data)
    File.open('__main__/urls.py', 'r+') do |file|
      lines = file.each_line.to_a
      val = lines[line_number]
      lines[line_number]="""#{data}#just added \n#{val}"""
      val2 = lines[-5]
      lines[-5]= """#{val2}  #{other_data}, #just added \n"""
      file.rewind
      file.write(lines.join)
    end
  end

  def self.insert_to_model(directory, data)
    File.open("#{directory}/models.py", 'r+') do |file|
      lines = file.each_line.to_a
      val2 = lines[-1]
      lines[-1]= """#{val2}  #{data}\n #just added \n"""
      file.rewind
      file.write(lines.join)
    end
  end

  def self.format_model_data(fields)
    return_array = [
      'id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)'
    ]
    fields_array = ["id"]
    many_to_many = []
    types = {
      :d    => { :name => "DateField", :default => "" },
      :date => { :name => "DateField", :default => "" },
      :mm   => { :name => "ManyToManyField", :default => "" },
      :fk   => { :name => "ForeignKey", :default => "" },
      :json => { :name => "JSONField", :default => "" },
      :dict => { :name => "JSONField", :default => "" },
      :dt   => { :name => "DateTimeField", :default => "" },
      :s    => { :name => "CharField", :default => "max_length=SHORT_STR_LEN, " },
      :str  => { :name => "CharField", :default => "max_length=SHORT_STR_LEN, " },
      :f    => { :name => "FileField", :default => "" },
      :b    => { :name => "BooleanField", :default => "" },
      :bool => { :name => "BooleanField", :default => "" },
    }
    fields.each_with_index do |field, ind|
      field       = field.split(":")
      field_name  = field[0]
      field_type  = field[1]
      is_required = field[2]  && field[2] == "req" ? "True" : "False"
      key = types[field_type.to_sym]
      if ["mm", "fk"].include?(field_type)
        model = field_name.split("")[0...-1].join("").capitalize()
        field_type == "mm" ? many_to_many.push(field_name) : fields_array.push(field_name)
        return_array.push("  #{field_name} = models.#{key[:name]}(#{model}, #{key[:default]}blank=#{is_required})")
      else
        fields_array.push(field_name)
        return_array.push("  #{field_name} = models.#{key[:name]}(#{key[:default]}blank=#{is_required})")
      end
    end
    return_array.push("  created_at = models.DateTimeField(auto_now_add=True)", "  updated_at = models.DateTimeField(auto_now=True)")
    simple_json_down_part_format_array = ["res['id'] = self.pk"]
    many_to_many.each do |data|
      simple_json_down_part_format_array.push("\t\tres['#{data}'] = list(self.#{data}.values())")
    end
    {
      :response     => return_array.join("\n"),
      :fields_array => fields_array,
      :ass_array    => simple_json_down_part_format_array.join("\n"),
    }
  end

  def self.form_validation_fields(fields)
    form_fields_data_create = []
    form_fields_data_update = []
    create_fields_data = []
    update_fields_data = []
    fields.each_with_index do |field, index|
        each_field = field.split(":")
        field_name, field_type = each_field[0], each_field[1]
        is_required = ""
        (each_field[2] && each_field[2] === "req") ? is_required = "True" : is_required = "False"
        if index > 0
          form_fields_data_create.push("\t\tself.validator.expect('#{field_name}', #{field_type}, is_required=#{is_required})")
          form_fields_data_update.push("\t\tself.validator.expect('#{field_name}', #{field_type}, is_required=False)")
          create_fields_data.push("\t\t\t\t#{field_name}=args['#{field_name}'],")
          update_fields_data.push("\t\t\tgotten_data.#{field_name}= args['#{field_name}']")
        else
          form_fields_data_create.push("self.validator.expect('#{field_name}', #{field_type}, is_required=#{is_required})")
          form_fields_data_update.push("self.validator.expect('id', str, is_required=True)")
          form_fields_data_update.push("\t\tself.validator.expect('#{field_name}', #{field_type}, is_required=False)")
          create_fields_data.push("#{field_name}=args['#{field_name}'],")
          update_fields_data.push("gotten_data.#{field_name}= args['#{field_name}']")
        end
    end
    return {
      :form_fields_data_create   => form_fields_data_create.join("\n"),
      :form_fields_data_update   => form_fields_data_update.join("\n"),
      :create_fields_data => create_fields_data.join("\n"),
      :update_fields_data => update_fields_data.join("\n"),
    }
  end

 def self.association_functions(model_name, route_name, associations_array)

   # associations_array = associations_array.split(",")
   associations_array = [associations_array, "#{associations_array}_test"]

   routes_array = [" "]
   handler_functions_array = []
   services_functions_array = []
   store_functions_array = []

   associations_array.each do |associations|
     ## routes
     routes_array.push("\t\tself.add('/#{route_name}.add.#{associations}', self.add_#{associations})")

     ## handler_function format
     handler_function = """

  def add_#{associations}(self, request):
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
    response, err = self.service.add_#{associations}(context, args)
    if err:
      return err
    return ApiResponse(data=response)

     """

     handler_functions_array.push(handler_function)


     ### services_function_format
     service_function = """

  def add_#{associations}(self, context: Context, args: dict) -> (dict, ApiError): # type: ignore
    # print('==== INIT ARGS =====', args)
    response, err = self.store.add_#{associations}(context, args)
    if err:
      return None, err
    return serialize(response, full=True), None
     """

     services_functions_array.push(service_function)


     ### store_function_format
     store_function = """

  def add_#{associations}(self, context: Context, args: dict) -> (#{model_name}, ApiError): # type: ignore
    try:
      pk, #{associations}_array = args['id'], args['#{associations}_array']
      # print('===#{associations} ARRAY =====', #{associations}_array)
      data_to_update = #{model_name}.objects.filter(pk=pk)[0]
      data_to_update.#{associations}.add(*#{associations}_array)
      data_to_update.save()
      return data_to_update, None
    except Exception as e:
      return None, ApiError(str(e))

     """

     store_functions_array.push(store_function)
   end
   {
     :routes   => routes_array.join("\n"),
     :handlers => handler_functions_array.join("\n"),
     :services => services_functions_array.join("\n"),
     :store    => store_functions_array.join("\n"),
   }
 end

end


module Generator
  def self.generate(model_name, associations, directory, fields)
    route_name = "#{model_name.downcase}s"
    fields = Helper::form_validation_fields(fields)
    ass_functions = Helper::association_functions(model_name, route_name, associations)
    # puts ass_functions
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
    # MANY TO MANY ROUTE SECTION
    #{ass_functions[:routes]}


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
    

  ##################### MANY TO MANY FUNCTION SECTION BEGIN ##############################
  #{ass_functions[:handlers]}
  ##################### MANY TO MANY FUNCTION SECTION END ##############################

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

  ##################### MANY TO MANY FUNCTION SECTION BEGIN ##############################
  #{ass_functions[:services]}
  ##################### MANY TO MANY FUNCTION SECTION END ##############################

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

  ##################### MANY TO MANY FUNCTION SECTION BEGIN ##############################
  #{ass_functions[:store]}
  #################### MANY TO MANY FUNCTION SECTION END ##############################

"""


Helper::insert_in_line(3, "from #{directory}.handlers.#{model_name.downcase}_handler import #{model_name}Handler", "#{model_name}Handler()")
File.open("#{directory}/handlers/#{model_name.downcase}_handler.py", 'w') { |f| f.write base_handler_data_head }
File.open("#{directory}/services/#{model_name.downcase}_service.py", 'w') { |f| f.write base_service_data }
File.open("#{directory}/store/#{model_name.downcase}_store.py", 'w') { |f| f.write base_store_data }
  end


  def self.generate_model(model, directory, fields)
    formatted_fields = Helper::format_model_data(fields)
    model_format = """
class #{model}(models.Model):
  '''
    This describes the #{model} table
  '''
  #{formatted_fields[:response]}

  def __str__(self):
    return self.#{formatted_fields[:fields_array][1]}

  def info(self):
    return model_to_dict(self,['id', '#{formatted_fields[:fields_array][1]}'])


  def simple_json(self):
    res = model_to_dict(self, #{formatted_fields[:fields_array]})
    #{formatted_fields[:ass_array]}
    return res

  def full_json(self):
    return self.simple_json()

  class Meta:
    db_table = '#{model.downcase}'
    ordering = ('-created_at',)
  """
    Helper::insert_to_model(directory, model_format)
  end


end
