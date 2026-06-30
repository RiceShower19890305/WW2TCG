package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.FSSoundFXMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.EditionDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Filters;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.cards.PermanentParticleAnimation;
   import com.fs.tcgengine.view.board.AbilityInfoBlock;
   import com.fs.tcgengine.view.board.AttachmentsInfoBlock;
   import com.fs.tcgengine.view.board.CardUpgradesInfoBlock;
   import com.fs.tcgengine.view.board.FSCardDescInfoBlock;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.battle.PromoteCostBlock;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.buttons.FSToggleButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.AuctionPanel;
   import com.fs.tcgengine.view.misc.CraftPanel;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import feathers.controls.ScrollBarDisplayMode;
   import feathers.controls.ScrollContainer;
   import feathers.layout.VerticalLayout;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.extensions.ColorArgb;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSCardXL extends FSCard
   {
      
      public static const ATTACHMENTS_BLOCK_HEIGHT_PERCENTAGE:int = 35;
      
      public static const ABILITIES_BLOCK_HEIGHT_PERCENTAGE:int = 60;
      
      public static const TIER_CARDS_BLOCK_HEIGHT_PERCENTAGE:int = 35;
      
      public static const DESCRIPTION_BLOCK_HEIGHT_PERCENTAGE:int = 50;
      
      public static const PROMOTE_CARD_BLOCK_HEIGHT_PERCENTAGE:int = 20;
      
      public static const VERTICAL_SEPARATORS_HEIGHT:int = 15;
      
      public static const COLUMN_WIDTH:int = Starling.current.stage.stageWidth / 4;
      
      private static const ABILITIES_BLOCK_TITLE_HEIGHT:int = FSResourceMng.FONT_STD_TITLE_SIZE;
      
      public var mParentCard:FSCard;
      
      public var mAbilitiesBlockTitle:FSTextfield;
      
      protected var mAbilitiesScrollContainer:ScrollContainer;
      
      protected var mDescriptionInfoBlock:FSCardDescInfoBlock;
      
      protected var mCardUpgradesInfoBlock:CardUpgradesInfoBlock;
      
      private var mAttachmentsInfoBlock:AttachmentsInfoBlock;
      
      private var mPromoteCostBlock:PromoteCostBlock;
      
      protected var mTierCards:Vector.<FSCardPreview>;
      
      protected var mAllCardsAbilities:Vector.<AbilityDef>;
      
      protected var mAbilitiesInfoBlocksCatalog:Dictionary;
      
      protected var mAttachmentsAbilitiesInfoBlocksCatalog:Dictionary;
      
      protected var mMainTitleTextfield:FSTextfield;
      
      protected var mAbilitiesHeightBlockPercent:int;
      
      protected var mDescBlockHeightPercent:int;
      
      protected var mTitleBanner:CustomComponent;
      
      private var mBackCard:FSImage;
      
      private var mXLAssetsLoaded:Boolean = false;
      
      private var mEditionIcon:FSImage;
      
      private var mEditionTextfield:FSTextfield;
      
      protected var mCraftButton:FSButton;
      
      private var mCraftPanel:CraftPanel;
      
      public var mCraftModeON:Boolean;
      
      private var mAuctionPanel:AuctionPanel;
      
      private var mAuctionButton:FSButton;
      
      protected var mFavouriteButton:FSToggleButton;
      
      private var mParticleSystem:PermanentParticleAnimation;
      
      protected var mCardSkinButton:FSButton;
      
      protected var mCardFusionButton:FSButton;
      
      private var mIsShown:Boolean = false;
      
      private var mCurrentAmountTextfield:FSTextfield;
      
      private var mShareButton:FSImage;
      
      private var mIsClosing:Boolean = false;
      
      public function FSCardXL(param1:FSCard)
      {
         this.mParentCard = param1;
         mZoomedIn = true;
         super(param1.getCardDef().getSku());
         this.setHeightPercentages();
         pivotX = 0;
         pivotY = 0;
      }
      
      override protected function initializeCard(param1:CardDef, param2:Boolean = false) : void
      {
         super.initializeCard(param1,param2);
         if(Config.getConfig().XLViewUsesParticles())
         {
            this.mParticleSystem = InstanceMng.getCardAnimsMng().requestZoomInAnimation(this);
         }
      }
      
      override protected function createAbsAnimsLayer() : void
      {
      }
      
      override public function createAbilitiesIcons(param1:int = 0) : void
      {
         if(Config.getConfig().XLViewShowsAbsIconsOnCard())
         {
            super.createAbilitiesIcons(param1);
         }
      }
      
      public function showCardsBack() : Boolean
      {
         return Config.getConfig().XLViewShowsCardBack();
      }
      
      protected function setHeightPercentages() : void
      {
         this.mAbilitiesHeightBlockPercent = Config.getConfig().XLViewShowsFrames() ? ABILITIES_BLOCK_HEIGHT_PERCENTAGE : int(ABILITIES_BLOCK_HEIGHT_PERCENTAGE * 1.95);
         this.mDescBlockHeightPercent = Config.getConfig().XLViewShowsFrames() ? DESCRIPTION_BLOCK_HEIGHT_PERCENTAGE : int(DESCRIPTION_BLOCK_HEIGHT_PERCENTAGE / 1.5);
      }
      
      protected function createWindowTitle() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Point = null;
         if(this.mTitleBanner == null)
         {
            this.mTitleBanner = Utils.createCustomBox("xl_name_panel",1848);
            this.mTitleBanner.x = mFrameBG ? mFrameBG.x + (mFrameBG.width - this.mTitleBanner.width) / 2 : width - this.mTitleBanner.width / 2;
            this.mTitleBanner.y = mFrameBG ? mFrameBG.y - this.mTitleBanner.height * 1.25 : this.mTitleBanner.height;
            if(!Config.getConfig().XLViewShowsFrames())
            {
               if(Boolean(this.mTitleBanner) && (Boolean(mFrameBG || mBG) || Boolean(mBGAnimated)))
               {
                  if(mFrameBG)
                  {
                     _loc1_ = mFrameBG.x;
                     _loc2_ = mFrameBG.y;
                  }
                  else
                  {
                     _loc1_ = mBG ? mBG.x : mBGAnimated.x;
                     _loc2_ = mBG ? mBG.y : mBGAnimated.y;
                  }
                  _loc3_ = localToGlobal(new Point(_loc1_,_loc2_));
                  this.mTitleBanner.y = -_loc3_.y;
                  if(this.mMainTitleTextfield)
                  {
                     this.mMainTitleTextfield.y = this.mTitleBanner.y;
                  }
               }
            }
            addChild(this.mTitleBanner);
         }
         if(this.mMainTitleTextfield == null)
         {
            this.mMainTitleTextfield = new FSTextfield(this.mTitleBanner.width,this.mTitleBanner.height,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mMainTitleTextfield.fontName = FSResourceMng.getFontByType();
            this.mMainTitleTextfield.format.horizontalAlign = Align.CENTER;
            this.mMainTitleTextfield.format.verticalAlign = Align.CENTER;
            addChild(this.mMainTitleTextfield);
            this.mMainTitleTextfield.x = this.mTitleBanner.x;
            this.mMainTitleTextfield.y = this.mTitleBanner.y;
         }
         this.setMainTitleText();
      }
      
      protected function createCardEdition() : void
      {
         var _loc3_:int = 0;
         var _loc1_:EditionDef = EditionDef(InstanceMng.getEditionsDefMng().getDefBySku(mCardDef.getEditionSku()));
         var _loc2_:Boolean = Boolean(mCardDef) && Boolean(_loc1_) && _loc1_.isVisible();
         if(_loc2_)
         {
            if(this.mEditionIcon == null)
            {
               if(Config.getConfig().gameHasTierFrames())
               {
                  this.mTitleBanner.y -= this.mTitleBanner.height * 0.45;
                  this.mMainTitleTextfield.y -= this.mMainTitleTextfield.height * 0.45;
               }
               this.mEditionIcon = new FSImage(Root.assets.getTexture(_loc1_.getBGImageName()));
               this.mEditionIcon.x = this.mTitleBanner.x;
               this.mEditionIcon.y = this.mTitleBanner.y + this.mTitleBanner.height * 1.1;
               addChild(this.mEditionIcon);
            }
            else
            {
               this.mEditionIcon.visible = true;
            }
            _loc3_ = this.mTitleBanner.width * 0.75 - this.mEditionIcon.width * 1.25;
            if(this.mEditionTextfield == null)
            {
               this.mEditionTextfield = new FSTextfield(_loc3_,this.mEditionIcon.height,_loc1_.getDesc());
               this.mEditionTextfield.x = this.mEditionIcon.x + this.mEditionIcon.width * 1.1;
               this.mEditionTextfield.y = this.mEditionIcon.y;
               addChild(this.mEditionTextfield);
            }
            else
            {
               this.mEditionIcon.visible = true;
            }
            this.mEditionIcon.x += (this.mTitleBanner.width - _loc3_) / 2;
            this.mEditionTextfield.x = this.mEditionIcon.x + this.mEditionIcon.width * 1.1;
         }
      }
      
      public function createCraftButton() : void
      {
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         var _loc2_:Boolean = Boolean(this.mParentCard) && this.mParentCard.getCardDef().getCardRarity() != "rarity_01";
         var _loc3_:Boolean = Boolean(this.mParentCard) && this.mParentCard.getCardDef().getCraftSku() != null;
         var _loc4_:Boolean = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? FSDeckBuilderScreen(_loc1_).getEdidionStatus() == FSDeckBuilderScreen.STATUS_CREATION_MODE : false;
         var _loc5_:Boolean = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? !FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON() : false;
         if(_loc1_ != null && Config.getConfig().getDeckBuilderCraftMode() && _loc4_ && _loc5_ && _loc2_ && _loc3_)
         {
            this.mCraftModeON = true;
            if(this.mCraftButton == null)
            {
               this.mCraftButton = new FSButton(Root.assets.getTexture("craft_button_lit"),TextManager.getText("TID_CRAFT_BUTTON"),null,true,null,Root.assets.getTexture("craft_button_unlit"));
               this.mCraftButton.fontSize = 22;
               this.mCraftButton.x = mFrameBG ? mFrameBG.x + mFrameBG.width / 2 : width / 2;
               this.mCraftButton.y = mFrameBG ? mFrameBG.height + this.mCraftButton.height : height + this.mCraftButton.height / 2;
               this.mCraftButton.addEventListener(Event.TRIGGERED,this.onCraftTriggered);
               addChild(this.mCraftButton);
            }
         }
      }
      
      public function createCardFusionButton() : void
      {
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         var _loc2_:Boolean = Boolean(this.mParentCard) && this.mParentCard.getCardDef().getFusionSku() != null;
         var _loc3_:Boolean = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? FSDeckBuilderScreen(_loc1_).getEdidionStatus() == FSDeckBuilderScreen.STATUS_CREATION_MODE : false;
         var _loc4_:Boolean = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? !FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON() : false;
         if(_loc1_ != null && Config.getConfig().getDeckBuilderCraftMode() && _loc3_ && _loc4_ && _loc2_)
         {
            this.mCraftModeON = true;
            if(this.mCardFusionButton == null)
            {
               this.mCardFusionButton = new FSButton(Root.assets.getTexture("fusion_button_lit"),TextManager.getText("TID_CARDFUSION"),null,true,null,Root.assets.getTexture("fusion_button_unlit"));
               this.mCardFusionButton.fontSize = 25;
               this.mCardFusionButton.x = mFrameBG ? mFrameBG.x + mFrameBG.width / 2 : width / 2;
               this.mCardFusionButton.y = mFrameBG ? mFrameBG.height + this.mCardFusionButton.height : height + this.mCardFusionButton.height / 2;
               this.mCardFusionButton.x = this.mCraftButton ? this.mCraftButton.x : this.mCardFusionButton.x;
               this.mCardFusionButton.y = this.mCraftButton ? this.mCraftButton.y + this.mCraftButton.height : this.mCardFusionButton.y;
               this.mCardFusionButton.addEventListener(Event.TRIGGERED,this.onCardFusionTriggered);
               addChild(this.mCardFusionButton);
            }
         }
      }
      
      private function onCardFusionTriggered() : void
      {
         if(this.mCardFusionButton)
         {
            this.mCardFusionButton.disableTemporarily(1);
         }
         if(this.mCraftPanel == null)
         {
            this.mCraftPanel = new CraftPanel(false,true);
         }
         var _loc1_:DeckBuilderCard = Boolean(this.mParentCard.parent) && this.mParentCard.parent is DeckBuilderCard ? DeckBuilderCard(this.mParentCard.parent) : null;
         this.mCraftPanel.setDeckBuilderCard(_loc1_);
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mParentCard.getCardDef().getFusionSku()));
         if(_loc2_)
         {
            InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc2_);
         }
         var _loc3_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mParentCard.getCardDef().getExtraFusionSku()));
         if(_loc3_)
         {
            InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc3_);
         }
         InstanceMng.getResourcesMng().loadAssets(this.onCraftCardBGLoaded);
      }
      
      public function createCardSkinButton() : void
      {
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         var _loc2_:Boolean = Boolean(this.mParentCard) && this.mParentCard.getCardDef().getCardSkinSku() != null;
         var _loc3_:Boolean = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? FSDeckBuilderScreen(_loc1_).getEdidionStatus() == FSDeckBuilderScreen.STATUS_CREATION_MODE : false;
         var _loc4_:Boolean = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen ? !FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON() : false;
         if(_loc1_ != null && Config.getConfig().getDeckBuilderCraftMode() && _loc3_ && _loc2_)
         {
            this.mCraftModeON = true;
            if(this.mCardSkinButton == null)
            {
               this.mCardSkinButton = new FSButton(Root.assets.getTexture("cardSkin_button_lit"),TextManager.getText("TID_CARDSKIN"),null,true,null,Root.assets.getTexture("cardSkin_button_unlit"));
               this.mCardSkinButton.fontSize = 25;
               this.mCardSkinButton.x = mFrameBG ? mFrameBG.x + mFrameBG.width / 2 : width / 2;
               this.mCardSkinButton.y = mFrameBG ? mFrameBG.height + this.mCardSkinButton.height : height + this.mCardSkinButton.height / 2;
               this.mCardSkinButton.x = this.mCraftButton ? this.mCraftButton.x : this.mCardSkinButton.x;
               this.mCardSkinButton.y = this.mCraftButton ? this.mCraftButton.y + this.mCraftButton.height : this.mCardSkinButton.y;
               this.mCardSkinButton.x = this.mCardFusionButton ? this.mCardFusionButton.x : this.mCardSkinButton.x;
               this.mCardSkinButton.y = this.mCardFusionButton ? this.mCardFusionButton.y + this.mCardFusionButton.height : this.mCardSkinButton.y;
               this.mCardSkinButton.addEventListener(Event.TRIGGERED,this.onCardSkinTriggered);
               addChild(this.mCardSkinButton);
            }
         }
      }
      
      private function onCardSkinTriggered(param1:Event) : void
      {
         if(this.mCardSkinButton)
         {
            this.mCardSkinButton.disableTemporarily(1);
         }
         if(this.mCraftPanel == null)
         {
            this.mCraftPanel = new CraftPanel(true);
         }
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mParentCard.getCardDef().getCardSkinSku()));
         if(_loc2_)
         {
            InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc2_);
            InstanceMng.getResourcesMng().loadAssets(this.onCraftCardBGLoaded);
         }
      }
      
      private function onCraftTriggered(param1:Event) : void
      {
         var _loc5_:QuestDef = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:CardDef = null;
         var _loc10_:CardDef = null;
         this.mCraftButton.disableTemporarily(1);
         var _loc2_:Boolean = this.mParentCard.isQuestConditionOKForCraft();
         if(!_loc2_)
         {
            _loc5_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(this.mParentCard.getCardDef().getCraftQuestSku()));
            if((Boolean(_loc5_)) && _loc5_.isBattlePassQuest())
            {
               _loc6_ = _loc5_ ? _loc5_.getDesc() : "???";
               _loc7_ = _loc5_.getBattlePassSeasonYear() == -1 ? "" : "-" + _loc5_.getBattlePassSeasonYear();
               _loc8_ = "#" + _loc5_.getBattlePassIndex() + " " + _loc6_ + " (" + TextManager.getText("TID_GEN_SEASON") + " " + _loc5_.getBattlePassSeason() + _loc7_ + ")";
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_BP_CRAFT_UNLOCKED"),[_loc8_]),false,false,false);
               return;
            }
         }
         if(this.mCraftPanel == null)
         {
            this.mCraftPanel = new CraftPanel();
         }
         var _loc3_:Boolean = this.mParentCard.getCardDef().isCraftSkuBGDifferentBG();
         var _loc4_:Boolean = this.mParentCard.getCardDef().needsExtraCraftCard() ? this.mParentCard.getCardDef().isExtraCraftSkuBGDifferentBG() : false;
         if(_loc3_ || _loc4_)
         {
            _loc9_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mParentCard.getCardDef().getCraftSku()));
            if(_loc9_)
            {
               InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc9_);
            }
            _loc10_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.mParentCard.getCardDef().getExtraCraftSku()));
            if(_loc10_)
            {
               InstanceMng.getResourcesMng().loadCardImagesByCardDef(_loc10_);
            }
            InstanceMng.getResourcesMng().loadAssets(this.onCraftCardBGLoaded);
         }
         else
         {
            this.mCraftPanel.setupPanel(this.mParentCard);
            this.lockUI(true);
            InstanceMng.getCurrentScreen().addChild(this.mCraftPanel);
         }
      }
      
      private function onCraftCardBGLoaded() : void
      {
         if(Boolean(this.mCraftPanel) && Boolean(this.mParentCard))
         {
            this.mCraftPanel.setupPanel(this.mParentCard);
            this.lockUI(true);
            InstanceMng.getCurrentScreen().addChild(this.mCraftPanel);
         }
      }
      
      protected function setMainTitleText() : void
      {
         var _loc1_:String = null;
         if(this.mMainTitleTextfield)
         {
            this.mMainTitleTextfield.text = mCardDef.getName();
            if(this.mParentCard.getType() != FSCard.TYPE_POWER)
            {
               _loc1_ = InstanceMng.getSubCategoriesMng().getSubcategoriesNamesByDefSku(mCardDef.getSubCategorySku()).toUpperCase();
               this.mMainTitleTextfield.text += _loc1_ != "" ? " (" + _loc1_ + ")" : "";
            }
         }
      }
      
      override protected function performExtraChecks() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:FactionDef = null;
         var _loc7_:String = null;
         if(this is FSCardXL && mCardDef != null && this.mParentCard != null)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(true,true);
            _loc1_ = false;
            if(Config.getConfig().XLViewUsesXLTextures())
            {
               _loc5_ = mCardDef.getBGXLImageName();
               if(mCardDef.getBGXLImageName() != "" && Root.assets.getTexture(_loc5_) == null)
               {
                  _loc1_ = InstanceMng.getResourcesMng().addResourceToLoad("cards/" + _loc5_,FSResourceMng.TYPE_TEXTURE_JPG);
               }
               else
               {
                  _loc1_ = false;
               }
            }
            _loc2_ = this.mParentCard.getType() == FSCard.TYPE_ACTION;
            _loc3_ = false;
            if(!_loc2_ && Config.getConfig().XLViewUsesXLTextures())
            {
               _loc3_ = InstanceMng.getResourcesMng().addResourceToLoad("framesXL/" + mCardDef.getCompositeTierFrameName(true),FSResourceMng.TYPE_TEXTURE_PNG);
            }
            _loc4_ = false;
            if(this.showCardsBack())
            {
               _loc6_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(mCardDef.getFactionSku()));
               _loc7_ = _loc6_ ? _loc6_.getBackBGXLName() : "";
               if(_loc7_ != "" && Root.assets.getTexture(_loc7_) == null)
               {
                  _loc4_ = InstanceMng.getResourcesMng().addResourceToLoad("backsXL/" + _loc7_,FSResourceMng.TYPE_TEXTURE_PNG);
               }
            }
            else
            {
               _loc4_ = true;
            }
            this.notifyResourceLoaded();
            if(_loc1_ || _loc4_ || _loc3_)
            {
               this.mXLAssetsLoaded = false;
               InstanceMng.getResourcesMng().loadAssets(this.onXLImagesLoaded);
            }
            else if(!Config.getConfig().XLViewUsesXLTextures())
            {
               if(Config.getConfig().playSoundOnZoomIn())
               {
                  InstanceMng.getSoundFXMng().playCardSound(this.mParentCard,FSSoundFXMng.PROMOTE);
               }
            }
         }
      }
      
      protected function onXLImagesLoaded() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         if(this.mIsShown)
         {
            this.mXLAssetsLoaded = true;
            if(!hasAnimatedBG())
            {
               if(mBG)
               {
                  _loc1_ = Root.assets.getTexture(mCardDef.getBGXLImageName());
                  if(_loc1_)
                  {
                     mBG.texture = _loc1_;
                  }
               }
            }
            this.createCardBack();
            if(mTierFrame)
            {
               mTierFrame.updateTexture(mCardDef.getCompositeTierFrameName(true));
            }
            if(Config.getConfig().playSoundOnZoomIn())
            {
               InstanceMng.getSoundFXMng().playCardSound(this.mParentCard,FSSoundFXMng.PROMOTE,true);
            }
         }
         else
         {
            _loc2_ = Config.getConfig().XLViewUsesXLTextures();
            if(_loc2_)
            {
               Root.assets.removeTexture(mCardDef.getBGXLImageName());
               _loc3_ = mCardDef.getType() == FSCard.TYPE_ACTION;
               if(!_loc3_)
               {
                  Root.assets.removeTexture(mCardDef.getCompositeTierFrameName(true));
               }
               if(this.showCardsBack())
               {
                  _loc4_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(mCardDef.getFactionSku())).getBackBGXLName();
                  Root.assets.removeTexture(_loc4_);
               }
            }
         }
      }
      
      override public function notifyResourceLoaded() : void
      {
         this.initializeCard(mCardDef);
         this.mParentCard.setTempCardXL(this);
         if(this.mParentCard.isZoomedIn() || this.mParentCard.isInfoCard())
         {
            this.mParentCard.onXLCardImageLoaded();
         }
         else
         {
            SpecialFX.zoomOut(this.mParentCard);
            DictionaryUtils.disposeCardXL(this);
            this.mParentCard.setTempCardXL(null);
         }
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         setTimeout(this.showShareButton,1000);
         this.mIsShown = true;
      }
      
      private function canShowShareButton() : Boolean
      {
         return false;
      }
      
      protected function showShareButton() : void
      {
         if(this.canShowShareButton())
         {
            this.mShareButton = new FSImage(Root.assets.getTexture(Constants.SOCIAL_SHARE_BUTTON_XS));
            this.mShareButton.touchable = true;
            this.mShareButton.scale = Utils.isMobile() || Utils.isDesktop() ? 1.5 : 1;
            this.mShareButton.addEventListener(TouchEvent.TOUCH,this.onShareButtonTouched);
            this.mShareButton.x = Starling.current.stage.stageWidth - this.mShareButton.width * 1.5;
            this.mShareButton.y = this.mShareButton.height / 2;
            InstanceMng.getCurrentScreen().addChild(this.mShareButton);
         }
      }
      
      private function onShareButtonTouched(param1:TouchEvent) : void
      {
         if(Boolean(param1) && Boolean(param1.getTouch(this.mShareButton,TouchPhase.ENDED)))
         {
            if(this.canShowShareButton())
            {
               this.shareCardReceived();
            }
         }
      }
      
      private function setShareButtonVisibility(param1:Boolean) : void
      {
         if(this.mShareButton)
         {
            this.mShareButton.visible = param1;
         }
      }
      
      private function shareCardReceived() : void
      {
         this.setShareButtonVisibility(false);
         if(InstanceMng.getFacebookPlugin() != null && InstanceMng.getFacebookPlugin().isSessionOpen() && this.mParentCard != null)
         {
            InstanceMng.getFacebookPlugin().shareCardReceived(this.mParentCard.getCardDef());
         }
         else if(this.mParentCard != null && InstanceMng.getApplication().isKongregateVersion())
         {
            InstanceMng.getApplication().kongShareCardReceived(this.mParentCard.getCardDef());
         }
         setTimeout(this.setShareButtonVisibility,2000,true);
      }
      
      override protected function createBGImage(param1:int = 0) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<Texture> = null;
         if(mCardDef)
         {
            if(!mCardDef.hasAnimatedBG())
            {
               _loc2_ = Config.getConfig().XLViewUsesXLTextures();
               _loc3_ = !_loc2_ || _loc2_ && !this.mXLAssetsLoaded;
               _loc4_ = _loc3_ ? mCardDef.getBGImageName() : mCardDef.getBGXLImageName();
               if(Root.assets.getTexture(_loc4_))
               {
                  setBG(_loc4_,false);
                  if(_loc3_)
                  {
                     mBG.x = mFactionFrameBG.x + (mFactionFrameBG.width - mBG.width) / 2;
                     mBG.y = mFactionFrameBG.y + (mFactionFrameBG.height - mBG.height) / 2;
                  }
                  else
                  {
                     mBG.x = (mFactionFrameBG.width - mBG.width) / 2;
                     mBG.y = (mFactionFrameBG.height - mBG.height) / 2;
                  }
                  createBattleContainer();
                  if(Config.getConfig().cardBGOverlapsFrame())
                  {
                     createBattleContainer();
                     mBattleComponents.addChild(mBG);
                  }
                  else
                  {
                     mSubComponentsContainer.addChild(mBG);
                  }
               }
               else if(param1 < 3)
               {
                  TweenMax.delayedCall(0.1,this.createBGImage,[param1 + 1]);
               }
            }
            else
            {
               _loc5_ = mCardDef.getAnimatedBG();
               _loc6_ = mCardDef.getAnimatedBGFPS();
               _loc7_ = Root.assets.getTextures(_loc5_ + "_");
               if(_loc7_)
               {
                  if(mBGAnimated == null)
                  {
                     mBGAnimated = new MovieClip(_loc7_,_loc6_);
                  }
                  mBGAnimated.scale *= 2;
                  mBGAnimated.x = mFactionFrameBG ? (mFactionFrameBG.width - mBGAnimated.width) / 2 : 0;
                  mBGAnimated.y = mFactionFrameBG ? (mFactionFrameBG.height - mBGAnimated.height) / 2 : 0;
                  Starling.juggler.add(mBGAnimated);
                  mBGAnimated.play();
                  createBattleContainer();
                  if(Config.getConfig().cardBGOverlapsFrame())
                  {
                     createBattleContainer();
                     mBattleComponents.addChild(mBGAnimated);
                  }
                  else
                  {
                     mSubComponentsContainer.addChild(mBGAnimated);
                  }
               }
               else if(param1 < 3)
               {
                  TweenMax.delayedCall(0.1,this.createBGImage,[param1 + 1]);
               }
            }
            if(Boolean(mBG) || Boolean(mBGAnimated))
            {
               if(Config.getConfig().cardFrameOverlapsBG())
               {
                  mSubComponentsContainer.addChild(mFactionFrameBG);
                  if(mBottomFrameBG)
                  {
                     mSubComponentsContainer.addChild(mBottomFrameBG);
                  }
               }
            }
         }
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc4_:Touch = null;
         var _loc5_:Touch = null;
         var _loc6_:Touch = null;
         var _loc7_:Touch = null;
         var _loc2_:Touch = param1.getTouch(this.mFavouriteButton,TouchPhase.ENDED);
         if(_loc2_ == null)
         {
            _loc3_ = param1.getTouch(this.mAuctionButton,TouchPhase.ENDED);
            if(_loc3_ == null)
            {
               _loc4_ = param1.getTouch(this.mCraftButton,TouchPhase.ENDED);
               if(_loc4_ == null)
               {
                  _loc5_ = param1.getTouch(this.mCardFusionButton,TouchPhase.ENDED);
                  if(_loc5_ == null)
                  {
                     _loc6_ = param1.getTouch(this.mCardSkinButton,TouchPhase.ENDED);
                     if(_loc6_ == null)
                     {
                        _loc7_ = param1.getTouch(this.mShareButton,TouchPhase.ENDED);
                        if(_loc7_ == null)
                        {
                           mCardTouch = param1.getTouch(this,TouchPhase.ENDED);
                           if(Boolean(mCardTouch) && (this.mAbilitiesScrollContainer == null || this.mAbilitiesScrollContainer != null && !this.mAbilitiesScrollContainer.isScrolling))
                           {
                              this.mIsClosing = true;
                              InstanceMng.getCurrentScreen().removeTranslucentBG(true);
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      override public function createTierFrame(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         if(Boolean(Config.getConfig().gameHasTierFrames()) && Boolean(mCardDef) && Boolean(mSubComponentsContainer))
         {
            if(mTierFrame != null)
            {
               mTierFrame.removeFromParent();
               mTierFrame = null;
            }
            if(mTierFrame == null)
            {
               _loc2_ = Config.getConfig().XLViewUsesXLTextures() && this.mXLAssetsLoaded ? mCardDef.getCompositeTierFrameName(true) : mCardDef.getCompositeTierFrameName();
               if(_loc2_ != "")
               {
                  mTierFrame = new CompositeFrame(_loc2_);
               }
            }
            if(mTierFrame)
            {
               mTierFrame.alignPivot();
               mTierFrame.width = mFrameBG ? mFrameBG.width : width;
               mTierFrame.height = mFrameBG ? mFrameBG.height : height;
               mTierFrame.x = mFrameBG ? mFrameBG.x + mFrameBG.width / 2 : width / 2;
               mTierFrame.y = mFrameBG ? mFrameBG.y + mFrameBG.height / 2 : height / 2;
               mSubComponentsContainer.addChild(mTierFrame);
               mTierFrame.visible = !this.hideFramesOnZoomInView();
            }
         }
      }
      
      override public function createFrameBG() : void
      {
         if(mBG != null || mBGAnimated != null)
         {
            if(mFrameBG == null)
            {
               mFrameBG = new CompositeFrame(mCardDef.getFrameRarityBGName());
            }
            if(mFactionFrameBG)
            {
               mFrameBG.scale = mFactionFrameBG.scale;
            }
            if(!mSubComponentsContainer.contains(mFrameBG))
            {
               mSubComponentsContainer.addChild(mFrameBG);
            }
         }
         if(mFrameBG)
         {
            mFrameBG.visible = !this.hideFramesOnZoomInView();
         }
      }
      
      public function createExtraInfoBlocks() : void
      {
         this.setHeightPercentages();
         this.createAttachmentsBlock();
         this.createSpecialAbilitiesBlockInfo();
         this.createDescriptionInfoBlock();
         this.createCardUpgradesThumbnails();
         this.createPromoteInfo();
         this.createWindowTitle();
         this.createCardEdition();
         this.createCraftButton();
         this.createCardSkinButton();
         this.createCardFusionButton();
         this.createAuctionButton();
         this.createCurrentAmountTextfield();
         this.createFavouriteButton();
      }
      
      private function createCurrentAmountTextfield() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSShopScreen)
         {
            if(this.mCurrentAmountTextfield == null)
            {
               _loc1_ = mFrameBG ? int(mFrameBG.width) : int(width);
               _loc2_ = height / 10;
               _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardAmount(mCardDef.getSku());
               _loc4_ = TextManager.getText("TID_GEN_AMOUNT_OWN") + " " + _loc3_;
               this.mCurrentAmountTextfield = new FSTextfield(_loc1_,_loc2_,_loc4_,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
               _loc5_ = this.showCardsBack() ? 1.05 : 1;
               _loc6_ = mFrameBG ? int(mFrameBG.y + mFrameBG.height * _loc5_) : int(height * _loc5_);
               this.mCurrentAmountTextfield.x = mFrameBG ? mFrameBG.x : width / 2;
               this.mCurrentAmountTextfield.y = _loc6_;
               addChild(this.mCurrentAmountTextfield);
            }
         }
      }
      
      private function createAuctionButton() : void
      {
         var _loc1_:FSDeckBuilderScreen = InstanceMng.getCurrentScreen() as FSDeckBuilderScreen;
         var _loc2_:Boolean = _loc1_ ? _loc1_.getEdidionStatus() == FSDeckBuilderScreen.STATUS_NOT_EDITING : false;
         var _loc3_:Boolean = _loc1_ ? !_loc1_.isViewAllCardsModeON() : false;
         var _loc4_:int = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
         if(Config.getConfig().gameHasAuctions() && _loc4_ >= Config.getConfig().getUnlockAuctionsLevel() && Utils.smInternetAvailable && InstanceMng.getServerConnection().isUserLoggedIn() && _loc1_ != null && _loc2_ && _loc3_ && this.mParentCard.getCardDef().isAllowedToSell())
         {
            if(this.mAuctionButton == null)
            {
               this.mAuctionButton = new FSButton(Root.assets.getTexture("auction_select_button_lit"),TextManager.getText("TID_AUCTIONS_CREATE_AUCTION"),null,true,null,Root.assets.getTexture("auction_select_button_unlit"));
               this.mAuctionButton.fontSize = 25;
               this.mAuctionButton.x = mFrameBG ? mFrameBG.x + mFrameBG.width / 2 : width / 2;
               this.mAuctionButton.y = mFrameBG ? mFrameBG.height + this.mAuctionButton.height : height + this.mAuctionButton.height / 2;
               this.mAuctionButton.addEventListener(Event.TRIGGERED,this.onAuctionTriggered);
               addChild(this.mAuctionButton);
            }
         }
      }
      
      protected function createFavouriteButton() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(mCardDef.getTier() != 1)
         {
            return;
         }
         if(this.mFavouriteButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().isCardInFavouritesCollection(mCardDef.getSku());
            this.mFavouriteButton = new FSToggleButton("button_favourite_off","button_favourite_on");
            if(_loc1_)
            {
               if(!this.mFavouriteButton.isToggled())
               {
                  this.mFavouriteButton.setToggled();
               }
            }
            else if(this.mFavouriteButton.isToggled())
            {
               this.mFavouriteButton.setToggled();
            }
            _loc2_ = mFrameBG ? int(mFrameBG.x + mFrameBG.width / 2 - this.mFavouriteButton.width / 2) : int(width / 2 - this.mFavouriteButton.width / 2);
            _loc3_ = mFrameBG ? int(mFrameBG.height + this.mFavouriteButton.height / 2) : int(height + this.mFavouriteButton.height / 2);
            _loc3_ = this.mCurrentAmountTextfield ? int(this.mCurrentAmountTextfield.y + this.mCurrentAmountTextfield.height) : _loc3_;
            if(this.mPromoteCostBlock)
            {
               _loc2_ = this.mPromoteCostBlock.x + this.mPromoteCostBlock.width / 2 - this.mFavouriteButton.width / 2;
               _loc3_ = this.mPromoteCostBlock.y - this.mPromoteCostBlock.height / 2;
            }
            else if(this.mCraftButton)
            {
               this.mCraftButton.x -= this.mFavouriteButton.width / 2;
               _loc2_ = this.mCraftButton.x + this.mCraftButton.width / 2;
               _loc3_ = this.mCraftButton.y - this.mCraftButton.height / 2;
            }
            else if(this.mCardFusionButton)
            {
               this.mCardFusionButton.x -= this.mFavouriteButton.width / 2;
               _loc2_ = this.mCardFusionButton.x + this.mCardFusionButton.width / 2;
               _loc3_ = this.mCardFusionButton.y - this.mCardFusionButton.height / 2;
            }
            else if(this.mAuctionButton)
            {
               this.mAuctionButton.x -= this.mFavouriteButton.width / 2;
               _loc2_ = this.mAuctionButton.x + this.mAuctionButton.width / 2;
               _loc3_ = this.mAuctionButton.y - this.mAuctionButton.height / 2;
            }
            else if(this.mCardSkinButton)
            {
               this.mCardSkinButton.x -= this.mFavouriteButton.width / 2;
               _loc2_ = this.mCardSkinButton.x + this.mCardSkinButton.width / 2;
               _loc3_ = this.mCardSkinButton.y - this.mCardSkinButton.height / 2;
            }
            this.mFavouriteButton.x = _loc2_;
            this.mFavouriteButton.y = _loc3_;
            this.mFavouriteButton.addEventListener(Event.TRIGGERED,this.onFavouritesTriggered);
            this.mFavouriteButton.setTooltipText(TextManager.getText("TID_GEN_FAVOURITE_ADD"));
            addChild(this.mFavouriteButton);
         }
      }
      
      private function onFavouritesTriggered(param1:Event) : void
      {
         var _loc2_:String = "";
         var _loc3_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isCardInFavouritesCollection(mCardDef.getSku());
         if(_loc3_)
         {
            InstanceMng.getUserDataMng().getOwnerUserData().removeCardFromFavouritesCollection(mCardDef.getSku());
            _loc2_ = TextManager.getText("TID_DB_FAVOURITE_REMOVED");
         }
         else
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addCardToFavouritesCollection(mCardDef.getSku());
            _loc2_ = TextManager.getText("TID_DB_FAVOURITE_ADDED");
         }
         Utils.setLogText(_loc2_);
         InstanceMng.getUserDataMng().updateFavouriteCardsCollection();
      }
      
      private function onAuctionTriggered(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.mAuctionPanel == null)
         {
            _loc2_ = DictionaryUtils.getCardsAmountPerCatalog(InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection());
            if(_loc2_ > Config.getConfig().getDeckCardsAmount())
            {
               this.mAuctionButton.visible = false;
               this.mAuctionPanel = new AuctionPanel(this.mParentCard,this);
               this.lockUI(true);
               InstanceMng.getCurrentScreen().addChild(this.mAuctionPanel);
            }
            else
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_AUCTIONS_MIN_CARDS"),[Config.getConfig().getMinCardsAmountForRecycling()]),true);
            }
         }
      }
      
      override protected function createTitle() : void
      {
      }
      
      protected function createAttachmentsBlock() : void
      {
         if(Config.getConfig().gameHasAttachments())
         {
            if(this.mParentCard is FSUnit && UnitDef(FSUnit(this.mParentCard).getCardDef()).getCanEquipItems())
            {
               if(this.mAttachmentsInfoBlock == null)
               {
                  this.mAttachmentsInfoBlock = new AttachmentsInfoBlock(FSUnit(this.mParentCard));
                  this.mAttachmentsInfoBlock.touchable = true;
                  this.mAttachmentsInfoBlock.x = -this.mAttachmentsInfoBlock.width * 1.3;
                  addChild(this.mAttachmentsInfoBlock);
               }
               this.mAttachmentsInfoBlock.updateCardsThumbnails();
            }
         }
      }
      
      protected function createSpecialAbilitiesBlockInfo() : void
      {
         var _loc1_:FSCard = null;
         var _loc4_:CardDef = null;
         if(this.mAbilitiesInfoBlocksCatalog != null || this.mAttachmentsAbilitiesInfoBlocksCatalog != null)
         {
            this.updateAbilityInfoBlocks();
            this.updateAttachments();
            this.manageScrollImageHighlighting();
            return;
         }
         this.fillTierCardsVector();
         var _loc2_:int = 1;
         var _loc3_:Vector.<CardDef> = this.mParentCard.getPreviousCardsDefs();
         if(_loc3_ != null)
         {
            for each(_loc4_ in _loc3_)
            {
               this.addCardDefAbilitiesToTotalAbilitiesVector(_loc4_);
            }
         }
         this.addCardAbilitiesToTotalAbilitiesVector(this);
         for each(_loc1_ in this.mTierCards)
         {
            this.addCardAbilitiesToTotalAbilitiesVector(_loc1_);
         }
         this.createAbilitiesBlock();
      }
      
      protected function createAbilitiesBlock() : void
      {
         var _loc1_:AbilityDef = null;
         var _loc2_:AbilityInfoBlock = null;
         var _loc3_:int = 0;
         var _loc4_:int = this.mAllCardsAbilities != null ? int(this.mAllCardsAbilities.length) : 0;
         var _loc5_:int = this.mParentCard.getCardDef().getTier();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc1_ = this.mAllCardsAbilities[_loc6_];
            if(_loc1_.isIconVisibleInXLView())
            {
               _loc3_ = this.getAbilityTier(_loc1_);
               _loc2_ = this.createAbInfoBlock(_loc1_,_loc5_,_loc3_);
               this.addAbBlockToScrollableContainer(_loc2_);
               this.addAbilityInfoBlock(_loc2_);
            }
            _loc6_++;
         }
         this.updateAttachments();
         if(this.mAbilitiesScrollContainer != null && this.mAbilitiesScrollContainer.numChildren > 0)
         {
            this.createSpecialAbilitiesBlockTitle();
         }
      }
      
      private function updateAttachments() : void
      {
         var _loc1_:AbilityDef = null;
         var _loc2_:AbilityInfoBlock = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc6_:Vector.<AbilityDef> = null;
         var _loc5_:int = this.mParentCard.getTier();
         this.removeAllAttachmentAbInfoBlocks();
         if(this.mParentCard is FSUnit)
         {
            _loc6_ = this.mParentCard.getUsableAbilitiesDefsFromAttachments();
            if(_loc6_ != null)
            {
               for each(_loc1_ in _loc6_)
               {
                  if(_loc1_.isIconVisibleInXLView())
                  {
                     _loc2_ = this.createAbInfoBlock(_loc1_,_loc5_,_loc5_,true);
                     this.addAbBlockToScrollableContainer(_loc2_);
                     this.addAbilityInfoBlock(_loc2_,true);
                     if(_loc1_.isParentAbility())
                     {
                        _loc3_ = _loc1_.getChildAbs();
                        _loc4_ = 0;
                        while(_loc4_ < _loc3_.length)
                        {
                           _loc1_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc3_[_loc4_]));
                           if(_loc1_.isIconVisibleInXLView())
                           {
                              _loc2_ = this.createAbInfoBlock(_loc1_,_loc5_,_loc5_,true);
                              this.addAbBlockToScrollableContainer(_loc2_);
                              this.addAbilityInfoBlock(_loc2_,true);
                           }
                           _loc4_++;
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function removeAllAttachmentAbInfoBlocks() : void
      {
         var _loc1_:AbilityInfoBlock = null;
         if(this.mAttachmentsAbilitiesInfoBlocksCatalog != null)
         {
            for each(_loc1_ in this.mAttachmentsAbilitiesInfoBlocksCatalog)
            {
               _loc1_.removeFromParent();
               _loc1_.destroy();
               delete this.mAttachmentsAbilitiesInfoBlocksCatalog[_loc1_.getAbilityDef().getSku()];
            }
         }
      }
      
      protected function addAbBlockToScrollableContainer(param1:AbilityInfoBlock) : void
      {
         var _loc2_:Number = NaN;
         if(param1 == null)
         {
            return;
         }
         this.createAbilitiesScrollContainer();
         if(this.mAbilitiesScrollContainer)
         {
            if(Utils.isIphone())
            {
               _loc2_ = Utils.isIphone4() ? 1.25 : 1.4;
               this.mAbilitiesScrollContainer.x = mFrameBG ? mFrameBG.x - param1.width * _loc2_ : mFactionFrameBG.x - param1.width * _loc2_;
            }
            else
            {
               this.mAbilitiesScrollContainer.x = mFrameBG ? mFrameBG.x - param1.width * 1.2 : mFactionFrameBG.x - param1.width * 1.2;
            }
            this.mAbilitiesScrollContainer.addChild(param1);
         }
         this.manageScrollImageHighlighting();
         if(Config.getConfig().XLViewHasCustomBG() && Utils.isAndroidOrDesktop() && Boolean(this.mAbilitiesScrollContainer))
         {
            this.mAbilitiesScrollContainer.x = mFrameBG ? mFrameBG.x - param1.width * 1.35 : mFactionFrameBG.x - param1.width * 1.35;
         }
      }
      
      protected function createAbilitiesScrollContainer(param1:Boolean = false) : void
      {
         var _loc2_:VerticalLayout = null;
         param1 ||= !Config.getConfig().XLViewShowsCardBack();
         if(this.mAbilitiesScrollContainer == null)
         {
            this.mAbilitiesScrollContainer = new ScrollContainer();
            if(!param1)
            {
               this.mAbilitiesHeightBlockPercent = this.mAttachmentsInfoBlock == null ? 100 : this.mAbilitiesHeightBlockPercent;
            }
            addChild(this.mAbilitiesScrollContainer);
            this.mAbilitiesScrollContainer.height = mFrameBG ? mFrameBG.height * 1.3 * (this.mAbilitiesHeightBlockPercent / 100) - ABILITIES_BLOCK_TITLE_HEIGHT : InstanceMng.getApplication().getFullScreenHeight() * 0.7 * (this.mAbilitiesHeightBlockPercent / 100) - ABILITIES_BLOCK_TITLE_HEIGHT;
            _loc2_ = new VerticalLayout();
            _loc2_.gap = 10;
            this.mAbilitiesScrollContainer.layout = _loc2_;
         }
      }
      
      private function manageScrollImageHighlighting() : void
      {
         if(this.mAbilitiesScrollContainer != null)
         {
            this.mAbilitiesScrollContainer.scrollBarDisplayMode = this.showCardsBack() ? ScrollBarDisplayMode.FLOAT : ScrollBarDisplayMode.FIXED;
         }
      }
      
      protected function createAbInfoBlock(param1:AbilityDef, param2:int, param3:int, param4:Boolean = false) : AbilityInfoBlock
      {
         return new AbilityInfoBlock(param1,param2,param3,this.mParentCard,param4);
      }
      
      protected function createSpecialAbilitiesBlockTitle() : void
      {
         var _loc1_:int = this.mAllCardsAbilities != null ? int(this.mAllCardsAbilities.length) : 0;
         _loc1_ += this.mAttachmentsAbilitiesInfoBlocksCatalog != null ? DictionaryUtils.getDictionaryLength(this.mAttachmentsAbilitiesInfoBlocksCatalog) : 0;
         if(_loc1_ > 0)
         {
            if(this.mAbilitiesBlockTitle == null)
            {
               this.mAbilitiesBlockTitle = new FSTextfield(Starling.current.stage.stageWidth / 3.7,ABILITIES_BLOCK_TITLE_HEIGHT,TextManager.getText("TID_GEN_ABILITIES"),16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               this.mAbilitiesBlockTitle.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            }
            this.mAbilitiesBlockTitle.x = mFrameBG ? mFrameBG.y - this.mAbilitiesBlockTitle.width * 1.25 : mFactionFrameBG.y - this.mAbilitiesBlockTitle.width * 1.25;
            if(this.mAttachmentsInfoBlock != null)
            {
               this.mAbilitiesBlockTitle.y = mFrameBG ? mFrameBG.y + ABILITIES_BLOCK_TITLE_HEIGHT + VERTICAL_SEPARATORS_HEIGHT + mFrameBG.height * 1.05 * ((100 - this.mAbilitiesHeightBlockPercent) / 100) : mFactionFrameBG.y + ABILITIES_BLOCK_TITLE_HEIGHT + VERTICAL_SEPARATORS_HEIGHT + mFactionFrameBG.height * 1.05 * ((100 - this.mAbilitiesHeightBlockPercent) / 100);
            }
            else
            {
               this.mAbilitiesBlockTitle.y = mFrameBG ? mFrameBG.y : mFactionFrameBG.y;
            }
            this.mAbilitiesScrollContainer.y = this.mAbilitiesBlockTitle.y + this.mAbilitiesBlockTitle.height + 10;
            addChild(this.mAbilitiesBlockTitle);
         }
      }
      
      protected function updateAbilityInfoBlocks() : void
      {
         var _loc1_:AbilityInfoBlock = null;
         var _loc2_:int = 0;
         if(this.mAbilitiesInfoBlocksCatalog != null)
         {
            for each(_loc1_ in this.mAbilitiesInfoBlocksCatalog)
            {
               if(_loc1_ != null)
               {
                  _loc1_.updateCurrentTier(this.mParentCard.getCardDef().getTier());
               }
            }
         }
      }
      
      protected function addAbilityInfoBlock(param1:AbilityInfoBlock, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         if(!param2)
         {
            if(this.mAbilitiesInfoBlocksCatalog == null)
            {
               this.mAbilitiesInfoBlocksCatalog = new Dictionary(true);
            }
            if(param1 != null)
            {
               _loc3_ = param1.getAbilityDef().getSku();
               if(this.mAbilitiesInfoBlocksCatalog[_loc3_] == null)
               {
                  this.mAbilitiesInfoBlocksCatalog[_loc3_] = param1;
               }
            }
         }
         else
         {
            if(this.mAttachmentsAbilitiesInfoBlocksCatalog == null)
            {
               this.mAttachmentsAbilitiesInfoBlocksCatalog = new Dictionary(true);
            }
            if(param1 != null)
            {
               _loc3_ = param1.getAbilityDef().getSku();
               if(this.mAttachmentsAbilitiesInfoBlocksCatalog[_loc3_] == null)
               {
                  this.mAttachmentsAbilitiesInfoBlocksCatalog[_loc3_] = param1;
               }
            }
         }
      }
      
      protected function getAbilityTier(param1:AbilityDef) : int
      {
         var _loc2_:FSCard = null;
         var _loc5_:CardDef = null;
         var _loc3_:int = 1;
         var _loc4_:Vector.<CardDef> = this.mParentCard.getPreviousCardsDefs();
         _loc3_ = this.getTierContainingAbilityDefInCardDefVector(param1,_loc4_);
         if(_loc3_ != -1)
         {
            return _loc3_;
         }
         _loc3_ = this.getTierContainingAbilityDefInCardDef(param1,this.mParentCard.getCardDef());
         if(_loc3_ != -1)
         {
            return _loc3_;
         }
         for each(_loc2_ in this.mTierCards)
         {
            _loc5_ = _loc2_.getCardDef();
            _loc3_ = this.getTierContainingAbilityDefInCardDef(param1,_loc5_);
            if(_loc3_ != -1)
            {
               return _loc3_;
            }
         }
         return _loc3_;
      }
      
      private function getTierContainingAbilityDefInCardDefVector(param1:AbilityDef, param2:Vector.<CardDef>) : int
      {
         var _loc4_:String = null;
         var _loc5_:CardDef = null;
         var _loc6_:Array = null;
         var _loc3_:int = -1;
         if(param2 != null)
         {
            for each(_loc5_ in param2)
            {
               if(this.getTierContainingAbilityDefInCardDef(param1,_loc5_) != -1)
               {
                  return _loc3_;
               }
            }
         }
         return _loc3_;
      }
      
      private function getTierContainingAbilityDefInCardDef(param1:AbilityDef, param2:CardDef) : int
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:AbilityDef = null;
         var _loc3_:int = -1;
         _loc5_ = param2.getAbilities();
         for each(_loc4_ in _loc5_)
         {
            _loc8_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc4_));
            if(_loc8_.isParentAbility())
            {
               if(param1.getSku() == _loc8_.getSku())
               {
                  return param2.getTier();
               }
               _loc7_ = _loc8_.getChildAbs();
               _loc6_ = 0;
               while(_loc6_ < _loc7_.length)
               {
                  if(param1.getSku() == _loc7_[_loc6_])
                  {
                     return param2.getTier();
                  }
                  _loc6_++;
               }
            }
            else if(param1.getSku() == _loc8_.getSku())
            {
               return param2.getTier();
            }
         }
         return _loc3_;
      }
      
      private function fillTierCardsVector() : void
      {
         var prevTierSku:String = null;
         var nextTierSku:String = null;
         var processTierCard:Function = function(param1:String, param2:Boolean):void
         {
            var _loc3_:CardDef = null;
            var _loc4_:FSCardPreview = null;
            var _loc5_:int = 0;
            while(param1 != null)
            {
               _loc4_ = InstanceMng.getCardsMng().createCardPreview(param1);
               mTierCards.push(_loc4_);
               _loc3_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
               if(param2)
               {
                  _loc5_++;
               }
               if(_loc3_)
               {
                  param1 = param2 ? _loc3_.getPreviousUpgradeSku() : _loc3_.getUpgradeSku();
               }
            }
            if(Boolean(param2) && Boolean(mTierCards) && _loc5_ == 2)
            {
               mTierCards.reverse();
            }
         };
         if(Boolean(this.mParentCard) && Boolean(this.mParentCard.getCardDef()))
         {
            this.mTierCards = new Vector.<FSCardPreview>();
            prevTierSku = this.mParentCard.getCardDef().getPreviousUpgradeSku();
            nextTierSku = this.mParentCard.getCardDef().getUpgradeSku();
            processTierCard(prevTierSku,true);
            processTierCard(nextTierSku,false);
         }
      }
      
      private function addCardAbilitiesToTotalAbilitiesVector(param1:FSCard) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:AbilityDef = null;
         var _loc5_:Vector.<AbilityDef> = null;
         var _loc6_:Ability = null;
         var _loc7_:Vector.<Ability> = null;
         if(param1 != null)
         {
            _loc2_ = 0;
            _loc5_ = param1.getParentAbilitiesDefs();
            if(_loc5_)
            {
               _loc3_ = int(_loc5_.length);
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  _loc4_ = _loc5_[_loc2_];
                  this.addAbilityDefToTotalAbilitiesVector(_loc4_);
                  _loc2_++;
               }
            }
            _loc7_ = param1.getAbilities();
            if(_loc7_ != null)
            {
               _loc3_ = int(_loc7_.length);
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  _loc6_ = _loc7_[_loc2_];
                  this.addAbilityDefToTotalAbilitiesVector(_loc6_.getAbilityDef());
                  _loc2_++;
               }
            }
         }
      }
      
      private function addCardDefAbilitiesToTotalAbilitiesVector(param1:CardDef) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:AbilityDef = null;
         if(param1 != null)
         {
            _loc2_ = param1.getAbilities();
            if(_loc2_ != null)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc2_[_loc3_]));
                  this.addAbilityDefToTotalAbilitiesVector(_loc4_);
                  _loc3_++;
               }
            }
         }
      }
      
      private function addAbilityDefToTotalAbilitiesVector(param1:AbilityDef) : void
      {
         var _loc2_:int = 0;
         if(Boolean(param1) && param1.isIconVisibleInXLView())
         {
            if(this.mAllCardsAbilities == null)
            {
               this.mAllCardsAbilities = new Vector.<AbilityDef>();
            }
            _loc2_ = 0;
            _loc2_ = 0;
            while(_loc2_ < this.mAllCardsAbilities.length)
            {
               if(AbilityDef(this.mAllCardsAbilities[_loc2_]).getSku() == param1.getSku())
               {
                  return;
               }
               _loc2_++;
            }
            this.mAllCardsAbilities.push(param1);
         }
      }
      
      protected function createCardUpgradesThumbnails() : void
      {
         if(Boolean(this.mParentCard) && Boolean(this.mParentCard.getCardDef()))
         {
            if(this.mCardUpgradesInfoBlock == null)
            {
               this.mCardUpgradesInfoBlock = new CardUpgradesInfoBlock(this.mParentCard,this.mTierCards);
               if(Config.getConfig().XLViewShowsFrames())
               {
                  this.mCardUpgradesInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width + 15 : width + 15;
               }
               this.mCardUpgradesInfoBlock.y = this.mDescriptionInfoBlock ? this.mDescriptionInfoBlock.y + this.mDescriptionInfoBlock.height * 1.05 : Starling.current.stage.stageHeight - this.mCardUpgradesInfoBlock.height * 1.05;
               if(!contains(this.mCardUpgradesInfoBlock))
               {
                  addChild(this.mCardUpgradesInfoBlock);
               }
            }
         }
         this.updateCardUpgradesThumbnails();
         this.refreshUpgradesThumbnailsVisibility();
      }
      
      private function updateCardUpgradesThumbnails() : void
      {
         var _loc1_:int = 0;
         if(this.mCardUpgradesInfoBlock != null)
         {
            if(this.mTierCards == null)
            {
               this.fillTierCardsVector();
            }
            _loc1_ = this.mParentCard.getCardDef().getTier();
            this.mCardUpgradesInfoBlock.updateCurrentTier(_loc1_);
         }
      }
      
      public function refreshUpgradesThumbnailsVisibility() : void
      {
         var _loc1_:Boolean = this.mParentCard.getCardDef().getTier() >= 1;
         if(this.mCardUpgradesInfoBlock != null)
         {
            this.mCardUpgradesInfoBlock.visible = _loc1_;
         }
         if(!Config.getConfig().XLViewShowsFrames())
         {
            if(Boolean(this.mCardUpgradesInfoBlock) && (mFrameBG != null || mBG != null || mBGAnimated != null))
            {
               this.mCardUpgradesInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.1 : width * 1.2;
               if(mFrameBG)
               {
                  this.mCardUpgradesInfoBlock.y = mFrameBG.y + mFrameBG.height * 0.85;
               }
               else
               {
                  this.mCardUpgradesInfoBlock.y = mBG ? mBG.y + mBG.height * 0.85 : mBGAnimated.y + mBGAnimated.height * 0.85;
               }
            }
         }
      }
      
      protected function createDescriptionInfoBlock() : void
      {
         var _loc1_:String = null;
         if(this.mDescriptionInfoBlock == null)
         {
            _loc1_ = "";
            _loc1_ = mCardDef.getDesc();
            this.mDescriptionInfoBlock = InstanceMng.getResourcesMng().createCardDescriptionInfoBlock(TextManager.getText("TID_GEN_DESCRIPTION"),_loc1_,this);
            this.mDescriptionInfoBlock.changeDescHeight(this.mDescBlockHeightPercent);
            if(Config.getConfig().XLViewShowsFrames())
            {
               if(Utils.isAndroidOrDesktop() || Utils.isIphone())
               {
                  this.mDescriptionInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.2 : width + width * 0.5;
               }
               else
               {
                  this.mDescriptionInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width + 15 : width + 15;
               }
               this.mDescriptionInfoBlock.y = mFrameBG ? mFrameBG.y : 0;
            }
            else
            {
               if(Utils.isAndroidOrDesktop() || Utils.isIphone())
               {
                  this.mDescriptionInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.15 : width + width * 0.5;
               }
               else
               {
                  this.mDescriptionInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.15 : width + 15;
               }
               this.mDescriptionInfoBlock.y = mFrameBG ? mFrameBG.y : 0;
            }
            if(!contains(this.mDescriptionInfoBlock))
            {
               addChild(this.mDescriptionInfoBlock);
            }
         }
      }
      
      protected function createPromoteInfo() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:BattleEngine = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:ColorArgb = null;
         var _loc7_:ColorArgb = null;
         if(Config.getConfig().XLViewHasPromoteButton())
         {
            _loc1_ = InstanceMng.getBattleEngine().getLevelDef().isUpgradeAllowed();
            _loc2_ = this.mParentCard && this.mParentCard.getCardDef().getTier() < 3 && !this.mParentCard.isEnemyCard() && _loc1_ && this.mParentCard.isOnBF();
            _loc3_ = InstanceMng.getBattleEngine();
            _loc4_ = _loc3_ != null && _loc3_.isOnlineMatch() ? _loc3_.isOwnerTurn() : true;
            if(_loc2_ && _loc4_)
            {
               if(this.mPromoteCostBlock == null && Boolean(mCardDef))
               {
                  _loc5_ = Config.getConfig().gameHasEmblems() && getCardDef() is UnitDef ? UnitDef(getCardDef()).getEmblemRequiredToPromote() : mCardDef.getUpgradeCost();
                  if(_loc5_ >= 0)
                  {
                     this.mPromoteCostBlock = new PromoteCostBlock(_loc5_,this.mParentCard);
                     this.mPromoteCostBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width / 2 - this.mPromoteCostBlock.width / 2 : width / 2 - this.mPromoteCostBlock.width / 2;
                     this.mPromoteCostBlock.y = mFrameBG ? mFrameBG.y + mFrameBG.height * 1.05 + this.mPromoteCostBlock.height / 2 : height + this.mPromoteCostBlock.height / 2;
                     addChild(this.mPromoteCostBlock);
                  }
               }
               if(this.mParentCard.canBePromoted())
               {
                  _loc6_ = new ColorArgb(0.9,1,0.2,1);
                  _loc7_ = new ColorArgb(0.3,0.6,0.5,0);
                  this.mPromoteCostBlock.activateSpecialHighlightParticle(_loc6_,_loc7_);
               }
            }
         }
      }
      
      public function refreshPromoteInfoVisibility() : void
      {
         var _loc1_:Boolean = this.mParentCard.getCardDef().getTier() < 3;
         if(this.mPromoteCostBlock)
         {
            this.mPromoteCostBlock.visible = _loc1_;
         }
      }
      
      override protected function canShowSummonCost() : Boolean
      {
         return mSummonTextfield == null && (getType() != TYPE_ACTION || getType() == TYPE_ACTION && Config.getConfig().cardShowSummonCostOnActions());
      }
      
      override protected function createSummonCostTextfield() : void
      {
         var _loc1_:Number = NaN;
         if(mType == FSCard.TYPE_POWER)
         {
            if(Config.getConfig().getShowSummonCost())
            {
               _loc1_ = !Utils.isTablet() ? 0.8 * Layout.getFontMultiplier() * 1.25 : Layout.getFontMultiplier();
               if(this.canShowSummonCost())
               {
                  if(mSummonTextfield == null)
                  {
                     mSummonTextfield = new FSTextfield(1,1,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
                     mSummonTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                     mSummonTextfield.touchable = false;
                     mSummonTextfield.alignPivot();
                     if(Utils.isIphone())
                     {
                        mSummonTextfield.x = mFrameSummonIcon.x - mFrameSummonIcon.width * 0.18;
                        mSummonTextfield.y = mFrameSummonIcon.y - mFrameSummonIcon.height * 0.18;
                     }
                     else
                     {
                        mSummonTextfield.x = mFrameSummonIcon.x;
                        mSummonTextfield.y = mFrameSummonIcon.y;
                     }
                     mSummonTextfield.width = mFrameSummonIcon.width * _loc1_;
                     mSummonTextfield.height = mFrameSummonIcon.height * _loc1_;
                  }
                  mSummonTextfield.text = String(getCardCostByType());
                  addChild(mSummonTextfield);
               }
            }
            this.setSummonPosition();
         }
         else
         {
            super.createSummonCostTextfield();
         }
      }
      
      private function setSummonPosition() : void
      {
         if(mFrameSummonIcon)
         {
            mFrameSummonIcon.x += this.mParentCard.width * 0.45;
            mFrameSummonIcon.y += this.mParentCard.height * 0.75;
         }
         if(mSummonTextfield)
         {
            mSummonTextfield.x = mFrameSummonIcon.x;
            mSummonTextfield.y = mFrameSummonIcon.y;
         }
      }
      
      override public function showDamageAndShield(param1:Boolean = false) : void
      {
         var _loc2_:int = mFrameBG ? int(mFrameBG.width / 3) : int(mFactionFrameBG.width / 3);
         var _loc3_:int = FSResourceMng.FONT_STD_TITLE_SIZE * 4.8;
         var _loc4_:Number = FSResourceMng.FONT_STD_BIG_TITLE_SIZE;
         var _loc5_:int = this.mParentCard ? this.mParentCard.getType() : 0;
         if(_loc5_ == FSCard.TYPE_POWER || _loc5_ == TYPE_ACTION)
         {
            return;
         }
         if(mDamageTextfield == null)
         {
            mDamageTextfield = new FSTextfield(_loc2_,_loc3_,"",16777215,_loc4_);
            switch(_loc5_)
            {
               case TYPE_UNIT:
                  mDamageTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  break;
               case TYPE_ATTACHMENT:
                  mDamageTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN);
            }
            mDamageTextfield.touchable = false;
         }
         if(mDefenseTextfield == null)
         {
            mDefenseTextfield = new FSTextfield(_loc2_,_loc3_,"",16777215,_loc4_);
            switch(_loc5_)
            {
               case TYPE_UNIT:
                  mDefenseTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
                  break;
               case TYPE_ATTACHMENT:
                  mDefenseTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN);
            }
            mDefenseTextfield.touchable = false;
         }
         if(mDamageImage == null)
         {
            mDamageImage = new FSImage(Root.assets.getTexture(DAMAGE_IMG_NAME));
            mDamageImage.touchable = false;
         }
         if(mDefenseImage == null)
         {
            mDefenseImage = new FSImage(Root.assets.getTexture(DEFENSE_IMG_NAME));
            mDefenseImage.touchable = false;
         }
         var _loc6_:int = this.mParentCard ? this.mParentCard.getCardDef().getDamage() : 0;
         var _loc7_:int = this.mParentCard ? this.mParentCard.getCardDef().getDefense() : 0;
         mDamageTextfield.text = _loc6_.toString();
         mDefenseTextfield.text = _loc7_.toString();
         addChild(mDamageImage);
         addChild(mDefenseImage);
         addChild(mDamageTextfield);
         addChild(mDefenseTextfield);
         setDamageDefenseTextfieldPosAndSize();
      }
      
      override protected function showUpgradeCost(param1:int = -1) : void
      {
         super.showUpgradeCost(this.mParentCard.mCardDef.getUpgradeCost());
      }
      
      public function createCardBack() : void
      {
         var _loc1_:String = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(mCardDef.getFactionSku())).getBackBGXLName();
         var _loc2_:Texture = Root.assets.getTexture(_loc1_);
         if(this.showCardsBack() && Boolean(_loc2_))
         {
            if(this.mBackCard == null && Boolean(mCardDef))
            {
               this.mBackCard = new FSImage(_loc2_);
               this.mBackCard.alignPivot();
               this.mBackCard.x = mFrameBG ? mFrameBG.x + mFrameBG.width / 2 : x + width / 2;
               this.mBackCard.y = mFrameBG ? mFrameBG.y + mFrameBG.height / 2 : y + height / 2;
               addChildAt(this.mBackCard,0);
               this.startCardBackFX();
            }
         }
      }
      
      private function startCardBackFX() : void
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:int = 0;
         if(Boolean(this.mBackCard) && Boolean(mFrameBG))
         {
            _loc1_ = new FSCoordinate(mFrameBG.x + mFrameBG.width / 2.75,mFrameBG.y + mFrameBG.height / 1.75);
            _loc2_ = -10;
            SpecialFX.tweenRotate(this.mBackCard,1,0,Sine.easeOut,-10);
            SpecialFX.createTransition(this.mBackCard,_loc1_,1,0,null,null,Sine.easeOut);
         }
      }
      
      public function safeXLDisposal() : void
      {
         var _loc1_:FSCardPreview = null;
         var _loc2_:AbilityInfoBlock = null;
         if(this.mCardUpgradesInfoBlock)
         {
            this.mCardUpgradesInfoBlock.unload();
            this.mCardUpgradesInfoBlock.removeFromParent();
            this.mCardUpgradesInfoBlock.destroy();
            this.mCardUpgradesInfoBlock = null;
         }
         if(this.mAbilitiesBlockTitle)
         {
            this.mAbilitiesBlockTitle.removeFromParent(true);
            this.mAbilitiesBlockTitle = null;
         }
         if(this.mDescriptionInfoBlock)
         {
            this.mDescriptionInfoBlock.removeFromParent(true);
            this.mDescriptionInfoBlock = null;
         }
         if(this.mTierCards)
         {
            for each(_loc1_ in this.mTierCards)
            {
               _loc1_.removeFromParent();
               _loc1_.destroy();
               _loc1_ = null;
            }
            Utils.destroyArray(this.mTierCards);
            this.mTierCards = null;
         }
         Utils.destroyArray(this.mAllCardsAbilities);
         this.mAllCardsAbilities = null;
         if(this.mAbilitiesInfoBlocksCatalog)
         {
            for each(_loc2_ in this.mAbilitiesInfoBlocksCatalog)
            {
               _loc2_.removeFromParent(true);
               _loc2_ = null;
            }
            DictionaryUtils.clearDictionary(this.mAbilitiesInfoBlocksCatalog);
            this.mAbilitiesInfoBlocksCatalog = null;
         }
         if(this.mAttachmentsInfoBlock)
         {
            this.mAttachmentsInfoBlock.removeFromParent();
            this.mAttachmentsInfoBlock = null;
         }
         if(this.mAttachmentsAbilitiesInfoBlocksCatalog)
         {
            this.removeAllAttachmentAbInfoBlocks();
            DictionaryUtils.clearDictionary(this.mAttachmentsAbilitiesInfoBlocksCatalog);
            this.mAttachmentsAbilitiesInfoBlocksCatalog = null;
         }
         if(this.mMainTitleTextfield)
         {
            this.mMainTitleTextfield.removeFromParent(true);
            this.mMainTitleTextfield = null;
         }
         if(this.mAbilitiesScrollContainer)
         {
            this.mAbilitiesScrollContainer.removeChildren();
            this.mAbilitiesScrollContainer.removeFromParent(true);
            this.mAbilitiesScrollContainer = null;
         }
         if(this.mTitleBanner)
         {
            this.mTitleBanner.removeFromParent();
            this.mTitleBanner = null;
         }
         if(this.mPromoteCostBlock)
         {
            this.mPromoteCostBlock.removeFromParent(true);
            this.mPromoteCostBlock = null;
         }
         if(this.mBackCard)
         {
            this.mBackCard.removeFromParent(true);
            this.mBackCard = null;
         }
         if(this.mEditionIcon)
         {
            this.mEditionIcon.removeFromParent();
            this.mEditionIcon.destroy();
            this.mEditionIcon = null;
         }
         if(this.mEditionTextfield)
         {
            this.mEditionTextfield.removeFromParent(true);
            this.mEditionTextfield = null;
         }
         if(this.mCraftPanel)
         {
            this.mCraftPanel.unload();
            this.mCraftPanel.removeFromParent();
            this.mCraftPanel.destroy();
            this.mCraftPanel = null;
         }
         if(this.mAuctionPanel)
         {
            this.mAuctionPanel.unload();
            this.mAuctionPanel.removeFromParent();
            this.mAuctionPanel.destroy();
            this.mAuctionPanel = null;
         }
         if(this.mCraftButton)
         {
            this.mCraftButton.removeFromParent(true);
            this.mCraftButton = null;
         }
         if(this.mAuctionButton)
         {
            this.mAuctionButton.removeFromParent(true);
            this.mAuctionButton = null;
         }
         if(this.mShareButton)
         {
            this.mShareButton.removeFromParent(true);
            this.mShareButton = null;
         }
         if(this.mFavouriteButton)
         {
            this.mFavouriteButton.removeFromParent(true);
            this.mFavouriteButton = null;
         }
         if(this.mCardSkinButton)
         {
            this.mCardSkinButton.removeFromParent(true);
            this.mCardSkinButton = null;
         }
         if(this.mCardFusionButton)
         {
            this.mCardFusionButton.removeFromParent(true);
            this.mCardFusionButton = null;
         }
         if(this.mCurrentAmountTextfield)
         {
            this.mCurrentAmountTextfield.removeFromParent(true);
            this.mCurrentAmountTextfield = null;
         }
         removeCardElemsFromDisplayList(false);
         removeEventListeners();
         mParentUserBattleInfo = null;
         mTempCardXL = null;
      }
      
      override protected function removeMainElements(param1:Boolean = false) : void
      {
         this.mIsShown = false;
         var _loc2_:Boolean = Config.getConfig().XLViewUsesXLTextures();
         param1 = true;
         if(mBG)
         {
            mBG.removeFromParent(param1);
            mBG = null;
         }
         if(mBGAnimated)
         {
            mBGAnimated.stop();
            Starling.juggler.remove(mBGAnimated);
            mBGAnimated.removeFromParent(param1);
            mBGAnimated = null;
         }
         if(mFrameBG)
         {
            mFrameBG.removeFromParent(param1);
            mFrameBG = null;
         }
         if(mFactionFrameBG)
         {
            mFactionFrameBG.removeFromParent(param1);
            mFactionFrameBG = null;
         }
         if(mBottomFrameBG)
         {
            mBottomFrameBG.removeFromParent(param1);
            mBottomFrameBG = null;
         }
         if(mTierFrame)
         {
            mTierFrame.removeFromParent(param1);
            mTierFrame = null;
         }
         if(this.mParticleSystem)
         {
            this.mParticleSystem.unload();
            this.mParticleSystem.removeFromParent(true);
            this.mParticleSystem = null;
         }
      }
      
      override public function dispose() : void
      {
         this.safeXLDisposal();
         super.dispose();
      }
      
      public function getParentCard() : FSCard
      {
         return this.mParentCard;
      }
      
      override public function isEnemyCard(param1:Boolean = false) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.mParentCard)
         {
            _loc2_ = this.mParentCard.isEnemyCard(param1);
         }
         return _loc2_;
      }
      
      override public function createFactionFrameBG() : void
      {
         var _loc1_:String = null;
         if(mCardDef)
         {
            _loc1_ = mCardDef.getFactionFrameBGName();
            if(_loc1_ != "" && _loc1_ != null)
            {
               setFactionFrameBG(_loc1_);
               if(!Config.getConfig().XLViewUsesXLTextures() && mFactionFrameBG != null)
               {
                  mFactionFrameBG.scale = Config.getConfig().getNoXLTexturesFactor() * 2;
                  if(mBottomFrameBG)
                  {
                     mBottomFrameBG.scale = mFactionFrameBG.scale;
                     mBottomFrameBG.x = mFactionFrameBG.x;
                     mBottomFrameBG.y = mFactionFrameBG.y + mFactionFrameBG.height - mBottomFrameBG.height;
                  }
               }
               if(mFactionFrameBG != null)
               {
                  if(!mSubComponentsContainer.contains(mFactionFrameBG))
                  {
                     mSubComponentsContainer.addChild(mFactionFrameBG);
                     if(mBottomFrameBG)
                     {
                        mSubComponentsContainer.addChild(mBottomFrameBG);
                     }
                  }
               }
            }
            if(mFactionFrameBG != null)
            {
               mFactionFrameBG.visible = !this.hideFramesOnZoomInView();
               if(!Utils.isLowPerformanceDevice())
               {
                  mFactionFrameBG.filter = Filters.requestFilter(Constants.FILTER_DROPSHADOW_CARD_BACK);
               }
            }
            if(mBottomFrameBG != null)
            {
               mBottomFrameBG.visible = !this.hideFramesOnZoomInView();
               if(!Utils.isLowPerformanceDevice())
               {
                  mBottomFrameBG.filter = Filters.requestFilter(Constants.FILTER_DROPSHADOW_CARD_BACK);
               }
            }
         }
      }
      
      override protected function createFusionIcon() : void
      {
      }
      
      public function hideFramesOnZoomInView() : Boolean
      {
         return !Config.getConfig().XLViewShowsFrames();
      }
      
      public function lockUI(param1:Boolean) : void
      {
         if(this.mCraftButton)
         {
            this.mCraftButton.touchable = !param1;
         }
         if(this.mCardSkinButton)
         {
            this.mCardSkinButton.touchable = !param1;
         }
         if(this.mCardFusionButton)
         {
            this.mCardFusionButton.touchable = !param1;
         }
      }
      
      override protected function createFrameSummonIcon() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:String = null;
         if(Config.getConfig().getShowSummonCost())
         {
            if(this.canShowSummonCost())
            {
               if(mFrameSummonIcon == null)
               {
                  _loc1_ = Root.assets.getTexture(FRAME_SUMMON_ICON_XL);
                  mFrameSummonIcon = new FSImage(_loc1_,false);
                  if(getType() == TYPE_POWER)
                  {
                     _loc2_ = Config.getConfig().cardPowerSummonCostPosition();
                     if(_loc2_ != "left")
                     {
                        mFrameSummonIcon.x = mFrameBG.x + mFrameBG.width / 2 - mFrameSummonIcon.width / 2;
                        mFrameSummonIcon.y = mFrameBG.y + mFrameBG.height - mFrameSummonIcon.height;
                     }
                  }
               }
               if(!mSubComponentsContainer.contains(mFrameSummonIcon))
               {
                  mSubComponentsContainer.addChild(mFrameSummonIcon);
               }
            }
         }
      }
   }
}

