package com.fs.tcgengine.view.popups.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.RewardSlot;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalLayout;
   
   public class PopupRewards extends PopupStandard
   {
      
      private var mTitleTextfield:FSTextfield;
      
      private var mScrollContainer:ScrollContainer;
      
      private var mRewardsArr:Array;
      
      private var mLootEmptyTextfield:FSTextfield;
      
      public function PopupRewards(param1:Boolean = true)
      {
         super(true);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_EXTENDED_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,1200);
         if(Boolean(mBox) && Config.getConfig().gameHasCustomPopups())
         {
            mBox.scale = Constants.POPUP_EXTENDED_SCALE_FACTOR;
         }
      }
      
      override protected function createCornerImage(param1:String = "") : void
      {
         super.createCornerImage("button_rewards");
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         if(mAcceptButton)
         {
            mAcceptButton.removeFromParent();
         }
         this.createTitle();
         this.refreshRewards();
      }
      
      private function createTitle() : void
      {
         if(this.mTitleTextfield == null)
         {
            this.mTitleTextfield = new FSTextfield(mBox.width,mBox.height / 10,TextManager.getText("TID_REWARDS_NAME"));
            this.mTitleTextfield.y = 10;
            addChild(this.mTitleTextfield);
         }
      }
      
      public function refreshRewards() : void
      {
         InstanceMng.getServerConnection().searchInCollection("rewards","{\'uid\':\'" + InstanceMng.getUserDataMng().getOwnerUserData().getAccountId() + "\'}",this.fillRewards);
      }
      
      private function fillRewards(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RewardSlot = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         this.cleanContainer();
         this.mRewardsArr = param1 as Array;
         if(Boolean(this.mRewardsArr) && this.mRewardsArr.length > 0)
         {
            _loc11_ = null;
            _loc12_ = "";
            _loc2_ = 0;
            while(_loc2_ < this.mRewardsArr.length)
            {
               _loc4_ = this.mRewardsArr[_loc2_].sku;
               _loc5_ = this.mRewardsArr[_loc2_].origin;
               _loc6_ = int(this.mRewardsArr[_loc2_].type);
               _loc8_ = int(this.mRewardsArr[_loc2_].amount);
               _loc7_ = this.getRewardText(_loc5_,_loc6_,this.mRewardsArr[_loc2_]);
               _loc9_ = Utils.getDataId(this.mRewardsArr[_loc2_]);
               _loc10_ = this.mRewardsArr[_loc2_].hasOwnProperty("extraData") ? this.mRewardsArr[_loc2_].extraData : null;
               if(_loc5_ == "RAIDS_SP" || _loc5_ == "RAIDS_MP")
               {
                  _loc11_ = {
                     "raidSku":"raid_" + Utils.transformValueToString(String(this.mRewardsArr[_loc2_].raidNumber),2),
                     "difficulty":this.mRewardsArr[_loc2_].raidDifficulty
                  };
               }
               _loc3_ = new RewardSlot(this,_loc9_,_loc4_,_loc5_,_loc6_,_loc8_,_loc7_,_loc10_,_loc11_,this.mRewardsArr[_loc2_]);
               this.addRewardToScrollContainer(_loc3_);
               _loc2_++;
            }
         }
         else
         {
            this.createLootEmptyTextfield();
         }
      }
      
      private function addRewardToScrollContainer(param1:RewardSlot) : void
      {
         var _loc2_:int = 0;
         if(Boolean(this.mScrollContainer == null && mBox) && Boolean(param1) && Boolean(this.mTitleTextfield))
         {
            this.mScrollContainer = new ScrollContainer();
            _loc2_ = param1.width * 1.1;
            this.mScrollContainer.width = _loc2_;
            this.mScrollContainer.height = mBox.height * 0.9 - (this.mTitleTextfield.y + this.mTitleTextfield.height);
            this.mScrollContainer.layout = this.getContainerLayoutVertical();
            this.mScrollContainer.x = (mBox.width - _loc2_) / 2;
            this.mScrollContainer.y = this.mTitleTextfield.y + this.mTitleTextfield.height;
            this.mScrollContainer.touchable = true;
            addChild(this.mScrollContainer);
         }
         if(Boolean(this.mScrollContainer) && Boolean(param1))
         {
            this.mScrollContainer.addChild(param1);
         }
      }
      
      private function getContainerLayoutVertical() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 5;
         _loc1_.horizontalAlign = HorizontalAlign.CENTER;
         return _loc1_;
      }
      
      private function getRewardText(param1:String, param2:int, param3:Object) : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:JobDef = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:CardDef = null;
         var _loc21_:PackDef = null;
         var _loc22_:GoldDef = null;
         var _loc23_:BundleDef = null;
         var _loc24_:BoostDef = null;
         var _loc25_:ShopBoostDef = null;
         var _loc26_:String = null;
         var _loc4_:String = "";
         switch(param1)
         {
            case "PVP":
               return TextManager.replaceParameters(TextManager.getText("TID_REWARDS_PVP_SEASON"),[param3.season]);
            case "DUNGEONS":
               return TextManager.replaceParameters(TextManager.getText("TID_REWARDS_PVE_SEASON"),[param3.season]);
            case "RAIDS_SP":
            case "RAIDS_MP":
               _loc5_ = TextManager.getText("TID_RAID_NAME_" + Utils.transformValueToString(String(param3.raidNumber),2));
               _loc6_ = TextManager.getText("TID_DUNGEON_DIFFICULTY_0" + (int(param3.raidDifficulty) + 1));
               return TextManager.replaceParameters(TextManager.getText("TID_REWARDS_RAID"),[_loc5_,_loc6_]);
            case "GUILDS":
               _loc7_ = Boolean(param3.isGift);
               return _loc7_ ? TextManager.getText("TID_SHOP_GIFT_FROM") + " " + param3.from : TextManager.getText("TID_REWARDS_GUILD");
            case "JOBS":
               _loc8_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(param3.extraData.jobSku));
               _loc9_ = _loc8_.getName();
               return TextManager.replaceParameters(TextManager.getText("TID_GEN_CHAR_LEVEL"),[param3.levelGained]) + " (" + _loc9_ + ")";
            case "LOGIN_FACEBOOK":
               return TextManager.getText("TID_REWARDS_FB_LOGIN");
            case "KONG_RATE":
               return TextManager.getText("TID_GEN_RATE_NOW_BROWSER_KONG");
            case "GIFTS":
               _loc10_ = param3.from;
               _loc11_ = "";
               _loc12_ = param3.hasOwnProperty("sku") ? param3.sku : "";
               switch(param3.type)
               {
                  case 0:
                     _loc20_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc12_));
                     _loc11_ = _loc20_ ? _loc20_.getName() + " -" : TextManager.getText("TID_SHOP_GIFT_FROM");
                     break;
                  case 1:
                     _loc21_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc12_));
                     _loc22_ = GoldDef(InstanceMng.getGoldDefMng().getDefBySku(_loc12_));
                     _loc23_ = BundleDef(InstanceMng.getBundlesDefMng().getDefBySku(_loc12_));
                     if(_loc21_)
                     {
                        _loc11_ = _loc21_.getName() + " -";
                     }
                     else if(_loc22_)
                     {
                        _loc11_ = _loc22_.getName() + " -";
                     }
                     else if(_loc23_)
                     {
                        _loc11_ = _loc23_.getName() + " -";
                     }
                     break;
                  case 4:
                     _loc25_ = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getDefBySku(_loc12_));
                     if(_loc25_)
                     {
                        _loc11_ = _loc25_.getName() + " -";
                     }
                     else
                     {
                        _loc24_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(_loc12_));
                        if(_loc24_)
                        {
                           _loc11_ = _loc24_.getName() + " -";
                        }
                     }
                     break;
                  default:
                     _loc11_ = TextManager.getText("TID_SHOP_GIFT_FROM");
               }
               _loc13_ = _loc10_ == "Customer Support" ? _loc11_ : TextManager.getText("TID_SHOP_GIFT_FROM");
               return _loc13_ + " " + param3.from;
            case "REFERRAL":
               _loc15_ = int(param3["referralInfo"]["type"]);
               _loc16_ = int(param3["referralInfo"]["amount"]);
               _loc17_ = param3["referralInfo"]["recruiterId"];
               switch(_loc15_)
               {
                  case PopupReferral.REFERRAL_TYPE_STD_RECRUIT:
                     _loc26_ = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
                     _loc14_ = _loc26_ != _loc17_ ? TextManager.getText("TID_RECRUIT_GIFT") : TextManager.getText("TID_RECRUIT_MESSAGE_FRIEND");
                     break;
                  case PopupReferral.REFERRAL_TYPE_RECRUIT:
                     _loc14_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_MESSAGE_FRIENDS"),[_loc16_]);
                     break;
                  case PopupReferral.REFERRAL_TYPE_PLAY_PVP:
                     _loc14_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_MESSAGE_FRIENDS_PVP"),[_loc16_]);
                     break;
                  case PopupReferral.REFERRAL_TYPE_PLAY_RAIDS:
                     _loc14_ = TextManager.replaceParameters(TextManager.getText("TID_RECRUIT_MESSAGE_FRIENDS_RAID"),[_loc16_]);
               }
               return _loc14_;
            case "BATTLE_PASS":
               _loc18_ = int(param3["season"]);
               _loc19_ = int(param3["battlePassIndex"]);
               return TextManager.getText("TID_BP_BATTLEPASS") + " - " + TextManager.getText("TID_GEN_SEASON") + " " + _loc18_ + " #" + _loc19_;
            default:
               return _loc4_;
         }
      }
      
      public function onRewardClaimedCheckRewards(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this.mRewardsArr != null && this.mRewardsArr.length > 0)
         {
            if(this.mLootEmptyTextfield)
            {
               this.mLootEmptyTextfield.visible = false;
            }
            _loc2_ = 0;
            while(_loc2_ < this.mRewardsArr.length)
            {
               _loc3_ = Utils.getDataId(this.mRewardsArr[_loc2_]);
               if(_loc3_ == param1)
               {
                  this.mRewardsArr.splice(_loc2_,1);
               }
               _loc2_++;
            }
            if(this.mRewardsArr.length == 0)
            {
               this.createLootEmptyTextfield();
            }
         }
         else
         {
            this.createLootEmptyTextfield();
         }
      }
      
      private function createLootEmptyTextfield() : void
      {
         if(mBox)
         {
            if(this.mLootEmptyTextfield == null)
            {
               this.mLootEmptyTextfield = new FSTextfield(mBox.width,mBox.height,TextManager.getText("TID_REWARDS_EMPTY"));
               addChild(this.mLootEmptyTextfield);
            }
            this.mLootEmptyTextfield.visible = true;
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).hideLootNotificationsIcon();
            }
         }
      }
      
      public function getScrollcontainer() : ScrollContainer
      {
         return this.mScrollContainer;
      }
      
      private function cleanContainer() : void
      {
         if(this.mScrollContainer != null)
         {
            this.mScrollContainer.removeChildren();
         }
      }
      
      public function getRewardsAmount() : int
      {
         return this.mRewardsArr ? int(this.mRewardsArr.length) : 0;
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mScrollContainer)
         {
            this.mScrollContainer.removeFromParent(true);
            this.mScrollContainer = null;
         }
         if(this.mLootEmptyTextfield)
         {
            this.mLootEmptyTextfield.removeFromParent(true);
            this.mLootEmptyTextfield = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.REWARDS_POPUP_NAME);
         super.removeFromStage();
      }
      
      override public function dispose() : void
      {
         Utils.destroyArray(this.mRewardsArr);
         this.mRewardsArr = null;
         super.dispose();
      }
   }
}

