#
#created by jayson.xu
#


require 'nokogiri'
require './txqs_mappings.rb'

class UIKitFactory
  
  def self.UIKitObj(xml_obj,name,clz)
    
      if xml_obj.name == 'label'
        return UILabel.new(xml_obj,name,clz)
      elsif xml_obj.name == 'button'
        return UIButton.new(xml_obj,name,clz)
      elsif xml_obj.name == 'imageView'
        return UIImageView.new(xml_obj,name,clz)
      elsif xml_obj.name == 'tableViewCell'
        return UITableViewCell.new(xml_obj,name,clz)
      else
        return UIView.new(xml_obj,name,clz)
      end
  end
  
end
  
class UIView
    
  protected
    attr_accessor :xml_obj
    
  public
    attr_accessor :customClz
    attr_accessor :name, :clz
    attr_accessor :x, :y, :w, :h
    attr_accessor :background_color
    attr_accessor :alpha
    attr_accessor :hidden
    attr_accessor :tag
    
    def initialize(xml_obj,name,clz)
    
       @clz = clz
       @name = name
       @xml_obj = xml_obj
       rect = xml_obj.at_xpath("rect")
       @x = rect["x"].to_f
       @y = rect["y"].to_f
       @w = rect["width"].to_f
       @h = rect["height"].to_f
       @tag = xml_obj["tag"]
       
       #bkcolor:
       color = xml_obj.at_xpath("color")
       if(color && color["key"] == "backgroundColor")
         @background_color = MAPPINGS.colorWithObject(color)
       end
    end

    def objc_code()
      
      str = "\n   //#{self.name}"
      str = str+ "\n   self.#{self.name} =[[#{self.clz} alloc]initWithFrame:CGRectMake(#{self.x},#{self.y},#{self.w},#{self.h})];"
      
      #tag
      if self.tag 
        str = str+ "\n   self.#{self.name}.tag = #{self.tag};" 
      end
      
      #background color
      if self.background_color
        str = str + "\n   self.#{self.name}.backgroundColor = #{self.background_color};"
      end
      
      #返回字符串和sel数组
      code,sels = self.objc_code_subclass()
      
      str = str + code + "\n   [self addSubview:self.#{self.name}];"
        
      return str,sels
          
    end
    
    def objc_code_subclass()
      return "",[]
    end
  
  end
  
  class UIButton < UIView
    
    attr_accessor :button_type, :title_font, :title_color_normal, :title_color_highlight, :title_normal, :title_highlight
    attr_accessor :btn_type_4_UIKit
    
    def initialize(xml_obj,name,clz)
      
        super(xml_obj,name,clz)
        
        @normal_state_dict = Hash.new
        @highlight_state_dict = Hash.new
        @btn_type_4_UIKit = {"contactAdd" => "UIButtonTypeContactAdd", 
                          "roundedRect" => "UIButtonTypeRoundedRect"}
        
        @button_type = @btn_type_4_UIKit[xml_obj["buttonType"]];
        #font:
        font = xml_obj.at_xpath("fontDescription")
        
        if font != nil
          font_size = font["pointSize"]
        
          if font["type"] == "boldSystem"
            @title_font = "[UIFont boldSystemFontOfSize:#{font_size}]"
          else
            @title_font = "[UIFont systemFontOfSize:#{font_size}]"
          end
        end
    
        #state:
        state = xml_obj.at_xpath("state")
        if state["key"] == "normal"
          @title_normal = state["title"]
          color = state.at_xpath("color")
          
          if color["red"] != nil && color["green"] != nil && color["blue"] != nil
            @title_color_normal = "[UIColor colorWithRed:#{color["red"]} green:#{color["green"]} blue:#{color["blue"]} alpha:#{color["alpha"]}]"
          end
          
        elsif state["key"] == "highlight"
          
          @title_highlight = state["title"]
          color = state.at_xpath("color")
          
          if color["red"] != nil && color["green"] != nil && color["blue"] != nil
            @title_color_highlight = "[UIColor colorWithRed:#{color["red"]} green:#{color["green"]} blue:#{color["blue"]} alpha:#{color["alpha"]}]"
          end
          
        else
          ##todo
        end     
        

    end
    
    def objc_code()

      str = "\n   //#{self.name}"
      str = str + "\n   self.#{self.name} = [UIButton buttonWithType:#{self.button_type}];"
      str = str + "\n   self.#{self.name}.frame = CGRectMake(#{self.x},#{self.y},#{self.w},#{self.h});"
      
      #tag
      if self.tag 
        str = str+ "\n   self.#{self.name}.tag = #{self.tag};" 
      end
      
      #background color
      if self.background_color
        str = str + "\n   self.#{self.name}.backgroundColor = #{self.background_color};"
      end
      
      str = str + "\n   [self addSubview:self.#{self.name}];"
      
      ##normal state
      if @title_normal != nil
        str = str + "\n   [self.#{self.name} setTitle:@\"#{self.title_normal}\" forState:UIControlStateNormal];"
      end
      
      if @title_color_normal != nil
        str = str + "\n   [self.#{self.name} setTitleColor:#{self.title_color_normal} forState:UIControlStateNormal];"
      end
      
      ##highlight state
      if @title_highlight != nil
      str = str + "\n   [self.#{self.name} setTitle:@\"#{self.title_highlight}\" forState:UIControlStateHighlighted];"
      end
      
      if @title_color_highlight != nil
      str = str + "\n   [self.#{self.name} setTitleColor:#{self.title_color_highlight} forState:UIControlStateHighlighted];"
      end
      
      ##font
      if self.title_font != nil
        str = str + "\n   self.#{self.name}.titleLabel.font = #{self.title_font};"
      end
      
      ##target-action
      str = str + "\n   [self.#{self.name} addTarget:self action:@selector(on#{self.name.capitalize}Clicked:) forControlEvents:UIControlEventTouchUpInside];"
      
      return str,["- (void)on#{self.name.capitalize}Clicked:(UIButton*)btn{ \n\n    //todo... \n }\n"]    
    end
  
  end
  

  
  class UILabel < UIView
    attr_accessor :font, :text, :text_color, :text_alignment, :text_linebreak_mode
    
    def initialize(xml_obj,name,clz)
      
      super(xml_obj,name,clz)
      
      #font:
      font = xml_obj.at_xpath("fontDescription")
        font_size = font["pointSize"]
        
        if font["type"] == "boldSystem"
          @font = "[UIFont boldSystemFontOfSize:#{font_size}]"
        else
          @font = "[UIFont systemFontOfSize:#{font_size}]"
        
        end
        
      #text color:
      color = xml_obj.at_xpath("color")
      @text_color = color ?  MAPPINGS.colorWithObject(color) : "[UIColor blackColor]"

      #breakmode:
      breakmode = xml_obj["lineBreakMode"]
      @text_linebreak_mode = breakmode ? MAPPINGS::OBJC_LINEBREAK_MODE[breakmode] : "NSLineBreakByTruncatingTail"
      
      #text:
      text = xml_obj["text"] 
      @text = text ? text : "@"";"
    
      #alignment
      alignment = xml_obj["textAlignment"]
      @text_alignment = alignment ? MAPPINGS::OBJC_TEXT_ALIGNMENT[alignment] : "NSTextAlignmentLeft"
            
    end
    
    def objc_code_subclass()
      
      str = ""
      str = str + "\n   self.#{self.name}.font = #{self.font};"
      str = str + "\n   self.#{self.name}.textColor = #{self.text_color};"
      str = str + "\n   self.#{self.name}.text = @\"#{self.text}\";"
      str = str + "\n   self.#{self.name}.textAlignment = #{self.text_alignment};"
      str = str + "\n   self.#{self.name}.lineBreakMode = #{self.text_linebreak_mode};"
      
      return str,[]
          
    end

end
  
  class UIImageView < UIView
  
   def objc_code_subclass()
     return "",[]
   end
  
  end

class UITableViewCell < UIView
  
  def initialize(xml_obj,name,clz)
    super(xml_obj,name,clz)
    
  end
  
  def objc_code_subclass()
    return "",[]
  end
end
  