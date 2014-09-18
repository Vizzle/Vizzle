require "./template_comment.rb"

puts "==========================================="
puts "Test Comment"
puts "==========================================="


#{
# class:xxx
# author:xxx
# comp:xxx
# proj:xxx
#}

hash = {"class" => "TestListCell",
        "superclass" => "TBCitySBTableViewCell",
        "comp" => "taobao",
        "proj" => "iCoupon"}
            
h = T_Comment::render(hash,"h")
puts h
puts "-------------------------------------------"
m = T_Comment::render(hash,"m")
puts m