package
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.FSInAppsManager;
   import com.fs.tcgengine.resources.FSAssetManager;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.wwiitcg.resources.ResourceMng;
   import embeddedConfig.Definitions;
   import flash.display.Bitmap;
   
   public class MainGame extends Main
   {
      
      private var API_KEY:String = "q302667Npx4r";
      
      private var API_SECRET:String = "JWDf96I6b8pxxzrDZ5Lla7bg0Rd213JK";
      
      public function MainGame()
      {
         mGSBrowserNamespace = "wwiitcg";
         super();
      }
      
      override protected function createResourcesMng() : void
      {
         mResourcesMng = new ResourceMng();
         InstanceMng.registerResourcesMng(mResourcesMng);
      }
      
      override public function getInAppsManager() : FSInAppsManager
      {
         if(mInAppsManager == null)
         {
            mInAppsManager = new SteamInAppsManager();
         }
         return mInAppsManager;
      }
      
      override public function getApiKey(param1:Boolean) : String
      {
         return this.API_KEY;
      }
      
      override public function getSecretKey() : String
      {
         return this.API_SECRET;
      }
      
      override public function getFullScreenWidth() : int
      {
         return FSAirLibrary.getFullScreenWidth();
      }
      
      override public function getFullScreenHeight() : int
      {
         return FSAirLibrary.getFullScreenHeight();
      }
      
      override public function getZoomInViewMainFontName() : String
      {
         return FSResourceMng.getFontByType();
      }
      
      override protected function addNativeEventListeners() : void
      {
         super.addNativeEventListeners();
         FSAirLibrary.addNativeEventListeners();
      }
      
      override protected function createStartupBackground() : Bitmap
      {
         return FSAirLibrary.createStartupBackground();
      }
      
      override protected function loadDefaultAssets(param1:FSAssetManager, param2:int, param3:int) : void
      {
         super.loadDefaultAssets(param1,param2,param3);
         FSAirLibrary.loadDefaultAssets(param1,param2,param3,Definitions);
      }
      
      override public function initializeANEs(param1:String) : void
      {
         FSSteamLibrary.initializeANEs();
      }
      
      override public function exitApp() : void
      {
         FSAirLibrary.exitApp();
      }
      
      override public function buyProduct(param1:String, param2:String) : void
      {
         FSSteamLibrary.buyProduct(param1);
      }
      
      override public function requestProducts(param1:Array) : void
      {
         FSSteamLibrary.requestProducts(param1);
      }
      
      override public function checkInternetConnection() : void
      {
         FSAirLibrary.checkInternetConnection();
      }
      
      override public function steamGetSessionTicket() : String
      {
         return FSSteamLibrary.smSessionTicket;
      }
      
      override public function shareGame() : void
      {
         FSSteamLibrary.shareGame();
      }
      
      override public function submitStat(param1:String, param2:Number) : void
      {
         FSSteamLibrary.submitStat(param1,param2);
      }
      
      override public function steamRelogin() : void
      {
         FSSteamLibrary.initializeANEs();
      }
      
      override public function steamCheckAchievement(param1:String) : void
      {
         FSSteamLibrary.checkAchievement(param1);
      }
      
      override public function steamCheckStat(param1:String) : void
      {
         FSSteamLibrary.checkStat(param1);
      }
      
      override public function steamClearAchievement(param1:String) : void
      {
         FSSteamLibrary.clearAchievement(param1);
      }
      
      override public function steamResetAllStats(param1:Boolean) : void
      {
         FSSteamLibrary.resetAllStats(param1);
      }
      
      override public function steamGetSteamId() : String
      {
         return FSSteamLibrary._userId;
      }
   }
}

