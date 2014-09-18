module T_HTTPListModel

require 'erb'

#{
# class:xxx
# superclass:xxx 
#}
def T_HTTPListModel::renderH(hash)
  
  template = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end

  TEMPLATE

  erb = ERB.new(template)
  erb.result(binding)
  
end

def T_HTTPListModel::renderM(hash)
  
  template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods

- (NSDictionary *)dataParams {
    
    //todo:
    
    return nil;
}

- (NSString *)methodName {
    
    //todo:
    
    
    return nil;
}

- (NSMutableArray* )responseObjects:(id)JSON
{
  
    //todo:
  
    
    return nil;
}

@end

  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end

end