package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   
   public class PostBoostExtraTurns extends Boost
   {
      
      public function PostBoostExtraTurns(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().setExtraTurnsBought(mBoostDef.getValue());
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).updateCurrentTurnsTextfield();
            }
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_BOOST_DEFENSE"),[mBoostDef.getValue()]));
         }
         else
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(mBoostDef.getSku(),1,true);
            InstanceMng.getUserDataMng().updateBoosts();
         }
         TweenMax.delayedCall(2,this.onExecuted);
         super.execute();
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

