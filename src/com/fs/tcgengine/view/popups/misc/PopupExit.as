package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.AbilitiesPanel;
   import starling.events.Event;
   
   public class PopupExit extends PopupStandard
   {
      
      public function PopupExit(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function onAccept(param1:Event) : void
      {
         super.onAccept(param1);
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ is FSBattleScreen)
         {
            mOnClosedFunction = this.onAcceptFromBattleScreen;
         }
      }
      
      private function onAcceptFromBattleScreen() : void
      {
         var _loc2_:LevelDef = null;
         var _loc3_:String = null;
         var _loc4_:AbilitiesPanel = null;
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc1_ != null)
         {
            if(_loc1_.isPvPMatch())
            {
               if(_loc1_.isOnlineMatch())
               {
                  PvPConnectionMng.onSurrenderPvPMatch();
                  BattleEnginePvP(_loc1_).onBattleOver(false,true);
               }
               else
               {
                  Utils.createPvPOverEffect(null);
               }
            }
            else
            {
               _loc2_ = _loc1_.getLevelDef();
               _loc3_ = Boolean(Root) && Boolean(Root.smBattleData) && Boolean(Root.smBattleData.easyMode) ? FSTracker.ACTION_SURRENDER_EASY_MODE : FSTracker.ACTION_SURRENDER;
               if(Boolean(_loc2_ && Root) && Boolean(Root.smBattleData) && !Root.smBattleData.isDungeon)
               {
                  FSTracker.trackMiscAction(FSTracker.getLevelCategoryByDifficulty(),_loc3_,{"level":_loc2_.getSku()});
               }
               _loc4_ = _loc1_.getBattleScreen() ? _loc1_.getBattleScreen().getAbilitiesChooserPanel() : null;
               if(_loc4_)
               {
                  _loc4_.forceClose();
               }
               _loc1_.setBattleStateId(BattleEngine.BATTLE_STATE_BATTLE_OVER);
               _loc1_.onBattleOver(false,true);
            }
         }
      }
   }
}

