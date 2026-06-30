package com.fs.tcgengine.view.components.buttons
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class FSToggleButton extends Component
   {
      
      protected var mButton:FSButton;
      
      protected var mUpTexture:Texture;
      
      protected var mUpTextureName:String;
      
      protected var mDownTexture:Texture;
      
      protected var mDownTextureName:String;
      
      protected var mToggled:Boolean;
      
      private var mEnabled:Boolean = true;
      
      private var mNotificationIcon:FSImage;
      
      public function FSToggleButton(param1:String, param2:String, param3:String = "")
      {
         super();
         this.mToggled = true;
         this.init(param1,param2,param3);
      }
      
      protected function init(param1:String, param2:String, param3:String = "") : void
      {
         this.mUpTextureName = param1;
         this.mDownTextureName = param2;
         if(this.mUpTexture == null)
         {
            this.mUpTexture = Root.assets.getTexture(param1);
         }
         if(this.mDownTexture == null)
         {
            this.mDownTexture = Root.assets.getTexture(param2);
         }
         if(this.mButton == null)
         {
            this.mButton = new FSButton(this.mUpTexture,param3,this.mDownTexture);
            this.mButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.setButtonPos();
            addChild(this.mButton);
         }
         this.addEventListeners();
         this.updateState();
      }
      
      public function updateText(param1:String) : void
      {
         if(Boolean(this.mButton) && Boolean(param1))
         {
            this.mButton.text = param1;
         }
      }
      
      protected function setButtonPos() : void
      {
         this.mButton.x = this.mButton.width / 2;
         this.mButton.y = this.mButton.height / 2;
      }
      
      protected function updateState() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.mToggled)
         {
            this.mButton.upState = this.mDownTexture;
            this.mButton.downState = this.mUpTexture;
            this.mButton.overState = this.mDownTexture;
            this.mButton.disabledState = this.mDownTexture;
         }
         else
         {
            this.mButton.upState = this.mUpTexture;
            this.mButton.downState = this.mDownTexture;
            this.mButton.overState = this.mUpTexture;
            this.mButton.disabledState = this.mUpTexture;
         }
         var _loc7_:Boolean = true;
         switch(this.mUpTextureName)
         {
            case "db_button_craft_available_on":
            case "db_button_craft_available_off":
               _loc1_ = 8.75;
               _loc2_ = 10;
               _loc3_ = 6.25;
               _loc4_ = 7.5;
               _loc5_ = 120.75;
               _loc6_ = 42;
               break;
            case FSDeckBuilderScreen.VIEW_ALL_CARDS_FILTER_ON_NAME:
            case FSDeckBuilderScreen.VIEW_ALL_CARDS_FILTER_OFF_NAME:
               _loc1_ = 17.5;
               _loc2_ = 13.5;
               _loc3_ = 6;
               _loc4_ = 16;
               _loc5_ = 59.75;
               _loc6_ = 31.75;
               break;
            default:
               _loc7_ = false;
         }
         if(_loc7_)
         {
            Utils.setupButton9Scale(this.mButton,_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
            this.setButtonPos();
         }
         else
         {
            this.mButton.readjustSize();
         }
      }
      
      public function setFontSize(param1:Number) : void
      {
         if(this.mButton)
         {
            this.mButton.fontSize = param1;
         }
      }
      
      private function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
         if(Boolean(_loc2_) && this.mEnabled)
         {
            this.setToggled();
         }
      }
      
      public function isEnabled() : Boolean
      {
         return this.mEnabled;
      }
      
      public function isToggled() : Boolean
      {
         return this.mToggled;
      }
      
      public function setToggled() : void
      {
         this.mToggled = !this.mToggled;
         this.updateState();
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.mEnabled = param1;
         alpha = this.mEnabled ? 1 : 0.5;
      }
      
      override public function dispose() : void
      {
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
         if(this.mUpTexture)
         {
            this.mUpTexture.dispose();
            this.mUpTexture = null;
         }
         if(this.mDownTexture)
         {
            this.mDownTexture.dispose();
            this.mDownTexture = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      public function showDeckNotificationIcon() : void
      {
         if(this.mNotificationIcon == null)
         {
            if(this.mButton)
            {
               this.mNotificationIcon = new FSImage(Root.assets.getTexture("claim_warning"));
               this.mNotificationIcon.alignPivot();
               this.mNotificationIcon.x = this.mButton.x + this.mButton.width * 0.47;
               this.mNotificationIcon.y = this.mButton.y - this.mButton.height * 0.27;
               addChild(this.mNotificationIcon);
            }
         }
      }
      
      public function hideDeckNotificationIcon() : void
      {
         if(this.mNotificationIcon)
         {
            this.mNotificationIcon.removeFromParent();
            this.mNotificationIcon.destroy();
            this.mNotificationIcon = null;
         }
      }
   }
}

