package com.fs.tcgengine.view.components.popups.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import feathers.controls.ScrollContainer;
   import feathers.controls.Slider;
   import feathers.controls.supportClasses.LayoutViewPort;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class SettingBlock extends Component
   {
      
      public static const BG_NAME:String = "settings_panel";
      
      public static const BG_RED_NAME:String = "settings_panel_red";
      
      private var mBG:CustomComponent;
      
      private var mTextfield:FSTextfield;
      
      private var mIconImage:FSImage;
      
      private var mTitle:String;
      
      private var mTextureName:String;
      
      private var mOnClickFunction:Function;
      
      private var mEnabled:Boolean = true;
      
      private var mBGName:String;
      
      private var mHasSlider:Boolean;
      
      private var mSlider:Slider;
      
      private var mSliderMin:int;
      
      private var mSliderMax:int;
      
      private var mSliderCurrValue:int;
      
      private var mOnSlideChangeFunction:Function;
      
      public function SettingBlock(param1:String, param2:String, param3:Function, param4:String = "settings_panel", param5:Boolean = false, param6:int = 0, param7:int = 1, param8:int = 1, param9:Function = null)
      {
         this.mTitle = param1;
         this.mTextureName = param2;
         this.mOnClickFunction = param3;
         this.mBGName = param4;
         this.mHasSlider = param5;
         this.mSliderMin = param6;
         this.mSliderMax = param7;
         this.mSliderCurrValue = param8;
         this.mOnSlideChangeFunction = param9;
         super();
         this.createUI();
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         Utils.alignComponentAndFixPosition(this);
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createImage();
         this.createTextfield();
         this.createSlider();
      }
      
      private function createSlider() : void
      {
         var onSliderChange:Function = null;
         if(this.mHasSlider)
         {
            onSliderChange = function(param1:Event):void
            {
               FSDebug.debugTrace("slider.value changed:" + mSlider.value);
               if(mOnSlideChangeFunction != null)
               {
                  mOnSlideChangeFunction(mSlider.value);
               }
            };
            if(this.mSlider == null)
            {
               this.mSlider = new Slider();
               this.mSlider.width = !Utils.isIOS() ? this.mTextfield.width * 2 : this.mTextfield.width;
               this.mSlider.height = this.mTextfield.height / 2;
               this.mSlider.scale = !Utils.isIOS() ? 0.5 : 1;
               this.mSlider.validate();
               this.mSlider.minimum = this.mSliderMin;
               this.mSlider.maximum = this.mSliderMax;
               this.mSlider.value = this.mSliderCurrValue;
               this.mSlider.step = 0.1;
               this.mSlider.x = this.mTextfield.x;
               this.mSlider.y = this.mTextfield.y + this.mTextfield.height;
               this.mSlider.addEventListener(Event.CHANGE,onSliderChange);
               addChild(this.mSlider);
            }
         }
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox(this.mBGName,861);
            addChild(this.mBG);
         }
      }
      
      private function createImage() : void
      {
         if(this.mIconImage == null)
         {
            this.mIconImage = new FSImage(Root.assets.getTexture(this.mTextureName));
            this.mIconImage.x = this.mBG.width * 0.1;
            this.mIconImage.y = (this.mBG.height - this.mIconImage.height) / 2;
            addChild(this.mIconImage);
         }
      }
      
      public function switchIconImage(param1:String) : void
      {
         if(this.mIconImage)
         {
            this.mIconImage.texture = Root.assets.getTexture(param1);
            this.mIconImage.readjustSize();
            this.mIconImage.x = this.mBG.width * 0.1;
            this.mIconImage.y = (this.mBG.height - this.mIconImage.height) / 2;
         }
      }
      
      public function switchName(param1:String) : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.text = param1;
         }
      }
      
      public function updateSliderCurrValue(param1:Number) : void
      {
         if(this.mSlider)
         {
            this.mSlider.value = param1;
         }
      }
      
      private function createTextfield() : void
      {
         var _loc1_:int = 0;
         if(this.mTextfield == null)
         {
            this.mTextfield = new FSTextfield(this.mBG.width * 0.6,this.mBG.height * 0.9,this.mTitle,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mTextfield.format.horizontalAlign = Align.CENTER;
            this.mTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mTextfield.x = this.mIconImage.x + this.mIconImage.width + 15;
            this.mTextfield.y = (this.mBG.height - this.mTextfield.height) / 2;
            _loc1_ = this.mHasSlider ? int(this.mBG.height * 0.9 / 1.65) : int(this.mBG.height * 0.9);
            this.mTextfield.height = _loc1_;
            addChild(this.mTextfield);
         }
      }
      
      public function updateTitle(param1:String) : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.text = param1;
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
         if(Boolean(_loc2_) && this.mEnabled)
         {
            if(parent != null && parent is LayoutViewPort && parent.parent is ScrollContainer && ScrollContainer(parent.parent).isScrolling)
            {
               return;
            }
            if(this.mOnClickFunction != null && !this.mHasSlider)
            {
               this.mOnClickFunction();
            }
         }
         if(this.mEnabled)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
            if(Utils.isDesktop() || Utils.isBrowser())
            {
               scale = _loc2_ ? 1.02 : 1;
            }
            else
            {
               alpha = _loc2_ ? 0.8 : 1;
            }
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.mEnabled = param1;
         if(this.mBG)
         {
            this.mBG.alpha = param1 ? 1 : 0.5;
         }
         if(this.mTextfield)
         {
            this.mTextfield.alpha = param1 ? 1 : 0.5;
         }
         if(this.mIconImage)
         {
            this.mIconImage.alpha = param1 ? 1 : 0.5;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mIconImage)
         {
            this.mIconImage.removeFromParent(true);
            this.mIconImage = null;
         }
         if(this.mSlider)
         {
            this.mSlider.removeFromParent(true);
            this.mSlider = null;
         }
         this.mOnClickFunction = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

