package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.CategoryDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.AttachmentXL;
   import com.fs.tcgengine.view.cards.DeckBuilderCard;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSActionXL;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.cards.FSCardPreviewXL;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.cards.FSInfoCardXL;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.cards.FSPowerXL;
   import com.fs.tcgengine.view.cards.FSShopInfoCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.cards.InfoCard;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   
   public class FSCardsMng
   {
      
      private static var mCardsPool:Dictionary;
      
      private static const POOL_UNITS:String = "POOL_UNITS";
      
      private static const POOL_ATTACHMENT:String = "POOL_ATTACHMENT";
      
      private static const POOL_ACTION:String = "POOL_ACTION";
      
      private static const POOL_POWER:String = "POOL_POWER";
      
      private static const POOL_CARDPREVIEW:String = "POOL_CARDPREVIEW";
      
      private static const POOL_INFOCARD_XL:String = "POOL_INFOCARD_XL";
      
      private static const POOL_CARD_XL:String = "POOL_CARD_XL";
      
      private static const POOL_ATTACHMENT_XL:String = "POOL_ATTACHMENT_XL";
      
      private static const POOL_ACTION_XL:String = "POOL_ACTION_XL";
      
      private static const POOL_CARDPREVIEW_XL:String = "POOL_CARDPREVIEW_XL";
      
      private static const POOL_POWER_XL:String = "POOL_POWER_XL";
      
      private static const POOL_DECKBUILDERCARD:String = "POOL_DECKBUILDERCARD";
      
      private static const POOL_SHOPINFOCARD:String = "POOL_SHOPINFOCARD";
      
      public function FSCardsMng()
      {
         super();
      }
      
      public static function addCardToPool(param1:*, param2:Boolean) : void
      {
         if(!Config.USE_CARD_POOLING)
         {
            return;
         }
         if(param1 is FSCard)
         {
            FSCard(param1).reset();
         }
         var _loc3_:String = getPoolTypeByCard(param1,param2);
         if(mCardsPool == null)
         {
            mCardsPool = new Dictionary(true);
         }
         if(mCardsPool[_loc3_] == null)
         {
            mCardsPool[_loc3_] = new Vector.<*>();
         }
         Vector.<*>(mCardsPool[_loc3_]).push(param1);
         printMemoryUsed("[ADD]: ");
      }
      
      public static function getCardFromPool(param1:String, param2:String = "") : *
      {
         var _loc3_:* = null;
         if(mCardsPool != null && mCardsPool[param1] != null)
         {
            _loc3_ = mCardsPool[param1].pop();
         }
         if(_loc3_ == null)
         {
            switch(param1)
            {
               case POOL_UNITS:
                  _loc3_ = new FSUnit(param2);
                  break;
               case POOL_ATTACHMENT:
                  _loc3_ = new FSAttachment(param2);
                  break;
               case POOL_ACTION:
                  _loc3_ = new FSAction(param2);
                  break;
               case POOL_POWER:
                  _loc3_ = new FSPower(param2);
                  break;
               case POOL_CARDPREVIEW:
               case POOL_INFOCARD_XL:
               case POOL_CARD_XL:
               case POOL_ATTACHMENT_XL:
               case POOL_ACTION_XL:
               case POOL_CARDPREVIEW_XL:
               case POOL_POWER_XL:
               case POOL_DECKBUILDERCARD:
               case POOL_SHOPINFOCARD:
            }
         }
         if(_loc3_ is FSCard && Config.USE_CARD_POOLING)
         {
            FSCard(_loc3_).reset(param2);
         }
         printMemoryUsed("[GET]: ");
         return _loc3_;
      }
      
      private static function getPoolTypeByCard(param1:*, param2:Boolean) : String
      {
         var _loc3_:String = "";
         var _loc4_:Boolean = param1 is FSCard ? Boolean(param1.isInfoCard()) : false;
         if((_loc4_) && param2 || param1 is FSInfoCardXL)
         {
            return POOL_INFOCARD_XL;
         }
         if(param1 is InfoCard)
         {
            if(param1 is DeckBuilderCard)
            {
               _loc3_ = POOL_DECKBUILDERCARD;
            }
            else if(param1 is FSShopInfoCard)
            {
               _loc3_ = POOL_SHOPINFOCARD;
            }
         }
         else if(param1 is FSUnit)
         {
            _loc3_ = param2 ? POOL_CARD_XL : POOL_UNITS;
         }
         else if(param1 is FSAttachment)
         {
            _loc3_ = param2 ? POOL_ATTACHMENT_XL : POOL_ATTACHMENT;
         }
         else if(param1 is FSAction)
         {
            _loc3_ = param2 ? POOL_ACTION_XL : POOL_ACTION;
         }
         else if(param1 is FSPower)
         {
            _loc3_ = param2 ? POOL_POWER_XL : POOL_POWER;
         }
         else if(param1 is FSCardPreview)
         {
            _loc3_ = param2 ? POOL_CARDPREVIEW_XL : POOL_CARDPREVIEW;
         }
         return _loc3_;
      }
      
      public static function printMemoryUsed(param1:String) : void
      {
         var _loc2_:Vector.<*> = null;
         var _loc3_:int = 0;
         if(mCardsPool)
         {
            _loc3_ = 0;
            for each(_loc2_ in mCardsPool)
            {
               _loc3_ += _loc2_ ? _loc2_.length : 0;
            }
            FSDebug.debugTrace("Cards in MEM after op: " + param1 + _loc3_);
         }
      }
      
      public function createCard(param1:String) : FSCard
      {
         var _loc2_:FSCard = null;
         var _loc5_:int = 0;
         var _loc6_:CategoryDef = null;
         var _loc3_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         var _loc4_:String = _loc3_.getCategorySku();
         if(_loc4_ != null)
         {
            _loc6_ = CategoryDef(InstanceMng.getCategoriesDefMng().getDefBySku(_loc4_));
            _loc5_ = _loc6_ != null ? _loc6_.getIndex() : 0;
         }
         switch(_loc5_)
         {
            case FSCard.TYPE_UNIT:
               _loc2_ = Config.USE_CARD_POOLING ? getCardFromPool(POOL_UNITS,param1) : new FSUnit(param1);
               break;
            case FSCard.TYPE_ATTACHMENT:
               _loc2_ = Config.USE_CARD_POOLING ? getCardFromPool(POOL_ATTACHMENT,param1) : new FSAttachment(param1);
               break;
            case FSCard.TYPE_ACTION:
               _loc2_ = Config.USE_CARD_POOLING ? getCardFromPool(POOL_ACTION,param1) : new FSAction(param1);
               break;
            case FSCard.TYPE_POWER:
               _loc2_ = Config.USE_CARD_POOLING ? getCardFromPool(POOL_POWER,param1) : new FSPower(param1);
         }
         return _loc2_;
      }
      
      public function createDeckBuilderCard(param1:FSCard, param2:int, param3:Boolean = true, param4:Boolean = false) : void
      {
      }
      
      public function createCardPreview(param1:String) : FSCardPreview
      {
         return new FSCardPreview(param1);
      }
      
      public function createZoomedCard(param1:FSCard) : FSCardXL
      {
         var _loc2_:FSCardXL = null;
         var _loc3_:Boolean = param1.isInfoCard();
         if(param1 is FSUnit)
         {
            _loc2_ = _loc3_ ? new FSInfoCardXL(param1) : new FSCardXL(param1);
         }
         else if(param1 is FSAttachment)
         {
            _loc2_ = _loc3_ ? new FSInfoCardXL(param1) : new AttachmentXL(param1);
         }
         else if(param1 is FSAction)
         {
            _loc2_ = _loc3_ ? new FSInfoCardXL(param1) : new FSActionXL(param1);
         }
         else if(param1 is FSCardPreview)
         {
            _loc2_ = _loc3_ ? new FSInfoCardXL(param1) : new FSCardPreviewXL(param1);
         }
         else if(param1 is FSPower)
         {
            _loc2_ = new FSPowerXL(param1);
         }
         return _loc2_;
      }
      
      public function createAbilityIcon(param1:FSCard, param2:AbilityDef, param3:int, param4:Boolean = false) : Boolean
      {
         var _loc6_:FSImage = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc5_:Boolean = false;
         if(param2 != null)
         {
            if(param2 != null && param1 != null && param1.getCardDef() != null)
            {
               _loc7_ = param2.getBGImageName();
               if(_loc7_ != "")
               {
                  _loc5_ = true;
                  _loc6_ = new FSImage(Root.assets.getTexture(_loc7_),false);
                  _loc8_ = param2.getFactionSku();
                  _loc9_ = _loc8_ == null || _loc8_ == "" || _loc8_ == param1.getCardDef().getFactionSku();
                  _loc6_.alpha = _loc9_ ? 1 : 0.35;
                  if(param4 && _loc9_)
                  {
                     SpecialFX.tweenToColor(_loc6_,0,61440,0);
                  }
                  this.resetAbilityIconPosition(param1,_loc6_,param3,param4);
                  if(param1.getBattleSubcomponentsContainer())
                  {
                     param1.getBattleSubcomponentsContainer().addChild(_loc6_);
                  }
                  param1.addAbilityIconImage(_loc6_,param2);
               }
            }
         }
         if(Config.getConfig().cardShowsOnlyMainAbility() && param1 != null)
         {
            _loc6_ = param1.getAbilityIconImage(param2);
            this.resetAbilityIconPosition(param1,_loc6_,param3,param4);
         }
         return _loc5_;
      }
      
      public function resetAbilityIconPosition(param1:FSCard, param2:FSImage, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         _loc5_ = Config.getConfig().cardsGetMaxAbsIconsPerCol();
         if(Boolean(param2) && Boolean(param1))
         {
            if(Config.getConfig().cardShowsOnlyMainAbility())
            {
               param2.alignPivot();
               param2.x = param1.getFrameBG() ? param1.getFrameBG().width / 2 : param1.width / 2;
               param2.y = param1.getFrameBG() ? param1.getFrameBG().height - param2.height / 2 : param1.height - param2.height / 2;
            }
            else
            {
               param2.alignPivot();
               this.assignScaleToAbilityIcon(param2,param1);
               _loc6_ = param1.getType() != FSCard.TYPE_ACTION && Boolean(param1.getDamageImage()) ? param1.getDamageImage().height : param2.height * 0.75;
               _loc6_ = _loc6_ + param2.height / 2;
               if(param1.getFrameBG())
               {
                  param2.x = param1.getFrameBG().x + param1.getFrameBG().width * 0.14;
                  param2.y = param1.getFrameBG().y + param1.getFrameBG().height - _loc6_ - param2.height * param3;
                  if(param3 >= _loc5_)
                  {
                     param3 -= _loc5_;
                     param2.x += param2.width * 1.05;
                     param2.y = param1.getFrameBG().y + param1.getFrameBG().height - _loc6_ - param2.height * param3;
                  }
               }
               else if(param1.getFactionFrameBG())
               {
                  param2.x = param1.getFactionFrameBG().x + param1.getFactionFrameBG().width * 0.16;
                  param2.y = param1.getFactionFrameBG().y + param1.getFactionFrameBG().height - _loc6_ - param2.height * param3;
                  param2.y -= param3 > 0 && param1 is FSCardXL ? param2.height / 2 : 0;
                  if(param3 >= _loc5_)
                  {
                     param3 -= _loc5_;
                     param2.x += param2.width * 1.05;
                     param2.y = param1.getFactionFrameBG().y + param1.getFactionFrameBG().height - _loc6_ - param2.height * param3;
                  }
               }
            }
         }
      }
      
      public function assignScaleToAbilityIcon(param1:FSImage, param2:FSCard) : void
      {
         var _loc3_:Boolean = false;
         if(Boolean(param1) && Boolean(param2))
         {
            _loc3_ = !Utils.isTablet() || Utils.isAndroid() || Utils.isDesktop() || param2 is FSCardXL;
            param1.scale = Config.getConfig().getAbScaleFactor();
            param1.scaleX *= _loc3_ ? 1.4 : 1;
            param1.scaleY *= _loc3_ ? 1.4 : 1;
            if(param2 is FSCardXL)
            {
               param1.scaleX *= _loc3_ ? 1.4 : 1;
               param1.scaleY *= _loc3_ ? 1.4 : 1;
            }
         }
      }
      
      public function checkIfBGImageUnloadableByCardDef(param1:CardDef, param2:Dictionary, param3:FSCard = null) : Boolean
      {
         var _loc5_:FSCard = null;
         var _loc6_:String = null;
         var _loc7_:CardDef = null;
         var _loc8_:Vector.<String> = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Vector.<String> = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:FSAttachment = null;
         var _loc15_:Vector.<FSAttachment> = null;
         var _loc4_:Boolean = true;
         if(param1 != null)
         {
            if(param1)
            {
               _loc6_ = param1.hasAnimatedBG() ? param1.getAnimatedBG() : param1.getBGImageName();
               for each(_loc5_ in param2)
               {
                  _loc7_ = _loc5_.getCardDef();
                  if(_loc7_ != null)
                  {
                     _loc8_ = this.getCardTiersImageNames(_loc7_);
                     if(_loc8_ != null)
                     {
                        _loc10_ = 0;
                        while(_loc10_ < _loc8_.length)
                        {
                           _loc9_ = _loc8_[_loc10_];
                           if(_loc9_ == _loc6_)
                           {
                              return false;
                           }
                           if(_loc5_.getFightingWithCard() != null && _loc5_.getFightingWithCard().isAlive() && _loc5_.getFightingWithCard().getCardDef().getBGImageName() == _loc6_)
                           {
                              return false;
                           }
                           if(_loc5_.isUnit() && !_loc5_.isZoomedIn() && _loc5_.isAlive())
                           {
                              _loc15_ = null;
                              _loc15_ = _loc5_.getAttachments();
                              if(_loc15_)
                              {
                                 for each(_loc14_ in _loc15_)
                                 {
                                    if(param3 == null || param3 != null && _loc14_ != param3)
                                    {
                                       if(_loc14_.getCardDef() != null)
                                       {
                                          _loc11_ = this.getCardTiersImageNames(_loc14_.getCardDef());
                                          if(_loc11_ != null)
                                          {
                                             _loc13_ = 0;
                                             while(_loc13_ < _loc11_.length)
                                             {
                                                _loc12_ = _loc11_[_loc13_];
                                                if(_loc12_ == _loc6_)
                                                {
                                                   return false;
                                                }
                                                _loc13_++;
                                             }
                                          }
                                       }
                                    }
                                    else
                                    {
                                       FSDebug.debugTrace("Same card");
                                    }
                                 }
                              }
                           }
                           _loc10_++;
                        }
                     }
                  }
                  else if(Capabilities.isDebugger)
                  {
                     throw new Error("[FS] Attention - A catalog card without CardDef has been found");
                  }
               }
            }
            else
            {
               FSDebug.debugTrace("No card def found when removing the card");
            }
         }
         return _loc4_;
      }
      
      public function checkIfSoundUnloadableByCardDef(param1:CardDef, param2:Dictionary, param3:FSCard = null, param4:String = "") : Boolean
      {
         var _loc6_:FSCard = null;
         var _loc7_:CardDef = null;
         var _loc8_:Vector.<String> = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Vector.<String> = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:FSAttachment = null;
         var _loc15_:Vector.<FSAttachment> = null;
         var _loc5_:Boolean = true;
         if(param1 != null)
         {
            if(param1)
            {
               for each(_loc6_ in param2)
               {
                  if(_loc6_ != param3)
                  {
                     _loc7_ = _loc6_.getCardDef();
                     if(_loc7_ != null)
                     {
                        _loc8_ = InstanceMng.getCardsMng().getCardAllPossibleSounds(_loc6_);
                        if(_loc8_ != null)
                        {
                           _loc10_ = 0;
                           while(_loc10_ < _loc8_.length)
                           {
                              _loc9_ = _loc8_[_loc10_];
                              if(_loc9_ == param4)
                              {
                                 return false;
                              }
                              if(_loc6_.getFightingWithCard() != null && _loc6_.getFightingWithCard().isAlive() && _loc6_.getFightingWithCard().getCardDef().getBGImageName() == param4)
                              {
                                 return false;
                              }
                              if(_loc6_.isUnit() && !_loc6_.isZoomedIn() && _loc6_.isAlive())
                              {
                                 _loc15_ = null;
                                 _loc15_ = _loc6_.getAttachments();
                                 if(_loc15_)
                                 {
                                    for each(_loc14_ in _loc15_)
                                    {
                                       if(param3 == null || param3 != null && _loc14_ != param3)
                                       {
                                          if(_loc14_.getCardDef() != null)
                                          {
                                             _loc11_ = InstanceMng.getCardsMng().getCardAllPossibleSounds(_loc14_);
                                             if(_loc11_ != null)
                                             {
                                                _loc13_ = 0;
                                                while(_loc13_ < _loc11_.length)
                                                {
                                                   _loc12_ = _loc11_[_loc13_];
                                                   if(_loc12_ == param4)
                                                   {
                                                      return false;
                                                   }
                                                   _loc13_++;
                                                }
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                              _loc10_++;
                           }
                        }
                     }
                     else if(Capabilities.isDebugger)
                     {
                        throw new Error("[FS] Attention - A catalog card without CardDef has been found");
                     }
                  }
               }
            }
            else
            {
               FSDebug.debugTrace("No card def found when removing the card");
            }
         }
         return _loc5_;
      }
      
      public function getCardTiersOnPlaySoundnames(param1:CardDef) : Vector.<String>
      {
         var _loc3_:Boolean = false;
         var _loc4_:CardDef = null;
         var _loc5_:CardDef = null;
         var _loc6_:CardDef = null;
         var _loc2_:Vector.<String> = null;
         if(Boolean(param1) && param1 is UnitDef)
         {
            _loc3_ = true;
            _loc6_ = param1;
            while(_loc3_)
            {
               _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_.getPreviousUpgradeSku()));
               _loc3_ = _loc5_ != null;
               if(_loc5_ != null)
               {
                  _loc2_ = Utils.addStringToStringsVector(_loc2_,UnitDef(_loc5_).getOnPlaySound());
                  if(_loc5_ is UnitDef)
                  {
                     _loc2_ = Utils.addStringToStringsVector(_loc2_,UnitDef(_loc5_).getDamageAudioName());
                  }
                  _loc6_ = _loc5_;
               }
            }
            _loc3_ = true;
            _loc6_ = param1;
            _loc2_ = Utils.addStringToStringsVector(_loc2_,UnitDef(param1).getOnPlaySound());
            if(param1 is UnitDef)
            {
               _loc2_ = Utils.addStringToStringsVector(_loc2_,UnitDef(param1).getDamageAudioName());
            }
            while(_loc3_)
            {
               _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc6_.getUpgradeSku()));
               _loc3_ = _loc4_ != null;
               if(_loc4_ != null)
               {
                  _loc2_ = Utils.addStringToStringsVector(_loc2_,UnitDef(_loc4_).getOnPlaySound());
                  if(_loc4_ is UnitDef)
                  {
                     _loc2_ = Utils.addStringToStringsVector(_loc2_,UnitDef(_loc4_).getDamageAudioName());
                  }
                  _loc6_ = _loc4_;
               }
            }
         }
         return _loc2_;
      }
      
      public function getCardAllPossibleSounds(param1:FSCard, param2:CardDef = null) : Vector.<String>
      {
         var _loc4_:Vector.<Ability> = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc3_:Vector.<String> = null;
         if(Boolean(param1) && Boolean(param1.getCardDef()))
         {
            _loc3_ = InstanceMng.getSoundFXMng().getAllRandomSoundNames(param1);
            _loc3_ = this.getCardTiersOnPlaySoundnames(param1.getCardDef());
            _loc4_ = param1.getAbilities();
            if(_loc4_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc6_ = _loc4_[_loc5_].getAbilityDef() ? _loc4_[_loc5_].getAbilityDef().getSoundName() : "";
                  _loc3_ = Utils.addStringToStringsVector(_loc3_,_loc6_);
                  _loc5_++;
               }
            }
         }
         else if(param2 != null)
         {
            _loc3_ = this.getCardTiersOnPlaySoundnames(param2);
            if(param2 is UnitDef)
            {
               _loc3_ = Utils.addStringToStringsVector(_loc3_,UnitDef(param2).getDamageAudioName());
            }
         }
         return _loc3_;
      }
      
      public function getCardTiersImageNames(param1:CardDef, param2:Boolean = false) : Vector.<String>
      {
         var _loc4_:Boolean = false;
         var _loc5_:CardDef = null;
         var _loc6_:CardDef = null;
         var _loc7_:String = null;
         var _loc8_:CardDef = null;
         var _loc3_:Vector.<String> = null;
         if(param1)
         {
            _loc4_ = true;
            _loc8_ = param1;
            while(_loc4_)
            {
               _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc8_.getPreviousUpgradeSku()));
               _loc4_ = _loc6_ != null;
               if(_loc6_ != null)
               {
                  _loc7_ = _loc6_.hasAnimatedBG() ? _loc6_.getAnimatedBG() : _loc6_.getBGImageName();
                  _loc3_ = Utils.addStringToStringsVector(_loc3_,_loc7_);
                  if(param2 && Config.getConfig().XLViewUsesXLTextures())
                  {
                     _loc3_ = Utils.addStringToStringsVector(_loc3_,_loc6_.getBGXLImageName());
                  }
                  _loc8_ = _loc6_;
               }
            }
            _loc4_ = true;
            _loc8_ = param1;
            _loc7_ = param1.hasAnimatedBG() ? param1.getAnimatedBG() : param1.getBGImageName();
            _loc3_ = Utils.addStringToStringsVector(_loc3_,_loc7_);
            if(param2 && Config.getConfig().XLViewUsesXLTextures())
            {
               _loc3_ = Utils.addStringToStringsVector(_loc3_,param1.getBGXLImageName());
            }
            while(_loc4_)
            {
               _loc5_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc8_.getUpgradeSku()));
               _loc4_ = _loc5_ != null;
               if(_loc5_ != null)
               {
                  _loc7_ = _loc5_.hasAnimatedBG() ? _loc5_.getAnimatedBG() : _loc5_.getBGImageName();
                  _loc3_ = Utils.addStringToStringsVector(_loc3_,_loc7_);
                  if(param2 && Config.getConfig().XLViewUsesXLTextures())
                  {
                     _loc3_ = Utils.addStringToStringsVector(_loc3_,_loc5_.getBGXLImageName());
                  }
                  _loc8_ = _loc5_;
               }
            }
         }
         return _loc3_;
      }
      
      public function onCardPreviewXLTouched(param1:FSCard, param2:CardDef) : void
      {
         var _loc3_:CardDef = null;
         var _loc4_:Screen = null;
         var _loc5_:FSCardPreview = null;
         if(param1 != null)
         {
            SpecialFX.zoomOut(param1);
            _loc3_ = Utils.getPreviousTierCardDef(param2.getSku());
            _loc4_ = InstanceMng.getCurrentScreen();
            if(_loc4_)
            {
               if(_loc3_ != null)
               {
                  if(_loc4_.getSelectedCard())
                  {
                     if(_loc3_.getTier() == _loc4_.getSelectedCard().getCardDef().getTier())
                     {
                        SpecialFX.zoomIn(_loc4_.getSelectedCard());
                     }
                     else
                     {
                        _loc5_ = new FSCardPreview(_loc3_.getSku());
                        SpecialFX.zoomIn(_loc5_);
                     }
                  }
               }
               else
               {
                  _loc4_.removeTranslucentBG(true);
               }
            }
         }
      }
   }
}

