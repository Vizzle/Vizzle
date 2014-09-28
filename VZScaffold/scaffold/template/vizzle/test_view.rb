require "./template_view.rb"

puts "==========================================="
puts "Test View"
puts "==========================================="


# {
#   class:xxx
#   superclass:xxx
#   itemclass : xxx
# }

hash = {"class" => "TestView",
        "superclass" => "UIView",
        "itemclass" => "TestItem"}
            
h = T_View::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_View::renderM(hash)
puts m