require 'json'
require 'colorize'
require 'fileutils'
require 'yaml'
require './parser.rb'

$arg0 = ARGV[0]
$arg1 = ARGV[1]
$arg2 = ARGV[2]


config_path = "./proj_config/kof.json"
package_name = $arg0
type = ""
response_json_path = ""

if $arg1.to_s.start_with?"-"
	type = $arg1.to_s

	if $arg2.to_s.end_with?".json"
		response_json_path = $arg2.to_s
	end
else
	type = ""
	if $arg1.to_s.end_with?".json"
		response_json_path = $arg1.to_s
	end
end

# puts "config_path:#{config_path}"
# puts "package_name:#{package_name}"
# puts "type:#{type}"
# puts "response_json_path:#{response_json_path}"


def _err(str)
  puts "error:".red
  puts str
  exit
end

def _log(str)
  puts "...................................................\n"
  puts str
end

                                                                                  
#find config file
_err "config file is not found in #{config_path} !" if not File.exist?(config_path) 

#check package name
_err "Missing PackageName !" if( (not package_name) || (package_name.length == 0) )

#parse json
$g_config = nil;
begin
f = File.read(config_path)
  $g_config = JSON.parse(f)
rescue
  _err "Parse #{config_path} filed"
end

BEGIN{puts "......BEGIN SCAFFOLDING......"}

_log($g_config)

proj_name   = $g_config["proj"] ? $g_config["proj"] : ""
comp_name   = $g_config["comp"] ? $g_config["comp"] : ""
author_name = $g_config["author"] ? $g_config["author"] : ENV['USER']
clz_prefix  = $g_config["clz_prefix"] ? $g_config["clz_prefix"] : ""
sdk_name    = $g_config["sdk"] ? $g_config["sdk"] : ""
_err "Missing SDK name in config file!" if sdk_name.length == 0

#create directory
_log("Create Directory")
FileUtils.mkdir_p ["#{package_name}/controller", "#{package_name}/model", "#{package_name}/view" ,"#{package_name}/logic","#{package_name}/config","#{package_name}/item"]
FileUtils.mkdir_p ["#{package_name}/datasource", "#{package_name}/delegate", "#{package_name}/cell"] if type == "-l"

#get yaml
_log("Read YAML File : ./yml/#{sdk_name.downcase}.yml")
yaml_path = "./yml/#{sdk_name.downcase}.yml"
_err "Missing #{sdk_name.downcase}.yml in ./yml/" if not File.exist?(yaml_path)
template = YAML.load(File.read(yaml_path))
#check yaml
_err "SDK name is inconsistant!!!" if template[:template].downcase != sdk_name.downcase

#controller 
controller_class  		= type == "-l" ? "#{clz_prefix}#{package_name}ListViewController" : "#{clz_prefix}#{package_name}ViewController"
controller_superclass 	= type == "-l" ? "#{template[:listviewcontroller][:class]}" : "#{template[:viewcontroller][:class]}"
controller_tpath 		= type == "-l" ? "./template/#{sdk_name.downcase}/template_#{template[:listviewcontroller][:template]}.rb" : "./template/#{sdk_name.downcase}/template_#{template[:viewcontroller][:template]}.rb"
controller_namespace 	= type == "-l" ? "#{template[:listviewcontroller][:namespace]}" : "#{template[:viewcontroller][:namespace]}"
controller_filepath 	= "./#{package_name}/controller/"

#model
model_class 		= type == "-l" ? "#{clz_prefix}#{package_name}ListModel" : "#{clz_prefix}#{package_name}Model"
model_superclass 	= type == "-l" ? "#{template[:listmodel][:class]}" : "#{template[:model][:class]}"
model_name 			= type == "-l" ? "#{package_name.downcase}ListModel" : "#{package_name.downcase}Model"
model_tpath 		= type == "-l" ? "./template/#{sdk_name.downcase}/template_#{template[:listmodel][:template]}" : "./template/#{sdk_name.downcase}/template_#{template[:model][:template]}.rb"
model_namespace 	= type == "-l" ? "#{template[:listmodel][:namespace]}" :  "#{template[:model][:namespace]}"
model_filepath 		= "./#{package_name}/model/"


#item
item_class 		= type == "-l" ? "#{clz_prefix}#{package_name}ListItem" : "#{clz_prefix}#{package_name}Item"
item_superclass = type == "-l" ? "#{template[:listitem][:class]}" : "#{template[:item][:class]}"
item_tpath 		= type == "-l" ? "./template/#{sdk_name.downcase}/template_#{template[:listitem][:template]}.rb" : "./template/#{sdk_name.downcase}/template_#{template[:item][:template]}.rb"
item_namespace 	= type == "-l" ? "#{template[:listitem][:namespace]}" : "#{template[:item][:namespace]}"
item_filepath 	= type == "-l" ? "./#{package_name}/item/" : "./#{package_name}/item/"
item_response   = response_json_path ? response_json_path : "" 

#view
view_class			= "#{clz_prefix}#{package_name}SubView"
view_superclass		= "#{template[:view][:class]}"
view_tpath			= "./template/#{sdk_name.downcase}/template_#{template[:view][:template]}.rb"
view_filepath 		= "./#{package_name}/view/"
view_namespace      = "#{template[:view][:namespace]}"
view_xibpath 		= ""
view_name			= ""
view_itemclass  	= item_class


#logic
logic_class 		= "#{clz_prefix}#{package_name}Logic"
logic_superclass 	= "#{template[:logic][:class]}"
logic_name 			= "#{package_name.downcase}Logic";
logic_tpath 		= "./template/#{sdk_name.downcase}/template_#{template[:logic][:template]}.rb"
logic_namespace 	= "#{template[:logic][:namespace]}"
logic_filepath 		= "./#{package_name}/logic/"

#datasource
datasource_class 		= type == "-l" ? "#{clz_prefix}#{package_name}ListViewDataSource" : ""
datasource_superclass 	= type == "-l" ? "#{template[:listviewdatasource][:class]}" : ""
datasource_name 		= type == "-l" ? "ds" : ""
datasource_tpath 		= type == "-l" ? "./template/#{sdk_name.downcase}/template_#{template[:listviewdatasource][:template]}.rb" : ""
datasource_namespace 	= type == "-l" ? "#{template[:listviewdatasource][:namespace]}" : ""
datasource_filepath 	= type == "-l" ? "./#{package_name}/datasource/" : ""

#delate 
delegate_class 			= type == "-l" ? "#{clz_prefix}#{package_name}ListViewDelegate" : ""
delegate_superclass 	= type == "-l" ? "#{template[:listviewdelegate][:class]}" : ""
delegate_name 			= type == "-l" ? "dl" : ""
delegate_tpath 			= type == "-l" ? "./template/#{sdk_name.downcase}/template_#{template[:listviewdelegate][:template]}.rb" : ""
delegate_namespace 		= type == "-l" ? "#{template[:listviewdelegate][:namespace]}" : ""
delegate_filepath 		= type == "-l" ? "./#{package_name}/delegate/" : ""

#cell
cell_class 			= type == "-l" ? "#{clz_prefix}#{package_name}ListCell" : ""
cell_superclass 	= type == "-l" ? "#{template[:cell][:class]}" : ""
cell_tpath 			= type == "-l" ? "./template/#{sdk_name.downcase}/template_#{template[:cell][:template]}.rb" : ""
cell_namespace 		= type == "-l" ? "#{template[:cell][:namespace]}" : ""
cell_filepath 		= type == "-l" ? "./#{package_name}/cell/" : ""

#meta json
meta_hash = Hash.new

#controller's hash
controller_hash 				= Hash.new
controller_hash["class"] 		= controller_class
controller_hash["superclass"] 	= controller_superclass
controller_hash["model"] 		= [{"name"=>model_name,"class"=>model_class,"superclass"=>model_superclass}]
controller_hash["datasource"] 	= {"name"=>datasource_name,"class"=>datasource_class,"superclass" => datasource_superclass} if type == "-l"
controller_hash["delegate"] 	= {"name"=>delegate_name,"class"=>delegate_class,"superclass" => delegate_superclass} if type == "-l"
controller_hash["logic"] 		= {"name" => logic_name,"class"=>logic_class,"superclass"=>logic_superclass}
controller_hash["tpath"] 		= controller_tpath
controller_hash["namespace"] 	= controller_namespace
controller_hash["filepath"] 	= controller_filepath
meta_hash["controller"] 		= [].push(controller_hash)

#model's hash
model_hash 					= Hash.new
model_hash["class"] 		= model_class
model_hash["superclass"] 	= model_superclass
model_hash["api"] 			= ""
model_hash["tpath"] 		= model_tpath
model_hash["namespace"] 	= model_namespace
model_hash["filepath"] 		= model_filepath
meta_hash["model"] 			= [].push model_hash

#logic's hash
logic_hash 					= Hash.new
logic_hash["class"] 		= logic_class
logic_hash["superclass"] 	= logic_superclass
logic_hash["tpath"] 		= logic_tpath
logic_hash["namespace"] 	= logic_namespace
logic_hash["filepath"] 		= logic_filepath
meta_hash["logic"] 			= [].push logic_hash

#datasource's hash
datasource_hash 				= Hash.new
datasource_hash["class"] 		= datasource_class
datasource_hash["superclass"] 	= datasource_superclass
datasource_hash["cellclass"] 	= cell_class
datasource_hash["tpath"] 		= datasource_tpath
datasource_hash["namespace"] 	= datasource_namespace
datasource_hash["filepath"] 	= datasource_filepath
meta_hash["datasource"] 		= [].push datasource_hash if type == "-l"

#delegate's hash
delegate_hash 					= Hash.new
delegate_hash["class"] 			= delegate_class
delegate_hash["superclass"] 	= delegate_superclass
delegate_hash["tpath"] 			= delegate_tpath
delegate_hash["namespace"] 		= delegate_namespace
delegate_hash["filepath"] 		= delegate_filepath
meta_hash["delegate"] 			= [].push delegate_hash if type == "-l"

#item's hash
item_hash 				= Hash.new
item_hash["class"] 		= item_class
item_hash["superclass"] = item_superclass
item_hash["response"] 	= item_response
item_hash["tpath"] 		= item_tpath
item_hash["namespace"] 	= item_namespace
item_hash["filepath"] 	= item_filepath
meta_hash["item"] 		= [].push item_hash

#cell's hash
cell_hash 				= Hash.new
cell_hash["class"] 		= cell_class
cell_hash["superclass"] = cell_superclass
cell_hash["itemclass"] 	= item_class
cell_hash["height"] 	= "44"
cell_hash["tpath"] 		= cell_tpath
cell_hash["namespace"] 	= cell_namespace
cell_hash["filepath"] 	= cell_filepath
meta_hash["cell"] 		= [].push cell_hash if type == "-l"

#view's hash
view_hash 				= Hash.new
view_hash["class"]		= view_class
view_hash["superclass"] = view_superclass
view_hash["tpath"]		= view_tpath
view_hash["xpath"] 		= view_xibpath
view_hash["filepath"] 	= view_filepath
view_hash["namespace"]  = view_namespace
view_hash["itemclass"]  = item_class
meta_hash["view"] 		= [].push view_hash


#comment hash
comment_hash 				= Hash.new
comment_hash["class"] 		= ""
comment_hash["comp"] 		= comp_name
comment_hash["proj"] 		= proj_name
comment_hash["author"] 		= author_name
comment_hash["tpath"] 		= "./template/#{sdk_name.downcase}/template_#{template[:comment][:template]}"
comment_hash["namespace"] 	= "#{template[:comment][:namespace]}"
meta_hash["comment"] 		= comment_hash

#create meta.json
meta_json_path = "./#{package_name}/config/#{package_name.downcase}_meta.json"
_log "create meta.json:#{meta_json_path}"
meta_json = JSON.pretty_generate(meta_hash)
File.delete meta_json_path if File.exist? meta_json_path 
File.open(meta_json_path, "w") { |io| io.puts meta_json  }

PARSER::parse(meta_json_path)

END{puts "......END SCAFFOLDING......"}









