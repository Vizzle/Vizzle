require "./template_viewcontroller.rb"

puts "==========================================="
puts "Test VZViewController"
puts "==========================================="

# {
#   class:xxx
#   superclass:xxx
#   model:[{name:xx,class:xx},....]
#   logic:{name:xx,class:xx}
# }
hash = {"class" => "TestViewController",
        "superclass" => "VZViewController",
        "model" => [{"name"=>"model1","class"=>"TestModel1"},{"name"=>"model2","class"=>"TestModel2"}],
        "logic" => {"name"=>"","class"=>"TestLogic"}}
            
h = T_ViewController::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ViewController::renderM(hash)
puts m
