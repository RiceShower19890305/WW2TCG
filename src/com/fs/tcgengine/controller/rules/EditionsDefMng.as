package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.EditionDef;
   import flash.utils.Dictionary;
   
   public class EditionsDefMng extends DefMng
   {
      
      public function EditionsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new EditionDef();
      }
      
      public function getGameEditionsInfo() : Dictionary
      {
         var _loc2_:EditionDef = null;
         var _loc1_:Dictionary = null;
         if(mDefsBySku)
         {
            for each(_loc2_ in mDefsBySku)
            {
               if(_loc1_ == null)
               {
                  _loc1_ = new Dictionary(true);
               }
               if(_loc1_[_loc2_.getGameIndex()] == null)
               {
                  _loc1_[_loc2_.getGameIndex()] = _loc2_;
               }
            }
         }
         return _loc1_;
      }
      
      public function getDefsByGameIndex(param1:int) : Vector.<EditionDef>
      {
         var _loc3_:EditionDef = null;
         var _loc2_:Vector.<EditionDef> = null;
         if(mDefsBySku)
         {
            for each(_loc3_ in mDefsBySku)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Vector.<EditionDef>();
               }
               if(_loc3_.getGameIndex() == param1)
               {
                  _loc2_.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
      
      public function getGameEditionsAmount() : int
      {
         var _loc2_:EditionDef = null;
         var _loc1_:int = 0;
         if(mDefsBySku)
         {
            for each(_loc2_ in mDefsBySku)
            {
               _loc1_ = _loc2_.getGameIndex() > _loc1_ ? _loc2_.getGameIndex() : _loc1_;
            }
         }
         return _loc1_;
      }
   }
}

