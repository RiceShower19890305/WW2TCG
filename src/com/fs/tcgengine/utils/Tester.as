package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.RewardDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.cards.FSCard;
   import flash.utils.Dictionary;
   
   public class Tester
   {
      
      private static const THROW_ERROR:Boolean = true;
      
      private static var mTestsDone:Boolean = false;
      
      public function Tester()
      {
         super();
      }
      
      public static function startTest() : void
      {
         if(!mTestsDone)
         {
            reviewCardsAbilities();
            checkIncorrectAbilities();
            checkLevelsRewards();
            checkTexts();
            checkChances();
            mTestsDone = true;
         }
      }
      
      private static function checkTexts() : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc1_:String = TextManager.smLang;
         var _loc2_:Dictionary = Config.getConfig().getLanguagesSupported();
         if(_loc2_)
         {
            _loc3_ = DictionaryUtils.getKeys(_loc2_);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               TextManager.loadLang(_loc3_[_loc4_]);
               _loc4_++;
            }
         }
         FSDebug.debugTrace("MISSING TEXTS IN SPECIFIC LOCALE ARE: " + TextManager.smMissingTexts);
         FSDebug.debugTrace("GLYPHS FOUND IN TEXTS IN NON ORIENTAL LOCALE ARE: " + TextManager.smGlyphedTexts);
         TextManager.loadLang(_loc1_);
      }
      
      private static function reviewCardsAbilities() : void
      {
         var k:int = 0;
         var familyIdsCatalogUnits:Dictionary = null;
         var familyIdsCatalogAttachments:Dictionary = null;
         var familyIdsCatalogActions:Dictionary = null;
         var keys:Array = null;
         var processTestResult:Function = function(param1:Object, param2:String, param3:String, param4:String = "", param5:Boolean = false):void
         {
            if(param1[param2] != null)
            {
               keys = DictionaryUtils.getKeys(param1[param2]);
               if(keys != null && keys.length > 0)
               {
                  FSDebug.debugTrace("\n\n" + param3 + ":");
                  k = 0;
                  while(k < keys.length)
                  {
                     FSDebug.debugTrace(keys[k] + " -> " + param1[param2][keys[k]]);
                     ++k;
                  }
                  if(THROW_ERROR && param5)
                  {
                     throw new Error(param4);
                  }
               }
            }
         };
         var processCards:Function = function(param1:Array, param2:Object):Object
         {
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc6_:String = null;
            var _loc7_:AbilityDef = null;
            var _loc8_:Array = null;
            var _loc9_:CardDef = null;
            var _loc10_:String = null;
            var _loc11_:String = null;
            var _loc12_:String = null;
            var _loc13_:String = null;
            var _loc14_:Boolean = false;
            var _loc15_:int = 0;
            var _loc16_:int = 0;
            var _loc17_:int = 0;
            var _loc18_:int = 0;
            var _loc19_:int = 0;
            var _loc20_:int = 0;
            var _loc21_:String = null;
            var _loc22_:int = 0;
            var _loc23_:String = null;
            var _loc25_:String = null;
            var _loc26_:Boolean = false;
            var _loc27_:Boolean = false;
            var _loc28_:String = null;
            var _loc29_:String = null;
            var _loc30_:Boolean = false;
            var _loc31_:Boolean = false;
            var _loc32_:int = 0;
            var _loc33_:String = null;
            var _loc34_:Array = null;
            var _loc35_:Boolean = false;
            var _loc36_:Boolean = false;
            var _loc37_:String = null;
            var _loc38_:int = 0;
            var _loc39_:int = 0;
            var _loc40_:String = null;
            var _loc41_:String = null;
            var _loc42_:Boolean = false;
            var _loc43_:Boolean = false;
            var _loc44_:int = 0;
            var _loc5_:int = 0;
            var _loc24_:Boolean = false;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc6_ = param1[_loc3_];
               _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_));
               if(_loc9_)
               {
                  _loc25_ = _loc9_.getFactionSku();
                  _loc24_ = false;
                  if(_loc9_.isLeader())
                  {
                     _loc34_ = _loc9_.getAllowedToPlayOnFactionDecks();
                     if(_loc34_ == null)
                     {
                        _loc24_ = true;
                     }
                     if(!_loc24_ && _loc34_ != null)
                     {
                        _loc35_ = false;
                        _loc4_ = 0;
                        while(_loc4_ < _loc34_.length)
                        {
                           if(_loc25_ == _loc34_[_loc4_])
                           {
                              _loc35_ = true;
                              break;
                           }
                           _loc4_++;
                        }
                        if(!_loc35_)
                        {
                           _loc24_ = true;
                        }
                     }
                     if(!_loc24_)
                     {
                        _loc8_ = _loc9_.getAllAbilitiesDefsBreakdown();
                        _loc36_ = false;
                        if(_loc8_ != null && _loc8_.length > 0)
                        {
                           _loc5_ = 0;
                           while(_loc5_ < _loc8_.length)
                           {
                              if(AbilityDef(_loc8_[_loc5_]).getKeyName() == AbilitiesMng.SPECIAL_LEADER)
                              {
                                 _loc36_ = true;
                                 break;
                              }
                              _loc5_++;
                           }
                           if(!_loc36_)
                           {
                              _loc24_ = true;
                           }
                        }
                     }
                  }
                  if(_loc24_)
                  {
                     if(!param2["wrongLeaders"].hasOwnProperty(_loc9_.getSku()))
                     {
                        param2["wrongLeaders"][_loc9_.getSku()] = "";
                     }
                     param2["wrongLeaders"][_loc9_.getSku()] = param2["wrongLeaders"][_loc9_.getSku()] + (param2["wrongLeaders"][_loc9_.getSku()] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")");
                  }
                  if(_loc9_.getCategoryIndex() == CategoriesDefMng.CATEGORY_ATTACHMENTS)
                  {
                     _loc8_ = _loc9_.getAllAbilitiesDefsBreakdown();
                     if(_loc8_ != null && _loc8_.length > 0)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < _loc8_.length)
                        {
                           if(InstanceMng.getAbilitiesMng().isTargetSelectionAbility(AbilityDef(_loc8_[_loc5_])))
                           {
                              if(!param2["attachmentsWithTargetSelectionAbs"].hasOwnProperty(_loc9_.getSku()))
                              {
                                 param2["attachmentsWithTargetSelectionAbs"][_loc9_.getSku()] = "";
                              }
                              param2["attachmentsWithTargetSelectionAbs"][_loc9_.getSku()] = param2["attachmentsWithTargetSelectionAbs"][_loc9_.getSku()] + (param2["attachmentsWithTargetSelectionAbs"][_loc9_.getSku()] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")");
                           }
                           _loc5_++;
                        }
                     }
                  }
                  _loc28_ = _loc9_.getUpgradeSku();
                  _loc29_ = _loc9_.getPreviousUpgradeSku();
                  _loc30_ = _loc28_ != "" && _loc28_ != null;
                  _loc31_ = _loc29_ != "" && _loc29_ != null;
                  if(_loc30_ || _loc31_)
                  {
                     if(_loc30_)
                     {
                        if(InstanceMng.getCardsDefMng().getDefBySku(_loc28_) == null)
                        {
                           if(!param2["upgradeSkuNonExistent"].hasOwnProperty(_loc9_.getSku()))
                           {
                              param2["upgradeSkuNonExistent"][_loc9_.getSku()] = "";
                           }
                           param2["upgradeSkuNonExistent"][_loc9_.getSku()] = param2["upgradeSkuNonExistent"][_loc9_.getSku()] + (param2["upgradeSkuNonExistent"][_loc9_.getSku()] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")");
                        }
                     }
                     if(_loc31_)
                     {
                        if(InstanceMng.getCardsDefMng().getDefBySku(_loc29_) == null)
                        {
                           if(!param2["upgradeSkuNonExistent"].hasOwnProperty(_loc9_.getSku()))
                           {
                              param2["upgradeSkuNonExistent"][_loc9_.getSku()] = "";
                           }
                           param2["upgradeSkuNonExistent"][_loc9_.getSku()] = param2["upgradeSkuNonExistent"][_loc9_.getSku()] + (param2["upgradeSkuNonExistent"][_loc9_.getSku()] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")");
                        }
                     }
                  }
                  _loc12_ = _loc9_.getType() == FSCard.TYPE_UNIT ? (_loc9_ as UnitDef).getOnPlaySound() : "";
                  _loc13_ = _loc9_.getType() == FSCard.TYPE_UNIT ? (_loc9_ as UnitDef).getDamageAudioName() : "";
                  if(_loc12_ != "" && _loc12_ != null)
                  {
                     _loc14_ = InstanceMng.getResourcesMng().checkIfFileExists(InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_AUDIO) + "fx/" + _loc12_ + ".mp3");
                     if(!_loc14_)
                     {
                        if(!param2["soundNotFound"].hasOwnProperty(_loc12_))
                        {
                           param2["soundNotFound"][_loc12_] = "";
                        }
                        param2["soundNotFound"][_loc12_] += param2["soundNotFound"][_loc12_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                     }
                  }
                  if(_loc9_.getName() == null)
                  {
                     if(!param2["missingInfo"].hasOwnProperty(_loc9_.getSku()))
                     {
                        param2["missingInfo"][_loc9_.getSku()] = "";
                     }
                     param2["missingInfo"][_loc9_.getSku()] = param2["missingInfo"][_loc9_.getSku()] + (param2["missingInfo"][_loc9_.getSku()] != "" ? ", " + _loc9_.getSku() : _loc9_.getSku());
                  }
                  if(_loc13_ != "" && _loc13_ != null)
                  {
                     _loc14_ = InstanceMng.getResourcesMng().checkIfFileExists(InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_AUDIO) + "battleFX/" + _loc13_ + ".mp3");
                     if(!_loc14_)
                     {
                        if(!param2["soundNotFound"].hasOwnProperty(_loc13_))
                        {
                           param2["soundNotFound"][_loc13_] = "";
                        }
                        param2["soundNotFound"][_loc13_] += param2["soundNotFound"][_loc13_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                     }
                  }
                  _loc23_ = _loc9_.getCardSkinSku();
                  _loc22_ = _loc9_.getCardSkinAmountCards();
                  _loc21_ = _loc23_;
                  if(_loc21_ != "" && _loc21_ != null)
                  {
                     if(_loc22_ == 0)
                     {
                        if(!param2["skinSkuError"].hasOwnProperty(_loc21_))
                        {
                           param2["skinSkuError"][_loc21_] = "";
                        }
                        param2["skinSkuError"][_loc21_] += param2["skinSkuError"][_loc21_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                     }
                  }
                  _loc15_ = _loc9_.getFusionAmountCards();
                  _loc16_ = _loc9_.getFusionCost();
                  _loc17_ = _loc9_.getCraftAmountCards();
                  _loc18_ = _loc9_.getCraftCost();
                  _loc19_ = _loc9_.getExtraCraftAmountCards();
                  _loc20_ = _loc9_.getFusionAmountExtraCards();
                  _loc21_ = _loc9_.getFusionSku();
                  if(_loc21_ != "" && _loc21_ != null)
                  {
                     if(_loc15_ == 0 || _loc16_ == 0)
                     {
                        if(!param2["fusionWrong"].hasOwnProperty(_loc21_))
                        {
                           param2["fusionWrong"][_loc21_] = "";
                        }
                        param2["fusionWrong"][_loc21_] += param2["fusionWrong"][_loc21_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                     }
                  }
                  _loc21_ = _loc9_.getExtraFusionSku();
                  if(_loc21_ != "" && _loc21_ != null)
                  {
                     if(_loc20_ == 0)
                     {
                        if(!param2["extraFusionSku"].hasOwnProperty(_loc21_))
                        {
                           param2["extraFusionSku"][_loc21_] = "";
                        }
                        param2["extraFusionSku"][_loc21_] += param2["extraFusionSku"][_loc21_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                     }
                  }
                  _loc21_ = _loc9_.getCraftSku();
                  if(_loc21_ != "" && _loc21_ != null)
                  {
                     if(_loc17_ == 0 || _loc18_ == 0)
                     {
                        if(!param2["craftWrong"].hasOwnProperty(_loc21_))
                        {
                           param2["craftWrong"][_loc21_] = "";
                        }
                        param2["craftWrong"][_loc21_] += param2["craftWrong"][_loc21_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                     }
                  }
                  _loc21_ = _loc9_.getExtraCraftSku();
                  if(_loc21_ != "" && _loc21_ != null)
                  {
                     if(_loc19_ == 0)
                     {
                        if(!param2["extraCraftSku"].hasOwnProperty(_loc21_))
                        {
                           param2["extraCraftSku"][_loc21_] = "";
                        }
                        param2["extraCraftSku"][_loc21_] += param2["extraCraftSku"][_loc21_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                     }
                  }
                  _loc8_ = _loc9_.getAllAbilitiesDefsBreakdown();
                  if((Boolean(_loc8_)) && _loc8_.length > 0)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc8_.length)
                     {
                        _loc7_ = AbilityDef(_loc8_[_loc4_]);
                        if(_loc7_)
                        {
                           _loc37_ = _loc7_.getKeyName();
                           _loc38_ = _loc7_.getTargetIndex();
                           _loc39_ = _loc7_.getTriggerIndex();
                           _loc40_ = _loc9_.getPreviousUpgradeSku();
                           _loc41_ = _loc9_.getUpgradeSku();
                           _loc42_ = _loc37_ == AbilitiesMng.SPECIAL_DEMOTE || _loc37_ == AbilitiesMng.SPECIAL_TOTALDEMOTE;
                           _loc43_ = _loc37_ == AbilitiesMng.SPECIAL_BETTEREQUIP || _loc37_ == AbilitiesMng.SPECIAL_FULLPROMOTE;
                           _loc10_ = _loc7_.getSku() + " (" + _loc7_.getName() + ")";
                           if(_loc38_ == 13)
                           {
                              if((_loc41_ == "" || _loc41_ == null) && _loc43_)
                              {
                                 if(!param2["promoteWithNoMoreTiers"].hasOwnProperty(_loc10_))
                                 {
                                    param2["promoteWithNoMoreTiers"][_loc10_] = "";
                                 }
                                 param2["promoteWithNoMoreTiers"][_loc10_] += param2["promoteWithNoMoreTiers"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                              }
                              if((_loc40_ == "" || _loc40_ == null) && _loc42_)
                              {
                                 if(!param2["demoteWithNoMoreTiers"].hasOwnProperty(_loc10_))
                                 {
                                    param2["demoteWithNoMoreTiers"][_loc10_] = "";
                                 }
                                 param2["demoteWithNoMoreTiers"][_loc10_] += param2["demoteWithNoMoreTiers"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                              }
                           }
                           if(!_loc7_.isIconVisible())
                           {
                              if(!param2["absNoVisible"].hasOwnProperty(_loc10_))
                              {
                                 param2["absNoVisible"][_loc10_] = "";
                              }
                              param2["absNoVisible"][_loc10_] += param2["absNoVisible"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           if(!_loc7_.isIconVisibleInXLView())
                           {
                              if(!param2["absNoVisibleXL"].hasOwnProperty(_loc10_))
                              {
                                 param2["absNoVisibleXL"][_loc10_] = "";
                              }
                              param2["absNoVisibleXL"][_loc10_] += param2["absNoVisibleXL"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           _loc44_ = _loc7_.getDuration();
                           if(_loc44_ == 1 && (_loc39_ == 0 || _loc39_ == 1 || _loc39_ == 4))
                           {
                              if(!param2["abDuration"].hasOwnProperty(_loc10_))
                              {
                                 param2["abDuration"][_loc10_] = "";
                              }
                              param2["abDuration"][_loc10_] += param2["abDuration"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           if(!_loc7_.isSpecial() && _loc7_.getKeyName() != "" && _loc7_.getKeyName() != null)
                           {
                              if(!param2["abKeynameNoSpecial"].hasOwnProperty(_loc10_))
                              {
                                 param2["abKeynameNoSpecial"][_loc10_] = "";
                              }
                              param2["abKeynameNoSpecial"][_loc10_] += param2["abKeynameNoSpecial"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           if(InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc7_) && (_loc7_.getTriggerIndex() != AbilitiesMng.TRIGGERS_ON_PLAY && _loc7_.getTriggerIndex() != -1) && !_loc7_.isParentAbility())
                           {
                              if(!param2["abTargetSelectionWrongTrigger"].hasOwnProperty(_loc10_))
                              {
                                 param2["abTargetSelectionWrongTrigger"][_loc10_] = "";
                              }
                              param2["abTargetSelectionWrongTrigger"][_loc10_] += param2["abTargetSelectionWrongTrigger"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           if(InstanceMng.getAbilitiesMng().isRandomTargetAbility(_loc7_) && (_loc7_.getTriggerIndex() != AbilitiesMng.TRIGGERS_ON_PLAY && _loc7_.getTriggerIndex() != AbilitiesMng.TRIGGERS_ON_PROMOTE && _loc7_.getTriggerIndex() != -1) && !_loc7_.isParentAbility())
                           {
                              if(!param2["abRandomWrongTrigger"].hasOwnProperty(_loc10_))
                              {
                                 param2["abRandomWrongTrigger"][_loc10_] = "";
                              }
                              param2["abRandomWrongTrigger"][_loc10_] += param2["abRandomWrongTrigger"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           if(_loc9_.getCategoryIndex() != CategoriesDefMng.CATEGORY_ACTIONS)
                           {
                              if(InstanceMng.getAbilitiesMng().isRandomTargetAbility(_loc7_) && InstanceMng.getAbilitiesMng().isRandomStatsAbility(_loc7_))
                              {
                                 if(!param2["abRandomStatsAndTarget"].hasOwnProperty(_loc10_))
                                 {
                                    param2["abRandomStatsAndTarget"][_loc10_] = "";
                                 }
                                 param2["abRandomStatsAndTarget"][_loc10_] += param2["abRandomStatsAndTarget"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                              }
                           }
                           if(InstanceMng.getAbilitiesMng().isRandomStatsAbility(_loc7_) && (_loc7_.getTriggerIndex() != AbilitiesMng.TRIGGERS_ON_PLAY && _loc7_.getTriggerIndex() != AbilitiesMng.TRIGGERS_ON_PROMOTE && _loc7_.getTriggerIndex() != -1) && !_loc7_.isParentAbility())
                           {
                              if(!param2["abRandomStatsWrongTrigger"].hasOwnProperty(_loc10_))
                              {
                                 param2["abRandomStatsWrongTrigger"][_loc10_] = "";
                              }
                              param2["abRandomStatsWrongTrigger"][_loc10_] += param2["abRandomStatsWrongTrigger"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           if(_loc7_.getTriggerIndex() == AbilitiesMng.TRIGGERS_ON_PROMOTE && _loc7_.getChances() != null)
                           {
                              if(!param2["multiCastOnPromotion"].hasOwnProperty(_loc10_))
                              {
                                 param2["multiCastOnPromotion"][_loc10_] = "";
                              }
                              param2["multiCastOnPromotion"][_loc10_] += param2["abRandomWrongTrigger"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           if(_loc7_.getTriggerIndex() == AbilitiesMng.TRIGGERS_ON_PROMOTE && (_loc7_.getRandomDamageAmount() != 0 || _loc7_.getRandomDefenseAmount() != 0 || _loc7_.getRandomHealAmount() != 0))
                           {
                              if(!param2["randomOnPromotion"].hasOwnProperty(_loc10_))
                              {
                                 param2["randomOnPromotion"][_loc10_] = "";
                              }
                              param2["randomOnPromotion"][_loc10_] += param2["randomOnPromotion"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                           }
                           _loc12_ = _loc7_.getSoundName();
                           if(_loc12_ != "" && _loc12_ != null)
                           {
                              _loc14_ = InstanceMng.getResourcesMng().checkIfFileExists(InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_AUDIO) + "battleFX/" + _loc12_ + ".mp3");
                              if(!_loc14_)
                              {
                                 if(!param2["abSoundNotFound"].hasOwnProperty(_loc12_))
                                 {
                                    param2["abSoundNotFound"][_loc12_] = "";
                                 }
                                 param2["abSoundNotFound"][_loc12_] += param2["abSoundNotFound"][_loc12_] != "" ? ", " + _loc7_.getSku() + "(" + _loc7_.getName() + ")" : _loc7_.getSku() + "(" + _loc7_.getName() + ")";
                              }
                           }
                        }
                        else
                        {
                           _loc10_ = _loc8_[_loc4_];
                           if(!param2["abTypo"].hasOwnProperty(_loc10_))
                           {
                              param2["abTypo"][_loc10_] = "";
                           }
                           param2["abTypo"][_loc10_] += param2["abTypo"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                        }
                        _loc4_++;
                     }
                     if(Utils.hasDuplicate(_loc8_))
                     {
                        _loc4_ = 0;
                        while(_loc4_ < _loc8_.length)
                        {
                           _loc11_ += _loc11_ != "" ? ", " + AbilityDef(_loc8_[_loc4_]).getSku() + " (" + AbilityDef(_loc8_[_loc4_]).getName() + ")" : AbilityDef(_loc8_[_loc4_]).getSku() + " (" + AbilityDef(_loc8_[_loc4_]).getName() + ")";
                           _loc4_++;
                        }
                        param2["duplicated"][_loc9_.getSku() + "(" + _loc9_.getName() + ")"] = _loc11_;
                     }
                     _loc4_ = 0;
                     while(_loc4_ < _loc8_.length)
                     {
                        _loc7_ = AbilityDef(_loc8_[_loc4_]);
                        if(_loc7_)
                        {
                           _loc10_ = _loc7_.getSku();
                           if(_loc7_.getKeyName() == AbilitiesMng.SPECIAL_FIXEDCOST || _loc7_.getKeyName() == AbilitiesMng.SPECIAL_MODIFYCOST)
                           {
                              if(_loc9_.getType() != FSCard.TYPE_POWER && _loc7_.getDuration() == -1)
                              {
                                 if(!param2["costModifier"].hasOwnProperty(_loc10_))
                                 {
                                    param2["costModifier"][_loc10_] = "";
                                 }
                                 param2["costModifier"][_loc10_] += param2["costModifier"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                              }
                           }
                        }
                        _loc4_++;
                     }
                  }
                  _loc8_ = _loc9_.getNullAbilities();
                  if((Boolean(_loc8_)) && _loc8_.length > 0)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc8_.length)
                     {
                        _loc10_ = _loc8_[_loc4_];
                        if(!param2["abTypo"].hasOwnProperty(_loc10_))
                        {
                           param2["abTypo"][_loc10_] = "";
                        }
                        param2["abTypo"][_loc10_] += param2["abTypo"][_loc10_] != "" ? ", " + _loc9_.getSku() + "(" + _loc9_.getName() + ")" : _loc9_.getSku() + "(" + _loc9_.getName() + ")";
                        _loc4_++;
                     }
                  }
                  _loc32_ = _loc9_.getDeckFamilyID();
                  _loc33_ = _loc9_.getSku();
                  if(_loc32_ != 0)
                  {
                     if(_loc9_ is UnitDef)
                     {
                        if(familyIdsCatalogUnits == null)
                        {
                           familyIdsCatalogUnits = new Dictionary(true);
                        }
                        if(familyIdsCatalogAttachments != null && familyIdsCatalogAttachments[_loc32_] != null)
                        {
                           if(!param2["familyIdError"].hasOwnProperty(_loc32_))
                           {
                              param2["familyIdError"][_loc32_] = "";
                           }
                           param2["familyIdError"][_loc32_] += param2["familyIdError"][_loc32_] != "" ? ", " + _loc33_ + "(" + _loc9_.getName() + ")" : _loc33_ + "(" + _loc9_.getName() + ")";
                        }
                        else if(familyIdsCatalogActions != null && familyIdsCatalogActions[_loc32_] != null)
                        {
                           if(!param2["familyIdError"].hasOwnProperty(_loc32_))
                           {
                              param2["familyIdError"][_loc32_] = "";
                           }
                           param2["familyIdError"][_loc32_] += param2["familyIdError"][_loc32_] != "" ? ", " + _loc33_ + "(" + _loc9_.getName() + ")" : _loc33_ + "(" + _loc9_.getName() + ")";
                        }
                        else
                        {
                           familyIdsCatalogUnits[_loc32_] += familyIdsCatalogUnits[_loc32_] != null && familyIdsCatalogUnits[_loc32_] != "" ? "," + _loc33_ : _loc33_;
                        }
                     }
                     else if(_loc9_ is AttachmentDef)
                     {
                        if(_loc33_ == "attach_700")
                        {
                           FSDebug.debugTrace("");
                        }
                        if(familyIdsCatalogAttachments == null)
                        {
                           familyIdsCatalogAttachments = new Dictionary(true);
                        }
                        if(familyIdsCatalogUnits != null && familyIdsCatalogUnits[_loc32_] != null)
                        {
                           if(!param2["familyIdError"].hasOwnProperty(_loc32_))
                           {
                              param2["familyIdError"][_loc32_] = "";
                           }
                           param2["familyIdError"][_loc32_] += param2["familyIdError"][_loc32_] != "" ? ", " + _loc33_ + "(" + _loc9_.getName() + ")" : _loc33_ + "(" + _loc9_.getName() + ")";
                        }
                        else if(familyIdsCatalogActions != null && familyIdsCatalogActions[_loc32_] != null)
                        {
                           if(!param2["familyIdError"].hasOwnProperty(_loc32_))
                           {
                              param2["familyIdError"][_loc32_] = "";
                           }
                           param2["familyIdError"][_loc32_] += param2["familyIdError"][_loc32_] != "" ? ", " + _loc33_ + "(" + _loc9_.getName() + ")" : _loc33_ + "(" + _loc9_.getName() + ")";
                        }
                        else
                        {
                           familyIdsCatalogAttachments[_loc32_] += familyIdsCatalogAttachments[_loc32_] != null && familyIdsCatalogAttachments[_loc32_] != "" ? "," + _loc33_ : _loc33_;
                        }
                     }
                     else if(_loc9_ is ActionDef)
                     {
                        if(familyIdsCatalogActions == null)
                        {
                           familyIdsCatalogActions = new Dictionary(true);
                        }
                        if(familyIdsCatalogUnits != null && familyIdsCatalogUnits[_loc32_] != null)
                        {
                           if(!param2["familyIdError"].hasOwnProperty(_loc32_))
                           {
                              param2["familyIdError"][_loc32_] = "";
                           }
                           param2["familyIdError"][_loc32_] += param2["familyIdError"][_loc32_] != "" ? ", " + _loc33_ + "(" + _loc9_.getName() + ")" : _loc33_ + "(" + _loc9_.getName() + ")";
                        }
                        else if(familyIdsCatalogAttachments != null && familyIdsCatalogAttachments[_loc32_] != null)
                        {
                           if(!param2["familyIdError"].hasOwnProperty(_loc32_))
                           {
                              param2["familyIdError"][_loc32_] = "";
                           }
                           param2["familyIdError"][_loc32_] += param2["familyIdError"][_loc32_] != "" ? ", " + _loc33_ + "(" + _loc9_.getName() + ")" : _loc33_ + "(" + _loc9_.getName() + ")";
                        }
                        else
                        {
                           familyIdsCatalogActions[_loc32_] += familyIdsCatalogActions[_loc32_] != null && familyIdsCatalogActions[_loc32_] != "" ? "," + _loc33_ : _loc33_;
                        }
                     }
                  }
               }
               _loc3_++;
            }
            return param2;
         };
         var unitDefs:Dictionary = InstanceMng.getUnitsDefMng().getAllDefs();
         var attachmentDefs:Dictionary = InstanceMng.getAttachmentsDefMng().getAllDefs();
         var actionDefs:Dictionary = InstanceMng.getActionsDefMng().getAllDefs();
         var powerDefs:Dictionary = InstanceMng.getPowerDefMng().getAllDefs();
         var unitDefsKeysArr:Array = DictionaryUtils.getKeys(unitDefs);
         var attachmentDefskeysArr:Array = DictionaryUtils.getKeys(attachmentDefs);
         var actionDefsKeysArr:Array = DictionaryUtils.getKeys(actionDefs);
         var powerDefsKeysArr:Array = DictionaryUtils.getKeys(powerDefs);
         var result:Object = new Object();
         result["absNoVisible"] = new Dictionary(true);
         result["absNoVisibleXL"] = new Dictionary(true);
         result["duplicated"] = new Dictionary(true);
         result["costModifier"] = new Dictionary(true);
         result["abTypo"] = new Dictionary(true);
         result["soundNotFound"] = new Dictionary(true);
         result["missingInfo"] = new Dictionary(true);
         result["abSoundNotFound"] = new Dictionary(true);
         result["abDuration"] = new Dictionary(true);
         result["abKeynameNoSpecial"] = new Dictionary(true);
         result["abTargetSelectionWrongTrigger"] = new Dictionary(true);
         result["fusionWrong"] = new Dictionary(true);
         result["craftWrong"] = new Dictionary(true);
         result["extraCraftSku"] = new Dictionary(true);
         result["extraFusionSku"] = new Dictionary(true);
         result["familyIdError"] = new Dictionary(true);
         result["skinSkuError"] = new Dictionary(true);
         result["multiCastOnPromotion"] = new Dictionary(true);
         result["randomOnPromotion"] = new Dictionary(true);
         result["abRandomWrongTrigger"] = new Dictionary(true);
         result["abRandomStatsWrongTrigger"] = new Dictionary(true);
         result["attachmentsWithTargetSelectionAbs"] = new Dictionary(true);
         result["wrongLeaders"] = new Dictionary(true);
         result["promoteWithNoMoreTiers"] = new Dictionary(true);
         result["demoteWithNoMoreTiers"] = new Dictionary(true);
         result["upgradeSkuNonExistent"] = new Dictionary(true);
         result["abRandomStatsAndTarget"] = new Dictionary(true);
         result = processCards(unitDefsKeysArr,result);
         result = processCards(attachmentDefskeysArr,result);
         result = processCards(actionDefsKeysArr,result);
         result = processCards(powerDefsKeysArr,result);
         if(result != null)
         {
            processTestResult(result,"abTypo","ABILITIES TYPOS","Typos found on some abilities! -> Check console to find out which ones!",true);
            processTestResult(result,"absNoVisible","NO VISIBLE");
            processTestResult(result,"absNoVisibleXL","NO VISIBLE XL");
            processTestResult(result,"duplicated","DUPLICATED","Duplicated variables found! -> Check console to find out which ones!",true);
            processTestResult(result,"costModifier","COST MODIFIER","Cost modifier abilities found on cards with duration == -1 -> Check console to find out which ones!",true);
            processTestResult(result,"soundNotFound","SOUNDS NOT FOUND","Some card sounds not found -> Check console to find out which ones!",true);
            processTestResult(result,"missingInfo","CARD NAME OR DESC NOT FOUND","Some card names or sounds were not found -> Check console to find out which ones!",true);
            processTestResult(result,"abSoundNotFound","ABILITIES SOUNDs NOT FOUND","Some ability sounds not found -> Check console to find out which ones!",true);
            processTestResult(result,"abDuration","nDURATION = 1 AND TRIGGER INDEX= 0 OR 1 OR 4");
            processTestResult(result,"abKeynameNoSpecial","Has KEYNAME but not set as SPECIAL","Found abilities with KEYNAME but not set to SPECIAL",true);
            processTestResult(result,"abTargetSelectionWrongTrigger","Found abilities with Target Selection but wrong TRIGGER index","Found abilities with Target Selection but wrong TRIGGER index",true);
            processTestResult(result,"abRandomWrongTrigger","Found abilities with random targets and wrong TRIGGER index","Found abilities with random targets and wrong TRIGGER index",true);
            processTestResult(result,"abRandomStatsAndTarget","Found abilities with random targets and random stats","Found abilities with random targets and random stats",true);
            processTestResult(result,"abRandomStatsWrongTrigger","Found abilities with random dmg/heal/def and wrong TRIGGER index","Found abilities with random dmg/heal/def and wrong TRIGGER index",true);
            processTestResult(result,"attachmentsWithTargetSelectionAbs","Found attachments with target sel. abilities","Found attachments with target sel. abilities",true);
            processTestResult(result,"wrongLeaders","Found leaders with wrong data (allowedToPlayOnFactionDecks or ab_2447 missing)","Found leaders with wrong data (allowedToPlayOnFactionDecks or ab_2447 missing)",true);
            processTestResult(result,"fusionWrong","WRONG FUSION PARAMS","Fusion Amount Cards == 0 || fusionCost == 0",true);
            processTestResult(result,"craftWrong","WRONG CRAFT PARAMS","Craft Amount Cards == 0 || CraftCost == 0",true);
            processTestResult(result,"extraCraftSku","WRONG EXTRA CRAFT PARAMS","CraftAmountExtraCards == 0",true);
            processTestResult(result,"extraFusionSku","WRONG EXTRA FUSION PARAMS","fusionAmountExtraCards == 0",true);
            processTestResult(result,"familyIdError","FAMILY ID ERROR","The same family id was found in more than 1 category",true);
            processTestResult(result,"skinSkuError","SKIN SKU ERROR","There are some unconfigured skin cards",true);
            processTestResult(result,"multiCastOnPromotion","MULTICAST AND PROMOTION","A card can\'t have multicast ability on promotion",true);
            processTestResult(result,"randomOnPromotion","RANDOM AND PROMOTION","A card can\'t have random ability on promotion",true);
            processTestResult(result,"promoteWithNoMoreTiers","Promote with no more tiers","A tier 3 card can\'t have self promote ability",true);
            processTestResult(result,"demoteWithNoMoreTiers","Demote with no more tiers","A tier 1 card can\'t have self demote ability",true);
            processTestResult(result,"upgradeSkuNonExistent","Upgrade Sku non existent","There are upgradeSku cards non existent",true);
         }
      }
      
      private static function checkIncorrectAbilities() : void
      {
         var _loc2_:AbilityDef = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         FSDebug.debugTrace("\n\nChecking Incorrect Abilities: ");
         var _loc1_:Dictionary = InstanceMng.getAbilitiesDefMng().getAllDefs();
         if(_loc1_)
         {
            _loc5_ = "";
            for each(_loc2_ in _loc1_)
            {
               if(!_loc2_.isParentAbility() && (_loc2_.getKeyName() == "" || _loc2_.getKeyName() == null))
               {
                  _loc3_ = _loc2_.getDesc();
                  _loc4_ = _loc2_.getTargetDesc();
                  if(_loc3_ == _loc4_ && _loc4_.length > 0)
                  {
                     FSDebug.debugTrace("Def: " + _loc2_.getSku() + " - " + _loc3_);
                     _loc5_ += _loc5_ != "" ? ", " + _loc2_.getSku() + " (" + _loc2_.getName() + ")" : _loc2_.getSku() + " (" + _loc2_.getName() + ")";
                  }
               }
            }
            if(_loc5_ != "")
            {
               if(THROW_ERROR)
               {
                  throw new Error("Some abilities are incorrect! Check logs to see which");
               }
            }
            else
            {
               FSDebug.debugTrace("All good.");
            }
         }
      }
      
      private static function processLevelsDecks(param1:Dictionary, param2:LevelDef, param3:Boolean = false) : String
      {
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:CardDef = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc4_:String = "";
         if(param1 != null)
         {
            _loc5_ = DictionaryUtils.getKeys(param1);
            _loc8_ = false;
            _loc9_ = 0;
            _loc10_ = "";
            _loc11_ = param3 ? " [EASY MDOE] " : "";
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_));
               _loc9_ = DictionaryUtils.getCardAmountInCatalog(_loc7_.getSku(),param1);
               _loc8_ = DictionaryUtils.getDeckFamilyIDMaxReached(_loc7_,param1,null,0);
               if(_loc8_)
               {
                  _loc10_ = "\nLevel: " + param2.getSku() + _loc11_ + " - Card: " + _loc7_.getSku() + " (" + _loc7_.getName() + ") Amount: " + _loc9_ + " ";
                  FSDebug.debugTrace(_loc10_);
                  _loc4_ += _loc4_ != "" ? ", " + _loc10_ : _loc10_;
               }
            }
         }
         return _loc4_;
      }
      
      private static function checkLevelsRewards() : void
      {
         var allLevels:Dictionary;
         var allDungeonsLevels:Dictionary;
         var allRaidsLevels:Dictionary;
         var wrongDecks:String;
         var levelDef:LevelDef = null;
         var levelSku:String = null;
         var i:int = 0;
         var maxDiff:int = 0;
         var rewardSku:String = null;
         var rewardDef:RewardDef = null;
         var packSku:String = null;
         var packDef:PackDef = null;
         var AIUnits:Dictionary = null;
         var processLevels:Function = function(param1:Dictionary):String
         {
            var _loc2_:String = "";
            for each(levelDef in param1)
            {
               i = 0;
               while(i < maxDiff)
               {
                  _loc2_ += processLevelsDecks(levelDef.getAIUnits(UserData.WORLD_DEFAULT),levelDef);
                  _loc2_ += processLevelsDecks(levelDef.getAIEasyUnits(UserData.WORLD_DEFAULT),levelDef,true);
                  _loc2_ += processLevelsDecks(levelDef.getAIAttachments(UserData.WORLD_DEFAULT),levelDef);
                  _loc2_ += processLevelsDecks(levelDef.getAIEasyAttachments(UserData.WORLD_DEFAULT),levelDef,true);
                  _loc2_ += processLevelsDecks(levelDef.getAIActions(UserData.WORLD_DEFAULT),levelDef);
                  _loc2_ += processLevelsDecks(levelDef.getAIEasyActions(UserData.WORLD_DEFAULT),levelDef,true);
                  rewardSku = levelDef.getRewardSkuByDifficulty(i);
                  if(rewardSku != "" && rewardSku != null)
                  {
                     rewardDef = RewardDef(InstanceMng.getRewardsDefMng().getDefBySku(rewardSku));
                     if(rewardDef)
                     {
                        packSku = rewardDef.getPackSku();
                        if(packSku != "" && packSku != null)
                        {
                           packDef = PackDef(InstanceMng.getPacksDefMng().getDefBySku(packSku));
                           if(Boolean(packDef) && !packDef.areCardsPredefined())
                           {
                              FSDebug.debugTrace(levelDef.getSku() + " Diff " + i + " reward " + rewardSku + " Pack: " + packSku + " hasPredefinedCards: " + packDef.areCardsPredefined());
                              if(THROW_ERROR)
                              {
                                 throw new Error("A level has been detected to have a PACK reward (with no cards predefined). Check console for more info");
                              }
                           }
                        }
                     }
                  }
                  ++i;
               }
            }
            return _loc2_;
         };
         FSDebug.debugTrace("\n\nChecking Levels ");
         allLevels = InstanceMng.getLevelsDefMng().getAllDefs();
         allDungeonsLevels = InstanceMng.getDungeonLevelsDefMng().getAllDefs();
         allRaidsLevels = InstanceMng.getRaidLevelsDefMng().getAllDefs();
         maxDiff = UserDataMng.DIFFICULTY_HARD;
         wrongDecks = "";
         wrongDecks += processLevels(allLevels);
         wrongDecks += processLevels(allDungeonsLevels);
         wrongDecks += processLevels(allRaidsLevels);
         if(wrongDecks != "" && THROW_ERROR)
         {
            throw new Error("Some AI Decks didn\'t comply with game rules, check logs");
         }
      }
      
      private static function checkChances() : void
      {
         var rewardDef:RewardDef = null;
         var packDef:PackDef = null;
         var log:String = null;
         var processPacks:Function = function(param1:Dictionary):void
         {
            for each(packDef in param1)
            {
               log = processPackChances(packDef,log);
            }
            if(log != "")
            {
               FSDebug.debugTrace("\n PACKS CHANCES INCORRECT: " + log);
               if(THROW_ERROR)
               {
                  throw new Error("There are some packs where the total chance doesn\'t add correctly 100. Check console for more info");
               }
            }
         };
         var processPackChances:Function = function(param1:PackDef, param2:String):String
         {
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc7_:String = null;
            var _loc8_:RarityDef = null;
            var _loc3_:Dictionary = InstanceMng.getRaritiesDefMng().getAllDefs();
            var _loc4_:int = 1;
            var _loc9_:int = param1.getChancesAmount();
            var _loc10_:int = _loc9_ * 100;
            for each(_loc8_ in _loc3_)
            {
               _loc7_ = _loc8_.getSku();
               _loc4_ = 1;
               while(_loc4_ <= Config.getConfig().getShopMaxCardsPerPack())
               {
                  _loc5_ = param1.getChanceByRaritySkuAndIndex(_loc4_,_loc7_);
                  _loc6_ += _loc5_;
                  _loc4_++;
               }
            }
            if(_loc6_ != _loc10_)
            {
               param2 += "\n Pack: " + param1.getSku() + " chance: " + _loc6_ + " where " + _loc10_ + " was expected";
            }
            return param2;
         };
         var processRewards:Function = function(param1:Dictionary):void
         {
            var _loc2_:Dictionary = null;
            var _loc3_:Dictionary = null;
            var _loc4_:Dictionary = null;
            for each(rewardDef in param1)
            {
               _loc2_ = rewardDef.getCardChances();
               _loc3_ = rewardDef.getPackChances();
               _loc4_ = rewardDef.getPortraitChances();
               log = processRewardChances(rewardDef,_loc2_,RewardDef.SUFFIX_CARD,log);
               log = processRewardChances(rewardDef,_loc3_,RewardDef.SUFFIX_PACK,log);
               log = processRewardChances(rewardDef,_loc4_,RewardDef.SUFFIX_PORTRAIT,log);
            }
            if(log != "")
            {
               FSDebug.debugTrace("\n REWARDS CHANCES INCORRECT: " + log);
               if(THROW_ERROR)
               {
                  throw new Error("There are some rewards where the total chance doesn\'t add correctly 100. Check console for more info");
               }
            }
         };
         var processRewardChances:Function = function(param1:RewardDef, param2:Dictionary, param3:String, param4:String):String
         {
            var _loc5_:Array = null;
            var _loc6_:String = null;
            var _loc7_:int = 0;
            var _loc8_:int = 0;
            var _loc9_:int = 0;
            if(param2)
            {
               _loc5_ = DictionaryUtils.getKeys(param2);
               _loc9_ = 0;
               _loc8_ = 0;
               while(_loc8_ < _loc5_.length)
               {
                  _loc6_ = _loc5_[_loc8_];
                  _loc7_ = int(param2[_loc6_]);
                  _loc9_ += _loc7_;
                  _loc8_++;
               }
               if(_loc9_ != 100)
               {
                  param4 += "\n " + param3 + " reward: " + param1.getSku() + " chance: " + _loc9_;
               }
            }
            return param4;
         };
         var allRewards:Dictionary = InstanceMng.getRewardsDefMng().getAllDefs();
         var allPacks:Dictionary = InstanceMng.getPacksDefMng().getAllDefs();
         log = "";
         processRewards(allRewards);
         processPacks(allPacks);
      }
   }
}

