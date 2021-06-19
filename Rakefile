require_relative './generator'

def form_validation_fields(fields)
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
        form_fields_data_create.push("\tself.validator.expect('#{field_name}', #{field_type}, is_required=#{is_required})")
        form_fields_data_update.push("\tself.validator.expect('#{field_name}', #{field_type}, is_required=False)")
        create_fields_data.push("\t\t#{field_name}=args['#{field_name}']")
        update_fields_data.push("\t  gotten_data.#{field_name}= args['#{field_name}']")
      else
        form_fields_data_create.push("self.validator.expect('#{field_name}', #{field_type}, is_required=#{is_required})")
        form_fields_data_update.push("self.validator.expect('id', str, is_required=True)")
        form_fields_data_update.push("\tself.validator.expect('#{field_name}', #{field_type}, is_required=False)")
        create_fields_data.push("#{field_name}=args['#{field_name}']")
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

namespace :g do
    desc 'GENERATE CRUD FUNCTIONALITIES FOR SPECIFIED MODEL IN SPECIFIED FOLDER'
    task :crud do

        ARGV.each { |a| task a.to_sym do ; end }
        MODEL_NAME = ARGV[1].to_s
        ASSOCIATIONS = ARGV[2].to_s
        DIRECTORY =  ARGV[3].to_s
        has_fields = ARGV.length > 4

        if (MODEL_NAME.length > 0 && ASSOCIATIONS.length > 0 &&DIRECTORY.length > 0)
            if has_fields
              FIELDS = ARGV[4..-1]
              Generator::generate(MODEL_NAME, ASSOCIATIONS, DIRECTORY, FIELDS)
              puts "========SUCCESS========"
            else
              puts "========CREATING NECCESSARY FILES========"
              puts "MODEL NAME:   #{MODEL_NAME}"
              puts "ASSOCIATIONS: #{ASSOCIATIONS}"
              puts "DIRECTORY:    #{DIRECTORY}"
              FIELDS = ["name:str:req", "description:str"]
              Generator::generate(MODEL_NAME, ASSOCIATIONS, DIRECTORY, FIELDS)
              puts "========SUCCESS========"
            end
        else
            puts "Error!!!!: See how To Use This Below: \nrake g:crud  <ModelName> <Association> <Directory>"
        end
    end

    task :delete do
        ARGV.each { |a| task a.to_sym do ; end }
        MODEL_NAME = ARGV[1].to_s
        DIRECTORY = ARGV[2].to_s
        `rm -rf #{DIRECTORY}/handlers/#{MODEL_NAME}_handler.py`
        puts "========DELETING #{DIRECTORY}/handlers/#{MODEL_NAME}_handler.py========"
        `rm -rf #{DIRECTORY}/services/#{MODEL_NAME}_service.py`
        puts "========DELETING #{DIRECTORY}/services/#{MODEL_NAME}_service.py========"
        `rm -rf #{DIRECTORY}/store/#{MODEL_NAME}_store.py`
        puts "========DELETING #{DIRECTORY}/store/#{MODEL_NAME}_store.py========"
    end

    task :model do
      ARGV.each { |a| task a.to_sym do ; end }
      MODEL_NAME = ARGV[1].to_s
      DIRECTORY  = ARGV[2].to_s
      FIELDS     = ARGV[3..-1]
      Generator::generate_model(MODEL_NAME, DIRECTORY, FIELDS)
      puts "========SUCCESS========"
    end

    task :scaffold do
      ARGV.each { |a| task a.to_sym do ; end }
      MODEL_NAME = ARGV[1].to_s
      ASSOCIATIONS = ARGV[2].to_s
      DIRECTORY =  ARGV[3].to_s
      has_fields = ARGV.length > 4
      if has_fields
        puts "====== GENERATING MODEL ========"
        FIELDS =  ARGV[4..-1]
        Generator::generate_model(MODEL_NAME, DIRECTORY, FIELDS)
        puts "======== MODEL GENERATED SUCCESSFULLY ========"
        puts "====== GENERATING CRUD ========"
        Generator::generate(MODEL_NAME, ASSOCIATIONS, DIRECTORY, FIELDS)
        puts "======== CRUD GENERATED SUCCESSFULLY ========"
        puts "======== PROCESS COMPLETE ========"
      else
        puts "Error!!!! Please provide fields for the model to be generated with. Read the docs to know how"
      end
      # rake g:scaffold Asset documents apps__users  name:str:req description:str documents:mm is_archived:bool
    end
end
