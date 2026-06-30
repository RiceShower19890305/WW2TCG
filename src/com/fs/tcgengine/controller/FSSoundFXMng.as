package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.controller.rules.FactionsDefMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.ResourceDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.cards.FSUnit;
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   
   public class FSSoundFXMng
   {
      
      public static const FX_FOLDER_PREFIX:String = "fx/";
      
      public static const CARD_SELECTED:int = 0;
      
      public static const CARD_MOVED_TO_BF:int = 1;
      
      public static const PROMOTE:int = 2;
      
      public static const PURCHASED:int = 3;
      
      private const SELECTED_PREFIX:String = "selected_";
      
      private const PLAYED_PREFIX:String = "played_";
      
      protected const CATEGORY_UNIVERSAL_PREFIX:String = "_catuniversal";
      
      protected const UNITS_PREFIX:String = "unit_";
      
      protected const ATTACHMENTS_PREFIX:String = "attachment_";
      
      protected const ACTIONS_PREFIX:String = "action_";
      
      protected const INFANTRY_PREFIX:String = "infantry_";
      
      protected const ARMORED_PREFIX:String = "armored_";
      
      protected const AIR_PREFIX:String = "air_";
      
      protected const SHIP_PREFIX:String = "ship_";
      
      protected const SUBMARINE_PREFIX:String = "submarine_";
      
      protected const STRUCTURE_PREFIX:String = "structure_";
      
      protected const SUBCATEGORY_UNIVERSAL_PREFIX:String = "_scatuniversal";
      
      private const GERMANY_PREFIX:String = "german_";
      
      private const AMERICAN_PREFIX:String = "american_";
      
      private const RUSSIAN_PREFIX:String = "russian_";
      
      private const JAPAN_PREFIX:String = "japanese_";
      
      private const BRITISH_PREFIX:String = "british_";
      
      protected const FACTION_UNIVERSAL_PREFIX:String = "_factionuniversal";
      
      private var mSoundRequested:Array;
      
      public function FSSoundFXMng()
      {
         super();
      }
      
      public function playCardSound(param1:FSCard, param2:int, param3:Boolean = false) : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc4_:String = "";
         if(InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().getBattleStateId() != BattleEngine.BATTLE_STATE_BATTLE_OVER || InstanceMng.getBattleEngine() == null || param3)
         {
            if(param1 != null)
            {
               _loc5_ = param2 == CARD_SELECTED ? this.SELECTED_PREFIX : this.PLAYED_PREFIX;
               _loc6_ = this.getRandomSoundName(param1,_loc5_);
               if(_loc6_ != "")
               {
                  _loc4_ = _loc6_;
                  if(!this.isSoundLoaded(_loc6_) && !Root.assets.isLoading)
                  {
                     this.addSoundWaitingToLoad(_loc6_);
                     InstanceMng.getResourcesMng().addResourceToLoad(FX_FOLDER_PREFIX + _loc6_,FSResourceMng.TYPE_AUDIO);
                  }
                  else
                  {
                     Utils.playSound(_loc6_,SoundManager.TYPE_SFX);
                  }
               }
               if((param2 == CARD_MOVED_TO_BF || param2 == PROMOTE || param2 == PURCHASED) && (param1 is FSUnit || param1 is FSCardPreview))
               {
                  _loc7_ = param1.getCardDef() is UnitDef ? UnitDef(param1.getCardDef()).getOnPlaySound() : "";
                  if(_loc7_ != null && _loc7_ != "")
                  {
                     _loc4_ = _loc7_;
                     if(!this.isSoundLoaded(_loc7_))
                     {
                        if(!Root.assets.isLoading)
                        {
                           this.addSoundWaitingToLoad(_loc7_);
                           InstanceMng.getResourcesMng().addResourceToLoad(FX_FOLDER_PREFIX + _loc7_,FSResourceMng.TYPE_AUDIO);
                        }
                     }
                     else
                     {
                        Utils.playSound(_loc7_,SoundManager.TYPE_SFX);
                     }
                  }
               }
               if(this.mSoundRequested != null && this.mSoundRequested.length > 0)
               {
                  InstanceMng.getResourcesMng().loadAssets(this.notifySoundLoaded);
               }
            }
         }
         return _loc4_;
      }
      
      private function isSoundLoaded(param1:String) : Boolean
      {
         if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
         {
            return FSResourceMng.smAudioFilesPaths[param1] != null;
         }
         return Root.assets.getSound(param1) != null;
      }
      
      private function addSoundWaitingToLoad(param1:String) : void
      {
         if(this.mSoundRequested == null)
         {
            this.mSoundRequested = new Array();
         }
         this.mSoundRequested.push(param1);
      }
      
      public function isSoundWaitingToLoad(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(this.mSoundRequested)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mSoundRequested.length)
            {
               if(this.mSoundRequested[_loc3_] == param1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function updateSoundWaitingToLoad(param1:String, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         if(param2)
         {
            this.addSoundWaitingToLoad(param1);
         }
         else if(this.mSoundRequested)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mSoundRequested.length)
            {
               if(this.mSoundRequested[_loc3_] == param1)
               {
                  this.mSoundRequested.splice(_loc3_);
                  return;
               }
               _loc3_++;
            }
         }
      }
      
      public function notifySoundLoaded() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
         {
            return;
         }
         if(this.mSoundRequested != null && this.mSoundRequested.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mSoundRequested.length)
            {
               Utils.playSound(this.mSoundRequested[_loc2_],SoundManager.TYPE_SFX);
               _loc2_++;
            }
         }
         if(this.mSoundRequested)
         {
            this.mSoundRequested.length = 0;
            this.mSoundRequested = null;
         }
      }
      
      public function getRandomSoundName(param1:FSCard, param2:String) : String
      {
         var _loc11_:File = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc3_:String = "";
         var _loc4_:File = InstanceMng.getResourcesMng().getFileFromStorage(InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_AUDIO) + "fx/");
         if(_loc4_ == null || !_loc4_.exists)
         {
            return null;
         }
         var _loc5_:Array = _loc4_.getDirectoryListing();
         var _loc6_:Array = null;
         var _loc7_:int = param1.getCardDef().getCategoryIndex();
         var _loc8_:String = this.getCategoryFilterByCategoryIndex(_loc7_);
         var _loc9_:String = this.getSubcategoryFilter(param1);
         var _loc10_:String = this.getFactionFilterByIndex(param1);
         if(_loc5_ != null)
         {
            for each(_loc11_ in _loc5_)
            {
               _loc12_ = _loc11_.name;
               if(_loc12_.indexOf(param2) != -1)
               {
                  if(_loc12_.indexOf(_loc8_) != -1 || _loc12_.indexOf(this.CATEGORY_UNIVERSAL_PREFIX) != -1)
                  {
                     if(_loc12_.indexOf(_loc9_) != -1 || _loc12_.indexOf(this.SUBCATEGORY_UNIVERSAL_PREFIX) != -1)
                     {
                        if(_loc12_.indexOf(_loc10_) != -1 || _loc12_.indexOf(this.FACTION_UNIVERSAL_PREFIX) != -1)
                        {
                           if(_loc6_ == null)
                           {
                              _loc6_ = new Array();
                           }
                           _loc6_.push(_loc12_.split(".")[0]);
                        }
                     }
                  }
               }
            }
         }
         if(_loc6_ != null && _loc6_.length > 0)
         {
            _loc13_ = Utils.randomInt(0,_loc6_.length - 1);
            return _loc6_[_loc13_];
         }
         return _loc3_;
      }
      
      public function getAllRandomSoundNames(param1:FSCard) : Vector.<String>
      {
         var _loc9_:ResourceDef = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc2_:Vector.<String> = null;
         var _loc3_:Dictionary = InstanceMng.getResourceDefMng().getResourcesByFolderName("audio_on_demand/fx");
         var _loc4_:Array = null;
         var _loc5_:int = param1.getCardDef().getCategoryIndex();
         var _loc6_:String = this.getCategoryFilterByCategoryIndex(_loc5_);
         var _loc7_:String = this.getSubcategoryFilter(param1);
         var _loc8_:String = this.getFactionFilterByIndex(param1);
         if(_loc3_ != null)
         {
            for each(_loc9_ in _loc3_)
            {
               _loc10_ = _loc9_.getPath();
               _loc10_ = _loc10_.slice(_loc10_.lastIndexOf("/") + 1);
               if(_loc10_ != null && _loc10_ != "")
               {
                  _loc11_ = _loc10_.split(".")[0];
               }
               if(_loc11_ != "" && Boolean(_loc11_))
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = new Vector.<String>();
                  }
                  _loc2_.push(_loc11_);
               }
            }
         }
         return _loc2_;
      }
      
      protected function getSubcategoryFilter(param1:FSCard) : String
      {
         var _loc2_:String = "";
         var _loc3_:Array = param1.getCardDef().getSubCategorySku();
         var _loc4_:SubCategoryDef = null;
         if(_loc3_ != null)
         {
            _loc4_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc3_[0]));
         }
         if(_loc4_ != null)
         {
            switch(_loc4_.getIndex())
            {
               case SubCategoriesMng.SUBCATEGORY_01:
                  _loc2_ = this.INFANTRY_PREFIX;
                  break;
               case SubCategoriesMng.SUBCATEGORY_02:
                  _loc2_ = this.ARMORED_PREFIX;
                  break;
               case SubCategoriesMng.SUBCATEGORY_03:
                  _loc2_ = this.AIR_PREFIX;
                  break;
               case SubCategoriesMng.SUBCATEGORY_04:
                  _loc2_ = param1 is FSUnit && FSUnit(param1).isSubmarineUnit() ? this.SUBMARINE_PREFIX : this.SHIP_PREFIX;
                  break;
               case SubCategoriesMng.SUBCATEGORY_05:
                  _loc2_ = this.STRUCTURE_PREFIX;
            }
         }
         return _loc2_;
      }
      
      protected function getCategoryFilterByCategoryIndex(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case CategoriesDefMng.CATEGORY_UNITS:
               _loc2_ = this.UNITS_PREFIX;
               break;
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
               _loc2_ = this.ATTACHMENTS_PREFIX;
               break;
            case CategoriesDefMng.CATEGORY_ACTIONS:
               _loc2_ = this.ACTIONS_PREFIX;
         }
         return _loc2_;
      }
      
      protected function getFactionFilterByIndex(param1:FSCard) : String
      {
         var _loc2_:String = "";
         var _loc3_:FactionDef = param1 ? FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(param1.getCardDef().getFactionSku())) : null;
         var _loc4_:int = _loc3_ ? _loc3_.getIndex() : -1;
         switch(_loc4_)
         {
            case FactionsDefMng.FACTION_GERMANY:
               _loc2_ = this.GERMANY_PREFIX;
               break;
            case FactionsDefMng.FACTION_EEUU:
               _loc2_ = this.AMERICAN_PREFIX;
               break;
            case FactionsDefMng.FACTION_RUSSIA:
               _loc2_ = this.RUSSIAN_PREFIX;
               break;
            case FactionsDefMng.FACTION_JAPAN:
               _loc2_ = this.JAPAN_PREFIX;
               break;
            case FactionsDefMng.FACTION_BRITISH:
               _loc2_ = this.BRITISH_PREFIX;
         }
         return _loc2_;
      }
   }
}

