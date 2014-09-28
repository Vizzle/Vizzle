module T_ListViewDataSource

require 'erb'

# {
#   class:xxx
#   superclass:xxx
#   cellclass:xxx
# }

def T_ListViewDataSource::renderH(hash)
  
  template = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


def T_ListViewDataSource::renderM(hash)

template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
#import "<%= hash["cellclass"] %>.h"

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //default:
    return 1; 

}

- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{

    //@REQUIRED:
    return [<%= hash["cellclass"] %> class];

}

//@optional:
//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{

    //default:
    //return [super itemForCellAtIndexPath:indexPath]; 

//}


@end  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


end