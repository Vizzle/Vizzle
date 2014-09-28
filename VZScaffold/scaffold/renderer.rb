
require 'fileutils'
require 'JSON'


def _err(str)
  puts "error:".red
  puts str
  exit
end

def _rb2objc(clz)
  ret = ""
  clzStr = clz.to_s
  if clzStr == "String"
    ret = "NSString"
  elsif clzStr == "Array"
    ret = "NSArray"
  elsif clzStr == "Hash"
    ret = "NSDictionary"
  elsif clzStr == "Fixnum"
    ret = "NSNumber"
  elsif clzStr == "Float"
    ret = "NSNumber"
  end

end

class Renderer

attr_accessor :hash_target, :hash_comment

def initialize(target,comment)
	@hash_target  = target
	@hash_comment = comment

	require target["tpath"] 
	require comment["tpath"] 
end

def render
	
	#check to see if @hash_target is item
	if @hash_target["namespace"] == "T_Item" || @hash_target["namespace"] == "T_ListItem"
	
		renderItem

	elsif @hash_target["namespace"] == "T_View" || @hash_target["namespace"] == "T_ListCell"
		
		renderXIB

	else
			renderH
			renderM
	end

end

def renderH

	#puts @hash_target
	clz = @hash_target["class"]
	return if clz.length == 0

	dir_path = @hash_target["filepath"]
	file_path = "#{dir_path}"+"#{clz}.h"

	touch file_path do

		#content
		str_content = ""

		#comment
		@hash_comment["class"] = clz
		comment_namespace = @hash_comment["namespace"]
		str_comment = Object.const_get(comment_namespace)::render(@hash_comment,"h")
		str_content += str_comment

		#header file
		header_namespace = @hash_target["namespace"]
		str_header = Object.const_get(header_namespace)::renderH(@hash_target)
		str_content += str_header

		end

end

def renderM

	clz = @hash_target["class"]
	return if clz.length == 0

	dir_path = @hash_target["filepath"]
	file_path = "#{dir_path}"+"#{clz}.m"

	touch file_path do

		#content
		str_content = ""

		#comment
		@hash_comment["class"] = clz
		comment_namespace = @hash_comment["namespace"]
		str_comment = Object.const_get(comment_namespace)::render(@hash_comment,"m")
		str_content += str_comment

		#body file
		header_namespace = @hash_target["namespace"]
		str_header = Object.const_get(header_namespace)::renderM(@hash_target)
		str_content += str_header

		end

end

def touch(path,&block)

	File.delete(path) if File.exist?path
	File.open(path, "w") { |file|  

		if block_given?
			file.puts block.call
		else
			puts "missing block"
		end
	}
end

def renderXIB

	xib_path = @hash_target["xpath"]

	if xib_path.to_s.length > 0

		
	end

	renderH
	renderM

end

def renderItem

	response_path = @hash_target["response"]

	if response_path.length > 0
	_err "response json does not exist !!" if not File.exist?response_path

		##read response
		puts "Parsing Repsonse: #{response_path}"
		response_json = nil
		begin
		
		f = File.read(response_path)
		
			response_json = JSON.parse(f)

		rescue
		
		  puts "parse response json file error"
		
		end

		propertylist = []
		response_json.each{|k,v|

		 	property = Hash.new
		 	property["name"] = k
		 	property["class"] = _rb2objc(v.class)
		 	propertylist.push property

		}
		#add properties to item
		@hash_target["property"] = propertylist

	end

	renderH
	renderM

end

end
