require_relative './generator'

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
      puts ASSOCIATIONS
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
