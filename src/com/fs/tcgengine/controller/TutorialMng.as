package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.TutorialDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   import flash.utils.Dictionary;
   import starling.events.Event;
   
   public class TutorialMng
   {
      
      public static const TUTORIAL_PANEL_CONVERSATION_BG_NAME:String = "tutorial_panel_conversation";
      
      public static const TUTORIAL_SOLDIER_BG_NAME:String = "tutorial_soldier";
      
      private var mBattleEngine:BattleEngine;
      
      private var mTutorialDefs:Array;
      
      private var mTutorialDefsRequested:Boolean;
      
      public function TutorialMng()
      {
         super();
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         this.manageTutorialSteps();
      }
      
      private function manageTutorialSteps() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TutorialDef = null;
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            if(!this.mTutorialDefsRequested)
            {
               if(this.mBattleEngine == null)
               {
                  this.mBattleEngine = InstanceMng.getBattleEngine();
               }
               _loc1_ = this.mBattleEngine.getLevelDef().getSku();
               this.mTutorialDefs = InstanceMng.getTutorialDefMng().getTutorialDefsByLevelSku(_loc1_);
               this.mTutorialDefsRequested = true;
            }
            if(this.mTutorialDefs != null && this.mTutorialDefsRequested && InstanceMng.getCurrentScreen().isFullyLoaded())
            {
               if(this.mBattleEngine == null)
               {
                  this.mBattleEngine = InstanceMng.getBattleEngine();
               }
               if(!this.mBattleEngine.isPlayersIntroPlaying())
               {
                  _loc2_ = this.mBattleEngine.getCurrentTurnId();
                  _loc4_ = int(this.mTutorialDefs.length);
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc5_ = this.mTutorialDefs[_loc3_];
                     if(_loc5_ != null)
                     {
                        if(_loc5_.getTurn() == _loc2_)
                        {
                           this.mTutorialDefs.splice(_loc3_,1);
                           if(this.mTutorialDefs.length == 0)
                           {
                              this.mTutorialDefs = null;
                           }
                           if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                           {
                              FSBattleScreen(InstanceMng.getCurrentScreen()).lockUI(true);
                           }
                           this.onTutorialTriggerStepOps(_loc5_,_loc3_);
                        }
                     }
                     _loc3_++;
                  }
               }
            }
         }
      }
      
      private function onTutorialTriggerStepOps(param1:TutorialDef, param2:int) : void
      {
         FSDebug.debugTrace("Opening Tutorial Popup");
         if(Boolean(InstanceMng.getPopupMng()) && Boolean(param1))
         {
            TweenMax.delayedCall(0.2,InstanceMng.getPopupMng().openTutorialPopup,[param1]);
         }
      }
      
      public function unload() : void
      {
         var _loc1_:int = 0;
         this.mBattleEngine = null;
         if(this.mTutorialDefs != null)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.mTutorialDefs.length)
            {
               this.mTutorialDefs[_loc1_] = null;
               _loc1_++;
            }
            this.mTutorialDefs.length = 0;
            this.mTutorialDefs = null;
         }
         this.mTutorialDefsRequested = false;
      }
      
      public function isTutorialOver() : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:LevelDef = null;
         var _loc1_:Boolean = false;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getCurrentLevelSkuByDifficulty(UserDataMng.DIFFICULTY_EASY);
            if(_loc3_ != "" && _loc3_ != null)
            {
               _loc4_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(_loc3_));
               if(_loc4_ != null)
               {
                  _loc1_ = !_loc4_.isTutorialLevel();
               }
               else
               {
                  _loc1_ = true;
               }
            }
         }
         return _loc1_;
      }
      
      public function getFirstNonTutorialLevelIndex() : int
      {
         var _loc2_:LevelDef = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:int = -1;
         var _loc3_:Dictionary = InstanceMng.getLevelsDefMng().getAllDefs();
         var _loc4_:Array = DictionaryUtils.sortDictionaryByKey(_loc3_);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc2_ = _loc3_[_loc4_[_loc5_].key];
            if(!_loc2_.isTutorialLevel())
            {
               return _loc2_.getLevelIndex();
            }
            _loc5_++;
         }
         return _loc1_;
      }
   }
}

