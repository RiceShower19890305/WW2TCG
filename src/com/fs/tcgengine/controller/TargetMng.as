package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.CategoryDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.GameModeDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import flash.utils.Dictionary;
   
   public class TargetMng
   {
      
      public static const MAIN_SUBOBJECTIVE:int = 0;
      
      public static const KILL_CATEGORY_SUBOBJECTIVE:int = 1;
      
      public static const KILL_SUBCATEGORY_SUBOBJECTIVE:int = 2;
      
      public static const KILL_CARD_SUBOBJECTIVE:int = 3;
      
      public static const PLAY_CATEGORY_SUBOBJECTIVE:int = 4;
      
      public static const PLAY_SUBCATEGORY_SUBOBJECTIVE:int = 5;
      
      private var mBattleEngine:BattleEngine;
      
      private var mCurrentGameMode:GameModeDef;
      
      private var mObjectivesCatalog:Dictionary;
      
      private var mLevelDef:LevelDef;
      
      private var mCurrentPlayedCategories:Dictionary;
      
      private var mCurrentPlayedSubcategories:Dictionary;
      
      private var mCurrentKilledCategories:Dictionary;
      
      private var mCurrentKilledSubcategories:Dictionary;
      
      private var mCurrentKilledCards:Dictionary;
      
      public function TargetMng()
      {
         super();
      }
      
      public function levelStart() : void
      {
         this.reset();
         this.mBattleEngine = InstanceMng.getBattleEngine();
         this.mLevelDef = this.mBattleEngine.getLevelDef();
         this.mCurrentGameMode = GameModeDef(InstanceMng.getGameModesDefMng().getDefBySku(this.mLevelDef.getGameModeSku()));
         this.fillObjectivesCatalog();
      }
      
      private function keepPlaying() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = this.mBattleEngine.getCurrentTurnId();
         var _loc3_:int = this.mLevelDef.getTurnsAmount();
         if(_loc3_ == 0)
         {
            _loc1_ = true;
         }
         else
         {
            _loc1_ = _loc2_ <= _loc3_;
         }
         return _loc1_;
      }
      
      public function playerWon() : Boolean
      {
         var _loc5_:Boolean = false;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = this.canPlayerKeepPlaying();
         var _loc3_:Boolean = !this.mBattleEngine.getOpponentBattleInfo().isAlive();
         var _loc4_:Boolean = this.isSurvivalMode();
         if(_loc4_)
         {
            _loc1_ = _loc3_ || !_loc2_;
         }
         else
         {
            _loc5_ = this.mLevelDef.isKillEnemyRequired();
            if(_loc5_)
            {
               if(_loc3_)
               {
                  _loc1_ = this.allObjectivesCompleted();
               }
               else
               {
                  _loc1_ = false;
               }
            }
            else if(_loc3_)
            {
               _loc1_ = this.mLevelDef.getObjectiveCompleteOnEnemyKilled();
            }
            else
            {
               _loc1_ = this.allObjectivesCompleted();
            }
         }
         return _loc1_;
      }
      
      public function allObjectivesCompleted() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Dictionary = this.mLevelDef.getKillCategoryCatalog();
         var _loc3_:Boolean = this.isSubObjectiveCompleted(_loc2_,this.mCurrentKilledCategories);
         var _loc4_:Dictionary = this.mLevelDef.getKillSubcategoryCatalog();
         var _loc5_:Boolean = this.isSubObjectiveCompleted(_loc4_,this.mCurrentKilledSubcategories);
         var _loc6_:Dictionary = this.mLevelDef.getKillSpecCardsCatalog();
         var _loc7_:Boolean = this.isSubObjectiveCompleted(_loc6_,this.mCurrentKilledCards);
         var _loc8_:Dictionary = this.mLevelDef.getPlayCategoryCatalog();
         var _loc9_:Boolean = this.isSubObjectiveCompleted(_loc8_,this.mCurrentPlayedCategories);
         var _loc10_:Dictionary = this.mLevelDef.getPlaySubcategoryCatalog();
         var _loc11_:Boolean = this.isSubObjectiveCompleted(_loc10_,this.mCurrentPlayedSubcategories);
         return _loc3_ && _loc5_ && _loc7_ && _loc9_ && _loc11_;
      }
      
      public function getSubObjectiveCurrentAmount(param1:int, param2:String) : int
      {
         var _loc4_:Dictionary = null;
         var _loc5_:UserBattleInfo = null;
         var _loc6_:UserBattleInfo = null;
         var _loc3_:int = 0;
         switch(param1)
         {
            case MAIN_SUBOBJECTIVE:
               if(this.mBattleEngine != null)
               {
                  _loc5_ = this.mBattleEngine.getOwnerBattleInfo();
                  _loc6_ = this.mBattleEngine.getOpponentBattleInfo();
                  if(Boolean(_loc5_) && this.isSurvivalMode())
                  {
                     _loc3_ = this.mBattleEngine.getOwnerBattleInfo().isAlive() ? 1 : 0;
                  }
                  else if(_loc6_)
                  {
                     _loc3_ = !this.mBattleEngine.getOpponentBattleInfo().isAlive() ? 1 : 0;
                  }
               }
               break;
            case KILL_CATEGORY_SUBOBJECTIVE:
               _loc4_ = this.mCurrentKilledCategories;
               break;
            case KILL_SUBCATEGORY_SUBOBJECTIVE:
               _loc4_ = this.mCurrentKilledSubcategories;
               break;
            case KILL_CARD_SUBOBJECTIVE:
               _loc4_ = this.mCurrentKilledCards;
               break;
            case PLAY_CATEGORY_SUBOBJECTIVE:
               _loc4_ = this.mCurrentPlayedCategories;
               break;
            case PLAY_SUBCATEGORY_SUBOBJECTIVE:
               _loc4_ = this.mCurrentPlayedSubcategories;
         }
         if(_loc4_ != null && _loc4_[param2] != null)
         {
            _loc3_ = int(_loc4_[param2]);
         }
         return _loc3_;
      }
      
      private function isSubObjectiveCompleted(param1:Dictionary, param2:Dictionary) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc3_:Boolean = true;
         if(param1 == null && param2 == null)
         {
            _loc3_ = true;
         }
         else if(param2 == null)
         {
            _loc3_ = false;
         }
         else
         {
            _loc4_ = DictionaryUtils.getKeys(param1);
            _loc6_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc7_ = _loc4_[_loc5_];
               if(param2[_loc7_] == null)
               {
                  return false;
               }
               _loc6_ = int(param2[_loc7_]);
               if(_loc6_ < param1[_loc7_])
               {
                  return false;
               }
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      private function fillObjectivesCatalog() : void
      {
         if(this.mObjectivesCatalog == null)
         {
            this.mObjectivesCatalog = new Dictionary(true);
         }
         this.mObjectivesCatalog[KILL_CATEGORY_SUBOBJECTIVE] = this.mLevelDef.getKillCategoryCatalog();
         this.mObjectivesCatalog[KILL_SUBCATEGORY_SUBOBJECTIVE] = this.mLevelDef.getKillSubcategoryCatalog();
         this.mObjectivesCatalog[KILL_CARD_SUBOBJECTIVE] = this.mLevelDef.getKillSpecCardsCatalog();
         this.mObjectivesCatalog[PLAY_CATEGORY_SUBOBJECTIVE] = this.mLevelDef.getPlayCategoryCatalog();
         this.mObjectivesCatalog[PLAY_SUBCATEGORY_SUBOBJECTIVE] = this.mLevelDef.getPlaySubcategoryCatalog();
      }
      
      public function getMainObjectiveText(param1:Boolean = false) : String
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:String = "";
         if(this.mCurrentGameMode != null)
         {
            _loc3_ = 0;
            _loc4_ = this.mLevelDef.isKillEnemyRequired();
            _loc5_ = this.mLevelDef.getObjectiveCompleteOnEnemyKilled();
            _loc6_ = this.getCurrentLevelRequiredTurns();
            _loc7_ = param1 ? "_DESC" : "";
            if(this.isSurvivalMode())
            {
               _loc2_ = TextManager.replaceParameters(TextManager.getText("TID_GAMEMODE_OBJ_SURVIVE" + _loc7_),[_loc6_]);
            }
            else if(_loc4_)
            {
               if(param1)
               {
                  _loc2_ = _loc6_ > 0 ? TextManager.replaceParameters(TextManager.getText("TID_GAMEMODE_OBJ_ENEMY_TURN_DESC"),[_loc6_]) : TextManager.getText("TID_GAMEMODE_OBJ_ENEMY_DESC");
               }
               else
               {
                  _loc2_ = TextManager.getText("TID_GAMEMODE_OBJ_ENEMY");
                  if(_loc6_ > 0)
                  {
                     _loc2_ += " (" + TextManager.getText("TID_GEN_LEVEL_TURNS") + ": " + _loc6_ + ")";
                  }
               }
            }
            else if(!_loc5_)
            {
               _loc2_ = TextManager.getText("TID_GAMEMODE_OBJ_NOTKILL" + _loc7_);
            }
            else
            {
               _loc2_ = TextManager.getText("TID_GAMEMODE_OBJ_KILLOPTIONAL" + _loc7_);
            }
         }
         return _loc2_;
      }
      
      public function getObjectiveText(param1:Dictionary, param2:int, param3:Boolean = true) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:Def = null;
         var _loc12_:String = null;
         var _loc13_:Object = null;
         if(param1 != null)
         {
            _loc5_ = this.isKillObjective(param2);
            _loc4_ = new Array();
            _loc7_ = DictionaryUtils.getKeys(param1);
            _loc12_ = _loc5_ ? TextManager.getText("TID_GAMEMODE_OBJ_KILL") : TextManager.getText("TID_GAMEMODE_OBJ_PLAY");
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc6_ = _loc7_[_loc8_];
               if(_loc6_ != null)
               {
                  switch(param2)
                  {
                     case KILL_CATEGORY_SUBOBJECTIVE:
                     case PLAY_CATEGORY_SUBOBJECTIVE:
                        _loc11_ = CategoryDef(InstanceMng.getCategoriesDefMng().getDefBySku(_loc6_));
                        break;
                     case KILL_SUBCATEGORY_SUBOBJECTIVE:
                     case PLAY_SUBCATEGORY_SUBOBJECTIVE:
                        _loc11_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc6_));
                        break;
                     case KILL_CARD_SUBOBJECTIVE:
                        _loc11_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_));
                  }
                  if(_loc11_ != null)
                  {
                     _loc9_ = int(param1[_loc6_]);
                     if(param2 == KILL_SUBCATEGORY_SUBOBJECTIVE || param2 == PLAY_SUBCATEGORY_SUBOBJECTIVE)
                     {
                        _loc10_ = TextManager.getText(SubCategoryDef(_loc11_).getGameModeName());
                     }
                     else
                     {
                        _loc10_ = _loc11_.getName();
                     }
                     _loc13_ = new Object();
                     _loc13_.sku = _loc6_;
                     _loc13_.amountRequired = _loc9_;
                     _loc13_.text = TextManager.replaceParameters(_loc12_,[_loc10_]).toUpperCase();
                     _loc13_.text += param3 ? " (x" + _loc9_ + ")" : " ";
                     _loc4_[_loc4_.length] = _loc13_;
                  }
               }
               _loc8_++;
            }
         }
         return _loc4_;
      }
      
      public function addCardKilled(param1:FSCard) : void
      {
         var _loc2_:CardDef = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param1 != null)
         {
            _loc2_ = param1.getCardDef();
            _loc3_ = _loc2_.getSku();
            if(Config.TRACE_BATTLE_LOGS)
            {
               FSDebug.debugTrace("Card Killed: " + _loc3_);
            }
            this.mCurrentKilledCards = this.addSkuToCatalog(_loc3_,this.mCurrentKilledCards);
            _loc4_ = _loc2_.getCategorySku();
            this.mCurrentKilledCategories = this.addSkuToCatalog(_loc4_,this.mCurrentKilledCategories);
            this.computeKilledCardAttachments(param1);
            if(_loc2_.getSubCategorySku() != null)
            {
               _loc5_ = _loc2_.getSubCategorySku()[0];
               this.mCurrentKilledSubcategories = this.addSkuToCatalog(_loc5_,this.mCurrentKilledSubcategories);
            }
         }
         if(this.mBattleEngine)
         {
            this.mBattleEngine.getBattleScreen().updateObjectivesProgress();
         }
      }
      
      private function computeKilledCardAttachments(param1:FSCard) : void
      {
         var _loc3_:String = null;
         var _loc4_:FSAttachment = null;
         var _loc2_:int = 0;
         if(param1 != null && param1 is FSUnit)
         {
            if(FSUnit(param1).hasAttachments())
            {
               _loc2_ = FSUnit(param1).getAttachmentsAmount();
               _loc4_ = FSAttachment(FSUnit(param1).getAttachments()[0]);
               if(_loc4_ != null)
               {
                  _loc3_ = _loc4_.getCardDef().getCategorySku();
               }
            }
         }
         if(_loc3_ != null && _loc3_ != "")
         {
            this.mCurrentKilledCategories = this.addSkuToCatalog(_loc3_,this.mCurrentKilledCategories,_loc2_);
         }
      }
      
      public function addCardPlayed(param1:FSCard) : void
      {
         var _loc2_:CardDef = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 != null)
         {
            if(Config.TRACE_BATTLE_LOGS)
            {
               FSDebug.debugTrace("Card played: " + param1.getCardDef().getSku());
            }
            _loc2_ = param1.getCardDef();
            _loc3_ = _loc2_.getCategorySku();
            this.mCurrentPlayedCategories = this.addSkuToCatalog(_loc3_,this.mCurrentPlayedCategories);
            if(_loc2_.getSubCategorySku() != null)
            {
               _loc4_ = _loc2_.getSubCategorySku()[0];
               this.mCurrentPlayedSubcategories = this.addSkuToCatalog(_loc4_,this.mCurrentPlayedSubcategories);
            }
         }
         this.mBattleEngine.getBattleScreen().updateObjectivesProgress();
      }
      
      private function addSkuToCatalog(param1:String, param2:Dictionary, param3:int = 1) : Dictionary
      {
         if(param2 == null)
         {
            param2 = new Dictionary(true);
         }
         if(param1 != null)
         {
            if(param2[param1] != null)
            {
               param2[param1] += param3;
            }
            else
            {
               param2[param1] = param3;
            }
         }
         return param2;
      }
      
      public function getObjectivesCatalog(param1:LevelDef) : Dictionary
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            this.mLevelDef = param1;
            _loc2_ = this.mLevelDef.getGameModeSku();
            this.mCurrentGameMode = GameModeDef(InstanceMng.getGameModesDefMng().getDefBySku(_loc2_));
            DictionaryUtils.clearDictionary(this.mObjectivesCatalog);
            this.fillObjectivesCatalog();
         }
         return this.mObjectivesCatalog;
      }
      
      public function isSurvivalMode() : Boolean
      {
         return this.mLevelDef.isSurvivalMode();
      }
      
      public function getCurrentLevelRequiredTurns(param1:LevelDef = null) : int
      {
         var _loc2_:int = 0;
         if(param1)
         {
            _loc2_ = param1.getTurnsAmount();
         }
         if(param1 == null && Boolean(this.mLevelDef))
         {
            _loc2_ = this.mLevelDef.getTurnsAmount();
         }
         return _loc2_;
      }
      
      public function canPlayerKeepPlaying() : Boolean
      {
         return this.keepPlaying();
      }
      
      public function isKillObjective(param1:int) : Boolean
      {
         var _loc2_:Boolean = true;
         switch(param1)
         {
            case KILL_CATEGORY_SUBOBJECTIVE:
            case KILL_SUBCATEGORY_SUBOBJECTIVE:
            case KILL_CARD_SUBOBJECTIVE:
               return true;
            case PLAY_CATEGORY_SUBOBJECTIVE:
            case PLAY_SUBCATEGORY_SUBOBJECTIVE:
               return false;
            default:
               return _loc2_;
         }
      }
      
      public function reset() : void
      {
         this.unload();
      }
      
      public function unload() : void
      {
         this.mBattleEngine = null;
         this.mLevelDef = null;
         this.mCurrentGameMode = null;
         DictionaryUtils.clearDictionary(this.mObjectivesCatalog);
         this.mObjectivesCatalog = null;
         DictionaryUtils.clearDictionary(this.mCurrentKilledCards);
         DictionaryUtils.clearDictionary(this.mCurrentKilledCategories);
         DictionaryUtils.clearDictionary(this.mCurrentKilledSubcategories);
         DictionaryUtils.clearDictionary(this.mCurrentPlayedCategories);
         DictionaryUtils.clearDictionary(this.mCurrentPlayedSubcategories);
      }
   }
}

