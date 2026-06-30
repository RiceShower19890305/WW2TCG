package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import flash.utils.Dictionary;
   
   public class HeroCharacterDefMng extends DefMng
   {
      
      public static const UNLOCK_BY_NO_LOCK:int = 0;
      
      public static const UNLOCK_BY_RAID:int = 1;
      
      public static const UNLOCK_BY_QUEST:int = 2;
      
      public static const UNLOCK_BY_PVP:int = 3;
      
      public static const UNLOCK_BY_LEVEL:int = 4;
      
      public static const UNLOCK_BY_DUNGEON:int = 5;
      
      public static const UNLOCK_BY_SHOP:int = 6;
      
      public static const UNLOCK_BY_GUILD:int = 7;
      
      public function HeroCharacterDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new HeroCharacterDef();
      }
      
      public function getDefByIndex(param1:int) : HeroCharacterDef
      {
         var _loc2_:HeroCharacterDef = null;
         var _loc3_:HeroCharacterDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function getAllSkins(param1:int = 0) : Dictionary
      {
         var _loc3_:HeroCharacterDef = null;
         var _loc2_:Dictionary = new Dictionary(true);
         for each(_loc3_ in mDefsBySku)
         {
            if(param1 == 0)
            {
               if(_loc3_.isSkin())
               {
                  _loc2_[_loc3_.getSku()] = _loc3_;
               }
            }
            else if(_loc3_.isSkin() && _loc3_.getUnlockType() == param1)
            {
               _loc2_[_loc3_.getSku()] = _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function getAllSkinsArr(param1:int = 0) : Array
      {
         var _loc3_:HeroCharacterDef = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in mDefsBySku)
         {
            if(param1 <= 0)
            {
               if(_loc3_.isSkin())
               {
                  _loc2_.push(_loc3_);
               }
            }
            else if(_loc3_.isSkin() && _loc3_.getUnlockType() == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc2_.sort(DictionaryUtils.sortSkinsByIsAvailable);
         return _loc2_;
      }
      
      public function getDungeonExclusiveRewardBySeason(param1:int) : HeroCharacterDef
      {
         var _loc2_:HeroCharacterDef = null;
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
                  if(_loc5_[_loc3_] == param1 && HeroCharacterDef(_loc2_).isSkin())
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
            _loc2_ = mDefsBySku["hero_01"];
         }
         return _loc2_;
      }
      
      public function getPvPExclusiveRewardBySeason(param1:int) : HeroCharacterDef
      {
         var _loc2_:HeroCharacterDef = null;
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
                  if(_loc5_[_loc3_] == param1 && HeroCharacterDef(_loc2_).isSkin())
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
            _loc2_ = mDefsBySku["hero_01"];
         }
         return _loc2_;
      }
      
      public function getJobSkinsByJobSku(param1:String) : Array
      {
         var _loc2_:HeroCharacterDef = null;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         for each(_loc2_ in mDefsBySku)
         {
            if(_loc2_.isSkin() && _loc2_.getJobSku() == param1)
            {
               _loc4_.push(_loc2_.getSku());
            }
         }
         return _loc4_;
      }
   }
}

