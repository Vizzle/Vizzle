require "./template_listcell.rb"

puts "==========================================="
puts "Test VZListCell"
puts "==========================================="


# {
#   class:xxx
#   superclass:xxx
#   itemclass : xxx
#   height : xxx
# }

hash = {"class" => "TestListCell",
        "superclass" => "VZListCell",
        "itemclass" => "TestListItem",
        "height" =>  "44"}
            
h = T_ListCell::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ListCell::renderM(hash)
puts m