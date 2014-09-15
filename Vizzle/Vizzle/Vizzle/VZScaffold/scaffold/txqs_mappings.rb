#created by jayson.xu

module MAPPINGS

  #xib's class type <=> objc
  OBJC_CLASS = {"view" => "UIView", 
               "label" => "UILabel",
               "button" => "UIButton", 
               "imageView" => "UIImageView",
               "tableViewCell" => "TBCitySBTableViewCell"} 
               

  
  #xib's button type <=> objc
  OBJC_BTN_TYPE = {"contactAdd" => "UIButtonTypeContactAdd",
                      "roundedRect" => "UIButtonTypeRoundedRect"}
  
  #xib's lable's linebreakmode <=> objc
  OBJC_LINEBREAK_MODE = {"tailTruncation" => "NSLineBreakByTruncatingTail"}
  
  #xib's lable's textalignment <=>
  OBJC_TEXT_ALIGNMENT = {"center" => "NSTextAlignmentCenter",
                         "left" => "NSTextAlignmentLeft", 
                         "right" => "NSTextAlignmentRight"}
    
                         
  

  #COLOR
  def MAPPINGS.colorWithRGBA(r,g,b,a)
    return "[UIColor colorWithRed:#{r} green:#{g} blue:#{b} alpha:#{a}]"
  end
  
  def MAPPINGS.colorWithWhiteAndAlpha(w,a)
    return "[UIColor colorWithWhite:#{w} alpha:#{a}]"
  end
  
  def MAPPINGS.colorWithCocoaColor(c)
    return "[UIColor #{c}]"
  end
  
  def MAPPINGS.colorWithObject(c)
    
    if(c["white"])
      return MAPPINGS.colorWithWhiteAndAlpha(c["white"],c["alpha"])
    elsif(c["cocoaTouchSystemColor"])
      return MAPPINGS.colorWithCocoaColor(c["cocoaTouchSystemColor"])
    elsif(c["red"] && c["green"] && c["blue"] && c["alpha"])
      return MAPPINGS.colorWithRGBA(c["red"],c["green"],c["blue"],c["alpha"])
    else
      return MAPPINGS.colorWithRGBA("#{1.0}","#{1.0}","#{1.0}","#{1.0}")
    end

  end
    
  
end