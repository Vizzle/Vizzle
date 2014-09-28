module T_ListViewDelegate

require 'erb'

# {
#   class:xxx
#   superclass:xxx
# }

def T_ListViewDelegate::renderH(hash)
  
  template = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


def T_ListViewDelegate::renderM(hash)

template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>


@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


end