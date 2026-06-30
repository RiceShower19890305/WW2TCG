package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import flash.utils.Dictionary;
   
   public class RaritiesDefMng extends DefMng
   {
      
      public function RaritiesDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new RarityDef();
      }
      
      public function getFontNameByIndex(param1:int) : String
      {
         var _loc2_:String = FSResourceMng.getFontByType();
         if(InstanceMng.getApplication().showCustomFontsForPacks())
         {
            switch(param1)
            {
               case 0:
               case 1:
                  _loc2_ = FSResourceMng.getFontByType();
                  break;
               case 2:
                  _loc2_ = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
                  break;
               case 3:
                  _loc2_ = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE);
            }
         }
         return _loc2_;
      }
      
      public function getRarityDefByIndex(param1:int) : RarityDef
      {
         var _loc4_:Def = null;
         var _loc2_:RarityDef = null;
         var _loc3_:Dictionary = getAllDefs();
         for each(_loc4_ in _loc3_)
         {
            if(RarityDef(_loc4_).getIndex() == param1)
            {
               return RarityDef(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function getRarityColor(param1:int) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = Config.getConfig().gameGetCommonColor();
               break;
            case 1:
               _loc2_ = Config.getConfig().gameGetUnCommonColor();
               break;
            case 2:
               _loc2_ = Config.getConfig().gameGetRareColor();
               break;
            case 3:
               _loc2_ = Config.getConfig().gameGetEpicColor();
               break;
            case 4:
               _loc2_ = Config.getConfig().gameGetLegendaryColor();
               break;
            case 5:
               _loc2_ = Config.getConfig().gameGetMegaLegendaryColor();
               break;
            case 6:
               _loc2_ = Config.getConfig().gameGetUltraLegendaryColor();
               break;
            case 7:
               _loc2_ = Config.getConfig().gameGetUberLegendaryColor();
         }
         return _loc2_;
      }
   }
}

