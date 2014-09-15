require 'json'
require 'pp'
require './txqs_controller.rb'
require './txqs_model.rb'
require './txqs_response.rb'
require './txqs_view.rb'

def printSepLine(str)

  puts "...................................................\n"
  puts str + "\n"
end

path = ARGV[0]

BEGIN{puts "......BEGIN SCAFFOLDING......"}

printSepLine("env: #{RUBY_PLATFORM} ")

##read meta data
begin
f = File.read(path)
response = JSON.parse(f)
rescue
  puts "parse json file error"
end



#author
author = response["author"]
puts "author : #{author}"


#create controller
if(response["controller"])
 
  printSepLine("create controller:") 
  response["controller"].each{|controller|

    name = controller["name"]
    clz  = controller["class"]
    pros = controller["protocols"]
    models = controller["models"]
    datasource = controller["datasource"]
    delegate = controller["delegate"]
    logic = controller["logic"]
    
    puts("\nname:#{name}\nclass:#{clz}\nprotocols:#{pros}\nmodels:#{models}\ndatasource:#{datasource}\ndelegate:#{delegate}\nlogic:#{logic}")
   
    #create files
    createControllers(name,clz,pros,models,datasource,delegate,logic,author)
 
  }
end

#create model
if (response["model"])

  printSepLine("create models:")
  response["model"].each{ |model|
  
    name = model["name"]
    clz  = model["class"]
    api  = model["api"]
    v    = model["v"]
    ins  = model["in"]
    outs = model["out"]
    
    puts("\nname:#{name}\nclass:#{clz}\napi:#{api}\nv:#{v}\nins:#{ins}\nouts:#{outs}\n")
    
    #create models
    createModels(name,clz,api,v,ins,outs,author)
  }
end

#create items
if response["item"]
  printSepLine("create items:")
  response["item"].each{|item|
  
    name = item["name"]
    clz  = item["class"]
    resp = item["response"]
 
    puts("\nname:#{name}\nclass:#{clz}\njson_path:#{resp}\n")
    
    #create items
    createItems(name,clz,resp,author)
  }
end

#create views
if(response["view"])
  printSepLine("create views:")
  xib = response["view"]["xib"]
  puts("\nxib_path:#{xib}\n")
  createViews(xib,author)
end

END{puts("......END SCAFFOLDING......")}

