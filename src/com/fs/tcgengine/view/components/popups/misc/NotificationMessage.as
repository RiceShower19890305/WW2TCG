package com.fs.tcgengine.view.components.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSCheckBox;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.player.PlayerPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import feathers.controls.ScrollContainer;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class NotificationMessage extends Component
   {
      
      public static const NOTIFICATION_TYPE_LIFE_RECEIVED:int = 0;
      
      public static const NOTIFICATION_TYPE_LIFE_REQUESTED:int = 1;
      
      public static const NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED:int = 2;
      
      public static const NOTIFICATION_TYPE_UNLOCK_HELP_REQUESTED:int = 3;
      
      public static const NOTIFICATION_TYPE_ITEM_RECEIVED:int = 4;
      
      public static const NOTIFICATION_TYPE_ITEM_REQUESTED:int = 5;
      
      public static const NOTIFICATION_TYPE_MESSAGE_RECEIVED:int = 6;
      
      public static const NOTIFICATION_TYPE_SEND_LIFE:int = 7;
      
      public static const NOTIFICATION_TYPE_INVITE:int = 8;
      
      public static const NOTIFICATION_TYPE_PVP_REQUEST:int = 9;
      
      public static const NOTIFICATION_GIFT_BG_NAME:String = "message_panel_green";
      
      public static const NOTIFICATION_REQUEST_BG_NAME:String = "message_panel_red";
      
      public static const LIFE_ICON_SMALL:String = "life_icon_small";
      
      public static const UNLOCK_ICON_SMALL:String = "unlock_icon_small";
      
      public static const INVITE_ICON_SMALL:String = "logo_small";
      
      private var mRequestId:String;
      
      private var mType:int;
      
      private var mSenderFBId:String;
      
      private var mSenderName:String;
      
      private var mCheckBox:FSCheckBox;
      
      private var mPlayerPortrait:PlayerPortrait;
      
      private var mBG:FSImage;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mSubtitleTextfield:FSTextfield;
      
      private var mIcon:FSImage;
      
      private var mNotificationObj:Object;
      
      private var mParentScrollContainer:ScrollContainer;
      
      private var mExtraMsg:String;
      
      public function NotificationMessage(param1:Object, param2:ScrollContainer)
      {
         super();
         this.mParentScrollContainer = param2;
         this.mNotificationObj = param1;
         this.mRequestId = param1.requestId;
         this.mType = this.mNotificationObj.type;
         this.mSenderFBId = this.mNotificationObj.senderFBId;
         this.mSenderName = this.mNotificationObj.senderName;
         this.mExtraMsg = this.mNotificationObj.extra;
         this.setup();
      }
      
      private function setup() : void
      {
         this.createBG();
         this.createCheckBox();
         this.createPlayerPortrait();
         this.createTitle();
         this.createSubtitle();
         this.createIconImage();
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null)
         {
            _loc1_ = this.isGift() ? NOTIFICATION_GIFT_BG_NAME : NOTIFICATION_REQUEST_BG_NAME;
            if(Root.assets.getTexture(_loc1_) != null)
            {
               this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
               addChild(this.mBG);
               this.mBG.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
            }
         }
      }
      
      private function onBGTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         _loc2_ = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(!this.mParentScrollContainer.isScrolling)
            {
               this.mCheckBox.setToggled();
            }
         }
      }
      
      private function createCheckBox() : void
      {
         if(this.mCheckBox == null)
         {
            this.mCheckBox = new FSCheckBox();
            this.mCheckBox.x = this.mCheckBox.width * 0.85;
            this.mCheckBox.y = this.mBG ? this.mBG.height / 2 : 0;
            this.mCheckBox.setToggled(true);
            addChild(this.mCheckBox);
         }
      }
      
      private function createPlayerPortrait() : void
      {
         if(this.mPlayerPortrait == null)
         {
            this.mPlayerPortrait = new PlayerPortrait(this.mSenderFBId);
            this.mPlayerPortrait.x = this.mCheckBox ? this.mCheckBox.x + this.mCheckBox.width * 0.85 : this.mPlayerPortrait.width / 2;
            this.mPlayerPortrait.y = Boolean(this.mBG) && Boolean(this.mPlayerPortrait) ? (this.mBG.height - this.mPlayerPortrait.height) / 2 : this.mPlayerPortrait.height / 2;
            addChild(this.mPlayerPortrait);
         }
      }
      
      private function createTitle() : void
      {
         if(this.mTitleTextfield == null)
         {
            this.mTitleTextfield = new FSTextfield(this.mBG.width * 0.5,this.mBG.height * 0.35,this.getTitleText());
            this.mTitleTextfield.touchable = false;
            this.mTitleTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mTitleTextfield.x = this.mPlayerPortrait.x + this.mPlayerPortrait.width * 1.1;
            this.mTitleTextfield.y = this.mBG.height * 0.05;
            this.mTitleTextfield.color = this.isGift() ? 65280 : 16711680;
            this.mTitleTextfield.format.horizontalAlign = Align.LEFT;
            this.mTitleTextfield.format.verticalAlign = Align.BOTTOM;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function createSubtitle() : void
      {
         if(this.mSubtitleTextfield == null)
         {
            this.mSubtitleTextfield = new FSTextfield(this.mBG.width * 0.5,this.mBG.height * 0.6,this.getSubtitleText());
            this.mSubtitleTextfield.touchable = false;
            this.mSubtitleTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mSubtitleTextfield.format.horizontalAlign = Align.LEFT;
            this.mSubtitleTextfield.format.verticalAlign = Align.TOP;
            this.mSubtitleTextfield.fontName = FSResourceMng.getFontByType();
            this.mSubtitleTextfield.x = this.mTitleTextfield.x;
            this.mSubtitleTextfield.y = this.mTitleTextfield.y + this.mTitleTextfield.height;
            addChild(this.mSubtitleTextfield);
         }
      }
      
      private function createIconImage() : void
      {
         var _loc1_:String = null;
         var _loc2_:Texture = null;
         if(this.mIcon == null)
         {
            _loc1_ = this.getImageName();
            if(_loc1_ != "")
            {
               _loc2_ = Root.assets.getTexture(_loc1_);
               if(_loc2_ != null)
               {
                  this.mIcon = new FSImage(_loc2_);
                  this.mIcon.touchable = false;
                  this.mIcon.x = this.mSubtitleTextfield.x + this.mSubtitleTextfield.width;
                  this.mIcon.y = (this.mBG.height - this.mIcon.height) / 2;
                  addChild(this.mIcon);
               }
            }
         }
      }
      
      public function requestPortraitPics() : void
      {
         if(this.mPlayerPortrait)
         {
            this.mPlayerPortrait.loadProfilePicture();
         }
      }
      
      private function getImageName() : String
      {
         var _loc1_:String = "";
         switch(this.mType)
         {
            case NOTIFICATION_TYPE_LIFE_REQUESTED:
            case NOTIFICATION_TYPE_LIFE_RECEIVED:
            case NOTIFICATION_TYPE_SEND_LIFE:
               _loc1_ = LIFE_ICON_SMALL;
               break;
            case NOTIFICATION_TYPE_UNLOCK_HELP_REQUESTED:
            case NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED:
               _loc1_ = UNLOCK_ICON_SMALL;
               break;
            case NOTIFICATION_TYPE_ITEM_RECEIVED:
            case NOTIFICATION_TYPE_ITEM_REQUESTED:
            case NOTIFICATION_TYPE_MESSAGE_RECEIVED:
               _loc1_ = LIFE_ICON_SMALL;
               break;
            case NOTIFICATION_TYPE_INVITE:
               _loc1_ = INVITE_ICON_SMALL;
         }
         return _loc1_;
      }
      
      private function getTitleText() : String
      {
         var _loc1_:String = null;
         switch(this.mType)
         {
            case NOTIFICATION_TYPE_LIFE_RECEIVED:
               _loc1_ = TextManager.getText("TID_SOCIAL_GIFT_CLAIM",true);
               break;
            case NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED:
               _loc1_ = TextManager.getText("TID_SOCIAL_HELPED_FRIEND",true);
               break;
            case NOTIFICATION_TYPE_ITEM_RECEIVED:
               _loc1_ = TextManager.getText("TID_SOCIAL_GIFT_CLAIM",true);
               break;
            case NOTIFICATION_TYPE_LIFE_REQUESTED:
               _loc1_ = TextManager.getText("TID_SOCIAL_GIFT_SEND",true);
               break;
            case NOTIFICATION_TYPE_SEND_LIFE:
               _loc1_ = TextManager.getText("TID_SOCIAL_GIFT_SEND",true);
               break;
            case NOTIFICATION_TYPE_UNLOCK_HELP_REQUESTED:
               _loc1_ = TextManager.getText("TID_SOCIAL_HELP_FRIEND",true);
               break;
            case NOTIFICATION_TYPE_ITEM_REQUESTED:
               _loc1_ = TextManager.getText("TID_SOCIAL_GIFT_SEND",true);
               break;
            case NOTIFICATION_TYPE_MESSAGE_RECEIVED:
               break;
            case NOTIFICATION_TYPE_INVITE:
               _loc1_ = TextManager.getText("TID_GEN_BUTTON_INVITE",true);
         }
         return _loc1_;
      }
      
      private function getSubtitleText() : String
      {
         var _loc1_:String = null;
         switch(this.mType)
         {
            case NOTIFICATION_TYPE_SEND_LIFE:
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_LIFE_SEND_TO",true),[this.mSenderName]);
               if(this.mExtraMsg != null && this.mExtraMsg != "")
               {
                  _loc1_ += ". " + this.mExtraMsg;
               }
               break;
            case NOTIFICATION_TYPE_LIFE_RECEIVED:
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_SOCIAL_RECEIVE_LIFE",true),[this.mSenderName]);
               break;
            case NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED:
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_SOCIAL_RECEIVE_UNLOCK",true),[this.mSenderName]);
               break;
            case NOTIFICATION_TYPE_ITEM_RECEIVED:
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_SOCIAL_RECEIVE_BOOST",true),[this.mSenderName]);
               break;
            case NOTIFICATION_TYPE_LIFE_REQUESTED:
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_SOCIAL_SEND_LIFE",true),[this.mSenderName]);
               break;
            case NOTIFICATION_TYPE_UNLOCK_HELP_REQUESTED:
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_SOCIAL_SEND_UNLOCK",true),[this.mSenderName]);
               break;
            case NOTIFICATION_TYPE_ITEM_REQUESTED:
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_SOCIAL_SEND_BOOST",true),[this.mSenderName]);
               break;
            case NOTIFICATION_TYPE_MESSAGE_RECEIVED:
               break;
            case NOTIFICATION_TYPE_INVITE:
               _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_INVITE_FRIEND_AWESOME",true),[this.mSenderName]);
         }
         return _loc1_;
      }
      
      public function isGift() : Boolean
      {
         var _loc1_:Boolean = false;
         switch(this.mType)
         {
            case NOTIFICATION_TYPE_LIFE_RECEIVED:
            case NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED:
            case NOTIFICATION_TYPE_ITEM_RECEIVED:
               return true;
            case NOTIFICATION_TYPE_UNLOCK_HELP_REQUESTED:
            case NOTIFICATION_TYPE_ITEM_REQUESTED:
            case NOTIFICATION_TYPE_LIFE_REQUESTED:
            case NOTIFICATION_TYPE_SEND_LIFE:
            case NOTIFICATION_TYPE_INVITE:
               return false;
            case NOTIFICATION_TYPE_MESSAGE_RECEIVED:
         }
         return _loc1_;
      }
      
      public function toggleCheckBox(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(this.mCheckBox)
         {
            this.mCheckBox.setToggled(param1,param2);
         }
      }
      
      public function execute() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:Object = null;
         switch(this.mType)
         {
            case NOTIFICATION_TYPE_LIFE_RECEIVED:
               _loc1_ = Utils.getOwnerUserData();
               if(_loc1_)
               {
                  _loc1_.playerGainLife(1,false);
               }
               break;
            case NOTIFICATION_TYPE_ITEM_RECEIVED:
            case NOTIFICATION_TYPE_ITEM_REQUESTED:
            case NOTIFICATION_TYPE_MESSAGE_RECEIVED:
               break;
            case NOTIFICATION_TYPE_UNLOCK_HELP_RECEIVED:
               _loc2_ = new Object();
               _loc2_.reqId = this.mRequestId;
               _loc2_.uid = InstanceMng.getServerConnection().getUserId();
               _loc2_.senderFBId = this.mSenderFBId;
               _loc2_.senderName = this.mSenderName;
               _loc2_.type = this.mType;
               InstanceMng.getServerConnection().checkIfMapHelpNotifExists(this.mSenderFBId,InstanceMng.getServerConnection().addMapUnlockHelpInstanceToDB,_loc2_);
               break;
            case NOTIFICATION_TYPE_UNLOCK_HELP_REQUESTED:
            case NOTIFICATION_TYPE_LIFE_REQUESTED:
            case NOTIFICATION_TYPE_SEND_LIFE:
            case NOTIFICATION_TYPE_INVITE:
         }
         if(InstanceMng.getUserDataMng() != null && InstanceMng.getUserDataMng().getOwnerUserData() != null)
         {
            InstanceMng.getUserDataMng().getOwnerUserData().removeNotification(this.mRequestId);
         }
         InstanceMng.getServerConnection().removeRequestInstance(this.mRequestId);
      }
      
      public function isToggled() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.mCheckBox)
         {
            _loc1_ = this.mCheckBox.isToggled();
         }
         return _loc1_;
      }
      
      public function getExtId() : String
      {
         return this.mSenderFBId;
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mCheckBox)
         {
            this.mCheckBox.removeFromParent(true);
            this.mCheckBox = null;
         }
         if(this.mPlayerPortrait)
         {
            this.mPlayerPortrait.removeFromParent(true);
            this.mPlayerPortrait = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mSubtitleTextfield)
         {
            this.mSubtitleTextfield.removeFromParent(true);
            this.mSubtitleTextfield = null;
         }
         if(this.mIcon)
         {
            this.mIcon.removeFromParent(true);
            this.mIcon = null;
         }
         this.mNotificationObj = null;
         this.mParentScrollContainer = null;
         super.dispose();
      }
   }
}

