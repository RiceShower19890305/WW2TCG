package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.Def;
   
   public class AttachmentsDefMng extends CardDefMng
   {
      
      public function AttachmentsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new AttachmentDef();
      }
      
      override public function getDefBySku(param1:String) : Def
      {
         return mDefsBySku[param1];
      }
   }
}

