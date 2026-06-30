package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import flash.utils.Dictionary;
   
   public class RewardsDefMng extends DefMng
   {
      
      public function RewardsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new RewardDef();
      }
      
      private function getRewardDefByLevel(param1:String, param2:int = -1) : RewardDef
      {
         var _loc3_:RewardDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:RewardDef = null;
         var _loc4_:LevelDef = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param1));
         if(_loc4_ != null)
         {
            _loc5_ = param2 != -1 ? param2 : InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc6_ = _loc4_.getMapWorldParentIndex();
            _loc7_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc7_);
            _loc8_ = _loc4_.getRewardSkuByDifficulty(_loc5_,_loc7_);
            _loc9_ = RewardDef(getDefBySku(_loc8_));
            if(_loc9_ != null)
            {
               return _loc9_;
            }
         }
         return _loc3_;
      }
      
      public function getCardRewardsForLevel(param1:String) : Dictionary
      {
         var _loc2_:Dictionary = null;
         var _loc3_:RewardDef = this.getRewardDefByLevel(param1);
         if(_loc3_ != null)
         {
            return _loc3_.getCards();
         }
         return _loc2_;
      }
      
      public function getGoldRewardForLevel(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:RewardDef = this.getRewardDefByLevel(param1);
         if(_loc3_ != null)
         {
            return _loc3_.getGold();
         }
         return _loc2_;
      }
      
      public function getExpRewardForLevel(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:RewardDef = this.getRewardDefByLevel(param1);
         if(_loc3_ != null)
         {
            return _loc3_.getExp();
         }
         return _loc2_;
      }
      
      public function getPackRewardsForLevel(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:RewardDef = this.getRewardDefByLevel(param1);
         if(_loc3_ != null)
         {
            return _loc3_.getPackSku();
         }
         return _loc2_;
      }
      
      public function getRewardDefsForLevelRanks(param1:String, param2:String, param3:int) : Vector.<RewardDef>
      {
         var _loc4_:Vector.<RewardDef> = null;
         var _loc5_:RewardDef = null;
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:LevelDef = null;
         var _loc7_:LevelDef = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param1));
         var _loc8_:LevelDef = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param2));
         if(Boolean(_loc7_) && Boolean(_loc8_))
         {
            _loc9_ = _loc7_.getLevelIndex();
            _loc10_ = _loc8_.getLevelIndex();
            _loc6_ = _loc9_;
            while(_loc6_ <= _loc10_)
            {
               _loc11_ = LevelDef(InstanceMng.getLevelsDefMng().getLevelDefByLevelIndex(_loc6_));
               if(_loc11_)
               {
                  _loc5_ = this.getRewardDefByLevel(_loc11_.getSku(),param3);
                  if(_loc5_)
                  {
                     if(_loc4_ == null)
                     {
                        _loc4_ = new Vector.<RewardDef>();
                     }
                     _loc4_.push(_loc5_);
                  }
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      public function getRewardedCardsForLevelRanks(param1:String, param2:String, param3:int) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:RewardDef = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:PackDef = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Vector.<RewardDef> = this.getRewardDefsForLevelRanks(param1,param2,param3);
         if(_loc5_ != null)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               _loc8_ = _loc5_[_loc7_];
               if(_loc8_)
               {
                  _loc9_ = _loc8_.getCardsArr();
                  if(_loc4_ == null)
                  {
                     _loc4_ = new Array();
                  }
                  if(_loc9_)
                  {
                     _loc6_ = 0;
                     while(_loc6_ < _loc9_.length)
                     {
                        _loc4_.push(_loc9_[_loc6_]);
                        _loc6_++;
                     }
                  }
                  _loc10_ = _loc8_.getPackSku();
                  if(_loc10_)
                  {
                     _loc11_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc10_));
                     if(_loc11_.areCardsPredefined())
                     {
                        _loc12_ = _loc11_.getSpecialCardsArr();
                        if(_loc12_ != null)
                        {
                           _loc13_ = 0;
                           while(_loc13_ < _loc12_.length)
                           {
                              _loc4_.push(_loc12_[_loc13_]);
                              _loc13_++;
                           }
                        }
                     }
                  }
               }
               _loc7_++;
            }
         }
         return _loc4_;
      }
      
      public function getRewardedGoldForLevelRanks(param1:String, param2:String, param3:int) : int
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:RewardDef = null;
         var _loc9_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<RewardDef> = this.getRewardDefsForLevelRanks(param1,param2,param3);
         if(_loc5_ != null)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               _loc8_ = _loc5_[_loc7_];
               if(_loc8_)
               {
                  _loc4_ += _loc8_.getGold();
               }
               _loc7_++;
            }
         }
         return _loc4_;
      }
      
      public function getRewardCardRaritiesCatalogs(param1:RewardDef, param2:int) : Object
      {
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:RarityDef = null;
         var _loc3_:Object = new Object();
         var _loc4_:Dictionary = new Dictionary(true);
         var _loc5_:Dictionary = new Dictionary(true);
         var _loc6_:Dictionary = InstanceMng.getRaritiesDefMng().getAllDefs();
         var _loc7_:int = 1;
         for each(_loc10_ in _loc6_)
         {
            _loc9_ = _loc10_.getSku();
            _loc7_ = 1;
            while(_loc7_ <= param2)
            {
               _loc8_ = param1.getChanceByRaritySkuAndIndex(RewardDef.SUFFIX_CARD,_loc9_);
               if(_loc8_ > 0)
               {
                  if(_loc8_ == 100)
                  {
                     if(_loc4_[_loc9_] == null)
                     {
                        _loc4_[_loc9_] = 1;
                     }
                     else
                     {
                        _loc4_[_loc9_] += 1;
                     }
                  }
                  else
                  {
                     if(_loc5_[_loc7_] == null)
                     {
                        _loc5_[_loc7_] = new Dictionary(true);
                     }
                     if(_loc5_[_loc7_][_loc9_] == null)
                     {
                        _loc5_[_loc7_][_loc9_] = _loc8_;
                     }
                  }
               }
               _loc7_++;
            }
         }
         _loc3_.rarities = _loc4_;
         _loc3_.mixedRarities = _loc5_;
         return _loc3_;
      }
      
      public function getRewardsRaids() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:RewardDef = null;
         var _loc3_:Array = new Array();
         for each(_loc2_ in mDefsBySku)
         {
            if(_loc2_.getRewardType() == RewardDef.REWARD_TYPE_RAID)
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
   }
}

