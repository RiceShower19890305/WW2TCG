package com.fs.tcgengine.view.components.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class PVPRewardInfo extends Component
   {
      
      private var mRewardInfo:Object;
      
      private var mBG:CustomComponent;
      
      private var mPackAnim:PackAnimation;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mGoldTextfield:FSTextfield;
      
      private var mRaidPointsTextfield:FSTextfield;
      
      private var mGoldImage:FSImage;
      
      private var mRaidPointsImage:FSImage;
      
      public function PVPRewardInfo(param1:Object)
      {
         this.mRewardInfo = param1;
         super();
         this.createUI();
         Utils.alignComponentAndFixPosition(this);
         x += width;
         y += height;
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createTextfield();
         this.createBundle();
         this.createCurrencies();
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:BundleDef = null;
         var _loc8_:FSShopItem = null;
         var _loc9_:Popup = null;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(parent != null && parent.parent is LayoutViewPort && parent.parent.parent is ScrollContainer && ScrollContainer(parent.parent.parent).isScrolling)
            {
               return;
            }
            _loc3_ = Boolean(this.mRewardInfo["firstPos"]);
            _loc4_ = int(this.mRewardInfo["minRating"]);
            _loc5_ = int(this.mRewardInfo["maxRating"]);
            FSDebug.debugTrace("Touching reward info: minRat" + _loc4_ + " maxrat: " + _loc5_);
            _loc6_ = this.mRewardInfo["reward"];
            _loc7_ = _loc6_ != null && _loc6_ != "" ? BundleDef(InstanceMng.getBundlesDefMng().getDefBySku(_loc6_.toLowerCase())) : null;
            _loc8_ = new FSShopItem(_loc7_,false,null,true);
            _loc9_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc9_)
            {
               _loc9_.hideTemporarily(InstanceMng.getPopupMng().openShopItemPopup,[_loc8_]);
            }
            else
            {
               InstanceMng.getPopupMng().openShopItemPopup(_loc8_);
            }
         }
         scale = param1.getTouch(this,TouchPhase.HOVER) != null ? 1.025 : 1;
      }
      
      private function createCurrencies() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:String = this.mRewardInfo["reward"];
         var _loc2_:BundleDef = _loc1_ != null && _loc1_ != "" ? BundleDef(InstanceMng.getBundlesDefMng().getDefBySku(_loc1_.toLowerCase())) : null;
         if(_loc2_)
         {
            _loc3_ = _loc2_.getGold();
            _loc4_ = _loc2_.getRaidPoints();
            _loc5_ = 0;
            _loc5_ = _loc5_ + (_loc3_ > 0 ? 1 : 0);
            _loc5_ = _loc5_ + (_loc4_ > 0 ? 1 : 0);
            if(_loc5_ > 0)
            {
               _loc6_ = _loc5_ == 1 ? int(this.mBG.width) : int(this.mBG.width / 2);
               _loc7_ = this.mBG.x + this.mBG.width * 0.2;
               if(_loc3_ > 0)
               {
                  if(this.mGoldImage == null)
                  {
                     this.mGoldImage = new FSImage(Root.assets.getTexture("large_gold_reward"));
                     this.mGoldImage.scale = 0.35;
                     this.mGoldImage.x = _loc5_ > 1 ? this.mBG.x : _loc7_;
                     this.mGoldImage.y = this.mBG.y + this.mBG.height - this.mGoldImage.height;
                     addChild(this.mGoldImage);
                  }
                  if(this.mGoldTextfield == null)
                  {
                     this.mGoldTextfield = new FSTextfield(_loc6_ - (this.mGoldImage.x + this.mGoldImage.width),this.mGoldImage.height,_loc3_.toString(),16777215,FSResourceMng.FONT_STD_SMALL_SIZE);
                     this.mGoldTextfield.format.horizontalAlign = Align.LEFT;
                     this.mGoldTextfield.x = this.mGoldImage.x + this.mGoldImage.width;
                     this.mGoldTextfield.y = this.mGoldImage.y;
                     addChild(this.mGoldTextfield);
                  }
               }
               if(_loc4_ > 0)
               {
                  if(this.mRaidPointsImage == null)
                  {
                     this.mRaidPointsImage = new FSImage(Root.assets.getTexture("large_raidpoints_reward"));
                     this.mRaidPointsImage.scale = 0.35;
                     this.mRaidPointsImage.x = _loc3_ > 0 ? this.mGoldTextfield.x + this.mGoldTextfield.width : _loc7_;
                     this.mRaidPointsImage.y = _loc3_ > 0 ? this.mGoldImage.y : this.mBG.y + this.mBG.height - this.mRaidPointsImage.height;
                     addChild(this.mRaidPointsImage);
                  }
                  if(this.mRaidPointsTextfield == null)
                  {
                     _loc8_ = _loc5_ > 1 ? int(this.mBG.width - (this.mRaidPointsImage.x + this.mRaidPointsImage.width)) : int(_loc6_ - (this.mRaidPointsImage.x + this.mRaidPointsImage.width));
                     this.mRaidPointsTextfield = new FSTextfield(_loc8_,this.mRaidPointsImage.height,_loc4_.toString(),16777215,FSResourceMng.FONT_STD_SMALL_SIZE);
                     this.mRaidPointsTextfield.format.horizontalAlign = Align.LEFT;
                     this.mRaidPointsTextfield.x = this.mRaidPointsImage.x + this.mRaidPointsImage.width;
                     this.mRaidPointsTextfield.y = this.mRaidPointsImage.y;
                     addChild(this.mRaidPointsTextfield);
                  }
               }
            }
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:int = int(this.mRewardInfo["league"]);
         var _loc2_:Boolean = Boolean(this.mRewardInfo["isReachLeagueReward"]);
         var _loc3_:int = this.mRewardInfo.hasOwnProperty("minRating") ? int(this.mRewardInfo["minRating"]) : -1;
         var _loc4_:int = this.mRewardInfo.hasOwnProperty("maxRating") ? int(this.mRewardInfo["maxRating"]) : -1;
         var _loc5_:UserData = Utils.getOwnerUserData();
         var _loc6_:int = _loc5_.getElo();
         var _loc7_:int = _loc5_.getPvPCurrentLeague();
         var _loc8_:int = _loc5_.getPvPBestLeague();
         var _loc9_:String = "";
         if(_loc2_)
         {
            _loc9_ = _loc1_ == _loc8_ ? "pvp_reward_socket_highlight" : "pvp_reward_socket_" + _loc1_;
         }
         else
         {
            _loc9_ = _loc1_ == _loc7_ && (_loc6_ >= _loc3_ && _loc6_ <= _loc4_) ? "pvp_reward_socket_highlight" : "pvp_reward_socket_" + _loc1_;
         }
         this.mBG = Utils.createCustomBox(_loc9_,344);
         addChild(this.mBG);
      }
      
      private function createTextfield() : void
      {
         var _loc1_:int = int(this.mRewardInfo["league"]);
         var _loc2_:String = TextManager.getText("TID_PVP_LEAGUE_" + _loc1_);
         var _loc3_:Boolean = this.mRewardInfo.hasOwnProperty("firstPos") ? Boolean(this.mRewardInfo["firstPos"]) : false;
         var _loc4_:int = this.mRewardInfo.hasOwnProperty("position") ? int(this.mRewardInfo["position"]) : -1;
         var _loc5_:int = this.mRewardInfo.hasOwnProperty("minRating") ? int(this.mRewardInfo["minRating"]) : -1;
         var _loc6_:int = this.mRewardInfo.hasOwnProperty("maxRating") ? int(this.mRewardInfo["maxRating"]) : -1;
         var _loc7_:Boolean = Boolean(this.mRewardInfo["isReachLeagueReward"]);
         var _loc8_:Boolean = Boolean(this.mRewardInfo["isTop3Reward"]);
         var _loc9_:String = _loc3_ || _loc6_ == -1 ? _loc5_ + "+" : _loc5_ + "-" + _loc6_;
         if(_loc7_)
         {
            _loc9_ = TextManager.replaceParameters(TextManager.getText("TID_PVP_REACH_LEAGUE"),[_loc2_]);
         }
         else if(_loc8_)
         {
            _loc9_ = "#" + (_loc4_ + 1);
         }
         else
         {
            _loc9_ = _loc3_ || _loc6_ == -1 ? _loc5_ + "+" : _loc5_ + "-" + _loc6_;
         }
         var _loc10_:int = this.mBG.width * 0.9;
         var _loc11_:Number = _loc7_ ? this.mBG.height / 3 : this.mBG.height / 4;
         this.mTitleTextfield = new FSTextfield(_loc10_,_loc11_,_loc9_,16777215,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
         this.mTitleTextfield.x = (this.mBG.width - _loc10_) / 2;
         this.mTitleTextfield.y = 3;
         addChild(this.mTitleTextfield);
      }
      
      private function createBundle() : void
      {
         var _loc6_:PackDef = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc1_:Boolean = Boolean(this.mRewardInfo["isReachLeagueReward"]);
         var _loc2_:int = int(this.mRewardInfo["league"]);
         var _loc3_:String = this.mRewardInfo["reward"];
         var _loc4_:BundleDef = _loc3_ != null && _loc3_ != "" ? BundleDef(InstanceMng.getBundlesDefMng().getDefBySku(_loc3_.toLowerCase())) : null;
         var _loc5_:String = _loc4_ ? _loc4_.getChestBG() : "";
         if(_loc5_)
         {
            _loc6_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc5_));
            _loc7_ = PackDef(_loc6_).getAnimBG();
            if(this.mPackAnim == null)
            {
               this.mPackAnim = new PackAnimation(_loc7_);
            }
            this.mPackAnim.scale = _loc1_ ? 0.65 : 0.55;
            this.mPackAnim.alignPivot();
            _loc8_ = _loc1_ ? 1.1 : 0.875;
            this.mPackAnim.x = this.mBG.x + this.mBG.width / 2;
            this.mPackAnim.y = this.mTitleTextfield.y + this.mTitleTextfield.height / 2 + this.mPackAnim.height / 2 + (this.mBG.height * _loc8_ - (this.mTitleTextfield.height + this.mPackAnim.height)) / 2;
            this.mPackAnim.touchable = false;
            addChild(this.mPackAnim);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mPackAnim)
         {
            this.mPackAnim.removeFromParent(true);
            this.mPackAnim = null;
         }
         if(this.mGoldImage)
         {
            this.mGoldImage.removeFromParent(true);
            this.mGoldImage = null;
         }
         if(this.mGoldTextfield)
         {
            this.mGoldTextfield.removeFromParent(true);
            this.mGoldTextfield = null;
         }
         if(this.mRaidPointsImage)
         {
            this.mRaidPointsImage.removeFromParent(true);
            this.mRaidPointsImage = null;
         }
         if(this.mRaidPointsTextfield)
         {
            this.mRaidPointsTextfield.removeFromParent(true);
            this.mRaidPointsTextfield = null;
         }
         this.mRewardInfo = null;
         super.dispose();
      }
   }
}

