require './template_viewcontrollerlogic.rb'

puts "==========================================="
puts "Test VZViewControllerLogic"
puts "==========================================="

# {
#   class:xxx
#   superclass:xxx
# }
hash = {"class" => "TestViewControllerLogic",
        "superclass" => "VZViewControllerLogic"}
            
h = T_ViewControllerLogic::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ViewControllerLogic::renderM(hash)
puts m
