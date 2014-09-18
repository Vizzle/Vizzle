require "./template_listcell.rb"

puts "==========================================="
puts "Test ListCell"
puts "==========================================="


# {
#   class:xxx
#   superclass:xxx
#   itemclass : xxx
#   height : xxx
# }

hash = {"class" => "TestListCell",
        "superclass" => "TBCitySBTableViewCell",
        "itemclass" => "TestListItem",
        "height" =>  "44"}
            
h = T_ListCell::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ListCell::renderM(hash)
puts m