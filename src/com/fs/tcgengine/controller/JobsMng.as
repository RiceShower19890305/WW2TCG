package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.JobLevelsDef;
   import com.fs.tcgengine.model.rules.JobRewardsDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.jobs.FSJobSelectedInfo;
   import com.fs.tcgengine.view.jobs.JobExpPanel;
   import com.fs.tcgengine.view.misc.DeckJobConfigurator;
   import com.fs.tcgengine.view.misc.JobPanel;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   
   public class JobsMng
   {
      
      public static const REWARD_TYPE_CARD:int = 0;
      
      public static const REWARD_TYPE_GOLD:int = 1;
      
      public static const REWARD_TYPE_SKILL:int = 2;
      
      public static const REWARD_TYPE_SKIN:int = 3;
      
      public static const REWARD_TYPE_PACK:int = 4;
      
      private static const REWARD_SKIN_IMAGE:String = "level_up_skin_unlocked";
      
      private static const REWARD_GOLD_IMAGE:String = "level_up_gold_obtained";
      
      private static const REWARD_CARDS_IMAGE:String = "level_up_cards_obtained";
      
      private static const REWARD_SKILL_IMAGE:String = "level_up_skill_unlocked";
      
      private static const REWARD_PACKS_IMAGE:String = "level_up_cards_obtained";
      
      public static const STATE_UNLOCKED:int = 0;
      
      public static const STATE_UNLOCKED_NO_CARDS:int = 1;
      
      public static const STATE_LOCKED:int = 2;
      
      public static const STATE_AVAILABLE:int = 3;
      
      public static const STATE_LOCKED_BY_QUEST:int = 4;
      
      public function JobsMng()
      {
         super();
      }
      
      public static function isJobReadyToUnlock(param1:JobDef) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc3_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
            _loc2_ = param1.getUnlockLevel() <= _loc3_;
         }
         return _loc2_;
      }
      
      public static function isJobAvailable(param1:JobDef) : Boolean
      {
         var _loc2_:Boolean = false;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc2_ = InstanceMng.getUserDataMng().getOwnerUserData().isJobAvailable(param1.getSku());
         }
         return _loc2_;
      }
      
      public static function getJobLevel(param1:JobDef) : int
      {
         var _loc3_:JobLevelsDef = null;
         var _loc2_:int = 1;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc3_ = InstanceMng.getJobLevelsDefMng().getJobLevelDefByJobExp(InstanceMng.getUserDataMng().getOwnerUserData().getJobExperienceByJobSku(param1.getSku()));
            if(_loc3_)
            {
               _loc2_ = _loc3_.getLevel();
            }
         }
         return _loc2_;
      }
      
      public static function getJobLevelSku(param1:JobDef) : String
      {
         var _loc3_:JobLevelsDef = null;
         var _loc2_:String = "";
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc3_ = InstanceMng.getJobLevelsDefMng().getJobLevelDefByJobExp(InstanceMng.getUserDataMng().getOwnerUserData().getJobExperienceByJobSku(param1.getSku()));
            if(_loc3_)
            {
               _loc2_ = _loc3_.getSku();
            }
         }
         return _loc2_;
      }
      
      public static function getJobLevelSkuByLevel(param1:int) : String
      {
         var _loc3_:JobLevelsDef = null;
         var _loc2_:String = "";
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc3_ = InstanceMng.getJobLevelsDefMng().getJobLevelDefByLevel(param1);
            if(_loc3_)
            {
               _loc2_ = _loc3_.getSku();
            }
         }
         return _loc2_;
      }
      
      public static function getPercentageExpCurrentLevel(param1:JobDef) : Number
      {
         var _loc3_:JobLevelsDef = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:Number = 0;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            _loc3_ = InstanceMng.getJobLevelsDefMng().getJobLevelDefByJobExp(InstanceMng.getUserDataMng().getOwnerUserData().getJobExperienceByJobSku(param1.getSku()));
            if(_loc3_)
            {
               _loc4_ = _loc3_.getMaxXP() - _loc3_.getMinXP();
               _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getJobExperienceByJobSku(param1.getSku());
               _loc2_ = (_loc5_ - _loc3_.getMinXP()) / _loc4_;
            }
         }
         return _loc2_;
      }
      
      public static function getAllCardsForJobDic(param1:JobDef, param2:Boolean = true) : Dictionary
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:Dictionary = null;
         var _loc10_:Array = null;
         var _loc3_:Array = param1.getRestrictionFactionSkuArr();
         var _loc6_:Dictionary = new Dictionary(true);
         var _loc8_:int = Config.getConfig().getDeckCardsAmount();
         var _loc9_:int = 0;
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc7_ = DictionaryUtils.getCatalogFilteredByFaction(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection(),_loc3_[_loc4_],param2);
               _loc10_ = DictionaryUtils.getKeys(_loc7_);
               if((Boolean(_loc10_)) && _loc10_.length > 0)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc10_.length)
                  {
                     _loc6_[_loc10_[_loc5_]] = _loc7_[_loc10_[_loc5_]];
                     _loc5_++;
                  }
               }
               _loc4_++;
            }
         }
         return _loc6_;
      }
      
      public static function getAllCardsForJob(param1:JobDef) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Dictionary = null;
         var _loc11_:Boolean = false;
         var _loc12_:Array = null;
         var _loc2_:Array = param1.getRestrictionFactionSkuArr();
         var _loc5_:Array = new Array();
         var _loc7_:int = Config.getConfig().getDeckCardsAmount();
         var _loc8_:int = 0;
         var _loc9_:String = param1.getActiveDefaultSku();
         var _loc10_:String = param1.getActiveSecondarySku();
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc6_ = DictionaryUtils.getCatalogFilteredByFaction(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection(),_loc2_[_loc3_]);
               _loc12_ = DictionaryUtils.getKeys(_loc6_);
               if((Boolean(_loc12_)) && _loc12_.length > 0)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc12_.length)
                  {
                     _loc11_ = String(_loc12_[_loc4_]).indexOf("power_") != -1;
                     if(!_loc11_ || _loc11_ && (_loc12_[_loc4_] == _loc9_ || _loc12_[_loc4_] == _loc10_))
                     {
                        _loc5_.push(String(_loc12_[_loc4_] + ":" + _loc6_[_loc12_[_loc4_]]));
                     }
                     _loc4_++;
                  }
               }
               _loc3_++;
            }
         }
         _loc5_.sort(DictionaryUtils.sortCardsByValueAndSubcategory);
         return _loc5_;
      }
      
      public static function haveEnoughCardsForJob(param1:JobDef) : Boolean
      {
         var _loc2_:Boolean = false;
         return getNumCardsForJob(param1) >= Config.getConfig().getDeckCardsAmount();
      }
      
      public static function getNumCardsForJob(param1:JobDef) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Dictionary = null;
         var _loc2_:Boolean = false;
         if(Boolean(param1) && Boolean(param1.getRestrictionFactionSkuArr()) && param1.getRestrictionFactionSkuArr().length > 0)
         {
            _loc5_ = param1.getRestrictionFactionSkuArr();
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc6_ = _loc5_[_loc4_];
               _loc7_ = DictionaryUtils.getCatalogFilteredByFaction(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection(),_loc6_);
               _loc3_ += DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(_loc7_);
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public static function isActiveSecondaryAbilityUnlocked(param1:JobDef) : Boolean
      {
         var _loc2_:int = param1.getUnlockSecondaryAbiliyLevel();
         var _loc3_:int = getJobLevel(param1);
         return _loc3_ >= _loc2_;
      }
      
      public static function getJobSkinSkusArray(param1:JobDef) : Array
      {
         return InstanceMng.getHeroCharactersDefMng().getJobSkinsByJobSku(param1.getSku());
      }
      
      public static function getRewardAsset(param1:JobDef) : String
      {
         var _loc3_:int = 0;
         var _loc4_:JobRewardsDef = null;
         var _loc2_:String = "";
         if(param1)
         {
            _loc3_ = JobsMng.getJobLevel(param1);
            _loc4_ = JobRewardsDef(InstanceMng.getJobRewardsDefMng().getJobRewardDefByJob(param1,_loc3_ + 1));
            if(_loc4_)
            {
               switch(_loc4_.getJobRewardType())
               {
                  case REWARD_TYPE_CARD:
                  case REWARD_TYPE_PACK:
                     _loc2_ = REWARD_CARDS_IMAGE;
                     break;
                  case REWARD_TYPE_GOLD:
                     _loc2_ = REWARD_GOLD_IMAGE;
                     break;
                  case REWARD_TYPE_SKILL:
                     _loc2_ = REWARD_SKILL_IMAGE;
                     break;
                  case REWARD_TYPE_SKIN:
                     _loc2_ = REWARD_SKIN_IMAGE;
               }
            }
         }
         return _loc2_;
      }
      
      public static function getRewardDesc(param1:JobDef) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:JobRewardsDef = null;
         if(param1)
         {
            _loc3_ = JobsMng.getJobLevel(param1);
            _loc4_ = JobRewardsDef(InstanceMng.getJobRewardsDefMng().getJobRewardDefByJob(param1,_loc3_ + 1));
            if(_loc4_)
            {
               _loc2_ = _loc4_.getDesc();
            }
         }
         return _loc2_;
      }
      
      public static function createJobLevelUpPanel(param1:JobDef, param2:int, param3:int, param4:Number, param5:Number, param6:Number, param7:Boolean) : void
      {
         var _loc8_:JobExpPanel = new JobExpPanel(param1,param4,param5,param6);
         _loc8_.x = Starling.current.stage.stageWidth / 2;
         _loc8_.y = -_loc8_.height / 2;
         InstanceMng.getCurrentScreen().addChild(_loc8_);
         _loc8_.showPanel();
         if(param7)
         {
            giveRewardsLevelUp(param1,param2,param3);
         }
      }
      
      private static function giveRewardsLevelUp(param1:JobDef, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:JobRewardsDef = null;
         var _loc7_:RewardDef = null;
         if(param1)
         {
            _loc4_ = param2 + 1;
            for(; _loc4_ <= param3; _loc4_++)
            {
               _loc6_ = JobRewardsDef(InstanceMng.getJobRewardsDefMng().getJobRewardDefByJob(param1,_loc4_));
               if(!_loc6_)
               {
                  continue;
               }
               _loc7_ = RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(_loc6_.getJobRewardSku()));
               _loc5_ = _loc6_.getChestBG();
               switch(_loc6_.getJobRewardType())
               {
                  case REWARD_TYPE_CARD:
                     addCards(_loc7_,_loc4_,param1.getSku(),_loc5_);
                     break;
                  case REWARD_TYPE_GOLD:
                     addGold(_loc7_,_loc4_,param1.getSku(),_loc5_);
                     break;
                  case REWARD_TYPE_SKILL:
                     break;
                  case REWARD_TYPE_SKIN:
                     addSkin(_loc7_,_loc4_,param1.getSku(),_loc5_);
                     break;
                  case REWARD_TYPE_PACK:
                     addPack(_loc7_,_loc4_,param1.getSku(),_loc5_);
               }
            }
         }
      }
      
      private static function addSkin(param1:RewardDef, param2:int, param3:String, param4:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         if(param1)
         {
            _loc5_ = param1.getSkinSku();
            _loc6_ = new Object();
            _loc6_.date = ServerConnection.smServerTimeMS;
            _loc6_.uid = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
            _loc6_.sku = _loc5_;
            _loc6_.type = 2;
            _loc6_.amount = 1;
            _loc6_.origin = "JOBS";
            _loc6_.levelGained = param2;
            _loc6_.extraData = {
               "jobSku":param3,
               "chestBG":param4
            };
            InstanceMng.getServerConnection().createEntityInCollection("rewards",_loc6_);
         }
      }
      
      private static function addGold(param1:RewardDef, param2:int, param3:String, param4:String) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         if(param1)
         {
            _loc5_ = param1.getGold();
            _loc6_ = new Object();
            _loc6_.date = ServerConnection.smServerTimeMS;
            _loc6_.uid = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
            _loc6_.sku = "";
            _loc6_.type = 3;
            _loc6_.amount = _loc5_;
            _loc6_.origin = "JOBS";
            _loc6_.levelGained = param2;
            _loc6_.extraData = {
               "jobSku":param3,
               "chestBG":param4
            };
            InstanceMng.getServerConnection().createEntityInCollection("rewards",_loc6_);
         }
      }
      
      public static function addCards(param1:RewardDef, param2:int, param3:String, param4:String) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(param1)
         {
            _loc5_ = param1.getCardsArr();
            if(_loc5_)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc7_ = new Object();
                  _loc7_.date = ServerConnection.smServerTimeMS;
                  _loc7_.uid = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
                  _loc7_.sku = String(_loc5_[_loc6_]).split(":")[0];
                  _loc7_.type = 0;
                  _loc7_.amount = String(_loc5_[_loc6_]).split(":")[1];
                  _loc7_.origin = "JOBS";
                  _loc7_.levelGained = param2;
                  _loc7_.extraData = {
                     "jobSku":param3,
                     "chestBG":param4
                  };
                  InstanceMng.getServerConnection().createEntityInCollection("rewards",_loc7_);
                  _loc6_++;
               }
            }
         }
      }
      
      public static function addPack(param1:RewardDef, param2:int, param3:String, param4:String) : void
      {
         var _loc5_:Object = null;
         if(param1)
         {
            _loc5_ = new Object();
            _loc5_.date = ServerConnection.smServerTimeMS;
            _loc5_.uid = InstanceMng.getUserDataMng().getOwnerUserData().getAccountId();
            _loc5_.sku = param1.getPackSku();
            _loc5_.type = 1;
            _loc5_.amount = 1;
            _loc5_.origin = "JOBS";
            _loc5_.levelGained = param2;
            _loc5_.extraData = {
               "jobSku":param3,
               "chestBG":param4
            };
            InstanceMng.getServerConnection().createEntityInCollection("rewards",_loc5_);
         }
      }
      
      public static function winJobExperience(param1:Number) : void
      {
         var _loc2_:UserData = null;
         var _loc3_:BattleEngine = null;
         var _loc4_:int = 0;
         var _loc5_:DeckJobConfigurator = null;
         var _loc6_:String = null;
         var _loc7_:JobDef = null;
         if(Config.getConfig().gameHasClassSystem() && param1 > 0)
         {
            _loc2_ = Utils.getOwnerUserData();
            _loc3_ = InstanceMng.getBattleEngine();
            _loc4_ = Boolean(_loc3_) && _loc3_.isPvPMatch() ? _loc2_.getSelectedDeckIndexPvP() : _loc2_.getSelectedDeckIndex();
            if(_loc4_ >= Config.getConfig().getMaxDecksAmount())
            {
               _loc7_ = InstanceMng.getJobsDefMng().getBasicJobByDeck(String(_loc4_));
               _loc6_ = _loc7_.getSku();
            }
            else
            {
               _loc5_ = _loc2_.getDeckJobConfiguratorByDeck(_loc4_);
               if(_loc5_)
               {
                  _loc6_ = _loc5_.getJobSku();
                  _loc7_ = JobDef(InstanceMng.getJobsDefMng().getDefBySku(_loc6_));
               }
            }
            if(Boolean(_loc6_) && _loc6_ != "")
            {
               winXPByJob(_loc7_,param1);
            }
         }
      }
      
      public static function winXPByJob(param1:JobDef, param2:int) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(Boolean(_loc3_) && Boolean(param1) && param2 > 0)
         {
            _loc4_ = param1.getSku();
            _loc5_ = JobsMng.getJobLevel(param1);
            _loc6_ = _loc3_.getJobExperienceByJobSku(_loc4_);
            _loc7_ = willLevelUpAfterWinningExp(param1,_loc6_,param2);
            _loc8_ = _loc6_ + param2;
            _loc3_.addJobExperienceByJobSku(_loc4_,param2);
            InstanceMng.getUserDataMng().updateJobsExperience();
            _loc9_ = JobsMng.getJobLevel(param1);
            JobsMng.createJobLevelUpPanel(param1,_loc5_,_loc9_,param2,_loc6_,_loc8_,_loc7_);
         }
      }
      
      public static function willLevelUpAfterWinningExp(param1:JobDef, param2:Number, param3:Number) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:JobLevelsDef = InstanceMng.getJobLevelsDefMng().getJobLevelDefByJobExp(param2);
         if(_loc5_)
         {
            _loc6_ = _loc5_.getLevel();
            _loc5_ = InstanceMng.getJobLevelsDefMng().getJobLevelDefByJobExp(param2 + param3);
            _loc7_ = _loc5_ ? _loc5_.getLevel() : -1;
            return _loc6_ < _loc7_;
         }
         return false;
      }
      
      public static function getJobState(param1:JobDef) : int
      {
         var _loc2_:int = STATE_LOCKED;
         if(isJobReadyToUnlock(param1) && isJobAvailable(param1) && haveEnoughCardsForJob(param1))
         {
            return STATE_UNLOCKED;
         }
         if(param1.isLockedByQuest() && !InstanceMng.getUserDataMng().getOwnerUserData().isQuestAlreadyClaimed(param1.getLockedByQuestSku()))
         {
            return STATE_LOCKED_BY_QUEST;
         }
         if(isJobReadyToUnlock(param1) && isJobAvailable(param1) && !haveEnoughCardsForJob(param1))
         {
            return STATE_UNLOCKED_NO_CARDS;
         }
         if(isJobReadyToUnlock(param1) && !isJobAvailable(param1))
         {
            return STATE_AVAILABLE;
         }
         if(!isJobReadyToUnlock(param1))
         {
            return STATE_LOCKED;
         }
         return _loc2_;
      }
      
      public static function buyJob(param1:JobDef, param2:FSJobSelectedInfo = null, param3:Boolean = true) : void
      {
         var userGold:int;
         var owner:UserData = null;
         var onJobPurchased:Function = null;
         var jobDef:JobDef = param1;
         var parentJobSelectedInfo:FSJobSelectedInfo = param2;
         var notifyViaLog:Boolean = param3;
         onJobPurchased = function(param1:Boolean = true):void
         {
            var _loc2_:JobPanel = null;
            owner.addJobToCatalog(jobDef.getSku());
            if(parentJobSelectedInfo != null)
            {
               parentJobSelectedInfo.removeJobLockImage();
               _loc2_ = parentJobSelectedInfo.getParentPanel();
               if(_loc2_)
               {
                  _loc2_.updateInfoText();
                  _loc2_.switchSelectButtonStateToSelect();
               }
            }
            if(param1)
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_JOBS_CONGRATULATIONS"),[jobDef.getName()]));
            }
            Utils.playSound("unlock_job",SoundManager.TYPE_SFX);
            InstanceMng.getUserDataMng().persistenceSaveData();
         };
         if(jobDef == null)
         {
            return;
         }
         owner = Utils.getOwnerUserData();
         userGold = owner.getGold();
         if(userGold >= jobDef.getUnlockCost())
         {
            if(jobDef.getUnlockCost() > 0)
            {
               owner.substractGold(-jobDef.getUnlockCost(),onJobPurchased,[notifyViaLog],Utils.showNotEnoughCurrencyMessage,[ServerConnection.CURRENCY_GOLD]);
            }
            else
            {
               onJobPurchased(notifyViaLog);
            }
         }
         else
         {
            Utils.showNotEnoughCurrencyMessage(ServerConnection.CURRENCY_GOLD);
         }
      }
   }
}

