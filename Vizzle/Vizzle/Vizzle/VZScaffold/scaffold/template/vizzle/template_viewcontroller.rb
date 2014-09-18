module T_ViewController

require 'erb'

# {
#   class:xxx
#   superclass:xxx
#   model:[{name:xx,class:xx},....]
#   logic:{name:xx,class:xx}
# }
def T_ViewController::renderH(hash)
  
  tmplate = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(tmplate)
  erb.result(binding)
  
end


def T_ViewController::renderM(hash)

  list = hash["model"];
  tmplate = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
#import "<%= hash["logic"]["class"] %>.h"
<% list.each{|obj| %><% name = obj["name"] %> <% clz  = obj["class"] %>
#import "<%= clz %>.h" <% } if list %>

@interface <%= hash["class"] %>()

<% list.each{|obj| %><% name = obj["name"] %> <% clz  = obj["class"] %>
@property(nonatomic,strong)<%= clz %> *<%= name %>; <% } if list %>
@property(nonatomic,strong)<%= hash["logic"]["class"] %> *<%= hash["logic"]["name"] %>;

@end

@implementation <%= hash["class"] %>


//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

<% list.each{|obj| %>  <% name = obj["name"] %> <% clz  = obj["class"] %>
- (<%= clz %> *)<%= name %>
{
    if (!_<%= name %>) {
        _<%= name %> = [<%= clz %> new];
        _<%= name %>.key = @"__<%= clz %>__";
    }
    return _<%= name %>;
}
<%} %>

- (<%= hash["logic"]["class"] %> *)<%= hash["logic"]["name"] %>
{
    if(!_<%= hash["logic"]["name"] %>){
        _<%= hash["logic"]["name"] %> = [<%= hash["logic"]["class"] %> new];
    }

    return _<%= hash["logic"]["name"] %>
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle methods

- (id)init
{
    self = [super init];
    
    if (self) {
        self.logic = self.<%= hash["logic"]["name"] %>;
        
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    //todo..
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //todo..
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //todo..
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //todo..
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //todo..
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //todo..
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc {
    
    //todo..
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods

- (void)showModel:(VZModel *)model
{
    //todo:
}

- (void)showEmpty:(VZModel *)model
{
    //todo:
}


- (void)showLoading:(VZModel*)model
{
    //todo:
}

- (void)showError:(NSError *)error withModel:(VZModel*)model
{
    //todo:
}

@end
 
  TEMPLATE
  
  erb = ERB.new(tmplate)
  erb.result(binding)
  
end

end