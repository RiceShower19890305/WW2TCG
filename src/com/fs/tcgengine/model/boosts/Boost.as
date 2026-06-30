package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.BoostItem;
   
   public class Boost
   {
      
      protected var mBoostDef:BoostDef;
      
      private var mBoostItemParent:BoostItem;
      
      protected var mWaitTime:Number = 1;
      
      public function Boost(param1:BoostDef)
      {
         super();
         this.mBoostDef = param1;
      }
      
      public function execute() : void
      {
         if(!this.mBoostDef.isPermanent())
         {
            InstanceMng.getUserDataMng().getOwnerUserData().removeBoostFromCatalog(this.mBoostDef.getSku(),1);
         }
         if(this.mBoostItemParent != null)
         {
            this.mBoostItemParent.onExecuted();
         }
         var _loc1_:int = InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().getLevelDef() != null ? InstanceMng.getBattleEngine().getLevelDef().getLevelIndex() : -1;
         FSTracker.trackMiscAction(FSTracker.CATEGORY_BATTLE,FSTracker.ACTION_BOOST_USED,{
            "level":_loc1_,
            "sku":this.mBoostDef.getSku()
         });
      }
      
      public function onExecuted() : void
      {
      }
      
      public function userHasBoost() : Boolean
      {
         var _loc1_:Boolean = false;
         return this.getAmount() > 0;
      }
      
      public function getAmount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.getBoostAmount(this.mBoostDef.getSku());
         }
         return _loc1_;
      }
      
      public function getBoostItemParent() : BoostItem
      {
         return this.mBoostItemParent;
      }
      
      public function setBoostItemParent(param1:BoostItem) : void
      {
         this.mBoostItemParent = param1;
      }
      
      public function getWaitTime() : Number
      {
         return this.mWaitTime;
      }
      
      public function setWaitTime(param1:Number) : void
      {
         this.mWaitTime = param1;
      }
   }
}

