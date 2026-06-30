package com.fs.tcgengine.model.boosts
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.BoostDef;
   
   public class PostBoostHP extends BoostHP
   {
      
      public function PostBoostHP(param1:BoostDef)
      {
         super(param1);
      }
      
      override public function onExecuted() : void
      {
         super.onExecuted();
         InstanceMng.getUserDataMng().getOwnerUserData().setPostBoost(null);
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().getOwnerBattleInfo().getUserBattlePortrait().removeCardAnims();
            InstanceMng.getBattleEngine().setBattleStateId(BattleEngine.BATTLE_STATE_BATTLE_IDLE);
            InstanceMng.getBattleEngine().changePlayersState();
            InstanceMng.getBattleEngine().getOwnerBattleInfo().resetRaidCumulativeDamageCurrentBattle();
         }
      }
   }
}

