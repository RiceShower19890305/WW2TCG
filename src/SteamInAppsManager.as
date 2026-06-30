package
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.FSInAppsManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.utils.Utils;
   import mx.utils.ObjectUtil;
   
   public class SteamInAppsManager extends FSInAppsManager
   {
      
      public static const STATE_PURCHASED:int = 0;
      
      public static const STATE_FAILED:int = 1;
      
      public static const STATE_CANCELLED:int = 2;
      
      public function SteamInAppsManager()
      {
         super();
         mAreInappPurchasesSetup = true;
      }
      
      public function purchases_updatedHandler(param1:int, param2:String = "") : void
      {
         FSDebug.debugTrace("purchases updated state: [" + param1 + "]:");
         switch(param1)
         {
            case STATE_PURCHASED:
               FSDebug.debugTrace("purchase success");
               this.processPurchaseForFraudulentCheck(param2);
               break;
            case STATE_FAILED:
               FSDebug.debugTrace("purchase failed");
               onProductPurchasedFailedGS(null,null);
               break;
            case STATE_CANCELLED:
               FSDebug.debugTrace("purchase cancelled");
               onProductPurchasedCancelled(null);
         }
      }
      
      private function processPurchaseForFraudulentCheck(param1:String) : void
      {
         InstanceMng.getServerConnection().processPurchaseReceipt("","","","",param1,this.onSteamProductPurchasedOkGS,null,onProductPurchasedFailedGS,[null,false],true);
      }
      
      public function onSteamProductPurchasedOkGS(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         if(Utils.isDesktop())
         {
            FSDebug.debugTrace("data received: " + ObjectUtil.toString(param1));
            _loc2_ = Utils.getShopItemByShortCode(param1[0]["data"]["shortCode"]).getProdId();
            _loc3_ = new Object();
            _loc3_[0] = new Object();
            _loc3_[0]["productId"] = _loc2_;
            this.gsFinishAIRPurchase({"data":_loc3_},0,true,false,onProductConsumedSuccessfuly,[_loc2_]);
         }
      }
      
      override public function buyProduct(param1:String) : void
      {
         var showWarningMessage:Function = null;
         var productId:String = param1;
         showWarningMessage = function():void
         {
            var _loc1_:String = TextManager.getText("TID_GEN_STEAM_OVERLAY");
            InstanceMng.getPopupMng().openConfirmationPopup(_loc1_,InstanceMng.getPopupMng().closePopupShown);
            InstanceMng.getApplication().getInAppsManager().onProductPurchasedCancelled(null);
         };
         var performBuyProduct:Function = function():void
         {
            InstanceMng.getServerConnection().steamBuyProduct(productId,onSteamBuyProductSuccess,onSteamBuyProductFailed);
            FSDebug.debugTrace("makePurchase( " + productId + " )");
         };
         if(!FSSteamLibrary.isOverlayEnabled())
         {
            if(InstanceMng.getPopupMng().getPopupShown())
            {
               InstanceMng.getPopupMng().getPopupShown().closePopup(showWarningMessage);
            }
            else
            {
               showWarningMessage();
            }
         }
         else
         {
            performBuyProduct();
         }
      }
      
      private function onSteamBuyProductSuccess(param1:Object) : void
      {
         FSDebug.debugTrace("Steam init transaction successfully initialized, waiting for player action");
      }
      
      private function onSteamBuyProductFailed(param1:Object = null, param2:Object = null) : void
      {
         FSDebug.debugTrace("Steam init transaction could not be initialized");
         onProductPurchasedFailedGS(null,null);
      }
      
      override public function gsFinishAIRPurchase(param1:*, param2:int = 0, param3:Boolean = true, param4:Boolean = false, param5:Function = null, param6:Array = null, param7:Function = null, param8:Array = null) : void
      {
         if(param3 && param1 != null && Boolean(param1.hasOwnProperty("data")))
         {
            this.consumeProduct(param1.data[param2].productId,param4,param5,param6,param7,param8);
         }
      }
      
      override public function consumeProduct(param1:String, param2:Boolean = false, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null) : void
      {
         if(InstanceMng.getApplication().getInAppsManager().isProductRePurchasableByProdId(param1))
         {
            param1 = param1.split(Config.getConfig().getAppNameSpace() + ".")[1];
            InstanceMng.getServerConnection().consumeProductInGS(param1,"",false,param3,param4,param5,param6);
         }
         else if(!param2)
         {
            if(param3 != null)
            {
               if(param4 != null)
               {
                  param3.apply(null,param4);
               }
               else
               {
                  param3();
               }
            }
         }
      }
      
      public function onProductsReceived(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = param1 as Array;
            if(_loc2_ != null && _loc2_.length > 0)
            {
               if(FSInAppsManager.smCurrencyCode == "")
               {
                  FSInAppsManager.smCurrencyCode = "USD";
               }
            }
            onProductsRequested(param1);
         }
      }
   }
}

