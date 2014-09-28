require "./template_httplistmodel.rb"

puts "==========================================="
puts "Test VZHTTPListModel"
puts "==========================================="
#{
# class:xxx
# superclass:xxx 
#}

hash = {"class" => "TestModel",
        "superclass" => "VZHTTPListModel"}
  
puts "Hash Value : #{hash}"
puts "\n"

h = T_HTTPListModel::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_HTTPListModel::renderM(hash)
puts m