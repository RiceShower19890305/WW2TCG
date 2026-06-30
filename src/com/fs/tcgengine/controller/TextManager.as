package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.utils.Utils;
   
   public class TextManager
   {
      
      public static var smLang:String;
      
      private static const REPLACE_SEARCH_EXPRESSION:String = "%U";
      
      public static const ARIAL_UNICODE_FONT:String = "Arial Unicode MS";
      
      public static const SPACE:String = " ";
      
      public static const BLANK:String = "";
      
      private static var smTexts:Object = new Object();
      
      private static var smTextsDefaultLang:Object = new Object();
      
      private static var smDefaultLang:String = "EN";
      
      public static var smMissingTexts:String = "";
      
      public static var smGlyphedTexts:String = "";
      
      public function TextManager()
      {
         super();
      }
      
      public static function loadLang(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(param1 != smLang)
         {
            smLang = param1;
            _loc2_ = Root.assets.getObject("texts");
            if(_loc2_)
            {
               for(_loc5_ in _loc2_)
               {
                  _loc4_ = _loc2_[_loc5_];
                  _loc3_ = _loc4_[smLang];
                  if(_loc3_ == "" || _loc3_ == null)
                  {
                     addText(_loc4_["TID"],_loc4_[smDefaultLang],_loc4_[smDefaultLang]);
                     if(_loc4_["TID"] != null && _loc4_["TID"] != "" && _loc4_[smDefaultLang] != null && _loc4_[smDefaultLang] != "")
                     {
                        smMissingTexts += "\n[" + smDefaultLang + "] " + _loc4_["TID"];
                     }
                     if(smLang != "JA" && smLang != "ZH" && Utils.textHasGlyphs(_loc4_[smDefaultLang]))
                     {
                        smGlyphedTexts += "\n[" + smDefaultLang + "] " + _loc4_["TID"] + ":" + _loc4_[smDefaultLang];
                     }
                  }
                  else
                  {
                     if(smLang != "JA" && smLang != "ZH" && Utils.textHasGlyphs(_loc4_[smLang]))
                     {
                        smGlyphedTexts += "\n[" + smLang + "] " + _loc4_["TID"] + ":" + _loc4_[smLang];
                     }
                     addText(_loc4_["TID"],_loc4_[smLang],_loc4_[smDefaultLang]);
                  }
               }
            }
         }
      }
      
      protected static function addText(param1:String, param2:String, param3:String) : void
      {
         param2 = Utils.cleanMasterString(param2);
         smTexts[param1] = param2;
         smTextsDefaultLang[param1] = param3;
      }
      
      public static function getText(param1:String, param2:Boolean = false, param3:Boolean = false) : String
      {
         var _loc4_:String = param3 ? smTextsDefaultLang[param1] : smTexts[param1];
         if(!param2)
         {
            if(_loc4_ != null)
            {
               if(Config.getConfig().getDefaultTextsUpperCase())
               {
                  return _loc4_.indexOf("\\n") != -1 ? _loc4_.toUpperCase().replace(/\\n/g,"\n") : _loc4_.toUpperCase();
               }
               return _loc4_.indexOf("\\n") != -1 ? _loc4_.replace(/\\n/g,"\n") : _loc4_;
            }
            return null;
         }
         if(_loc4_)
         {
            return _loc4_.indexOf("\\n") != -1 ? _loc4_.replace(/\\n/g,"\n") : _loc4_;
         }
         return "";
      }
      
      public static function replaceParameters(param1:*, param2:Array) : String
      {
         var _loc5_:int = 0;
         var _loc3_:String = getText(param1);
         if(_loc3_ == null)
         {
            _loc3_ = param1 as String;
         }
         var _loc4_:int = -1;
         do
         {
            _loc4_ = _loc3_.indexOf(REPLACE_SEARCH_EXPRESSION);
            if(_loc4_ > -1)
            {
               _loc5_ = getParamIndex(_loc4_,_loc3_);
               if(_loc5_ == -1)
               {
                  _loc3_ = _loc3_.replace(REPLACE_SEARCH_EXPRESSION,param2[0]);
               }
               else
               {
                  _loc3_ = _loc3_.replace(REPLACE_SEARCH_EXPRESSION + _loc5_,param2[_loc5_]);
               }
            }
         }
         while(_loc4_ > -1);
         return _loc3_;
      }
      
      private static function getParamIndex(param1:int, param2:String) : int
      {
         var _loc6_:String = null;
         param1 += 2;
         var _loc3_:int = String("0").charCodeAt();
         var _loc4_:int = String("9").charCodeAt();
         var _loc5_:String = BLANK;
         while(true)
         {
            _loc6_ = param2.substr(param1,1);
            if(!(_loc6_ != BLANK && _loc6_ != null && _loc6_.charCodeAt() >= _loc3_ && _loc6_.charCodeAt() <= _loc4_))
            {
               break;
            }
            _loc5_ += _loc6_;
            param1++;
         }
         if(_loc5_ == "")
         {
            return -1;
         }
         return int(_loc5_);
      }
   }
}

