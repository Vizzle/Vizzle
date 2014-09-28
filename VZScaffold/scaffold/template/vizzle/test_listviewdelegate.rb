require "./template_listviewdelegate.rb"

puts "==========================================="
puts "Test VZListViewDelegate"
puts "==========================================="

# {
#   class:xxx
#   superclass:xxx
#   cell:xxx
# }
hash = {"class" => "VZListViewDelegate",
        "superclass" => "VZListViewDelegate"}
            
h = T_ListViewDelegate::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ListViewDelegate::renderM(hash)
puts m