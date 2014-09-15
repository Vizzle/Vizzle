##author : jayson.xu @taobao inc

require 'nokogiri'
require './txqs_uikit.rb'
require './txqs_mappings.rb'


class XibParser
  
  attr_accessor :path, :f, :doc #Nokogiri::XML::Document
  attr_accessor :view_hash 
  
  def initialize(path)
    @path = path
    @view_hash = Hash.new
    open()
    
  end
  
  def open
    @f = File.open(@path)
    @doc = Nokogiri::XML(f)
    @f.close    
  end
  
  def parse

    ##1,find objects
    root_objs = @doc.xpath('//objects/*')
    root_objs.each do |o|

      if( o.name == 'view' || o.name == 'tableViewCell' )

        tmp = []
        subviews = nil
        
        if o.name == 'view'
          subviews = o.xpath("subviews/*") ## subviews => Nokogiri::XML::NodeSet
        end
        
        if o.name == 'tableViewCell'
          subviews = o.xpath("tableViewCellContentView/subviews/*")
        end
        
        pp "clz:#{o.name}"
        pp "name:#{o["customClass"]}"

        #get subviews class
        if (subviews)
          
            subviews.each{|v| ## v => Nokogiri::XML::Element
              
              objc_clz  = v["customClass"] ? v["customClass"] : MAPPINGS::OBJC_CLASS[v.name]
              objc_name = v.at_xpath('accessibility')["label"] 
              
              pp "{#{objc_clz}=>#{objc_name}}"
              obj = UIKitFactory.UIKitObj(v,objc_name,objc_clz)
          
              ##custom import list
              customClass = v["customClass"]
              obj.customClz = true if(customClass)
              tmp.push(obj)
          
            } ##end of subviews.each
        end #end of if (subviews)
        
        #background color
        color = o.at_xpath("color")
        bkColor = MAPPINGS.colorWithObject(color) if(color && color["key"] == "backgroundColor")
          
        #binding data
        data = o.at_xpath("bind")
        data_clz = data["class"] if(data)
        data_name = data["name"] if(data)
        @view_hash[o["customClass"]] = {"clz"=>o.name,"bkcolor"=> bkColor , "subviews" => tmp, "data" => {data_clz => data_name}}
        
      end ##end of if      
    
    end #end of root_objs.each
    
   return @view_hash
        
  end#end of parse


end#end of class