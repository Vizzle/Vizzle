require "./template_item.rb"

puts "==========================================="
puts "Test Item"
puts "==========================================="

#{
# property : [{type=>name},{type=>name},...]
# class:xxx
# superclass:xxx 
#}

hash = {"class" => "TestListItem",
        "superclass" => "VZItem",
        "property" => [{"name"=>"name","class"=>"NSString"},{"name"=>"desc","class"=>"NSArray"}]}
  
puts "Hash Value : #{hash}"
puts "\n"

h = T_Item::renderH(hash)
puts h
puts "-------------------------------------------"
m = T_Item::renderM(hash)
puts m