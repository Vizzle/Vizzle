require './template_viewcontrollerlogic.rb'

puts "==========================================="
puts "Test ViewControllerLogic"
puts "==========================================="

# {
#   class:xxx
#   superclass:xxx
# }
hash = {"class" => "TestViewControllerLogic",
        "superclass" => "TBCitySBBusinessLogic"}
            
h = T_ViewControllerLogic::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ViewControllerLogic::renderM(hash)
puts m
