module T_Model

require 'erb'

#{
# class:xxx
# superclass:xxx 
#}

def T_Model::renderH(hash)

  template = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end

  TEMPLATE

  erb = ERB.new(template)
  erb.result(binding)
  
end

def T_Model::renderM(hash)
  
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

- (NSDictionary* )mtopParams
{
    return nil;
}

- (NSString *)methodName {
   
    //todo:
   
    return nil;
}


- (NSArray* )parseResponse:(id)JSON error:(NSError *__autoreleasing *)error
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
