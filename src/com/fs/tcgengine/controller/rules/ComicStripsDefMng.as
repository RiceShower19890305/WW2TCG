package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.ComicStripDef;
   import com.fs.tcgengine.model.rules.Def;
   import flash.utils.Dictionary;
   
   public class ComicStripsDefMng extends DefMng
   {
      
      public function ComicStripsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new ComicStripDef();
      }
      
      public function getComicStripsDefsByMapSku(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc4_:ComicStripDef = null;
         var _loc3_:Dictionary = getAllDefs();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getTriggeredOnMapSku() == param1)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Array();
               }
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
   }
}

