require "./txqs_util.rb"

Dir.exist?("./out/controller") ? $g_src_ctrlr_path = "/out/controller" : ""
Dir.exist?("./out/delegate") ? $g_src_dl_path = "/out/delegate" : ""
Dir.exist?("./out/datasource") ? $g_src_ds_path = "/out/datasource" : ""
Dir.exist?("./out/logic") ? $g_src_logic_path = "/out/logic" : ""

def createControllers(name,clz,pros,models,datasource,delegate,logic,author)

  #header
  if File.exist?(".#{$g_src_ctrlr_path}/#{name}.h")
    File.delete(".#{$g_src_ctrlr_path}/#{name}.h")
  end

  File.open(".#{$g_src_ctrlr_path}/#{name}.h","w"){ |h|

    str = commentsOfFile("h","#{name}","#{author}")
    h.puts(str)

    str = headerFileContent(["#{clz}"],name,clz,[],[],[])
    h.puts(str)
  }
  
  #body
  if File.exist?(".#{$g_src_ctrlr_path}/#{name}.m")
    File.delete(".#{$g_src_ctrlr_path}/#{name}.m")
  end
  
  File.open(".#{$g_src_ctrlr_path}/#{name}.m","w"){ |h|
    
    str = commentsOfFile("m","#{name}","#{author}")
    h.puts(str)
    
    str = "#import \"#{name}.h\" \n"
    models.each{|model|
      
      _clz = model["class"]
      str += "#import \"#{_clz}.h\" \n"
    }
  
    str += "#import \"#{datasource["class"]}.h\" \n" if(datasource)
    str += "#import \"#{delegate["class"]}.h\" \n" if(delegate)
    str += "#import \"#{logic["class"]}.h\"  \n" if(logic)
    h.puts str+"\n"
    
    
    str = "@interface #{name} ()\n\n"
    h.puts str
    
    str = ""
    models.each{|model|
      str += "@property(nonatomic,strong)#{model["class"]} *#{model["name"]};\n"
    }
    
    if(datasource)
      str += "@property(nonatomic,strong)#{datasource["class"]} *#{datasource["name"]};\n"
    end
    
    if(delegate)
      str += "@property(nonatomic,strong)#{delegate["class"]} *#{delegate["name"]};\n"
    end
    
    h.puts str
    
    str = "@end\n\n"
    h.puts str
    
    str = "@implementation #{name} \n\n"
    h.puts str
    
    #setters
    str =  "//////////////////////////////////////////////////////////// \n#pragma mark - setters \n\n\n\n"
    h.puts str
    
    #getters
    str = "//////////////////////////////////////////////////////////// \n#pragma mark - getters \n\n\n\n" 
    h.puts str     
    
    str = ""
    models.each{|model|
      
      _clz = model["class"]
      _name = model["name"]
      str += "-(#{_clz}* )#{_name}{\n\n if(!_#{_name}) {\n      _#{_name} = [#{_clz} new];\n      _#{_name}.key = @\"__#{_clz}__\";\n   }\n   return _#{_name};\n}\n\n"  
    }
    h.puts str
    
    if(datasource)
      _name = datasource["name"]
      _clz  = datasource["class"]
      str = "- (#{_clz}* )#{_name}{\n\n  if (!_#{_name}) {\n      _ds = [#{_clz} new];\n   }\n   return _#{_name};\n}\n\n"
      h.puts str
    end
    
    if(delegate)
      _name = delegate["name"]
      _clz  = delegate["class"]
      str = "- (#{_clz}* )#{_name}{\n\n  if (!_#{_name}) {\n      _dl = [#{_clz} new];\n   }\n   return _#{_name};\n}\n\n"
      h.puts str
    end
    
    #life cycle
    str = "//////////////////////////////////////////////////////////// \n#pragma mark - life cycle \n\n"  
    h.puts str
    
    #init
    if(logic)
      _clz = logic["class"]
      str = "-(id)init{\n\n   self = [super init];\n\n    if (self) {\n\n     self.logic = [#{_clz} new];\n\n   }\n\n   return self;\n\n}\n\n"
      h.puts str
    end
    
    #loadview
    str = "- (void)loadView{ \n\n    [super loadView]; \n\n\n\n}\n\n"
    h.puts str
    
    #viewdidload
    str = "- (void)viewDidLoad{ \n\n    [super viewDidLoad]; \n\n"
    h.puts str
    
    #tableview
    if (clz == "TBCitySBTableViewController")
  		s = "    //1,config your tableview\n"
  		s += "    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);\n"
  		s += "    self.tableView.backgroundColor = [UIColor clearColor];\n"
  		s += "    self.tableView.showsVerticalScrollIndicator = YES;\n\n"
  		s += "    //2,set some properties:下拉刷新，自动翻页\n"
  		s += "    self.bNeedLoadMore = YES;\n    self.bNeedPullRefresh = YES;\n\n"
  		s += "    //3，bind your delegate and datasource to tableview\n"
  		s += "    self.dataSource = self.ds;\n    self.delegate = self.dl;\n\n"
  		s += "    //4,@REQUIRED:YOU MUST SET A KEY MODEL!\n    //self.keyModel = self.model;\n\n"
  		s += "    //5,REQUIRED:register model to parent view controller\n    //[self registerModel:self.model];\n\n"
  		s += "    //6,load model\n"
  		s += "    [self load];\n"
  		h.puts s 
    end
    s = "\n}\n\n" #end of viewdidload
    h.puts s
    
    #memory warning
  	s = "- (void)didReceiveMemoryWarning{ \n\n    [super didReceiveMemoryWarning]; \n\n\n\n}\n\n"
  	h.puts s
	
  	#dealloc
  	s = "- (void)dealloc{ \n\n}\n\n"
  	h.puts s
	
	
  	if (clz == "TBCitySBTableViewController") 
  	  s = "//////////////////////////////////////////////////////////// \n#pragma mark - TBCitySBViewController \n\n\n\n"
    	#did select row
    	s += "- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{\n\n  //todo:... \n\n}\n\n"
      #did select row 
    	s += "- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{\n\n  //todo:... \n\n}\n\n"
    	
      h.puts s 
		
  	else
    	s = "//////////////////////////////////////////////////////////// \n#pragma mark - TBCitySBViewController \n\n\n\n"
    	#show empty
    	s += "- (void)showEmpty:(TBCitySBModel *)model{ \n\n    [super showEmpty:model]; \n\n\n\n}\n\n"
      #showLoading
    	s += "- (void)showLoading:(TBCitySBModel *)model{ \n\n    [super showLoading:model]; \n\n\n\n}\n\n"
      #showModel
    	s += "- (void)showModel:(TBCitySBModel *)model{ \n\n    [super showModel:model]; \n\n\n\n}\n\n"
      #showError
    	s += "- (void)showError:(TBCitySBModel *)model{ \n\n    [super showError:model]; \n\n\n\n}\n\n"
    	
      h.puts s
	
  	end
	
  	#public method
  	s = "//////////////////////////////////////////////////////////// \n#pragma mark - public method \n\n\n\n"
    h.puts s
    
  	#private callback method
  	s = "//////////////////////////////////////////////////////////// \n#pragma mark - private callback method \n\n\n\n"
  	h.puts s
	
	
  	#private method
  	s = "//////////////////////////////////////////////////////////// \n#pragma mark - private method \n\n\n\n"
  	h.puts s

    #end
    str = "@end \n\n"
    h.puts str
    
  }
  
  #create ds
  if(datasource)
    createDataSource(datasource["name"],datasource["class"],datasource["cell"],author)
  end
  
  #create dl
  if(delegate)
    createDelegate(delegate["name"],delegate["class"],author)
  end
  
  #create logic
  if(logic)
    createLogic(logic["class"],author)
  end

end


def createDataSource(name,clz,cell,author)
  
  #header
  if File.exist?(".#{$g_src_ds_path}/#{clz}.h")
    File.delete(".#{$g_src_ds_path}/#{clz}.h")
  end

  File.open(".#{$g_src_ds_path}/#{clz}.h","w"){ |h|

    str = commentsOfFile("h","#{clz}","#{author}")
    h.puts(str)

    str = headerFileContent(["TBCitySBTableViewDataSource"],clz,"TBCitySBTableViewDataSource",[],[],[])
    h.puts(str)
  }
  
  #body
  if File.exist?(".#{$g_src_ds_path}/#{clz}.m")
    File.delete(".#{$g_src_ds_path}/#{clz}.m")
  end
  
  File.open(".#{$g_src_ds_path}/#{clz}.m","w"){ |h|
  
    itemlist = []
    celllist = []
    
    cell.each{|c|
      itemlist.push(c["itemclass"])
      celllist.push(c["class"])    
    }
    
    
    
    str = "#import \"#{clz}.h\"\n"
    celllist.each{|c|
      str += "#import \"#{c}.h\"\n"
    }
    itemlist.each{|i|
      str += "#import \"#{i}.h\"\n"
    }
    h.puts str
  
    str = "@implementation #{clz} \n\n"
    h.puts str
    
    str = "- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{\n\n    //default:\n    return 1; \n\n}\n\n"
    h.puts str
    
    str = "- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{\n\n    //@REQUIRED:\n"  
    h.puts str
    
    str = ""
    cell.each{ |c|
      str += "    if([item isKindOfClass:[#{c["itemclass"]} class]])\n      return [#{c["class"]} class];\n"
    }
    h.puts str
    
    str = "\n     return [TBCitySBTableViewErrorCell class]; \n\n}\n\n"
    h.puts str
    
    str = "//@optional:\n"
    h.puts str 
    
    str = "//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{\n\n    //default:\n    //return [super itemForCellAtIndexPath:indexPath]; \n\n//}\n\n"
    h.puts str
    
    str = "@end \n\n"
    h.puts str
  }
  
  
  
end


def createDelegate(name,clz,author)
  
  #header
  if File.exist?(".#{$g_src_dl_path}/#{clz}.h")
    File.delete(".#{$g_src_dl_path}/#{clz}.h")
  end

  File.open(".#{$g_src_dl_path}/#{clz}.h","w"){ |h|

    str = commentsOfFile("h","#{clz}","#{author}")
    h.puts(str)

    str = headerFileContent(["TBCitySBTableViewDelegate"],clz,"TBCitySBTableViewDelegate",[],[],[])
    h.puts(str)
  }
  
  #body
  if File.exist?(".#{$g_src_dl_path}/#{clz}.m")
    File.delete(".#{$g_src_dl_path}/#{clz}.m")
  end
  
  File.open(".#{$g_src_dl_path}/#{clz}.m","w"){ |h|
  
    str = "#import \"#{clz}.h\"\n\n"
    h.puts str
    
    str = "@implementation #{clz} \n\n"
    h.puts str
      
    str = "@end \n\n"
    h.puts str
  }
  
end

def createLogic(clz,author)
  
  #header
  if File.exist?(".#{$g_src_logic_path}/#{clz}.h")
    File.delete(".#{$g_src_logic_path}/#{clz}.h")
  end

  File.open(".#{$g_src_logic_path}/#{clz}.h","w"){ |h|

    str = commentsOfFile("h","#{clz}","#{author}")
    h.puts(str)

    str = headerFileContent(["TBCitySBBusinessLogic"],clz,"TBCitySBBusinessLogic",[],[],[])
    h.puts(str)
  }
  
  #body
  if File.exist?(".#{$g_src_logic_path}/#{clz}.m")
    File.delete(".#{$g_src_logic_path}/#{clz}.m")
  end
  
  File.open(".#{$g_src_logic_path}/#{clz}.m","w"){ |h|
  
    str = "#import \"#{clz}.h\"\n\n"
    h.puts str
    
    str = "@implementation #{clz} \n\n"
    h.puts str
    
    str = "-(void)logic_view_did_load{\n\n    //todo\n\n}\n\n"
    str += "-(void)logic_view_will_appear{\n\n    //todo\n\n}\n\n"
    str += "-(void)logic_view_did_appear{\n\n    //todo\n\n}\n\n"
    str += "-(void)logic_view_will_disappear{\n\n    //todo\n\n}\n\n"
    str += "-(void)logic_view_did_disappear{\n\n    //todo\n\n}\n\n"
    str += "-(void)dealloc{\n\n    //todo\n\n}\n\n"
    h.puts str
    
    str = "@end \n\n"
    h.puts str
  }
  
end

