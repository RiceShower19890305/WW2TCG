package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class AttachmentDef extends CardDef
   {
      
      private var mAttachmentCost:Array;
      
      public function AttachmentDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         super.doFromJSON(param1);
         if("attachmentCost" in param1)
         {
            if(param1.attachmentCost != "")
            {
               _loc2_ = Utils.cleanMasterString(param1.attachmentCost);
               this.setAttachmentCost(_loc2_.split(","));
            }
         }
      }
      
      public function getAttachmentCost() : Array
      {
         return this.mAttachmentCost;
      }
      
      public function setAttachmentCost(param1:Array) : void
      {
         this.mAttachmentCost = param1;
      }
   }
}

