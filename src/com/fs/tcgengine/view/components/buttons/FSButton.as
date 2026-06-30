package com.fs.tcgengine.view.components.buttons
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSLoadingComponentMini;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import feathers.controls.Callout;
   import mx.utils.StringUtil;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSButton extends Button implements FSModelUnloadableInterface
   {
      
      private const PADDING_AMOUNT_X:Number = 0.8;
      
      private const PADDING_AMOUNT_Y:Number = 0.75;
      
      private var mTooltip:Callout;
      
      private var mTooltipText:String;
      
      private var mLoadingIcon:FSLoadingComponentMini;
      
      private var mScaleOnMouseOver:Boolean = true;
      
      private var mNotificationIcon:FSImage;
      
      private var mDefaultScale:Number;
      
      private var mDefaultHoverScale:Number;
      
      public function FSButton(param1:Texture, param2:String = "", param3:Texture = null, param4:Boolean = false, param5:Texture = null, param6:Texture = null, param7:Number = 1, param8:Number = 1.04, param9:Number = -1, param10:Number = -1)
      {
         param2 = param2 != null ? param2 : "";
         this.mDefaultScale = param7;
         this.mDefaultHoverScale = param8;
         super(param1,param2,param3,param5,param6);
         this.init(param9,param10);
      }
      
      protected function init(param1:Number = -1, param2:Number = -1) : void
      {
         if(this.getTextfield())
         {
            this.getTextfield().border = Config.smTextfieldsBorder;
         }
         this.fontColor = 16777215;
         this.fontName = FSResourceMng.getFontByType();
         this.fontSize = Utils.isDesktop() ? 12 : 16;
         pivotX = width / 2;
         pivotY = height / 2;
         var _loc3_:Number = param1 != -1 ? param1 : this.PADDING_AMOUNT_X;
         var _loc4_:Number = param2 != -1 ? param2 : this.PADDING_AMOUNT_Y;
         _textBounds.width = width * _loc3_;
         _textBounds.height = height * _loc4_;
         _textBounds.x = (width - _textBounds.width) / 2;
         _textBounds.y = (height - _textBounds.height) / 2;
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         addEventListener(Event.TRIGGERED,this.onButtonTriggered);
         this.readjustSize();
      }
      
      public function applyTextBoundsOffsetY(param1:Number) : void
      {
         _textBounds.y += param1;
      }
      
      public function disableTriggeredEvent() : void
      {
         removeEventListener(Event.TRIGGERED,this.onButtonTriggered);
      }
      
      public function enableScaleOnMouseOver(param1:Boolean) : void
      {
         this.mScaleOnMouseOver = param1;
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(enabled)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
            if(this.mScaleOnMouseOver)
            {
               scaleX = _loc2_ ? this.mDefaultHoverScale : this.mDefaultScale;
               scaleY = _loc2_ ? this.mDefaultHoverScale : this.mDefaultScale;
            }
            _loc2_ = param1.getTouch(this);
            if(Utils.isBrowser() || Utils.isDesktop())
            {
               if(_loc2_)
               {
                  this.showTooltip();
               }
               else
               {
                  this.closeTooltip();
               }
            }
         }
      }
      
      private function onButtonTriggered(param1:Event) : void
      {
         Utils.playSound(Constants.SOUND_CLICK,SoundManager.TYPE_SFX);
         if(Utils.isMobile())
         {
            this.showTooltip();
         }
      }
      
      public function showLoadingIcon(param1:Boolean, param2:Boolean = false, param3:String = "center", param4:String = "center", param5:Number = 100) : void
      {
         var _loc6_:Number = NaN;
         if(param1)
         {
            if(this.mLoadingIcon == null)
            {
               this.mLoadingIcon = new FSLoadingComponentMini(param2);
            }
            this.mLoadingIcon.scaleX = param5 / 100;
            this.mLoadingIcon.scaleY = param5 / 100;
            _loc6_ = 0.5;
            switch(param3)
            {
               case Align.LEFT:
                  this.mLoadingIcon.x = this.mLoadingIcon.width / 2 + this.mLoadingIcon.width * _loc6_;
                  break;
               case Align.CENTER:
                  this.mLoadingIcon.x = width / 2;
                  break;
               case Align.RIGHT:
                  this.mLoadingIcon.x = width - this.mLoadingIcon.width / 2 - this.mLoadingIcon.width * _loc6_;
            }
            switch(param4)
            {
               case Align.TOP:
                  this.mLoadingIcon.y = this.mLoadingIcon.height / 2 + this.mLoadingIcon.height * _loc6_;
                  break;
               case Align.CENTER:
                  this.mLoadingIcon.y = height / 2;
                  break;
               case Align.BOTTOM:
                  this.mLoadingIcon.y = height - this.mLoadingIcon.height / 2 - this.mLoadingIcon.height * _loc6_;
            }
            addChild(this.mLoadingIcon);
         }
         else if(this.mLoadingIcon != null)
         {
            this.mLoadingIcon.removeFromParent();
            this.mLoadingIcon = null;
         }
      }
      
      public function setTooltipText(param1:String) : void
      {
         this.mTooltipText = param1 != null && param1 != "" ? StringUtil.trim(param1) : "";
      }
      
      private function showTooltip() : void
      {
         if(this.mTooltip == null && this.mTooltipText != null && this.mTooltipText != "")
         {
            if(stage == null)
            {
               return;
            }
            this.mTooltip = Callout.show(Utils.getTooltipContent(this.mTooltipText),this,null,false);
            this.mTooltip.closeOnTouchEndedOutside = true;
            this.mTooltip.closeOnTouchBeganOutside = true;
            this.mTooltip.disposeContent = false;
            this.mTooltip.maxWidth = Starling.current.stage.stageWidth / 3;
            this.mTooltip.touchable = false;
            this.mTooltip.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mTooltip,0.999,0.25,0);
         }
         else if(Utils.isMobile())
         {
            if(Boolean(this.mTooltip) && this.mTooltip.parent == null)
            {
               this.removeTooltip();
               this.showTooltip();
            }
         }
      }
      
      public function closeTooltip() : void
      {
         if(this.mTooltip)
         {
            SpecialFX.tweenToAlpha(this.mTooltip,0.001,0.25,0,this.removeTooltip);
         }
      }
      
      private function removeTooltip() : void
      {
         if(this.mTooltip)
         {
            this.mTooltip.close();
            this.mTooltip.removeFromParent(true);
            this.mTooltip = null;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mLoadingIcon)
         {
            this.mLoadingIcon.removeFromParent();
            this.mLoadingIcon = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent(true);
            this.mNotificationIcon = null;
         }
         this.removeTooltip();
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         removeEventListener(Event.TRIGGERED,this.onButtonTriggered);
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mLoadingIcon)
         {
            this.mLoadingIcon.removeFromParent();
            this.mLoadingIcon = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon = null;
         }
         this.removeTooltip();
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         removeEventListener(Event.TRIGGERED,this.onButtonTriggered);
      }
      
      public function getTextfield() : TextField
      {
         return _textField;
      }
      
      public function disableTemporarily(param1:int = 2) : void
      {
         this.setEnabled(false);
         TweenMax.delayedCall(param1,this.setEnabled,[true]);
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         enabled = param1;
      }
      
      public function showNotificationIcon() : void
      {
         if(this.mNotificationIcon == null)
         {
            this.mNotificationIcon = new FSImage(Root.assets.getTexture("claim_warning"));
            this.mNotificationIcon.alignPivot();
            this.mNotificationIcon.x = width * 0.9;
            this.mNotificationIcon.y = height * 0.25;
            _contents.addChild(this.mNotificationIcon);
         }
      }
      
      public function hideNotificationIcon() : void
      {
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon.destroy();
            this.mNotificationIcon = null;
         }
      }
      
      override public function set text(param1:String) : void
      {
         if(param1 != null)
         {
            super.text = param1;
         }
         Utils.refreshTextfieldIfTextHasGlyphs(_textField,text,textFormat.font);
      }
      
      public function set fontName(param1:String) : void
      {
         textFormat.font = param1;
         Utils.refreshTextfieldIfTextHasGlyphs(this._textField,text,param1);
      }
      
      public function set fontSize(param1:Number) : void
      {
         textFormat.size = param1;
      }
      
      public function set fontColor(param1:uint) : void
      {
         textFormat.color = param1;
      }
      
      public function set bold(param1:Boolean) : void
      {
         textFormat.bold = param1;
      }
      
      public function get fontName() : String
      {
         return textFormat.font;
      }
      
      public function get fontSize() : Number
      {
         return textFormat.size;
      }
      
      public function get fontColor() : uint
      {
         return textFormat.color;
      }
      
      override public function readjustSize() : void
      {
         super.readjustSize();
         Utils.refreshTextfieldIfTextHasGlyphs(_textField,text,textFormat.font);
      }
   }
}

