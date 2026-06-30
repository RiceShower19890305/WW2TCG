package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TutorialMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.TutorialDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class PopupHowToPlay extends PopupStandard
   {
      
      private const IMG_PREFIX:String = "popup_tutorial_";
      
      private var mNextButton:FSButton;
      
      private var mPrevButton:FSButton;
      
      private var mCurrentSlideIndex:int = 1;
      
      private var mTextPanelContainer:Component;
      
      private var mTextPanelImg:CustomComponent;
      
      private var mTextPanelTextfield:FSTextfield;
      
      private var mCharacterBG:FSImage;
      
      private var mAnimMC:MovieClip;
      
      private var mTutorialDef:TutorialDef;
      
      private var mMaxImagesIndex:int = 0;
      
      public function PopupHowToPlay(param1:Boolean = true)
      {
         super(true);
      }
      
      override protected function addBGToLoad() : void
      {
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(Root.assets.getSound("misc/" + Constants.SOUND_PANEL_DOWN) == null)
         {
            InstanceMng.getResourcesMng().addResourceToLoad("misc/" + Constants.SOUND_PANEL_DOWN,FSResourceMng.TYPE_AUDIO);
         }
         if(Root.assets.getTexture("tutorial/" + TutorialMng.TUTORIAL_SOLDIER_BG_NAME) == null)
         {
            InstanceMng.getResourcesMng().addResourceToLoad("tutorial/" + TutorialMng.TUTORIAL_SOLDIER_BG_NAME,FSResourceMng.TYPE_TEXTURE_PNG);
         }
         this.loadCurrentTutorialIndexResources(false);
         super.setResourcesToLoad();
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         this.mTutorialDef = TutorialDef(InstanceMng.getTutorialDefMng().getTutorialDefByIndex(this.mCurrentSlideIndex));
         mBGName = this.mTutorialDef.getBGImageName();
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mNextButton)
         {
            this.mNextButton.removeFromParent(true);
            this.mNextButton = null;
         }
         if(this.mPrevButton)
         {
            this.mPrevButton.removeFromParent(true);
            this.mPrevButton = null;
         }
         if(this.mTextPanelContainer)
         {
            this.mTextPanelContainer.removeFromParent(true);
            this.mTextPanelContainer = null;
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
         if(this.mCharacterBG)
         {
            this.mCharacterBG.removeFromParent(true);
            this.mCharacterBG = null;
         }
         if(this.mAnimMC)
         {
            Starling.juggler.remove(this.mAnimMC);
            this.mAnimMC.removeFromParent(true);
            this.mAnimMC = null;
         }
         var _loc1_:String = "tutorial_" + Utils.transformValueToString((this.mTutorialDef.getIndex() + 1).toString(),2);
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("tutorial/" + _loc1_,InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
         InstanceMng.getPopupMng().removePopup(FSPopupMng.HOW_TO_PLAY_POPUP_NAME);
         Root.assets.removeTexture(TutorialMng.TUTORIAL_SOLDIER_BG_NAME);
         Utils.removeSound(Constants.SOUND_PANEL_DOWN);
         this.mTutorialDef = null;
         super.removeFromStage();
      }
      
      private function loadCurrentTutorialIndexResources(param1:Boolean = true) : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(true,true);
         this.mTutorialDef = TutorialDef(InstanceMng.getTutorialDefMng().getTutorialDefByIndex(this.mCurrentSlideIndex));
         var _loc2_:String = "tutorial_" + Utils.transformValueToString((this.mTutorialDef.getIndex() + 1).toString(),2);
         InstanceMng.getResourcesMng().addResourcesFolderByName("tutorial/" + _loc2_);
         if(param1)
         {
            InstanceMng.getResourcesMng().loadAssets(this.loadCurrentSlide);
         }
      }
      
      private function unloadLastTutorialIndexResources() : void
      {
         if(this.mAnimMC)
         {
            this.mAnimMC.stop();
            this.mAnimMC.removeFromParent(true);
            Starling.juggler.remove(this.mAnimMC);
            this.mAnimMC = null;
         }
         updateBGTexture("popup_bg_01");
         mBox.alpha = 0.25;
         var _loc1_:String = "tutorial_" + Utils.transformValueToString((this.mTutorialDef.getIndex() + 1).toString(),2);
         InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("tutorial/" + _loc1_,InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.mMaxImagesIndex = InstanceMng.getTutorialDefMng().getDefsAmount();
         this.setupArrowButtons();
         this.createTextPanel();
         this.createAnimMC();
         this.checkArrowButtonsState();
      }
      
      private function loadCurrentSlide() : void
      {
         if(mBox == null)
         {
            return;
         }
         this.enableArrowButtons(true);
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         mBGName = this.mTutorialDef.getBGImageName();
         var _loc1_:Texture = Root.assets.getTexture(mBGName);
         updateBGTexture(mBGName);
         mBox.width = _loc1_.width;
         mBox.height = _loc1_.height;
         addChild(mBox);
         this.resetButtonsPos();
         this.checkArrowButtonsState();
         this.createAnimMC();
         this.createTextPanel();
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         mBox.alpha = 0.999;
         addChild(mCloseButton);
      }
      
      private function createCharacter() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         if(this.mCharacterBG == null)
         {
            this.mCharacterBG = new FSImage(Root.assets.getTexture(TutorialMng.TUTORIAL_SOLDIER_BG_NAME));
            this.mCharacterBG.touchable = false;
            this.mCharacterBG.alpha = 0.001;
            _loc1_ = localToGlobal(new Point(mBox.x));
            _loc2_ = localToGlobal(new Point(mBox.y));
            this.mCharacterBG.x = Starling.current.stage.stageWidth - this.mCharacterBG.width - _loc1_.x;
            this.mCharacterBG.y = Starling.current.stage.stageHeight - this.mCharacterBG.height - _loc2_.y;
            addChild(this.mCharacterBG);
            SpecialFX.tweenToAlpha(this.mCharacterBG,0.999,2,0);
         }
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
            this.mTextPanelTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mTextPanelTextfield.x = (this.mTextPanelImg.width - this.mTextPanelTextfield.width) / 2 + 3;
            this.mTextPanelTextfield.y = 5;
            this.mTextPanelContainer.addChild(this.mTextPanelTextfield);
         }
         this.mTextPanelTextfield.text = this.mTutorialDef.getDesc().toUpperCase();
         this.mTextPanelContainer.x = (mBox.width - this.mTextPanelContainer.width) / 2;
         this.mTextPanelContainer.y = mBox.height;
         if(!contains(this.mTextPanelContainer))
         {
            addChild(this.mTextPanelContainer);
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
               this.mAnimMC = new MovieClip(Root.assets.getTextures(_loc1_),this.mTutorialDef.getFPS());
               this.mAnimMC.touchable = false;
               this.mAnimMC.alpha = 0.001;
               this.mAnimMC.stop();
               this.mAnimMC.x = this.mTutorialDef.getAnimPosX() / 100 * mBox.width;
               this.mAnimMC.y = this.mTutorialDef.getAnimPosY() / 100 * mBox.height;
               Starling.juggler.add(this.mAnimMC);
               addChild(this.mAnimMC);
               SpecialFX.tweenToAlpha(this.mAnimMC,0.999,2,0,this.playMC);
            }
         }
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
      
      override protected function addButtonsEventListeners() : void
      {
         super.addButtonsEventListeners();
         if(this.mNextButton)
         {
            this.mNextButton.addEventListener(Event.TRIGGERED,this.onNext);
         }
         if(this.mPrevButton)
         {
            this.mPrevButton.addEventListener(Event.TRIGGERED,this.onPrev);
         }
      }
      
      override protected function removeButtonsEventListeners() : void
      {
         super.removeButtonsEventListeners();
         if(this.mNextButton)
         {
            this.mNextButton.removeEventListener(Event.TRIGGERED,this.onNext);
         }
         if(this.mPrevButton)
         {
            this.mPrevButton.removeEventListener(Event.TRIGGERED,this.onPrev);
         }
      }
      
      private function onNext(param1:Event) : void
      {
         if(this.mCurrentSlideIndex < this.mMaxImagesIndex)
         {
            this.enableArrowButtons(false);
            this.unloadLastTutorialIndexResources();
            InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
            ++this.mCurrentSlideIndex;
            this.loadCurrentTutorialIndexResources();
         }
      }
      
      private function onPrev(param1:Event) : void
      {
         if(this.mCurrentSlideIndex > 1)
         {
            this.enableArrowButtons(false);
            this.unloadLastTutorialIndexResources();
            --this.mCurrentSlideIndex;
            this.loadCurrentTutorialIndexResources();
         }
      }
      
      protected function setupArrowButtons() : void
      {
         var _loc1_:Boolean = Utils.isIphone();
         if(this.mNextButton == null)
         {
            this.mNextButton = new FSButton(Root.assets.getTexture(Constants.NEXT_BUTTON_NAME));
            this.mNextButton.visible = false;
         }
         if(this.mPrevButton == null)
         {
            this.mPrevButton = new FSButton(Root.assets.getTexture(Constants.PREV_BUTTON_NAME));
            this.mPrevButton.visible = false;
         }
         this.resetButtonsPos();
      }
      
      private function resetButtonsPos() : void
      {
         if(mCloseButton)
         {
            mCloseButton.x = mBox.width - mCloseButton.width / 2;
            mCloseButton.y = mCloseButton.height / 2;
         }
         var _loc1_:Boolean = Utils.isIphone();
         if(this.mNextButton)
         {
            this.mNextButton.x = _loc1_ ? mBox.width - this.mNextButton.width / 2 : mBox.width * 0.9;
            this.mNextButton.y = mBox.height;
            addChild(this.mNextButton);
            this.mNextButton.visible = true;
         }
         if(this.mPrevButton)
         {
            this.mPrevButton.x = _loc1_ ? this.mPrevButton.width / 2 : mBox.width * 0.1;
            this.mPrevButton.y = mBox.height;
            addChild(this.mPrevButton);
            this.mPrevButton.visible = true;
         }
      }
      
      private function checkArrowButtonsState() : void
      {
         if(this.mPrevButton)
         {
            this.mPrevButton.enabled = this.mCurrentSlideIndex > 1;
         }
         if(this.mNextButton)
         {
            this.mNextButton.enabled = this.mCurrentSlideIndex < this.mMaxImagesIndex;
         }
      }
      
      private function enableArrowButtons(param1:Boolean) : void
      {
         if(this.mPrevButton)
         {
            this.mPrevButton.enabled = param1 ? this.mCurrentSlideIndex > 1 : param1;
         }
         if(this.mNextButton)
         {
            this.mNextButton.enabled = param1 ? this.mCurrentSlideIndex < this.mMaxImagesIndex : param1;
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         if(!mClosed)
         {
            this.setupArrowButtons();
            this.createCharacter();
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function performOnOpenDefaultOps(param1:FSCoordinate, param2:Number = 0.6) : void
      {
         super.performOnOpenDefaultOps(param1,0.85);
      }
   }
}

