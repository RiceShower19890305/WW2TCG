package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.model.rules.ConversationDef;
   import com.fs.tcgengine.model.rules.Def;
   import flash.utils.Dictionary;
   
   public class ConversationsDefMng extends DefMng
   {
      
      public function ConversationsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new ConversationDef();
      }
      
      public function getConversationsDefsByLevelSku(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc4_:ConversationDef = null;
         var _loc3_:Dictionary = getAllDefs();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getLevelSku() == param1 && _loc4_.getCallKey() != "custom")
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Array();
               }
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function getConversationDefByCallKey(param1:String) : ConversationDef
      {
         var _loc2_:ConversationDef = null;
         var _loc4_:ConversationDef = null;
         var _loc3_:Dictionary = getAllDefs();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getCallKey() == param1)
            {
               return _loc4_;
            }
         }
         return _loc2_;
      }
   }
}

