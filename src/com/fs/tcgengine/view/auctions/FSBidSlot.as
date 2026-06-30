package com.fs.tcgengine.view.auctions
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.auctions.Auction;
   import com.fs.tcgengine.model.auctions.Bid;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.player.PlayerPortrait;
   import com.fs.tcgengine.view.guilds.GuildEmblem;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSBidSlot extends Component
   {
      
      private var mAuction:Auction;
      
      private var mBid:Bid;
      
      private var mBG:FSImage;
      
      private var mBidLayer:FSImage;
      
      private var mPhotoImage:FSImage;
      
      private var mPlayerPortrait:PlayerPortrait;
      
      private var mNameTextfield:FSTextfield;
      
      private var mRoundBidTextfield:FSTextfield;
      
      private var mGoldImage:FSImage;
      
      private var mBidTextfield:FSTextfield;
      
      private var mGuildEmblem:GuildEmblem;
      
      public function FSBidSlot(param1:Auction, param2:Bid)
      {
         super();
         this.mAuction = param1;
         this.mBid = param2;
         if(Boolean(this.mAuction) && Boolean(this.mBid))
         {
            this.createUI();
         }
         touchable = true;
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createPhoto();
         this.createNameTextfield();
         this.createRoundBidTextfield();
         this.createGoldImage();
         this.createBidTextfield();
         if(this.mBid.getBidderGuildEmblemBG() != "" && this.mBid.getBidderGuildEmblemFG() != "")
         {
            this.createGuildEmblem();
         }
      }
      
      private function createGuildEmblem() : void
      {
         if(Boolean(this.mNameTextfield) && this.mGuildEmblem == null)
         {
            this.mGuildEmblem = new GuildEmblem(this.mBid.getBidderGuildEmblemBG(),this.mBid.getBidderGuildEmblemFG());
            this.mGuildEmblem.touchable = true;
            this.mGuildEmblem.width *= Config.getConfig().getPortraitGuildEmblemFactor();
            this.mGuildEmblem.height *= Config.getConfig().getPortraitGuildEmblemFactor();
            this.mGuildEmblem.x = this.mNameTextfield.x + this.mNameTextfield.width + this.mGuildEmblem.width * 2;
            this.mGuildEmblem.y = this.mNameTextfield.y;
            this.mGuildEmblem.addEventListener(TouchEvent.TOUCH,this.onGuildEmblemTouch);
            if(this.mBid.getBidderGuildName() != null && this.mBid.getBidderGuildName() != "")
            {
               this.mGuildEmblem.setTooltipText(TextManager.getText("TID_GUILD_NAME_SINGLE") + ": " + this.mBid.getBidderGuildName());
            }
            addChild(this.mGuildEmblem);
         }
      }
      
      private function onGuildEmblemTouch(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc2_:Touch = param1 ? param1.getTouch(this.mGuildEmblem,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
            if(_loc3_ >= Config.getConfig().getUnlockGuildsLevel())
            {
               if(InstanceMng.getPopupMng())
               {
                  InstanceMng.getPopupMng().openGuildsPopup(this.mBid.getBidderGuildId());
               }
            }
            else
            {
               _loc4_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_FEATURE_LOCKED"),[Config.getConfig().getUnlockGuildsLevel()]);
               Utils.setLogText(_loc4_,true);
            }
         }
      }
      
      private function createBidTextfield() : void
      {
         if(Boolean(this.mGoldImage) && Boolean(this.mRoundBidTextfield) && this.mBidTextfield == null)
         {
            this.mBidTextfield = new FSTextfield(this.mBG.width - this.mGoldImage.x - this.mGoldImage.width,this.mGoldImage.height,this.mBid.getBid().toString());
            this.mBidTextfield.x = this.mGoldImage.x + this.mGoldImage.width * 0.6;
            this.mBidTextfield.y = this.mRoundBidTextfield.y;
            addChild(this.mBidTextfield);
         }
      }
      
      private function createGoldImage() : void
      {
         if(Boolean(this.mRoundBidTextfield) && this.mGoldImage == null)
         {
            this.mGoldImage = new FSImage(Root.assets.getTexture("auction_gold_icon"));
            this.mGoldImage.alignPivot();
            this.mGoldImage.x = this.mRoundBidTextfield.x + this.mRoundBidTextfield.width + this.mGoldImage.width * 0.5;
            this.mGoldImage.y = this.mRoundBidTextfield.y + this.mGoldImage.height / 2;
            addChild(this.mGoldImage);
         }
      }
      
      private function createRoundBidTextfield() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mNameTextfield) && Boolean(this.mRoundBidTextfield == null) && Boolean(this.mBid))
         {
            _loc1_ = this.mBid.getRound() == 1 ? TextManager.getText("TID_AUCTIONS_INITIAL_ROUND") : TextManager.replaceParameters(TextManager.getText("TID_AUCTIONS_KNOCKOUT_ROUND"),[this.mBid.getRound() - 1]);
            this.mRoundBidTextfield = new FSTextfield(this.mBG.width * 0.55,this.mBG.height * 0.3,_loc1_);
            this.mRoundBidTextfield.format.horizontalAlign = Align.LEFT;
            this.mRoundBidTextfield.x = this.mNameTextfield.x;
            this.mRoundBidTextfield.y = this.mNameTextfield.y + this.mNameTextfield.height * 1.3;
            addChild(this.mRoundBidTextfield);
         }
      }
      
      private function createNameTextfield() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mBG) && (Boolean(this.mPhotoImage || this.mPlayerPortrait)) && this.mNameTextfield == null)
         {
            _loc1_ = this.mBid.getBidderName() ? this.mBid.getBidderName() : TextManager.getText("TID_GEN_PLAYER");
            this.mNameTextfield = new FSTextfield(this.mBG.width * 0.55,this.mBG.height * 0.3,_loc1_);
            this.mNameTextfield.format.horizontalAlign = Align.LEFT;
            this.mNameTextfield.x = this.mPhotoImage ? this.mPhotoImage.x + this.mPhotoImage.width * 1.2 : this.mPlayerPortrait.x + this.mPlayerPortrait.width * 1.2;
            this.mNameTextfield.y = this.mBG.y + this.mNameTextfield.height * 0.5;
            addChild(this.mNameTextfield);
         }
      }
      
      private function createPhoto() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:Texture = null;
         var _loc4_:String = null;
         if(this.mBG)
         {
            _loc1_ = this.mBid.getBidderExtId();
            if(_loc1_ != null && _loc1_ != "" && _loc1_ != "sample")
            {
               _loc2_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) && _loc1_ == InstanceMng.getUserDataMng().getOwnerUserData().getExtId();
               this.mPlayerPortrait = new PlayerPortrait(_loc1_,_loc2_);
               if(this.mPlayerPortrait)
               {
                  this.mPlayerPortrait.x = this.mBG.x + this.mPlayerPortrait.width * 0.3;
                  this.mPlayerPortrait.y = this.mBG.y + this.mPlayerPortrait.height * 0.3;
                  addChild(this.mPlayerPortrait);
                  this.mPlayerPortrait.loadProfilePicture();
               }
            }
            else
            {
               _loc4_ = FSResourceMng.DEFAULT_PHOTO_NAME + "_portrait";
               _loc3_ = Root.assets.getTexture(_loc4_);
               this.mPhotoImage = new FSImage(_loc3_);
               this.mPhotoImage.x = this.mBG.x + this.mPhotoImage.width * 0.3;
               this.mPhotoImage.y = this.mBG.y + this.mPhotoImage.height * 0.3;
               addChild(this.mPhotoImage);
            }
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:String = null;
         if(this.mBG == null)
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
            if(this.mBid.getBidderId() == _loc2_)
            {
               _loc1_ = Root.assets.getTexture("auction_layer_bid_me");
            }
            else
            {
               _loc1_ = Root.assets.getTexture("auction_layer_bid");
            }
            this.mBG = new FSImage(_loc1_);
            addChild(this.mBG);
         }
      }
      
      public function getBid() : Bid
      {
         return this.mBid;
      }
      
      override public function dispose() : void
      {
         this.mAuction = null;
         Utils.destroyObject(this.mBid);
         this.mBid = null;
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBidLayer)
         {
            this.mBidLayer.removeFromParent(true);
            this.mBidLayer = null;
         }
         if(this.mPhotoImage)
         {
            this.mPhotoImage.removeFromParent(true);
            this.mPhotoImage = null;
         }
         if(this.mPlayerPortrait)
         {
            this.mPlayerPortrait.removeFromParent(true);
            this.mPlayerPortrait = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mRoundBidTextfield)
         {
            this.mRoundBidTextfield.removeFromParent(true);
            this.mRoundBidTextfield = null;
         }
         if(this.mGoldImage)
         {
            this.mGoldImage.removeFromParent(true);
            this.mGoldImage = null;
         }
         if(this.mBidTextfield)
         {
            this.mBidTextfield.removeFromParent(true);
            this.mBidTextfield = null;
         }
         if(this.mGuildEmblem)
         {
            this.mGuildEmblem.removeFromParent(true);
            this.mGuildEmblem = null;
         }
      }
   }
}

