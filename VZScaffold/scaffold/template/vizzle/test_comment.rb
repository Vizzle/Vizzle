require "./template_comment.rb"

puts "==========================================="
puts "Test VZComment"
puts "==========================================="


#{
# class:xxx
# author:xxx
# comp:xxx
# proj:xxx
#}

hash = {"class" => "TestListCell",
        "superclass" => "VZListCell",
        "comp" => "Vizzle",
        "proj" =>  "iCoupon",
        "author" => "Jayson"}
            
h = T_Comment::render(hash,"h")
puts h
puts "-------------------------------------------"
m = T_Comment::render(hash,"m")
puts m