module T_ListCell

require 'erb'

# {
#   class:xxx
#   superclass:xxx
#   itemclass : xxx
#   height : xxx
# }

def T_ListCell::renderH(hash)
  
  template = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


def T_ListCell::renderM(hash)

template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
#import "<%= hash["itemclass"] %>.h"

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //todo: add some UI code
    
        
    }
    return self;
}

+ (CGFloat) tableView:(UITableView *)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath *)indexPath
{
    return <%= hash["height"] %>;
}

- (void)setItem:(<%= hash["itemclass"] %> *)item
{
    [super setItem:item];
  
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