package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.BadgeDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.Utils;
   
   public class BadgesDefMng extends DefMng
   {
      
      public function BadgesDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new BadgeDef();
      }
      
      public function getRewardedBadgesForLevelRanks(param1:String, param2:String) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:BadgeDef = null;
         var _loc8_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Vector.<BadgeDef> = this.getRewardBadgesForLevelRanks(param1,param2);
         if(_loc4_ != null)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc7_ = _loc4_[_loc6_];
               if(_loc7_)
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = new Array();
                  }
                  _loc3_.push(_loc7_.getSku());
               }
               _loc6_++;
            }
         }
         return _loc3_;
      }
      
      public function getRewardBadgesForLevelRanks(param1:String, param2:String) : Vector.<BadgeDef>
      {
         var _loc3_:Vector.<BadgeDef> = null;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:RankDef = null;
         var _loc10_:String = null;
         var _loc5_:int = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(param1);
         var _loc6_:int = InstanceMng.getLevelsDefMng().getLevelIndexByLevelSku(param2);
         var _loc7_:int = 1;
         _loc4_ = _loc5_;
         while(_loc4_ <= _loc6_)
         {
            _loc8_ = RankDef(InstanceMng.getRanksDefMng().getDefByCurrentLevel(_loc4_)).getIndex();
            if(_loc7_ < _loc8_)
            {
               _loc9_ = RankDef(InstanceMng.getRanksDefMng().getDefByCurrentLevel(_loc4_));
               _loc10_ = _loc9_ != null ? _loc9_.getBadgeSku() : "";
               if(_loc10_ != null && _loc10_ != "")
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = new Vector.<BadgeDef>();
                  }
                  _loc3_.push(BadgeDef(InstanceMng.getBadgesDefMng().getDefBySku(_loc10_)));
                  _loc7_ = _loc8_;
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function isAnyBadgeRewardClaimeable() : Boolean
      {
         var _loc2_:BadgeDef = null;
         var _loc1_:Boolean = false;
         var _loc3_:UserData = Utils.getOwnerUserData();
         for each(_loc2_ in mDefsBySku)
         {
            if(this.isClaimeable(_loc2_))
            {
               return true;
            }
         }
         return _loc1_;
      }
      
      private function isClaimeable(param1:BadgeDef) : Boolean
      {
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getBadgesAmountByBadgeSku(param1.getSku());
         var _loc3_:int = param1.getAmountToUnlock() - _loc2_;
         var _loc4_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isBadgeRewardAlreadyClaimed(param1.getSku());
         return _loc3_ <= 0 && InstanceMng.getServerConnection().isUserLoggedIn() && !_loc4_;
      }
   }
}

