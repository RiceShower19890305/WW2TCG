package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class PowerDef extends CardDef
   {
      
      private var mBgIcon:String;
      
      public function PowerDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("bgIcon" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.bgIcon);
            this.mBgIcon = _loc2_;
         }
      }
      
      public function getBgIcon() : String
      {
         return this.mBgIcon;
      }
   }
}

