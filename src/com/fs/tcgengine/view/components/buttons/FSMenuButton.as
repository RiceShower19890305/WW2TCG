package com.fs.tcgengine.view.components.buttons
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class FSMenuButton extends Component
   {
      
      private var mTextfield:FSTextfield;
      
      private var mButton:FSButton;
      
      private var mUpTexture:Texture;
      
      private var mText:String;
      
      private var mOnTriggeredFunction:Function;
      
      private var mExtraLeftImage:FSImage;
      
      private var mNotificationIcon:FSImage;
      
      public function FSMenuButton(param1:String, param2:String, param3:Function, param4:String = null)
      {
         super();
         this.mUpTexture = Root.assets.getTexture(param1);
         this.mText = param2;
         this.mOnTriggeredFunction = param3;
         this.mExtraLeftImage = param4 ? new FSImage(Root.assets.getTexture(param4)) : null;
         this.init();
         this.addEventListeners();
      }
      
      private function init() : void
      {
         this.createButton();
         this.createTextfield();
         this.createExtraLeftImage();
         pivotX = width / 2;
         pivotY = height / 2;
      }
      
      private function createExtraLeftImage() : void
      {
         if(this.mExtraLeftImage != null)
         {
            this.mExtraLeftImage.touchable = false;
            this.mExtraLeftImage.alignPivot();
            this.mExtraLeftImage.x = this.mExtraLeftImage.width / 2;
            this.mExtraLeftImage.y = height / 2;
            addChild(this.mExtraLeftImage);
         }
      }
      
      public function changeExtraLeftImageTexture(param1:Texture) : void
      {
         if(this.mExtraLeftImage != null)
         {
            this.mExtraLeftImage.texture = param1;
            this.mTextfield.x = this.mExtraLeftImage != null ? this.mButton.x + this.mExtraLeftImage.width / 2 : this.mButton.x;
         }
      }
      
      public function removeExtraLeftImage() : void
      {
         if(this.mExtraLeftImage)
         {
            this.mExtraLeftImage.removeFromParent();
            this.mExtraLeftImage.destroy();
            this.mExtraLeftImage = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.x = this.mExtraLeftImage != null ? this.mButton.x + this.mExtraLeftImage.width / 2 : this.mButton.x;
         }
      }
      
      public function updatePositions() : void
      {
         if(this.mExtraLeftImage)
         {
            this.mExtraLeftImage.x = this.mButton.x - this.mButton.width / 2 + this.mExtraLeftImage.width / 2;
         }
         this.createTextfield();
      }
      
      public function getExtraLeftImage() : FSImage
      {
         return this.mExtraLeftImage;
      }
      
      public function switchBGTexture(param1:Texture) : void
      {
         if(this.mButton)
         {
            this.mButton.upState = param1;
         }
      }
      
      public function setLeftImageAlpha(param1:Number) : void
      {
         if(this.mExtraLeftImage)
         {
            this.mExtraLeftImage.alpha = param1;
         }
      }
      
      private function createButton() : void
      {
         if(this.mButton == null)
         {
            this.mButton = new FSButton(this.mUpTexture,"",null,true);
            this.mButton.addEventListener(Event.TRIGGERED,this.mOnTriggeredFunction);
            this.mButton.x = this.mButton.width / 2;
            this.mButton.y = this.mButton.height / 2;
            addChild(this.mButton);
         }
      }
      
      private function createTextfield() : void
      {
         var _loc1_:int = 0;
         if(this.mTextfield == null)
         {
            _loc1_ = this.mExtraLeftImage != null ? int(this.mButton.width - (this.mExtraLeftImage.x + this.mExtraLeftImage.width)) : int(this.mButton.width);
            this.mTextfield = new FSTextfield(_loc1_,this.mButton.height / 1.8,this.mText,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mTextfield.color = 16777215;
            this.mTextfield.fontName = FSResourceMng.getFontByType();
            this.mTextfield.alignPivot();
            this.mTextfield.x = this.mExtraLeftImage != null ? this.mButton.x + this.mExtraLeftImage.width / 2.5 : this.mButton.x;
            this.mTextfield.y = this.mButton.y;
            this.mTextfield.touchable = false;
            addChild(this.mTextfield);
         }
         else
         {
            _loc1_ = this.mExtraLeftImage != null ? int(this.mButton.width * 0.9 - this.mExtraLeftImage.width) : int(this.mButton.width);
            this.mTextfield.width = _loc1_;
            this.mTextfield.height = this.mButton.height / 1.8;
            this.mTextfield.alignPivot();
            this.mTextfield.x = this.mExtraLeftImage != null ? this.mExtraLeftImage.x + this.mTextfield.width / 2 + this.mExtraLeftImage.width / 2 : this.mButton.x;
            this.mTextfield.y = this.mButton.y;
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(this.mButton)
         {
            this.mButton.enabled = param1;
         }
         if(this.mTextfield)
         {
            this.mTextfield.alpha = param1 ? 1 : 0.5;
         }
         if(this.mExtraLeftImage != null)
         {
            this.mExtraLeftImage.alpha = param1 ? 1 : 0.5;
         }
      }
      
      public function isEnabled() : Boolean
      {
         return Boolean(this.mButton) && this.mButton.enabled;
      }
      
      public function setFontProperties(param1:String = "", param2:int = 0, param3:uint = 16777215) : void
      {
         if(this.mTextfield != null)
         {
            if(param1 != "")
            {
               this.mTextfield.fontName = param1;
            }
            if(param2 != 0)
            {
               this.mTextfield.fontSize = param2;
            }
            this.mTextfield.color = param3;
         }
      }
      
      public function setFontColor(param1:uint) : void
      {
         if(this.mTextfield != null)
         {
            this.mTextfield.color = param1;
         }
      }
      
      public function updateText(param1:String) : void
      {
         if(this.mTextfield != null)
         {
            this.mText = param1;
            this.mTextfield.text = this.mText;
         }
      }
      
      public function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(this.mButton.enabled)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
            scale = _loc2_ ? 1.04 : 1;
         }
      }
      
      public function updateUpTexture(param1:Texture) : void
      {
         if(this.mUpTexture)
         {
            this.mUpTexture = param1;
         }
         if(this.mButton)
         {
            this.mButton.upState = this.mUpTexture;
            this.mButton.readjustSize();
         }
      }
      
      public function startLeftTextureRotation() : void
      {
         var _loc1_:Array = null;
         if(this.mExtraLeftImage != null)
         {
            _loc1_ = TweenMax.getTweensOf(this.mExtraLeftImage);
            if(_loc1_ == null || Boolean(_loc1_) && Boolean(_loc1_.length == 0))
            {
               SpecialFX.tweenRotate(this.mExtraLeftImage,5);
            }
         }
      }
      
      public function stopLeftTextureRotation() : void
      {
         if(this.mExtraLeftImage)
         {
            TweenMax.killTweensOf(this.mExtraLeftImage);
            this.mExtraLeftImage.rotation = 0;
         }
      }
      
      public function getButton() : FSButton
      {
         return this.mButton;
      }
      
      public function unload() : void
      {
         if(this.mExtraLeftImage)
         {
            TweenMax.killTweensOf(this.mExtraLeftImage);
         }
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mButton)
         {
            this.mButton.removeFromParent(true);
            this.mButton = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent(true);
            this.mNotificationIcon = null;
         }
         this.mOnTriggeredFunction = null;
         if(this.mExtraLeftImage)
         {
            this.mExtraLeftImage.removeFromParent(true);
            this.mExtraLeftImage = null;
         }
         if(this.mUpTexture)
         {
            this.mUpTexture.dispose();
            this.mUpTexture = null;
         }
         this.unload();
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function disableTemporarily(param1:int = 2) : void
      {
         this.setEnabled(false);
         TweenMax.delayedCall(param1,this.setEnabled,[true]);
      }
      
      public function showDeckNotificationIcon() : void
      {
         if(this.mNotificationIcon == null)
         {
            if(this.mButton)
            {
               this.mNotificationIcon = new FSImage(Root.assets.getTexture("claim_warning"));
               this.mNotificationIcon.alignPivot();
               this.mNotificationIcon.x = this.mButton.x + this.mButton.width * 0.4;
               this.mNotificationIcon.y = this.mButton.y - this.mButton.height * 0.3;
               addChild(this.mNotificationIcon);
            }
         }
      }
   }
}

