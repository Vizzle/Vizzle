module T_HTTPModel

require 'erb'

#{
# class:xxx
# superclass:xxx 
#}

def T_HTTPModel::renderH(hash)

  template = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end

  TEMPLATE

  erb = ERB.new(template)
  erb.result(binding)
  
end

def T_HTTPModel::renderM(hash)
  
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

- (BOOL)parseResponse:(id)JSON
{
    //todo:
  


    return NO;
}

@end

  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end

end
