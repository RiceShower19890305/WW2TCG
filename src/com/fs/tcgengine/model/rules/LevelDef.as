package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class LevelDef extends Def
   {
      
      private var mUnits:Dictionary;
      
      private var mPowerSku:String;
      
      private var mAIPowerSku:String;
      
      private var mAIUnits:Dictionary;
      
      private var mAIActions:Dictionary;
      
      private var mAIAttachments:Dictionary;
      
      private var mAIEasyPowerSku:String;
      
      private var mAIEasyUnits:Dictionary;
      
      private var mAIEasyActions:Dictionary;
      
      private var mAIEasyAttachments:Dictionary;
      
      private var mRowsAmount:int;
      
      private var mColumnsAmount:int;
      
      private var mDeckCards:int;
      
      private var mActionPointsPerTurn:FSNumber;
      
      private var mIAActionPointsPerTurn:FSNumber;
      
      private var mGameModeSku:String;
      
      private var mRewardSku:Dictionary;
      
      private var mRewardMediumSku:Dictionary;
      
      private var mRewardHardSku:Dictionary;
      
      private var mReplayRewardSku:String;
      
      private var mReplayRewardMediumSku:String;
      
      private var mReplayRewardHardSku:String;
      
      private var mHP:FSNumber;
      
      private var mIAHP:FSNumber;
      
      private var mRestrictionSku:String;
      
      private var mBackgroundSku:Dictionary;
      
      private var mBackgroundSkuOld:Dictionary;
      
      private var mMusicTrack:String;
      
      private var mMinScore:int;
      
      private var mMedScore:int;
      
      private var mMaxScore:int;
      
      private var mMinMediumScore:int;
      
      private var mMedMediumScore:int;
      
      private var mMaxMediumScore:int;
      
      private var mMinHardScore:int;
      
      private var mMedHardScore:int;
      
      private var mMaxHardScore:int;
      
      private var mAverageTurns:int;
      
      private var mPreBoostsArr:Array;
      
      private var mBoostsArr:Array;
      
      private var mEnemyHeroSku:Dictionary;
      
      private var mKillEnemyRequired:Boolean;
      
      private var mTurns:FSNumber;
      
      private var mFinishTime:Number;
      
      private var mKillSpecCardsCatalog:Dictionary;
      
      private var mKillCategoryCatalog:Dictionary;
      
      private var mKillSubcategoryCatalog:Dictionary;
      
      private var mPlayCategoryCatalog:Dictionary;
      
      private var mPlaySubcategoryCatalog:Dictionary;
      
      private var mObjectiveCompleteOnEnemyKilled:Boolean;
      
      private var mIsSurvivalMode:Boolean;
      
      private var mIAUsePowers:Boolean;
      
      private var mBattleEventsSku:Dictionary;
      
      private var mBattleEventsMediumSku:Dictionary;
      
      private var mBattleEventsHardSku:Dictionary;
      
      private var mIAUseSacrifice:Boolean;
      
      private var mExp:FSNumber;
      
      private var mExpMedium:FSNumber;
      
      private var mExpHard:FSNumber;
      
      private var mExpReplay:FSNumber;
      
      private var mExpMediumReplay:FSNumber;
      
      private var mExpHardReplay:FSNumber;
      
      private var mExpLose:FSNumber;
      
      private var mMaxIAActionPoints:FSNumber;
      
      private var mMaxActionPoints:FSNumber;
      
      private var mPassiveAbilitySku:String;
      
      private var mIAPassiveAbilitySku:Dictionary;
      
      private var mChestBG:String;
      
      private var mHardness:int = 0;
      
      public function LevelDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         this.mAIUnits = this.readComplexAttributeJSON(this.mAIUnits,"IAUnitsSku",param1,true);
         this.mAIAttachments = this.readComplexAttributeJSON(this.mAIAttachments,"IAAttachmentsSku",param1,true);
         this.mAIActions = this.readComplexAttributeJSON(this.mAIActions,"IAActionsSku",param1,true);
         this.mAIEasyActions = this.readComplexAttributeJSON(this.mAIEasyActions,"IAEasyActionsSku",param1,true);
         this.mAIEasyAttachments = this.readComplexAttributeJSON(this.mAIEasyAttachments,"IAEasyAttachmentsSku",param1,true);
         this.mAIEasyUnits = this.readComplexAttributeJSON(this.mAIEasyUnits,"IAEasyUnitsSku",param1,true);
         this.mRewardSku = this.readComplexAttributeJSON(this.mRewardSku,"rewardSku",param1);
         this.mRewardMediumSku = this.readComplexAttributeJSON(this.mRewardMediumSku,"rewardMediumSku",param1);
         this.mRewardHardSku = this.readComplexAttributeJSON(this.mRewardHardSku,"rewardHardSku",param1);
         this.mBackgroundSku = this.readComplexAttributeJSON(this.mBackgroundSku,"backgroundSku",param1);
         this.mBackgroundSkuOld = this.readComplexAttributeJSON(this.mBackgroundSkuOld,"backgroundSkuOld",param1);
         this.mEnemyHeroSku = this.readComplexAttributeJSON(this.mEnemyHeroSku,"heroSku",param1);
         this.mIAPassiveAbilitySku = this.readComplexAttributeJSON(this.mIAPassiveAbilitySku,"IApassiveAbilitySku",param1);
         this.mBattleEventsSku = this.readComplexAttributeJSON(this.mBattleEventsSku,"battleEventsSku",param1);
         this.mBattleEventsMediumSku = this.readComplexAttributeJSON(this.mBattleEventsMediumSku,"battleEventsMediumSku",param1);
         this.mBattleEventsHardSku = this.readComplexAttributeJSON(this.mBattleEventsHardSku,"battleEventsHardSku",param1);
         if("unitsSku" in param1)
         {
            if(String(param1.unitsSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.unitsSku);
               this.setUnits(_loc3_.split(","));
            }
         }
         if("powerSku" in param1)
         {
            if(String(param1.powerSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.powerSku);
               this.mPowerSku = _loc3_;
            }
         }
         if("IAPowerSku" in param1)
         {
            if(String(param1.IAPowerSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IAPowerSku);
               this.mAIPowerSku = _loc3_;
            }
         }
         if("IAEasyPowerSku" in param1)
         {
            if(String(param1.IAEasyPowerSku) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.IAEasyPowerSku);
               this.mAIEasyPowerSku = _loc3_;
            }
         }
         if("rowsAmount" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.rowsAmount);
            this.setRowsAmount(int(_loc3_));
         }
         if("columnsAmount" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.columnsAmount);
            this.setColumnsAmount(int(_loc3_));
         }
         if("deckCards" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.deckCards);
            this.setDeckCards(int(_loc3_));
         }
         if("actionPoints" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.actionPoints);
            this.setActionPointsPerTurn(int(_loc3_));
         }
         if("IAActionsPoints" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.IAActionsPoints);
            this.setIAActionPointsPerTurn(int(_loc3_));
         }
         if("gameModeSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.gameModeSku);
            this.setGameModeSku(_loc3_);
         }
         if("replayRewardSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.replayRewardSku);
            this.setReplayRewardSku(_loc3_);
         }
         if("replayRewardMediumSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.replayRewardMediumSku);
            this.setReplayRewardMediumSku(_loc3_);
         }
         if("replayRewardHardSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.replayRewardHardSku);
            this.setReplayRewardHardSku(_loc3_);
         }
         if("HP" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.HP);
            this.setHP(int(_loc3_));
         }
         if("IAHP" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.IAHP);
            this.setIAHP(int(_loc3_));
         }
         if("restrictionSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.restrictionSku);
            this.setRestrictionSku(_loc3_);
         }
         if("musicTrack" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.musicTrack);
            this.setMusicTrack(_loc3_);
         }
         if("minScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.minScore);
            this.setMinScore(int(_loc3_));
         }
         if("medScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.medScore);
            this.setMedScore(int(_loc3_));
         }
         if("maxScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.maxScore);
            this.setMaxScore(int(_loc3_));
         }
         if("minMediumScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.minMediumScore);
            this.setMinMediumScore(int(_loc3_));
         }
         if("medMediumScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.medMediumScore);
            this.setMedMediumScore(int(_loc3_));
         }
         if("maxMediumScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.maxMediumScore);
            this.setMaxMediumScore(int(_loc3_));
         }
         if("minHardScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.minHardScore);
            this.setMinHardScore(int(_loc3_));
         }
         if("medHardScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.medHardScore);
            this.setMedHardScore(int(_loc3_));
         }
         if("maxHardScore" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.maxHardScore);
            this.setMaxHardScore(int(_loc3_));
         }
         if("averageTurns" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.averageTurns);
            this.setAverageTurns(int(_loc3_));
         }
         if("preBoosts" in param1)
         {
            if(String(param1.preBoosts) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.preBoosts);
               this.setPreBoostsArr(_loc3_.split(","));
            }
         }
         if("boosts" in param1)
         {
            if(String(param1.boosts) != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.boosts);
               this.setBoostsArr(_loc3_.split(","));
            }
         }
         if("killEnemyRequired" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.killEnemyRequired);
            this.setKillEnemyRequired(Utils.stringToBoolean(_loc3_));
         }
         if("finishTime" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.finishTime);
            this.setFinishTime(Number(_loc3_));
         }
         if("turns" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.turns);
            this.setTurnsAmount(int(_loc3_));
         }
         if("killSpecCard" in param1)
         {
            if(param1.killSpecCard != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.killSpecCard);
               _loc2_ = _loc3_.split(",");
               this.setKillSpecCardsCatalog(_loc2_);
            }
         }
         if("killCategory" in param1)
         {
            if(param1.killCategory != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.killCategory);
               _loc2_ = _loc3_.split(",");
               this.setKillCategoryCatalog(_loc2_);
            }
         }
         if("killSubCategory" in param1)
         {
            if(param1.killSubCategory != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.killSubCategory);
               _loc2_ = _loc3_.split(",");
               this.setKillSubcategoryCatalog(_loc2_);
            }
         }
         if("playCategory" in param1)
         {
            if(param1.playCategory != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.playCategory);
               _loc2_ = _loc3_.split(",");
               this.setPlayCategoryCatalog(_loc2_);
            }
         }
         if("playSubCategory" in param1)
         {
            if(param1.playSubCategory != "")
            {
               _loc3_ = Utils.cleanMasterString(param1.playSubCategory);
               _loc2_ = String(_loc3_).split(",");
               this.setPlaySubcategoryCatalog(_loc2_);
            }
         }
         if("completeOnKill" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.completeOnKill);
            this.setObjectiveCompleteOnEnemyKilled(Utils.stringToBoolean(_loc3_));
         }
         if("isSurvival" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.isSurvival);
            this.setIsSurvivalMode(Utils.stringToBoolean(_loc3_));
         }
         if("IAUsePowers" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.IAUsePowers);
            this.mIAUsePowers = Utils.stringToBoolean(_loc3_);
         }
         if("IAUseSacrifice" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.IAUseSacrifice);
            this.mIAUseSacrifice = Utils.stringToBoolean(_loc3_);
         }
         if("exp" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.exp);
            this.setExp(int(_loc3_));
         }
         if("expMedium" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expMedium);
            this.setExpMedium(int(_loc3_));
         }
         if("expHard" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expHard);
            this.setExpHard(int(_loc3_));
         }
         if("expReplay" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expReplay);
            this.setExpReplay(int(_loc3_));
         }
         if("expMediumReplay" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expMediumReplay);
            this.setExpMediumReplay(int(_loc3_));
         }
         if("expHardReplay" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expHardReplay);
            this.setExpHardReplay(int(_loc3_));
         }
         if("expLose" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.expLose);
            this.setExpLose(int(_loc3_));
         }
         if("maxActionPoints" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.maxActionPoints);
            if(this.mMaxActionPoints == null)
            {
               this.mMaxActionPoints = new FSNumber(Number(_loc3_));
            }
         }
         if("maxIAActionPoints" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.maxIAActionPoints);
            if(this.mMaxIAActionPoints == null)
            {
               this.mMaxIAActionPoints = new FSNumber(Number(_loc3_));
            }
         }
         if("passiveAbilitySku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.passiveAbilitySku);
            this.mPassiveAbilitySku = _loc3_;
         }
         if("chestBG" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.chestBG);
            this.mChestBG = _loc3_;
         }
         if("hardness" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.hardness);
            this.mHardness = int(_loc3_);
         }
      }
      
      public function setExpLose(param1:Number) : void
      {
         if(this.mExpLose == null)
         {
            this.mExpLose = new FSNumber();
         }
         this.mExpLose.value = param1;
      }
      
      public function getExpLose() : Number
      {
         return this.mExpLose ? this.mExpLose.value : 0;
      }
      
      public function setExpHardReplay(param1:Number) : void
      {
         if(this.mExpHardReplay == null)
         {
            this.mExpHardReplay = new FSNumber();
         }
         this.mExpHardReplay.value = param1;
      }
      
      public function getExpHardReplay() : Number
      {
         return this.mExpHardReplay ? this.mExpHardReplay.value : 0;
      }
      
      public function setExpMediumReplay(param1:Number) : void
      {
         if(this.mExpMediumReplay == null)
         {
            this.mExpMediumReplay = new FSNumber();
         }
         this.mExpMediumReplay.value = param1;
      }
      
      public function getExpMediumReplay() : Number
      {
         return this.mExpMediumReplay ? this.mExpMediumReplay.value : 0;
      }
      
      public function setExpReplay(param1:Number) : void
      {
         if(this.mExpReplay == null)
         {
            this.mExpReplay = new FSNumber();
         }
         this.mExpReplay.value = param1;
      }
      
      public function getExpReplay() : Number
      {
         return this.mExpReplay ? this.mExpReplay.value : 0;
      }
      
      public function setExpHard(param1:Number) : void
      {
         if(this.mExpHard == null)
         {
            this.mExpHard = new FSNumber();
         }
         this.mExpHard.value = param1;
      }
      
      public function getExpHard() : Number
      {
         return this.mExpHard ? this.mExpHard.value : 0;
      }
      
      public function setExpMedium(param1:Number) : void
      {
         if(this.mExpMedium == null)
         {
            this.mExpMedium = new FSNumber();
         }
         this.mExpMedium.value = param1;
      }
      
      public function getExpMedium() : Number
      {
         return this.mExpMedium ? this.mExpMedium.value : 0;
      }
      
      public function setExp(param1:Number) : void
      {
         if(this.mExp == null)
         {
            this.mExp = new FSNumber();
         }
         this.mExp.value = param1;
      }
      
      public function getExp() : Number
      {
         return this.mExp ? this.mExp.value : 0;
      }
      
      public function getPlayerCards() : Dictionary
      {
         return this.mUnits;
      }
      
      public function setUnits(param1:Array) : void
      {
         this.mUnits = DictionaryUtils.addCards(param1,this.mUnits);
      }
      
      public function getPowerSku() : String
      {
         return this.mPowerSku;
      }
      
      public function getIAPowerSku() : String
      {
         return this.mAIPowerSku;
      }
      
      public function getAIEasyPowerSku() : String
      {
         return this.mAIEasyPowerSku;
      }
      
      public function getAIUnits(param1:int) : Dictionary
      {
         return this.getWorldSpecificValue(this.mAIUnits,param1);
      }
      
      private function valueHasWorldsContentJSON(param1:Object, param2:String) : Boolean
      {
         var _loc3_:String = param1[param2];
         var _loc4_:Boolean = _loc3_ != null && _loc3_.toString().length > 0;
         return Config.getConfig().gameHasWorlds() && _loc4_;
      }
      
      private function readComplexAttributeJSON(param1:Dictionary, param2:String, param3:Object, param4:Boolean = false) : Dictionary
      {
         var _loc5_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc6_:int = 2;
         var _loc9_:Boolean = this.valueHasWorldsContentJSON(param3,param2 + "_0");
         if(_loc9_)
         {
            _loc5_ = 0;
            while(_loc5_ <= _loc6_)
            {
               _loc7_ = param3[param2 + "_" + _loc5_];
               if(_loc7_ != null)
               {
                  _loc8_ = Utils.cleanMasterString(_loc7_);
                  if(_loc8_ != "")
                  {
                     if(param1 == null)
                     {
                        param1 = new Dictionary(true);
                     }
                     if(param1[_loc5_] == null)
                     {
                        param1[_loc5_] = param4 ? DictionaryUtils.addCards(_loc8_.split(","),param1[_loc5_]) : _loc8_;
                     }
                  }
               }
               _loc5_++;
            }
         }
         else
         {
            _loc7_ = param3[param2];
            _loc8_ = Utils.cleanMasterString(_loc7_);
            if(param1 == null)
            {
               param1 = new Dictionary(true);
            }
            param1[0] = Boolean(param4) && Boolean(_loc8_) && _loc8_.length > 0 ? DictionaryUtils.addCards(_loc8_.split(","),param1[0]) : _loc8_;
            param1[0] = param4 && param1[0] == "" ? null : param1[0];
         }
         return param1;
      }
      
      public function getAIEasyUnits(param1:int) : Dictionary
      {
         return this.getWorldSpecificValue(this.mAIEasyUnits,param1);
      }
      
      public function getAIActions(param1:int) : Dictionary
      {
         return this.getWorldSpecificValue(this.mAIActions,param1);
      }
      
      public function getAIEasyActions(param1:int) : Dictionary
      {
         return this.getWorldSpecificValue(this.mAIEasyActions,param1);
      }
      
      public function getAIAttachments(param1:int) : Dictionary
      {
         return this.getWorldSpecificValue(this.mAIAttachments,param1);
      }
      
      public function getAIEasyAttachments(param1:int) : Dictionary
      {
         return this.getWorldSpecificValue(this.mAIEasyAttachments,param1);
      }
      
      public function getRowsAmount() : int
      {
         return this.mRowsAmount;
      }
      
      public function setRowsAmount(param1:int) : void
      {
         this.mRowsAmount = param1;
      }
      
      public function getColumnsAmount() : int
      {
         return this.mColumnsAmount;
      }
      
      public function setColumnsAmount(param1:int) : void
      {
         this.mColumnsAmount = param1;
      }
      
      public function getDeckCards() : int
      {
         return this.mDeckCards;
      }
      
      public function setDeckCards(param1:int) : void
      {
         this.mDeckCards = param1;
      }
      
      public function getActionPointsPerTurn() : int
      {
         return this.mActionPointsPerTurn ? int(this.mActionPointsPerTurn.value) : 0;
      }
      
      public function setActionPointsPerTurn(param1:int) : void
      {
         if(this.mActionPointsPerTurn == null)
         {
            this.mActionPointsPerTurn = new FSNumber();
         }
         this.mActionPointsPerTurn.value = Number(param1);
      }
      
      public function getGameModeSku() : String
      {
         return this.mGameModeSku;
      }
      
      public function setGameModeSku(param1:String) : void
      {
         this.mGameModeSku = param1;
      }
      
      public function getRewardSku(param1:int) : String
      {
         return this.getWorldSpecificValue(this.mRewardSku,param1);
      }
      
      public function getReplayRewardSku() : String
      {
         return this.mReplayRewardSku;
      }
      
      public function setReplayRewardSku(param1:String) : void
      {
         this.mReplayRewardSku = param1;
      }
      
      public function getReplayRewardMediumSku() : String
      {
         return this.mReplayRewardMediumSku;
      }
      
      public function setReplayRewardMediumSku(param1:String) : void
      {
         this.mReplayRewardMediumSku = param1;
      }
      
      public function getReplayRewardHardSku() : String
      {
         return this.mReplayRewardHardSku;
      }
      
      public function setReplayRewardHardSku(param1:String) : void
      {
         this.mReplayRewardHardSku = param1;
      }
      
      public function getHP() : int
      {
         return this.mHP ? int(this.mHP.value) : 0;
      }
      
      public function getHPEncripted() : FSNumber
      {
         return this.mHP;
      }
      
      public function setHP(param1:int) : void
      {
         if(this.mHP == null)
         {
            this.mHP = new FSNumber();
         }
         this.mHP.value = Number(param1);
      }
      
      public function getIAHP() : int
      {
         return this.mIAHP ? int(this.mIAHP.value) : 0;
      }
      
      public function getAIHPEncripted() : FSNumber
      {
         return this.mIAHP;
      }
      
      public function setIAHP(param1:int) : void
      {
         if(this.mIAHP == null)
         {
            this.mIAHP = new FSNumber();
         }
         this.mIAHP.value = Number(param1);
      }
      
      public function getRestrictionSku() : String
      {
         return this.mRestrictionSku;
      }
      
      public function setRestrictionSku(param1:String) : void
      {
         this.mRestrictionSku = param1;
      }
      
      public function getBackgroundSku(param1:int) : String
      {
         return this.getWorldSpecificValue(this.mBackgroundSku,param1);
      }
      
      public function getBackgroundSkuOld(param1:int) : String
      {
         return this.getWorldSpecificValue(this.mBackgroundSkuOld,param1);
      }
      
      public function getMusicTrack() : String
      {
         return this.mMusicTrack;
      }
      
      public function setMusicTrack(param1:String) : void
      {
         this.mMusicTrack = param1;
      }
      
      public function getMinScore() : int
      {
         return this.mMinScore;
      }
      
      public function setMinScore(param1:int) : void
      {
         this.mMinScore = param1;
      }
      
      public function getMedScore() : int
      {
         return this.mMedScore;
      }
      
      public function setMedScore(param1:int) : void
      {
         this.mMedScore = param1;
      }
      
      public function getMaxScore() : int
      {
         return this.mMaxScore;
      }
      
      public function setMaxScore(param1:int) : void
      {
         this.mMaxScore = param1;
      }
      
      public function getMinMediumScore() : int
      {
         return this.mMinMediumScore;
      }
      
      public function setMinMediumScore(param1:int) : void
      {
         this.mMinMediumScore = param1;
      }
      
      public function getMedMediumScore() : int
      {
         return this.mMedMediumScore;
      }
      
      public function setMedMediumScore(param1:int) : void
      {
         this.mMedMediumScore = param1;
      }
      
      public function getMaxMediumScore() : int
      {
         return this.mMaxMediumScore;
      }
      
      public function setMaxMediumScore(param1:int) : void
      {
         this.mMaxMediumScore = param1;
      }
      
      public function getMinHardScore() : int
      {
         return this.mMinHardScore;
      }
      
      public function setMinHardScore(param1:int) : void
      {
         this.mMinHardScore = param1;
      }
      
      public function getMedHardScore() : int
      {
         return this.mMedHardScore;
      }
      
      public function setMedHardScore(param1:int) : void
      {
         this.mMedHardScore = param1;
      }
      
      public function getMaxHardScore() : int
      {
         return this.mMaxHardScore;
      }
      
      public function setMaxHardScore(param1:int) : void
      {
         this.mMaxHardScore = param1;
      }
      
      public function getAverageTurns() : int
      {
         return this.mAverageTurns;
      }
      
      public function setAverageTurns(param1:int) : void
      {
         this.mAverageTurns = param1;
      }
      
      public function getPreBoostsArr() : Array
      {
         return this.mPreBoostsArr;
      }
      
      public function setPreBoostsArr(param1:Array) : void
      {
         this.mPreBoostsArr = param1;
      }
      
      public function getAIActionPointsPerTurn() : int
      {
         return this.mIAActionPointsPerTurn ? int(this.mIAActionPointsPerTurn.value) : 0;
      }
      
      public function setIAActionPointsPerTurn(param1:int) : void
      {
         if(this.mIAActionPointsPerTurn == null)
         {
            this.mIAActionPointsPerTurn = new FSNumber();
         }
         this.mIAActionPointsPerTurn.value = Number(param1);
      }
      
      public function getBoostsArr() : Array
      {
         return this.mBoostsArr;
      }
      
      public function setBoostsArr(param1:Array) : void
      {
         this.mBoostsArr = param1;
      }
      
      public function areDefaultCardsDefined() : Boolean
      {
         return this.mUnits != null && DictionaryUtils.getDictionaryLength(this.mUnits) > 0;
      }
      
      public function isCardAllowedInThisLevel(param1:CardDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:RestrictionDef = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc2_:Boolean = true;
         if(Boolean(this.isPvPLevel()) && Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isOnlineMatch())
         {
            _loc4_ = PvPConnectionMng.smPvPBannedCards != null && PvPConnectionMng.smPvPBannedCards != "" && PvPConnectionMng.smPvPBannedCards.length > 3 ? PvPConnectionMng.smPvPBannedCards.split(",") : null;
            if((Boolean(_loc4_)) && _loc4_.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc4_.length)
               {
                  if(Boolean(param1) && param1.getSku() == _loc4_[_loc3_])
                  {
                     return false;
                  }
                  _loc3_++;
               }
            }
         }
         if(Boolean(param1) && param1 is UnitDef)
         {
            _loc2_ = false;
            _loc5_ = RestrictionDef(InstanceMng.getRestrictionsDefMng().getDefBySku(this.getRestrictionSku()));
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_.getSubCategoryAllowedSku();
               _loc7_ = param1.getSubCategorySku();
               if(_loc6_)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc6_.length)
                  {
                     if(_loc7_)
                     {
                        _loc8_ = 0;
                        while(_loc8_ < _loc7_.length)
                        {
                           if(_loc7_[_loc8_] == _loc6_[_loc3_])
                           {
                              return true;
                           }
                           _loc8_++;
                        }
                     }
                     _loc3_++;
                  }
               }
            }
         }
         if(!_loc2_)
         {
            FSDebug.debugTrace("[isCardAllowedInThisLevel] - CardSku: " + param1.getSku() + " not allowed in levelSku: " + getSku());
         }
         return _loc2_;
      }
      
      public function isUpgradeAllowed() : Boolean
      {
         var _loc1_:Boolean = true;
         var _loc2_:RestrictionDef = RestrictionDef(InstanceMng.getRestrictionsDefMng().getDefBySku(this.getRestrictionSku()));
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.isUpgradeAllowed();
         }
         return _loc1_;
      }
      
      public function getLevelIndex() : int
      {
         var _loc1_:Array = mSku.split("_");
         return _loc1_[1];
      }
      
      public function isTutorialLevel() : Boolean
      {
         return this.areDefaultCardsDefined();
      }
      
      public function getEnemyHeroSku(param1:int) : String
      {
         return this.getWorldSpecificValue(this.mEnemyHeroSku,param1);
      }
      
      public function isKillEnemyRequired() : Boolean
      {
         return this.mKillEnemyRequired;
      }
      
      public function setKillEnemyRequired(param1:Boolean) : void
      {
         this.mKillEnemyRequired = param1;
      }
      
      public function getTurnsAmount() : int
      {
         return this.mTurns ? int(this.mTurns.value) : 0;
      }
      
      public function setTurnsAmount(param1:int) : void
      {
         if(this.mTurns == null)
         {
            this.mTurns = new FSNumber();
         }
         this.mTurns.value = param1;
      }
      
      public function getFinishTime() : Number
      {
         return this.mFinishTime;
      }
      
      public function setFinishTime(param1:Number) : void
      {
         this.mFinishTime = param1;
      }
      
      public function getObjectiveCompleteOnEnemyKilled() : Boolean
      {
         return this.mObjectiveCompleteOnEnemyKilled;
      }
      
      public function setObjectiveCompleteOnEnemyKilled(param1:Boolean) : void
      {
         this.mObjectiveCompleteOnEnemyKilled = param1;
      }
      
      public function getKillSpecCardsCatalog() : Dictionary
      {
         return this.mKillSpecCardsCatalog;
      }
      
      public function setKillSpecCardsCatalog(param1:Array) : void
      {
         this.mKillSpecCardsCatalog = DictionaryUtils.addCards(param1,this.mKillSpecCardsCatalog);
      }
      
      public function getKillCategoryCatalog() : Dictionary
      {
         return this.mKillCategoryCatalog;
      }
      
      public function setKillCategoryCatalog(param1:Array) : void
      {
         this.mKillCategoryCatalog = DictionaryUtils.addCards(param1,this.mKillCategoryCatalog,false);
      }
      
      public function getKillSubcategoryCatalog() : Dictionary
      {
         return this.mKillSubcategoryCatalog;
      }
      
      public function setKillSubcategoryCatalog(param1:Array) : void
      {
         this.mKillSubcategoryCatalog = DictionaryUtils.addCards(param1,this.mKillSubcategoryCatalog,false);
      }
      
      public function getPlayCategoryCatalog() : Dictionary
      {
         return this.mPlayCategoryCatalog;
      }
      
      public function setPlayCategoryCatalog(param1:Array) : void
      {
         this.mPlayCategoryCatalog = DictionaryUtils.addCards(param1,this.mPlayCategoryCatalog);
      }
      
      public function getPlaySubcategoryCatalog() : Dictionary
      {
         return this.mPlaySubcategoryCatalog;
      }
      
      public function setPlaySubcategoryCatalog(param1:Array) : void
      {
         this.mPlaySubcategoryCatalog = DictionaryUtils.addCards(param1,this.mPlaySubcategoryCatalog,false);
      }
      
      public function isSurvivalMode() : Boolean
      {
         return this.mIsSurvivalMode;
      }
      
      public function setIsSurvivalMode(param1:Boolean) : void
      {
         this.mIsSurvivalMode = param1;
      }
      
      public function isPvPLevel() : Boolean
      {
         return mSku.indexOf("pvp") != -1;
      }
      
      public function getIAUsePowers() : Boolean
      {
         return this.mIAUsePowers;
      }
      
      public function getBattleEventsSku(param1:int) : String
      {
         return this.getWorldSpecificValue(this.mBattleEventsSku,param1);
      }
      
      public function getBattleEventSkuByDifficulty(param1:int, param2:int) : String
      {
         var _loc3_:String = null;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc3_ = this.getWorldSpecificValue(this.mBattleEventsSku,param2);
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc3_ = this.getWorldSpecificValue(this.mBattleEventsMediumSku,param2);
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc3_ = this.getWorldSpecificValue(this.mBattleEventsHardSku,param2);
               break;
            default:
               _loc3_ = this.getWorldSpecificValue(this.mBattleEventsSku,param2);
         }
         return _loc3_;
      }
      
      public function getIAUseSacrifice() : Boolean
      {
         return this.mIAUseSacrifice;
      }
      
      public function hasBattleEvent() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = false;
         if(InstanceMng.getUserDataMng())
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            _loc3_ = this.getMapWorldParentIndex();
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc3_);
            return this.getBattleEventSkuByDifficulty(_loc2_,_loc4_) != null && this.getBattleEventSkuByDifficulty(_loc2_,_loc4_) != "";
         }
         return _loc1_;
      }
      
      public function getMinScoreByDifficulty(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc2_ = this.mMinScore;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc2_ = this.mMinMediumScore;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc2_ = this.mMinHardScore;
               break;
            default:
               _loc2_ = this.mMinScore;
         }
         return _loc2_;
      }
      
      public function getMedScoreByDifficulty(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc2_ = this.mMedScore;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc2_ = this.mMedMediumScore;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc2_ = this.mMedHardScore;
               break;
            default:
               _loc2_ = this.mMedScore;
         }
         return _loc2_;
      }
      
      public function getMaxScoreByDifficulty(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc2_ = this.mMaxScore;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc2_ = this.mMaxMediumScore;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc2_ = this.mMaxHardScore;
               break;
            default:
               _loc2_ = this.mMaxScore;
         }
         return _loc2_;
      }
      
      public function getRewardSkuByDifficulty(param1:int = 0, param2:int = 0) : String
      {
         var _loc3_:String = null;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc3_ = this.getWorldSpecificValue(this.mRewardSku,param2);
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc3_ = this.getWorldSpecificValue(this.mRewardMediumSku,param2);
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc3_ = this.getWorldSpecificValue(this.mRewardHardSku,param2);
               break;
            default:
               _loc3_ = this.getWorldSpecificValue(this.mRewardSku,param2);
         }
         return _loc3_;
      }
      
      public function getReplayRewardSkuByDifficulty(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case UserDataMng.DIFFICULTY_EASY:
               _loc2_ = this.mReplayRewardSku;
               break;
            case UserDataMng.DIFFICULTY_MEDIUM:
               _loc2_ = this.mReplayRewardMediumSku;
               break;
            case UserDataMng.DIFFICULTY_HARD:
               _loc2_ = this.mReplayRewardHardSku;
               break;
            default:
               _loc2_ = this.mReplayRewardSku;
         }
         return _loc2_;
      }
      
      public function getExperience(param1:Boolean, param2:Boolean = false) : Number
      {
         var _loc3_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : 0;
         var _loc4_:Number = 0;
         if(param2 && !param1)
         {
            _loc4_ = this.getExpLose();
         }
         else if(!param2 && param1)
         {
            switch(_loc3_)
            {
               case UserDataMng.DIFFICULTY_EASY:
                  _loc4_ = this.getExpReplay();
                  break;
               case UserDataMng.DIFFICULTY_MEDIUM:
                  _loc4_ = this.getExpMediumReplay();
                  break;
               case UserDataMng.DIFFICULTY_HARD:
                  _loc4_ = this.getExpHardReplay();
                  break;
               default:
                  _loc4_ = this.getExpReplay();
            }
         }
         else if(!param2 && !param1)
         {
            switch(_loc3_)
            {
               case UserDataMng.DIFFICULTY_EASY:
                  _loc4_ = this.getExp();
                  break;
               case UserDataMng.DIFFICULTY_MEDIUM:
                  _loc4_ = this.getExpMedium();
                  break;
               case UserDataMng.DIFFICULTY_HARD:
                  _loc4_ = this.getExpHard();
                  break;
               default:
                  _loc4_ = this.getExp();
            }
         }
         return _loc4_;
      }
      
      public function getMaxActionPoints() : Number
      {
         return this.mMaxActionPoints ? this.mMaxActionPoints.value : 0;
      }
      
      public function getMaxAIActionPoints() : Number
      {
         return this.mMaxIAActionPoints ? this.mMaxIAActionPoints.value : 0;
      }
      
      public function getPassiveAbilitySku() : String
      {
         return this.mPassiveAbilitySku;
      }
      
      public function getAIPassiveAbilitySku(param1:int) : String
      {
         return this.getWorldSpecificValue(this.mIAPassiveAbilitySku,param1);
      }
      
      public function getChestBG() : String
      {
         return this.mChestBG;
      }
      
      private function getWorldSpecificValue(param1:Dictionary, param2:int) : *
      {
         var _loc3_:* = undefined;
         if(param1)
         {
            _loc3_ = param1[param2] != null ? param1[param2] : param1[0];
         }
         else
         {
            _loc3_ = param1;
         }
         return _loc3_;
      }
      
      public function getMapWorldParentIndex() : int
      {
         var _loc1_:int = -1;
         var _loc2_:int = InstanceMng.getMapsDefMng().getMapIndexByLevelIndex(this.getLevelIndex());
         var _loc3_:MapDef = MapDef(InstanceMng.getMapsDefMng().getDefBySku("map_" + Utils.transformValueToString(_loc2_.toString(),2)));
         if(_loc3_)
         {
            _loc1_ = _loc3_.getWorldParentIndex();
         }
         return _loc1_;
      }
      
      public function getHardness() : int
      {
         return this.mHardness;
      }
   }
}

