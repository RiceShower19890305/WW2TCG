package com.fs.tcgengine.controller
{
   import com.adobe.serialization.json.JSON;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.DeckSlotDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GoldDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.shop.FSShopItem;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyDeckSlot;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyPostBoost;
   import com.fs.tcgengine.view.popups.purchases.PopupBuyProduct;
   import com.fs.tcgengine.view.popups.purchases.PopupShopItem;
   import com.fs.tcgengine.view.popups.raids.PopupRaidLevelFailed;
   import com.gamesparks.api.types.VirtualGood;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import mx.utils.ObjectUtil;
   
   public class FSInAppsManager extends EventDispatcher
   {
      
      public static var smCurrencyCode:String;
      
      public static var mProductsArr:Array;
      
      public static var mVGoodsCatalog:Dictionary;
      
      public static var mPlayerVGoods:Object;
      
      public static var smProductsPriceInUSD:Dictionary;
      
      public static const PRODUCTS_REQUESTED:String = "PRODUCTS_REQUESTED";
      
      public static const PRODUCT_PURCHASED_OK:String = "PRODUCT_PURCHASED_OK";
      
      public static const PRODUCT_PURCHASED_KO:String = "PRODUCT_PURCHASED_KO";
      
      public static const PRODUCT_PURCHASE_PENDING:String = "PRODUCT_PURCHASE_PENDING";
      
      public static const PRODUCT_PURCHASE_ERROR:String = "PRODUCT_PURCHASE_ERROR";
      
      public static const PRODUCT_PURCHASE_CANCELLED:String = "PRODUCT_PURCHASE_CANCELLED";
      
      public static var smCurrencySymbol:String = "";
      
      public var mCurrentProdIdBeingPurchased:String;
      
      private var mUnprocessedProdIds:Vector.<String>;
      
      public var mSupportedCurrencies:Object;
      
      protected var mAreInappPurchasesSetup:Boolean = false;
      
      private var mProductsInfoCatalog:Dictionary;
      
      private var mPlayerGoodsRestored:Boolean;
      
      public function FSInAppsManager()
      {
         super();
      }
      
      public function getCurrentProdIdBeingPurchased() : String
      {
         return this.mCurrentProdIdBeingPurchased;
      }
      
      public function setCurrentProdIdBeingPurchased(param1:String) : void
      {
         this.mCurrentProdIdBeingPurchased = param1;
      }
      
      public function requestProducts(param1:Array) : void
      {
         InstanceMng.getApplication().requestProducts(param1);
      }
      
      public function onProductPurchasedOkProcessProdId(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Screen = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:FSShopItem = null;
         FSDebug.debugTrace("Product purchased OK");
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PURCHASE,FSTracker.ACTION_CONSUMED,{"prodId":param1});
         if(Boolean(InstanceMng.getServerConnection()) && this.areProductsPricesUpToDate())
         {
            this.mCurrentProdIdBeingPurchased = "";
            _loc4_ = "";
            _loc5_ = InstanceMng.getCurrentScreen();
            if(_loc5_ != null && !param2)
            {
               _loc8_ = false;
               if(_loc5_ is FSShopScreen)
               {
                  _loc9_ = FSShopScreen(_loc5_).getItemBeingPurchased();
                  if(_loc9_ != null)
                  {
                     _loc3_ = _loc9_.getProdId();
                     if(param1.toLowerCase() == _loc3_.toLowerCase())
                     {
                        _loc8_ = true;
                        if(_loc9_.getDef() is CardDef || _loc9_.getDef() is BundleDef || _loc9_.getDef() is PackDef)
                        {
                           _loc4_ = _loc9_.getDef().getSku();
                        }
                     }
                  }
                  if(!_loc8_)
                  {
                     _loc8_ = this.addProductByProdId(param1);
                  }
                  if(!_loc8_)
                  {
                     Utils.setLogText(TextManager.getText("TID_SHOP_SUPPORT"));
                  }
                  FSShopScreen(_loc5_).onItemPurchasedOK(param1);
               }
               else
               {
                  if(InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
                  {
                     _loc8_ = this.onNonShopProdOK();
                     if(!_loc8_)
                     {
                        _loc8_ = this.addProductByProdId(param1);
                     }
                  }
                  else
                  {
                     _loc8_ = this.addProductByProdId(param1);
                  }
                  if(_loc5_ is FSBattleScreen)
                  {
                     FSBattleScreen.smUserPayedInThisLevel = true;
                  }
               }
            }
            if(param1)
            {
               _loc3_ = Utils.isAndroidOrDesktop() ? param1.toLowerCase() : param1;
            }
            _loc6_ = this.getPriceByProdId(_loc3_);
            _loc6_ = _loc6_ ? _loc6_.replace(",",".") : "";
            _loc7_ = _loc6_ ? _loc6_.split(" ")[0] : "???";
            if(_loc7_ == "$0.0" || _loc7_.toLowerCase() == "purchased")
            {
               InstanceMng.getServerConnection().addUserToBlackList();
            }
            else
            {
               if(InstanceMng.getUserDataMng().getOwnerUserData())
               {
                  InstanceMng.getUserDataMng().getOwnerUserData().increasePurchasesAmount();
               }
               if(Boolean(InstanceMng.getBattleEngine()) && _loc4_ == "")
               {
                  if(Root.smBattleData != null)
                  {
                     if(Root.smBattleData.isDungeon)
                     {
                        _loc4_ = "Dungeon";
                     }
                     else if(Root.smBattleData.isRaid)
                     {
                        _loc4_ = "Raid";
                     }
                     else
                     {
                        _loc4_ = "Level";
                     }
                  }
               }
               if(Utils.isMobile())
               {
                  this.trackMobilePurchase(_loc3_);
               }
               if(!param2)
               {
                  FSTracker.getInstance().trackPurchase(param1,_loc4_,_loc8_,_loc6_);
               }
            }
         }
         else
         {
            if(this.mUnprocessedProdIds == null)
            {
               this.mUnprocessedProdIds = new Vector.<String>();
            }
            this.mUnprocessedProdIds.push(param1);
            if(InstanceMng.getServerConnection())
            {
               InstanceMng.getServerConnection().getProducts();
            }
         }
      }
      
      public function trackMobilePurchase(param1:String) : void
      {
      }
      
      public function processUnconsumedProds() : void
      {
         var _loc1_:int = 0;
         if(Boolean(Utils.smInternetAvailable) && Boolean(InstanceMng.getServerConnection()) && this.areProductsPricesUpToDate())
         {
            if(Boolean(this.mUnprocessedProdIds) && this.mUnprocessedProdIds.length > 0)
            {
               _loc1_ = 0;
               while(_loc1_ < this.mUnprocessedProdIds.length)
               {
                  this.processUnconsumedProduct(this.mUnprocessedProdIds[_loc1_]);
                  _loc1_++;
               }
               this.mUnprocessedProdIds.length = 0;
               this.mUnprocessedProdIds = null;
            }
         }
      }
      
      public function processUnconsumedProduct(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         if(param1 != "" && param1 != null)
         {
            _loc2_ = this.addProductByProdId(param1,true,true);
            if(!_loc2_)
            {
               Utils.setLogText(TextManager.getText("TID_SHOP_SUPPORT"));
            }
            param1 = Utils.isAndroidOrDesktop() ? param1.toLowerCase() : param1;
            _loc3_ = this.getPriceByProdId(param1);
            _loc4_ = this.isProductRePurchasableByProdId(param1);
            _loc3_ = _loc3_.replace(",",".");
            _loc5_ = _loc3_.split(" ")[0];
            if(_loc5_ == "$0.0" || _loc5_.toLowerCase() == "purchased")
            {
               InstanceMng.getServerConnection().addUserToBlackList();
            }
            else if(_loc4_)
            {
               FSTracker.getInstance().trackPurchase(param1,"(Unconsumed now processed)",true,_loc3_);
            }
         }
      }
      
      public function onNonShopProdOK() : Boolean
      {
         var _loc2_:Popup = null;
         var _loc1_:Boolean = false;
         if(InstanceMng.getPopupMng() != null)
         {
            _loc2_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc2_)
            {
               if(_loc2_ is PopupBuyPostBoost)
               {
                  PopupBuyPostBoost(_loc2_).onPurchaseSuccesful();
                  _loc1_ = true;
               }
               else if(_loc2_ is PopupBuyProduct)
               {
                  PopupBuyProduct(_loc2_).onPurchaseSuccesful();
                  _loc1_ = true;
               }
               else if(_loc2_ is PopupShopItem)
               {
                  PopupShopItem(_loc2_).onPurchaseSuccesful();
                  _loc1_ = true;
               }
               else if(_loc2_ is PopupBuyDeckSlot)
               {
                  PopupBuyDeckSlot(_loc2_).onPurchaseSuccesful();
                  _loc1_ = true;
               }
               else if(_loc2_ is PopupShopItem)
               {
                  PopupShopItem(_loc2_).onPurchaseSuccesful();
                  _loc1_ = true;
               }
            }
         }
         return _loc1_;
      }
      
      public function onNonShopProdKO() : void
      {
         var _loc1_:Popup = null;
         if(InstanceMng.getPopupMng() != null)
         {
            _loc1_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc1_)
            {
               if(_loc1_ is PopupBuyProduct)
               {
                  PopupBuyProduct(_loc1_).onPurchaseFailed();
               }
               else if(_loc1_ is PopupShopItem)
               {
                  PopupShopItem(_loc1_).onPurchaseFailed();
               }
               BattleEngine.smFillAPBoostRecentlyPurchased = false;
            }
         }
      }
      
      public function addProductByProdId(param1:String, param2:Boolean = true, param3:Boolean = false) : Boolean
      {
         var def:Def = null;
         var lastPurchaseAttemptSku:String = null;
         var compositeCardItem:String = null;
         var prodId:String = param1;
         var notifyViaLog:Boolean = param2;
         var isAutoReimburse:Boolean = param3;
         var performBoughtOps:Function = function():void
         {
            var _loc1_:FSShopItem = new FSShopItem(def,false,null,true);
            _loc1_.performOnBoughtOperations(notifyViaLog);
         };
         var returnValue:Boolean = false;
         if(prodId == null)
         {
            return false;
         }
         prodId = Utils.isAndroidOrDesktop() ? prodId.toLowerCase() : prodId;
         InstanceMng.getServerConnection().createRestorationHistoryInstance(prodId);
         def = Utils.getShopItemByProdId(prodId);
         if(def != null)
         {
            lastPurchaseAttemptSku = InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSShopScreen ? FSShopScreen(InstanceMng.getCurrentScreen()).getLastPurchaseAttemptSku() : "";
            if(def is CardDef)
            {
               if(!isAutoReimburse)
               {
                  if(lastPurchaseAttemptSku != "" && lastPurchaseAttemptSku != null)
                  {
                     returnValue = true;
                     compositeCardItem = lastPurchaseAttemptSku + ":1";
                     InstanceMng.getUserDataMng().getOwnerUserData().addCardToCollection(compositeCardItem);
                     InstanceMng.getUserDataMng().getOwnerUserData().addCardToNewCardsCollection(compositeCardItem);
                     InstanceMng.getUserDataMng().persistenceSaveData();
                     FSShopScreen(InstanceMng.getCurrentScreen()).cleanLastPurchaseAttemptSku();
                     if(notifyViaLog)
                     {
                        Utils.setLogText(TextManager.getText("TID_SHOP_CARD_SUCCESS"));
                     }
                  }
               }
            }
            else if(def is BundleDef)
            {
               if(!isAutoReimburse)
               {
                  if(lastPurchaseAttemptSku != "" && lastPurchaseAttemptSku != null)
                  {
                     returnValue = true;
                     def = BundleDef(InstanceMng.getBundlesDefMng().getDefBySku(lastPurchaseAttemptSku));
                     performBoughtOps();
                     if(InstanceMng.getCurrentScreen() is FSShopScreen)
                     {
                        FSShopScreen(InstanceMng.getCurrentScreen()).cleanLastPurchaseAttemptSku();
                     }
                     if(notifyViaLog)
                     {
                        Utils.setLogText(TextManager.getText("TID_SHOP_CARD_SUCCESS"));
                     }
                  }
               }
            }
            else if(def is ShopBoostDef || def is BoostDef)
            {
               returnValue = true;
               if(InstanceMng.getBattleEngine() != null && !InstanceMng.getBattleEngine().isPvPMatch())
               {
                  BattleEngine.smFillAPBoostRecentlyPurchased = true;
               }
               performBoughtOps();
            }
            else if(def is DeckSlotDef)
            {
               returnValue = true;
               InstanceMng.getUserDataMng().userPurchasedDeck(DeckSlotDef(def).getIndex(),notifyViaLog);
            }
            else
            {
               returnValue = true;
               if(!isAutoReimburse)
               {
                  performBoughtOps();
               }
            }
         }
         else
         {
            FSDebug.debugTrace("[addProductByProdId] ProdId: " + prodId + " not found by def");
         }
         return returnValue;
      }
      
      public function rollNonPayerNextAction(param1:int = 7, param2:int = 2) : void
      {
         if(InstanceMng.getUserDataMng().isEligibleToVIPPack() && Utils.randomInt(0,9) <= param2)
         {
            if(Boolean(InstanceMng.getCurrentScreen() is FSMapScreen) && Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen().isFullyLoaded())
            {
               this.onRollShowVIPPack();
            }
         }
      }
      
      private function onRollShowVIPPack() : void
      {
         var _loc4_:Def = null;
         var _loc1_:String = !Utils.isBrowser() ? Config.getConfig().getAppNameSpace() : "";
         var _loc2_:String = !Utils.isBrowser() ? "." : "";
         var _loc3_:String = InstanceMng.getApplication().isKongregateVersion() ? "packs-PACK_VIP" : "packs.PACK_VIP";
         if(Config.getConfig().getGameVipOfferGold())
         {
            _loc4_ = GoldDef(InstanceMng.getGoldDefMng().getDefByProdId(_loc1_ + _loc2_ + _loc3_));
         }
         else
         {
            _loc4_ = PackDef(InstanceMng.getPacksDefMng().getDefByProdId(_loc1_ + _loc2_ + _loc3_));
         }
         if(InstanceMng.getPopupMng().getPopupShown() == null)
         {
            InstanceMng.getPopupMng().openBuyVIPPackPopup(_loc4_);
         }
      }
      
      public function addBrowserEventListeners() : void
      {
         this.fillSupportedFBCurrencies();
         addEventListener(PRODUCTS_REQUESTED,this.onProductsRequested);
         addEventListener(PRODUCT_PURCHASED_OK,this.onProductPurchasedOk);
         addEventListener(PRODUCT_PURCHASED_KO,this.onProductPurchasedKo);
         addEventListener(PRODUCT_PURCHASE_PENDING,this.onProductPurchasedPending);
         addEventListener(PRODUCT_PURCHASE_CANCELLED,this.onProductPurchasedCancelled);
         addEventListener(PRODUCT_PURCHASE_ERROR,this.onProductPurchasedFailed);
      }
      
      public function fillSupportedFBCurrencies() : void
      {
         this.mSupportedCurrencies = {
            "USD":{
               "symbol":"&#36;",
               "pre":true
            },
            "SGD":{
               "symbol":"S&#36;",
               "pre":true
            },
            "RON":{
               "symbol":"LEU",
               "pre":false
            },
            "EUR":{
               "symbol":"&#8364;",
               "pre":false
            },
            "TRY":{
               "symbol":"&#8378;",
               "pre":true
            },
            "SEK":{
               "symbol":"kr",
               "pre":false
            },
            "ZAR":{
               "symbol":"R",
               "pre":true
            },
            "BHD":{
               "symbol":"BD",
               "pre":true
            },
            "HKD":{
               "symbol":"HK&#36;",
               "pre":true
            },
            "CHF":{
               "symbol":"Fr.",
               "pre":false
            },
            "NIO":{
               "symbol":"C&#36;",
               "pre":true
            },
            "JPY":{
               "symbol":"&#165;",
               "pre":true
            },
            "ISK":{
               "symbol":"kr;",
               "pre":false
            },
            "TWD":{
               "symbol":"NT&#36;",
               "pre":true
            },
            "NZD":{
               "symbol":"NZ&#36;",
               "pre":true
            },
            "CZK":{
               "symbol":"K&#269;",
               "pre":true
            },
            "AUD":{
               "symbol":"A&#36;",
               "pre":true
            },
            "THB":{
               "symbol":"&#3647;",
               "pre":true
            },
            "BOB":{
               "symbol":"Bs",
               "pre":true
            },
            "BRL":{
               "symbol":"B&#36;",
               "pre":true
            },
            "MXN":{
               "symbol":"Mex&#36;",
               "pre":true
            },
            "ILS":{
               "symbol":"&#8362;",
               "pre":true
            },
            "JOD":{
               "symbol":"JD",
               "pre":false
            },
            "HNL":{
               "symbol":"L",
               "pre":true
            },
            "MOP":{
               "symbol":"MOP&#36;",
               "pre":true
            },
            "COP":{
               "symbol":"&#36;",
               "pre":true
            },
            "UYU":{
               "symbol":"&#36;U",
               "pre":true
            },
            "CRC":{
               "symbol":"&#8353;",
               "pre":true
            },
            "DKK":{
               "symbol":"kr",
               "pre":false
            },
            "QAR":{
               "symbol":"QR",
               "pre":false
            },
            "PYG":{
               "symbol":"&#8370;",
               "pre":true
            },
            "EGP":{
               "symbol":"E&#163;",
               "pre":true
            },
            "CAD":{
               "symbol":"C&#36;",
               "pre":true
            },
            "LVL":{
               "symbol":"Ls",
               "pre":true
            },
            "INR":{
               "symbol":"&#8377;",
               "pre":true
            },
            "LTL":{
               "symbol":"Lt;",
               "pre":false
            },
            "KRW":{
               "symbol":"&#8361;",
               "pre":true
            },
            "GTQ":{
               "symbol":"Q",
               "pre":true
            },
            "AED":{
               "symbol":"AED",
               "pre":false
            },
            "VEF":{
               "symbol":"Bs.F.",
               "pre":true
            },
            "SAR":{
               "symbol":"SR",
               "pre":false
            },
            "NOK":{
               "symbol":"kr",
               "pre":false
            },
            "UAH":{
               "symbol":"&#8372;",
               "pre":true
            },
            "DOP":{
               "symbol":"RD&#36;",
               "pre":true
            },
            "CNY":{
               "symbol":"&#165;",
               "pre":true
            },
            "BGN":{
               "symbol":"lev",
               "pre":false
            },
            "ARS":{
               "symbol":"&#36;",
               "pre":true
            },
            "PLN":{
               "symbol":"z&#322;",
               "pre":false
            },
            "GBP":{
               "symbol":"&#163;",
               "pre":true
            },
            "PEN":{
               "symbol":"S/.",
               "pre":false
            },
            "PHP":{
               "symbol":"PhP",
               "pre":false
            },
            "VND":{
               "symbol":"&#8363;",
               "pre":false
            },
            "RUB":{
               "symbol":"py&#1073;",
               "pre":false
            },
            "RSD":{
               "symbol":"RSD",
               "pre":false
            },
            "HUF":{
               "symbol":"Ft",
               "pre":false
            },
            "MYR":{
               "symbol":"RM",
               "pre":true
            },
            "CLP":{
               "symbol":"&#36;",
               "pre":true
            },
            "HRK":{
               "symbol":"kn",
               "pre":false
            },
            "IDR":{
               "symbol":"Rp",
               "pre":true
            }
         };
      }
      
      public function addInAppBillingEvListeners() : void
      {
      }
      
      public function buyProduct(param1:String) : void
      {
      }
      
      public function backendRestorePurchases() : void
      {
      }
      
      public function gsFinishAIRPurchase(param1:*, param2:int = 0, param3:Boolean = true, param4:Boolean = false, param5:Function = null, param6:Array = null, param7:Function = null, param8:Array = null) : void
      {
      }
      
      public function consumeProduct(param1:String, param2:Boolean = false, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null) : void
      {
      }
      
      public function getSupportedCurrencies() : Object
      {
         return this.mSupportedCurrencies;
      }
      
      public function getPendingPurchases() : void
      {
      }
      
      public function processVGoods() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Def = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:UserData = null;
         var _loc11_:int = 0;
         if(Boolean(mPlayerVGoods) && !this.mPlayerGoodsRestored)
         {
            _loc1_ = DictionaryUtils.getKeys(mPlayerVGoods);
            if(_loc1_)
            {
               this.mPlayerGoodsRestored = true;
               _loc2_ = 0;
               for(; _loc2_ < _loc1_.length; _loc2_++)
               {
                  if(!(mVGoodsCatalog != null && mVGoodsCatalog[_loc1_[_loc2_]] == null))
                  {
                     _loc8_ = new Object();
                     _loc4_ = Utils.getShopItemByShortCode(_loc1_[_loc2_]);
                     _loc5_ = int(mPlayerVGoods[_loc1_[_loc2_]]);
                     _loc8_.sku = _loc1_[_loc2_];
                     _loc8_.amount = 1;
                     _loc8_.type = this.getGiftTypeByVirtualGood(_loc8_);
                     _loc8_.uid = InstanceMng.getServerConnection().getUserId();
                     _loc6_ = this.isProductPermanent(_loc8_);
                     _loc8_.sku = _loc4_ ? _loc4_.getSku() : "";
                     if(_loc8_.type != -1)
                     {
                        if(_loc6_)
                        {
                           _loc10_ = Utils.getOwnerUserData();
                           if((Boolean(_loc10_)) && Boolean(_loc4_))
                           {
                              _loc11_ = _loc10_.getBoostAmount(_loc4_.getSku());
                              if(_loc11_ > 0)
                              {
                                 continue;
                              }
                           }
                        }
                        _loc8_.origin = "GIFTS";
                        _loc8_.from = "Customer Support";
                        _loc9_ = 0;
                        while(_loc9_ < _loc5_)
                        {
                           if((_loc8_.type == 1 || _loc8_.type == 0) && (!_loc8_.hasOwnProperty("sku") || _loc8_.sku == "" || _loc8_.sku == null))
                           {
                              break;
                           }
                           _loc7_ = true;
                           InstanceMng.getServerConnection().createEntityInCollection("rewards",_loc8_);
                           if(InstanceMng.getApplication().isKongregateVersion() && !_loc6_)
                           {
                              InstanceMng.getServerConnection().consumeVGood(_loc1_[_loc2_],1);
                           }
                           _loc9_++;
                        }
                        if(!InstanceMng.getApplication().isKongregateVersion() && !_loc6_)
                        {
                           InstanceMng.getServerConnection().consumeVGood(_loc1_[_loc2_],_loc5_);
                        }
                     }
                  }
               }
               if(_loc7_ && !_loc6_)
               {
                  setTimeout(Utils.setLogText,1000,TextManager.getText("TID_SHOP_TRANSACTION_REIMBURSED"));
               }
            }
         }
      }
      
      public function getGiftTypeByVirtualGood(param1:Object) : int
      {
         var _loc3_:String = null;
         var _loc4_:VirtualGood = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Def = null;
         var _loc9_:BoostDef = null;
         var _loc10_:int = 0;
         var _loc2_:int = -1;
         if(param1)
         {
            _loc3_ = param1.sku;
            if(mVGoodsCatalog != null)
            {
               _loc4_ = mVGoodsCatalog[param1.sku];
               if(_loc4_ != null)
               {
                  _loc5_ = _loc4_.getPropertySet().PREFIX.type;
                  _loc6_ = _loc4_.getTags();
                  _loc7_ = _loc6_.indexOf("PERMANENT") != -1;
                  switch(_loc5_)
                  {
                     case "cards.":
                        _loc2_ = 0;
                        break;
                     case "packs.":
                     case "gold.":
                     case "tokens.":
                        _loc2_ = 1;
                        break;
                     case "portraits.":
                        _loc2_ = 2;
                        break;
                     case "boosts.":
                        _loc2_ = 4;
                  }
                  if(_loc7_)
                  {
                     _loc8_ = Utils.getShopItemByShortCode(_loc3_);
                     if(_loc8_)
                     {
                        if(_loc8_ is ShopBoostDef && !ShopBoostDef(_loc8_).isRepurchasable())
                        {
                           _loc9_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(ShopBoostDef(_loc8_).getBoostSku()));
                           _loc10_ = InstanceMng.getUserDataMng().getOwnerUserData().getBoostAmount(_loc9_.getSku());
                           if(_loc10_ != 0)
                           {
                              _loc2_ = -1;
                           }
                        }
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function isProductPermanent(param1:Object) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:VirtualGood = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc3_ = param1.sku;
            if(mVGoodsCatalog != null)
            {
               _loc4_ = mVGoodsCatalog[param1.sku];
               if(_loc4_ != null)
               {
                  _loc5_ = _loc4_.getPropertySet().PREFIX.type;
                  _loc6_ = _loc4_.getTags();
                  _loc2_ = _loc6_.indexOf("PERMANENT") != -1;
               }
            }
         }
         return _loc2_;
      }
      
      public function syncCurrencies(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc7_:UserData = Utils.getOwnerUserData();
         if(_loc7_)
         {
            _loc7_.setGold(param1);
            _loc7_.setRaidCoins(param2);
            _loc7_.setQuestsCoins(param3);
            _loc7_.setAuctionTickets(param4);
            _loc7_.setRaidTicketsSinglePlayer(param5);
            _loc7_.setRaidTicketsMultiPlayer(param6);
         }
      }
      
      public function backendBuyProduct(param1:String) : void
      {
         this.buyProduct(param1);
      }
      
      private function getPurchaseObjectFromInAppEvent(param1:*) : Object
      {
         return InAppEvent(param1).getPurchaseInfo();
      }
      
      public function onProductsRequested(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:String = null;
         FSDebug.debugTrace("!!!!!!!! Products requested");
         if(Utils.isMobile() || Utils.isDesktop())
         {
            _loc2_ = Utils.isDesktop() ? param1 : param1.data;
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = Utils.isDesktop() ? ObjectUtil.toString(_loc3_) : _loc3_.toString();
               _loc5_ = Utils.isDesktop() ? "product.price " + _loc3_.price / 100 : "product.priceString " + _loc3_.priceString;
               FSDebug.debugTrace(_loc4_);
               FSDebug.debugTrace(_loc5_);
            }
            this.updatePricesAIR(_loc2_);
         }
         else
         {
            this.processProductsRequested(param1.products);
         }
      }
      
      private function processProductsRequested(param1:*) : void
      {
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(param1);
         this.updatePricesBrowser(_loc2_);
         var _loc3_:Screen = InstanceMng.getCurrentScreen();
         if(_loc3_ != null && _loc3_ is FSShopScreen)
         {
            FSShopScreen(_loc3_).refreshPrices();
         }
         if(Boolean(InstanceMng.getPopupMng()) && Boolean(InstanceMng.getPopupMng().getPopupShown() != null) && InstanceMng.getPopupMng().getPopupShown() is PopupBuyProduct)
         {
            PopupBuyProduct(InstanceMng.getPopupMng().getPopupShown()).refreshPrices();
         }
         InstanceMng.getApplication().getInAppsManager().processUnconsumedProds();
      }
      
      public function onProductPurchasedOk(param1:*) : void
      {
         FSDebug.debugTrace("Product purchased OK");
         var _loc2_:String = this.getPurchaseObjectFromInAppEvent(param1).identifier;
         InstanceMng.getServerConnection().consumeProductInGS(_loc2_,"",false,this.onProductConsumedSuccessfuly,[_loc2_]);
      }
      
      public function onProductPurchasedKo(param1:*) : void
      {
         FSDebug.debugTrace("Product purchased KO");
         InstanceMng.getApplication().getInAppsManager().setCurrentProdIdBeingPurchased("");
         Utils.setLogText(TextManager.getText("TID_SHOP_PURCHASE_CANCELLED"));
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ != null)
         {
            if(_loc2_ is FSShopScreen)
            {
               FSShopScreen(_loc2_).onItemPurchasedKO();
            }
            else
            {
               InstanceMng.getApplication().getInAppsManager().onNonShopProdKO();
            }
         }
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PURCHASE,FSTracker.ACTION_KO);
      }
      
      public function onProductPurchasedPending(param1:*) : void
      {
         FSDebug.debugTrace("Product purchased pending...");
         Utils.setLogText(TextManager.getText("TID_SHOP_PURCHASE_PENDING"));
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ != null)
         {
            if(_loc2_ is FSShopScreen)
            {
               FSShopScreen(_loc2_).onItemPurchasedKO();
            }
            else
            {
               InstanceMng.getApplication().getInAppsManager().onNonShopProdKO();
            }
         }
      }
      
      public function onBackendStoreEvent(param1:*) : void
      {
         if(param1)
         {
            FSDebug.debugTrace("onBackendStoreEvent (" + param1.type + "): " + param1.products);
         }
      }
      
      public function onAIRProductPurchasedOkGS(param1:* = null, param2:* = null, param3:Boolean = false) : void
      {
         if(Utils.isMobile())
         {
            this.gsFinishAIRPurchase(param2,0,true,false,this.onProductConsumedSuccessfuly,[param1.productId]);
         }
         if(param3)
         {
            Utils.setLogText(TextManager.getText("TID_GEN_PURCHASES_RESTORED"));
         }
      }
      
      protected function onProductConsumedSuccessfuly(param1:String) : void
      {
         InstanceMng.getApplication().getInAppsManager().onProductPurchasedOkProcessProdId(param1);
      }
      
      public function onProductPurchasedFailed(param1:*) : void
      {
         var _loc4_:Boolean = false;
         FSDebug.debugTrace("Product purchased Failed");
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         var _loc3_:FSInAppsManager = InstanceMng.getApplication() ? InstanceMng.getApplication().getInAppsManager() : null;
         if(_loc3_)
         {
            if(Boolean(param1) && Boolean(param1.products) && param1.products.indexOf("Item Already Owned") != -1)
            {
               if(_loc2_ != null)
               {
                  if(_loc2_ is FSShopScreen)
                  {
                     FSShopScreen(_loc2_).onItemPurchasedKO();
                  }
                  else
                  {
                     _loc3_.onNonShopProdOK();
                  }
               }
               _loc4_ = _loc3_.addProductByProdId(_loc3_.getCurrentProdIdBeingPurchased());
               _loc3_.setCurrentProdIdBeingPurchased("");
               if(!_loc4_)
               {
                  Utils.setLogText(TextManager.getText("TID_SHOP_SUPPORT"),true);
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_SHOP_PURCHASE_CANCELLED"),true);
               if(_loc2_ != null)
               {
                  if(_loc2_ is FSShopScreen)
                  {
                     FSShopScreen(_loc2_).onItemPurchasedKO();
                  }
                  else
                  {
                     _loc3_.onNonShopProdKO();
                  }
               }
            }
         }
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PURCHASE,FSTracker.ACTION_FAILED);
      }
      
      public function onProductPurchasedFailedGS(param1:Object, param2:* = null, param3:Boolean = false) : void
      {
         var _loc8_:String = null;
         var _loc9_:Popup = null;
         var _loc10_:Popup = null;
         FSDebug.debugTrace("Product purchased Failed");
         var _loc4_:Boolean = param1 != null && param1.hasOwnProperty("verificationError") && param1.verificationError == "5";
         var _loc5_:String = param2 != null && param2.data != null && param2.data[0] != null ? param2.data[0].productId : "";
         _loc5_ = _loc5_ == "" ? this.mCurrentProdIdBeingPurchased : _loc5_;
         var _loc6_:Boolean = _loc5_ != "" ? this.isProductRePurchasableByProdId(_loc5_) : false;
         if(!_loc6_ && (Boolean(param2 && param2.errorCode == "7") || Boolean(_loc4_ && param3)))
         {
            this.onProductsRestoredGS(param2,_loc5_);
         }
         else
         {
            if(Utils.isMobile() || Utils.isDesktop())
            {
               if(_loc5_ != "")
               {
                  if(param2 != null && param2.data != null)
                  {
                     this.gsFinishAIRPurchase(param2,0,false);
                  }
                  else
                  {
                     this.forceConsumeProdId(_loc5_);
                  }
               }
               if(_loc4_ && !param3)
               {
                  if(InstanceMng.getServerConnection().isUserLoggedIn())
                  {
                     setTimeout(this.backendRestorePurchases,5000);
                  }
                  else
                  {
                     Utils.setLogText("Please make sure you have a valid internet connection and restart the app if necessary.",true);
                  }
               }
            }
            if(!param3)
            {
               _loc8_ = Boolean(param2 != null) && Boolean(param2.data) && Boolean(param2.data[0]) && Boolean(param2.data[0].hasOwnProperty("error")) ? " " + param2.data[0]["error"] : "";
               Utils.setLogText(TextManager.getText("TID_SHOP_PURCHASE_CANCELLED") + _loc8_,true);
            }
         }
         var _loc7_:Screen = InstanceMng.getCurrentScreen();
         if(_loc7_ != null)
         {
            if(_loc7_ is FSShopScreen)
            {
               FSShopScreen(_loc7_).onItemPurchasedKO();
            }
            else
            {
               InstanceMng.getApplication().getInAppsManager().onNonShopProdKO();
            }
            _loc9_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc9_ != null)
            {
               if(_loc9_ is PopupBuyProduct)
               {
                  _loc10_ = InstanceMng.getPopupMng().getPopupInBackground();
                  if(_loc10_ is PopupRaidLevelFailed)
                  {
                     PopupRaidLevelFailed(_loc10_).disablePostBoostButtonTemporarily(5);
                  }
                  _loc9_.closePopup();
               }
               else if(_loc9_ is PopupShopItem)
               {
                  PopupShopItem(_loc9_).disablePurchaseButtonTemporarily(5);
               }
            }
         }
         if(!param3)
         {
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PURCHASE,FSTracker.ACTION_FAILED,param1);
         }
      }
      
      protected function forceConsumeProdId(param1:String) : Boolean
      {
         return true;
      }
      
      public function onProductsRestored(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc2_:Array = Utils.parseJSONData(param1.products) as Array;
         for each(_loc4_ in _loc2_)
         {
            _loc3_ = _loc4_.identifier;
            FSTracker.trackMiscAction(FSTracker.CATEGORY_PURCHASE,FSTracker.ACTION_RESTORED,{"prodId":_loc3_});
            InstanceMng.getApplication().getInAppsManager().addProductByProdId(_loc3_,false);
         }
         Utils.setLogText(TextManager.getText("TID_GEN_PURCHASES_RESTORED"));
      }
      
      public function onProductsRestoredGS(param1:*, param2:String = "") : void
      {
         var prodId:String = null;
         var i:int = 0;
         var event:* = param1;
         var uniqueProdId:String = param2;
         var processProdId:Function = function(param1:String, param2:int):void
         {
            if(isProductRePurchasableByProdId(param1))
            {
               anyConsumableProdFound = true;
               onProductPurchasedOkProcessProdId(param1,true);
            }
            InstanceMng.getApplication().getInAppsManager().addProductByProdId(param1,false);
            if(Utils.isMobile())
            {
               gsFinishAIRPurchase(event,param2,false,true);
            }
         };
         var anyConsumableProdFound:Boolean = false;
         if(event.data != null)
         {
            i = 0;
            while(i < event.data.length)
            {
               prodId = event.data[i].productId;
               processProdId(prodId,i);
               i++;
            }
         }
         else if(uniqueProdId != "")
         {
            processProdId(uniqueProdId,0);
         }
         if(anyConsumableProdFound)
         {
            Utils.setLogText(TextManager.getText("TID_GEN_PURCHASES_RESTORED"));
         }
      }
      
      public function onProductPurchasedCancelled(param1:*) : void
      {
         FSDebug.debugTrace("Product purchased Cancelled");
         InstanceMng.getApplication().getInAppsManager().setCurrentProdIdBeingPurchased("");
         Utils.setLogText(TextManager.getText("TID_SHOP_PURCHASE_CANCELLED"));
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ != null)
         {
            if(_loc2_ is FSShopScreen)
            {
               FSShopScreen(_loc2_).onItemPurchasedKO();
            }
            else
            {
               InstanceMng.getApplication().getInAppsManager().onNonShopProdKO();
            }
         }
         if(param1 != null && (Utils.isMobile() || Utils.isDesktop()))
         {
            this.gsFinishAIRPurchase(param1,0,false);
         }
         FSTracker.trackMiscAction(FSTracker.CATEGORY_PURCHASE,FSTracker.ACTION_CANCELLED);
      }
      
      public function areProductsPricesUpToDate() : Boolean
      {
         return this.mProductsInfoCatalog != null;
      }
      
      public function areProductsRequested() : Boolean
      {
         return mProductsArr != null;
      }
      
      public function processPurchasableProductsReceived(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         FSDebug.debugTrace("[processPurchasableProductsReceived] OK");
         var _loc2_:String = Config.getConfig().getAppNameSpace();
         var _loc4_:String = "";
         if(param1 != null)
         {
            if(mProductsArr == null)
            {
               mProductsArr = new Array();
            }
            if(mProductsArr)
            {
               mProductsArr.length = 0;
            }
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               _loc5_ = true;
               _loc4_ = _loc2_ + "." + param1[_loc6_];
               _loc3_ = Utils.isAndroidOrDesktop() ? String(_loc4_).toLowerCase() : _loc4_;
               _loc5_ = this.isProductRePurchasableByProdId(_loc3_);
               _loc3_ = InstanceMng.getApplication().isFacebookBrowser() ? _loc3_.split(Config.getConfig().getAppNameSpace() + ".")[1] : _loc3_;
               if(InstanceMng.getApplication().isFacebookBrowser())
               {
                  _loc7_ = _loc3_.split(".")[1];
                  _loc3_ = _loc3_.split(".")[0] + "." + _loc7_.toUpperCase();
               }
               _loc3_ = InstanceMng.getApplication().isKongregateVersion() ? String(_loc3_.split(Config.getConfig().getAppNameSpace() + ".")[1]).replace(".","-").toLowerCase() : _loc3_;
               if(_loc3_ != null && _loc3_ != "")
               {
                  if(_loc5_ || !_loc5_ && InstanceMng.getApplication().hasPermanentBoosts())
                  {
                     mProductsArr.push(_loc3_);
                  }
               }
               _loc6_++;
            }
            FSDebug.debugTrace("Requesting products: " + mProductsArr.toString());
            InstanceMng.getApplication().getInAppsManager().requestProducts(mProductsArr);
         }
      }
      
      public function isProductRePurchasableByProdId(param1:String) : Boolean
      {
         var _loc3_:Def = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc2_:Boolean = true;
         param1 = Utils.isAndroidOrDesktop() ? String(param1).toLowerCase() : param1;
         param1 = InstanceMng.getApplication().isFacebookBrowser() ? param1.split(Config.getConfig().getAppNameSpace() + ".")[1] : param1;
         param1 = InstanceMng.getApplication().isKongregateVersion() ? String(param1.split(Config.getConfig().getAppNameSpace() + ".")[1]).replace(".","-").toLowerCase() : param1;
         _loc3_ = Utils.getShopItemByProdId(param1);
         _loc4_ = _loc3_ is DeckSlotDef;
         _loc5_ = _loc3_ is ShopBoostDef;
         if(_loc3_)
         {
            if(_loc5_ || _loc4_)
            {
               if(_loc5_ && !ShopBoostDef(_loc3_).isRepurchasable() || _loc4_)
               {
                  _loc2_ = false;
               }
            }
         }
         return _loc2_;
      }
      
      public function updatePricesBrowser(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         if(param1 != null)
         {
            if(InstanceMng.getApplication().isBrowserVersion())
            {
               _loc3_ = InstanceMng.getApplication().isKongregateVersion();
               _loc4_ = "";
               if(_loc3_)
               {
                  _loc4_ = "Kreds";
               }
               else if(smCurrencySymbol == "")
               {
                  _loc4_ = Utils.getDefaultCurrency();
                  smCurrencySymbol = _loc4_;
               }
               else
               {
                  _loc4_ = smCurrencySymbol;
               }
            }
            for each(_loc2_ in param1)
            {
               if(this.mProductsInfoCatalog == null)
               {
                  this.mProductsInfoCatalog = new Dictionary(true);
               }
               if(this.mProductsInfoCatalog[_loc2_.identifier] == null)
               {
                  this.mProductsInfoCatalog[_loc2_.identifier] = InstanceMng.getApplication().isBrowserVersion() ? _loc2_.priceLocale + " " + _loc4_ : _loc2_.priceLocale;
               }
            }
         }
      }
      
      public function updatePricesAIR(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 != null)
         {
            for each(_loc2_ in param1)
            {
               if(this.mProductsInfoCatalog == null)
               {
                  this.mProductsInfoCatalog = new Dictionary(true);
               }
               _loc3_ = Utils.isDesktop() ? _loc2_["prodId"] : _loc2_["id"];
               if(Utils.isDesktop())
               {
                  _loc4_ = Boolean(_loc2_.hasOwnProperty("priceInCurrencies")) && Boolean(_loc2_["priceInCurrencies"].hasOwnProperty(FSInAppsManager.smCurrencyCode)) ? _loc2_["priceInCurrencies"][FSInAppsManager.smCurrencyCode] + " " + smCurrencyCode : _loc2_.price / 100 + " " + smCurrencyCode;
               }
               else
               {
                  _loc4_ = _loc2_.priceString;
               }
               if(this.mProductsInfoCatalog[_loc3_] == null)
               {
                  this.mProductsInfoCatalog[_loc3_] = _loc4_;
               }
            }
            this.onLoggedInRestorePurchases();
         }
      }
      
      private function onLoggedInRestorePurchases() : void
      {
         if(!Utils.isIOS())
         {
            if(Boolean(InstanceMng.getUserDataMng() && InstanceMng.getUserDataMng().getOwnerUserData()) && Boolean(InstanceMng.getServerConnection().isUserLoggedIn()) && InstanceMng.getApplication().areOnDemandDefinitionsInitialized())
            {
               this.backendRestorePurchases();
            }
            else
            {
               setTimeout(this.onLoggedInRestorePurchases,5000);
            }
         }
      }
      
      public function getPriceByProdId(param1:String) : String
      {
         var _loc2_:String = "N.A";
         if(param1)
         {
            param1 = Utils.isAndroidOrDesktop() ? param1.toLowerCase() : param1;
            _loc2_ = this.mProductsInfoCatalog != null ? this.mProductsInfoCatalog[param1] : "N.A";
         }
         return _loc2_;
      }
      
      public function getPriceByDef(param1:Def) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1 != null)
         {
            _loc3_ = Utils.isDesktop() ? param1.getProdId().toLowerCase() : param1.getProdId();
            if(this.mProductsInfoCatalog != null)
            {
               if(InstanceMng.getApplication().isFacebookBrowser())
               {
                  _loc3_ = _loc3_.split(".")[0] + "." + String(_loc3_.split(".")[1]).toUpperCase();
               }
               _loc2_ = this.mProductsInfoCatalog[_loc3_];
            }
            else
            {
               _loc2_ = "N.A";
            }
         }
         return _loc2_;
      }
      
      public function getPriceOfProd(param1:FSShopItem) : String
      {
         return this.getPriceByDef(param1.getDef());
      }
   }
}

