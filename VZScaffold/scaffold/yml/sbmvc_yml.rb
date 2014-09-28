require 'yaml'

hash = {:template => "SBMVC",
  :comment => {:template => "comment",:namespace => "T_Comment"},
  :cell => {:class => "TBCitySBTableViewCell" ,:template => "listcell", :namespace => "T_ListCell"},
  :listitem => {:class => "TBCitySBTableViewItem" ,:template => "listItem", :namespace => "T_ListItem"},
  :item => {:class => "TBCitySBItem" ,:template => "item", :namespace => "T_Item"},
  :listviewcontroller => {:class => "TBCitySBTableViewController" ,:template => "listviewcontroller",:namespace => "T_ListViewController"},
  :listviewdatasource => {:class => "TBCitySBTableViewDataSource" ,:template => "listviewdatasource",:namespace => "T_ListViewDataSource"},
  :listviewdelegate => {:class => "TBCitySBTableViewDelegate" ,:template => "listviewdelegate",:namespace => "T_ListViewDelegate"},
  :model => {:class => "TBCitySBModel",:template => "model",:namespace => "T_Model"},
  :listmodel => {:class => "TBCitySBListModel",:template => "model",:namespace => "T_Model"},
  :viewcontroller => {:class => "TBCitySBViewController",:template => "viewcontroller",:namespace => "T_ViewController"},
  :logic => {:class => "TBCitySBBusinessLogic",:template => "viewcontrollerlogic",:namespace => "T_ViewControllerLogic"},
  :view => {:class => "UIView", :template => "view", :namespace => "T_View"}
}


puts hash.to_yaml

File.open("sbmvc.yml","w+"){|f| f.puts hash.to_yaml}