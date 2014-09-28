
def rb2objc(clz)
  ret = ""
  clzStr = clz.to_s
  
  if clzStr == "String"
    ret = "NSString"
  elsif clzStr == "Array"
    ret = "NSArray"
  elsif clzStr == "Hash"
    ret = "NSDictionary"
  elsif clzStr = "Fixnum"
    ret = "NSNumber"
  elsif clzStr = "Float"
    ret = "NSNumber"
  end

end

def commentsOfFile(type,name,author)
  
  str = ""
  
  if(type == "h")
    str += "// #{name}.h \n"
  else
    str = "// #{name}.m \n"
  end
  
  str += "// iCoupon \n" + "//"  "created by #{author} on #{Time.new}. \n"
  str += "// Copyright (c) @taobao. All rights reserved.\n"
  str += "// \n\n"
  
  return str

end


def headerFileContent(imports,name,clz,properties,methods,protocols)

  str = "\n\n"
  
  #imports
  imports.each{|i| str += "@class #{i};\n"}
  
  str += "\n"
  
  #@interface name:clz
  str += "@interface #{name} : #{clz}"
  
  #protocols
  if(protocols.count > 0)
    str += "<"
    str += protocols.join(",")
    str += ">"
  end
  
  str += "\n\n"

  #properties
  properties.each{|p| str += "#{p};\n" }
  
  str += "\n"
  
  #methods
  methods.each{|m| str += "#{m};\n"}
  
  str += "\n\n"
  
  #@end
  str += "@end\n"

  return str
  
end



