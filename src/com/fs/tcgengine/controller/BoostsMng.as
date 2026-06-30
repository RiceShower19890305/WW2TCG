package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.model.boosts.Boost;
   import com.fs.tcgengine.model.boosts.BoostBestHand;
   import com.fs.tcgengine.model.boosts.BoostDecreaseHP;
   import com.fs.tcgengine.model.boosts.BoostExtraLifes;
   import com.fs.tcgengine.model.boosts.BoostFillAP;
   import com.fs.tcgengine.model.boosts.BoostFillLives;
   import com.fs.tcgengine.model.boosts.BoostHP;
   import com.fs.tcgengine.model.boosts.BoostIncreaseRank;
   import com.fs.tcgengine.model.boosts.BoostInvulnerable;
   import com.fs.tcgengine.model.boosts.BoostPurchaseBattlePass;
   import com.fs.tcgengine.model.boosts.BoostRechargeRaidMP;
   import com.fs.tcgengine.model.boosts.BoostRechargeRaidSP;
   import com.fs.tcgengine.model.boosts.BoostResetDailyQuests;
   import com.fs.tcgengine.model.boosts.BoostReshuffle;
   import com.fs.tcgengine.model.boosts.BoostUnlockMap;
   import com.fs.tcgengine.model.boosts.PostBoostExtraHPAndTurns;
   import com.fs.tcgengine.model.boosts.PostBoostExtraTurns;
   import com.fs.tcgengine.model.boosts.PostBoostHP;
   import com.fs.tcgengine.model.rules.BoostDef;
   import flash.utils.Dictionary;
   
   public class BoostsMng
   {
      
      public static const BOOST_ID_PRE_HP:String = "PRE_HP";
      
      public static const BOOST_ID_FILL_ACTION_POINTS:String = "FILL_AP";
      
      public static const BOOST_ID_RESHUFFLE:String = "RESHUFFLE";
      
      public static const BOOST_ID_BARRIER:String = "BARRIER";
      
      public static const BOOST_ID_BEST_HAND:String = "PERFECT_HAND";
      
      public static const BOOST_ID_MINOR_STRIKE:String = "MINOR_STRIKE";
      
      public static const BOOST_ID_PROMOTE:String = "PROMOTE";
      
      public static const POST_BOOST_ID_HP:String = "POST_HP";
      
      public static const POST_BOOST_ID_EXTRA_TURNS:String = "POST_EXTRA_TURNS";
      
      public static const POST_BOOST_ID_EXTRA_HP_TURNS:String = "POST_EXTRA_HP_TURNS";
      
      public static const BOOST_ID_FILL_LIVES:String = "FILL_LIVES";
      
      public static const BOOST_ID_PERMANENT_LIVES:String = "PERMANENT_LIVES";
      
      public static const BOOST_ID_PERMANENT_FILL_ACTION_POINTS:String = "PERMANENT_FILL_AP";
      
      public static const BOOST_ID_UNLOCK_MAP:String = "UNLOCK_MAP";
      
      public static const BOOST_ID_RESET_DAILY_QUESTS:String = "RESET_DAILY_QUEST";
      
      public static const BOOST_ID_PURCHASE_BATTLE_PASS:String = "BATTLE_PASS";
      
      public static const BOOST_ID_RESET_TECKETS_RAID_SINGLE_PLAYER:String = "RECHARGE_RAID_SP";
      
      public static const BOOST_ID_RESET_TECKETS_RAID_MULTI_PLAYER:String = "RECHARGE_RAID_MP";
      
      public static const PRE_BOOST:int = 0;
      
      public static const BOOST:int = 1;
      
      public static const POST_BOOST:int = 2;
      
      private var mBoostsCatalog:Dictionary;
      
      public function BoostsMng()
      {
         super();
      }
      
      public function getBoost(param1:BoostDef) : Boost
      {
         if(this.mBoostsCatalog == null)
         {
            this.mBoostsCatalog = new Dictionary(true);
         }
         if(this.mBoostsCatalog[param1.getKeyName()] == null)
         {
            this.requestBoost(param1);
         }
         return this.mBoostsCatalog[param1.getKeyName()];
      }
      
      private function requestBoost(param1:BoostDef) : void
      {
         var _loc2_:String = null;
         var _loc3_:Class = null;
         if(param1 != null)
         {
            _loc2_ = param1.getKeyName();
            if(this.mBoostsCatalog[_loc2_] != null)
            {
               return;
            }
            _loc3_ = null;
            switch(_loc2_)
            {
               case BOOST_ID_PRE_HP:
                  _loc3_ = BoostHP;
                  break;
               case BOOST_ID_MINOR_STRIKE:
                  _loc3_ = BoostDecreaseHP;
                  break;
               case BOOST_ID_FILL_ACTION_POINTS:
                  _loc3_ = BoostFillAP;
                  break;
               case BOOST_ID_RESHUFFLE:
                  _loc3_ = BoostReshuffle;
                  break;
               case BOOST_ID_BARRIER:
                  _loc3_ = BoostInvulnerable;
                  break;
               case BOOST_ID_BEST_HAND:
                  _loc3_ = BoostBestHand;
                  break;
               case BOOST_ID_PROMOTE:
                  _loc3_ = BoostIncreaseRank;
                  break;
               case BOOST_ID_PERMANENT_LIVES:
                  _loc3_ = BoostExtraLifes;
                  break;
               case BOOST_ID_FILL_LIVES:
                  _loc3_ = BoostFillLives;
                  break;
               case POST_BOOST_ID_HP:
                  _loc3_ = PostBoostHP;
                  break;
               case POST_BOOST_ID_EXTRA_TURNS:
                  _loc3_ = PostBoostExtraTurns;
                  break;
               case POST_BOOST_ID_EXTRA_HP_TURNS:
                  _loc3_ = PostBoostExtraHPAndTurns;
                  break;
               case BOOST_ID_PERMANENT_FILL_ACTION_POINTS:
                  _loc3_ = BoostFillAP;
                  break;
               case BOOST_ID_UNLOCK_MAP:
                  _loc3_ = BoostUnlockMap;
                  break;
               case BOOST_ID_RESET_DAILY_QUESTS:
                  _loc3_ = BoostResetDailyQuests;
                  break;
               case BOOST_ID_RESET_TECKETS_RAID_SINGLE_PLAYER:
                  _loc3_ = BoostRechargeRaidSP;
                  break;
               case BOOST_ID_RESET_TECKETS_RAID_MULTI_PLAYER:
                  _loc3_ = BoostRechargeRaidMP;
                  break;
               case BOOST_ID_PURCHASE_BATTLE_PASS:
                  _loc3_ = BoostPurchaseBattlePass;
            }
            if(_loc2_ != null)
            {
               this.mBoostsCatalog[_loc2_] = new _loc3_(param1);
            }
         }
      }
   }
}

