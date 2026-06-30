package com.fs.tcgengine.view.board
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import feathers.controls.text.TextFieldTextRenderer;
   import starling.core.Starling;
   import starling.utils.Align;
   
   public class FSCardDescInfoBlock extends Component
   {
      
      protected var mTitleTextfield:FSTextfield;
      
      protected var mDescTextfield:FSTextfield;
      
      protected var mTitle:String;
      
      protected var mDesc:String;
      
      protected var mParentCard:FSCard;
      
      protected var mDescriptionTexfield:TextFieldTextRenderer;
      
      private var mFactionBlock:CardDescInfoSubBlock;
      
      private var mCardValueBlock:CardDescInfoSubBlock;
      
      public function FSCardDescInfoBlock(param1:String, param2:String, param3:FSCard)
      {
         super();
         this.mTitle = param1;
         if(Config.getConfig().XLDescriptionAreStats() && param3 != null && param3.getCardDef() is UnitDef)
         {
            param2 = "";
         }
         this.mDesc = param2;
         this.mParentCard = param3;
         this.init();
         touchable = false;
      }
      
      private function init() : void
      {
         this.createTitleTextfield();
         this.createDescTextfield();
      }
      
      protected function createTitleTextfield() : void
      {
         if(this.mTitleTextfield == null)
         {
            this.mTitleTextfield = new FSTextfield(Starling.current.stage.stageWidth / 3.2,FSResourceMng.FONT_STD_TITLE_SIZE,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mTitleTextfield.touchable = false;
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mTitleTextfield.text = this.mTitle ? this.mTitle.toUpperCase() : "";
            this.mTitleTextfield.format.horizontalAlign = Align.LEFT;
         }
         this.mTitleTextfield.x = 0;
         this.mTitleTextfield.y = 0;
         addChild(this.mTitleTextfield);
      }
      
      private function createDescTextfield() : void
      {
         var _loc1_:CardDescInfoSubBlock = null;
         var _loc2_:int = 0;
         var _loc3_:CardDescInfoSubBlock = null;
         var _loc4_:SubCategoryDef = null;
         var _loc5_:SubCategoryDef = null;
         var _loc6_:CardDescInfoSubBlock = null;
         var _loc7_:CardDescInfoSubBlock = null;
         if(Config.getConfig().XLDescriptionAreStats() && this.mParentCard != null && this.mParentCard.getCardDef() is UnitDef)
         {
            _loc1_ = this.addRarityBlock();
            if(Config.PVP_SHOW_DECK_VALUE)
            {
               this.mCardValueBlock = this.addCardValueBlock(_loc1_);
               this.mFactionBlock = this.addFactionBlock(this.mCardValueBlock);
            }
            else
            {
               this.mFactionBlock = this.addFactionBlock(_loc1_);
            }
            _loc3_ = new CardDescInfoSubBlock(TextManager.getText("TID_COMBAT_SIZE")," " + TextManager.getText(UnitDef(this.mParentCard.getCardDef()).getCombatSize()),16777215);
            _loc3_.x = this.mTitleTextfield.x;
            _loc3_.y = this.mFactionBlock.y + this.mFactionBlock.height;
            addChild(_loc3_);
            _loc4_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(UnitDef(this.mParentCard.getCardDef()).getStrongSubcategorySku()));
            if(_loc4_)
            {
               _loc6_ = new CardDescInfoSubBlock(TextManager.getText("TID_COMBAT_STRONG") + ": "," · " + _loc4_.getName() + " · ",_loc4_.getColor());
               _loc6_.x = this.mTitleTextfield.x;
               _loc6_.y = _loc3_.y + _loc3_.height + 5;
               addChild(_loc6_);
            }
            _loc5_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(UnitDef(this.mParentCard.getCardDef()).getWeakSubcategorySku()));
            if(_loc5_)
            {
               _loc7_ = new CardDescInfoSubBlock(TextManager.getText("TID_COMBAT_WEAK") + ": "," · " + _loc5_.getName() + " · ",_loc5_.getColor());
               _loc7_.x = this.mTitleTextfield.x;
               _loc7_.y = _loc6_ ? _loc6_.y + _loc6_.height + 5 : _loc3_.y + _loc3_.height + 5;
               addChild(_loc7_);
            }
         }
         else
         {
            if(this.mDescTextfield == null)
            {
               _loc2_ = this.mParentCard.height / 2 - this.mTitleTextfield.height;
               this.mDescTextfield = new FSTextfield(this.mTitleTextfield.width,_loc2_);
               this.mDescTextfield.touchable = false;
               this.mDescTextfield.fontName = InstanceMng.getApplication().getZoomInViewMainFontName();
               this.mDescTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
               this.mDescTextfield.fontSize *= Layout.getFontMultiplier();
               this.mDescTextfield.text = this.mDesc;
               this.mDescTextfield.format.horizontalAlign = Align.LEFT;
               this.mDescTextfield.format.verticalAlign = Align.TOP;
            }
            _loc1_ = this.addRarityBlock();
            if(Config.PVP_SHOW_DECK_VALUE)
            {
               this.mCardValueBlock = this.addCardValueBlock(_loc1_);
               this.mFactionBlock = this.addFactionBlock(this.mCardValueBlock);
            }
            else
            {
               this.mFactionBlock = this.addFactionBlock(_loc1_);
            }
            this.mDescTextfield.x = this.mTitleTextfield.x;
            this.mDescTextfield.y = this.mFactionBlock.y + this.mFactionBlock.height + 10;
            addChild(this.mDescTextfield);
            if(Config.getConfig().XLDescriptionAreStats())
            {
               _loc2_ = this.mParentCard.height / 2.5 - this.mTitleTextfield.height;
               this.mDescTextfield.height = _loc2_;
            }
         }
      }
      
      protected function addRarityBlock() : CardDescInfoSubBlock
      {
         var _loc1_:RarityDef = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(this.mParentCard.getCardDef().getCardRarity()));
         var _loc2_:uint = InstanceMng.getRaritiesDefMng().getRarityColor(_loc1_.getIndex());
         var _loc3_:CardDescInfoSubBlock = new CardDescInfoSubBlock(TextManager.getText("TID_RARITY") + ":"," " + _loc1_.getName(),_loc2_);
         _loc3_.x = this.mTitleTextfield.x;
         _loc3_.y = this.mTitleTextfield.y + this.mTitleTextfield.height + 10;
         addChild(_loc3_);
         return _loc3_;
      }
      
      protected function addFactionBlock(param1:CardDescInfoSubBlock) : CardDescInfoSubBlock
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:CardDescInfoSubBlock = null;
         var _loc2_:FactionDef = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(this.mParentCard.getCardDef().getFactionSku()));
         if(_loc2_)
         {
            _loc3_ = _loc2_.getName().toUpperCase();
            _loc4_ = _loc2_.getColor();
            _loc5_ = new CardDescInfoSubBlock(TextManager.getText("TID_COMBAT_TYPE")," " + _loc3_,_loc4_);
            _loc5_.x = this.mTitleTextfield.x;
            _loc5_.y = param1.y + param1.height + 5;
            addChild(_loc5_);
         }
         return _loc5_;
      }
      
      protected function addCardValueBlock(param1:CardDescInfoSubBlock) : CardDescInfoSubBlock
      {
         var _loc2_:int = this.mParentCard.getCardDef().getCardValue();
         var _loc3_:CardDescInfoSubBlock = new CardDescInfoSubBlock(TextManager.getText("TID_CARDVALUE") + ": ",_loc2_.toString(),16777215);
         _loc3_.x = this.mTitleTextfield.x;
         _loc3_.y = param1.y + param1.height + 5;
         addChild(_loc3_);
         return _loc3_;
      }
      
      public function changeDescHeight(param1:Number) : void
      {
         var _loc2_:int = Boolean(InstanceMng.getCurrentScreen()) && Boolean(InstanceMng.getCurrentScreen().getBG()) ? int(InstanceMng.getCurrentScreen().getBG().height) : int(InstanceMng.getCurrentScreen().height);
         var _loc3_:int = Boolean(this.mParentCard) && Boolean(this.mParentCard.getFrameBG()) ? int(this.mParentCard.getFrameBG().height * (param1 / 100)) : int(_loc2_ / 3 * (param1 / 100));
         if(this.mDescriptionTexfield != null)
         {
            this.mDescriptionTexfield.height = _loc3_;
         }
         if(this.mDescTextfield != null)
         {
            this.mDescTextfield.height = _loc3_;
            if(this.mFactionBlock)
            {
               this.mDescTextfield.height -= this.mFactionBlock.height * 1.35;
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mDescriptionTexfield)
         {
            this.mDescriptionTexfield.nativeFilters = [];
            this.mDescriptionTexfield.removeFromParent(true);
            this.mDescriptionTexfield = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mDescTextfield)
         {
            this.mDescTextfield.removeFromParent(true);
            this.mDescTextfield = null;
         }
         if(this.mFactionBlock)
         {
            this.mFactionBlock.removeFromParent(true);
            this.mFactionBlock = null;
         }
         if(this.mCardValueBlock)
         {
            this.mCardValueBlock.removeFromParent(true);
            this.mCardValueBlock = null;
         }
         this.mParentCard = null;
         this.mDescriptionTexfield = null;
      }
   }
}

