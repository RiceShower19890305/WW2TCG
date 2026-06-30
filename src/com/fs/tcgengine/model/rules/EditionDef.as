package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class EditionDef extends Def
   {
      
      private var mVisible:Boolean;
      
      private var mGameIndex:int;
      
      private var mGameName:String;
      
      private var mGameNameLarge:String;
      
      private var mGameBG:String;
      
      public function EditionDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("visible" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.visible);
            this.setVisible(Utils.stringToBoolean(_loc2_));
         }
         if("gameIndex" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameIndex);
            this.mGameIndex = int(_loc2_);
         }
         if("gameBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameBG);
            this.mGameBG = _loc2_;
         }
         if("gameName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameName);
            this.mGameName = _loc2_;
         }
         if("gameNameLarge" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameNameLarge);
            this.mGameNameLarge = _loc2_;
         }
      }
      
      public function isVisible() : Boolean
      {
         return this.mVisible;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.mVisible = param1;
      }
      
      public function getGameIndex() : int
      {
         return this.mGameIndex;
      }
      
      public function getGameBG() : String
      {
         return this.mGameBG;
      }
      
      public function getGameName() : String
      {
         return this.mGameName;
      }
      
      public function getGameNameLarge() : String
      {
         return this.mGameNameLarge;
      }
   }
}

