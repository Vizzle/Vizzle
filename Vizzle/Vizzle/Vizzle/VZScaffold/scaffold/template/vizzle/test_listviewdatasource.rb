require "./template_listviewdatasource.rb"

puts "==========================================="
puts "Test VZListViewDataSource"
puts "==========================================="

# {
#   class:xxx
#   superclass:xxx
#   cellclass:xxx
# }
hash = {"class" => "TestListViewDataSource",
        "superclass" => "VZListViewDataSource",
        "cellclass" => "TestListViewCell"}
            
h = T_ListViewDataSource::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ListViewDataSource::renderM(hash)
puts m