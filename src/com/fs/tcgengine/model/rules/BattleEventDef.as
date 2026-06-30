package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.utils.Utils;
   
   public class BattleEventDef extends Def
   {
      
      private var mActionSku:String;
      
      private var mRestrictionSku:String;
      
      private var mTriggerEvent:int;
      
      public function BattleEventDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.doFromJSON(param1);
         if("actionSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.actionSku);
            this.mActionSku = _loc3_;
         }
         if("restrictionSku" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.restrictionSku);
            this.mRestrictionSku = _loc3_;
         }
         if("triggerEvent" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.triggerEvent);
            this.mTriggerEvent = int(_loc3_);
         }
      }
      
      public function getActionSku() : String
      {
         return this.mActionSku;
      }
      
      public function getRestrictionSku() : String
      {
         return this.mRestrictionSku;
      }
      
      public function getTriggerEvent() : int
      {
         return this.mTriggerEvent;
      }
      
      override public function getDesc() : String
      {
         var _loc2_:Array = null;
         var _loc3_:AbilityDef = null;
         var _loc1_:ActionDef = ActionDef(InstanceMng.getActionsDefMng().getDefBySku(this.mActionSku));
         if(_loc1_)
         {
            _loc2_ = _loc1_.getAbilities();
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc3_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc2_[0]));
               if(_loc3_)
               {
                  return _loc3_.getDesc();
               }
            }
         }
         return super.getDesc();
      }
   }
}

