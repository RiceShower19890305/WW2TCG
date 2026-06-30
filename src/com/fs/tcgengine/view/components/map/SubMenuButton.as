package com.fs.tcgengine.view.components.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class SubMenuButton extends Component
   {
      
      protected var mButton:FSButton;
      
      protected var mTextfield:FSTextfield;
      
      private var mText:String;
      
      private var mButtonTextureName:String;
      
      private var mButtonTextureDisabledName:String;
      
      private var mButtonOnTriggeredFunction:Function;
      
      private var mEnabled:Boolean = true;
      
      protected var mNotificationIcon:FSImage;
      
      private var mTextVAlign:String;
      
      public function SubMenuButton(param1:String, param2:String, param3:Function, param4:String, param5:String = "bottom")
      {
         super();
         this.mButtonTextureName = param1;
         this.mButtonTextureDisabledName = param2;
         this.mButtonOnTriggeredFunction = param3;
         this.mText = param4;
         this.mTextVAlign = param5;
         this.createUI();
         touchable = true;
      }
      
      public function getButtonTextureName() : String
      {
         return this.mButtonTextureName;
      }
      
      public function getButtonText() : String
      {
         return this.mText;
      }
      
      public function updateButtonTexture(param1:String) : void
      {
         this.mButtonTextureName = param1;
         this.mButtonTextureDisabledName = param1;
         this.refreshButtonTextures();
      }
      
      public function refreshButtonTextures() : void
      {
         var _loc1_:Texture = null;
         if(this.mButton)
         {
            _loc1_ = this.mEnabled ? Root.assets.getTexture(this.mButtonTextureName) : Root.assets.getTexture(this.mButtonTextureDisabledName);
            if(_loc1_)
            {
               this.mButton.upState = _loc1_;
               this.mButton.downState = _loc1_;
               this.mButton.disabledState = _loc1_;
               this.mButton.overState = _loc1_;
            }
         }
      }
      
      protected function createUI() : void
      {
         if(this.mButton == null)
         {
            this.mButton = new FSButton(Root.assets.getTexture(this.mButtonTextureName));
            if(this.mButtonOnTriggeredFunction != null)
            {
               this.mButton.addEventListener(Event.TRIGGERED,this.mButtonOnTriggeredFunction);
            }
            this.mButton.x += this.mButton.width / 2;
            this.mButton.y += this.mButton.height / 2;
            addChild(this.mButton);
         }
         this.updateText(this.mText);
         this.refreshButtonTextures();
      }
      
      public function updateOnTriggeredFunction(param1:Function = null) : void
      {
         this.mButtonOnTriggeredFunction = param1;
         if(this.mButtonOnTriggeredFunction != null)
         {
            this.mButton.addEventListener(Event.TRIGGERED,this.mButtonOnTriggeredFunction);
         }
      }
      
      public function updateText(param1:String) : void
      {
         var _loc2_:int = 0;
         this.mText = param1;
         if(this.mText != "")
         {
            _loc2_ = this.mTextVAlign == Align.BOTTOM ? int(this.mButton.height / 2) : int(this.mButton.height * 0.85);
            if(this.mTextfield == null)
            {
               this.mTextfield = new FSTextfield(this.mButton.width,_loc2_,this.mText,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               this.mTextfield.touchable = false;
               this.mTextfield.alignPivot();
               this.mTextfield.x = this.mButton.x;
               this.mTextfield.y = this.mTextVAlign == Align.BOTTOM ? this.mButton.y + _loc2_ * 1.4 : this.mButton.y;
               addChild(this.mTextfield);
            }
            else
            {
               this.mTextfield.height = _loc2_;
               this.mTextfield.text = this.mText;
               this.mTextfield.y = this.mTextVAlign == Align.BOTTOM ? this.mButton.y + _loc2_ * 1.4 : this.mButton.y;
            }
         }
      }
      
      public function set fontName(param1:String) : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.fontName = param1;
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.mEnabled = param1;
         this.refreshButtonTextures();
      }
      
      public function isEnabled() : Boolean
      {
         return this.mEnabled;
      }
      
      public function showNotificationIcon(param1:Boolean) : void
      {
         if(this.mNotificationIcon == null)
         {
            this.mNotificationIcon = new FSImage(Root.assets.getTexture(MapSubmenu.NOTIFICATION_NAME));
            this.mNotificationIcon.touchable = false;
            this.mNotificationIcon.alignPivot();
            this.mNotificationIcon.x = this.mButton.x + this.mButton.width / 2 - this.mNotificationIcon.width / 1.85;
            this.mNotificationIcon.y = this.mButton.y - this.mButton.height / 2 + this.mNotificationIcon.height / 3;
            this.mNotificationIcon.scale = 0.75;
            addChild(this.mNotificationIcon);
            SpecialFX.createYoYoZoomTransition(this.mNotificationIcon,1,1,-1,null,null,false);
         }
         this.mNotificationIcon.visible = param1;
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).checkSubMenuNotificationIcon();
         }
      }
      
      public function hasNotification() : Boolean
      {
         return Boolean(this.mNotificationIcon) && this.mNotificationIcon.visible;
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
      
      override public function dispose() : void
      {
         if(this.mButton)
         {
            this.mButton.removeFromParent(true);
            this.mButton = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent(true);
            this.mNotificationIcon = null;
         }
         this.mButtonOnTriggeredFunction = null;
         super.dispose();
      }
   }
}

