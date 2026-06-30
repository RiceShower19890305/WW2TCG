package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TutorialMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.TutorialDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class PopupTutorial extends PopupStandard
   {
      
      private var mTutorialDef:TutorialDef;
      
      private var mTextPanelContainer:Component;
      
      private var mTextPanelImg:CustomComponent;
      
      private var mTextPanelTextfield:FSTextfield;
      
      private var mCharacterBG:FSImage;
      
      private var mAnimMC:MovieClip;
      
      public function PopupTutorial(param1:Boolean = true)
      {
         super(true);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         if(param1.getTouch(this,TouchPhase.ENDED))
         {
            closePopup(this.onCancelPerformActions);
         }
      }
      
      override protected function setResourcesToLoad() : void
      {
         var _loc1_:String = null;
         if(this.mTutorialDef != null)
         {
            _loc1_ = "tutorial_" + Utils.transformValueToString((this.mTutorialDef.getIndex() + 1).toString(),2);
            InstanceMng.getResourcesMng().addResourcesFolderByName("tutorial/" + _loc1_);
            InstanceMng.getResourcesMng().addResourceToLoad("misc/" + Constants.SOUND_PANEL_DOWN,FSResourceMng.TYPE_AUDIO);
            InstanceMng.getResourcesMng().addResourceToLoad("tutorial/" + TutorialMng.TUTORIAL_SOLDIER_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
            super.setResourcesToLoad();
         }
      }
      
      override protected function addBGToLoad() : void
      {
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:String = null;
         if(this.mAnimMC)
         {
            this.mAnimMC.stop();
            this.mAnimMC.removeFromParent(true);
            Starling.juggler.remove(this.mAnimMC);
            this.mAnimMC = null;
         }
         if(this.mTextPanelImg)
         {
            this.mTextPanelImg.removeFromParent(true);
            this.mTextPanelImg = null;
         }
         if(this.mTextPanelTextfield)
         {
            this.mTextPanelTextfield.removeFromParent(true);
            this.mTextPanelTextfield = null;
         }
         if(this.mTextPanelContainer)
         {
            this.mTextPanelContainer.removeFromParent(true);
            this.mTextPanelContainer = null;
         }
         if(this.mCharacterBG)
         {
            this.mCharacterBG.removeFromParent(true);
            this.mCharacterBG = null;
         }
         if(this.mTutorialDef)
         {
            Root.assets.removeTexture(this.mTutorialDef.getBGImageName());
         }
         Root.assets.removeTexture(TutorialMng.TUTORIAL_SOLDIER_BG_NAME);
         if(this.mTutorialDef)
         {
            _loc1_ = "tutorial_" + Utils.transformValueToString((this.mTutorialDef.getIndex() + 1).toString(),2);
            InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("tutorial/" + _loc1_,InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.TUTORIAL_POPUP_NAME);
         Utils.removeSound(Constants.SOUND_PANEL_DOWN);
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         this.mTutorialDef = null;
         super.removeFromStage();
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         var _loc1_:Texture = Root.assets.getTexture(mBGName);
         if(Boolean(mBox) && Boolean(_loc1_))
         {
            updateBGTexture(mBGName);
            mBox.width = _loc1_.width;
            mBox.height = _loc1_.height;
         }
         this.createTextPanel();
      }
      
      private function createTextPanel() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.mTextPanelContainer == null)
         {
            this.mTextPanelContainer = new Component();
            this.mTextPanelContainer.touchable = false;
         }
         if(this.mTextPanelImg == null)
         {
            this.mTextPanelImg = Utils.createCustomBox(TutorialMng.TUTORIAL_PANEL_CONVERSATION_BG_NAME,1536);
            this.mTextPanelContainer.addChild(this.mTextPanelImg);
         }
         if(this.mTextPanelTextfield == null)
         {
            _loc1_ = Utils.isIphone();
            _loc2_ = _loc1_ ? this.mTextPanelImg.width * 0.81 : this.mTextPanelImg.width * 0.75;
            _loc3_ = _loc1_ ? this.mTextPanelImg.height * 0.91 : this.mTextPanelImg.height * 0.82;
            this.mTextPanelTextfield = new FSTextfield(_loc2_,_loc3_,"",0);
            this.mTextPanelTextfield.touchable = false;
            this.mTextPanelTextfield.fontName = FSResourceMng.getFontByType(Config.getConfig().getTutorialPopupFontName());
            this.mTextPanelTextfield.fontSize = !Utils.isDesktop() ? FSResourceMng.FONT_STD_SUBTITLE_SIZE : FSResourceMng.FONT_STD_SMALL_SIZE;
            this.mTextPanelTextfield.x = (this.mTextPanelImg.width - this.mTextPanelTextfield.width) / 2 + 3;
            this.mTextPanelTextfield.y = (this.mTextPanelImg.height - this.mTextPanelTextfield.height) / 2;
            this.mTextPanelContainer.addChild(this.mTextPanelTextfield);
         }
         this.mTextPanelContainer.x = (mBox.width - this.mTextPanelContainer.width) / 2;
         this.mTextPanelContainer.y = mBox.height;
         this.mTextPanelContainer.visible = false;
         addChildAt(this.mTextPanelContainer,0);
      }
      
      public function setupPopup(param1:TutorialDef) : void
      {
         this.mTutorialDef = param1;
         if(this.mTutorialDef != null)
         {
            mBGName = this.mTutorialDef.getBGImageName();
            this.setResourcesToLoad();
         }
      }
      
      private function onCancelPerformActions() : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).lockUI(false);
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         closePopup(this.onCancelPerformActions);
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         super.onPopupOpenTransitionOver();
         this.createCharacter();
      }
      
      private function createCharacter() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         if(this.mCharacterBG == null && Boolean(mBox))
         {
            this.mCharacterBG = new FSImage(Root.assets.getTexture(TutorialMng.TUTORIAL_SOLDIER_BG_NAME));
            this.mCharacterBG.touchable = false;
            this.mCharacterBG.alpha = 0.001;
            _loc1_ = localToGlobal(new Point(mBox.x));
            _loc2_ = localToGlobal(new Point(mBox.y));
            this.mCharacterBG.x = Starling.current.stage.stageWidth - this.mCharacterBG.width - _loc1_.x;
            this.mCharacterBG.y = Starling.current.stage.stageHeight - this.mCharacterBG.height - _loc2_.y;
            addChild(this.mCharacterBG);
            SpecialFX.tweenToAlpha(this.mCharacterBG,0.999,0.5,0,this.startTextAnimation);
         }
      }
      
      private function startTextAnimation() : void
      {
         var _loc1_:FSCoordinate = null;
         if(Boolean(this.mTextPanelImg != null) && Boolean(this.mTextPanelContainer) && Boolean(this.mTutorialDef))
         {
            this.mTextPanelContainer.y -= this.mTextPanelContainer.height;
            this.mTextPanelContainer.visible = true;
            _loc1_ = new FSCoordinate(this.mTextPanelContainer.x,this.mTextPanelContainer.y + this.mTextPanelContainer.height);
            this.mTextPanelTextfield.text = this.mTutorialDef.getDesc() ? this.mTutorialDef.getDesc().toUpperCase() : "";
            this.createAnimMC();
            SpecialFX.createTransition(this.mTextPanelContainer,_loc1_,1,0);
            Utils.playSound(Constants.SOUND_PANEL_DOWN,SoundManager.TYPE_SFX);
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      private function createAnimMC() : void
      {
         var _loc1_:String = null;
         if(this.mAnimMC == null)
         {
            _loc1_ = this.mTutorialDef.getAnimBGName();
            if(_loc1_ != "" && _loc1_ != null)
            {
               if(Root.assets.getTextures(_loc1_) != null)
               {
                  this.mAnimMC = new MovieClip(Root.assets.getTextures(_loc1_),this.mTutorialDef.getFPS());
                  this.mAnimMC.touchable = false;
                  this.mAnimMC.alpha = 0.001;
                  this.mAnimMC.stop();
                  this.mAnimMC.x = this.mTutorialDef.getAnimPosX() / 100 * mBox.width;
                  this.mAnimMC.y = this.mTutorialDef.getAnimPosY() / 100 * mBox.height;
                  Starling.juggler.add(this.mAnimMC);
                  addChild(this.mAnimMC);
                  SpecialFX.tweenToAlpha(this.mAnimMC,0.999,2,0,this.onMCCreatedPerformOps);
               }
            }
            else
            {
               this.onMCCreatedPerformOps();
            }
         }
      }
      
      private function onMCCreatedPerformOps() : void
      {
         this.playMC();
         TweenMax.delayedCall(1.5,this.onFinishAnimPerformOps);
      }
      
      private function playMC() : void
      {
         if(this.mAnimMC)
         {
            this.mAnimMC.play();
            this.mAnimMC.loop = false;
            if(!this.mAnimMC.hasEventListener(Event.COMPLETE))
            {
               this.mAnimMC.addEventListener(Event.COMPLETE,this.movieCompletedHandler);
            }
         }
      }
      
      private function movieCompletedHandler(param1:Event) : void
      {
         if(this.mAnimMC)
         {
            this.mAnimMC.stop();
            Starling.juggler.delayCall(this.playMC,1.5);
         }
      }
      
      private function onFinishAnimPerformOps() : void
      {
         if(mCloseButton)
         {
            SpecialFX.createYoYoZoomTransition(mCloseButton,1.3,1,-1,null,null,false);
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function performOnOpenDefaultOps(param1:FSCoordinate, param2:Number = 0.6) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc3_)
         {
            _loc4_ = _loc3_.getBattleStateId();
            _loc5_ = _loc3_.getPlayersStateId();
            if(Boolean(_loc3_) && Boolean(_loc4_ != BattleEngine.BATTLE_STATE_DEALING_CARDS) && _loc5_ != BattleEngine.STATE_OWNER_MOVING_UP_FROM_SUPPORT)
            {
               super.performOnOpenDefaultOps(param1,0.85);
            }
            else
            {
               setTimeout(this.performOnOpenDefaultOps,500,param1,0.85);
            }
         }
         else
         {
            closePopup();
         }
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
   }
}

