module T_Comment

require 'erb'


#{
# class:xxx
# author:xxx
# comp:xxx
# proj:xxx
#}
def T_Comment::render(hash,type)
  
  time = Time.new
  tmplate = <<-TEMPLATE
  
//
//  <%= hash["class"] %>.<%= type %>
//  <%= hash["proj"] %>
//
//  Created by <%= hash["author"] %> on <%= time %>.
//  Copyright (c) <%= time.year %>年 <%= hash["comp"] %>. All rights reserved.
//


  TEMPLATE
  
  erb = ERB.new(tmplate)
  erb.result(binding)
  
end
end