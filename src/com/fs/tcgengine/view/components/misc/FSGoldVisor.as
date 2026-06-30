package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import flash.ui.Mouse;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class FSGoldVisor extends Component
   {
      
      private const BG_IMG_NAME:String = "gold_icon_socket";
      
      protected var mTitleTextfield:FSTextfield;
      
      protected var mAmountTextfield:FSTextfield;
      
      protected var mBG:FSImage;
      
      protected var mFontName:String;
      
      protected var mIsButton:Boolean;
      
      protected var mOnClickFunction:Function;
      
      protected var mTitle:String;
      
      public function FSGoldVisor(param1:String = "", param2:String = "", param3:Boolean = false, param4:Function = null, param5:String = "", param6:Number = 1)
      {
         super();
         this.mFontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
         this.mIsButton = param3;
         this.mOnClickFunction = param4;
         this.mTitle = param5;
         this.init(param1,param6);
         pivotX = width / 2;
         pivotY = height / 2;
      }
      
      private function init(param1:String = "", param2:Number = 1) : void
      {
         this.createBG(param1);
         this.createTitle();
         this.createAmountTextfield(param2);
      }
      
      private function createTitle() : void
      {
         if(this.mTitleTextfield == null && this.mTitle != "")
         {
            this.mTitleTextfield = new FSTextfield(this.mBG.width * 0.5,this.mBG.height / 1.7,this.mTitle,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mTitleTextfield.alignPivot();
            this.mTitleTextfield.x = this.mBG.width * 0.4 + this.mTitleTextfield.width / 2;
            this.mTitleTextfield.y = (this.mBG.height - this.mTitleTextfield.height) / 2.5 + this.mTitleTextfield.height / 2;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function createAmountTextfield(param1:Number = 1) : void
      {
         var _loc2_:Number = NaN;
         if(this.mAmountTextfield == null)
         {
            _loc2_ = this.mTitle != "" ? this.mBG.height / 3.95 : this.mBG.height / 1.7;
            _loc2_ *= param1;
            this.mAmountTextfield = new FSTextfield(this.mBG.width * 0.5,_loc2_,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mAmountTextfield.fontName = this.mFontName;
            this.mAmountTextfield.alignPivot();
            this.mAmountTextfield.x = this.mTitle == "" ? this.mBG.width * 0.45 + this.mAmountTextfield.width / 2 : this.mBG.width * 0.2 + this.mAmountTextfield.width / 2;
            this.mAmountTextfield.y = this.mTitle == "" ? (this.mBG.height - this.mAmountTextfield.height) / 2 + this.mAmountTextfield.height / 2 : this.mBG.height - this.mAmountTextfield.height * 1.2 + this.mAmountTextfield.height / 2;
            addChild(this.mAmountTextfield);
         }
         this.updateAmount();
      }
      
      private function createBG(param1:String = "") : void
      {
         var _loc2_:String = null;
         if(this.mBG == null)
         {
            _loc2_ = param1 == "" ? this.BG_IMG_NAME : param1;
            this.mBG = new FSImage(Root.assets.getTexture(_loc2_));
            addChild(this.mBG);
            this.mBG.alignPivot();
            this.mBG.x = this.mBG.width / 2;
            this.mBG.y = this.mBG.height / 2;
         }
         if(this.mIsButton)
         {
            this.mBG.addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:GoldDef = null;
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getCurrentScreen() is FSMapScreen && FSMapScreen(InstanceMng.getCurrentScreen()).isSubMenuShown();
            if(_loc3_)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).closeSubMenu();
            }
            Utils.playSound(Constants.SOUND_CLICK,SoundManager.TYPE_SFX);
            if(this.mOnClickFunction != null)
            {
               this.mOnClickFunction();
               this.disableButtonTemporarily();
            }
            else
            {
               _loc4_ = InstanceMng.getTutorialMng().isTutorialOver();
               if(_loc4_)
               {
                  this.disableButtonTemporarily();
                  _loc5_ = GoldDef(InstanceMng.getGoldDefMng().getDefBySku("gold_02"));
                  if(_loc5_)
                  {
                     InstanceMng.getPopupMng().openBuyGoldBagPopup(_loc5_);
                  }
               }
            }
         }
         _loc2_ = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
         this.mBG.scaleX = _loc2_ ? 1.04 : 1;
         this.mBG.scaleY = _loc2_ ? 1.04 : 1;
         this.mAmountTextfield.scaleX = _loc2_ ? 1.04 : 1;
         this.mAmountTextfield.scaleY = _loc2_ ? 1.04 : 1;
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.scaleX = _loc2_ ? 1.04 : 1;
            this.mTitleTextfield.scaleY = _loc2_ ? 1.04 : 1;
         }
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            Mouse.cursor = _loc2_ ? "hand" : "auto";
         }
      }
      
      protected function disableButtonTemporarily() : void
      {
         this.setEnabled(false);
         TweenMax.delayedCall(3,this.setEnabled,[true]);
      }
      
      public function updateAmount() : void
      {
         var _loc1_:UserData = null;
         if(this.mAmountTextfield != null)
         {
            _loc1_ = Utils.getOwnerUserData();
            if(_loc1_)
            {
               if(this.mAmountTextfield.text != "")
               {
                  SpecialFX.createTextfieldAmountTransition(this.mAmountTextfield,_loc1_.getGold(),0.25,true);
               }
               else
               {
                  this.mAmountTextfield.text = _loc1_.getGold().toString();
               }
            }
            else
            {
               this.mAmountTextfield.text = "?";
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
            this.mAmountTextfield = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         this.mOnClickFunction = null;
         this.mTitle = "";
         Root.assets.removeTexture(this.BG_IMG_NAME);
         super.dispose();
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         touchable = param1;
         alpha = param1 ? 0.999 : 0.7;
      }
   }
}

