require "./template_listviewdelegate.rb"

puts "==========================================="
puts "Test ListViewDelegate"
puts "==========================================="

# {
#   class:xxx
#   superclass:xxx
#   cell:xxx
# }
hash = {"class" => "TestListViewDelegate",
        "superclass" => "TBCitySBTableViewDelegate"}
            
h = T_ListViewDelegate::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ListViewDelegate::renderM(hash)
puts m