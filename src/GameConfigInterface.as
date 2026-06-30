package
{
   public interface GameConfigInterface
   {
      
      function getApiKey(param1:Boolean) : String;
      
      function getSecretKey() : String;
      
      function isBrowserVersion() : Boolean;
      
      function isFacebookBrowser() : Boolean;
      
      function isKongregateVersion() : Boolean;
      
      function hasPermanentBoosts() : Boolean;
      
      function showCustomFontsForPacks() : Boolean;
      
      function getZoomInViewMainFontName() : String;
   }
}

