package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class BundlesDefMng extends DefMng
   {
      
      public function BundlesDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new BundleDef();
      }
      
      public function getBundlesUnlockedByQuest(param1:String) : BundleDef
      {
         var _loc2_:Dictionary = getAllDefs();
         var _loc3_:BundleDef = null;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getUnlockedByQuest() == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getCustomOfferToShowInShop() : BundleDef
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:BundleDef = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(Boolean(_loc2_) && Boolean(ServerConnection.smServerTimeMS))
         {
            if(_loc2_.hasAnyCustomOfferActive())
            {
               _loc3_ = _loc2_.getCustomOfferShownSku();
               if(_loc3_ != "" && Boolean(_loc3_))
               {
                  return BundleDef(getDefBySku(_loc3_));
               }
            }
            else
            {
               _loc1_ = this.getBestBundleToShow();
               if(_loc1_)
               {
                  _loc4_ = ServerConnection.smServerTimeMS + TimerUtil.daysToMs(_loc1_.getDuration());
                  _loc2_.setCustomOfferShown(_loc1_.getSku() + ":" + _loc4_);
                  _loc2_.addCustomOfferView(_loc1_.getSku());
                  _loc5_ = TimerUtil.daysToMs(4);
                  _loc6_ = _loc4_ + (_loc5_ + Utils.randomInt(0,4));
                  _loc2_.setCustomOfferNextVisibleDateMS(_loc6_);
                  _loc2_.setCustomOfferNewBannerShown(true);
                  InstanceMng.getUserDataMng().persistenceSaveData();
               }
            }
         }
         return _loc1_;
      }
      
      public function getWelcomeBackBundle() : BundleDef
      {
         var _loc5_:BundleDef = null;
         var _loc1_:BundleDef = null;
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:Boolean = _loc2_ ? _loc2_.isPayingUser() : false;
         var _loc4_:Boolean = _loc2_ ? _loc2_.isOldPlayerComingBack() : false;
         if(Boolean(_loc2_) && Boolean(ServerConnection.smServerTimeMS) && _loc4_)
         {
            for each(_loc5_ in mDefsBySku)
            {
               if(_loc5_.isWelcomeBackBundle() && (_loc3_ && _loc5_.shopDisplayOnlyToPayingUsers() || !_loc3_ && !_loc5_.shopDisplayOnlyToPayingUsers()))
               {
                  return _loc5_;
               }
            }
         }
         return _loc1_;
      }
      
      public function getServerManualOffer() : BundleDef
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc1_:BundleDef = null;
         if(Config.smShopManualOffer != "" && Config.smShopManualOffer != null)
         {
            _loc2_ = Config.smShopManualOffer["sku"] != null && Config.smShopManualOffer["sku"] != "" ? Config.smShopManualOffer["sku"] : "";
            _loc1_ = Boolean(_loc2_) && _loc2_ != "" ? BundleDef(InstanceMng.getBundlesDefMng().getDefBySku(_loc2_)) : null;
            if(_loc1_)
            {
               _loc3_ = Config.smShopManualOffer["manualId"] != null && Config.smShopManualOffer["manualId"] != "" ? Config.smShopManualOffer["manualId"] : "";
               _loc4_ = Config.smShopManualOffer["repurchasable"] != null ? Config.smShopManualOffer["repurchasable"] == 1 : false;
               _loc5_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().isCustomOfferPurchased(_loc3_) : false;
               if(!(_loc3_ != null && _loc3_ != "" && (_loc4_ || !_loc4_ && !_loc5_)))
               {
                  return null;
               }
               _loc1_.resetTemporaryData();
               _loc1_.setSku(_loc2_);
               if(Config.smShopManualOffer["gold"] > 0)
               {
                  _loc1_.setGold(Config.smShopManualOffer["gold"]);
               }
               if(Config.smShopManualOffer["raidPoints"] > 0)
               {
                  _loc1_.setRaidPoints(Config.smShopManualOffer["raidPoints"]);
               }
               if(Config.smShopManualOffer["questPoints"] > 0)
               {
                  _loc1_.setQuestPoints(Config.smShopManualOffer["questPoints"]);
               }
               if(Config.smShopManualOffer["tokens"] > 0)
               {
                  _loc1_.setAHTokens(Config.smShopManualOffer["tokens"]);
               }
               if(Config.smShopManualOffer["cards"] != null && Config.smShopManualOffer["cards"] != "")
               {
                  _loc1_.setCards(Config.smShopManualOffer["cards"]);
               }
               if(Config.smShopManualOffer["packs"] != null && Config.smShopManualOffer["packs"] != "")
               {
                  _loc1_.setPacks(Config.smShopManualOffer["packs"]);
               }
               if(Config.smShopManualOffer["skins"] != null && Config.smShopManualOffer["skins"] != "")
               {
                  _loc1_.setSkins(Config.smShopManualOffer["skins"]);
               }
               if(Config.smShopManualOffer["boosts"] != null && Config.smShopManualOffer["boosts"] != "")
               {
                  _loc1_.setBoosts(Config.smShopManualOffer["boosts"]);
               }
               if(Config.smShopManualOffer["chestBG"] != null && Config.smShopManualOffer["chestBG"] != "")
               {
                  _loc1_.setChestBG(Config.smShopManualOffer["chestBG"]);
               }
               if(Config.smShopManualOffer["discount"] > 0)
               {
                  _loc1_.setDiscount(Config.smShopManualOffer["discount"]);
               }
               if(Config.smShopManualOffer["name"] != null && Config.smShopManualOffer["name"] != "")
               {
                  _loc6_ = TextManager.getText(Config.smShopManualOffer["name"]) != null ? Config.smShopManualOffer["name"] : "TID_SHOP_SPECIAL_OFFER";
                  _loc1_.setName(_loc6_);
               }
               if(Config.smShopManualOffer["manualId"] != null && Config.smShopManualOffer["manualId"] != "")
               {
                  _loc1_.setManualId(Config.smShopManualOffer["manualId"]);
                  _loc1_.setIsRepurchasable(Config.smShopManualOffer["repurchasable"] == 1);
               }
               if(Config.smShopManualOffer["expirationTimeMS"] > 0)
               {
                  _loc1_.setExpirationTimeMS(Config.smShopManualOffer["expirationTimeMS"]);
               }
            }
         }
         return _loc1_;
      }
      
      private function getAllAvailableOffersFiltered() : Array
      {
         var _loc1_:Array = null;
         var _loc3_:BundleDef = null;
         var _loc5_:String = null;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:Array = null;
         var _loc4_:UserData = Utils.getOwnerUserData();
         var _loc6_:int = -1;
         var _loc7_:int = -1;
         var _loc8_:Boolean = this.canShowAlreadyDisplayedBundles();
         for each(_loc3_ in mDefsBySku)
         {
            _loc5_ = _loc3_.getUnlockedByQuest();
            if(Boolean(!_loc3_.isManualOffer() && _loc5_) && Boolean(_loc4_.isQuestCompleted(_loc5_)) && !_loc4_.isCustomOfferPurchased(_loc3_.getSku()))
            {
               if(_loc1_ == null)
               {
                  _loc1_ = new Array();
               }
               _loc7_ = _loc4_.getCustomOfferViewsCountBySku(_loc3_.getSku());
               if(_loc6_ == -1 || _loc7_ >= 0 && _loc7_ <= _loc6_)
               {
                  if(_loc7_ == 0 || _loc7_ > 0 && _loc8_)
                  {
                     _loc9_ = {};
                     _loc9_["bundleDef"] = _loc3_;
                     _loc9_["views"] = _loc7_;
                     _loc6_ = _loc7_ < _loc6_ || _loc6_ == -1 ? _loc7_ : _loc6_;
                     _loc1_.push(_loc9_);
                  }
               }
            }
         }
         if(_loc1_)
         {
            _loc1_.sort(DictionaryUtils.sortBundlesByViewsCount);
         }
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            _loc10_ = int(_loc1_[0]["views"]);
            _loc11_ = 0;
            while(_loc11_ < _loc1_.length)
            {
               if(_loc1_[_loc11_]["views"] <= _loc10_)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Array();
                  }
                  _loc2_.push(_loc1_[_loc11_]);
               }
               _loc11_++;
            }
         }
         return _loc2_;
      }
      
      private function getBestBundleToShow() : BundleDef
      {
         var _loc3_:int = 0;
         var _loc1_:BundleDef = null;
         var _loc2_:Array = this.getAllAvailableOffersFiltered();
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc3_ = _loc2_.length > 1 ? Utils.randomInt(0,_loc2_.length - 1) : 0;
            _loc1_ = _loc2_[_loc3_]["bundleDef"];
         }
         return _loc1_;
      }
      
      private function canShowAlreadyDisplayedBundles() : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc1_:Boolean = false;
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(Boolean(_loc2_) && Boolean(ServerConnection.smServerTimeMS))
         {
            _loc3_ = _loc2_.getCustomOfferNextVisibleDateMS();
            _loc1_ = _loc3_ == 0 || ServerConnection.smServerTimeMS >= _loc3_;
         }
         return _loc1_;
      }
   }
}

