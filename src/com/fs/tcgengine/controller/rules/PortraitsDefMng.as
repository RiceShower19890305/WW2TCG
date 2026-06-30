package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.PortraitDef;
   
   public class PortraitsDefMng extends DefMng
   {
      
      public function PortraitsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new PortraitDef();
      }
      
      public function getDefByIndex(param1:int) : PortraitDef
      {
         var _loc2_:PortraitDef = null;
         var _loc3_:PortraitDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function getPvPExclusiveRewardBySeason(param1:int) : PortraitDef
      {
         var _loc2_:PortraitDef = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         for each(_loc2_ in mDefsBySku)
         {
            _loc5_ = _loc2_.getPvPSeasonRewards();
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc5_.length)
               {
                  if(_loc5_[_loc3_] == param1)
                  {
                     _loc4_ = true;
                     break;
                  }
                  _loc3_++;
               }
            }
            if(_loc4_)
            {
               break;
            }
         }
         if(!_loc4_)
         {
            _loc2_ = mDefsBySku["portrait_01"];
         }
         return _loc2_;
      }
      
      public function getDungeonExclusiveRewardBySeason(param1:int) : PortraitDef
      {
         var _loc2_:PortraitDef = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         for each(_loc2_ in mDefsBySku)
         {
            _loc5_ = _loc2_.getDungeonSeasonRewards();
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc5_.length)
               {
                  if(_loc5_[_loc3_] == param1)
                  {
                     _loc4_ = true;
                     break;
                  }
                  _loc3_++;
               }
            }
            if(_loc4_)
            {
               break;
            }
         }
         if(!_loc4_)
         {
            _loc2_ = mDefsBySku["portrait_01"];
         }
         return _loc2_;
      }
   }
}

