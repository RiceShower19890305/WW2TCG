package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.Def;
   import flash.utils.Dictionary;
   
   public class AbilitiesDefMng extends DefMng
   {
      
      public function AbilitiesDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new AbilityDef();
      }
      
      public function getAbilityDefByKeyname(param1:String) : AbilityDef
      {
         var _loc2_:AbilityDef = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Def = null;
         if(param1 != "" && param1 != null)
         {
            _loc3_ = getAllDefs();
            for each(_loc4_ in _loc3_)
            {
               if(AbilityDef(_loc4_).getKeyName() == param1)
               {
                  return AbilityDef(_loc4_);
               }
            }
         }
         return _loc2_;
      }
      
      public function getOnTargetSelectedExtraDelay(param1:String) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = 0;
         switch(param1)
         {
            case AbilitiesMng.SPECIAL_BETTEREQUIP:
            case AbilitiesMng.SPECIAL_FULLPROMOTE:
            case AbilitiesMng.SPECIAL_DEMOTE:
            case AbilitiesMng.SPECIAL_TOTALDEMOTE:
               _loc3_ = Config.getConfig().getDefaultDelayPromoteFadeTextfieldsAnimDuration();
               _loc4_ = Config.getConfig().getDefaultDelayPromoteAttachNewFrameAnimDuration();
               _loc2_ = _loc3_ + _loc4_;
               break;
            default:
               _loc2_ = 0.5;
         }
         return _loc2_;
      }
   }
}

