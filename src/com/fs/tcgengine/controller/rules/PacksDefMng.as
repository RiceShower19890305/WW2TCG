package com.fs.tcgengine.controller.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.shop.ShopItemSlotInfo;
   import flash.utils.Dictionary;
   
   public class PacksDefMng extends DefMng
   {
      
      public static const PACK_ANY:String = "any";
      
      public static const PACK_ACH_PROGRESS:String = "achievement-progress";
      
      public static const PACK_STARS_REWARD:String = "stars-reward";
      
      public static const PACK_QUEST_REWARD:String = "quest-reward";
      
      public static const PACK_DAILY_REWARDS:String = "daily";
      
      public static const PACK_DUNGEONS:String = "dungeon";
      
      public static const PACK_RAIDS:String = "raids";
      
      public static const PACK_QUESTS:String = "quests";
      
      public static const PACK_SHOP:String = "shop";
      
      public static const PACK_SHOP_OFFER:String = "shop-offer";
      
      public static const PACK_REWARD:String = "reward";
      
      public static const PACK_REWARD_PREDEFINED:String = "reward-predefined";
      
      public static const PACK_TUTORIAL_MAP_REWARD:String = "tutorialMapReward";
      
      public function PacksDefMng(param1:String)
      {
         super(param1);
      }
      
      override protected function createDef() : Def
      {
         return new PackDef();
      }
      
      public function getPacksToShowInShop() : Dictionary
      {
         var _loc3_:PackDef = null;
         var _loc1_:Dictionary = new Dictionary(true);
         var _loc2_:Dictionary = getAllDefs();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getShowInShop())
            {
               _loc1_[_loc3_.getSku()] = _loc3_;
            }
         }
         return _loc1_;
      }
      
      public function getPacksToShowInShopArray() : Array
      {
         var _loc3_:PackDef = null;
         var _loc1_:Array = new Array();
         var _loc2_:Dictionary = getAllDefs();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getShowInShop())
            {
               _loc1_.push(_loc3_);
            }
         }
         _loc1_.sort(DictionaryUtils.sortDefByShopPosition);
         return _loc1_;
      }
      
      public function getPackDescriptionText(param1:PackDef) : String
      {
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:RarityDef = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc2_:String = "";
         var _loc3_:Dictionary = new Dictionary(true);
         var _loc4_:Dictionary = new Dictionary(true);
         var _loc5_:Dictionary = InstanceMng.getRaritiesDefMng().getAllDefs();
         var _loc6_:int = 1;
         for each(_loc9_ in _loc5_)
         {
            _loc8_ = _loc9_.getSku();
            _loc6_ = 1;
            while(_loc6_ <= Config.getConfig().getShopMaxCardsPerPack())
            {
               _loc7_ = param1.getChanceByRaritySkuAndIndex(_loc6_,_loc8_);
               if(_loc7_ > 0)
               {
                  if(_loc7_ == 100)
                  {
                     if(_loc3_[_loc8_] == null)
                     {
                        _loc3_[_loc8_] = 1;
                     }
                     else
                     {
                        _loc3_[_loc8_] += 1;
                     }
                  }
                  else if(_loc4_[_loc8_] == null)
                  {
                     _loc4_[_loc8_] = _loc7_;
                  }
               }
               _loc6_++;
            }
         }
         _loc10_ = DictionaryUtils.getKeys(_loc3_);
         _loc10_.sort();
         _loc11_ = DictionaryUtils.getKeys(_loc4_);
         _loc11_.sort();
         _loc6_ = 0;
         while(_loc6_ < _loc10_.length)
         {
            _loc12_ = _loc6_ != 0 ? "\n- " : "-";
            _loc13_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc10_[_loc6_])).getName();
            _loc2_ += _loc12_ + _loc3_[_loc10_[_loc6_]] + "x " + _loc13_;
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc11_.length)
         {
            _loc13_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc11_[_loc6_])).getName();
            _loc7_ = int(_loc4_[_loc11_[_loc6_]]);
            if(_loc7_ < 5)
            {
               _loc14_ = TextManager.getText("TID_GEN_VERYLOW");
            }
            else if(_loc7_ < 10)
            {
               _loc14_ = TextManager.getText("TID_GEN_LOW");
            }
            else if(_loc7_ < 15)
            {
               _loc14_ = TextManager.getText("TID_GEN_MEDIUM");
            }
            else if(_loc7_ >= 15)
            {
               _loc14_ = TextManager.getText("TID_GEN_HIGH");
            }
            _loc2_ += "\n- 1x" + _loc13_ + " (CHANCE: " + _loc14_ + ")";
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function getPackRaritiesCatalogs(param1:PackDef) : Object
      {
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:RarityDef = null;
         var _loc2_:Object = new Object();
         var _loc3_:Dictionary = new Dictionary(true);
         var _loc4_:Dictionary = new Dictionary(true);
         var _loc5_:Dictionary = InstanceMng.getRaritiesDefMng().getAllDefs();
         var _loc6_:int = 1;
         for each(_loc9_ in _loc5_)
         {
            _loc8_ = _loc9_.getSku();
            _loc6_ = 1;
            while(_loc6_ <= Config.getConfig().getShopMaxCardsPerPack())
            {
               _loc7_ = param1.getChanceByRaritySkuAndIndex(_loc6_,_loc8_);
               if(_loc7_ > 0)
               {
                  if(_loc7_ == 100)
                  {
                     if(_loc3_[_loc8_] == null)
                     {
                        _loc3_[_loc8_] = 1;
                     }
                     else
                     {
                        _loc3_[_loc8_] += 1;
                     }
                  }
                  else
                  {
                     if(_loc4_[_loc6_] == null)
                     {
                        _loc4_[_loc6_] = new Dictionary(true);
                     }
                     if(_loc4_[_loc6_][_loc8_] == null)
                     {
                        _loc4_[_loc6_][_loc8_] = _loc7_;
                     }
                  }
               }
               _loc6_++;
            }
         }
         _loc2_.rarities = _loc3_;
         _loc2_.mixedRarities = _loc4_;
         return _loc2_;
      }
      
      public function fillBundleInfoContainer(param1:BundleDef) : Vector.<ShopItemSlotInfo>
      {
         var _loc3_:String = null;
         var _loc4_:ShopItemSlotInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:RarityDef = null;
         var _loc10_:Array = null;
         var _loc12_:String = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:PackDef = null;
         var _loc23_:CardDef = null;
         var _loc24_:Boolean = false;
         var _loc25_:HeroCharacterDef = null;
         var _loc26_:BoostDef = null;
         var _loc2_:Vector.<ShopItemSlotInfo> = new Vector.<ShopItemSlotInfo>();
         var _loc5_:String = "";
         var _loc11_:String = "";
         var _loc13_:Boolean = false;
         if(param1 != null)
         {
            _loc14_ = param1.getPacks();
            _loc15_ = param1.getCards();
            _loc16_ = param1.getSkins();
            _loc17_ = param1.getBoosts();
            _loc18_ = param1.getGold();
            _loc19_ = param1.getRaidPoints();
            _loc20_ = param1.getQuestPoints();
            _loc21_ = param1.getAHTokens();
            if(_loc14_ != null && _loc14_.length > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc14_.length)
               {
                  _loc22_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(_loc14_[_loc7_]));
                  _loc2_ = _loc2_.concat(this.fillPackInfoContainer(_loc22_));
                  _loc7_++;
               }
            }
            if(_loc15_ != null && _loc15_.length > 0)
            {
               _loc24_ = false;
               _loc7_ = 0;
               while(_loc7_ < _loc15_.length)
               {
                  _loc23_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc15_[_loc7_]));
                  _loc24_ = _loc23_.isCraftMaterial();
                  _loc9_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc23_.getCardRarity()));
                  _loc3_ = _loc24_ ? _loc23_.getName() : _loc9_.getName();
                  _loc12_ = _loc24_ ? "shop_card_craft_material" : _loc9_.getBGPack();
                  _loc5_ = " " + "1x " + _loc11_ + _loc3_;
                  _loc4_ = new ShopItemSlotInfo(_loc12_,_loc5_,_loc9_);
                  _loc2_.push(_loc4_);
                  _loc7_++;
               }
            }
            if(_loc18_ > 0)
            {
               _loc5_ = " " + _loc18_;
               _loc12_ = "large_gold_reward";
               _loc4_ = new ShopItemSlotInfo(_loc12_,_loc5_,_loc9_,"",0.75);
               _loc2_.push(_loc4_);
            }
            if(_loc19_ > 0)
            {
               _loc5_ = " " + _loc19_;
               _loc12_ = "large_raidpoints_reward";
               _loc4_ = new ShopItemSlotInfo(_loc12_,_loc5_,_loc9_,"",0.75);
               _loc2_.push(_loc4_);
            }
            if(_loc20_ > 0)
            {
               _loc5_ = " " + _loc20_;
               _loc12_ = "large_questpoints";
               _loc4_ = new ShopItemSlotInfo(_loc12_,_loc5_,_loc9_,"",0.75);
               _loc2_.push(_loc4_);
            }
            if(_loc21_ > 0)
            {
               _loc5_ = " " + _loc21_;
               _loc12_ = "large_tokens";
               _loc4_ = new ShopItemSlotInfo(_loc12_,_loc5_,_loc9_,"",0.75);
               _loc2_.push(_loc4_);
            }
            if(_loc16_ != null && _loc16_.length > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc16_.length)
               {
                  _loc25_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc16_[_loc7_]));
                  _loc5_ = " " + _loc25_.getName();
                  _loc12_ = "rewards_skins_icon";
                  _loc4_ = new ShopItemSlotInfo(_loc12_,_loc5_,_loc9_,"");
                  _loc2_.push(_loc4_);
                  _loc7_++;
               }
            }
            if(_loc17_ != null && _loc17_.length > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc17_.length)
               {
                  _loc26_ = BoostDef(InstanceMng.getBoostsDefMng().getDefBySku(_loc17_[_loc7_].split(":")[0]));
                  _loc5_ = " " + _loc17_[_loc7_].split(":")[1] + "x " + _loc26_.getName();
                  _loc12_ = _loc26_.getBGImageName();
                  _loc4_ = new ShopItemSlotInfo(_loc12_,_loc5_,_loc9_,"");
                  _loc2_.push(_loc4_);
                  _loc7_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function fillPackInfoContainer(param1:PackDef) : Vector.<ShopItemSlotInfo>
      {
         var _loc2_:String = null;
         var _loc3_:ShopItemSlotInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:RarityDef = null;
         var _loc9_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:Object = null;
         var _loc18_:Dictionary = null;
         var _loc19_:Dictionary = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:String = null;
         var _loc23_:Boolean = false;
         var _loc24_:int = 0;
         var _loc4_:String = "";
         var _loc10_:String = "";
         var _loc11_:Vector.<ShopItemSlotInfo> = new Vector.<ShopItemSlotInfo>();
         var _loc12_:Dictionary = param1.getShopInfoRaritiesInfo();
         if(_loc12_)
         {
            _loc14_ = DictionaryUtils.getDictionaryLength(_loc12_);
            _loc6_ = 0;
            while(_loc6_ < _loc14_)
            {
               _loc22_ = "shop_card_rarity_";
               _loc4_ = "";
               _loc9_ = String(_loc12_[_loc6_]).split("-");
               _loc16_ = int(String(_loc9_[0]).split(":")[0]);
               _loc9_[0] = String(_loc9_[0]).split(":")[1];
               if(_loc9_.length == 1)
               {
                  _loc8_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc9_[0]));
                  _loc2_ = _loc8_.getName();
                  _loc4_ = " " + _loc9_.length + "x " + _loc10_ + _loc2_;
                  _loc3_ = new ShopItemSlotInfo(_loc8_.getBGPack(),_loc4_,_loc8_);
                  _loc11_.push(_loc3_);
               }
               else
               {
                  if(_loc9_.length > 3)
                  {
                     _loc22_ += "random";
                     _loc4_ = " " + _loc9_.length + "x " + _loc10_ + TextManager.getText("TID_GEN_RANDOM");
                     _loc3_ = new ShopItemSlotInfo(_loc22_,_loc4_,_loc8_);
                     _loc11_.push(_loc3_);
                  }
                  else
                  {
                     _loc7_ = 0;
                     while(_loc7_ < _loc9_.length)
                     {
                        _loc8_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc9_[_loc7_]));
                        _loc22_ += _loc7_ > 0 ? "_" : "";
                        _loc22_ = _loc22_ + Utils.transformValueToString((_loc8_.getIndex() + 1).toString(),2);
                        _loc2_ = _loc8_.getName();
                        _loc4_ += _loc7_ == 0 ? _loc16_ + "x " + _loc10_ + _loc2_ : " " + TextManager.getText("TID_GEN_OR") + " " + _loc2_;
                        _loc23_ = true;
                        _loc7_++;
                     }
                  }
                  if(_loc23_)
                  {
                     _loc3_ = new ShopItemSlotInfo(_loc22_,_loc4_,_loc8_);
                     _loc11_.push(_loc3_);
                  }
               }
               _loc6_++;
            }
         }
         else
         {
            _loc17_ = this.getPackRaritiesCatalogs(param1);
            _loc18_ = _loc17_.rarities;
            _loc19_ = _loc17_.mixedRarities;
            _loc20_ = DictionaryUtils.getKeys(_loc18_);
            _loc20_.sort();
            _loc6_ = 0;
            while(_loc6_ < _loc20_.length)
            {
               _loc8_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc20_[_loc6_]));
               _loc2_ = _loc8_.getName();
               _loc5_ = int(_loc18_[_loc20_[_loc6_]]);
               _loc4_ = " " + _loc5_ + "x " + _loc10_ + _loc2_;
               _loc3_ = new ShopItemSlotInfo(_loc8_.getBGPack(),_loc4_,_loc8_);
               _loc11_.push(_loc3_);
               _loc6_++;
            }
            _loc23_ = false;
            _loc6_ = 1;
            while(_loc6_ <= Config.getConfig().getShopMaxCardsPerPack())
            {
               _loc22_ = "shop_card_rarity_";
               _loc23_ = false;
               _loc4_ = "";
               _loc21_ = DictionaryUtils.getKeys(_loc19_[_loc6_]);
               _loc21_.sort();
               _loc24_ = DictionaryUtils.getDictionaryLength(_loc19_);
               if(_loc21_.length > 3)
               {
                  _loc22_ += "random";
                  _loc4_ = " " + _loc24_ + "x " + _loc10_ + TextManager.getText("TID_GEN_RANDOM");
                  _loc3_ = new ShopItemSlotInfo(_loc22_,_loc4_,_loc8_);
                  _loc11_.push(_loc3_);
                  break;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc21_.length)
               {
                  _loc8_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc21_[_loc7_]));
                  _loc22_ += _loc7_ > 0 ? "_" : "";
                  _loc22_ = _loc22_ + Utils.transformValueToString((_loc8_.getIndex() + 1).toString(),2);
                  _loc2_ = _loc8_.getName();
                  _loc4_ += _loc7_ == 0 ? " 1x " + _loc10_ + _loc2_ : " " + TextManager.getText("TID_GEN_OR") + " " + _loc2_;
                  _loc23_ = true;
                  _loc7_++;
               }
               if(_loc23_)
               {
                  _loc3_ = new ShopItemSlotInfo(_loc22_,_loc4_,_loc8_);
                  _loc11_.push(_loc3_);
               }
               _loc6_++;
            }
         }
         return _loc11_;
      }
   }
}

