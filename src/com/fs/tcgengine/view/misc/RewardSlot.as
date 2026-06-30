package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.quests.QuestSlot;
   import com.fs.tcgengine.view.map.MapRewardPanel;
   import com.fs.tcgengine.view.popups.misc.PopupRewards;
   import flash.utils.setTimeout;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class RewardSlot extends Component
   {
      
      public static const BG_CARDS:String = "rewards_cards_icon";
      
      public static const REWARD_TYPE_CARD:int = 0;
      
      public static const REWARD_TYPE_PACK:int = 1;
      
      public static const REWARD_TYPE_PORTRAIT_SKIN:int = 2;
      
      public static const REWARD_TYPE_GOLD:int = 3;
      
      public static const REWARD_TYPE_BOOSTS:int = 4;
      
      public static const REWARD_TYPE_RAID_POINTS:int = 5;
      
      public static const REWARD_TYPE_TOKENS:int = 6;
      
      public static const REWARD_TYPE_QUEST_COINS:int = 7;
      
      private const BG:String = "quest_layer";
      
      private const BG_PVP:String = "rewards_pvp_icon";
      
      private const BG_DUNGEONS:String = "rewards_dungeons_icon";
      
      private const BG_GUILDS:String = "rewards_guilds_icon";
      
      private const BG_RAIDS_SP:String = "rewards_raids_sp_icon";
      
      private const BG_RAIDS_MP:String = "rewards_raids_mp_icon";
      
      private const BG_FB_LOGIN:String = "rewards_fb_login_icon";
      
      private const BG_KONG_RATE:String = "kong_rate_icon";
      
      private const BG_GIFT:String = "rewards_gift_icon";
      
      private const BG_BATTLE_PASS:String = "rewards_battle_pass_icon";
      
      private const BG_GOLD:String = "rewards_gold_icon";
      
      private const BG_RAID_POINTS:String = "rewards_raid_points_icon";
      
      private const BG_PACKS:String = "rewards_packs_icon";
      
      private const BG_SKIN:String = "rewards_skins_icon";
      
      private const BG_PORTRAITS:String = "rewards_portraits_icon";
      
      private const BG_TOKENS:String = "rewards_tokens_icon";
      
      private var mBG:FSImage;
      
      private var mBGOrigin:FSImage;
      
      private var mBGType:FSImage;
      
      private var mDescTextfield:FSTextfield;
      
      private var mAmountTextfield:FSTextfield;
      
      private var mSku:String;
      
      private var mParentPopup:PopupRewards;
      
      private var mType:int;
      
      private var mOrigin:String;
      
      private var mAmount:int;
      
      private var mRewardId:String;
      
      private var mExtraData:Object;
      
      private var mRaidData:Object;
      
      private var mMapRewardPanel:MapRewardPanel;
      
      private var mRewardObjRaw:Object;
      
      public function RewardSlot(param1:PopupRewards, param2:String, param3:String, param4:String, param5:int, param6:int, param7:String, param8:Object, param9:Object, param10:Object = null)
      {
         super();
         this.mParentPopup = param1;
         this.mRewardId = param2;
         this.mSku = param3 ? param3.toLowerCase() : "";
         this.mAmount = param6;
         this.mType = param5;
         this.mOrigin = param4;
         this.mExtraData = param8;
         this.mRaidData = param9;
         this.mRewardObjRaw = param10;
         this.createUI(param4,param5,param6,param7);
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         Utils.alignComponentAndFixPosition(this);
      }
      
      public function createUI(param1:String, param2:int, param3:int, param4:String) : void
      {
         this.createBG();
         this.createOriginBG(param1);
         this.createTypeBG(param2);
         this.createDescription(param4);
         this.createAmount(param3);
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.BG));
            Utils.setupImage9Scale(this.mBG,6,10,8,12.5,296.25,55.31);
            this.mBG.x = 0;
            this.mBG.y = 0;
            addChild(this.mBG);
         }
      }
      
      private function createOriginBG(param1:String) : void
      {
         if(this.mBGOrigin == null)
         {
            this.mBGOrigin = new FSImage(Root.assets.getTexture(this.getOriginBGName(param1)));
            this.mBGOrigin.alignPivot();
            this.mBGOrigin.x = this.mBGOrigin.width / 3;
            this.mBGOrigin.y = this.mBG.height / 2;
            SpecialFX.createYoYoZoomTransition(this.mBGOrigin,1.1,1.5,-1,null,null,false);
            addChild(this.mBGOrigin);
         }
      }
      
      private function createTypeBG(param1:int) : void
      {
         if(this.mBGType == null)
         {
            this.mBGType = new FSImage(Root.assets.getTexture(this.getTypeBGName(param1)));
            this.mBGType.alignPivot();
            this.mBGType.x = this.mBG.width - this.mBGType.width / 2 - 5;
            this.mBGType.y = this.mBG.height / 2;
            addChild(this.mBGType);
         }
      }
      
      private function createDescription(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.mDescTextfield == null)
         {
            if(this.mType == 4)
            {
               param1 = this.getBoostName();
            }
            _loc2_ = this.mBG.width - this.mBGOrigin.width - this.mBGType.width - 10;
            this.mDescTextfield = new FSTextfield(_loc2_,this.mBG.height * 0.9,param1);
            this.mDescTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mDescTextfield.x = this.mBGOrigin.width + 5;
            this.mDescTextfield.y = (this.mBG.height - this.mDescTextfield.height) / 2;
            addChild(this.mDescTextfield);
         }
      }
      
      private function getBoostName() : String
      {
         var _loc1_:BoostDef = null;
         var _loc3_:String = null;
         var _loc2_:ShopBoostDef = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getDefBySku(this.mSku));
         if(_loc2_)
         {
            _loc3_ = _loc2_ ? _loc2_.getBoostSku() : "";
            if(_loc3_ != "")
            {
               _loc1_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(_loc3_));
            }
         }
         else
         {
            _loc1_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(this.mSku));
         }
         return _loc1_ ? TextManager.getText("TID_SHOP_BOOSTS") + ": " + _loc1_.getName() : "";
      }
      
      private function createAmount(param1:int) : void
      {
         if(this.mAmountTextfield == null)
         {
            if(this.isGoldBag())
            {
               param1 = GoldDef(InstanceMng.getGoldDefMng().getDefBySku(this.mSku)).getGold();
            }
            else if(this.isTokenBag())
            {
               param1 = AuctionTicketDef(InstanceMng.getAuctionTicketsDefMng().getDefBySku(this.mSku)).getTokens();
            }
            this.mAmountTextfield = new FSTextfield(this.mBGType.width,this.mBGType.height,param1.toString());
            this.mAmountTextfield.alignPivot();
            this.mAmountTextfield.x = this.mBGType.x;
            this.mAmountTextfield.y = this.mBGType.y;
            addChild(this.mAmountTextfield);
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(Boolean(this.mParentPopup) && !this.mParentPopup.getScrollcontainer().isScrolling)
            {
               if(InstanceMng.getServerConnection().isUserLoggedIn())
               {
                  touchable = false;
                  if(this.mType == 1)
                  {
                     this.mParentPopup.getScrollcontainer().touchable = false;
                     this.mParentPopup.enableCloseButton(false);
                  }
                  SpecialFX.tweenToAlpha(this,0.0001,0.35,0,this.onRewardFadedBeginClaim);
                  return;
               }
               Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            }
         }
         _loc2_ = param1.getTouch(this,TouchPhase.HOVER);
         scale = _loc2_ ? 1.02 : 1;
      }
      
      private function onRewardFadedBeginClaim() : void
      {
         removeFromParent();
         InstanceMng.getServerConnection().deleteReward(this.mRewardId,this.claim,null,this.onDeletionFailed);
      }
      
      private function onDeletionFailed() : void
      {
         Utils.setLogText(TextManager.getText("TID_GEN_SERVER_NO_CONNECT"),true);
      }
      
      private function claim() : void
      {
         var openPack:Function = null;
         var openBundle:Function = null;
         var giftInfo:Object = null;
         var cardDef:CardDef = null;
         var amountText:String = null;
         var cardName:String = null;
         var packDef:PackDef = null;
         var goldDef:GoldDef = null;
         var bundleDef:BundleDef = null;
         var lootsLeftToClaim:int = 0;
         var boostDef:BoostDef = null;
         var shopBoostDef:ShopBoostDef = null;
         var ticketDef:AuctionTicketDef = null;
         var boostSku:String = null;
         var currentAmount:int = 0;
         var boost:Boost = null;
         openPack = function():void
         {
            if(packDef)
            {
               checkIfJobsPack(packDef);
            }
         };
         openBundle = function():void
         {
            if(bundleDef)
            {
               InstanceMng.getUserDataMng().handleBundlePurchased(bundleDef,null);
            }
         };
         var ownerUserData:UserData = Utils.getOwnerUserData();
         if(ownerUserData)
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_LOOT,FSTracker.ACTION_PRE_CLAIM,{
               "type":this.mType,
               "sku":this.mSku,
               "amount":this.mAmount
            });
            giftInfo = {};
            switch(this.mType)
            {
               case REWARD_TYPE_CARD:
                  ownerUserData.addCardToCollection(this.mSku + ":" + this.mAmount);
                  ownerUserData.addCardToNewCardsCollection(this.mSku + ":" + this.mAmount);
                  cardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mSku));
                  amountText = this.mAmount > 1 ? this.mAmount + "x " : "";
                  cardName = cardDef ? ": " + amountText + cardDef.getName() : "";
                  Utils.setLogText(TextManager.getText("TID_CARD_RECEIVED") + cardName);
                  giftInfo["card"] = this.mAmount + "x " + this.mSku + "(" + cardName + ")";
                  break;
               case REWARD_TYPE_PACK:
                  packDef = PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.mSku));
                  goldDef = GoldDef(InstanceMng.getGoldDefMng().getDefBySku(this.mSku));
                  bundleDef = BundleDef(InstanceMng.getBundlesDefMng().getDefBySku(this.mSku));
                  if(packDef)
                  {
                     lootsLeftToClaim = this.mParentPopup ? this.mParentPopup.getRewardsAmount() : 0;
                     if(lootsLeftToClaim == 1)
                     {
                        if(this.mParentPopup)
                        {
                           this.mParentPopup.closePopup(openPack);
                        }
                     }
                     else
                     {
                        if(Boolean(this.mParentPopup) && Boolean(this.mParentPopup.getScrollcontainer()))
                        {
                           this.mParentPopup.getScrollcontainer().touchable = false;
                        }
                        this.checkIfJobsPack(packDef);
                     }
                  }
                  else if(goldDef)
                  {
                     ownerUserData.addGold(goldDef.getGold());
                     ticketDef = AuctionTicketDef(InstanceMng.getAuctionTicketsDefMng().getDefBySku(this.mSku));
                     if(ticketDef)
                     {
                        ownerUserData.addAuctionTickets(ticketDef.getTokens());
                        Utils.setLogText(TextManager.getText("TID_TOKENS_ADDED"));
                     }
                     if(this.mParentPopup)
                     {
                        if(this.mParentPopup.getScrollcontainer())
                        {
                           this.mParentPopup.getScrollcontainer().touchable = true;
                        }
                        this.mParentPopup.enableCloseButton(true);
                     }
                  }
                  else if(bundleDef)
                  {
                     lootsLeftToClaim = this.mParentPopup ? this.mParentPopup.getRewardsAmount() : 0;
                     if(lootsLeftToClaim == 1)
                     {
                        if(this.mParentPopup)
                        {
                           this.mParentPopup.closePopup(openBundle);
                        }
                     }
                     else
                     {
                        if(Boolean(this.mParentPopup) && Boolean(this.mParentPopup.getScrollcontainer()))
                        {
                           this.mParentPopup.getScrollcontainer().touchable = false;
                        }
                        openBundle();
                     }
                  }
                  giftInfo["pack"] = this.mAmount + "x " + this.mSku;
                  break;
               case REWARD_TYPE_PORTRAIT_SKIN:
                  if(Config.getConfig().hasSkins())
                  {
                     ownerUserData.addSkinToCatalog(this.mSku);
                     Utils.setLogText(TextManager.getText("TID_SKIN_RECEIVED"));
                     giftInfo["skin"] = this.mAmount + "x " + this.mSku;
                  }
                  else
                  {
                     ownerUserData.addPortraitToCatalog(this.mSku);
                     Utils.setLogText(TextManager.getText("TID_PORTRAIT_RECEIVED"));
                     giftInfo["portrait"] = this.mAmount + "x " + this.mSku;
                  }
                  break;
               case REWARD_TYPE_GOLD:
                  ownerUserData.addGold(this.mAmount);
                  Utils.setLogText(TextManager.getText("TID_AUCTIONS_INFO_GOLD"));
                  giftInfo["gold"] = "x " + this.mAmount;
                  break;
               case REWARD_TYPE_BOOSTS:
                  Utils.setLogText(TextManager.getText("TID_SHOP_BOOST_SUCCESS"),false,false,false);
                  shopBoostDef = ShopBoostDef(InstanceMng.getShopBoostsDefMng().getDefBySku(this.mSku));
                  if(shopBoostDef)
                  {
                     boostSku = shopBoostDef ? shopBoostDef.getBoostSku() : "";
                     if(Boolean(boostSku != "") && Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
                     {
                        currentAmount = InstanceMng.getUserDataMng().getOwnerUserData().getBoostAmount(boostSku);
                        if(Boolean(shopBoostDef) && Boolean(shopBoostDef.isRepurchasable()) || Boolean(shopBoostDef && !shopBoostDef.isRepurchasable()) && Boolean(currentAmount == 0))
                        {
                           InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(boostSku,1);
                           InstanceMng.getUserDataMng().updateBoosts();
                        }
                        if(Boolean(shopBoostDef && shopBoostDef.getExecuteOnBuy()) && Boolean(InstanceMng.getBoostsDefMng()) && Boolean(InstanceMng.getBoostsMng()))
                        {
                           boostDef = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(boostSku));
                           boost = InstanceMng.getBoostsMng().getBoost(boostDef);
                           if(boost != null)
                           {
                              boost.execute();
                           }
                        }
                     }
                  }
                  else
                  {
                     boostDef = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(this.mSku));
                     if(boostDef)
                     {
                        InstanceMng.getUserDataMng().getOwnerUserData().addBoostToCatalog(this.mSku,1);
                        InstanceMng.getUserDataMng().updateBoosts();
                     }
                  }
                  break;
               case REWARD_TYPE_RAID_POINTS:
                  ownerUserData.addRaidCoins(this.mAmount);
                  Utils.setLogText(TextManager.getText("TID_RAID_POINTS_ADDED"));
                  giftInfo["raidPoints"] = "x " + this.mAmount;
                  break;
               case REWARD_TYPE_TOKENS:
                  ownerUserData.addAuctionTickets(this.mAmount);
                  Utils.setLogText(TextManager.getText("TID_TOKENS_ADDED"));
                  giftInfo["ahTokens"] = "x " + this.mAmount;
                  break;
               case REWARD_TYPE_QUEST_COINS:
                  ownerUserData.addQuestsCoins(this.mAmount);
                  Utils.setLogText(TextManager.getText("TID_QUEST_POINTS_ADDED"));
                  giftInfo["questCoins"] = "x " + this.mAmount;
            }
            if(this.mType != 1)
            {
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
            switch(this.mOrigin)
            {
               case "PVP":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_PVP,FSTracker.ACTION_PVP_REWARD_CLAIMED,{
                     "sku":this.mSku,
                     "type":this.mType,
                     "amount":this.mAmount
                  });
                  break;
               case "DUNGEONS":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEONS,FSTracker.ACTION_DUNGEON_REWARD_CLAIMED,{
                     "sku":this.mSku,
                     "type":this.mType,
                     "amount":this.mAmount
                  });
                  break;
               case "RAIDS_SP":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_RAIDS,FSTracker.ACTION_RAIDS_REWARD_CLAIMED,{
                     "sku":this.mSku,
                     "type":this.mType,
                     "amount":this.mAmount,
                     "isMulti":false
                  });
                  if(Config.getConfig().hasQuests() && this.mType == 5 && Boolean(this.mRaidData))
                  {
                     InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_WIN_RAID_SP,1,true,null,null,this.mRaidData.raidSku,this.mRaidData.difficulty);
                  }
                  break;
               case "RAIDS_MP":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_RAIDS,FSTracker.ACTION_RAIDS_REWARD_CLAIMED,{
                     "sku":this.mSku,
                     "type":this.mType,
                     "amount":this.mAmount,
                     "isMulti":true
                  });
                  if(Config.getConfig().hasQuests() && this.mType == 5 && Boolean(this.mRaidData))
                  {
                     InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_TYPE_WIN_RAID_MP,1,true,null,null,this.mRaidData.raidSku,this.mRaidData.difficulty);
                  }
                  break;
               case "GUILDS":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_GUILDS,FSTracker.ACTION_GUILDS_REWARD_CLAIMED,{
                     "sku":this.mSku,
                     "type":this.mType,
                     "amount":this.mAmount
                  });
                  break;
               case "JOBS":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_JOBS,FSTracker.GUILDS_JOBS_REWARD_CLAIMED,{
                     "sku":this.mSku,
                     "type":this.mType,
                     "extraData":this.mExtraData.jobSku
                  });
                  break;
               case "LOGIN_FACEBOOK":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_FACEBOOK,FSTracker.ACTION_FB_LOGIN_REWARD_CLAIMED,{
                     "sku":this.mSku,
                     "type":this.mType
                  });
                  break;
               case "KONG_RATE":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_KONGREGATE,FSTracker.ACTION_KONG_RATE_REWARD_CLAIMED);
                  break;
               case "GIFTS":
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_GIFTS,FSTracker.ACTION_CLAIMED,giftInfo);
                  break;
               case "REFERRAL":
                  if(giftInfo != null)
                  {
                     giftInfo["referralType"] = Boolean(this.mRewardObjRaw) && this.mRewardObjRaw.hasOwnProperty("referralInfo") ? this.mRewardObjRaw["referralInfo"]["type"] : null;
                     giftInfo["referralAmount"] = Boolean(this.mRewardObjRaw) && this.mRewardObjRaw.hasOwnProperty("referralInfo") ? this.mRewardObjRaw["referralInfo"]["amount"] : null;
                     if(Boolean(this.mRewardObjRaw) && Boolean(this.mRewardObjRaw.hasOwnProperty("referralInfo")) && Boolean(this.mRewardObjRaw["referralInfo"].hasOwnProperty("recruitedId")))
                     {
                        giftInfo["recruitedId"] = Boolean(this.mRewardObjRaw) && this.mRewardObjRaw.hasOwnProperty("referralInfo") ? this.mRewardObjRaw["referralInfo"]["recruitedId"] : null;
                     }
                     if(Boolean(this.mRewardObjRaw) && Boolean(this.mRewardObjRaw.hasOwnProperty("referralInfo")) && Boolean(this.mRewardObjRaw["referralInfo"].hasOwnProperty("recruiterId")))
                     {
                        giftInfo["recruiterId"] = Boolean(this.mRewardObjRaw) && this.mRewardObjRaw.hasOwnProperty("referralInfo") ? this.mRewardObjRaw["referralInfo"]["recruiterId"] : null;
                     }
                  }
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_REFERRALS,FSTracker.ACTION_CLAIMED,giftInfo);
                  break;
               case "BATTLE_PASS":
                  if(giftInfo != null)
                  {
                     giftInfo["season"] = this.mRewardObjRaw["season"] + "-" + this.mRewardObjRaw["seasonYear"];
                     giftInfo["index"] = this.mRewardObjRaw["battlePassIndex"];
                     giftInfo["quest"] = this.mRewardObjRaw["battlePassQuestSku"];
                     giftInfo["chain_index"] = this.mRewardObjRaw["battlePassChainIndex"];
                     giftInfo["chain_fam_id"] = this.mRewardObjRaw["battlePassChainFamilyId"];
                     giftInfo["premium"] = this.mRewardObjRaw["isPremiumReward"];
                  }
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_BATTLE_PASS,FSTracker.ACTION_CLAIMED,giftInfo);
            }
            if(this.mParentPopup)
            {
               this.mParentPopup.onRewardClaimedCheckRewards(this.mRewardId);
            }
         }
      }
      
      private function isGoldBag() : Boolean
      {
         var _loc1_:GoldDef = GoldDef(InstanceMng.getGoldDefMng().getDefBySku(this.mSku));
         return _loc1_ != null;
      }
      
      private function isTokenBag() : Boolean
      {
         var _loc1_:AuctionTicketDef = AuctionTicketDef(InstanceMng.getAuctionTicketsDefMng().getDefBySku(this.mSku));
         return _loc1_ != null;
      }
      
      private function checkIfJobsPack(param1:PackDef) : void
      {
         var removeMapRewardPanelFromParent:Function = null;
         var packSku:String = null;
         var packAnimBG:String = null;
         var origin:String = null;
         var packCardsReward:Array = null;
         var j:int = 0;
         var jobDef:JobDef = null;
         var jobName:String = null;
         var tName:String = null;
         var desc:String = null;
         var packDef:PackDef = param1;
         removeMapRewardPanelFromParent = function():void
         {
            if(mMapRewardPanel)
            {
               mMapRewardPanel.removeFromParent();
            }
         };
         if(Boolean(packDef) && Boolean(Config.getConfig().gameHasClassSystem()) && this.mOrigin == "JOBS")
         {
            if(packDef.areCardsPredefined())
            {
               packCardsReward = packDef.getSpecialCardsArr();
               if(packCardsReward != null)
               {
                  j = 0;
                  while(j < packCardsReward.length)
                  {
                     InstanceMng.getUserDataMng().getOwnerUserData().addCardToCollection(packCardsReward[j]);
                     InstanceMng.getUserDataMng().getOwnerUserData().addCardToNewCardsCollection(packCardsReward[j]);
                     j++;
                  }
               }
               InstanceMng.getUserDataMng().persistenceSaveData();
            }
            packSku = Boolean(this.mExtraData) && Boolean(this.mExtraData.hasOwnProperty("chestBG")) && this.mExtraData["chestBG"] != null ? this.mExtraData["chestBG"] : "";
            packDef = packSku != "" && packSku != null ? PackDef(InstanceMng.getPacksDefMng().getDefBySku(packSku)) : null;
            packAnimBG = packDef ? packDef.getAnimBG() : packSku;
            origin = packDef.areCardsPredefined() ? PacksDefMng.PACK_REWARD_PREDEFINED : PacksDefMng.PACK_REWARD;
            Utils.openPack(packDef,origin,null,false,packAnimBG);
            if(this.mRewardObjRaw)
            {
               jobDef = JobDef(InstanceMng.getJobsDefMng().getDefBySku(this.mExtraData.jobSku));
               if(jobDef)
               {
                  jobName = jobDef.getName();
                  if(this.mMapRewardPanel == null)
                  {
                     tName = jobDef.getBgIcon();
                     desc = TextManager.replaceParameters(TextManager.getText("TID_GEN_CHAR_LEVEL"),[this.mRewardObjRaw.levelGained]) + " (" + jobName + ")";
                     this.mMapRewardPanel = new MapRewardPanel(TextManager.getText("TID_GEN_CONGRATULATIONS"),desc,tName);
                     this.mMapRewardPanel.alpha = 0;
                     setTimeout(SpecialFX.tweenToAlpha,2000,this.mMapRewardPanel,1,1.5,0);
                     setTimeout(SpecialFX.tweenToAlpha,7000,this.mMapRewardPanel,0,2,0,removeMapRewardPanelFromParent);
                     InstanceMng.getCurrentScreen().addChild(this.mMapRewardPanel);
                  }
               }
            }
         }
         else
         {
            Utils.openPack(packDef,PacksDefMng.PACK_ANY);
            Utils.setLogText(TextManager.getText("TID_PACK_RECEIVED"));
         }
      }
      
      private function getOriginBGName(param1:String) : String
      {
         var _loc3_:JobDef = null;
         var _loc2_:String = "";
         switch(param1)
         {
            case "PVP":
               return this.BG_PVP;
            case "DUNGEONS":
               return this.BG_DUNGEONS;
            case "RAIDS_SP":
               return this.BG_RAIDS_SP;
            case "RAIDS_MP":
               return this.BG_RAIDS_MP;
            case "GUILDS":
               return this.BG_GUILDS;
            case "JOBS":
               _loc3_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(this.mExtraData.jobSku));
               if(_loc3_)
               {
                  return _loc3_.getBgIcon();
               }
               break;
            case "LOGIN_FACEBOOK":
               return this.BG_FB_LOGIN;
            case "KONG_RATE":
               return this.BG_KONG_RATE;
            case "GIFTS":
            case "REFERRAL":
               return this.BG_GIFT;
            case "BATTLE_PASS":
               return this.BG_BATTLE_PASS;
         }
         return _loc2_;
      }
      
      private function getTypeBGName(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 0:
               return BG_CARDS;
            case 1:
               if(this.isGoldBag())
               {
                  return this.BG_GOLD;
               }
               if(this.isTokenBag())
               {
                  return this.BG_TOKENS;
               }
               return this.BG_PACKS;
               break;
            case 2:
               return Config.getConfig().hasSkins() ? this.BG_SKIN : this.BG_PORTRAITS;
            case 3:
               return this.BG_GOLD;
            case 4:
               return this.BG_PACKS;
            case 5:
               return this.BG_RAID_POINTS;
            case 6:
               return this.BG_TOKENS;
            case 7:
               return QuestSlot.QUESTSLOT_CURRENCY_ICON_BG;
            default:
               return _loc2_;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGOrigin)
         {
            this.mBGOrigin.removeFromParent(true);
            this.mBGOrigin = null;
         }
         if(this.mBGType)
         {
            this.mBGType.removeFromParent(true);
            this.mBGType = null;
         }
         if(this.mDescTextfield)
         {
            this.mDescTextfield.removeFromParent(true);
            this.mDescTextfield = null;
         }
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
            this.mAmountTextfield = null;
         }
         if(this.mMapRewardPanel)
         {
            this.mMapRewardPanel.removeFromParent(true);
            this.mMapRewardPanel = null;
         }
         removeChildren(0,-1,true);
         this.mParentPopup = null;
         this.mExtraData = null;
         this.mRaidData = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

