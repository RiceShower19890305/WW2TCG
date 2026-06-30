package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.GameModeDef;
   import com.fs.tcgengine.model.rules.GameScoreDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.TurnScoreDef;
   import com.fs.tcgengine.screens.FSBattleScreen;
   
   public class ScoreMng
   {
      
      public static const PLAY_UNIT:int = 1;
      
      public static const PLAY_ATTACHMENT:int = 2;
      
      public static const PLAY_ORDER_COST_1:int = 3;
      
      public static const PLAY_ORDER_COST_2:int = 4;
      
      public static const PLAY_ORDER_COST_3:int = 5;
      
      public static const UPGRADE_TIER_1_COST_1:int = 6;
      
      public static const UPGRADE_TIER_1_COST_2:int = 7;
      
      public static const UPGRADE_TIER_1_COST_3:int = 8;
      
      public static const UPGRADE_TIER_2_COST_1:int = 9;
      
      public static const UPGRADE_TIER_2_COST_2:int = 10;
      
      public static const UPGRADE_TIER_2_COST_3:int = 11;
      
      public static const DESTROY_UNIT_TIER_1:int = 12;
      
      public static const DESTROY_UNIT_TIER_1_WITH_ATTACHMENT:int = 13;
      
      public static const DESTROY_UNIT_TIER_2:int = 14;
      
      public static const DESTROY_UNIT_TIER_2_WITH_ATTACHMENT:int = 15;
      
      public static const DESTROY_UNIT_TIER_3:int = 16;
      
      public static const DESTROY_UNIT_TIER_3_WITH_ATTACHMENT:int = 17;
      
      private var mLevelDef:LevelDef;
      
      private var mBattleScore:int;
      
      public function ScoreMng()
      {
         super();
      }
      
      public function startTracking(param1:LevelDef) : void
      {
         if(param1 != null)
         {
            this.mLevelDef = param1;
            this.mBattleScore = 0;
         }
      }
      
      public function trackAction(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:GameScoreDef = GameScoreDef(InstanceMng.getGameScoresDefMng().getDefByIndex(param1));
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getPointsAmount();
            if(Config.TRACE_BATTLE_LOGS)
            {
               FSDebug.debugTrace("Increasing the battle score points in " + _loc3_ + " points");
            }
            this.mBattleScore += _loc3_;
            FSDebug.debugTrace("Total battle score points: " + this.mBattleScore);
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).updateScoreStars();
            }
         }
      }
      
      public function calculateFinalScore(param1:Boolean) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(InstanceMng.getBattleEngine())
         {
            _loc3_ = this.getPointsGainedByHPLeft(param1);
            _loc4_ = this.getPointsGainedByTurnsLeft(param1);
            _loc5_ = this.getPointsGainedByCombat();
            _loc2_ = _loc3_ + _loc5_ + _loc4_;
         }
         return _loc2_;
      }
      
      public function getPointsGainedByCombat() : int
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getCurrentTurnId();
            _loc4_ = this.mLevelDef ? this.mLevelDef.getAverageTurns() : 0;
            _loc1_ = this.mBattleScore * _loc4_ / _loc3_;
         }
         return _loc1_;
      }
      
      public function getPointsGainedByHPLeft(param1:Boolean) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc3_)
         {
            if(param1)
            {
               _loc2_ = _loc3_.getOwnerBattleInfo() ? int(_loc3_.getOwnerBattleInfo().getHP() * 100) : 0;
            }
            else
            {
               _loc4_ = _loc3_.getCurrentTurnId();
               _loc5_ = this.mLevelDef ? this.mLevelDef.getAverageTurns() : 0;
               _loc2_ = _loc3_.getOwnerBattleInfo() ? int(_loc3_.getOwnerBattleInfo().getHP() * 100 * (_loc4_ - 1) / _loc5_) : 0;
            }
         }
         return _loc2_;
      }
      
      public function getPointsGainedByTurnsLeft(param1:Boolean) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TurnScoreDef = null;
         var _loc8_:GameModeDef = null;
         var _loc2_:int = 0;
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         if(Boolean(_loc3_) && Boolean(this.mLevelDef))
         {
            _loc4_ = _loc3_.getCurrentTurnId();
            _loc5_ = this.mLevelDef.getAverageTurns();
            _loc6_ = _loc5_ - _loc4_ > 0 ? int(_loc5_ - _loc4_) : 0;
            _loc7_ = InstanceMng.getTurnScoresDefMng().getDefByTurnsLeft(_loc6_);
            if(_loc7_ != null)
            {
               _loc8_ = GameModeDef(InstanceMng.getGameModesDefMng().getDefBySku(this.mLevelDef.getGameModeSku()));
               if(_loc8_ != null)
               {
                  _loc2_ = _loc7_.getPointsAmountByGameModeIndex(_loc8_.getIndex());
               }
            }
         }
         if(!param1)
         {
            _loc2_ = 0;
         }
         return _loc2_;
      }
      
      public function getBattleScore() : int
      {
         return this.mBattleScore;
      }
      
      public function setBattleScore(param1:int) : void
      {
         this.mBattleScore = param1;
      }
   }
}

