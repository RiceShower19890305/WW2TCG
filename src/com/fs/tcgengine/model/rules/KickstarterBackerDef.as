package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class KickstarterBackerDef extends Def
   {
      
      private var mKickSurname:String = "";
      
      private var mKickName:String = "";
      
      private var mKickType:String = "";
      
      public function KickstarterBackerDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("kickname" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.kickname);
            this.setKickName(_loc2_);
         }
         if("kicksurname" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.kicksurname);
            this.setKickSurname(_loc2_);
         }
         if("kicktype" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.kicktype);
            this.setKickType(_loc2_);
         }
      }
      
      private function setKickName(param1:String) : void
      {
         this.mKickName = param1;
      }
      
      public function getKickName() : String
      {
         return this.mKickName;
      }
      
      private function setKickSurname(param1:String) : void
      {
         this.mKickSurname = param1;
      }
      
      public function getKickSurname() : String
      {
         return this.mKickSurname;
      }
      
      private function setKickType(param1:String) : void
      {
         this.mKickType = param1;
      }
      
      public function getKickType() : String
      {
         return this.mKickType;
      }
   }
}

