package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.QuestsMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.QuestDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.DeckBuilderCard;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class CraftPanel extends Component implements FSModelUnloadableInterface
   {
      
      private static const TYPE_COST_GOLD:int = 0;
      
      private static const TYPE_COST_RAID_COINS:int = 1;
      
      private var mBG:FSImage;
      
      private var mTitleImage:FSImage;
      
      private var mCraftSign:FSImage;
      
      private var mLargeGoldReward:FSImage;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mCardsOriginTextfield:FSTextfield;
      
      private var mExtraCardsOriginTextfield:FSTextfield;
      
      private var mGoldToCraftTextfield:FSTextfield;
      
      private var mCraftButton:FSButton;
      
      private var mParentCard:FSCardPreview;
      
      private var mPreviousCard:FSCardPreview;
      
      private var mPreviousExtraCard:FSCardPreview;
      
      private var mNumCardsNeededToCraft:int;
      
      private var mNumExtraCardsNeeded:int;
      
      private var mNumCardsOwn:int;
      
      private var mNumExtraCardsOwn:int;
      
      private var mCurrencyNeededToCraft:int;
      
      private var mNumTotalDeckCards:int;
      
      private var mCraftMC:MovieClip;
      
      private var mCraftPanelStats1:Quad;
      
      private var mCraftPanelStats2:Quad;
      
      private var mCraftPanelStats3:Quad;
      
      private var mCraftPanelRank1:Quad;
      
      private var mCraftPanelRank2:Quad;
      
      private var mCraftPanelRank3:Quad;
      
      private var mCraftPanelStatsTitle:Quad;
      
      private var mCraftStatsTitleTextfield:FSTextfield;
      
      private var mCraftRankTextfield1:FSTextfield;
      
      private var mCraftRankTextfield2:FSTextfield;
      
      private var mCraftRankTextfield3:FSTextfield;
      
      private var mCraftUpgradePropRank1:CraftUpgradeProperties;
      
      private var mCraftUpgradePropRank2:CraftUpgradeProperties;
      
      private var mCraftUpgradePropRank3:CraftUpgradeProperties;
      
      private var mCraftStatInfo:FSButton;
      
      private var mCraftPanelInfo:CustomComponent;
      
      private var mIsVisibleCraftStatInfo:Boolean;
      
      private var mCraftAttackIcon:FSImage;
      
      private var mCraftAttackIconTF:FSTextfield;
      
      private var mCraftDefenseIcon:FSImage;
      
      private var mCraftDefenseIconTF:FSTextfield;
      
      private var mCraftSummonCostIcon:FSImage;
      
      private var mCraftSummonCostIconTF:FSTextfield;
      
      private var mCraftUpgradeCostIcon:FSImage;
      
      private var mCraftUpgradeCostIconTF:FSTextfield;
      
      private var mCraftAbilityIcon:FSImage;
      
      private var mCraftAbilityIconTF:FSTextfield;
      
      private var mIsCardSkin:Boolean;
      
      private var mIsCardFusion:Boolean;
      
      private var mTypeCost:int;
      
      private var mParentDeckBuilderCard:DeckBuilderCard;
      
      public function CraftPanel(param1:Boolean = false, param2:Boolean = false)
      {
         this.mIsCardSkin = param1;
         this.mIsCardFusion = param2;
         super();
      }
      
      private function init() : void
      {
         this.createBGImage();
         this.createBGTitle();
         this.createTitle();
         this.createCraftSign();
         this.createCards();
         this.createCardNumTextfield();
         this.addCraftSign();
         this.createCraftButton();
         this.createCraftPanelGold();
         if(this.mParentCard.getCardDef().getShowCraftUpdatePanel())
         {
            this.createCraftPanelStatsTitle();
            this.createCraftTitleTextfield();
            this.createCraftStatInfo();
            this.createCraftPanelRank();
            this.createCraftRankTextfields();
            this.createCraftPanelStats();
            this.createCraftUpgradeProperties();
         }
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).setCraftPanelShown(true);
         }
      }
      
      private function closePopupAndRemoveTranslucentBG() : void
      {
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).setCraftPanelShown(false);
         }
         InstanceMng.getPopupMng().closePopupShown();
         InstanceMng.getCurrentScreen().removeTranslucentBG();
      }
      
      private function createCraftStatInfo() : void
      {
         if(Boolean(this.mCraftPanelStatsTitle) && this.mCraftStatInfo == null)
         {
            this.mCraftStatInfo = new FSButton(Root.assets.getTexture("craft_stat_info"));
            this.mCraftStatInfo.x = this.mCraftPanelStatsTitle.x + this.mCraftPanelStatsTitle.width - this.mCraftStatInfo.width;
            this.mCraftStatInfo.y = this.mCraftPanelStatsTitle.y + this.mCraftStatInfo.height / 2;
            this.mCraftStatInfo.addEventListener(Event.TRIGGERED,this.onCraftStatInfoTriggered);
            addChild(this.mCraftStatInfo);
         }
      }
      
      private function onCraftStatInfoTriggered(param1:Event) : void
      {
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         var _loc3_:Boolean = false;
         if(_loc2_ is FSDeckBuilderScreen)
         {
            _loc3_ = FSDeckBuilderScreen(_loc2_).getCraftingON();
         }
         if(!_loc3_)
         {
            if(!this.isVisibleCraftStatInfo())
            {
               this.setVisibleCraftStatInfo(true);
               this.createCraftInfo();
            }
            else
            {
               this.setVisibleCraftStatInfo(false);
               this.unloadCraftInfo();
            }
         }
      }
      
      private function setVisibleCraftStatInfo(param1:Boolean) : void
      {
         this.mIsVisibleCraftStatInfo = param1;
      }
      
      private function isVisibleCraftStatInfo() : Boolean
      {
         return this.mIsVisibleCraftStatInfo;
      }
      
      private function unloadCraftInfo() : void
      {
         if(this.mCraftPanelInfo)
         {
            this.mCraftPanelInfo.removeFromParent();
            this.mCraftPanelInfo = null;
         }
         if(this.mCraftAttackIcon)
         {
            this.mCraftAttackIcon.removeFromParent();
            this.mCraftAttackIcon.destroy();
            this.mCraftAttackIcon = null;
         }
         if(this.mCraftAttackIconTF)
         {
            this.mCraftAttackIconTF.removeFromParent();
            this.mCraftAttackIconTF = null;
         }
         if(this.mCraftDefenseIcon)
         {
            this.mCraftDefenseIcon.removeFromParent();
            this.mCraftDefenseIcon.destroy();
            this.mCraftDefenseIcon = null;
         }
         if(this.mCraftDefenseIconTF)
         {
            this.mCraftDefenseIconTF.removeFromParent();
            this.mCraftDefenseIconTF = null;
         }
         if(this.mCraftSummonCostIcon)
         {
            this.mCraftSummonCostIcon.removeFromParent();
            this.mCraftSummonCostIcon.destroy();
            this.mCraftSummonCostIcon = null;
         }
         if(this.mCraftSummonCostIconTF)
         {
            this.mCraftSummonCostIconTF.removeFromParent();
            this.mCraftSummonCostIconTF = null;
         }
         if(this.mCraftUpgradeCostIcon)
         {
            this.mCraftUpgradeCostIcon.removeFromParent();
            this.mCraftUpgradeCostIcon.destroy();
            this.mCraftUpgradeCostIcon = null;
         }
         if(this.mCraftUpgradeCostIconTF)
         {
            this.mCraftUpgradeCostIconTF.removeFromParent();
            this.mCraftUpgradeCostIconTF = null;
         }
         if(this.mCraftAbilityIcon)
         {
            this.mCraftAbilityIcon.removeFromParent();
            this.mCraftAbilityIcon.destroy();
            this.mCraftAbilityIcon = null;
         }
         if(this.mCraftAbilityIconTF)
         {
            this.mCraftAbilityIconTF.removeFromParent();
            this.mCraftAbilityIconTF = null;
         }
      }
      
      private function createCraftInfo() : void
      {
         if(this.mCraftPanelInfo == null)
         {
            this.mCraftPanelInfo = Utils.createCustomBox("craft_panel_info",492);
            if(this.mCraftStatInfo)
            {
               this.mCraftPanelInfo.x = this.mCraftStatInfo.x + this.mCraftStatInfo.width * 0.7;
               this.mCraftPanelInfo.y = this.mCraftStatInfo.y - this.mCraftPanelInfo.height / 2;
            }
            addChild(this.mCraftPanelInfo);
         }
         if(Boolean(this.mCraftPanelInfo) && this.mCraftAttackIcon == null)
         {
            this.mCraftAttackIcon = new FSImage(Root.assets.getTexture("craft_stat_attack"));
            this.mCraftAttackIcon.x = this.mCraftPanelInfo.x + this.mCraftAttackIcon.width * 0.5;
            this.mCraftAttackIcon.y = this.mCraftPanelInfo.y + this.mCraftAttackIcon.height * 0.3;
            addChild(this.mCraftAttackIcon);
         }
         if(Boolean(this.mCraftPanelInfo) && Boolean(this.mCraftAttackIcon) && this.mCraftAttackIconTF == null)
         {
            this.mCraftAttackIconTF = new FSTextfield(this.mCraftPanelInfo.width * 0.7,this.mCraftPanelInfo.height * 0.2,TextManager.getText("TID_CRAFT_ATTACK"));
            this.mCraftAttackIconTF.x = this.mCraftAttackIcon.x + this.mCraftAttackIcon.width;
            this.mCraftAttackIconTF.y = this.mCraftAttackIcon.y;
            addChild(this.mCraftAttackIconTF);
         }
         if(Boolean(this.mCraftPanelInfo) && this.mCraftDefenseIcon == null)
         {
            this.mCraftDefenseIcon = new FSImage(Root.assets.getTexture("craft_stat_defense"));
            this.mCraftDefenseIcon.x = this.mCraftPanelInfo.x + this.mCraftDefenseIcon.width * 0.5;
            this.mCraftDefenseIcon.y = this.mCraftPanelInfo.y + this.mCraftDefenseIcon.height * 1.3;
            addChild(this.mCraftDefenseIcon);
         }
         if(Boolean(this.mCraftPanelInfo) && Boolean(this.mCraftDefenseIcon) && this.mCraftDefenseIconTF == null)
         {
            this.mCraftDefenseIconTF = new FSTextfield(this.mCraftPanelInfo.width * 0.7,this.mCraftPanelInfo.height * 0.2,TextManager.getText("TID_CRAFT_DEFENSE"));
            this.mCraftDefenseIconTF.x = this.mCraftDefenseIcon.x + this.mCraftDefenseIcon.width;
            this.mCraftDefenseIconTF.y = this.mCraftDefenseIcon.y;
            addChild(this.mCraftDefenseIconTF);
         }
         if(Boolean(this.mCraftPanelInfo) && this.mCraftSummonCostIcon == null)
         {
            this.mCraftSummonCostIcon = new FSImage(Root.assets.getTexture("craft_stat_summon"));
            this.mCraftSummonCostIcon.x = this.mCraftPanelInfo.x + this.mCraftSummonCostIcon.width * 0.5;
            this.mCraftSummonCostIcon.y = this.mCraftPanelInfo.y + this.mCraftSummonCostIcon.height * 2.3;
            addChild(this.mCraftSummonCostIcon);
         }
         if(Boolean(this.mCraftPanelInfo) && Boolean(this.mCraftSummonCostIcon) && this.mCraftSummonCostIconTF == null)
         {
            this.mCraftSummonCostIconTF = new FSTextfield(this.mCraftPanelInfo.width * 0.7,this.mCraftPanelInfo.height * 0.2,TextManager.getText("TID_CRAFT_SUMMON"));
            this.mCraftSummonCostIconTF.x = this.mCraftSummonCostIcon.x + this.mCraftSummonCostIcon.width;
            this.mCraftSummonCostIconTF.y = this.mCraftSummonCostIcon.y;
            addChild(this.mCraftSummonCostIconTF);
         }
         if(Boolean(this.mCraftPanelInfo) && this.mCraftUpgradeCostIcon == null)
         {
            this.mCraftUpgradeCostIcon = new FSImage(Root.assets.getTexture("craft_stat_promote"));
            this.mCraftUpgradeCostIcon.x = this.mCraftPanelInfo.x + this.mCraftUpgradeCostIcon.width * 0.5;
            this.mCraftUpgradeCostIcon.y = this.mCraftPanelInfo.y + this.mCraftUpgradeCostIcon.height * 3.3;
            addChild(this.mCraftUpgradeCostIcon);
         }
         if(Boolean(this.mCraftPanelInfo) && Boolean(this.mCraftUpgradeCostIcon) && this.mCraftUpgradeCostIconTF == null)
         {
            this.mCraftUpgradeCostIconTF = new FSTextfield(this.mCraftPanelInfo.width * 0.7,this.mCraftPanelInfo.height * 0.2,TextManager.getText("TID_CRAFT_PROMOTE"));
            this.mCraftUpgradeCostIconTF.x = this.mCraftUpgradeCostIcon.x + this.mCraftUpgradeCostIcon.width;
            this.mCraftUpgradeCostIconTF.y = this.mCraftUpgradeCostIcon.y;
            addChild(this.mCraftUpgradeCostIconTF);
         }
         if(Boolean(this.mCraftPanelInfo) && this.mCraftAbilityIcon == null)
         {
            this.mCraftAbilityIcon = new FSImage(Root.assets.getTexture("craft_stat_ability"));
            this.mCraftAbilityIcon.x = this.mCraftPanelInfo.x + this.mCraftAbilityIcon.width * 0.5;
            this.mCraftAbilityIcon.y = this.mCraftPanelInfo.y + this.mCraftAbilityIcon.height * 4.3;
            addChild(this.mCraftAbilityIcon);
         }
         if(Boolean(this.mCraftPanelInfo) && Boolean(this.mCraftAbilityIcon) && this.mCraftAbilityIconTF == null)
         {
            this.mCraftAbilityIconTF = new FSTextfield(this.mCraftPanelInfo.width * 0.7,this.mCraftPanelInfo.height * 0.2,TextManager.getText("TID_CRAFT_ABILITY"));
            this.mCraftAbilityIconTF.x = this.mCraftAbilityIcon.x + this.mCraftAbilityIcon.width;
            this.mCraftAbilityIconTF.y = this.mCraftAbilityIcon.y;
            addChild(this.mCraftAbilityIconTF);
         }
      }
      
      private function createCraftUpgradeProperties() : void
      {
         this.createCraftUpgradePropertiesRank1();
         this.createCraftUpgradePropertiesRank2();
         this.createCraftUpgradePropertiesRank3();
      }
      
      private function createCraftUpgradePropertiesRank3() : void
      {
         var _loc1_:String = null;
         var _loc2_:CardDef = null;
         var _loc3_:CardDef = null;
         if(Boolean(this.mCraftPanelStats3) && this.mCraftUpgradePropRank3 == null)
         {
            _loc1_ = "";
            if(this.mIsCardFusion)
            {
               _loc1_ = this.mParentCard.getCardDef().getFusionSku();
            }
            else if(this.mIsCardSkin)
            {
               _loc1_ = this.mParentCard.getCardDef().getCardSkinSku();
            }
            else
            {
               _loc1_ = this.mParentCard.getCardDef().getCraftSku();
            }
            _loc2_ = Utils.getTopTierCardDef(this.mParentCard.getCardDef().getSku());
            _loc3_ = Utils.getTopTierCardDef(_loc1_);
            if(Boolean(_loc2_ && _loc3_) && Boolean(_loc2_.getTier() == 3) && _loc3_.getTier() == 3)
            {
               this.mCraftUpgradePropRank3 = new CraftUpgradeProperties(_loc3_,_loc2_);
               if(this.mCraftUpgradePropRank3.hasSomeUpgrade())
               {
                  this.mCraftUpgradePropRank3.createUI();
                  this.mCraftUpgradePropRank3.x = this.mCraftPanelStats3.x;
                  this.mCraftUpgradePropRank3.y = this.mCraftPanelStats3.y;
                  addChild(this.mCraftUpgradePropRank3);
               }
            }
            else if(_loc2_ == null && this.mParentCard.getCardDef() is ActionDef)
            {
               this.mCraftUpgradePropRank3 = new CraftUpgradeProperties(CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc1_)),this.mParentCard.getCardDef(),true,3);
               if(this.mCraftUpgradePropRank3.hasSomeUpgrade())
               {
                  this.mCraftUpgradePropRank3.createUI();
                  this.mCraftUpgradePropRank3.x = this.mCraftPanelStats3.x;
                  this.mCraftUpgradePropRank3.y = this.mCraftPanelStats3.y;
                  addChild(this.mCraftUpgradePropRank3);
               }
            }
         }
      }
      
      private function createCraftUpgradePropertiesRank2() : void
      {
         var _loc1_:String = null;
         var _loc2_:CardDef = null;
         var _loc3_:CardDef = null;
         if(Boolean(this.mCraftPanelStats2) && this.mCraftUpgradePropRank2 == null)
         {
            if(this.mIsCardFusion)
            {
               _loc1_ = this.mParentCard.getCardDef().getFusionSku();
            }
            else if(this.mIsCardSkin)
            {
               _loc1_ = this.mParentCard.getCardDef().getCardSkinSku();
            }
            else
            {
               _loc1_ = this.mParentCard.getCardDef().getCraftSku();
            }
            _loc2_ = Utils.getNextTierCardDef(this.mParentCard.getCardDef().getSku());
            _loc3_ = Utils.getNextTierCardDef(_loc1_);
            if(Boolean(_loc2_) && Boolean(_loc3_))
            {
               if(_loc2_ is ActionDef)
               {
                  this.mCraftUpgradePropRank2 = new CraftUpgradeProperties(_loc3_,_loc2_,true,2);
               }
               else
               {
                  this.mCraftUpgradePropRank2 = new CraftUpgradeProperties(_loc3_,_loc2_);
               }
               if(this.mCraftUpgradePropRank2.hasSomeUpgrade())
               {
                  this.mCraftUpgradePropRank2.createUI();
                  this.mCraftUpgradePropRank2.x = this.mCraftPanelStats2.x;
                  this.mCraftUpgradePropRank2.y = this.mCraftPanelStats2.y;
                  addChild(this.mCraftUpgradePropRank2);
               }
            }
            else if(_loc2_ == null && this.mParentCard.getCardDef() is ActionDef)
            {
               this.mCraftUpgradePropRank2 = new CraftUpgradeProperties(CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc1_)),this.mParentCard.getCardDef(),true,2);
               if(this.mCraftUpgradePropRank2.hasSomeUpgrade())
               {
                  this.mCraftUpgradePropRank2.createUI();
                  this.mCraftUpgradePropRank2.x = this.mCraftPanelStats2.x;
                  this.mCraftUpgradePropRank2.y = this.mCraftPanelStats2.y;
                  addChild(this.mCraftUpgradePropRank2);
               }
            }
         }
      }
      
      private function createCraftUpgradePropertiesRank1() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mCraftPanelStats1) && this.mCraftUpgradePropRank1 == null)
         {
            if(this.mIsCardFusion)
            {
               _loc1_ = this.mParentCard.getCardDef().getFusionSku();
            }
            else if(this.mIsCardSkin)
            {
               _loc1_ = this.mParentCard.getCardDef().getCardSkinSku();
            }
            else
            {
               _loc1_ = this.mParentCard.getCardDef().getCraftSku();
            }
            if(this.mParentCard.getCardDef() is ActionDef)
            {
               this.mCraftUpgradePropRank1 = new CraftUpgradeProperties(CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc1_)),this.mParentCard.getCardDef(),true,1);
            }
            else
            {
               this.mCraftUpgradePropRank1 = new CraftUpgradeProperties(CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc1_)),this.mParentCard.getCardDef());
            }
            if(this.mCraftUpgradePropRank1.hasSomeUpgrade())
            {
               this.mCraftUpgradePropRank1.createUI();
               this.mCraftUpgradePropRank1.x = this.mCraftPanelStats1.x;
               this.mCraftUpgradePropRank1.y = this.mCraftPanelStats1.y;
               addChild(this.mCraftUpgradePropRank1);
            }
         }
      }
      
      private function createCraftRankTextfields() : void
      {
         this.createCraftRankTextfield1();
         this.createCraftRankTextfield2();
         this.createCraftRankTextfield3();
      }
      
      private function createCraftRankTextfield3() : void
      {
         if(Boolean(this.mCraftPanelRank3) && this.mCraftRankTextfield3 == null)
         {
            this.mCraftRankTextfield3 = new FSTextfield(this.mCraftPanelRank3.width,this.mCraftPanelRank3.height,TextManager.replaceParameters(TextManager.getText("TID_GEN_RANK"),["3"]));
            this.mCraftRankTextfield3.alignPivot();
            this.mCraftRankTextfield3.x = this.mCraftPanelRank3.x + this.mCraftRankTextfield3.width / 2;
            this.mCraftRankTextfield3.y = this.mCraftPanelRank3.y + this.mCraftRankTextfield3.height / 2;
            addChild(this.mCraftRankTextfield3);
         }
      }
      
      private function createCraftRankTextfield2() : void
      {
         if(Boolean(this.mCraftPanelRank1) && this.mCraftRankTextfield2 == null)
         {
            this.mCraftRankTextfield2 = new FSTextfield(this.mCraftPanelRank1.width,this.mCraftPanelRank1.height,TextManager.replaceParameters(TextManager.getText("TID_GEN_RANK"),["2"]));
            this.mCraftRankTextfield2.alignPivot();
            this.mCraftRankTextfield2.x = this.mCraftPanelRank2.x + this.mCraftRankTextfield2.width / 2;
            this.mCraftRankTextfield2.y = this.mCraftPanelRank2.y + this.mCraftRankTextfield2.height / 2;
            addChild(this.mCraftRankTextfield2);
         }
      }
      
      private function createCraftRankTextfield1() : void
      {
         if(Boolean(this.mCraftPanelRank1) && this.mCraftRankTextfield1 == null)
         {
            this.mCraftRankTextfield1 = new FSTextfield(this.mCraftPanelRank1.width,this.mCraftPanelRank1.height,TextManager.replaceParameters(TextManager.getText("TID_GEN_RANK"),["1"]));
            this.mCraftRankTextfield1.alignPivot();
            this.mCraftRankTextfield1.x = this.mCraftPanelRank1.x + this.mCraftRankTextfield1.width / 2;
            this.mCraftRankTextfield1.y = this.mCraftPanelRank1.y + this.mCraftRankTextfield1.height / 2;
            addChild(this.mCraftRankTextfield1);
         }
      }
      
      private function createCraftTitleTextfield() : void
      {
         if(Boolean(this.mCraftPanelStatsTitle) && this.mCraftStatsTitleTextfield == null)
         {
            this.mCraftStatsTitleTextfield = new FSTextfield(this.mCraftPanelStatsTitle.width * 0.75,this.mCraftPanelStatsTitle.height,TextManager.getText("TID_CRAFT_TITLE"));
            this.mCraftStatsTitleTextfield.x = this.mCraftPanelStatsTitle.x + this.mCraftStatsTitleTextfield.width * 0.08;
            this.mCraftStatsTitleTextfield.y = this.mCraftPanelStatsTitle.y;
            addChild(this.mCraftStatsTitleTextfield);
         }
      }
      
      private function createCraftPanelStatsTitle() : void
      {
         if(this.mCraftPanelStatsTitle == null)
         {
            this.mCraftPanelStatsTitle = new Quad(this.mBG.width * 0.9,31,0);
            this.mCraftPanelStatsTitle.alpha = 0.5;
            this.mCraftPanelStatsTitle.x = this.mBG.x + (this.mBG.width - this.mCraftPanelStatsTitle.width) / 2;
            this.mCraftPanelStatsTitle.y = this.mParentCard.y + this.mParentCard.height / 1.75;
            addChild(this.mCraftPanelStatsTitle);
         }
      }
      
      private function createCraftPanelRank() : void
      {
         if(this.mCraftPanelRank1 == null)
         {
            this.mCraftPanelRank1 = new Quad(this.mBG.width * 0.3,33,0);
            this.mCraftPanelRank1.alpha = 0.5;
            this.mCraftPanelRank1.x = this.mCraftPanelStatsTitle.x;
            this.mCraftPanelRank1.y = this.mCraftPanelStatsTitle.y + this.mCraftPanelStatsTitle.height * 1.05;
            addChild(this.mCraftPanelRank1);
         }
         if(this.mCraftPanelRank2 == null)
         {
            this.mCraftPanelRank2 = new Quad(this.mCraftPanelRank1.width,this.mCraftPanelRank1.height,0);
            this.mCraftPanelRank2.alpha = 0.5;
            this.mCraftPanelRank2.x = this.mCraftPanelRank1.x + this.mCraftPanelRank1.width + 3;
            this.mCraftPanelRank2.y = this.mCraftPanelRank1.y;
            addChild(this.mCraftPanelRank2);
         }
         if(this.mCraftPanelRank3 == null)
         {
            this.mCraftPanelRank3 = new Quad(this.mCraftPanelRank1.width - 6,this.mCraftPanelRank1.height,0);
            this.mCraftPanelRank3.alpha = 0.5;
            this.mCraftPanelRank3.x = this.mCraftPanelRank2.x + this.mCraftPanelRank2.width + 3;
            this.mCraftPanelRank3.y = this.mCraftPanelRank1.y;
            addChild(this.mCraftPanelRank3);
         }
      }
      
      private function createCraftPanelStats() : void
      {
         var _loc1_:int = 0;
         if(this.mCraftPanelStats1 == null)
         {
            _loc1_ = Utils.isIOS() ? int(this.mCraftPanelRank1.height * 2.5) : int(this.mCraftPanelRank1.height * 1.25);
            this.mCraftPanelStats1 = new Quad(this.mCraftPanelRank1.width,_loc1_,0);
            this.mCraftPanelStats1.alpha = 0.5;
            this.mCraftPanelStats1.x = this.mCraftPanelRank1.x;
            this.mCraftPanelStats1.y = this.mCraftPanelRank1.y + this.mCraftPanelRank1.height * 1.05;
            addChild(this.mCraftPanelStats1);
         }
         if(this.mCraftPanelStats2 == null)
         {
            this.mCraftPanelStats2 = new Quad(this.mCraftPanelRank2.width,this.mCraftPanelStats1.height,0);
            this.mCraftPanelStats2.alpha = 0.5;
            this.mCraftPanelStats2.x = this.mCraftPanelRank2.x;
            this.mCraftPanelStats2.y = this.mCraftPanelStats1.y;
            addChild(this.mCraftPanelStats2);
         }
         if(this.mCraftPanelStats3 == null)
         {
            this.mCraftPanelStats3 = new Quad(this.mCraftPanelRank3.width,this.mCraftPanelStats1.height,0);
            this.mCraftPanelStats3.alpha = 0.5;
            this.mCraftPanelStats3.x = this.mCraftPanelRank3.x;
            this.mCraftPanelStats3.y = this.mCraftPanelStats2.y;
            addChild(this.mCraftPanelStats3);
         }
      }
      
      private function createCraftAnimation(param1:int = 0) : void
      {
         var _loc2_:String = "anim_craft";
         var _loc3_:int = 20;
         var _loc4_:Vector.<Texture> = Root.assets.getTextures(_loc2_ + "_");
         if((Boolean(_loc4_)) && _loc4_.length > 0)
         {
            if(this.mCraftMC == null)
            {
               this.mCraftMC = new MovieClip(_loc4_,_loc3_);
               this.mCraftMC.touchable = false;
               this.mCraftMC.scale = 2;
            }
            Starling.juggler.add(this.mCraftMC);
            this.mCraftMC.stop();
            this.mCraftMC.visible = false;
            this.mCraftMC.alignPivot();
            this.mCraftMC.x = this.mParentCard.x;
            this.mCraftMC.y = this.mParentCard.y + this.mParentCard.height / 2 - this.mCraftMC.height / 2.15;
            addChild(this.mCraftMC);
         }
         else if(param1 < 3)
         {
            TweenMax.delayedCall(0.1,this.createCraftAnimation,[param1 + 1]);
         }
      }
      
      private function createCards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!this.mIsCardSkin && this.mParentCard != null && this.mParentCard.getCardDef().getCardRarity() != "rarity_01" || this.mIsCardSkin && this.mParentCard != null || this.mIsCardFusion && this.mParentCard != null)
         {
            _loc1_ = this.mParentCard.getType();
            if(this.mIsCardSkin && !this.mIsCardFusion)
            {
               _loc2_ = this.mParentCard.getCardDef().getCardSkinSku();
            }
            else if(!this.mIsCardSkin && this.mIsCardFusion)
            {
               _loc2_ = this.mParentCard.getCardDef().getFusionSku();
               _loc3_ = this.mParentCard.getCardDef().needsExtraFusionCard() ? this.mParentCard.getCardDef().getExtraFusionSku() : "";
            }
            else
            {
               _loc2_ = this.mParentCard.getCardDef().getCraftSku();
               _loc3_ = this.mParentCard.getCardDef().needsExtraCraftCard() ? this.mParentCard.getCardDef().getExtraCraftSku() : "";
            }
            if(_loc1_ == FSCard.TYPE_ACTION || _loc1_ == FSCard.TYPE_POWER)
            {
               this.mParentCard.showDamageAndShield(false);
            }
            if(_loc2_ != null && _loc2_ != "" && this.mPreviousCard == null)
            {
               this.mPreviousCard = InstanceMng.getCardsMng().createCardPreview(_loc2_);
            }
            if(_loc3_ != null && _loc3_ != "" && this.mPreviousExtraCard == null)
            {
               this.mPreviousExtraCard = InstanceMng.getCardsMng().createCardPreview(_loc3_);
            }
            if(this.mPreviousCard)
            {
               this.mPreviousCard.scale = this.mPreviousExtraCard ? 0.85 : 1;
            }
            if(this.mPreviousExtraCard)
            {
               this.mPreviousExtraCard.scale = this.mPreviousExtraCard ? 0.85 : 1;
            }
            _loc4_ = this.getSpaceBetweenCraftMaterials();
            if(this.mPreviousCard != null)
            {
               _loc6_ = this.mPreviousExtraCard ? this.mBG.x + this.mPreviousCard.width / 2 + _loc4_ : this.mBG.x + this.mPreviousCard.width / 2 + _loc4_;
               this.mPreviousCard.x = _loc6_;
               this.mPreviousCard.y = this.mPreviousCard.height / 2 + this.mBG.y + this.mBG.height * 0.15;
               addChild(this.mPreviousCard);
            }
            if(this.mPreviousExtraCard)
            {
               this.mPreviousExtraCard.x = this.mPreviousCard.x + this.mPreviousCard.width + _loc4_;
               this.mPreviousExtraCard.y = this.mPreviousCard.y;
               addChild(this.mPreviousExtraCard);
            }
            _loc5_ = this.mPreviousExtraCard ? this.mPreviousExtraCard.x + this.mPreviousExtraCard.width / 2 - this.mCraftSign.width / 2 + _loc4_ : this.mPreviousCard.x + this.mPreviousCard.width / 2 - this.mCraftSign.width / 2 + _loc4_;
            this.mParentCard.x = _loc5_ + this.mCraftSign.width + _loc4_ + this.mParentCard.width / 2;
            this.mParentCard.y = this.mPreviousCard.y - (this.mParentCard.height - this.mPreviousCard.height) / 2;
            addChild(this.mParentCard);
         }
      }
      
      private function getSpaceBetweenCraftMaterials() : int
      {
         var _loc1_:int = this.mPreviousCard.width + this.mCraftSign.width + this.mParentCard.width;
         _loc1_ += this.mPreviousExtraCard ? this.mPreviousExtraCard.width : 0;
         var _loc2_:int = this.mBG.width - _loc1_;
         return this.mPreviousExtraCard ? int(_loc2_ / 5) : int(_loc2_ / 4);
      }
      
      private function createCardNumTextfield() : void
      {
         if(this.mIsCardSkin)
         {
            return;
         }
         if(this.mCardsOriginTextfield == null)
         {
            this.mCardsOriginTextfield = new FSTextfield(this.mPreviousCard.width,this.mPreviousCard.height * 0.5,this.mNumCardsOwn + "/" + this.mNumCardsNeededToCraft);
            this.mCardsOriginTextfield.x = this.mPreviousCard.x - this.mPreviousCard.width / 2;
            this.mCardsOriginTextfield.y = this.mPreviousCard.y - this.mCardsOriginTextfield.height / 2;
            if(this.mNumCardsOwn < this.mNumCardsNeededToCraft)
            {
               this.mCardsOriginTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            }
         }
         addChild(this.mCardsOriginTextfield);
         if(this.mParentCard.getCardDef().needsExtraCraftCard() || this.mParentCard.getCardDef().needsExtraFusionCard())
         {
            if(this.mExtraCardsOriginTextfield == null)
            {
               this.mExtraCardsOriginTextfield = new FSTextfield(this.mPreviousExtraCard.width,this.mPreviousExtraCard.height * 0.5,this.mNumExtraCardsOwn + "/" + this.mNumExtraCardsNeeded);
               this.mExtraCardsOriginTextfield.x = this.mPreviousExtraCard.x - this.mPreviousExtraCard.width / 2;
               this.mExtraCardsOriginTextfield.y = this.mPreviousExtraCard.y - this.mExtraCardsOriginTextfield.height / 2;
               if(this.mNumExtraCardsOwn < this.mNumExtraCardsNeeded)
               {
                  this.mExtraCardsOriginTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
               }
            }
            addChild(this.mExtraCardsOriginTextfield);
         }
      }
      
      private function createCraftButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         if(this.mCraftButton == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getGold();
            if(this.mIsCardSkin && !this.mIsCardFusion)
            {
               _loc2_ = "cardSkin_button_lit";
               _loc3_ = TextManager.getText("TID_CARDSKIN");
            }
            else if(!this.mIsCardSkin && this.mIsCardFusion)
            {
               _loc2_ = "fusion_button_lit";
               _loc3_ = TextManager.getText("TID_CARDFUSION");
            }
            else
            {
               _loc2_ = "craft_button_lit";
               _loc3_ = TextManager.getText("TID_CRAFT_BUTTON");
            }
            this.mCraftButton = new FSButton(Root.assets.getTexture(_loc2_),_loc3_);
            _loc4_ = this.mParentCard.isQuestConditionOKForCraft();
            if(!_loc4_ || this.mNumCardsOwn < this.mNumCardsNeededToCraft || this.mNumExtraCardsOwn < this.mNumExtraCardsNeeded || _loc1_ < this.mCurrencyNeededToCraft || this.mParentCard.getCardDef().getCardRarity() == "rarity_01")
            {
               if(this.mIsCardSkin && !this.mIsCardFusion)
               {
                  this.mCraftButton.upState = Root.assets.getTexture("cardSkin_button_unlit");
               }
               else if(!this.mIsCardSkin && this.mIsCardFusion)
               {
                  this.mCraftButton.upState = Root.assets.getTexture("fusion_button_lit");
               }
               else
               {
                  this.mCraftButton.upState = Root.assets.getTexture("craft_button_unlit");
               }
            }
            this.mCraftButton.fontSize = 25;
            this.mCraftButton.alignPivot();
            this.mCraftButton.x = this.mBG.x + this.mBG.width / 2;
            this.mCraftButton.y = this.mBG.y + this.mBG.height - this.mCraftButton.height / 1.65;
            this.mCraftButton.addEventListener(Event.TRIGGERED,this.onCraftTriggered);
         }
         addChild(this.mCraftButton);
      }
      
      private function getCurrencyCost() : int
      {
         return this.mTypeCost == TYPE_COST_GOLD ? int(InstanceMng.getUserDataMng().getOwnerUserData().getGold()) : int(InstanceMng.getUserDataMng().getOwnerUserData().getRaidCoins());
      }
      
      private function onCraftTriggered(param1:Event) : void
      {
         var _loc7_:UserData = null;
         var _loc8_:int = 0;
         var _loc9_:RarityDef = null;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc12_:QuestDef = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc2_:Boolean = false;
         if(this.mCraftButton)
         {
            this.mCraftButton.enabled = false;
         }
         this.killTweensAndSetDefualtPosition();
         var _loc3_:int = this.getCurrencyCost();
         var _loc4_:Boolean = Boolean(this.mParentCard) && (this.mParentCard.getCardDef().needsExtraCraftCard() || this.mParentCard.getCardDef().needsExtraFusionCard()) ? this.mNumTotalDeckCards - (this.mNumCardsNeededToCraft + this.mNumExtraCardsNeeded) >= Config.getConfig().getDeckCardsAmount() : this.mNumTotalDeckCards - this.mNumCardsNeededToCraft >= Config.getConfig().getDeckCardsAmount();
         var _loc5_:Boolean = Boolean(this.mParentCard) && (this.mParentCard.getCardDef().needsExtraCraftCard() || this.mParentCard.getCardDef().needsExtraFusionCard()) ? this.mNumCardsOwn >= this.mNumCardsNeededToCraft && this.mNumExtraCardsOwn >= this.mNumExtraCardsNeeded : this.mNumCardsOwn >= this.mNumCardsNeededToCraft;
         var _loc6_:Boolean = this.mParentCard.isQuestConditionOKForCraft();
         if(InstanceMng.getServerConnection().isUserLoggedIn() && !PvPConnectionMng.smUserInPvPQueue && _loc4_ && _loc5_ && _loc3_ >= this.mCurrencyNeededToCraft && _loc6_)
         {
            _loc7_ = Utils.getOwnerUserData();
            _loc8_ = _loc7_ != null ? _loc7_.getCardAmount(this.mParentCard.getCardDef().getSku()) : 0;
            _loc9_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mParentCard.getCardDef().getCardRarity()));
            _loc10_ = _loc9_.getSku() == "rarity_08";
            if(_loc8_ >= 1 && _loc10_)
            {
               _loc11_ = TextManager.replaceParameters(TextManager.getText("TID_CRAFT_MAXIMUM_AMOUNT"),[_loc9_.getMaxAmountPerDeck()]);
               InstanceMng.getPopupMng().openConfirmationPopup(_loc11_,this.craftCard,this.closePopupAndRemoveTranslucentBG);
            }
            else
            {
               this.craftCard();
            }
         }
         else if(PvPConnectionMng.smUserInPvPQueue)
         {
            Utils.setLogText(TextManager.getText("TID_PVP_FEATURE_BLOCKED"),true);
            _loc2_ = true;
         }
         else if(!_loc6_)
         {
            _loc12_ = QuestDef(InstanceMng.getQuestsDefMng().getDefBySku(this.mParentCard.getCardDef().getCraftQuestSku()));
            _loc13_ = _loc12_ ? _loc12_.getDesc() : "???";
            _loc14_ = _loc12_ == null || Boolean(_loc12_) && Boolean(_loc12_.getBattlePassSeasonYear() == -1) ? "" : "-" + _loc12_.getBattlePassSeasonYear();
            _loc15_ = _loc12_ ? "#" + _loc12_.getBattlePassIndex() + " " + _loc13_ + " (" + TextManager.getText("TID_GEN_SEASON") + " " + _loc12_.getBattlePassSeason() + _loc14_ + ")" : "";
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_BP_CRAFT_UNLOCKED"),[_loc15_]),false,false,false);
            _loc2_ = true;
         }
         else if(!_loc4_)
         {
            Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_RECYCLE_BELOW_MIN"),[Config.getConfig().getDeckCardsAmount()]),true);
            _loc2_ = true;
         }
         else if(!_loc5_)
         {
            Utils.setLogText(TextManager.getText("TID_CRAFT_NO_CARDS"),true);
            if(this.mNumCardsOwn < this.mNumCardsNeededToCraft)
            {
               SpecialFX.createYoYoZoomTransition(this.mCardsOriginTextfield,1.3,1,4);
            }
            if(this.mNumExtraCardsOwn < this.mNumExtraCardsNeeded)
            {
               SpecialFX.createYoYoZoomTransition(this.mExtraCardsOriginTextfield,1.3,1,4);
            }
            _loc2_ = true;
         }
         else if(_loc3_ < this.mCurrencyNeededToCraft)
         {
            if(this.mTypeCost == TYPE_COST_GOLD)
            {
               Utils.setLogText(TextManager.getText("TID_GOLD_NOT_ENOUGH"),true);
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_RAID_POINTS_NOT_ENOUGH"),true);
            }
            SpecialFX.createYoYoZoomTransition(this.mGoldToCraftTextfield,1.3,1,4);
            _loc2_ = true;
         }
         else if(!Utils.smInternetAvailable || !InstanceMng.getServerConnection().isUserLoggedIn())
         {
            Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
            _loc2_ = true;
         }
         if(_loc2_ && Boolean(this.mCraftButton))
         {
            this.mCraftButton.enabled = true;
         }
      }
      
      private function killTweensAndSetDefualtPosition() : void
      {
         if(this.mCardsOriginTextfield)
         {
            TweenMax.killTweensOf(this.mCardsOriginTextfield);
            this.mCardsOriginTextfield.scaleX = 1;
            this.mCardsOriginTextfield.scaleY = 1;
            if(this.mPreviousCard)
            {
               this.mCardsOriginTextfield.x = this.mPreviousCard.x - this.mPreviousCard.width / 2;
               this.mCardsOriginTextfield.y = this.mPreviousCard.y - this.mCardsOriginTextfield.height / 2;
            }
         }
         if(this.mGoldToCraftTextfield)
         {
            TweenMax.killTweensOf(this.mGoldToCraftTextfield);
            this.mGoldToCraftTextfield.scaleX = 1;
            this.mGoldToCraftTextfield.scaleY = 1;
            if(this.mLargeGoldReward)
            {
               this.mGoldToCraftTextfield.x = this.mLargeGoldReward.x + this.mLargeGoldReward.width * 1.2;
               this.mGoldToCraftTextfield.y = this.mLargeGoldReward.y;
            }
         }
         if(this.mExtraCardsOriginTextfield)
         {
            TweenMax.killTweensOf(this.mExtraCardsOriginTextfield);
            this.mExtraCardsOriginTextfield.scaleX = 1;
            this.mExtraCardsOriginTextfield.scaleY = 1;
            if(this.mPreviousExtraCard)
            {
               this.mExtraCardsOriginTextfield.x = this.mPreviousExtraCard.x - this.mPreviousExtraCard.width / 2;
               this.mExtraCardsOriginTextfield.y = this.mPreviousExtraCard.y - this.mExtraCardsOriginTextfield.height / 2;
            }
         }
      }
      
      private function craftCard() : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(parent)
         {
            parent.addChild(this);
         }
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:FSDeckBuilderScreen = InstanceMng.getCurrentScreen() as FSDeckBuilderScreen;
         var _loc3_:Boolean = false;
         if(this.mIsCardSkin && !this.mIsCardFusion)
         {
            _loc4_ = this.mParentCard.getCardDef().getCardSkinSku();
         }
         else if(!this.mIsCardSkin && this.mIsCardFusion)
         {
            _loc4_ = this.mParentCard.getCardDef().getFusionSku();
            _loc5_ = this.mParentCard.getCardDef().needsExtraFusionCard() ? this.mParentCard.getCardDef().getExtraFusionSku() : "";
         }
         else
         {
            _loc4_ = this.mParentCard.getCardDef().getCraftSku();
            _loc5_ = this.mParentCard.getCardDef().needsExtraCraftCard() ? this.mParentCard.getCardDef().getExtraCraftSku() : "";
         }
         if(_loc4_ != "" && _loc1_.isCardInFavouritesCollection(_loc4_) || _loc5_ != "" && _loc1_.isCardInFavouritesCollection(_loc5_))
         {
            Utils.setLogText(TextManager.getText("TID_DB_FAVOURITE_DENIED"),true);
            _loc3_ = true;
            if(this.mCraftButton)
            {
               this.mCraftButton.enabled = true;
            }
            return;
         }
         if(Boolean(_loc2_ && _loc1_) && Boolean(this.mParentCard) && Boolean(this.mParentCard.getCardDef()))
         {
            if(this.mTypeCost == TYPE_COST_GOLD)
            {
               _loc1_.substractGold(-this.mCurrencyNeededToCraft,this.onCraftPayedSuccessfully,[_loc4_,this.mNumCardsNeededToCraft,_loc5_,this.mNumExtraCardsNeeded],this.onCraftPayedFailed);
            }
            else
            {
               _loc1_.substractRaidCoins(-this.mCurrencyNeededToCraft,this.onCraftPayedSuccessfully,[_loc4_,this.mNumCardsNeededToCraft,_loc5_,this.mNumExtraCardsNeeded],this.onCraftPayedFailed);
               if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
               {
                  FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).updateRaidCoinsVisor();
               }
            }
         }
      }
      
      private function onCraftPayedSuccessfully(param1:String, param2:int, param3:String, param4:int) : void
      {
         var _loc5_:UserData = null;
         var _loc10_:FSDeckBuilderScreen = null;
         var _loc11_:DeckBuilderCard = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:Array = null;
         _loc5_ = _loc5_ == null ? Utils.getOwnerUserData() : _loc5_;
         var _loc6_:CardDef = this.mParentCard ? this.mParentCard.getCardDef() : null;
         var _loc7_:String = _loc6_ ? _loc6_.getSku() : "";
         var _loc8_:String = param1 + ":" + param2;
         var _loc9_:String = param3 + ":" + param4;
         FSTracker.trackMiscAction(FSTracker.CATEGORY_CRAFT,FSTracker.ACTION_STARTED,{"sku":_loc7_});
         if(Boolean(_loc6_) && InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc10_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(Boolean((_loc10_) && _loc5_) && Boolean(this.mParentCard) && Boolean(_loc6_))
            {
               _loc10_.setCraftingON(true);
               _loc5_.addCardToCollection(_loc6_.getSku() + ":1");
               _loc5_.addCardToNewCardsCollection(_loc6_.getSku() + ":1");
               _loc5_.removeCardFromCollection(param1,param2);
               _loc5_.removeCardFromNewCardsCollection(param1,param2);
               InstanceMng.getUserDataMng().persistenceSaveData();
               InstanceMng.getServerConnection().addUserCraftedInstance(_loc6_.getSku(),_loc8_,_loc6_.getName());
               if(_loc9_ != "")
               {
                  _loc5_.removeCardFromCollection(param3,param4);
                  _loc5_.removeCardFromNewCardsCollection(param3,param4);
                  InstanceMng.getServerConnection().addUserCraftedInstance(_loc6_.getSku(),_loc9_,_loc6_.getName());
               }
               if(_loc10_.getCraftInfoPanel())
               {
                  _loc10_.getCraftInfoPanel().refreshCurrencyVisors();
               }
               Utils.playSound("craft_fx",SoundManager.TYPE_SFX);
               Utils.setStat(Constants.STAT_CARDS_CRAFTED,1);
               if(this.mIsCardSkin && !this.mIsCardFusion)
               {
                  InstanceMng.getServerConnection().trackCardCrafted(this.mCurrencyNeededToCraft,_loc6_.getCardSkinSku() + ":" + this.mNumCardsNeededToCraft,_loc6_.getSku());
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_ASPECT,FSTracker.ACTION_COMPLETED,{"sku":_loc6_.getSku()});
               }
               else if(!this.mIsCardSkin && this.mIsCardFusion)
               {
                  InstanceMng.getServerConnection().trackCardCrafted(this.mCurrencyNeededToCraft,_loc6_.getFusionSku() + ":" + this.mNumCardsNeededToCraft,_loc6_.getSku());
                  if(_loc6_.needsExtraFusionCard())
                  {
                     InstanceMng.getServerConnection().trackCardCrafted(this.mCurrencyNeededToCraft,_loc6_.getExtraFusionSku() + ":" + this.mNumExtraCardsNeeded,_loc6_.getSku());
                  }
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_FUSION,FSTracker.ACTION_COMPLETED,{"sku":_loc6_.getSku()});
               }
               else
               {
                  InstanceMng.getServerConnection().trackCardCrafted(this.mCurrencyNeededToCraft,_loc6_.getCraftSku() + ":" + this.mNumCardsNeededToCraft,_loc6_.getSku());
                  if(_loc6_.needsExtraCraftCard())
                  {
                     InstanceMng.getServerConnection().trackCardCrafted(this.mCurrencyNeededToCraft,_loc6_.getExtraCraftSku() + ":" + this.mNumExtraCardsNeeded,_loc6_.getSku());
                  }
                  FSTracker.trackMiscAction(FSTracker.CATEGORY_CRAFT,FSTracker.ACTION_COMPLETED,{"sku":_loc6_.getSku()});
               }
               if(Config.getConfig().hasQuests())
               {
                  if(InstanceMng.getQuestsMng())
                  {
                     _loc12_ = _loc6_.getFactionSku();
                     _loc13_ = _loc6_.getCardRarity();
                     _loc14_ = _loc6_.getCategorySku();
                     _loc15_ = _loc6_.getSubCategorySku() ? _loc6_.getSubCategorySku()[0] : "";
                     _loc16_ = _loc6_.getEditionSku();
                     _loc17_ = [QuestsMng.TARGET_CARD_RARITY + ":" + _loc13_,QuestsMng.TARGET_CARD_CATEGORY + ":" + _loc14_,QuestsMng.TARGET_CARD_SUBCATEGORY + ":" + _loc15_,QuestsMng.TARGET_CARD_FACTION + ":" + _loc12_,QuestsMng.TARGET_CARD_EDITION + ":" + _loc16_];
                     if(this.mIsCardFusion)
                     {
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_CARD_FUSION,1,true,_loc17_,null,null,-1,_loc12_);
                     }
                     else if(this.mIsCardSkin)
                     {
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_CARD_ASPECT,1,true,_loc17_,null,null,-1,_loc12_);
                     }
                     else
                     {
                        InstanceMng.getQuestsMng().addActionPerformed(QuestsMng.TARGET_CARD_CRAFT,1,true,_loc17_,null,null,-1,_loc12_);
                     }
                  }
               }
               _loc11_ = _loc10_.getCardInfoByCardSku(_loc6_.getSku());
               if(_loc11_)
               {
                  _loc11_.updateDeckCardInfoAfterCraft();
               }
               if(this.mCardsOriginTextfield)
               {
                  this.mCardsOriginTextfield.text = "";
               }
               if(this.mExtraCardsOriginTextfield)
               {
                  this.mExtraCardsOriginTextfield.text = "";
               }
               this.playAnimation();
            }
            else
            {
               FSTracker.trackMiscAction(FSTracker.CATEGORY_CRAFT,FSTracker.ACTION_KO);
            }
         }
      }
      
      private function onCraftPayedFailed() : void
      {
         Utils.setLogText(TextManager.getText("TID_CONNECTION_REQUIRED"),true);
         if(this.mCraftButton)
         {
            this.mCraftButton.enabled = true;
         }
      }
      
      private function playAnimation() : void
      {
         this.createCraftAnimation();
         if(this.mCraftMC)
         {
            this.mCraftMC.visible = true;
            this.mCraftMC.play();
            SpecialFX.tweenToAlpha(this.mCraftMC,1,2,1,this.onCraftAnimationComplete);
         }
      }
      
      private function onCraftAnimationComplete() : void
      {
         var _loc1_:FSDeckBuilderScreen = InstanceMng.getCurrentScreen() as FSDeckBuilderScreen;
         this.unload();
         if(_loc1_)
         {
            _loc1_.removeTranslucentBG(true);
            _loc1_.checkIfAnyCardCrafteable(true);
            _loc1_.refreshUI();
            _loc1_.fillCollections(true);
            _loc1_.setCraftingON(false);
            _loc1_.setCraftPanelShown(false);
         }
      }
      
      private function createCraftPanelGold() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(this.mLargeGoldReward == null)
         {
            _loc1_ = this.mIsCardFusion ? this.mParentCard.getCardDef().getFusionTypeCost() : this.mParentCard.getCardDef().getCraftTypeCost();
            _loc2_ = _loc1_ == TYPE_COST_RAID_COINS ? "large_raidpoints_reward" : "large_gold_reward";
            this.mLargeGoldReward = new FSImage(Root.assets.getTexture(_loc2_));
            this.mLargeGoldReward.x = this.mBG.width * 0.33 - this.mLargeGoldReward.width / 2;
            this.mLargeGoldReward.y = this.mCraftButton.y - this.mCraftButton.height * 2.5;
         }
         addChild(this.mLargeGoldReward);
         if(this.mGoldToCraftTextfield == null)
         {
            this.mGoldToCraftTextfield = new FSTextfield(this.mLargeGoldReward.width * 2,this.mLargeGoldReward.height);
            this.mGoldToCraftTextfield.x = this.mLargeGoldReward.x + this.mLargeGoldReward.width * 1.2;
            this.mGoldToCraftTextfield.y = this.mLargeGoldReward.y;
            _loc3_ = this.getCurrencyCost();
            this.mGoldToCraftTextfield.fontName = this.mCurrencyNeededToCraft < _loc3_ ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            this.mGoldToCraftTextfield.text = String(this.mCurrencyNeededToCraft);
         }
         addChild(this.mGoldToCraftTextfield);
      }
      
      private function createCraftSign() : void
      {
         if(this.mCraftSign == null)
         {
            this.mCraftSign = new FSImage(Root.assets.getTexture("craft_sign"));
            this.mCraftSign.scale = this.mParentCard.getCardDef().needsExtraCraftCard() || this.mParentCard.getCardDef().needsExtraFusionCard() ? 0.5 : 1;
         }
      }
      
      private function addCraftSign() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:FSCoordinate = null;
         if(this.mCraftSign)
         {
            _loc1_ = this.getSpaceBetweenCraftMaterials();
            _loc2_ = this.mPreviousExtraCard ? this.mPreviousExtraCard.x + this.mPreviousExtraCard.width / 2 - this.mCraftSign.width / 2 + _loc1_ : this.mPreviousCard.x + this.mPreviousCard.width / 2 - this.mCraftSign.width / 2 + _loc1_;
            this.mCraftSign.x = _loc2_;
            this.mCraftSign.y = this.mPreviousCard.y - this.mCraftSign.height / 2;
            _loc3_ = new FSCoordinate(this.mCraftSign.x + this.mCraftSign.width * 0.1,this.mCraftSign.y);
            SpecialFX.createYoYoTransition(this.mCraftSign,_loc3_,1,-1,null,Quint.easeInOut);
            addChild(this.mCraftSign);
         }
      }
      
      public function setupPanel(param1:FSCard) : void
      {
         this.mParentCard = InstanceMng.getCardsMng().createCardPreview(param1.getCardDef().getSku());
         this.calculateCardsNeeded();
         this.init();
         this.performOpeningFX();
      }
      
      private function calculateCardsNeeded() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:String = null;
         var _loc3_:String = "";
         _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
         this.mTypeCost = this.mIsCardFusion ? this.mParentCard.getCardDef().getFusionTypeCost() : this.mParentCard.getCardDef().getCraftTypeCost();
         if(this.mIsCardSkin && !this.mIsCardFusion)
         {
            this.mCurrencyNeededToCraft = this.mParentCard.getCardDef().getCardSkinCost();
            this.mNumCardsNeededToCraft = this.mParentCard.getCardDef().getCardSkinAmountCards();
            _loc2_ = this.mParentCard.getCardDef().getCardSkinSku();
         }
         else if(!this.mIsCardSkin && this.mIsCardFusion)
         {
            this.mCurrencyNeededToCraft = this.mParentCard.getCardDef().getFusionCost();
            this.mNumCardsNeededToCraft = this.mParentCard.getCardDef().getFusionAmountCards();
            _loc2_ = this.mParentCard.getCardDef().getFusionSku();
            if(this.mParentCard.getCardDef().needsExtraFusionCard())
            {
               this.mNumExtraCardsNeeded = this.mParentCard.getCardDef().getFusionAmountExtraCards();
               _loc3_ = this.mParentCard.getCardDef().getExtraFusionSku();
            }
         }
         else
         {
            this.mCurrencyNeededToCraft = this.mParentCard.getCardDef().getCraftCost();
            this.mNumCardsNeededToCraft = this.mParentCard.getCardDef().getCraftAmountCards();
            _loc2_ = this.mParentCard.getCardDef().getCraftSku();
            if(this.mParentCard.getCardDef().needsExtraCraftCard())
            {
               this.mNumExtraCardsNeeded = this.mParentCard.getCardDef().getExtraCraftAmountCards();
               _loc3_ = this.mParentCard.getCardDef().getExtraCraftSku();
            }
         }
         this.mNumCardsOwn = _loc1_[_loc2_];
         if(_loc3_ != "")
         {
            this.mNumExtraCardsOwn = _loc1_[_loc3_];
         }
         this.mNumTotalDeckCards = DictionaryUtils.getCardsAmountPerCatalog(_loc1_);
      }
      
      private function performOpeningFX() : void
      {
         x -= this.mBG.width;
         var _loc1_:FSCoordinate = new FSCoordinate(0,0);
         SpecialFX.createTransition(this,_loc1_,0.5,0);
      }
      
      private function createBGTitle() : void
      {
         if(this.mTitleImage == null)
         {
            this.mTitleImage = new FSImage(Root.assets.getTexture("db_side_panel_title"));
            this.mTitleImage.alignPivot();
            this.mTitleImage.x = this.mBG.x + this.mBG.width / 2;
            this.mTitleImage.y = this.mBG.y + this.mTitleImage.height / 2;
            addChild(this.mTitleImage);
         }
      }
      
      private function createTitle() : void
      {
         var _loc1_:String = null;
         if(this.mTitleTextfield == null)
         {
            _loc1_ = "";
            this.mTitleTextfield = new FSTextfield(this.mBG.width * 0.8,Starling.current.stage.stageHeight * 0.1);
            this.mTitleTextfield.alignPivot();
            this.mTitleTextfield.x = this.mTitleImage.x;
            this.mTitleTextfield.y = this.mTitleImage.y;
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mTitleTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            if(this.mIsCardSkin && !this.mIsCardFusion)
            {
               _loc1_ = TextManager.getText("TID_CARDSKIN_CARD");
            }
            else if(!this.mIsCardSkin && this.mIsCardFusion)
            {
               _loc1_ = TextManager.getText("TID_CARDFUSION_TITLE");
            }
            else
            {
               _loc1_ = TextManager.getText("TID_CRAFT_CARD");
            }
            this.mTitleTextfield.text = _loc1_;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function createBGImage() : void
      {
         this.mBG = new FSImage(Root.assets.getTexture("db_side_panel"));
         addChild(this.mBG);
      }
      
      public function unload(param1:Boolean = false) : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(param1);
            this.mBG = null;
         }
         if(this.mCardsOriginTextfield)
         {
            this.mCardsOriginTextfield.removeFromParent(true);
            this.mCardsOriginTextfield = null;
         }
         if(this.mExtraCardsOriginTextfield)
         {
            this.mExtraCardsOriginTextfield.removeFromParent(true);
            this.mExtraCardsOriginTextfield = null;
         }
         if(this.mCraftButton)
         {
            this.mCraftButton.removeEventListener(Event.TRIGGERED,this.onCraftTriggered);
            this.mCraftButton.removeFromParent(param1);
            this.mCraftButton = null;
         }
         if(this.mCraftSign)
         {
            this.mCraftSign.removeFromParent(param1);
            this.mCraftSign = null;
         }
         if(this.mParentCard)
         {
            this.mParentCard.removeFromParent();
            this.mParentCard = null;
         }
         if(this.mPreviousCard)
         {
            this.mPreviousCard.removeFromParent();
            this.mPreviousCard = null;
         }
         if(this.mPreviousExtraCard)
         {
            this.mPreviousExtraCard.removeFromParent();
            this.mPreviousExtraCard = null;
         }
         if(this.mCraftMC)
         {
            this.mCraftMC.stop();
            Starling.juggler.remove(this.mCraftMC);
            this.mCraftMC.removeFromParent(param1);
            this.mCraftMC = null;
         }
         if(this.mCraftUpgradePropRank1)
         {
            this.mCraftUpgradePropRank1.unload();
            this.mCraftUpgradePropRank1.removeFromParent(true);
            this.mCraftUpgradePropRank1 = null;
         }
         if(this.mCraftUpgradePropRank2)
         {
            this.mCraftUpgradePropRank2.unload();
            this.mCraftUpgradePropRank2.removeFromParent(true);
            this.mCraftUpgradePropRank2 = null;
         }
         if(this.mCraftUpgradePropRank3)
         {
            this.mCraftUpgradePropRank3.unload();
            this.mCraftUpgradePropRank3.removeFromParent(true);
            this.mCraftUpgradePropRank3 = null;
         }
         if(this.mCraftPanelStats1)
         {
            this.mCraftPanelStats1.removeFromParent(true);
            this.mCraftPanelStats1 = null;
         }
         if(this.mCraftPanelStats2)
         {
            this.mCraftPanelStats2.removeFromParent(true);
            this.mCraftPanelStats2 = null;
         }
         if(this.mCraftPanelStats3)
         {
            this.mCraftPanelStats3.removeFromParent(true);
            this.mCraftPanelStats3 = null;
         }
         if(this.mCraftPanelRank1)
         {
            this.mCraftPanelRank1.removeFromParent(true);
            this.mCraftPanelRank1 = null;
         }
         if(this.mCraftPanelRank2)
         {
            this.mCraftPanelRank2.removeFromParent(true);
            this.mCraftPanelRank2 = null;
         }
         if(this.mCraftPanelRank3)
         {
            this.mCraftPanelRank3.removeFromParent(true);
            this.mCraftPanelRank3 = null;
         }
         if(this.mCraftPanelStatsTitle)
         {
            this.mCraftPanelStatsTitle.removeFromParent(true);
            this.mCraftPanelStatsTitle = null;
         }
         if(this.mCraftStatsTitleTextfield)
         {
            this.mCraftStatsTitleTextfield.removeFromParent(true);
            this.mCraftStatsTitleTextfield = null;
         }
         if(this.mCraftRankTextfield1)
         {
            this.mCraftRankTextfield1.removeFromParent(true);
            this.mCraftRankTextfield1 = null;
         }
         if(this.mCraftRankTextfield2)
         {
            this.mCraftRankTextfield2.removeFromParent(true);
            this.mCraftRankTextfield2 = null;
         }
         if(this.mCraftRankTextfield3)
         {
            this.mCraftRankTextfield3.removeFromParent(true);
            this.mCraftRankTextfield3 = null;
         }
         if(this.mCraftStatInfo)
         {
            this.mCraftStatInfo.removeEventListener(Event.TRIGGERED,this.onCraftStatInfoTriggered);
            this.mCraftStatInfo.removeFromParent(param1);
            this.mCraftStatInfo = null;
         }
         if(this.mCraftPanelInfo)
         {
            this.mCraftPanelInfo.removeFromParent(param1);
            this.mCraftPanelInfo = null;
         }
         if(this.mCraftAttackIcon)
         {
            this.mCraftAttackIcon.removeFromParent(param1);
            this.mCraftAttackIcon = null;
         }
         if(this.mCraftAttackIconTF)
         {
            this.mCraftAttackIconTF.removeFromParent(true);
            this.mCraftAttackIconTF = null;
         }
         if(this.mCraftDefenseIcon)
         {
            this.mCraftDefenseIcon.removeFromParent(param1);
            this.mCraftDefenseIcon = null;
         }
         if(this.mCraftDefenseIconTF)
         {
            this.mCraftDefenseIconTF.removeFromParent(true);
            this.mCraftDefenseIconTF = null;
         }
         if(this.mCraftSummonCostIcon)
         {
            this.mCraftSummonCostIcon.removeFromParent(param1);
            this.mCraftSummonCostIcon = null;
         }
         if(this.mCraftSummonCostIconTF)
         {
            this.mCraftSummonCostIconTF.removeFromParent(true);
            this.mCraftSummonCostIconTF = null;
         }
         if(this.mCraftUpgradeCostIcon)
         {
            this.mCraftUpgradeCostIcon.removeFromParent(param1);
            this.mCraftUpgradeCostIcon = null;
         }
         if(this.mCraftUpgradeCostIconTF)
         {
            this.mCraftUpgradeCostIconTF.removeFromParent(true);
            this.mCraftUpgradeCostIconTF = null;
         }
         if(this.mCraftAbilityIcon)
         {
            this.mCraftAbilityIcon.removeFromParent(param1);
            this.mCraftAbilityIcon = null;
         }
         if(this.mCraftAbilityIconTF)
         {
            this.mCraftAbilityIconTF.removeFromParent(true);
            this.mCraftAbilityIconTF = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mLargeGoldReward)
         {
            this.mLargeGoldReward.removeFromParent(true);
            this.mLargeGoldReward = null;
         }
         if(this.mTitleImage)
         {
            this.mTitleImage.removeFromParent(true);
            this.mTitleImage = null;
         }
         this.mParentDeckBuilderCard = null;
      }
      
      public function setDeckBuilderCard(param1:DeckBuilderCard) : void
      {
         this.mParentDeckBuilderCard = param1;
      }
      
      override public function dispose() : void
      {
         this.unload(true);
         super.dispose();
      }
      
      public function destroy() : void
      {
         this.unload(false);
      }
   }
}

