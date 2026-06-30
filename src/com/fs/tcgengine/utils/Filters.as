package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import starling.filters.BlurFilter;
   import starling.filters.DropShadowFilter;
   import starling.filters.FragmentFilter;
   import starling.filters.GlowFilter;
   
   public class Filters
   {
      
      public function Filters()
      {
         super();
      }
      
      public static function requestFilter(param1:String) : FragmentFilter
      {
         var _loc2_:FragmentFilter = null;
         if(Config.getConfig().getAllowFilters())
         {
            FSDebug.debugTrace("Requesting Filter: " + param1);
            _loc2_ = createFilter(param1);
         }
         return _loc2_;
      }
      
      private static function createFilter(param1:String) : FragmentFilter
      {
         var _loc2_:FragmentFilter = null;
         switch(param1)
         {
            case Constants.FILTER_DROPSHADOW:
               _loc2_ = new DropShadowFilter(8,0.85,0,0.75);
               break;
            case Constants.FILTER_DROPSHADOW_CARD_BACK:
               _loc2_ = new DropShadowFilter(8,-3.75,0,0.8);
               break;
            case Constants.FILTER_DROPSHADOW_CARD_DESC:
               _loc2_ = new DropShadowFilter(2,0.5,0,1,0.15,10);
               break;
            case Constants.FILTER_GLOW_GREEN:
               _loc2_ = new GlowFilter(65280,1,0.5,0.5);
               break;
            case Constants.FILTER_BLUR:
               _loc2_ = new BlurFilter();
               break;
            case Constants.FILTER_GLOW_RED:
               _loc2_ = new GlowFilter(16711680);
               break;
            case Constants.FILTER_GLOW_BLUE:
               _loc2_ = new GlowFilter(4427262,1,15,0.5);
               break;
            case Constants.FILTER_GLOW_ORANGE:
               _loc2_ = new GlowFilter(16744448,1,15,0.5);
               break;
            case Constants.FILTER_GLOW_YELLOW:
               _loc2_ = new GlowFilter(16777184,1,20,0.5);
               break;
            case Constants.FILTER_GLOW_PURPLE:
               _loc2_ = new GlowFilter(10040012,1,15,0.5);
         }
         return _loc2_;
      }
   }
}

