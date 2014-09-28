require "./template_model.rb"


puts "==========================================="
puts "Test Model"
puts "==========================================="
#{
# class:xxx
# superclass:xxx 
#}

hash = {"class" => "TestModel",
        "superclass" => "TBCitySBListModel"}
  
puts "Hash Value : #{hash}"
puts "\n"

h = T_Model::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_Model::renderM(hash)
puts m
