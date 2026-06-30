package com.fs.tcgengine.view.components.shop
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.map.SubMenuButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class ShopMenuButton extends SubMenuButton
   {
      
      private var mSelectedBG:FSImage;
      
      private var mIsSelected:Boolean;
      
      private var mSelectedBGName:String = "";
      
      private var mUnselectedBGName:String = "";
      
      private var mNewCardsAmountImage:FSImage;
      
      private var mNewCardsAmountTextfield:FSTextfield;
      
      private var mExtraXFactor:Number;
      
      private var mOnTriggeredFunction:Function;
      
      private var mOriginalScale:Number = -1;
      
      public function ShopMenuButton(param1:Boolean, param2:String, param3:String, param4:String, param5:String, param6:Function, param7:String = "", param8:String = "bottom", param9:Number = 0.16)
      {
         this.mIsSelected = param1;
         super(param3,param3,param6,param7,param8);
         this.mSelectedBGName = param4;
         this.mUnselectedBGName = param5;
         name = param2;
         mButton.name = param2;
         this.mExtraXFactor = param9;
         this.setIsSelected(this.mIsSelected);
         this.mOnTriggeredFunction = param6;
         if(this.mOnTriggeredFunction != null)
         {
            mButton.touchable = false;
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.HOVER);
         if(Utils.isDesktop() || Utils.isBrowser())
         {
            this.mOriginalScale = this.mOriginalScale == -1 ? scale : this.mOriginalScale;
            scale = _loc2_ ? this.mOriginalScale * 1.05 : this.mOriginalScale;
         }
         _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
         if(Boolean(_loc2_) && this.mOnTriggeredFunction != null)
         {
            mButton.dispatchEventWith(Event.TRIGGERED);
         }
      }
      
      public function setIsSelected(param1:Boolean) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         this.mIsSelected = param1;
         var _loc2_:String = this.mIsSelected ? this.mSelectedBGName : this.mUnselectedBGName;
         var _loc3_:Boolean = false;
         if(this.mSelectedBG == null)
         {
            this.mSelectedBG = new FSImage(Root.assets.getTexture(_loc2_));
            _loc3_ = true;
         }
         else
         {
            this.mSelectedBG.texture = Root.assets.getTexture(_loc2_);
         }
         var _loc6_:Boolean = true;
         switch(_loc2_)
         {
            case "db_button_on":
            case "db_button_off":
            case FSDeckBuilderScreen.FILTER_ON_NAME:
            case FSDeckBuilderScreen.FILTER_ON_NAME:
               _loc4_ = 41.75;
               _loc5_ = 41;
               break;
            case "db_button_top_on":
            case "db_button_top_off":
               _loc4_ = 80;
               _loc5_ = 41;
               break;
            default:
               _loc6_ = false;
         }
         if(_loc6_)
         {
            Utils.setupImage9Scale(this.mSelectedBG,17.5,13.5,6,16,_loc4_,_loc5_);
         }
         if(_loc3_)
         {
            if(mButton)
            {
               mButton.x += mButton.width * this.mExtraXFactor;
            }
            if(mTextfield)
            {
               mTextfield.x += mButton.width * this.mExtraXFactor;
            }
            if(mNotificationIcon)
            {
               mNotificationIcon.x += mButton.width * this.mExtraXFactor;
            }
            addChildAt(this.mSelectedBG,getChildIndex(mButton));
         }
      }
      
      public function isSelected() : Boolean
      {
         return this.mIsSelected;
      }
      
      public function updateNewCardsAmount(param1:int) : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            if(param1 > 0)
            {
               if(this.mNewCardsAmountImage == null)
               {
                  this.mNewCardsAmountImage = new FSImage(Root.assets.getTexture("new_card_bubble"));
                  this.mNewCardsAmountImage.touchable = false;
                  this.mNewCardsAmountImage.x = width - this.mNewCardsAmountImage.width / 1.25;
                  this.mNewCardsAmountImage.y = -this.mNewCardsAmountImage.height / 5;
                  addChild(this.mNewCardsAmountImage);
               }
               if(this.mNewCardsAmountTextfield == null)
               {
                  this.mNewCardsAmountTextfield = new FSTextfield(this.mNewCardsAmountImage.width * 1.175,this.mNewCardsAmountImage.height,param1.toString());
                  this.mNewCardsAmountTextfield.touchable = false;
                  this.mNewCardsAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  this.mNewCardsAmountTextfield.format.horizontalAlign = Align.CENTER;
                  this.mNewCardsAmountTextfield.x = this.mNewCardsAmountImage.x;
                  this.mNewCardsAmountTextfield.y = this.mNewCardsAmountImage.y;
                  addChild(this.mNewCardsAmountTextfield);
               }
               else
               {
                  this.mNewCardsAmountTextfield.text = param1.toString();
               }
            }
            else
            {
               if(this.mNewCardsAmountImage)
               {
                  this.mNewCardsAmountImage.removeFromParent();
                  this.mNewCardsAmountImage.destroy();
                  this.mNewCardsAmountImage = null;
               }
               if(this.mNewCardsAmountTextfield)
               {
                  this.mNewCardsAmountTextfield.removeFromParent(true);
                  this.mNewCardsAmountTextfield = null;
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mSelectedBG)
         {
            this.mSelectedBG.removeFromParent(true);
            this.mSelectedBG = null;
         }
         if(this.mNewCardsAmountImage)
         {
            this.mNewCardsAmountImage.removeFromParent(true);
            this.mNewCardsAmountImage = null;
         }
         if(this.mNewCardsAmountTextfield)
         {
            this.mNewCardsAmountTextfield.removeFromParent(true);
            this.mNewCardsAmountTextfield = null;
         }
         this.mOnTriggeredFunction = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

