package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.FSCardsMng;
   import com.fs.tcgengine.controller.rules.CardDefMng;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.controller.rules.KickstarterBackerDefMng;
   import com.fs.tcgengine.controller.rules.QuestShopDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.auctions.Auction;
   import com.fs.tcgengine.model.auctions.Bid;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.quests.Quest;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.BundleDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.CategoryDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.DungeonRewardsDef;
   import com.fs.tcgengine.model.rules.EditionDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.KickstarterBackerDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.PvPRewardsDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.rules.QuestShopDef;
   import com.fs.tcgengine.model.rules.RaidShopDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.view.auctions.FSAuctionSlot;
   import com.fs.tcgengine.view.auctions.FSBidSlot;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.cards.InfoCard;
   import com.fs.tcgengine.view.components.popups.quests.BattlePassQuestSlot;
   import com.fs.tcgengine.view.jobs.JobSkinSlot;
   import com.fs.tcgengine.view.raids.FSUserPlayedRaidSlot;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import flash.utils.Dictionary;
   
   public final class DictionaryUtils
   {
      
      private static var mCardDefMng:CardDefMng;
      
      private static var mQuestShopDefMng:QuestShopDefMng;
      
      public function DictionaryUtils()
      {
         super();
      }
      
      public static function containsKey(param1:Dictionary, param2:Object) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc3_:Boolean = false;
         for(_loc4_ in param1)
         {
            if(param2 === _loc4_)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public static function containsValue(param1:Dictionary, param2:Object) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc3_:Boolean = false;
         for each(_loc4_ in param1)
         {
            if(_loc4_ === param2)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public static function deleteKeys(param1:Dictionary, param2:Array) : void
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param2)
         {
            deleteKey(param1,_loc3_);
         }
      }
      
      private static function deleteKey(param1:Dictionary, param2:*) : void
      {
         delete param1[param2];
      }
      
      public static function getKeys(param1:Object, param2:Array = null) : Array
      {
         var _loc4_:* = undefined;
         var _loc3_:Array = param2 == null ? [] : param2;
         for(_loc4_ in param1)
         {
            _loc3_.push(_loc4_);
         }
         return _loc3_;
      }
      
      public static function getDictionaryByObject(param1:Object) : Dictionary
      {
         var _loc2_:Dictionary = null;
         var _loc3_:* = undefined;
         for(_loc3_ in param1)
         {
            if(_loc2_ == null)
            {
               _loc2_ = new Dictionary(true);
            }
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getDictionaryLength(param1:Dictionary) : int
      {
         var _loc3_:* = undefined;
         var _loc2_:int = 0;
         if(param1 != null)
         {
            for(_loc3_ in param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public static function clearDictionary(param1:Dictionary, param2:Boolean = true) : void
      {
         var _loc3_:Vector.<Object> = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1)
         {
            _loc3_ = new Vector.<Object>(0);
            for(_loc4_ in param1)
            {
               _loc3_.push(_loc4_);
            }
            _loc5_ = int(_loc3_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(param2 && param1[_loc3_[_loc6_]] is FSModelUnloadableInterface)
               {
                  param1[_loc3_[_loc6_]].destroy();
               }
               delete param1[_loc3_[_loc6_]];
               _loc3_[_loc6_] = null;
               _loc6_++;
            }
            param1 = null;
         }
      }
      
      public static function sortDictionaryByValue(param1:Dictionary, param2:String = "value") : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = new Array();
         for(_loc4_ in param1)
         {
            _loc3_.push({
               "key":_loc4_,
               "value":param1[_loc4_]
            });
         }
         _loc3_.sortOn(param2,[Array.NUMERIC | Array.DESCENDING]);
         return _loc3_;
      }
      
      public static function sortDictionaryByKey(param1:Dictionary) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = new Array();
         for(_loc3_ in param1)
         {
            _loc2_.push({
               "key":_loc3_,
               "value":param1[_loc3_]
            });
         }
         _loc2_.sortOn("key");
         return _loc2_;
      }
      
      public static function getLowestAvailableKeyOnDictionary(param1:Dictionary) : int
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         if(param1 != null)
         {
            _loc5_ = DictionaryUtils.getDictionaryLength(param1);
            _loc6_ = 0;
            while(_loc6_ <= _loc5_)
            {
               if(!DictionaryUtils.containsKey(param1,_loc6_))
               {
                  _loc4_ = _loc6_;
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      public static function addCards(param1:Array, param2:Dictionary, param3:Boolean = true, param4:int = -1, param5:Boolean = false, param6:Dictionary = null) : Dictionary
      {
         var _loc7_:int = 0;
         var _loc9_:String = null;
         var _loc11_:CardDef = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:Boolean = true;
         var _loc12_:Boolean = false;
         if(param1 != null)
         {
            _loc7_ = 0;
            while(_loc7_ < param1.length)
            {
               if(param1[_loc7_])
               {
                  _loc9_ = param1[_loc7_].split(":")[0];
                  if(_loc9_)
                  {
                     _loc8_ = int(param1[_loc7_].split(":")[1]);
                     _loc12_ = Boolean(param6) && param6[_loc9_] != null && param6[_loc9_] >= _loc8_;
                     if(!param5 || param5 && _loc12_)
                     {
                        _loc11_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc9_));
                        if(param4 != -1)
                        {
                           _loc14_ = getCatalogCardsAmountCheckingRestrictions(param2,false);
                           if(_loc11_ is PowerDef)
                           {
                              _loc10_ = _loc14_ <= param4;
                           }
                           else
                           {
                              _loc10_ = _loc14_ + _loc8_ <= param4;
                           }
                        }
                        _loc13_ = 2;
                        if(_loc11_)
                        {
                           _loc13_ = _loc11_.getMaxAmountOndeck();
                        }
                        if(_loc10_ && _loc8_ > 0 && (param3 == false || param3 == true && _loc8_ <= _loc13_))
                        {
                           param2 = addCardSkuToCatalogs(_loc9_,_loc8_,param2);
                        }
                        else if(_loc10_ && _loc8_ > _loc13_)
                        {
                           _loc8_ = _loc13_;
                           param2 = addCardSkuToCatalogs(_loc9_,_loc8_,param2);
                        }
                     }
                  }
               }
               _loc7_++;
            }
         }
         return param2;
      }
      
      public static function getUniqueCardsAmountByCatalog(param1:Dictionary) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc4_ = DictionaryUtils.getKeys(param1);
            if(_loc4_ != null)
            {
               _loc2_ = int(_loc4_.length);
            }
         }
         return _loc2_;
      }
      
      public static function getCatalogCardsAmountCheckingRestrictions(param1:Dictionary, param2:Boolean = true, param3:int = -1) : int
      {
         var _loc5_:CardDef = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Dictionary = null;
         var _loc9_:Array = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc4_:int = 0;
         if(param1 != null)
         {
            _loc7_ = DictionaryUtils.getKeys(param1);
            _loc8_ = new Dictionary(true);
            _loc9_ = null;
            _loc10_ = false;
            if(_loc7_ != null)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc7_.length)
               {
                  _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc7_[_loc6_]));
                  if(param2)
                  {
                     if(_loc5_)
                     {
                        _loc11_ = 0;
                        _loc13_ = _loc5_.getMaxAmountOndeck();
                        _loc12_ = param1[_loc7_[_loc6_]] > _loc13_ ? _loc13_ : int(param1[_loc7_[_loc6_]]);
                        _loc14_ = 0;
                        for(; _loc14_ < _loc12_; _loc14_++)
                        {
                           if(!DictionaryUtils.getDeckFamilyIDMaxReached(_loc5_,_loc8_,_loc9_))
                           {
                              if(_loc5_.isLeader())
                              {
                                 if(_loc10_)
                                 {
                                    continue;
                                 }
                                 _loc10_ = true;
                              }
                              if(_loc8_[_loc5_.getSku()] == null)
                              {
                                 _loc8_[_loc5_.getSku()] = 1;
                              }
                              else
                              {
                                 _loc8_[_loc5_.getSku()] = _loc8_[_loc5_.getSku()] + 1;
                              }
                              _loc11_++;
                              if(_loc14_ == 0)
                              {
                                 if(_loc9_ == null)
                                 {
                                    _loc9_ = new Array();
                                 }
                                 _loc9_.push(_loc7_[_loc6_]);
                              }
                           }
                        }
                     }
                  }
                  if(!(_loc5_ is PowerDef))
                  {
                     _loc4_ += _loc11_;
                  }
                  if(param3 != -1 && _loc4_ >= param3)
                  {
                     return _loc4_;
                  }
                  _loc6_++;
               }
            }
         }
         return _loc4_;
      }
      
      public static function checkIfDeckSizeCorrect(param1:Dictionary, param2:Dictionary, param3:int = -1, param4:int = -1) : Boolean
      {
         if(Config.getConfig().gameHasClassSystem() && param3 >= Config.getConfig().getMaxDecksAmount())
         {
            return true;
         }
         if(param1 == null)
         {
            return false;
         }
         var _loc5_:int = Config.getConfig().getDeckCardsAmount();
         var _loc6_:Boolean = false;
         var _loc7_:int = getCatalogCardsAmountCheckingRestrictions(param1);
         param4 = param4 == -1 ? getCatalogCardsAmountCheckingRestrictions(param2,true,_loc5_) : param4;
         if(param4 >= _loc7_)
         {
            if(param4 >= _loc5_)
            {
               _loc6_ = _loc7_ == _loc5_;
            }
            else
            {
               _loc6_ = param4 == _loc7_ && param4 > 0 && _loc7_ > 0;
            }
         }
         else
         {
            _loc6_ = false;
         }
         FSDebug.debugTrace("size correct? " + _loc6_.toString());
         FSDebug.debugTrace("deck cards amount: " + _loc7_);
         FSDebug.debugTrace("collection cards amount: " + param4);
         return _loc6_;
      }
      
      public static function addCardSkuToCatalogs(param1:String, param2:int, param3:Dictionary) : Dictionary
      {
         if(param3 == null)
         {
            param3 = new Dictionary(true);
         }
         if(param3[param1] == null)
         {
            param3[param1] = param2;
         }
         else
         {
            param3[param1] += param2;
         }
         return param3;
      }
      
      public static function removeCardSkuFromCatalogs(param1:String, param2:int, param3:Dictionary, param4:Boolean = true) : Dictionary
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param3 != null)
         {
            if(param3[param1] != null)
            {
               _loc5_ = int(param3[param1]);
               if(param4)
               {
                  param3[param1] = _loc5_ - param2 >= 0 ? _loc5_ - param2 : 0;
               }
               else
               {
                  _loc6_ = int(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection()[param1]);
                  param3[param1] = _loc6_ >= _loc5_ ? _loc5_ : _loc6_;
               }
            }
            if(param3[param1] == 0)
            {
               delete param3[param1];
            }
         }
         return param3;
      }
      
      public static function createCatalogCopy(param1:Dictionary) : Dictionary
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc2_:Dictionary = new Dictionary(true);
         if(param1 != null)
         {
            _loc3_ = getKeys(param1);
            for each(_loc4_ in _loc3_)
            {
               _loc2_[_loc4_] = param1[_loc4_];
            }
         }
         return _loc2_;
      }
      
      public static function getCardsVectorFromDictionary(param1:Dictionary) : Vector.<FSCard>
      {
         var _loc2_:Vector.<FSCard> = null;
         var _loc3_:FSCard = null;
         if(param1 != null)
         {
            for each(_loc3_ in param1)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = new Vector.<FSCard>();
               }
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function disposeCatalogCards(param1:Dictionary, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:FSCardXL = null;
         var _loc5_:* = undefined;
         var _loc6_:Vector.<String> = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:CardDef = null;
         var _loc10_:Vector.<String> = null;
         var _loc11_:int = 0;
         if(param1 != null)
         {
            if(!param3)
            {
               for each(_loc5_ in param1)
               {
                  if(_loc5_ is FSCard)
                  {
                     disposeCard(_loc5_,param2);
                  }
                  else if(_loc5_ is InfoCard)
                  {
                     InfoCard(_loc5_).dispose();
                  }
                  else if(_loc5_ is FSCardSocket)
                  {
                     if(FSCardSocket(_loc5_).getParentCard() != null)
                     {
                        disposeCard(FSCardSocket(_loc5_).getParentCard(),param2);
                     }
                     FSCardSocket(_loc5_).removeFromParent(!param2);
                  }
                  _loc5_ = null;
               }
            }
            else
            {
               if(!param2)
               {
                  _loc7_ = DictionaryUtils.getKeys(param1);
                  _loc8_ = 0;
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length)
                  {
                     _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc7_[_loc8_]));
                     if(_loc9_ != null)
                     {
                        _loc10_ = _loc9_ ? InstanceMng.getCardsMng().getCardTiersImageNames(_loc9_) : null;
                        if(_loc10_)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc10_.length)
                           {
                              Root.assets.removeTexture(_loc10_[_loc11_]);
                              _loc11_++;
                           }
                        }
                        Root.assets.removeTexture(_loc9_.getFrameRarityBGName());
                        Root.assets.removeTexture(_loc9_.getFactionFrameBGName());
                        Root.assets.removeTexture(_loc9_.getBackBGName());
                        Root.assets.removeTexture(_loc9_.getBGXLImageName());
                        Root.assets.removeTexture(_loc9_.getFrameRarityBGName());
                        Root.assets.removeTexture(_loc9_.getFactionFrameBGName());
                        Root.assets.removeTexture(_loc9_.getCompositeTierFrameName());
                        if(Config.getConfig().XLViewUsesXLTextures())
                        {
                           Root.assets.removeTexture(_loc9_.getCompositeTierFrameName(true));
                        }
                        if(_loc9_.hasAnimatedBG())
                        {
                           Root.assets.removeTextureAtlas(_loc9_.getAnimatedBG());
                           Root.assets.removeTexture(_loc9_.getAnimatedBG());
                        }
                     }
                     _loc8_++;
                  }
               }
               _loc6_ = InstanceMng.getCardsMng().getCardAllPossibleSounds(null,_loc9_);
               if((Boolean(_loc6_)) && _loc6_.length > 0)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc6_.length)
                  {
                     if(_loc6_[_loc8_] != null && _loc6_[_loc8_] != "")
                     {
                        Root.assets.removeSound(_loc6_[_loc8_]);
                     }
                     _loc8_++;
                  }
               }
            }
         }
      }
      
      public static function disposeCard(param1:FSCard, param2:Boolean = false) : void
      {
         var _loc4_:FSCardXL = null;
         var _loc5_:CardDef = null;
         var _loc6_:FactionDef = null;
         var _loc7_:int = 0;
         if(!param2 && Boolean(param1))
         {
            _loc4_ = param1.getTempCardXL();
            if(_loc4_ != null)
            {
               _loc4_.dispose();
            }
            _loc5_ = param1.getCardDef();
            if(_loc5_)
            {
               param1.removeCardElemsFromDisplayList(true);
               InstanceMng.getResourcesMng().disposeCardBGByCardDef(_loc5_);
               Root.assets.removeTexture(_loc5_.getBGXLImageName());
               Root.assets.removeTexture(_loc5_.getFrameRarityBGName());
               Root.assets.removeTexture(_loc5_.getFactionFrameBGName());
               Root.assets.removeTexture(_loc5_.getBackBGName());
               Root.assets.removeTexture(_loc5_.getCompositeTierFrameName());
               if(Config.getConfig().XLViewUsesXLTextures())
               {
                  Root.assets.removeTexture(_loc5_.getCompositeTierFrameName(true));
               }
               _loc6_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(_loc5_.getFactionSku()));
               if(_loc6_)
               {
                  Root.assets.removeTexture(_loc6_.getBackBGName());
               }
               if(_loc5_.hasAnimatedBG())
               {
                  Root.assets.removeTextureAtlas(_loc5_.getAnimatedBG());
                  Root.assets.removeTexture(_loc5_.getAnimatedBG());
               }
            }
            param1.setTempCardXL(null);
         }
         var _loc3_:Vector.<String> = InstanceMng.getCardsMng().getCardAllPossibleSounds(param1);
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               if(_loc3_[_loc7_] != null && _loc3_[_loc7_] != "")
               {
                  if(_loc3_[_loc7_] != null)
                  {
                     Root.assets.removeSound(_loc3_[_loc7_]);
                  }
               }
               _loc7_++;
            }
         }
         if(param1)
         {
            param1.removeFromParent(!param2);
         }
         if(Config.USE_CARD_POOLING)
         {
            FSCardsMng.addCardToPool(param1,false);
         }
      }
      
      public static function disposeCardXL(param1:FSCardXL) : void
      {
         var _loc2_:CardDef = null;
         var _loc3_:Screen = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         if(param1 != null)
         {
            _loc2_ = param1.getCardDef();
            if(_loc2_)
            {
               if(Config.getConfig().XLViewUsesXLTextures())
               {
                  _loc3_ = InstanceMng.getCurrentScreen();
                  _loc4_ = Boolean(_loc3_) && (!(_loc3_ is FSShopScreen) || _loc3_ is FSShopScreen && FSShopScreen(_loc3_).isBGBDisposable(_loc2_.getBGXLImageName()));
                  if(_loc4_)
                  {
                     Root.assets.removeTexture(_loc2_.getBGXLImageName());
                  }
                  Root.assets.removeTexture(_loc2_.getFrameRarityBGName());
                  Root.assets.removeTexture(_loc2_.getFactionFrameBGName());
               }
               if(Config.getConfig().XLViewUsesXLTextures())
               {
                  Root.assets.removeTexture(_loc2_.getCompositeTierFrameName(true));
               }
               if(Config.getConfig().XLViewShowsCardBack())
               {
                  _loc5_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(_loc2_.getFactionSku())).getBackBGXLName();
                  Root.assets.removeTexture(_loc5_);
               }
            }
            param1.removeFromParent();
            param1.safeXLDisposal();
            if(param1.getParentCard())
            {
               param1.getParentCard().setZoomedIn(false);
            }
            param1.destroy();
            param1 = null;
         }
      }
      
      public static function getCatalogFilteredByCategory(param1:Dictionary, param2:int) : Dictionary
      {
         var _loc3_:Dictionary = null;
         var _loc4_:CategoryDef = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:CardDef = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         if(param1 != null)
         {
            _loc4_ = CategoryDef(InstanceMng.getCategoriesDefMng().getDefByIndex(param2));
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.getSku();
               if(_loc5_ != null && _loc5_ != "")
               {
                  _loc13_ = DictionaryUtils.getKeys(param1);
                  _loc12_ = 0;
                  while(_loc12_ < _loc13_.length)
                  {
                     _loc7_ = _loc13_[_loc12_];
                     _loc8_ = int(param1[_loc7_]);
                     _loc10_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc7_));
                     if(_loc10_ != null)
                     {
                        _loc11_ = _loc10_.getCategorySku();
                        if(_loc11_ == _loc5_)
                        {
                           _loc3_ = addCardSkuToCatalogs(_loc7_,_loc8_,_loc3_);
                        }
                     }
                     _loc12_++;
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public static function getCatalogFilteredByFaction(param1:Dictionary, param2:String, param3:Boolean = true) : Dictionary
      {
         var _loc4_:Dictionary = null;
         var _loc5_:FactionDef = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:CardDef = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         if(param1 != null)
         {
            _loc5_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(param2));
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_.getSku();
               if(_loc6_ != null && _loc6_ != "")
               {
                  _loc14_ = DictionaryUtils.getKeys(param1);
                  _loc13_ = 0;
                  while(_loc13_ < _loc14_.length)
                  {
                     _loc8_ = _loc14_[_loc13_];
                     _loc9_ = int(param1[_loc8_]);
                     _loc11_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc8_));
                     if(_loc11_ != null)
                     {
                        _loc12_ = _loc11_.getFactionSku();
                        if(_loc12_ == _loc6_ && (_loc11_.isFusion() == param3 || !_loc11_.isFusion()))
                        {
                           _loc4_ = addCardSkuToCatalogs(_loc8_,_loc9_,_loc4_);
                        }
                     }
                     _loc13_++;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      public static function dictionaryToArray(param1:Dictionary, param2:Boolean = false) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param1 != null)
         {
            _loc3_ = new Array();
            _loc4_ = getKeys(param1);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc3_[_loc5_] = !param2 ? _loc4_[_loc5_] + ":" + param1[_loc4_[_loc5_]] : _loc4_[_loc5_];
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      public static function getCardsAmountPerCatalog(param1:Dictionary) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(param1 != null)
         {
            for each(_loc3_ in param1)
            {
               _loc2_ += _loc3_;
            }
         }
         return _loc2_;
      }
      
      public static function isCardAvailableToFusion(param1:CardDef, param2:Boolean = false) : Boolean
      {
         var _loc3_:Dictionary = null;
         var _loc4_:RarityDef = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc14_:UserData = Utils.getOwnerUserData();
         if(_loc14_)
         {
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
            if(_loc3_)
            {
               _loc13_ = DictionaryUtils.getCardsAmountPerCatalog(_loc3_);
               if(_loc13_)
               {
                  if(param1.getCardRarity() != "rarity_01")
                  {
                     _loc4_ = InstanceMng.getRaritiesDefMng().getDefBySku(param1.getCardRarity()) as RarityDef;
                     if(_loc4_)
                     {
                        _loc5_ = param1.getFusionAmountCards();
                        _loc6_ = param1.getFusionSku();
                        _loc7_ = int(_loc3_[_loc6_]);
                        if(param1.needsExtraFusionCard())
                        {
                           _loc8_ = param1.getFusionAmountExtraCards();
                           _loc9_ = param1.getExtraFusionSku();
                           _loc10_ = int(_loc3_[_loc9_]);
                        }
                        _loc15_ = _loc7_ >= _loc5_;
                        _loc16_ = param1.needsExtraFusionCard() ? _loc10_ >= _loc8_ : true;
                        if(_loc15_ && _loc16_)
                        {
                           if(param2)
                           {
                              _loc12_ = param1.getCraftCost();
                              _loc17_ = _loc13_ - _loc5_ >= Config.getConfig().getDeckCardsAmount();
                              _loc18_ = param1.needsExtraFusionCard() ? _loc13_ - (_loc5_ + _loc8_) >= Config.getConfig().getDeckCardsAmount() : true;
                              if(param1.getFusionTypeCost() == 0)
                              {
                                 if(InstanceMng.getUserDataMng().getOwnerUserData().getGold() >= _loc12_ && _loc17_ && _loc18_)
                                 {
                                    _loc11_ = true;
                                 }
                              }
                              else if(InstanceMng.getUserDataMng().getOwnerUserData().getRaidCoins() >= _loc12_ && _loc17_ && _loc18_)
                              {
                                 _loc11_ = true;
                              }
                           }
                           else
                           {
                              _loc11_ = true;
                           }
                        }
                     }
                  }
               }
            }
         }
         return _loc11_;
      }
      
      public static function isCardAvailableToCraft(param1:CardDef, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:CardDef = null;
         var _loc16_:Boolean = false;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc15_:UserData = Utils.getOwnerUserData();
         if(_loc15_)
         {
            _loc4_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
            if(_loc4_)
            {
               _loc13_ = DictionaryUtils.getCardsAmountPerCatalog(_loc4_);
               if(_loc13_)
               {
                  if(param1.getCardRarity() != "rarity_01")
                  {
                     if(param1.isFusion())
                     {
                        _loc5_ = param1.getFusionAmountCards();
                        _loc6_ = param1.getFusionSku();
                        _loc7_ = int(_loc4_[_loc6_]);
                        if(param1.needsExtraFusionCard())
                        {
                           _loc9_ = param1.getExtraFusionSku();
                           if(_loc9_ != "" && _loc9_ != null)
                           {
                              _loc14_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc9_));
                              if((Boolean(_loc14_)) && !_loc14_.isCraftMaterial())
                              {
                                 _loc8_ = param1.getFusionAmountExtraCards();
                                 _loc10_ = int(_loc4_[_loc9_]);
                              }
                           }
                        }
                     }
                     else
                     {
                        _loc5_ = param1.getCraftAmountCards();
                        _loc6_ = param1.getCraftSku();
                        _loc7_ = int(_loc4_[_loc6_]);
                        if(param1.needsExtraCraftCard())
                        {
                           _loc9_ = param1.getExtraCraftSku();
                           if(_loc9_ != "" && _loc9_ != null)
                           {
                              _loc14_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc9_));
                              if((Boolean(_loc14_)) && !_loc14_.isCraftMaterial())
                              {
                                 _loc8_ = param1.getExtraCraftAmountCards();
                                 _loc10_ = int(_loc4_[_loc9_]);
                              }
                           }
                        }
                     }
                     _loc16_ = param1.getEnhanceLevel() > 0 ? param3 || !param3 && _loc10_ >= _loc8_ : _loc10_ >= _loc8_;
                     if(_loc6_ != null && _loc6_ != "" && _loc7_ >= _loc5_ && _loc16_)
                     {
                        if(param2)
                        {
                           _loc12_ = param1.isFusion() ? param1.getFusionCost() : param1.getCraftCost();
                           _loc17_ = Config.getConfig().getDeckCardsAmount();
                           _loc18_ = param1.needsExtraCraftCard() ? _loc13_ - (_loc5_ + _loc8_) >= _loc17_ : _loc13_ - _loc5_ >= _loc17_;
                           if(_loc18_)
                           {
                              if(param1.getFusionTypeCost() == 0)
                              {
                                 if(InstanceMng.getUserDataMng().getOwnerUserData().getGold() >= _loc12_)
                                 {
                                    _loc11_ = true;
                                 }
                              }
                              else if(InstanceMng.getUserDataMng().getOwnerUserData().getRaidCoins() >= _loc12_)
                              {
                                 _loc11_ = true;
                              }
                           }
                        }
                        else
                        {
                           _loc11_ = true;
                        }
                     }
                  }
               }
            }
         }
         return _loc11_;
      }
      
      public static function filterCatalog(param1:Dictionary, param2:Boolean, param3:Boolean = false, param4:Dictionary = null, param5:Dictionary = null, param6:Dictionary = null, param7:Dictionary = null, param8:Dictionary = null, param9:Boolean = true, param10:Boolean = true, param11:String = "", param12:String = "") : Dictionary
      {
         var _loc13_:Dictionary = null;
         var _loc14_:Array = null;
         var _loc15_:CardDef = null;
         var _loc16_:String = null;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:int = 0;
         if(param1 != null)
         {
            _loc13_ = new Dictionary(true);
            _loc14_ = getKeys(param1);
            _loc18_ = Boolean(param11) && param11.length > 0;
            _loc19_ = Boolean(param12) && param12.length > 0;
            _loc20_ = 0;
            while(_loc20_ < _loc14_.length)
            {
               _loc17_ = true;
               _loc16_ = _loc14_[_loc20_];
               _loc15_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc16_));
               if(_loc15_ != null)
               {
                  _loc17_ &&= isCardEligibleBySubcategories(_loc15_,param6,param3);
                  _loc17_ = (_loc17_) && isCardEligibleByFaction(_loc15_,param5,param3,param2);
                  _loc17_ = (_loc17_) && isCardEligibleBySummonCost(_loc15_,param8);
                  _loc17_ = (_loc17_) && isCardEligibleByRarities(_loc15_,param4);
                  _loc17_ = (_loc17_) && isCardEligibleByEditions(_loc15_,param7);
                  if(param10)
                  {
                     _loc17_ &&= isCardEligibleByNewCards(_loc15_);
                  }
                  if(param9)
                  {
                     _loc17_ &&= isCardEligibleByFavourites(_loc15_);
                  }
                  if(_loc18_ || _loc19_)
                  {
                     _loc17_ &&= isCardEligibleByAbilityName(_loc15_,param11);
                  }
                  if(_loc17_)
                  {
                     _loc13_[_loc16_] = param1[_loc16_];
                  }
               }
               _loc20_++;
            }
         }
         return _loc13_;
      }
      
      private static function isCardEligibleBySubcategories(param1:CardDef, param2:Dictionary, param3:Boolean) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = true;
         switch(param1.getCategoryIndex())
         {
            case CategoriesDefMng.CATEGORY_UNITS:
               _loc4_ = param1.getSubCategorySku();
               break;
            case CategoriesDefMng.CATEGORY_ATTACHMENTS:
            case CategoriesDefMng.CATEGORY_POWERS:
            case CategoriesDefMng.CATEGORY_ACTIONS:
               _loc4_ = param1.getAttachedToSubcategorySku();
               break;
            default:
               _loc4_ = param1.getSubCategorySku();
         }
         if(_loc4_ != null)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc5_ = _loc4_[_loc6_];
               if(_loc5_ != "" && _loc5_ != null)
               {
                  if(param2 != null || param3)
                  {
                     _loc7_ = param2 != null && param2[_loc5_] != null ? Boolean(param2[_loc5_]) : true;
                     if(_loc7_ == true)
                     {
                        return _loc7_;
                     }
                  }
               }
               _loc6_++;
            }
         }
         return _loc7_;
      }
      
      private static function isCardEligibleBySummonCost(param1:CardDef, param2:Dictionary) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         switch(param1.getType())
         {
            case FSCard.TYPE_UNIT:
               _loc3_ = param1.getSummonCost();
               break;
            case FSCard.TYPE_ATTACHMENT:
               _loc4_ = AttachmentDef(param1).getAttachmentCost();
               _loc3_ = int(_loc4_[0]);
               break;
            case FSCard.TYPE_ACTION:
               _loc3_ = (param1 as ActionDef).getUpgradeCosts() ? int((param1 as ActionDef).getUpgradeCosts()[0]) : 0;
               break;
            default:
               _loc3_ = param1.getSummonCost();
         }
         if(_loc3_ > 7)
         {
            _loc3_ = 7;
         }
         return param2 == null || Boolean(param2) && param2[_loc3_] != null && Boolean(param2[_loc3_]);
      }
      
      private static function isCardEligibleByFaction(param1:CardDef, param2:Dictionary, param3:Boolean, param4:Boolean) : Boolean
      {
         var _loc5_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc6_:Dictionary = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection() : null;
         var _loc7_:Boolean = false;
         if(param1 != null)
         {
            _loc5_ = param1.getFactionSku();
            if(_loc5_ != "" && _loc5_ != null)
            {
               if(param2 != null || param3)
               {
                  _loc7_ = param2 != null && param2[_loc5_] != null ? Boolean(param2[_loc5_]) : true;
                  if((_loc7_) || param3)
                  {
                     if(param4)
                     {
                        _loc7_ = isCardAvailableToCraft(param1);
                     }
                     else
                     {
                        if(param1.getEnhanceLevel() <= 0)
                        {
                           return true;
                        }
                        _loc8_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_CREATION_MODE;
                        _loc9_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON();
                        if(!(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen && (_loc8_ || _loc9_)))
                        {
                           return true;
                        }
                        _loc7_ = _loc6_[param1.getSku()] != null || isCardAvailableToCraft(param1,false,true);
                     }
                  }
               }
            }
         }
         return _loc7_;
      }
      
      private static function isCardEligibleByRarities(param1:CardDef, param2:Dictionary) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         if(param1 != null)
         {
            _loc3_ = param1.getCardRarity();
            if(_loc3_ != "" && _loc3_ != null)
            {
               if(param2 != null)
               {
                  _loc4_ = param2 != null && param2[_loc3_] != null ? Boolean(param2[_loc3_]) : true;
               }
            }
         }
         return _loc4_;
      }
      
      private static function isCardEligibleByEditions(param1:CardDef, param2:Dictionary) : Boolean
      {
         var _loc3_:String = null;
         var _loc5_:EditionDef = null;
         var _loc4_:Boolean = false;
         var _loc6_:int = 0;
         if(param1 != null)
         {
            _loc3_ = param1.getEditionSku();
            _loc5_ = EditionDef(InstanceMng.getEditionsDefMng().getDefBySku(_loc3_));
            _loc6_ = _loc5_.getGameIndex();
            if(param2 != null)
            {
               _loc4_ = param2 != null && param2[_loc6_] != null ? Boolean(param2[_loc6_]) : true;
            }
         }
         return _loc4_;
      }
      
      private static function isCardEligibleByNewCards(param1:CardDef) : Boolean
      {
         var _loc2_:String = null;
         var _loc4_:UserData = null;
         var _loc3_:Boolean = false;
         if(param1 != null)
         {
            _loc2_ = param1.getSku();
            _loc4_ = Utils.getOwnerUserData();
            return _loc4_ ? _loc4_.isCardInNewCardsCollection(_loc2_) : false;
         }
         return _loc3_;
      }
      
      private static function isCardEligibleByFavourites(param1:CardDef) : Boolean
      {
         var _loc2_:String = null;
         var _loc4_:UserData = null;
         var _loc3_:Boolean = false;
         if(param1 != null)
         {
            _loc2_ = param1.getSku();
            _loc4_ = Utils.getOwnerUserData();
            return _loc4_ ? _loc4_.isCardInFavouritesCollection(_loc2_) : false;
         }
         return _loc3_;
      }
      
      private static function isCardEligibleByAbilityName(param1:CardDef, param2:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:AbilityDef = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc4_:Boolean = true;
         if(param1 != null && param2 != null && param2 != "")
         {
            _loc5_ = param2.split(",");
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               _loc7_ = "";
               _loc12_ = 0;
               _loc9_ = 0;
               while(_loc9_ < _loc5_.length)
               {
                  _loc7_ = _loc5_[_loc9_];
                  _loc6_ = param1.getAllAbilitiesDefsBreakdown();
                  _loc13_ = !_loc13_ ? isCardEligibleByCardName(param1,_loc7_) : _loc13_;
                  if(_loc6_)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < _loc6_.length)
                     {
                        _loc10_ = _loc6_[_loc8_];
                        _loc11_ = (Boolean(_loc10_)) && Boolean(_loc10_.getName()) ? _loc10_.getName().toLowerCase() : "";
                        if(_loc11_ != "" && _loc11_.indexOf(_loc7_.toLowerCase()) != -1)
                        {
                           _loc12_++;
                           break;
                        }
                        _loc8_++;
                     }
                  }
                  _loc9_++;
               }
               _loc4_ = _loc12_ == _loc5_.length || _loc13_;
            }
         }
         return _loc4_;
      }
      
      private static function isCardEligibleByCardName(param1:CardDef, param2:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:AbilityDef = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc4_:Boolean = true;
         if(param1 != null && param2 != null && param2 != "")
         {
            _loc5_ = param2.split(",");
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               _loc6_ = "";
               _loc11_ = 0;
               _loc12_ = Config.ENVIRONMENT_ACTIVE == Config.ENVIRONMENT_DEV;
               _loc8_ = 0;
               while(_loc8_ < _loc5_.length)
               {
                  _loc6_ = _loc5_[_loc8_];
                  _loc10_ = param1.getName().toLowerCase();
                  if(_loc10_ != "" && (_loc10_.indexOf(_loc6_.toLowerCase()) != -1 || _loc12_ && param1.getSku() == _loc6_.toLowerCase()))
                  {
                     _loc11_++;
                     break;
                  }
                  _loc8_++;
               }
               _loc4_ = _loc11_ == _loc5_.length;
            }
         }
         return _loc4_;
      }
      
      public static function filterCatalogByPowersBelongingToClass(param1:Dictionary, param2:JobDef) : Dictionary
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:CardDef = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         if(param1 != null)
         {
            _loc3_ = new Dictionary(true);
            _loc4_ = getKeys(param1);
            _loc5_ = param2.getActiveDefaultSku();
            _loc6_ = param2.getActiveSecondarySku();
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               _loc10_ = true;
               _loc9_ = _loc4_[_loc7_];
               if(_loc9_ == _loc5_ || _loc9_ == _loc6_)
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = new Dictionary(true);
                  }
                  _loc3_[_loc9_] = param1[_loc9_];
               }
               _loc7_++;
            }
         }
         return _loc3_;
      }
      
      public static function filterCatalogByCardsAlreadyOnDeck(param1:Dictionary, param2:Dictionary) : Dictionary
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 != null)
         {
            _loc3_ = new Dictionary(true);
            _loc4_ = getKeys(param1);
            _loc8_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc7_ = int(param1[_loc6_]);
               _loc9_ = param2 != null && Boolean(param2[_loc6_]) ? int(param2[_loc6_]) : 0;
               _loc8_ = _loc7_ > _loc9_ ? int(_loc7_ - _loc9_) : 0;
               _loc3_[_loc6_] = _loc8_;
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      public static function sortCardArrByCardValue(param1:Array) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         param1.sort(DictionaryUtils.sortCardsByValueAndSubcategory);
         param1.reverse();
         _loc2_ = "";
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = _loc2_ != "" ? _loc2_ + "," + param1[_loc4_] : param1[_loc4_];
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function sortCardsCatalogByPlayableCardId(param1:FSCard, param2:FSCard) : Number
      {
         var _loc5_:RegExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1 == null || param2 == null)
         {
            return -1;
         }
         var _loc3_:int = param1 ? param1.getPlayableCardId() : 0;
         var _loc4_:int = param2 ? param2.getPlayableCardId() : 0;
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ == _loc4_)
         {
            _loc5_ = /[^0-9]/g;
            _loc6_ = parseInt(param1.getCardDef().getSku().replace(_loc5_,""),10);
            _loc7_ = parseInt(param2.getCardDef().getSku().replace(_loc5_,""),10);
            return _loc6_ === _loc7_ ? 0 : (_loc6_ > _loc7_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortByCardValue(param1:Dictionary) : Dictionary
      {
         var _loc2_:Dictionary = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            _loc3_.push(_loc4_);
         }
         _loc3_.sort(sortCardsSkusByValue);
         _loc3_.reverse();
         _loc2_ = new Dictionary(true);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc2_[_loc5_] = _loc3_[_loc5_];
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function sortCardsByValueAndSubcategory(param1:String, param2:String) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:CardDef = CardDef(mCardDefMng.getDefBySku(param1.split(":")[0]));
         var _loc4_:int = _loc3_.getCardValue();
         var _loc5_:CardDef = CardDef(mCardDefMng.getDefBySku(param2.split(":")[0]));
         var _loc6_:int = _loc5_.getCardValue();
         if(_loc4_ > _loc6_)
         {
            return -1;
         }
         if(_loc4_ < _loc6_)
         {
            return 1;
         }
         if(_loc4_ == _loc6_)
         {
            return sortCardsDefsBySubcategory(_loc3_,_loc5_);
         }
         return 0;
      }
      
      public static function sortAbilitiesBySku(param1:Ability, param2:Ability) : Number
      {
         var _loc7_:RegExp = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:AbilityDef = param1.getAbilityDef();
         var _loc4_:String = _loc3_.getSku();
         var _loc5_:AbilityDef = param2.getAbilityDef();
         var _loc6_:String = _loc5_.getSku();
         if(_loc4_ < _loc6_)
         {
            return -1;
         }
         if(_loc4_ > _loc6_)
         {
            return 1;
         }
         if(_loc4_ == _loc6_)
         {
            _loc7_ = /[^0-9]/g;
            _loc8_ = parseInt(_loc3_.getSku().replace(_loc7_,""),10);
            _loc9_ = parseInt(_loc5_.getSku().replace(_loc7_,""),10);
            return _loc8_ === _loc9_ ? 0 : (_loc8_ > _loc9_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortAbilitiesDefsByShield(param1:AbilityDef, param2:AbilityDef) : Number
      {
         var _loc5_:RegExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = param1.getShield();
         var _loc4_:int = param2.getShield();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            _loc5_ = /[^0-9]/g;
            _loc6_ = parseInt(param1.getSku().replace(_loc5_,""),10);
            _loc7_ = parseInt(param2.getSku().replace(_loc5_,""),10);
            return _loc6_ === _loc7_ ? 0 : (_loc6_ > _loc7_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortCardsDefsByValue(param1:CardDef, param2:CardDef) : Number
      {
         var _loc5_:RegExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1 == null || param2 == null)
         {
            return -1;
         }
         var _loc3_:int = param1 ? param1.getCardValue() : 0;
         var _loc4_:int = param2 ? param2.getCardValue() : 0;
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            _loc5_ = /[^0-9]/g;
            _loc6_ = parseInt(param1.getSku().replace(_loc5_,""),10);
            _loc7_ = parseInt(param2.getSku().replace(_loc5_,""),10);
            return _loc6_ === _loc7_ ? 0 : (_loc6_ > _loc7_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortCardsBySkus(param1:String, param2:String) : Number
      {
         var _loc5_:RegExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:int = int(param1.split("_")[1]);
         var _loc4_:int = int(param2.split("_")[1]);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            _loc5_ = /[^0-9]/g;
            _loc6_ = parseInt(param1.replace(_loc5_,""),10);
            _loc7_ = parseInt(param2.replace(_loc5_,""),10);
            return _loc6_ === _loc7_ ? 0 : (_loc6_ > _loc7_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortCardsSkusByValue(param1:String, param2:String) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:int = mCardDefMng.getCardValue(param1);
         var _loc4_:int = mCardDefMng.getCardValue(param2);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            return sortCardsSkusByEdition(param1,param2);
         }
         return 0;
      }
      
      public static function nonDeepSortCardsSkusByValue(param1:String, param2:String) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:int = mCardDefMng.getCardValue(param1);
         var _loc4_:int = mCardDefMng.getCardValue(param2);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            return sortCardsSkusByEdition(param1,param2,false);
         }
         return 0;
      }
      
      public static function sortCardsSkusByEdition(param1:String, param2:String, param3:Boolean = true) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc4_:int = mCardDefMng.getCardEdition(param1);
         var _loc5_:int = mCardDefMng.getCardEdition(param2);
         if(_loc4_ > _loc5_)
         {
            return -1;
         }
         if(_loc4_ < _loc5_)
         {
            return 1;
         }
         if(_loc4_ == _loc5_ && param3)
         {
            return sortCardsBySkus(param1,param2);
         }
         return 0;
      }
      
      public static function sortRaidShopItemsByPrice(param1:RaidShopDef, param2:RaidShopDef) : Number
      {
         var _loc5_:RegExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = param1.getCost();
         var _loc4_:int = param2.getCost();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            _loc5_ = /[^0-9]/g;
            _loc6_ = parseInt(param1.getSku().replace(_loc5_,""),10);
            _loc7_ = parseInt(param2.getSku().replace(_loc5_,""),10);
            return _loc6_ === _loc7_ ? 0 : (_loc6_ > _loc7_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortBundlesByViewsCount(param1:Object, param2:Object) : Number
      {
         var _loc5_:RegExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = int(param1["views"]);
         var _loc4_:int = int(param2["views"]);
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            _loc5_ = /[^0-9]/g;
            _loc6_ = parseInt(BundleDef(param1["bundleDef"]).getSku().replace(_loc5_,""),10);
            _loc7_ = parseInt(BundleDef(param2["bundleDef"]).getSku().replace(_loc5_,""),10);
            return _loc6_ === _loc7_ ? 0 : (_loc6_ > _loc7_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortQuestShopItemsByPrice(param1:QuestShopDef, param2:QuestShopDef) : Number
      {
         var _loc5_:RegExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = param1.getCost();
         var _loc4_:int = param2.getCost();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            _loc5_ = /[^0-9]/g;
            _loc6_ = parseInt(param1.getSku().replace(_loc5_,""),10);
            _loc7_ = parseInt(param2.getSku().replace(_loc5_,""),10);
            return _loc6_ === _loc7_ ? 0 : (_loc6_ > _loc7_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortQuestsByReward(param1:Quest, param2:Quest) : Number
      {
         var _loc5_:RegExp = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = param1.getRewardPoints();
         var _loc4_:int = param2.getRewardPoints();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ == _loc4_)
         {
            _loc5_ = /[^0-9]/g;
            _loc6_ = parseInt(param1.getDef().getSku().replace(_loc5_,""),10);
            _loc7_ = parseInt(param2.getDef().getSku().replace(_loc5_,""),10);
            return _loc6_ === _loc7_ ? 0 : (_loc6_ > _loc7_ ? 1 : -1);
         }
         return 0;
      }
      
      public static function sortQuestsByDailyFirst(param1:Quest, param2:Quest) : Number
      {
         var _loc3_:Boolean = param1.isDaily();
         var _loc4_:Boolean = param2.isDaily();
         if(_loc3_)
         {
            return -1;
         }
         if(_loc4_)
         {
            return 1;
         }
         return sortQuestsByReward(param1,param2);
      }
      
      public static function sortDungeonRewardsByPosition(param1:DungeonRewardsDef, param2:DungeonRewardsDef) : Number
      {
         var _loc3_:int = param1.getStartPosition();
         var _loc4_:int = param2.getStartPosition();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 1;
      }
      
      public static function sortPvPRewardsByPosition(param1:PvPRewardsDef, param2:PvPRewardsDef) : Number
      {
         var _loc3_:int = param1.getStartPosition();
         var _loc4_:int = param2.getStartPosition();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 1;
      }
      
      public static function sortMatchesArrByELO(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = int(param1.elo);
         var _loc4_:int = int(param2.elo);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortByIndexAsc(param1:Def, param2:Def) : Number
      {
         var _loc3_:int = param1.getIndex();
         var _loc4_:int = param2.getIndex();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortByDefSku(param1:Def, param2:Def) : Number
      {
         if(param1.getSku() < param2.getSku())
         {
            return -1;
         }
         if(param1.getSku() > param2.getSku())
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortTracklist(param1:String, param2:String) : Number
      {
         if(param1 < param2)
         {
            return -1;
         }
         if(param1 > param2)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortObjectArrByELO(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = int(param1.elo);
         var _loc4_:int = int(param2.elo);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortGuildMembersRank(param1:UserData, param2:UserData) : Number
      {
         var _loc3_:int = param1.getGuildRank();
         var _loc4_:int = param2.getGuildRank();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortGuildMembersWeeklyScore(param1:UserData, param2:UserData) : Number
      {
         var _loc3_:Number = param1.getGuildWeeklyTotalScore();
         var _loc4_:Number = param2.getGuildWeeklyTotalScore();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortGuildMembersTotalScore(param1:UserData, param2:UserData) : Number
      {
         var _loc3_:Number = param1.getGuildGlobalTotalScore();
         var _loc4_:Number = param2.getGuildGlobalTotalScore();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortGuildsByLastWeekTotalScore(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = int(param1.lastWeekTotalScore);
         var _loc4_:int = int(param2.lastWeekTotalScore);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortGuildsByWeekTotalScore(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = int(param1.weeklyTotalScore);
         var _loc4_:int = int(param2.weeklyTotalScore);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortGuildsByLastActivityDateMS(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = int(param1.lastActivityDateMS);
         var _loc4_:int = int(param2.lastActivityDateMS);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortRaidPlayersByDamage(param1:FSUserPlayedRaidSlot, param2:FSUserPlayedRaidSlot) : Number
      {
         var _loc3_:int = param1.getDamage();
         var _loc4_:int = param2.getDamage();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortBidSlotsByPrice(param1:FSBidSlot, param2:FSBidSlot) : Number
      {
         var _loc3_:int = param1.getBid().getBid();
         var _loc4_:int = param2.getBid().getBid();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortJobDefByIndex(param1:JobDef, param2:JobDef) : Number
      {
         var _loc3_:int = param1.getIndex();
         var _loc4_:int = param2.getIndex();
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortDefByIndex(param1:Def, param2:Def) : Number
      {
         var _loc3_:int = param1.getIndex();
         var _loc4_:int = param2.getIndex();
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortDefByShopPosition(param1:Def, param2:Def) : Number
      {
         var _loc3_:int = param1.getShopPosition();
         var _loc4_:int = param2.getShopPosition();
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortBidsByPrice(param1:Bid, param2:Bid) : Number
      {
         var _loc3_:int = param1.getBid();
         var _loc4_:int = param2.getBid();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortAuctionsByTime(param1:Auction, param2:Auction) : Number
      {
         var _loc3_:Auction = param1;
         var _loc4_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidRoundInBiddersArr(_loc3_.getAuctionId()) != -1;
         var _loc5_:Auction = param2;
         var _loc6_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidRoundInBiddersArr(_loc5_.getAuctionId()) != -1;
         if(_loc4_ && _loc6_ || !_loc4_ && !_loc6_)
         {
            if(_loc3_.getAuctionTime() > _loc5_.getAuctionTime())
            {
               return 1;
            }
            if(_loc3_.getAuctionTime() < _loc5_.getAuctionTime())
            {
               return -1;
            }
         }
         else
         {
            if(_loc4_ && !_loc6_)
            {
               return -1;
            }
            if(!_loc4_ && _loc6_)
            {
               return 1;
            }
         }
         return 0;
      }
      
      public static function sortSlotJobSkinByIndex(param1:JobSkinSlot, param2:JobSkinSlot) : Number
      {
         var _loc3_:int = param1.getSkinIndex();
         var _loc4_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(param1.getSkinSku());
         var _loc5_:int = param2.getSkinIndex();
         var _loc6_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(param2.getSkinSku());
         if(_loc4_ && _loc6_ || !_loc4_ && !_loc6_)
         {
            if(_loc3_ < _loc5_)
            {
               return 1;
            }
            if(_loc3_ > _loc5_)
            {
               return -1;
            }
         }
         else
         {
            if(!_loc4_ && _loc6_)
            {
               return 1;
            }
            if(_loc4_ && !_loc6_)
            {
               return -1;
            }
         }
         return 0;
      }
      
      public static function sortSlotAuctionsByTime(param1:FSAuctionSlot, param2:FSAuctionSlot) : Number
      {
         var _loc3_:Auction = param1.getAuction();
         var _loc4_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidRoundInBiddersArr(_loc3_.getAuctionId()) != -1;
         var _loc5_:Auction = param2.getAuction();
         var _loc6_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().getLastBidRoundInBiddersArr(_loc5_.getAuctionId()) != -1;
         if(_loc4_ && _loc6_ || !_loc4_ && !_loc6_ || !_loc4_ && _loc6_)
         {
            if(_loc3_.getAuctionTime() > _loc5_.getAuctionTime())
            {
               return 1;
            }
            if(_loc3_.getAuctionTime() < _loc5_.getAuctionTime())
            {
               return -1;
            }
         }
         else if(_loc4_ && !_loc6_)
         {
            if(_loc3_.getAuctionTime() > _loc5_.getAuctionTime())
            {
               return -1;
            }
            if(_loc3_.getAuctionTime() < _loc5_.getAuctionTime())
            {
               return 1;
            }
         }
         return 0;
      }
      
      public static function sortObjectArrByDungeonsWon(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = int(param1.dungeonsWon);
         var _loc4_:int = int(param2.dungeonsWon);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortCardsArrByValue(param1:FSCard, param2:FSCard) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:CardDef = param1.getCardDef();
         var _loc4_:int = _loc3_.getCardValue();
         _loc3_ = param2.getCardDef();
         var _loc5_:int = _loc3_.getCardValue();
         if(_loc4_ > _loc5_)
         {
            return -1;
         }
         if(_loc4_ < _loc5_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortCardsArrByAbilitiesAmount(param1:FSCard, param2:FSCard) : Number
      {
         var _loc3_:int = param1.getAbilities() ? int(param1.getAbilities().length) : 0;
         var _loc4_:int = param2.getAbilities() ? int(param2.getAbilities().length) : 0;
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortCardsArrByTier(param1:FSCard, param2:FSCard) : Number
      {
         var _loc3_:int = param1.getTier();
         var _loc4_:int = param1.getTier();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortCardsArrByDefense(param1:FSCard, param2:FSCard) : Number
      {
         var _loc3_:int = param1.getDefense();
         var _loc4_:int = param2.getDefense();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortCardsArrByAbilityPower(param1:FSCard, param2:FSCard) : Number
      {
         var _loc3_:Boolean = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_UNBLOCKABLE) != null || param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_PERMANENTUNBLOCKABLE) != null;
         var _loc4_:Boolean = param1.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_BRUTALITY) != null;
         var _loc5_:Boolean = FSUnit(param1).isSubmarineUnit();
         var _loc6_:Boolean = FSUnit(param1).isAirUnit();
         var _loc7_:Boolean = param2.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_UNBLOCKABLE) != null || param2.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_PERMANENTUNBLOCKABLE) != null;
         var _loc8_:Boolean = param2.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_BRUTALITY) != null;
         var _loc9_:Boolean = FSUnit(param2).isSubmarineUnit();
         var _loc10_:Boolean = FSUnit(param2).isAirUnit();
         var _loc11_:int = _loc3_ ? 1 : 99;
         var _loc12_:int = _loc4_ ? 2 : 99;
         var _loc13_:int = _loc5_ ? 3 : 99;
         var _loc14_:int = _loc6_ ? 4 : 99;
         var _loc15_:int = _loc7_ ? 1 : 99;
         var _loc16_:int = _loc8_ ? 2 : 99;
         var _loc17_:int = _loc9_ ? 3 : 99;
         var _loc18_:int = _loc10_ ? 4 : 99;
         var _loc19_:int = Math.min(_loc11_,_loc12_,_loc13_,_loc14_);
         var _loc20_:int = Math.min(_loc15_,_loc16_,_loc17_,_loc18_);
         if(_loc19_ > _loc20_)
         {
            return 1;
         }
         if(_loc19_ < _loc20_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortCardsArrByTriggerOnPromoteAbilities(param1:FSCard, param2:FSCard) : Number
      {
         var _loc3_:Boolean = param1.hasTriggerOnPromoteAbilities();
         var _loc4_:Boolean = param2.hasTriggerOnPromoteAbilities();
         if(_loc3_)
         {
            return -1;
         }
         if(_loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortCardsArrByBattlefieldPosition(param1:FSCard, param2:FSCard) : Number
      {
         if(!param1.isOnSupportLane() || !param2.isOnSupportLane())
         {
            if(!param1.isOnSupportLane() && !param2.isOnSupportLane())
            {
               return 0;
            }
            if(param1.isOnSupportLane())
            {
               return 1;
            }
            if(param2.isOnSupportLane())
            {
               return -1;
            }
         }
         return 0;
      }
      
      public static function sortCardsArrByLowerHP(param1:FSCard, param2:FSCard) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:int = param1.getDefense();
         var _loc4_:int = param2.getDefense();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortCardsSocketArrByValue(param1:FSCardSocket, param2:FSCardSocket) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:CardDef = param1.getParentCard() ? param1.getParentCard().getCardDef() : null;
         var _loc4_:int = _loc3_ ? _loc3_.getCardValue() : 0;
         _loc3_ = param2.getParentCard() ? param2.getParentCard().getCardDef() : null;
         var _loc5_:int = _loc3_ ? _loc3_.getCardValue() : 0;
         if(_loc4_ > _loc5_)
         {
            return -1;
         }
         if(_loc4_ < _loc5_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortAlphabetically(param1:String, param2:String) : Number
      {
         if(param1 < param2)
         {
            return -1;
         }
         if(param1 > param2)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortBackersBySurname(param1:String, param2:String) : Number
      {
         var _loc3_:KickstarterBackerDefMng = InstanceMng.getKickstarterBackersDefMng();
         var _loc4_:KickstarterBackerDef = KickstarterBackerDef(_loc3_.getDefBySku(param1.split(":")[0]));
         var _loc5_:String = _loc4_.getKickSurname();
         _loc4_ = KickstarterBackerDef(_loc3_.getDefBySku(param2.split(":")[0]));
         var _loc6_:String = _loc4_.getKickSurname();
         if(_loc5_ < _loc6_)
         {
            return -1;
         }
         if(_loc5_ > _loc6_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortCardsByType(param1:FSCard, param2:FSCard) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:int = param1.getType();
         var _loc4_:int = param2.getType();
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortCardsDefsByType(param1:CardDef, param2:CardDef) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:int = param1.getType();
         var _loc4_:int = param2.getType();
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortPvPRewardByMinRating(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = int(param1["minRating"]);
         var _loc4_:int = int(param2["minRating"]);
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function sortPvPRewardByPosition(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = int(param1["position"]);
         var _loc4_:int = int(param2["position"]);
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortCardsDefsBySubcategory(param1:CardDef, param2:CardDef) : Number
      {
         if(mCardDefMng == null)
         {
            mCardDefMng = InstanceMng.getCardsDefMng();
         }
         var _loc3_:Array = param1.getSubCategorySku();
         var _loc4_:Array = param2.getSubCategorySku();
         var _loc5_:String = Boolean(_loc3_) && _loc3_.length > 0 ? _loc3_[0] : "";
         var _loc6_:String = Boolean(_loc4_) && _loc4_.length > 0 ? _loc4_[0] : "";
         var _loc7_:SubCategoryDef = _loc5_ ? SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc5_)) : null;
         var _loc8_:SubCategoryDef = _loc6_ ? SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc6_)) : null;
         var _loc9_:int = _loc7_ ? _loc7_.getIndex() : 0;
         var _loc10_:int = _loc8_ ? _loc8_.getIndex() : 0;
         if(_loc9_ > _loc10_)
         {
            return 1;
         }
         if(_loc9_ < _loc10_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function getAllUnitsCatalog(param1:Boolean = false) : Dictionary
      {
         var _loc5_:int = 0;
         var _loc6_:CardDef = null;
         var _loc2_:Dictionary = InstanceMng.getUnitsDefMng().getAllCardsDefs(null,1,null,CategoriesDefMng.CATEGORY_UNITS,null,null,param1);
         var _loc3_:Array = DictionaryUtils.getKeys(_loc2_);
         var _loc4_:Dictionary = new Dictionary(true);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_[_loc5_]));
            if(_loc6_.getIsVisible())
            {
               _loc4_[_loc3_[_loc5_]] = 1;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function getAllAttachmentsCatalog(param1:Boolean = false) : Dictionary
      {
         var _loc5_:int = 0;
         var _loc6_:CardDef = null;
         var _loc2_:Dictionary = InstanceMng.getUnitsDefMng().getAllCardsDefs(null,1,null,CategoriesDefMng.CATEGORY_ATTACHMENTS,null,null,param1);
         var _loc3_:Array = DictionaryUtils.getKeys(_loc2_);
         var _loc4_:Dictionary = new Dictionary(true);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_[_loc5_]));
            if(_loc6_.getIsVisible())
            {
               _loc4_[_loc3_[_loc5_]] = 1;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function getAllActionsCatalog(param1:Boolean = false) : Dictionary
      {
         var _loc5_:int = 0;
         var _loc6_:CardDef = null;
         var _loc2_:Dictionary = InstanceMng.getUnitsDefMng().getAllCardsDefs(null,1,null,CategoriesDefMng.CATEGORY_ACTIONS,null,null,param1);
         var _loc3_:Array = DictionaryUtils.getKeys(_loc2_);
         var _loc4_:Dictionary = new Dictionary(true);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_[_loc5_]));
            if(_loc6_.getIsVisible())
            {
               _loc4_[_loc3_[_loc5_]] = 1;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function getAllPowersCatalog(param1:Boolean = false) : Dictionary
      {
         var _loc5_:int = 0;
         var _loc6_:CardDef = null;
         var _loc2_:Dictionary = InstanceMng.getPowerDefMng().getAllCardsDefs(null,1,null,CategoriesDefMng.CATEGORY_POWERS,null,null,param1);
         var _loc3_:Array = DictionaryUtils.getKeys(_loc2_);
         var _loc4_:Dictionary = new Dictionary(true);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc3_[_loc5_]));
            if(_loc6_.getIsVisible())
            {
               _loc4_[_loc3_[_loc5_]] = 1;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function sortBattlePassQuestSlotsByIndex(param1:BattlePassQuestSlot, param2:BattlePassQuestSlot) : Number
      {
         var _loc3_:int = param1.getQuest().getDef().getBattlePassIndex();
         var _loc4_:int = param2.getQuest().getDef().getBattlePassIndex();
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortBattlePassQuestDefsByIndex(param1:QuestDef, param2:QuestDef) : Number
      {
         var _loc3_:int = param1.getBattlePassIndex();
         var _loc4_:int = param2.getBattlePassIndex();
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortSkinsByIndex(param1:HeroCharacterDef, param2:HeroCharacterDef) : Number
      {
         var _loc3_:int = param1.getIndex();
         var _loc4_:int = param2.getIndex();
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public static function sortSkinsByIsAvailable(param1:HeroCharacterDef, param2:HeroCharacterDef) : Number
      {
         var _loc3_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(param1.getSku());
         var _loc4_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(param2.getSku());
         if(_loc3_ && !_loc4_)
         {
            return -1;
         }
         if(!_loc3_ && _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function getDeckFamilyIDMaxReached(param1:CardDef, param2:Dictionary, param3:Array = null, param4:int = 1) : Boolean
      {
         var _loc6_:Boolean = false;
         var _loc7_:RarityDef = null;
         var _loc8_:int = 0;
         var _loc9_:CardDef = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:RarityDef = null;
         var _loc5_:int = param1.getDeckFamilyID();
         if(_loc5_ == 0)
         {
            _loc6_ = false;
         }
         else
         {
            param3 = param3 != null ? param3 : DictionaryUtils.getKeys(param2);
            _loc7_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(param1.getCardRarity()));
            _loc10_ = 0;
            _loc12_ = Config.getConfig().getMaxCardsByDeckFamilyId();
            _loc13_ = 0;
            if(Boolean(param3) && param3.length > 0)
            {
               _loc8_ = 0;
               while(_loc8_ < param3.length)
               {
                  _loc11_ = int(param2[param3[_loc8_]]);
                  _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param3[_loc8_]));
                  if(_loc9_)
                  {
                     if(_loc9_.getDeckFamilyID() == _loc5_)
                     {
                        _loc10_ += _loc11_;
                        _loc14_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc9_.getCardRarity()));
                        if(_loc14_.getMaxAmountPerDeck() == _loc7_.getMaxAmountPerDeck())
                        {
                           _loc13_++;
                        }
                     }
                  }
                  _loc8_++;
               }
            }
            _loc6_ = _loc10_ + param4 > _loc12_;
            _loc6_ = (_loc6_) || _loc13_ + param4 > _loc7_.getMaxAmountPerDeck();
            if(_loc6_)
            {
               FSDebug.debugTrace(");");
            }
         }
         return _loc6_;
      }
      
      public static function catalogHasLeader(param1:Dictionary) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:CardDef = null;
         var _loc2_:Array = DictionaryUtils.getKeys(param1);
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc2_[_loc3_]));
               if((Boolean(_loc4_)) && _loc4_.isLeader())
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      public static function getCardAmountInCatalog(param1:String, param2:Dictionary) : int
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc3_:Array = DictionaryUtils.getKeys(param2);
         var _loc6_:int = 0;
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_ == param1)
               {
                  _loc6_++;
               }
               _loc4_++;
            }
         }
         return _loc6_;
      }
      
      public static function arrayToStringVector(param1:Array) : Vector.<String>
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:Vector.<String> = new Vector.<String>();
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = String(param1[_loc3_]).split(":")[0];
            _loc6_ = int(String(param1[_loc3_]).split(":")[1]);
            if(Boolean(_loc5_) && Boolean(_loc5_ != "") && _loc6_ > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc6_)
               {
                  _loc2_.push(_loc5_);
                  _loc4_++;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function arrayToDictionary(param1:Array) : Dictionary
      {
         var _loc2_:Dictionary = null;
         var _loc3_:int = 0;
         if(param1 != null && param1.length > 0)
         {
            if(_loc2_ == null)
            {
               _loc2_ = new Dictionary(true);
            }
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_[param1[_loc3_]] = true;
               _loc3_++;
            }
         }
         return _loc2_;
      }
   }
}

