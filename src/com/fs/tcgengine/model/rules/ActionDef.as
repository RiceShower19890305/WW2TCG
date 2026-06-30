package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class ActionDef extends CardDef
   {
      
      private var mUpgradeCosts:Array;
      
      private var mCardSkuUpgradeCatalog:Dictionary;
      
      public function ActionDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("upgradeCosts" in param1)
         {
            if(param1.upgradeCosts != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.upgradeCosts);
               this.setUpgradeCosts(_loc2_.split(","));
            }
         }
      }
      
      public function getUpgradeCosts() : Array
      {
         return this.mUpgradeCosts;
      }
      
      public function setUpgradeCosts(param1:Array) : void
      {
         var _loc2_:int = 0;
         this.mUpgradeCosts = param1;
         if(mAbilities != null)
         {
            if(this.mCardSkuUpgradeCatalog == null)
            {
               this.mCardSkuUpgradeCatalog = new Dictionary(true);
            }
            _loc2_ = 0;
            while(_loc2_ < mAbilities.length)
            {
               this.mCardSkuUpgradeCatalog[mAbilities[_loc2_]] = this.mUpgradeCosts[_loc2_];
               _loc2_++;
            }
         }
      }
      
      public function getCardSkuUpgradeCatalog() : Dictionary
      {
         return this.mCardSkuUpgradeCatalog;
      }
      
      public function setCardSkuUpgradeCatalog(param1:Dictionary) : void
      {
         this.mCardSkuUpgradeCatalog = param1;
      }
      
      public function getUpgradeCostByAbilitySku(param1:String) : int
      {
         var _loc2_:int = 0;
         if(this.mCardSkuUpgradeCatalog != null)
         {
            _loc2_ = int(this.mCardSkuUpgradeCatalog[param1]);
         }
         return _loc2_;
      }
   }
}

