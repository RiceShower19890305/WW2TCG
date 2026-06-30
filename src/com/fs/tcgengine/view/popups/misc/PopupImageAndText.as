package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TutorialMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.core.Starling;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class PopupImageAndText extends PopupStandard
   {
      
      private var mTextPanelContainer:Component;
      
      private var mTextPanelImg:CustomComponent;
      
      private var mTextPanelTextfield:FSTextfield;
      
      private var mImageName:String = "";
      
      public function PopupImageAndText(param1:Boolean = true)
      {
         super(false);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         if(param1.getTouch(this,TouchPhase.ENDED))
         {
            closePopup();
         }
      }
      
      override protected function performOnOpenDefaultOps(param1:FSCoordinate, param2:Number = 0.6) : void
      {
         super.performOnOpenDefaultOps(param1,0.85);
      }
      
      override protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         y = Starling.current.stage.stageHeight / 2 - mBox.height / 2 - this.mTextPanelImg.height / 2;
         super.performOpeningTransition(param1);
      }
      
      override protected function removeFromStage() : void
      {
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
         InstanceMng.getPopupMng().removePopup(FSPopupMng.IMAGE_AND_TEXT_POPUP_NAME);
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.removeFromStage();
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(mText == "" || mText == null)
         {
            return;
         }
         super.setResourcesToLoad();
      }
      
      override protected function createUI() : void
      {
         if(mBGName == "")
         {
            return;
         }
         super.createUI();
         var _loc1_:Texture = Root.assets.getTexture(mBGName);
         if(Boolean(mBox) && Boolean(_loc1_))
         {
            updateBGTexture(mBGName);
            mBox.width = _loc1_.frameWidth;
            mBox.height = _loc1_.frameHeight;
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
            this.mTextPanelTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mTextPanelTextfield.x = (this.mTextPanelImg.width - this.mTextPanelTextfield.width) / 2 + 3;
            this.mTextPanelTextfield.y = (this.mTextPanelImg.height - this.mTextPanelTextfield.height) / 2;
            this.mTextPanelContainer.addChild(this.mTextPanelTextfield);
         }
         this.mTextPanelContainer.x = (mBox.width - this.mTextPanelContainer.width) / 2;
         this.mTextPanelContainer.y = mBox.height;
         this.mTextPanelContainer.visible = false;
         addChildAt(this.mTextPanelContainer,0);
      }
      
      private function startTextAnimation() : void
      {
         var _loc1_:FSCoordinate = null;
         if(this.mTextPanelImg != null && Boolean(this.mTextPanelContainer))
         {
            this.mTextPanelContainer.y -= this.mTextPanelContainer.height;
            this.mTextPanelContainer.visible = true;
            _loc1_ = new FSCoordinate(this.mTextPanelContainer.x,this.mTextPanelContainer.y + this.mTextPanelContainer.height);
            this.mTextPanelTextfield.text = mText;
            SpecialFX.createTransition(this.mTextPanelContainer,_loc1_,1,0);
            Utils.playSound(Constants.SOUND_PANEL_DOWN,SoundManager.TYPE_SFX);
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      public function setup(param1:String, param2:String) : void
      {
         mText = param1;
         mBGName = param2;
         this.setResourcesToLoad();
         if(mText != "" && mText != null)
         {
            this.startTextAnimation();
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return true;
      }
   }
}

