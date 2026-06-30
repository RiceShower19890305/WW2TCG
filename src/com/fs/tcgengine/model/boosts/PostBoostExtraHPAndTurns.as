package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   
   public class PostBoostExtraHPAndTurns extends Boost
   {
      
      public function PostBoostExtraHPAndTurns(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         var _loc1_:UserBattleInfo = null;
         var _loc3_:int = 0;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.getOwnerBattleInfo();
            if(_loc1_ != null)
            {
               _loc3_ = mBoostDef.getValue();
               _loc1_.modifyHP(new FSNumber(_loc3_),true);
            }
            _loc2_.setExtraTurnsBought(2);
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).updateCurrentTurnsTextfield();
            }
            Utils.setLogText(TextManager.getText("TID_BOOST_HP_TURNS_INCREASE"));
            super.execute();
         }
         else
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(mBoostDef.getSku(),1,true);
            InstanceMng.getUserDataMng().updateBoosts();
         }
         TweenMax.delayedCall(2,this.onExecuted);
      }
      
      override public function onExecuted() : void
      {
         super.onExecuted();
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            InstanceMng.getUserDataMng().getOwnerUserData().setPostBoost(null);
         }
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().setBattleStateId(BattleEngine.BATTLE_STATE_BATTLE_IDLE);
            InstanceMng.getBattleEngine().changePlayersState();
            InstanceMng.getBattleEngine().getOwnerBattleInfo().resetRaidCumulativeDamageCurrentBattle();
         }
      }
   }
}

