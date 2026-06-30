package com.fs.tcgengine.view.popups.purchases
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.Utils;
   import starling.events.Event;
   
   public class PopupBuyPostBoost extends PopupBuyBoost
   {
      
      public function PopupBuyPostBoost(param1:Boolean = true)
      {
         super(param1);
      }
      
      override public function onPurchaseSuccesful() : void
      {
         InstanceMng.getPopupMng().cleanPopupInBackground();
         super.onPurchaseSuccesful();
      }
      
      override protected function performOpsOnSuccesfulPurchase() : void
      {
         var _loc1_:Boost = null;
         var _loc2_:BattleEngine = null;
         var _loc3_:UserData = null;
         var _loc4_:Number = NaN;
         var _loc5_:LevelDef = null;
         if(mBoostDef)
         {
            _loc1_ = InstanceMng.getBoostsMng().getBoost(mBoostDef);
            _loc2_ = InstanceMng.getBattleEngine();
            if(_loc2_)
            {
               _loc3_ = Boolean(_loc2_.getOwnerBattleInfo()) && Boolean(_loc2_.getOwnerBattleInfo().getUserData()) ? _loc2_.getOwnerBattleInfo().getUserData() : InstanceMng.getUserDataMng().getOwnerUserData();
               _loc3_.setPostBoost(_loc1_);
               InstanceMng.getBattleEngine().onUsePostBoostUsedOnBattleOver();
               Utils.stopSound(Constants.SOUND_DEFEAT);
               if(Boolean(Main.smTracker) && Config.PRODUCTION_BUILD)
               {
                  _loc4_ = 0;
                  _loc5_ = InstanceMng.getBattleEngine().getLevelDef();
                  if(_loc5_)
                  {
                     _loc4_ = Number(_loc5_.getLevelIndex());
                  }
               }
            }
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(!InstanceMng.getUserDataMng().getOwnerUserData().flagsGetUsedFreeBoost())
         {
            this.onPurchaseSuccesful();
            InstanceMng.getUserDataMng().getOwnerUserData().setUsedFreeBoost(true);
            InstanceMng.getUserDataMng().updateFlags();
         }
         else
         {
            _loc2_ = this.getUsersBoostAmount();
            if(_loc2_ > 0)
            {
               this.onPurchaseSuccesful();
            }
            else
            {
               super.onAccept(param1);
            }
         }
      }
      
      private function getUsersBoostAmount() : int
      {
         var _loc1_:int = 0;
         if(mItemDef is BoostDef)
         {
            return InstanceMng.getUserDataMng().getOwnerUserData().getBoostAmount(mItemDef.getSku());
         }
         return 0;
      }
      
      override protected function refreshAcceptButtonState() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(!InstanceMng.getUserDataMng().getOwnerUserData().flagsGetUsedFreeBoost())
         {
            _loc1_ = TextManager.getText("TID_GEN_FREE");
            mAcceptButton.text = _loc1_;
         }
         else
         {
            super.refreshAcceptButtonState();
            _loc2_ = this.getUsersBoostAmount();
            if(_loc2_ > 0)
            {
               mAcceptButton.text = TextManager.getText("TID_GEN_FREE") + " (" + _loc2_ + ")";
            }
         }
      }
   }
}

