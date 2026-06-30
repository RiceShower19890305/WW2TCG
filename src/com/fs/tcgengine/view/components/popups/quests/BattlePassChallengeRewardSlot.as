package com.fs.tcgengine.view.components.popups.quests
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.rules.QuestsDefMng;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.quests.PopupBattlePass;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class BattlePassChallengeRewardSlot extends Component implements FSModelUnloadableInterface
   {
      
      private var mNumberBG:FSImage;
      
      private var mNumberTextfield:FSTextfield;
      
      private var mRewardBG:FSImage;
      
      private var mRewardImage:*;
      
      private var mRewardImageLock:FSImage;
      
      private var mRewardAmountTextfield:FSTextfield;
      
      private var mPremiumRewardBG:FSImage;
      
      private var mPremiumRewardImage:*;
      
      private var mPremiumRewardImageLock:FSImage;
      
      private var mPremiumRewardAmountTextfield:FSTextfield;
      
      private var mBoxWidth:int;
      
      private var mBoxHeight:int;
      
      private var mQuestDef:QuestDef;
      
      private var mFixedWidth:int;
      
      private var mRewardInfoTName:String;
      
      private var mPremiumRewardInfoTName:String;
      
      public function BattlePassChallengeRewardSlot(param1:QuestDef, param2:int, param3:int)
      {
         super();
         this.mBoxWidth = param2;
         this.mBoxHeight = param3;
         this.mQuestDef = param1;
         this.mFixedWidth = this.mBoxWidth / PopupBattlePass.MAX_REWARDS_COLS;
         this.createComponent();
         Utils.alignComponentAndFixPosition(this);
      }
      
      private function createComponent() : void
      {
         this.createNumberSection();
         this.createRewardSection();
         this.createPremiumRewardSection();
         this.createInfoButton();
         this.setValidPass(this.ownerHasValidPass());
         this.loadExtraResources();
      }
      
      private function loadExtraResources() : void
      {
         var hasToLoadResources:Boolean = false;
         var hasToLoadPremiumResources:Boolean = false;
         var imageToLoadName:String = null;
         var imageToLoadNamePremium:String = null;
         var p:PortraitDef = null;
         var h:HeroCharacterDef = null;
         var notifyAssetsLoaded:Function = null;
         notifyAssetsLoaded = function():void
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
            if(hasToLoadResources)
            {
               FSImage(mRewardImage).texture = Root.assets.getTexture(imageToLoadName);
            }
            if(hasToLoadPremiumResources)
            {
               FSImage(mPremiumRewardImage).texture = Root.assets.getTexture(imageToLoadNamePremium);
            }
         };
         var rewardType:int = this.mQuestDef.getRewardType();
         var rewardTypePremium:int = this.mQuestDef.getRewardType(true);
         hasToLoadResources = false;
         hasToLoadPremiumResources = false;
         imageToLoadName = "";
         imageToLoadNamePremium = "";
         var alreadyLoaded:Boolean = false;
         if(rewardType == QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN)
         {
            hasToLoadResources = true;
            if(!Config.getConfig().hasSkins())
            {
               p = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(this.mQuestDef.getRewardSkinSku()));
               imageToLoadName = p ? p.getBGImageName() : "";
               if(!Config.smPortraitFramesInAtlas)
               {
                  if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
                  {
                     alreadyLoaded = PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).isExtraResourceLoaded(imageToLoadName) || Root.assets.getTexture(imageToLoadName) != null;
                  }
                  imageToLoadName = alreadyLoaded ? "" : imageToLoadName;
               }
               else
               {
                  notifyAssetsLoaded();
               }
            }
            else
            {
               h = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mQuestDef.getRewardSkinSku()));
               imageToLoadName = h ? h.getBGImageName() : "";
               if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
               {
                  alreadyLoaded = PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).isExtraResourceLoaded(imageToLoadName) || Root.assets.getTexture(imageToLoadName) != null;
               }
               imageToLoadName = alreadyLoaded ? "" : imageToLoadName;
            }
            if(imageToLoadName != "" && imageToLoadName != null)
            {
               this.loadSkinsResources(imageToLoadName);
            }
         }
         if(rewardTypePremium == QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN)
         {
            hasToLoadPremiumResources = true;
            if(!Config.getConfig().hasSkins())
            {
               p = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(this.mQuestDef.getRewardSkinSku(true)));
               imageToLoadNamePremium = p ? p.getBGImageName() : "";
               if(!Config.smPortraitFramesInAtlas)
               {
                  if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
                  {
                     alreadyLoaded = PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).isExtraResourceLoaded(imageToLoadNamePremium) || Root.assets.getTexture(imageToLoadNamePremium) != null;
                  }
                  imageToLoadNamePremium = alreadyLoaded ? "" : imageToLoadNamePremium;
               }
               else
               {
                  notifyAssetsLoaded();
               }
            }
            else
            {
               h = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mQuestDef.getRewardSkinSku(true)));
               imageToLoadNamePremium = h ? h.getBGImageName() : "";
               if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
               {
                  alreadyLoaded = PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).isExtraResourceLoaded(imageToLoadNamePremium) || Root.assets.getTexture(imageToLoadNamePremium) != null;
               }
               imageToLoadNamePremium = alreadyLoaded ? "" : imageToLoadNamePremium;
            }
            if(imageToLoadNamePremium != "" && imageToLoadNamePremium != null)
            {
               this.loadSkinsResources(imageToLoadNamePremium);
            }
         }
         if(hasToLoadResources || hasToLoadPremiumResources)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
            InstanceMng.getResourcesMng().loadAssets(notifyAssetsLoaded);
         }
      }
      
      protected function loadSkinsResources(param1:String) : void
      {
         if(Root.assets.getTexture(param1) == null)
         {
            if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
            {
               PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).addExtraResourceLoaded(param1);
            }
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + param1,FSResourceMng.TYPE_TEXTURE_PNG);
         }
      }
      
      private function ownerHasValidPass() : Boolean
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         return _loc1_ ? _loc1_.hasValidBattlePass() : false;
      }
      
      private function createNumberSection() : void
      {
         var _loc1_:PopupBattlePass = InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass ? PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()) : null;
         var _loc2_:Number = _loc1_ ? _loc1_.getRewardsNumberBG().height : this.mBoxHeight * PopupBattlePass.REWARDS_NUMBER_HEIGHT_FACTOR;
         var _loc3_:Number = _loc1_ ? _loc1_.getRewardsNumberBG().y : 0;
         if(this.mNumberBG == null)
         {
            this.mNumberBG = new FSImage(Root.assets.getTexture("battlepass_reward_layer"));
            this.mNumberBG.width = this.mFixedWidth;
            this.mNumberBG.height = _loc2_;
            this.mNumberBG.alpha = 0.65;
            addChild(this.mNumberBG);
         }
         if(this.mNumberTextfield == null)
         {
            this.mNumberTextfield = new FSTextfield(this.mNumberBG.width,this.mNumberBG.height,this.mQuestDef.getBattlePassIndex().toString());
            addChild(this.mNumberTextfield);
         }
      }
      
      private function createRewardSection() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:PopupBattlePass = InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass ? PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()) : null;
         var _loc2_:Quad = _loc1_ ? _loc1_.getRewardsRewardBG() : null;
         _loc3_ = _loc1_ ? _loc2_.height : this.mBoxHeight * PopupBattlePass.REWARDS_REWARD_HEIGHT_FACTOR;
         _loc4_ = _loc1_.getSeparatorY();
         if(this.mRewardBG == null)
         {
            this.mRewardBG = new FSImage(Root.assets.getTexture("battlepass_reward_layer"));
            this.mRewardBG.alpha = 0.65;
            this.mRewardBG.width = this.mFixedWidth;
            this.mRewardBG.height = _loc3_;
            this.mRewardBG.y = this.mNumberBG.y + this.mNumberBG.height + _loc4_;
            addChild(this.mRewardBG);
         }
         if(this.mQuestDef.hasReward())
         {
            this.createRewardIcon(false);
            this.createRewardCurrencyAmount(false);
            this.mRewardBG.addEventListener(TouchEvent.TOUCH,this.onRewardTouch);
         }
      }
      
      private function createPremiumRewardSection() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:PopupBattlePass = InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass ? PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()) : null;
         _loc2_ = _loc1_.getSeparatorY();
         var _loc3_:Number = _loc1_ ? _loc1_.getRewardsPremiumRewardsBG().height : this.mBoxHeight * PopupBattlePass.REWARDS_PREMIUM_REWARD_HEIGHT_FACTOR;
         if(this.mPremiumRewardBG == null)
         {
            this.mPremiumRewardBG = new FSImage(Root.assets.getTexture("battlepass_reward_layer"));
            this.mPremiumRewardBG.width = this.mFixedWidth;
            this.mPremiumRewardBG.height = _loc3_;
            this.mPremiumRewardBG.alpha = 0.65;
            this.mPremiumRewardBG.y = this.mRewardBG.y + this.mRewardBG.height + _loc2_;
            addChild(this.mPremiumRewardBG);
         }
         if(this.mQuestDef.hasPremiumReward())
         {
            this.createRewardIcon(true);
            this.createRewardCurrencyAmount(true);
            this.mPremiumRewardBG.addEventListener(TouchEvent.TOUCH,this.onPremiumRewardTouch);
         }
      }
      
      private function createRewardCurrencyAmount(param1:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = "";
         if(this.mQuestDef)
         {
            _loc4_ = this.mQuestDef.getRewardType(param1);
            switch(_loc4_)
            {
               case QuestsDefMng.REWARD_TYPE_QUEST_COINS:
                  _loc2_ = this.mQuestDef.getRewardPoints(param1);
                  _loc3_ = _loc2_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_RAID_COINS:
                  _loc2_ = this.mQuestDef.getRewardRaidPoints(param1);
                  _loc3_ = _loc2_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_GOLD:
                  _loc2_ = this.mQuestDef.getRewardGold(param1);
                  _loc3_ = _loc2_.toString();
                  break;
               case QuestsDefMng.REWARD_TYPE_TOKENS:
                  _loc2_ = this.mQuestDef.getRewardTokens(param1);
                  _loc3_ = _loc2_.toString();
            }
         }
         if(_loc2_ > 0)
         {
            if(!param1)
            {
               if(this.mRewardAmountTextfield == null)
               {
                  this.mRewardAmountTextfield = new FSTextfield(this.mRewardImage.width,this.mRewardImage.height,_loc3_);
                  this.mRewardAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
                  this.mRewardAmountTextfield.x = this.mRewardImage.x;
                  this.mRewardAmountTextfield.y = this.mRewardImage.y;
                  this.mRewardAmountTextfield.format.horizontalAlign = Align.CENTER;
                  this.mRewardAmountTextfield.touchable = false;
                  addChild(this.mRewardAmountTextfield);
               }
            }
            else if(this.mPremiumRewardAmountTextfield == null)
            {
               this.mPremiumRewardAmountTextfield = new FSTextfield(this.mPremiumRewardImage.width,this.mPremiumRewardImage.height,_loc3_);
               this.mPremiumRewardAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
               this.mPremiumRewardAmountTextfield.x = this.mPremiumRewardImage.x;
               this.mPremiumRewardAmountTextfield.y = this.mPremiumRewardImage.y;
               this.mPremiumRewardAmountTextfield.format.horizontalAlign = Align.CENTER;
               this.mPremiumRewardAmountTextfield.touchable = false;
               addChild(this.mPremiumRewardAmountTextfield);
            }
         }
      }
      
      private function createCardImage(param1:Boolean) : FSImage
      {
         var _loc2_:FSImage = null;
         var _loc4_:String = null;
         var _loc5_:RarityDef = null;
         var _loc6_:String = null;
         var _loc3_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mQuestDef.getRewardCard(param1)));
         if(_loc3_)
         {
            _loc4_ = _loc3_.getCardRarity();
            _loc5_ = _loc4_ != null && _loc4_ != "" ? RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc4_)) : null;
            _loc6_ = "";
            if(_loc5_)
            {
               _loc6_ = _loc5_ ? _loc5_.getBGPack() : null;
            }
            _loc2_ = _loc6_ != null ? new FSImage(Root.assets.getTexture(_loc6_)) : null;
         }
         return _loc2_;
      }
      
      private function createRewardIcon(param1:Boolean) : void
      {
         if(this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_QUEST_COINS || this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_RAID_COINS || this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_CLASS_UNLOCK || this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_GOLD || this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_TOKENS || this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_JOB_XP || this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_UNLOCK_CRAFT)
         {
            if(param1)
            {
               this.mPremiumRewardImage = InstanceMng.getQuestsMng().createCurrencyIcon(this.mQuestDef,param1);
            }
            else
            {
               this.mRewardImage = InstanceMng.getQuestsMng().createCurrencyIcon(this.mQuestDef,param1);
            }
         }
         else if(this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_CARD)
         {
            if(param1)
            {
               this.mPremiumRewardImage = this.createCardImage(param1);
            }
            else
            {
               this.mRewardImage = this.createCardImage(param1);
            }
         }
         else if(this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_PORTRAIT_SKIN)
         {
            if(param1)
            {
               this.mPremiumRewardImage = InstanceMng.getQuestsMng().createSkinImage(this.mQuestDef);
            }
            else
            {
               this.mRewardImage = InstanceMng.getQuestsMng().createSkinImage(this.mQuestDef);
            }
         }
         else if(this.mQuestDef.getRewardType(param1) == QuestsDefMng.REWARD_TYPE_PACK)
         {
            if(param1)
            {
               this.mPremiumRewardImage = InstanceMng.getQuestsMng().createPackImage(this.mQuestDef,param1);
               this.mPremiumRewardImage.x = this.mPremiumRewardImage.width / 2;
               this.mPremiumRewardImage.y = this.mPremiumRewardImage.height / 2;
            }
            else
            {
               this.mRewardImage = InstanceMng.getQuestsMng().createPackImage(this.mQuestDef,param1);
               this.mRewardImage.x = this.mRewardImage.width / 2;
               this.mRewardImage.y = this.mRewardImage.height / 2;
            }
         }
         if(!param1 && Boolean(this.mRewardImage))
         {
            this.mRewardImage.x += this.mRewardBG.x + (this.mRewardBG.width - this.mRewardImage.width) / 2;
            this.mRewardImage.y += this.mRewardBG.y + (this.mRewardBG.height - this.mRewardImage.height) / 2;
            addChild(this.mRewardImage);
         }
         if(param1 && Boolean(this.mPremiumRewardImage))
         {
            this.mPremiumRewardImage.x += this.mPremiumRewardBG.x + (this.mPremiumRewardBG.width - this.mPremiumRewardImage.width) / 2;
            this.mPremiumRewardImage.y += this.mPremiumRewardBG.y + (this.mPremiumRewardBG.height - this.mPremiumRewardImage.height) / 2;
            addChild(this.mPremiumRewardImage);
         }
         if(this.mPremiumRewardImage)
         {
            this.mPremiumRewardImage.touchable = false;
         }
         if(this.mRewardImage)
         {
            this.mRewardImage.touchable = false;
         }
      }
      
      private function createInfoButton() : void
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:UserData = Utils.getOwnerUserData();
         var _loc4_:Boolean = _loc3_ ? _loc3_.isQuestAlreadyClaimed(this.mQuestDef.getSku()) : false;
         var _loc5_:Boolean = this.ownerHasValidPass();
         if(_loc5_)
         {
            _loc2_ = _loc4_ ? "battlepass_reward_icon_claimed" : "";
            _loc1_ = _loc4_ ? "battlepass_reward_icon_claimed" : "";
         }
         else
         {
            _loc2_ = _loc4_ ? "battlepass_reward_icon_claimed" : "";
            _loc1_ = "battlepass_reward_icon_locked";
         }
         var _loc6_:Texture = Boolean(_loc2_) && _loc2_ != this.mRewardInfoTName ? Root.assets.getTexture(_loc2_) : null;
         var _loc7_:Texture = Boolean(_loc1_) && _loc1_ != this.mPremiumRewardInfoTName ? Root.assets.getTexture(_loc1_) : null;
         this.mRewardInfoTName = _loc2_;
         this.mPremiumRewardInfoTName = _loc1_;
         if(Boolean(this.mRewardImage) && Boolean(this.mRewardImageLock == null) && Boolean(_loc6_))
         {
            this.mRewardImageLock = new FSImage(_loc6_);
            if(this.mRewardImage is PackAnimation)
            {
               this.mRewardImageLock.x = this.mRewardImage.x + this.mRewardImage.width / 2 - this.mRewardImageLock.width;
               this.mRewardImageLock.y = this.mRewardImage.y - this.mRewardImage.height / 2;
            }
            else
            {
               this.mRewardImageLock.x = this.mRewardImage.x + this.mRewardImage.width - this.mRewardImageLock.width;
               this.mRewardImageLock.y = this.mRewardImage.y;
            }
            addChild(this.mRewardImageLock);
         }
         else if(Boolean(_loc6_) && Boolean(this.mRewardImageLock) && Boolean(_loc6_))
         {
            this.mRewardImageLock.texture = _loc6_;
            this.mRewardImageLock.readjustSize();
         }
         if(Boolean(this.mPremiumRewardImage) && Boolean(this.mPremiumRewardImageLock == null) && Boolean(_loc7_))
         {
            this.mPremiumRewardImageLock = new FSImage(_loc7_);
            if(this.mPremiumRewardImage is PackAnimation)
            {
               this.mPremiumRewardImageLock.x = this.mPremiumRewardImage.x + this.mPremiumRewardImage.width / 2 - this.mPremiumRewardImageLock.width;
               this.mPremiumRewardImageLock.y = this.mPremiumRewardImage.y - this.mPremiumRewardImage.height / 2;
            }
            else
            {
               this.mPremiumRewardImageLock.x = this.mPremiumRewardImage.x + this.mPremiumRewardImage.width - this.mPremiumRewardImageLock.width;
               this.mPremiumRewardImageLock.y = this.mPremiumRewardImage.y;
            }
            addChild(this.mPremiumRewardImageLock);
         }
         else if(Boolean(_loc7_) && Boolean(this.mPremiumRewardImageLock) && Boolean(_loc7_))
         {
            this.mPremiumRewardImageLock.texture = _loc7_;
            this.mPremiumRewardImageLock.readjustSize();
         }
      }
      
      public function onBattlePassQuestClaimed() : void
      {
         this.createInfoButton();
      }
      
      public function setValidPass(param1:Boolean) : void
      {
         this.createInfoButton();
         if(this.mPremiumRewardImage)
         {
            this.mPremiumRewardImage.alpha = param1 ? 1 : 0.5;
         }
         if(this.mPremiumRewardAmountTextfield)
         {
            this.mPremiumRewardAmountTextfield.alpha = param1 ? 1 : 0.5;
         }
      }
      
      private function onRewardTouch(param1:TouchEvent) : void
      {
         if(param1.getTouch(this,TouchPhase.ENDED))
         {
            if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
            {
               PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).onChallengeClicked(false,this);
            }
         }
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.HOVER);
         scale = _loc2_ ? 1.02 : 1;
      }
      
      private function onPremiumRewardTouch(param1:TouchEvent) : void
      {
         if(param1.getTouch(this,TouchPhase.ENDED))
         {
            if(InstanceMng.getPopupMng().getPopupShown() is PopupBattlePass)
            {
               PopupBattlePass(InstanceMng.getPopupMng().getPopupShown()).onChallengeClicked(true,this);
            }
         }
      }
      
      public function getQuestDef() : QuestDef
      {
         return this.mQuestDef;
      }
      
      public function setHighlighted(param1:Boolean, param2:Boolean) : void
      {
         this.mNumberTextfield.color = !param2 ? 16777215 : 16744448;
         this.mNumberTextfield.border = param2;
      }
      
      public function getRewardImage(param1:Boolean) : *
      {
         return !param1 ? this.mRewardImage : this.mPremiumRewardImage;
      }
      
      override public function dispose() : void
      {
         if(this.mNumberBG)
         {
            this.mNumberBG.removeFromParent(true);
            this.mNumberBG = null;
         }
         if(this.mNumberTextfield)
         {
            this.mNumberTextfield.removeFromParent(true);
            this.mNumberTextfield = null;
         }
         if(this.mRewardBG)
         {
            this.mRewardBG.removeFromParent(true);
            this.mRewardBG = null;
         }
         if(this.mRewardImage)
         {
            this.mRewardImage.removeFromParent(true);
            this.mRewardImage = null;
         }
         if(this.mPremiumRewardBG)
         {
            this.mPremiumRewardBG.removeFromParent(true);
            this.mPremiumRewardBG = null;
         }
         if(this.mPremiumRewardImage)
         {
            this.mPremiumRewardImage.removeFromParent(true);
            this.mPremiumRewardImage = null;
         }
         if(this.mPremiumRewardImageLock)
         {
            this.mPremiumRewardImageLock.removeFromParent(true);
            this.mPremiumRewardImageLock = null;
         }
         if(this.mRewardImageLock)
         {
            this.mRewardImageLock.removeFromParent(true);
            this.mRewardImageLock = null;
         }
         if(this.mRewardAmountTextfield)
         {
            this.mRewardAmountTextfield.removeFromParent(true);
            this.mRewardAmountTextfield = null;
         }
         if(this.mPremiumRewardAmountTextfield)
         {
            this.mPremiumRewardAmountTextfield.removeFromParent(true);
            this.mPremiumRewardAmountTextfield = null;
         }
         this.mQuestDef = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mNumberBG)
         {
            this.mNumberBG.removeFromParent();
            this.mNumberBG = null;
         }
         if(this.mNumberTextfield)
         {
            this.mNumberTextfield.removeFromParent();
            this.mNumberTextfield = null;
         }
         if(this.mRewardBG)
         {
            this.mRewardBG.removeFromParent();
            this.mRewardBG = null;
         }
         if(this.mRewardImage)
         {
            this.mRewardImage.removeFromParent();
            this.mRewardImage = null;
         }
         if(this.mPremiumRewardBG)
         {
            this.mPremiumRewardBG.removeFromParent();
            this.mPremiumRewardBG = null;
         }
         if(this.mPremiumRewardImage)
         {
            this.mPremiumRewardImage.removeFromParent();
            this.mPremiumRewardImage = null;
         }
         if(this.mPremiumRewardImageLock)
         {
            this.mPremiumRewardImageLock.removeFromParent();
            this.mPremiumRewardImageLock = null;
         }
         if(this.mRewardImageLock)
         {
            this.mRewardImageLock.removeFromParent();
            this.mRewardImageLock = null;
         }
         if(this.mRewardAmountTextfield)
         {
            this.mRewardAmountTextfield.removeFromParent();
            this.mRewardAmountTextfield = null;
         }
         if(this.mPremiumRewardAmountTextfield)
         {
            this.mPremiumRewardAmountTextfield.removeFromParent();
            this.mPremiumRewardAmountTextfield = null;
         }
         this.mQuestDef = null;
      }
   }
}

