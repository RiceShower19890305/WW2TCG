package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.TutorialDeckBuilderDef;
   import com.fs.tcgengine.model.rules.TutorialMapDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.particles.TextParticleWithBG;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.map.MapRewardPanel;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class TutorialMapMng extends TutorialDeckBuilderMng
   {
      
      public static const IMAGE_BG_TUTORIAL_PACK_GLOW:String = "tutorial_pack_glow";
      
      public static const IMAGE_BG_TUTORIAL_CONGRATS_PANEL:String = "tutorial_congratulations_panel";
      
      private var mTutorialStepsStarted:Dictionary;
      
      private var mExtraImageDic:Dictionary;
      
      private var mPackDef:PackDef;
      
      private var mPackClaimed:Boolean;
      
      private var mCurrentTutorialMapDef:TutorialMapDef;
      
      private var mCurrentLevelTutorialsArray:Array;
      
      public function TutorialMapMng()
      {
         super();
         this.getCurrentTutorialMapDef();
      }
      
      override protected function setTutorialAsFinished() : void
      {
         InstanceMng.getCurrentScreen().lockUI(false);
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).make3DSceneVisible(true);
         }
      }
      
      override public function onEnterFrame(param1:Event) : void
      {
         this.manageTutorialRewards();
         super.onEnterFrame(param1);
      }
      
      public function manageTutorialRewards() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(InstanceMng.getCurrentScreen() is FSMapScreen && !this.isTutorialON() && Boolean(InstanceMng.getUserDataMng()))
         {
            _loc1_ = Utils.getOwnerUserData();
            _loc2_ = _loc1_ ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : 0;
            _loc3_ = _loc1_ ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc2_) : 1;
            this.mCurrentLevelTutorialsArray = InstanceMng.getTutorialMapDefMng() ? InstanceMng.getTutorialMapDefMng().getTutorialDefsByLevelSku(_loc3_,_loc2_,this.mCurrentLevelTutorialsArray) : null;
            if(this.mCurrentLevelTutorialsArray != null && this.mCurrentLevelTutorialsArray.length > 0)
            {
               this.mCurrentTutorialMapDef = this.mCurrentLevelTutorialsArray[0];
               if(Boolean(this.mCurrentTutorialMapDef) && Boolean(!this.hasStartedStep(this.mCurrentTutorialMapDef.getIndex())) && FSMapScreen(InstanceMng.getCurrentScreen()).isReadyToTutorial())
               {
                  if(_loc1_)
                  {
                     _loc4_ = _loc1_.tutorialsSeenGetValueAsInt(this.mCurrentTutorialMapDef.getSku()) == 1;
                     if(_loc4_)
                     {
                        return;
                     }
                     _loc1_.tutorialsSeenSetValue(this.mCurrentTutorialMapDef.getSku(),"1");
                     InstanceMng.getUserDataMng().updateTutorialsSeen();
                  }
                  if(this.mCurrentTutorialMapDef.getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD)
                  {
                     if(this.mCurrentTutorialMapDef.getTutorialReward() == "reward1")
                     {
                        this.mPackClaimed = InstanceMng.getUserDataMng().getOwnerUserData().flagsIsTutorialReward1Claimed();
                     }
                     else if(this.mCurrentTutorialMapDef.getTutorialReward() == "reward2")
                     {
                        this.mPackClaimed = InstanceMng.getUserDataMng().getOwnerUserData().flagsIsTutorialReward2Claimed();
                     }
                     if(!this.mPackClaimed)
                     {
                        Utils.playSound(Constants.SOUND_UNFOLD_EPIC_CARD,SoundManager.TYPE_SFX);
                     }
                  }
                  if(this.mCurrentTutorialMapDef.getType() != TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD || !this.mPackClaimed)
                  {
                     if(this.mCurrentTutorialMapDef.needsToBeOnline() && InstanceMng.getServerConnection().isUserLoggedIn() || !this.mCurrentTutorialMapDef.needsToBeOnline())
                     {
                        this.startTutorial(this.mCurrentTutorialMapDef.getIndex());
                        this.updateCurrentStepAsStarted();
                        this.createExtraImageVector(this.mCurrentTutorialMapDef);
                     }
                  }
               }
            }
         }
      }
      
      private function createExtraImageVector(param1:TutorialMapDef) : void
      {
         var _loc3_:PackAnimation = null;
         this.mExtraImageDic = new Dictionary(true);
         var _loc2_:String = param1.getExtraImageBG();
         _loc2_ = _loc2_ != null && _loc2_ != "" ? _loc2_ : "tutorial_soldier";
         switch(param1.getType())
         {
            case TutorialMapDef.TUTORIAL_MAP_TYPE_COMMON:
               break;
            case TutorialMapDef.TUTORIAL_MAP_TYPE_INFORMATION:
               this.mExtraImageDic[_loc2_] = new FSImage(Root.assets.getTexture(_loc2_));
               this.mExtraImageDic[_loc2_].touchable = false;
               break;
            case TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD:
               this.mExtraImageDic[_loc2_] = new FSImage(Root.assets.getTexture(_loc2_));
               this.mExtraImageDic[_loc2_].touchable = false;
               this.mExtraImageDic[IMAGE_BG_TUTORIAL_CONGRATS_PANEL] = new MapRewardPanel(TextManager.getText("TID_GEN_CONGRATULATIONS"),TextManager.getText("TID_GEN_CONGRATULATIONS_DESC"));
               this.mExtraImageDic[IMAGE_BG_TUTORIAL_PACK_GLOW] = new FSImage(Root.assets.getTexture(IMAGE_BG_TUTORIAL_PACK_GLOW));
               this.mPackDef = PackDef(InstanceMng.getPacksDefMng().getDefBySku(param1.getPackSku()));
               _loc3_ = new PackAnimation(this.mPackDef.getAnimBG());
               _loc3_.x = _loc3_.width / 2;
               _loc3_.y = _loc3_.height / 2;
               _loc3_.touchable = true;
               this.mExtraImageDic[this.mPackDef.getBGImageName()] = _loc3_;
         }
      }
      
      override protected function onTutorialTriggerStepOps(param1:TutorialDeckBuilderDef, param2:int) : void
      {
         var _loc4_:String = null;
         var _loc5_:JobDef = null;
         var _loc6_:PackAnimation = null;
         var _loc7_:FSImage = null;
         var _loc8_:FSCoordinate = null;
         super.onTutorialTriggerStepOps(param1,param2);
         var _loc3_:Array = DictionaryUtils.getKeys(this.mExtraImageDic).sort(Array.DESCENDING);
         if(_loc3_.length > 0)
         {
            param2 = 0;
            while(param2 < _loc3_.length)
            {
               this.addExtraImageToTutorial(String(_loc3_[param2]));
               param2++;
            }
         }
         if(TutorialMapDef(param1).hasToBuyJobOnStep())
         {
            _loc4_ = TutorialMapDef(param1).getJobToBuy();
            _loc5_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc4_));
            if(_loc5_)
            {
               JobsMng.buyJob(_loc5_);
            }
         }
         if(TutorialMapDef(param1).getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD)
         {
            _loc6_ = PackAnimation(this.mExtraImageDic[this.mPackDef.getBGImageName()]);
            _loc7_ = FSImage(this.mExtraImageDic[IMAGE_BG_TUTORIAL_PACK_GLOW]);
            _loc8_ = new FSCoordinate(_loc6_.x,_loc6_.y + 6);
            TweenMax.delayedCall(Utils.randomNumber(0,1.5),SpecialFX.createYoYoTransition,[_loc6_,_loc8_,3,-1,null,Quad.easeInOut]);
            _loc7_.alignPivot();
            _loc7_.x += _loc7_.width / 2;
            _loc7_.y += _loc7_.height / 2;
            SpecialFX.createRotation(_loc7_,360,15,0,null,null,Quad.easeInOut,-1);
            if(this.mPackClaimed)
            {
               PackAnimation(this.mExtraImageDic[this.mPackDef.getBGImageName()]).alpha = 0.5;
               FSImage(this.mExtraImageDic[IMAGE_BG_TUTORIAL_PACK_GLOW]).alpha = 0.0001;
            }
         }
      }
      
      private function addExtraImageToTutorial(param1:String) : void
      {
         var _loc2_:String = null;
         if(this.mExtraImageDic)
         {
            _loc2_ = this.mCurrentTutorialMapDef.getExtraImageBG();
            _loc2_ = _loc2_ != null && _loc2_ != "" ? _loc2_ : "tutorial_soldier";
            switch(param1)
            {
               case _loc2_:
                  setPositionScreenRelative(this.mExtraImageDic[_loc2_],"down-right");
                  DisplayObject(this.mExtraImageDic[_loc2_]).alpha = 0.001;
                  SpecialFX.tweenToAlpha(DisplayObject(this.mExtraImageDic[_loc2_]),0.999,1,0);
                  InstanceMng.getCurrentScreen().addChild(DisplayObject(this.mExtraImageDic[_loc2_]));
                  break;
               case IMAGE_BG_TUTORIAL_CONGRATS_PANEL:
                  this.mExtraImageDic[IMAGE_BG_TUTORIAL_CONGRATS_PANEL].alpha = 0.001;
                  SpecialFX.tweenToAlpha(this.mExtraImageDic[IMAGE_BG_TUTORIAL_CONGRATS_PANEL],0.999,1,0);
                  this.mExtraImageDic[IMAGE_BG_TUTORIAL_CONGRATS_PANEL].x = 0;
                  this.mExtraImageDic[IMAGE_BG_TUTORIAL_CONGRATS_PANEL].y = this.mExtraImageDic[IMAGE_BG_TUTORIAL_CONGRATS_PANEL].height / 2;
                  InstanceMng.getCurrentScreen().addChild(this.mExtraImageDic[IMAGE_BG_TUTORIAL_CONGRATS_PANEL]);
                  break;
               case IMAGE_BG_TUTORIAL_PACK_GLOW:
                  setPositionScreenRelative(this.mExtraImageDic[IMAGE_BG_TUTORIAL_PACK_GLOW],"center-center");
                  InstanceMng.getCurrentScreen().addChild(FSImage(this.mExtraImageDic[IMAGE_BG_TUTORIAL_PACK_GLOW]));
                  break;
               default:
                  setPositionScreenRelative(this.mExtraImageDic[param1],"center-center");
                  InstanceMng.getCurrentScreen().addChild(DisplayObject(this.mExtraImageDic[param1]));
                  DisplayObject(this.mExtraImageDic[param1]).addEventListener(TouchEvent.TOUCH,this.onPackClick);
            }
         }
      }
      
      private function onPackClick(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(DisplayObject(this.mExtraImageDic[this.mPackDef.getBGImageName()]),TouchPhase.ENDED);
         if(_loc2_)
         {
            if(InstanceMng.getServerConnection().isUserLoggedIn())
            {
               if(!this.mPackClaimed)
               {
                  if(this.mCurrentTutorialMapDef.getTutorialReward() == "reward1")
                  {
                     InstanceMng.getUserDataMng().getOwnerUserData().setTutorialReward1(true);
                  }
                  else if(this.mCurrentTutorialMapDef.getTutorialReward() == "reward2")
                  {
                     InstanceMng.getUserDataMng().getOwnerUserData().setTutorialReward2(true);
                  }
                  Utils.openPack(this.mPackDef,PacksDefMng.PACK_TUTORIAL_MAP_REWARD);
                  this.mPackClaimed = true;
                  DisplayObject(this.mExtraImageDic[this.mPackDef.getBGImageName()]).alpha = 0.5;
                  FSImage(this.mExtraImageDic[IMAGE_BG_TUTORIAL_PACK_GLOW]).alpha = 0.0001;
                  this.increaseCurrentStep();
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
               InstanceMng.getCurrentScreen().onConnectionLost();
            }
         }
      }
      
      override public function isTutorialON() : Boolean
      {
         return mStartingStep > -1 || mTutorialDefsAmount == mStartingStep - 1;
      }
      
      public function isTutorialWaitingForAPopup() : Boolean
      {
         return Boolean(mCurrentTutorialDef) && mCurrentTutorialDef.hasToWaitForPopup();
      }
      
      override protected function fillTutorialDefsArr() : void
      {
         var _loc1_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : 0;
         var _loc2_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc1_) : 0;
         if(InstanceMng.getTutorialMapDefMng())
         {
            mTutorialDefs = InstanceMng.getTutorialMapDefMng().getTutorialDefsByLevelSku(_loc2_,_loc1_,mTutorialDefs);
         }
      }
      
      private function hasStartedStep(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.mTutorialStepsStarted)
         {
            _loc2_ = this.mTutorialStepsStarted[param1] == 1;
         }
         return _loc2_;
      }
      
      private function updateCurrentStepAsStarted(param1:Boolean = true) : void
      {
         if(this.mTutorialStepsStarted == null)
         {
            this.mTutorialStepsStarted = new Dictionary(true);
         }
         this.mTutorialStepsStarted[mCurrentStep] = param1 ? 1 : 0;
      }
      
      override public function increaseCurrentStep(param1:String = "") : void
      {
         var transitionPortrait:Function = null;
         var comp:* = undefined;
         var triggeredByComponent:String = param1;
         transitionPortrait = function():void
         {
            if(InstanceMng.getCurrentScreen() is FSMapScreen && FSMapScreen(InstanceMng.getCurrentScreen()).isOkToTransitionMapPortrait())
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).performPortraitTransition(true);
            }
         };
         if(InstanceMng.getCurrentScreen() is FSMapScreen && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            if(Boolean(mCurrentTutorialDef) && mCurrentTutorialDef.hasToWaitForPopup())
            {
               if(triggeredByComponent != this.mCurrentTutorialMapDef.getAttachedTo())
               {
                  return;
               }
            }
            if(this.mCurrentTutorialMapDef)
            {
               if(this.mCurrentTutorialMapDef.getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD && this.mPackClaimed || this.mCurrentTutorialMapDef.getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_INFORMATION || (!Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn()))
               {
                  super.increaseCurrentStep();
                  if(this.mExtraImageDic)
                  {
                     for each(comp in this.mExtraImageDic)
                     {
                        comp.removeFromParent();
                        comp = null;
                     }
                     this.mExtraImageDic = null;
                  }
               }
               else if(this.mCurrentTutorialMapDef.getType() != TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD)
               {
                  super.increaseCurrentStep();
               }
               this.updateCurrentStepAsStarted();
            }
            setTimeout(transitionPortrait,300);
         }
      }
      
      override protected function onParticleTouch(param1:TouchEvent) : void
      {
      }
      
      override public function startTutorial(param1:int = 0) : void
      {
         mTutorialDefsRequested = false;
         mOriginalAttachedToComponentParent = null;
         super.startTutorial(param1);
         if(InstanceMng.getCurrentScreen() is FSMapScreen && !this.mCurrentTutorialMapDef.hasToWaitForPopup())
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).make3DSceneVisible(false);
         }
      }
      
      override protected function lockUI(param1:Boolean) : void
      {
         if(!this.mCurrentTutorialMapDef.hasToWaitForPopup())
         {
            InstanceMng.getCurrentScreen().lockUI(true);
         }
      }
      
      override public function unload() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         if(Boolean(mCurrentTutorialDef) && mCurrentTutorialDef.hasToWaitForPopup())
         {
            this.updateCurrentStepAsStarted(false);
         }
         if(this.mExtraImageDic)
         {
            for each(_loc1_ in this.mExtraImageDic)
            {
               _loc1_.removeFromParent(true);
               _loc1_ = null;
            }
            this.mExtraImageDic = null;
         }
         DictionaryUtils.clearDictionary(this.mTutorialStepsStarted);
         this.mTutorialStepsStarted = null;
         this.mPackDef = null;
         this.mCurrentTutorialMapDef = null;
         if(this.mCurrentLevelTutorialsArray)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mCurrentLevelTutorialsArray.length)
            {
               this.mCurrentLevelTutorialsArray[_loc2_] = null;
               _loc2_++;
            }
            this.mCurrentLevelTutorialsArray.length = 0;
            this.mCurrentLevelTutorialsArray = null;
         }
         super.unload();
      }
      
      override protected function createTutorialBubble(param1:TutorialDeckBuilderDef) : void
      {
         if(TutorialMapDef(param1).getType() != TutorialMapDef.TUTORIAL_MAP_TYPE_COMMON)
         {
            if(mCurrentParticle == null)
            {
               mCurrentParticle = new TextParticleWithBG(TutorialMng.TUTORIAL_PANEL_CONVERSATION_BG_NAME,1536);
               mCurrentParticle.setBG(TutorialMng.TUTORIAL_PANEL_CONVERSATION_BG_NAME,Align.CENTER,FSResourceMng.FONT_TYPE_STD_DESC,0,true);
            }
            mCurrentParticle.touchable = false;
            mCurrentParticle.addEventListener(TouchEvent.TOUCH,this.onParticleTouch);
            if((!Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn()) && TutorialMapDef(param1).getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD)
            {
               mCurrentParticle.setText(TextManager.getText(param1.getDescTID() + "_OFFLINE"));
            }
            else
            {
               mCurrentParticle.setText(param1.getDesc());
            }
            setPositionScreenRelative(mCurrentParticle,"down-center");
         }
         else
         {
            super.createTutorialBubble(param1);
         }
      }
      
      public function isTutorialReward() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.mCurrentTutorialMapDef.getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_REWARD)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function isTutorialInformation() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.mCurrentTutorialMapDef.getType() == TutorialMapDef.TUTORIAL_MAP_TYPE_INFORMATION)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function getCurrentTutorialMapDef() : TutorialMapDef
      {
         var _loc2_:int = 0;
         var _loc4_:UserData = null;
         var _loc1_:int = 0;
         if(InstanceMng.getUserDataMng())
         {
            _loc4_ = Utils.getOwnerUserData();
            if(_loc4_)
            {
               _loc2_ = _loc4_.getCurrentDifficulty();
               if(InstanceMng.getLevelsDefMng())
               {
                  _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc2_) : 0;
               }
            }
         }
         var _loc3_:Array = InstanceMng.getTutorialMapDefMng().getTutorialDefsByLevelSku(_loc1_,_loc2_);
         if(_loc3_ != null && _loc3_.length > 0)
         {
            this.mCurrentTutorialMapDef = _loc3_[0];
         }
         return this.mCurrentTutorialMapDef;
      }
   }
}

