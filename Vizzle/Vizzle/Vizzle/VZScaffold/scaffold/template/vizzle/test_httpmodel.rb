require "./template_httpmodel.rb"


puts "==========================================="
puts "Test VZHTTPModel"
puts "==========================================="
#{
# class:xxx
# superclass:xxx 
#}

hash = {"class" => "TestModel",
        "superclass" => "VZHTTPModel"}
  
puts "Hash Value : #{hash}"
puts "\n"

h = T_HTTPModel::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_HTTPModel::renderM(hash)
puts m
