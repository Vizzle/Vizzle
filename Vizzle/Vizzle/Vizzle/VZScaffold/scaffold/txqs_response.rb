require 'json'
require 'pp'
require './txqs_util.rb'

Dir.exist?("./out/item") ? $g_src_item_path = "/out/item" : ""

g_name = ARGV[0]
g_clz  = ARGV[1]
g_path = ARGV[2]
g_author = ARGV[3]

def createItems(name,clz,path,author)

  if(not path)
    path = "./input.json"
  end
  
  begin
    
    propHash = {}
    propList = []
    
    ##read response.json
    f = File.read(path)
    response = JSON.parse(f)
    
    
    response.each{|k,v|
      propHash[k] = v.class
    }

    propHash.each{|k,v|
  
      c = rb2objc(v)  
      c = "NSString" if(c == "NSNumber")
  
      propList.push("@property(nonatomic,strong)#{c} *#{k}")
    }
    
    if File.exist?(".#{$g_src_item_path}/#{name}.h")
      File.delete(".#{$g_src_item_path}/#{name}.h")
    end

    #header
    File.open(".#{$g_src_item_path}/#{name}.h","w"){ |h|

      str = commentsOfFile("h","#{name}","#{author}")
      h.puts(str)
  
      str = headerFileContent(["#{clz}"],name,clz,propList,[],[])
      h.puts(str)
    }

    #body
    if File.exist?(".#{$g_src_item_path}/#{name}.m")
      File.delete(".#{$g_src_item_path}/#{name}.m")
    end
    File.open(".#{$g_src_item_path}/#{name}.m","w"){|m|

      str = commentsOfFile("m","#{name}","#{author}")
      m.puts(str)
  
      str = "#import \"#{name}.h\"\n\n"
      m.puts(str)
  
      str = "@implementation #{name}\n\n"
      m.puts(str)
  
      str = "-(void) autoKVCBinding:(NSDictionary* )dict {\n"
      m.puts(str)
  
      str = "\n     [super autoKVCBinding:dict];\n\n\n\n"
      m.puts(str)
  
      str = "}\n"
      m.puts str
  
      str = "\n@end"
      m.puts str
  
    }
        
 rescue
     pp "create item:#{name} failed!!"
  end
  
end


if g_name && g_clz && g_path
  createItems(g_name,g_clz,g_path,g_author)
end

