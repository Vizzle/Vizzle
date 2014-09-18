module T_ViewControllerLogic

require 'erb'

# {
#   class:xxx
#   superclass:xxx
# }

def T_ViewControllerLogic::renderH(hash)
  
  template = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


def T_ViewControllerLogic::renderM(hash)

template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>

-(void)logic_view_did_load{

    //todo

}

-(void)logic_view_will_appear{

    //todo

}

-(void)logic_view_did_appear{

    //todo

}

-(void)logic_view_will_disappear{

    //todo

}

-(void)logic_view_did_disappear{

    //todo

}

-(void)logic_dealloc{

    //todo

}

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


end