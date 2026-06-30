package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.SubCategoriesMng;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.CategoryDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.DeckBuilderCard;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import feathers.controls.ScrollContainer;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class FSCardSlotInfo extends Component
   {
      
      private const PROMOTION_COST_IMG_NAME_PREFIX:String = "db_promote_cost_";
      
      private const SUMMON_COST_IMG_NAME_PREFIX:String = "db_promote_cost_";
      
      protected var mRarityBG:FSImage;
      
      protected var mFactionBG:FSImage;
      
      private var mCardNameTextfield:FSTextfield;
      
      protected var mCategoryIcon:FSImage;
      
      private var mAmountTextfield:FSTextfield;
      
      private var mDamageDefenseTextfield:FSTextfield;
      
      protected var mCardDef:CardDef;
      
      private var mCardAmount:int;
      
      private var mIsMoving:Boolean;
      
      private var mCardPanelParent:DeckCardsPanel;
      
      private var mScrollBlocked:Boolean;
      
      private var mOrigPos:FSCoordinate;
      
      private var mTempCard:FSCard;
      
      private var mAbilitiesIcons:Vector.<FSImage>;
      
      private var mPromoteCostImage:FSImage;
      
      private var mSummonCostImage:FSImage;
      
      private var mParentScrollContainer:ScrollContainer;
      
      public function FSCardSlotInfo(param1:String, param2:int, param3:DeckCardsPanel, param4:ScrollContainer)
      {
         super();
         this.mCardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         this.mCardAmount = param2;
         this.mCardPanelParent = param3;
         this.mParentScrollContainer = param4;
         this.init();
      }
      
      private function init() : void
      {
         if(this.mCardDef != null)
         {
            this.createRarityBG();
            this.createFactionBG();
            this.createNameTextfield();
            this.createAmountTextfield();
            this.createDamageDefenseTextfield();
            this.createCategoryIcon();
            if(Config.getConfig().getShowSummonCost())
            {
               this.createSummonCostIcon();
            }
            else
            {
               this.createPromotionCostIcon();
            }
            this.createAbilitiesIcons();
         }
         this.addEventListeners();
      }
      
      private function createPromotionCostIcon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.mPromoteCostImage == null)
         {
            if(this.mCardDef is UnitDef)
            {
               _loc1_ = this.mCardDef.getUpgradeCost();
               if(_loc1_ > 0)
               {
                  _loc2_ = this.PROMOTION_COST_IMG_NAME_PREFIX + _loc1_;
                  this.mPromoteCostImage = new FSImage(Root.assets.getTexture(_loc2_));
                  this.mPromoteCostImage.x = this.mCategoryIcon.x + this.mCategoryIcon.width;
                  this.mPromoteCostImage.y = this.mCardNameTextfield.y + this.mCardNameTextfield.height - this.mPromoteCostImage.height / 2;
                  addChild(this.mPromoteCostImage);
               }
            }
         }
      }
      
      private function createSummonCostIcon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         if(Boolean(this.mCardDef && this.mSummonCostImage == null) && Boolean(this.mCategoryIcon) && Boolean(this.mCardNameTextfield))
         {
            if(this.mCardDef is UnitDef)
            {
               _loc1_ = this.mCardDef.getSummonCost();
            }
            else if(this.mCardDef is AttachmentDef)
            {
               _loc2_ = AttachmentDef(this.mCardDef).getAttachmentCost();
               _loc1_ = _loc2_ ? int(_loc2_[0]) : 0;
            }
            else if(this.mCardDef is ActionDef)
            {
               _loc1_ = Boolean((this.mCardDef as ActionDef).getUpgradeCosts()) && (this.mCardDef as ActionDef).getUpgradeCosts().length > 0 ? int((this.mCardDef as ActionDef).getUpgradeCosts()[0]) : 0;
            }
            else if(this.mCardDef is PowerDef)
            {
               _loc1_ = this.mCardDef.getSummonCost();
            }
            if(_loc1_ > 0)
            {
               _loc3_ = this.SUMMON_COST_IMG_NAME_PREFIX + _loc1_;
               this.mSummonCostImage = new FSImage(Root.assets.getTexture(_loc3_));
               this.mSummonCostImage.x = this.mCategoryIcon.x + this.mCategoryIcon.width;
               this.mSummonCostImage.y = this.mCardNameTextfield.y + this.mCardNameTextfield.height - this.mSummonCostImage.height / 2;
               addChild(this.mSummonCostImage);
            }
         }
      }
      
      private function createCategoryIcon() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:CategoryDef = null;
         var _loc4_:String = null;
         var _loc5_:SubCategoryDef = null;
         if(this.mCategoryIcon == null)
         {
            _loc1_ = Config.getConfig().useDeckBuilderThumbnails();
            if(this.mCardDef is PowerDef)
            {
               _loc2_ = _loc1_ ? PowerDef(this.mCardDef).getBgIcon() : "";
            }
            else
            {
               _loc2_ = _loc1_ ? this.mCardDef.getBGImageName() + "_thumb" : "";
            }
            if(_loc2_ == "")
            {
               _loc3_ = CategoryDef(InstanceMng.getCategoriesDefMng().getDefBySku(this.mCardDef.getCategorySku()));
               switch(_loc3_.getIndex())
               {
                  case CategoriesDefMng.CATEGORY_UNITS:
                     _loc4_ = this.mCardDef.getSubCategorySku()[0];
                     _loc5_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc4_));
                     switch(_loc5_.getIndex())
                     {
                        case SubCategoriesMng.SUBCATEGORY_01:
                           _loc2_ = "unit_infantry_icon";
                           break;
                        case SubCategoriesMng.SUBCATEGORY_02:
                           _loc2_ = "unit_tank_icon";
                           break;
                        case SubCategoriesMng.SUBCATEGORY_03:
                           _loc2_ = "unit_air_icon";
                           break;
                        case SubCategoriesMng.SUBCATEGORY_04:
                           _loc2_ = "unit_ship_icon";
                           break;
                        case SubCategoriesMng.SUBCATEGORY_05:
                           _loc2_ = "unit_structure_icon";
                           break;
                        default:
                           _loc2_ = "unit_air_icon";
                     }
                     break;
                  case CategoriesDefMng.CATEGORY_ATTACHMENTS:
                     _loc2_ = "item_icon";
                     break;
                  case CategoriesDefMng.CATEGORY_ACTIONS:
                     _loc2_ = "order_icon";
               }
               _loc2_ = this.mCardDef.isLeader() ? "unit_leader_icon" : _loc2_;
            }
            this.mCategoryIcon = new FSImage(Root.assets.getTexture(_loc2_));
            this.mCategoryIcon.x = 0;
            this.mCategoryIcon.y = (height - this.mCategoryIcon.height) / 2;
            addChild(this.mCategoryIcon);
            this.mFactionBG.x += this.mCategoryIcon.width / 2;
            this.mRarityBG.x += this.mCategoryIcon.width / 2;
            this.mCardNameTextfield.x += this.mCategoryIcon.width / 2;
            if(this.mAmountTextfield != null)
            {
               this.mAmountTextfield.x += this.mCategoryIcon.width / 2.5;
            }
            if(this.mDamageDefenseTextfield != null)
            {
               this.mDamageDefenseTextfield.x += this.mCategoryIcon.width / 2.5;
            }
         }
      }
      
      private function createRarityBG() : void
      {
         var _loc1_:RarityDef = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.mRarityBG == null)
         {
            _loc1_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mCardDef.getCardRarity()));
            _loc2_ = Utils.transformValueToString((_loc1_.getIndex() + 1).toString(),2);
            _loc3_ = "rarity_" + _loc2_ + "_slot";
            this.mRarityBG = new FSImage(Root.assets.getTexture(_loc3_));
            Utils.setupImage9Scale(this.mRarityBG,10,12.5,5,7.5,102.5,32.75);
            this.mRarityBG.alignPivot();
            this.mRarityBG.x += this.mRarityBG.width / 2;
            this.mRarityBG.y += this.mRarityBG.height / 2;
            addChild(this.mRarityBG);
         }
      }
      
      private function createFactionBG() : void
      {
         var _loc1_:FactionDef = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.mFactionBG == null)
         {
            _loc1_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(this.mCardDef.getFactionSku()));
            if(_loc1_ != null)
            {
               _loc2_ = Utils.transformValueToString((_loc1_.getIndex() + 1).toString(),2);
               _loc3_ = "faction_" + _loc2_ + "_slot";
               this.mFactionBG = new FSImage(Root.assets.getTexture(_loc3_));
               this.mFactionBG.alignPivot();
               this.mFactionBG.x = this.mRarityBG.x;
               this.mFactionBG.y = this.mRarityBG.y;
               addChild(this.mFactionBG);
            }
         }
      }
      
      private function createNameTextfield() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mCardNameTextfield == null)
         {
            _loc2_ = this.mCardDef.getName();
            if(_loc2_.length > 16)
            {
               _loc1_ = _loc2_.slice(0,15);
               _loc1_ += "...";
            }
            else
            {
               _loc1_ = _loc2_;
            }
            this.mCardNameTextfield = new FSTextfield(this.mRarityBG.width * 0.75,this.mRarityBG.height * 0.4,_loc1_);
            this.mCardNameTextfield.format.horizontalAlign = Align.LEFT;
            this.mCardNameTextfield.alignPivot();
            this.mCardNameTextfield.x = this.mRarityBG.x;
            this.mCardNameTextfield.y = this.mRarityBG.y - this.mRarityBG.height / 2 + this.mCardNameTextfield.height * 0.75;
            this.mCardNameTextfield.fontSize = FSResourceMng.FONT_STD_SMALL_SIZE;
            addChild(this.mCardNameTextfield);
         }
      }
      
      private function createAmountTextfield() : void
      {
         if(this.mCardAmount >= 1 && this.mAmountTextfield == null)
         {
            this.mAmountTextfield = new FSTextfield(this.mRarityBG.width * 0.98,this.mRarityBG.height * 0.4,"x" + this.mCardAmount.toString());
            this.mAmountTextfield.y = this.mRarityBG.height * 0.12;
            this.mAmountTextfield.fontName = FSResourceMng.getFontByType();
            this.mAmountTextfield.color = 15852199;
            this.mAmountTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mAmountTextfield.format.horizontalAlign = Align.RIGHT;
            this.mAmountTextfield.format.verticalAlign = Align.CENTER;
            addChild(this.mAmountTextfield);
         }
      }
      
      private function createDamageDefenseTextfield() : void
      {
         var _loc1_:String = null;
         if(this.mCardDef.getCategoryIndex() != CategoriesDefMng.CATEGORY_ACTIONS && this.mCardDef.getCategoryIndex() != CategoriesDefMng.CATEGORY_POWERS)
         {
            _loc1_ = this.mCardDef.getDamage() + "/" + this.mCardDef.getDefense();
            this.mDamageDefenseTextfield = new FSTextfield(this.mRarityBG.width * 0.98,this.mRarityBG.height * 0.35,_loc1_);
            this.mDamageDefenseTextfield.y = this.mAmountTextfield.y + this.mAmountTextfield.height;
            this.mDamageDefenseTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mDamageDefenseTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mDamageDefenseTextfield.format.horizontalAlign = Align.RIGHT;
            this.mDamageDefenseTextfield.format.verticalAlign = Align.CENTER;
            addChild(this.mDamageDefenseTextfield);
         }
      }
      
      public function updateAmountTextfield() : void
      {
         if(this.mAmountTextfield != null)
         {
            this.mAmountTextfield.text = "x" + this.mCardAmount.toString();
         }
      }
      
      public function setVisibility(param1:Boolean) : void
      {
         visible = param1;
      }
      
      public function setTouchable() : void
      {
         touchable = true;
      }
      
      private function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc5_:Touch = null;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Point = null;
         var _loc9_:Boolean = false;
         var _loc2_:ScrollContainer = this.getParentContainer();
         var _loc3_:Boolean = _loc2_ ? _loc2_.isScrolling : false;
         var _loc4_:Vector.<Touch> = param1.getTouches(this,TouchPhase.MOVED);
         if(Boolean(_loc4_.length == 1) && Boolean(this.mCardPanelParent) && parent != null)
         {
            _loc6_ = param1.getTouches(this,TouchPhase.MOVED)[0].getMovement(parent).x;
            _loc7_ = Utils.isAndroid() ? Math.abs(_loc6_) > 0.5 : true;
            if(_loc7_)
            {
               this.mIsMoving = true;
               _loc8_ = _loc4_[0].getMovement(parent);
               if(_loc8_.x < 0)
               {
                  x += _loc8_.x;
               }
               _loc9_ = _loc3_ && x <= width / 10 * -1;
               if(this.mIsMoving && !this.mScrollBlocked && _loc9_)
               {
                  this.setParentScrollContainerEnabled(false);
               }
            }
         }
         if(this.mOrigPos == null)
         {
            this.mOrigPos = new FSCoordinate(0,y);
         }
         else
         {
            this.mOrigPos.setY(y);
         }
         _loc5_ = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc5_)
         {
            if(this.mIsMoving)
            {
               this.setParentScrollContainerEnabled(true);
               this.mIsMoving = false;
               this.checkIfRemovedFromDeck();
            }
            else if(!this.mIsMoving && !Root.assets.isLoading && !_loc3_)
            {
               FSDebug.debugTrace("Slot Click");
               this.loadCardResources();
            }
         }
         _loc5_ = param1.getTouch(this,TouchPhase.HOVER);
         alpha = _loc5_ ? 0.8 : 1;
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            Mouse.cursor = _loc5_ ? "hand" : "auto";
         }
      }
      
      private function loadCardResources() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(true,true);
         InstanceMng.getResourcesMng().loadCardImagesByCardDef(this.mCardDef,true);
         InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
      }
      
      private function notifyAssetsLoaded() : void
      {
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         this.createTempCard();
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_ is FSDeckBuilderScreen)
         {
            FSDeckBuilderScreen(_loc1_).setSelectedCard(this.mTempCard);
         }
         else if(_loc1_ is FSDungeonsScreen)
         {
            FSDungeonsScreen(_loc1_).setSelectedCard(this.mTempCard);
         }
         SpecialFX.zoomIn(this.mTempCard);
      }
      
      public function checkIfRemovedFromDeck(param1:Boolean = false) : void
      {
         if(x <= width / 2 * -1 || param1)
         {
            touchable = false;
            SpecialFX.tweenToAlpha(this,0.001,0.3,0,this.onRemovedFromDeck,[param1]);
            Utils.playSound("card_to_bf",SoundManager.TYPE_SFX);
         }
         else
         {
            SpecialFX.createTransition(this,this.mOrigPos,0.2);
         }
      }
      
      private function onRemovedFromDeck(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ScrollContainer = this.getParentContainer();
         if(_loc3_ != null)
         {
            if(this.mCardAmount > 1)
            {
               if(param1)
               {
                  _loc2_ = this.mCardAmount;
                  this.mCardAmount = 0;
                  this.updateAmountTextfield();
                  x = 0;
                  removeFromParent();
                  this.unload(false);
               }
               else
               {
                  _loc2_ = 1;
                  --this.mCardAmount;
                  this.updateAmountTextfield();
                  x = 0;
                  SpecialFX.tweenToAlpha(this,0.999,0.3,0);
                  touchable = true;
               }
            }
            else
            {
               _loc2_ = 1;
               removeFromParent();
               this.unload(false);
            }
            if(param1)
            {
               this.onRemovedFromDeckUpdateInfo(param1,_loc2_);
            }
            else
            {
               this.onRemovedFromDeckUpdateInfo(param1);
            }
            if(this.mCardPanelParent)
            {
               this.mCardPanelParent.onDeckModified(false);
            }
         }
      }
      
      private function onRemovedFromDeckUpdateInfo(param1:Boolean, param2:int = 1) : void
      {
         var _loc3_:FSDeckBuilderScreen = null;
         var _loc4_:DeckBuilderCard = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            this.mCardPanelParent.removeCardInfoFromCatalog(this.mCardDef.getSku(),param2);
            _loc3_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            _loc3_.updateCollectionFilteredWithDeck();
            _loc4_ = _loc3_.getCardInfoByCardSku(this.mCardDef.getSku());
            if(_loc4_ != null)
            {
               _loc4_.addAmount(param2);
               _loc4_.checkIfNeedsToShowMaxAmountSocket();
            }
            if(!param1)
            {
               _loc3_.refreshUI();
            }
         }
      }
      
      private function setParentScrollContainerEnabled(param1:Boolean) : void
      {
         var _loc2_:ScrollContainer = this.getParentContainer();
         if(_loc2_ != null)
         {
            this.mScrollBlocked = !param1;
            if(this.mScrollBlocked)
            {
               _loc2_.stopScrolling();
            }
         }
      }
      
      private function getParentContainer() : ScrollContainer
      {
         var _loc1_:ScrollContainer = null;
         var _loc2_:ScrollContainer = null;
         if(this.mParentScrollContainer != null)
         {
            _loc1_ = this.mParentScrollContainer;
         }
         else if(this.mCardPanelParent != null)
         {
            _loc2_ = this.mCardPanelParent.getScrollableContainer();
            _loc1_ = _loc2_;
         }
         return _loc1_;
      }
      
      private function createTempCard() : FSCard
      {
         if(this.mTempCard == null && this.mCardDef != null)
         {
            this.mTempCard = InstanceMng.getCardsMng().createCard(this.mCardDef.getSku());
            this.mTempCard.setIsInfoCard(true);
         }
         return this.mTempCard;
      }
      
      public function getCardDef() : CardDef
      {
         return this.mCardDef;
      }
      
      public function setCardDef(param1:CardDef) : void
      {
         this.mCardDef = param1;
      }
      
      public function getCardAmount() : int
      {
         return this.mCardAmount;
      }
      
      public function setCardAmount(param1:int) : void
      {
         this.mCardAmount = param1;
      }
      
      public function addCardAmount(param1:int) : void
      {
         this.mCardAmount += param1;
      }
      
      private function createAbilitiesIcons() : void
      {
         var _loc2_:Ability = null;
         var _loc3_:FSImage = null;
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:Vector.<Ability> = null;
         var _loc10_:int = 0;
         var _loc1_:Array = this.mCardDef ? this.mCardDef.getAbilities() : null;
         if(_loc1_ != null)
         {
            _loc7_ = this is FSAttachment;
            for each(_loc8_ in _loc1_)
            {
               _loc2_ = new Ability(AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc8_)),null);
               if(_loc2_ != null && _loc2_.getAbilityDef().isIconVisible())
               {
                  if(_loc9_ == null)
                  {
                     _loc9_ = new Vector.<Ability>();
                  }
                  _loc9_.push(_loc2_);
               }
            }
            _loc4_ = _loc9_ ? int(_loc9_.length) : 0;
            _loc5_ = int(_loc4_ - 1);
            if(_loc4_ > 0)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc9_.length)
               {
                  _loc2_ = _loc9_[_loc10_];
                  this.createAbilityIcon(_loc2_,_loc5_,_loc7_);
                  _loc5_--;
                  _loc10_++;
               }
            }
         }
      }
      
      protected function createAbilityIcon(param1:Ability, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:FSImage = null;
         var _loc5_:String = null;
         _loc5_ = param1.getAbilityDef().getBGImageName();
         _loc4_ = this.createAbilityIconImage(_loc5_);
         _loc4_.color = param3 ? 65280 : 16777215;
         var _loc6_:String = param1.getAbilityDef().getFactionSku();
         var _loc7_:Boolean = _loc6_ == null || _loc6_ == "" || _loc6_ == this.mCardDef.getFactionSku();
         _loc4_.alpha = _loc7_ ? 1 : 0.35;
         if(this.mSummonCostImage != null)
         {
            _loc4_.x = this.mSummonCostImage.x + this.mSummonCostImage.width + _loc4_.width * param2;
         }
         else if(this.mPromoteCostImage != null)
         {
            _loc4_.x = this.mPromoteCostImage.x + this.mPromoteCostImage.width + _loc4_.width * param2;
         }
         else
         {
            _loc4_.x = this.mCategoryIcon.x + this.mCategoryIcon.width + _loc4_.width * param2;
         }
         _loc4_.y = this.mCardNameTextfield.y + this.mCardNameTextfield.height / 2;
         addChild(_loc4_);
         if(this.mAbilitiesIcons == null)
         {
            this.mAbilitiesIcons = new Vector.<FSImage>();
         }
         this.mAbilitiesIcons.push(_loc4_);
      }
      
      protected function createAbilityIconImage(param1:String) : FSImage
      {
         var _loc2_:FSImage = new FSImage(Root.assets.getTexture(param1),false);
         _loc2_.scaleX *= Config.getConfig().deckBuilderSlotInfoAbilityScale();
         _loc2_.scaleY *= Config.getConfig().deckBuilderSlotInfoAbilityScale();
         return _loc2_;
      }
      
      public function unload(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         if(this.mRarityBG)
         {
            this.mRarityBG.removeFromParent(param1);
            this.mRarityBG = null;
         }
         if(this.mFactionBG)
         {
            this.mFactionBG.removeFromParent(param1);
            this.mFactionBG = null;
         }
         if(this.mCardNameTextfield)
         {
            this.mCardNameTextfield.removeFromParent(param1);
            this.mCardNameTextfield = null;
         }
         if(this.mCategoryIcon)
         {
            this.mCategoryIcon.removeFromParent(param1);
            this.mCategoryIcon = null;
         }
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(param1);
            this.mAmountTextfield = null;
         }
         if(this.mDamageDefenseTextfield)
         {
            this.mDamageDefenseTextfield.removeFromParent(param1);
            this.mDamageDefenseTextfield = null;
         }
         if(this.mAbilitiesIcons)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAbilitiesIcons.length)
            {
               this.mAbilitiesIcons[_loc2_].removeFromParent();
               this.mAbilitiesIcons[_loc2_].destroy();
               _loc2_++;
            }
            Utils.destroyArray(this.mAbilitiesIcons);
            this.mAbilitiesIcons = null;
         }
         if(this.mPromoteCostImage)
         {
            this.mPromoteCostImage.removeFromParent(param1);
            this.mPromoteCostImage = null;
         }
         if(this.mSummonCostImage)
         {
            this.mSummonCostImage.removeFromParent(param1);
            this.mSummonCostImage = null;
         }
         removeFromParent();
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      override public function dispose() : void
      {
         this.unload(true);
         this.mCardPanelParent = null;
         this.mOrigPos = null;
         this.mParentScrollContainer = null;
         this.mTempCard = null;
         this.mCardDef = null;
         super.dispose();
      }
   }
}

