require "./template_listItem.rb"

puts "==========================================="
puts "Test VZListItem"
puts "==========================================="

#{
# property : [{type=>name},{type=>name},...]
# class:xxx
# superclass:xxx 
#}

hash = {"class" => "TestListItem",
        "superclass" => "VZListItem",
        "property" => [{"name"=>"name","class"=>"NSString"},{"name"=>"desc","class"=>"NSArray"}]}
  
puts "Hash Value : #{hash}"
puts "\n"

h = T_ListItem::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_ListItem::renderM(hash)
puts m