module T_ListViewController

require 'erb'

hash = ARGV[0]

# {
#   class:xxx
#   superclass:xxx
#   model:[{name:xx,class:xx},....]
#   datasource:{name:xxx,class:xxx,superclass:xxx}
#   delegate:{name:xxx,class:xxx,superclass:xxx}
# }
def T_ListViewController::renderH(hash)
  
  template = <<-TEMPLATE
  
@class <%= hash["superclass"] %>;
@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


def T_ListViewController::renderM(hash)

  list = hash["model"];
  template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
#import "<%= hash["logic"]["class"] %>.h"
<% list.each{|obj| %><% name = obj["name"] %> <% clz  = obj["class"] %>
#import "<%= clz %>.h" <% } if list%>
#import "<%= hash["datasource"]["class"] %>.h"
#import "<%= hash["delegate"]["class"] %>.h"

@interface <%= hash["class"] %>()

<% list.each{|obj| %><% name = obj["name"] %> <% clz  = obj["class"] %>
@property(nonatomic,strong)<%= clz %> *<%= name %>; <% } if list %>
@property(nonatomic,strong)<%= hash["datasource"]["class"] %> *<%= hash["datasource"]["name"] %>;
@property(nonatomic,strong)<%= hash["delegate"]["class"] %> *<%= hash["delegate"]["name"] %>;
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

- (<%= hash["datasource"]["class"] %> *)<%= hash["datasource"]["name"] %>{

  if (!_<%= hash["datasource"]["name"] %>) {
      _<%= hash["datasource"]["name"] %> = [<%= hash["datasource"]["class"] %> new];
   }
   return _<%= hash["datasource"]["name"] %>;
}

- (<%= hash["delegate"]["class"] %> *)<%= hash["delegate"]["name"] %>{

  if (!_<%= hash["delegate"]["name"] %>) {
      _<%= hash["delegate"]["name"] %> = [<%= hash["delegate"]["class"] %> new];
   }
   return _<%= hash["delegate"]["name"] %>;
}

- (<%= hash["logic"]["class"] %> *)<%= hash["logic"]["name"] %>
{
    if(!_<%= hash["logic"]["name"] %>){
        _<%= hash["logic"]["name"] %> = [<%= hash["logic"]["class"] %> new];
    }

    return _<%= hash["logic"]["name"] %>;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = YES;
    
    //2,set some properties:下拉刷新，自动翻页
    self.bNeedLoadMore = NO;
    self.bNeedPullRefresh = NO;

    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    //self.keyModel = self.model;
    
    //5,REQUIRED:register model to parent view controller
    [self registerModel:self.keyModel];

    //6,Load Data
    [self load];
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
#pragma mark - @override methods - VZViewController


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZListViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //todo...
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{

  //todo:... 

}

//////////////////////////////////////////////////////////// 
#pragma mark - public method 



//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 



@end
 
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end

end
