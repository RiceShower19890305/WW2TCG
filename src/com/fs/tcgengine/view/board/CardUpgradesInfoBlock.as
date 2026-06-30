package com.fs.tcgengine.view.board
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardPreview;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.cards.FSInfoCardXL;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Sprite;
   import starling.extensions.ColorArgb;
   
   public class CardUpgradesInfoBlock extends Component implements FSModelUnloadableInterface
   {
      
      private var mTitleTextfield:FSTextfield;
      
      private var mTitle:String;
      
      private var mReferenceCard:FSCard;
      
      private var mCardPanel:Sprite;
      
      private var mTierCards:Vector.<FSCardPreview>;
      
      private var mCurrentTier:int;
      
      private var mCardsInPanelCatalog:Dictionary;
      
      public function CardUpgradesInfoBlock(param1:FSCard, param2:Vector.<FSCardPreview>)
      {
         super();
         this.mReferenceCard = param1;
         this.mTierCards = param2;
         this.init();
      }
      
      public function updateCurrentTier(param1:int) : void
      {
         this.mCurrentTier = param1;
         this.updateTierCards();
         this.highlightNextUpgradeCard();
      }
      
      private function updateTierCards() : void
      {
         var _loc1_:FSCard = null;
         var _loc2_:String = null;
         var _loc4_:int = 0;
         var _loc3_:String = this.mReferenceCard.getCardDef().getSku();
         if(this.mTierCards != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.mTierCards.length)
            {
               _loc1_ = this.mTierCards[_loc4_];
               _loc2_ = _loc1_.getCardDef().getSku();
               if(_loc2_ == _loc3_)
               {
                  this.mTierCards.splice(_loc4_,1);
                  this.removeCardFromPanel(_loc2_);
               }
               _loc4_++;
            }
         }
      }
      
      private function init() : void
      {
         this.mTitle = TextManager.getText("TID_GEN_NEXT_RANK");
         this.createTitle();
         this.createCardsThumbnails();
      }
      
      private function createTitle() : void
      {
         var _loc1_:int = int(this.mTierCards.length);
         if(_loc1_ > 0)
         {
            if(this.mTitleTextfield == null)
            {
               this.mTitleTextfield = new FSTextfield(Starling.current.stage.stageWidth / 3.5,FSResourceMng.FONT_STD_TITLE_SIZE,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
               this.mTitleTextfield.text = this.mTitle.toUpperCase();
            }
            this.mTitleTextfield.x = 0;
            this.mTitleTextfield.y = 0;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function createCardsThumbnails() : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSCoordinate = null;
         var _loc4_:FSCard = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:int = this.mTierCards ? int(this.mTierCards.length) : 0;
         if(_loc1_ > 0)
         {
            if(this.mCardPanel == null)
            {
               this.mCardPanel = new Sprite();
               this.mCardPanel.y = 0;
            }
            _loc5_ = Starling.current.stage.stageWidth / 3.5;
            _loc6_ = 0;
            if(Boolean(this.mReferenceCard && this.mReferenceCard.getTempCardXL() && this.mReferenceCard.getTempCardXL().getFrameBG()) && Boolean(this.mTitleTextfield) && Boolean(this.mTitleTextfield.height))
            {
               _loc6_ = this.mReferenceCard.getTempCardXL().getFrameBG().height * (FSCardXL.ATTACHMENTS_BLOCK_HEIGHT_PERCENTAGE / 100) - this.mTitleTextfield.height;
            }
            else
            {
               _loc6_ = Starling.current.stage.stageHeight / 3;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc4_ = this.mTierCards[_loc2_];
               if(_loc4_)
               {
                  _loc3_ = Utils.getXYPositionInContainer(_loc2_,_loc4_.width,_loc4_.height,_loc5_,_loc6_,_loc1_,1,true);
                  _loc4_.x = _loc3_.getX() + _loc4_.width / 2;
                  _loc4_.y = this.mTitleTextfield ? this.mTitleTextfield.y + this.mTitleTextfield.height + _loc4_.height / 2 : _loc4_.height / 2;
                  this.mCardPanel.addChild(_loc4_);
                  this.addCardToPanelCatalog(_loc4_);
               }
               _loc2_++;
            }
            addChild(this.mCardPanel);
         }
      }
      
      public function highlightNextUpgradeCard() : void
      {
         var _loc6_:UserBattleInfo = null;
         var _loc7_:Boolean = false;
         var _loc8_:ColorArgb = null;
         var _loc9_:ColorArgb = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc1_:Boolean = InstanceMng.getCurrentScreen() is FSBattleScreen;
         var _loc2_:Boolean = parent is FSCardXL && !(parent is FSInfoCardXL) && this.mReferenceCard != null && !this.mReferenceCard.isEnemyCard() && this.mReferenceCard.canBePromoted();
         var _loc3_:Boolean = this.mCardPanel != null && this.mCardPanel.getChildAt(0) != null;
         var _loc4_:Boolean = Config.getConfig().XLViewHasPromoteButton();
         var _loc5_:Boolean = _loc1_ && Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().getLevelDef().isUpgradeAllowed();
         if(_loc3_ && _loc1_ && _loc2_ && _loc4_ && _loc5_)
         {
            _loc6_ = this.mReferenceCard.getParentUserBattleInfo();
            _loc7_ = InstanceMng.getBattleEngine().isOwnerTurn();
            if(_loc6_.isOwnerBattleInfo() && _loc7_ || !_loc6_.isOwnerBattleInfo() && !_loc7_ && InstanceMng.getBattleEngine().isPvPMatch())
            {
               _loc8_ = new ColorArgb(0.9,1,0.2,1);
               _loc9_ = new ColorArgb(0.3,0.6,0.5,0);
               _loc10_ = this.mReferenceCard.getCardDef().getTier();
               _loc11_ = _loc10_ == 1 ? 0 : 1;
               if(FSCard(this.mCardPanel.getChildAt(_loc11_)) != null)
               {
                  FSCard(this.mCardPanel.getChildAt(_loc11_)).activateSpecialHighlightParticle(_loc8_,_loc9_);
               }
            }
         }
      }
      
      public function unhighlightCards() : void
      {
         var _loc1_:FSCard = null;
         for each(_loc1_ in this.mCardsInPanelCatalog)
         {
            _loc1_.deactivateSpecialHighlightParticle();
         }
      }
      
      private function addCardToPanelCatalog(param1:FSCard) : void
      {
         var _loc2_:String = null;
         if(this.mCardsInPanelCatalog == null)
         {
            this.mCardsInPanelCatalog = new Dictionary(true);
         }
         if(param1 != null)
         {
            _loc2_ = param1.getCardDef().getSku();
            if(this.mCardsInPanelCatalog[_loc2_] == null)
            {
               this.mCardsInPanelCatalog[_loc2_] = param1;
            }
         }
      }
      
      private function removeCardFromPanel(param1:String) : void
      {
         var _loc2_:FSCard = null;
         if(this.mCardsInPanelCatalog != null)
         {
            _loc2_ = this.mCardsInPanelCatalog[param1];
            if(_loc2_ != null)
            {
               if(this.mCardPanel != null)
               {
                  if(this.mCardPanel.contains(_loc2_))
                  {
                     _loc2_.removeFromParent();
                     this.relocateTierCards();
                  }
               }
            }
         }
      }
      
      private function relocateTierCards() : void
      {
         var _loc1_:FSCard = null;
         var _loc2_:int = 0;
         var _loc3_:FSCoordinate = null;
         if(this.mCardsInPanelCatalog != null)
         {
            _loc2_ = 0;
            for each(_loc1_ in this.mCardsInPanelCatalog)
            {
               _loc3_ = Utils.getXYPositionInContainer(_loc2_,_loc1_.width,_loc1_.height,Starling.current.stage.stageWidth / 4,this.mReferenceCard.height * (FSCardXL.TIER_CARDS_BLOCK_HEIGHT_PERCENTAGE / 100) - this.mTitleTextfield.height,this.mTierCards.length,1,true);
               _loc1_.x = _loc3_.getX();
               _loc1_.y = 0;
               _loc2_++;
            }
         }
      }
      
      public function unload() : void
      {
         var _loc1_:FSCardPreview = null;
         this.unhighlightCards();
         DictionaryUtils.clearDictionary(this.mCardsInPanelCatalog);
         this.mCardsInPanelCatalog = null;
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
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
         if(this.mCardPanel)
         {
            this.mCardPanel.removeFromParent(true);
            this.mCardPanel = null;
         }
         this.mReferenceCard = null;
      }
      
      override public function dispose() : void
      {
         var _loc1_:FSCardPreview = null;
         if(this.mTierCards)
         {
            for each(_loc1_ in this.mTierCards)
            {
               _loc1_.removeFromParent();
               _loc1_.removeCardElemsFromDisplayList();
               _loc1_.destroy();
               _loc1_ = null;
            }
            this.mTierCards.length = 0;
            this.mTierCards = null;
         }
         this.unload();
         super.dispose();
      }
      
      public function destroy() : void
      {
         var _loc1_:FSCardPreview = null;
         if(this.mTierCards)
         {
            for each(_loc1_ in this.mTierCards)
            {
               _loc1_.removeFromParent();
               _loc1_.removeCardElemsFromDisplayList();
               _loc1_.destroy();
               _loc1_ = null;
            }
            this.mTierCards.length = 0;
            this.mTierCards = null;
         }
         if(this.mCardPanel)
         {
            this.mCardPanel.removeFromParent();
            this.mCardPanel = null;
         }
         this.mReferenceCard = null;
      }
   }
}

