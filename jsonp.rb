#encoding:utf-8
require 'aws/dynamo_db'

module Jsonp

  def self.jsonp_from_dynamo_item(dynamo_item)
    pad(json(dynamo_item))
  end

  def self.jsonp_from_dynamo_items(dynamo_items)
    s="";
    first=true;
    dynamo_items.each{ |dynamo_item|
      if(first) then first=false else s+="," end
      s += json(dynamo_item)
    }
    pad(s)
  end

  private
  def self.pad(s) #for JSON with Padding
    "pad([" + s + "])"
  end

  def self.json(dynamo_item)
    json_version2(dynamo_item)
  end

  def self.json_version1(dynamo_item)
    JSON.generate dynamo_item.attributes.to_h
  end
  
  def self.json_version2(dynamo_item)
    if(dynamo_item.attributes.count==0) then return '' end
    s = '{';
    first=true;
    dynamo_item.attributes.each{ |attr|
      if(first) then first=false else s+=',' end
      key=attr[0]
      value=attr[1]
      s += '"' + key + '":"'
      # http://stackoverflow.com/questions/6458990/how-to-format-a-number-1000-as-1-000
      s += (value.class==BigDecimal) ? value.to_i.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse : value
      s += '"'
    }
    s += '}'
    s
  end
  
end