package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import flash.utils.Dictionary;
   
   public class QuestsDefMng extends DefMng
   {
      
      public static const REWARD_TYPE_QUEST_COINS:int = 0;
      
      public static const REWARD_TYPE_PORTRAIT_SKIN:int = 1;
      
      public static const REWARD_TYPE_PACK:int = 2;
      
      public static const REWARD_TYPE_RAID_COINS:int = 3;
      
      public static const REWARD_TYPE_CLASS_UNLOCK:int = 4;
      
      public static const REWARD_TYPE_GOLD:int = 5;
      
      public static const REWARD_TYPE_JOB_XP:int = 6;
      
      public static const REWARD_TYPE_CARD:int = 7;
      
      public static const REWARD_TYPE_BOOST:int = 8;
      
      public static const REWARD_TYPE_TOKENS:int = 9;
      
      public static const REWARD_TYPE_UNLOCK_CRAFT:int = 10;
      
      public static const REWARD_TYPE_NONE:int = -1;
      
      public function QuestsDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new QuestDef();
      }
      
      public function getDailyQuests() : Dictionary
      {
         var _loc2_:QuestDef = null;
         var _loc1_:Dictionary = new Dictionary(true);
         for each(_loc2_ in mDefsBySku)
         {
            if(_loc2_.isDaily())
            {
               _loc1_[_loc2_.getSku()] = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function getChainQuestsAmountByFamilyId(param1:int, param2:int, param3:int) : int
      {
         var _loc5_:QuestDef = null;
         var _loc4_:int = 0;
         if(param1 != -1)
         {
            for each(_loc5_ in mDefsBySku)
            {
               if(_loc5_.getBattlePassChainFamilyId() == param1 && _loc5_.getBattlePassSeason() == param2 && _loc5_.getBattlePassSeasonYear() == param3)
               {
                  _loc4_++;
               }
            }
         }
         return _loc4_;
      }
      
      public function getSeasonBattlePassQuests(param1:int = -1, param2:int = -1) : Vector.<QuestDef>
      {
         var _loc4_:QuestDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Vector.<QuestDef> = null;
         if(Config.getConfig().hasBattlePass())
         {
            for each(_loc4_ in mDefsBySku)
            {
               if(Boolean(_loc4_ != null && _loc4_.isBattlePassQuest()) && Boolean(Config.smMonthNumber) && Boolean(Config.smYearNumber))
               {
                  _loc5_ = param1 != -1 ? param1 : int(Config.smMonthNumber.value);
                  _loc6_ = param2 != -1 ? param2 : int(Config.smYearNumber.value);
                  if(_loc5_ != -1 && _loc6_ != -1)
                  {
                     if(_loc4_.getBattlePassSeason() == _loc5_ && (_loc4_.getBattlePassSeasonYear() == _loc6_ || _loc4_.getBattlePassSeasonYear() == -1))
                     {
                        if(_loc3_ == null)
                        {
                           _loc3_ = new Vector.<QuestDef>();
                        }
                        _loc3_.push(_loc4_);
                     }
                  }
               }
            }
            if(_loc3_)
            {
               _loc3_.sort(DictionaryUtils.sortBattlePassQuestDefsByIndex);
            }
         }
         return _loc3_;
      }
   }
}

