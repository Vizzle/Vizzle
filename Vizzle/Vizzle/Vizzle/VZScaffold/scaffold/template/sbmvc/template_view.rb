module T_View

require 'erb'

#{
# class:xxx
# superclass:xxx 
# itemclass:xxx
#}

def T_View::renderH(hash)

  template = <<-TEMPLATE
  
@class <%= hash["itemclass"] %>;
@class <%= hash["superclass"] %>;

@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@property(nonatomic,strong) <%= hash["itemclass"] %> *item;

@end

  TEMPLATE

  erb = ERB.new(template)
  erb.result(binding)
  
end

def T_View::renderM(hash)
  
  template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
#import "<%= hash["itemclass"] %>.h"

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>

- (id)initWithFrame:(CGRect)frame 
{

  self = [super initWithFrame:frame]; 

  if (self) { 

    //todo...

  }

  return self;
}

- (void)setItem:(<%= hash["itemclass"] %> *)item
{
  
}

- (void)layoutSubviews
{
    [super layoutSubviews];
  
  
}

@end

  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end

end
