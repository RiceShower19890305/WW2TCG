package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.StarsRewardsDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class StarsRewardsDefMng extends DefMng
   {
      
      public function StarsRewardsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new StarsRewardsDef();
      }
      
      public function getOwnerNextStarReward() : StarsRewardsDef
      {
         var _loc3_:StarsRewardsDef = null;
         var _loc1_:StarsRewardsDef = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getHighestStarsRewardClaimed();
            if(_loc3_)
            {
               _loc1_ = this.getDefByIndex(_loc3_.getIndex() + 1);
            }
            else
            {
               _loc1_ = this.getDefByIndex(0);
            }
         }
         return _loc1_;
      }
      
      public function getDefByIndex(param1:int) : StarsRewardsDef
      {
         var _loc2_:StarsRewardsDef = null;
         var _loc3_:StarsRewardsDef = null;
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getIndex() == param1)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      override public function getDefBySku(param1:String) : Def
      {
         var _loc2_:StarsRewardsDef = null;
         var _loc3_:StarsRewardsDef = null;
         var _loc4_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         for each(_loc3_ in mDefsBySku)
         {
            if(_loc3_.getSku() == param1 && _loc3_.getDifficulty() == _loc4_)
            {
               return _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function isAnyStarsRewardClaimeable() : Boolean
      {
         var _loc2_:StarsRewardsDef = null;
         var _loc1_:Boolean = false;
         var _loc3_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         for each(_loc2_ in mDefsBySku)
         {
            if(_loc2_.getDifficulty() == _loc3_)
            {
               if(this.isStarRewardClaimeable(_loc2_))
               {
                  return true;
               }
            }
         }
         return _loc1_;
      }
      
      private function isStarRewardClaimeable(param1:StarsRewardsDef) : Boolean
      {
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().get3StarLevelsCompleted();
         var _loc3_:int = param1.getStarsAmount() - _loc2_;
         var _loc4_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isStarsRewardAlreadyClaimed(param1.getSku());
         var _loc5_:Boolean = InstanceMng.getServerConnection().isUserLoggedIn();
         return _loc3_ <= 0 && _loc5_ && !_loc4_;
      }
      
      override public function getAllDefs() : Dictionary
      {
         var _loc2_:StarsRewardsDef = null;
         var _loc1_:Dictionary = new Dictionary(true);
         var _loc3_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         for each(_loc2_ in mDefsBySku)
         {
            if(_loc2_.getDifficulty() == _loc3_)
            {
               _loc1_[_loc2_.getSku()] = _loc2_;
            }
         }
         return _loc1_;
      }
   }
}

