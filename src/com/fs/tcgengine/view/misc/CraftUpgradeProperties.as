package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   
   public class CraftUpgradeProperties extends Component
   {
      
      private static const UPGRADE_COLOR:String = "UPGRADE";
      
      private static const DOWNGRADE_COLOR:String = "DOWNGRADE";
      
      private static const MAX_ROWS:int = 2;
      
      private static const MAX_COLUMNS:int = 3;
      
      private static const TYPE_DAMAGE:int = 0;
      
      private static const TYPE_DEFENSE:int = 1;
      
      private static const TYPE_SUMMONCOST:int = 2;
      
      private static const TYPE_UPGRADECOST:int = 3;
      
      private static const TYPE_ABILITY:int = 4;
      
      private static const ICON_ATTACK:String = "craft_stat_attack";
      
      private static const ICON_DEFENSE:String = "craft_stat_defense";
      
      private static const ICON_SUMMONCOST:String = "craft_stat_summon";
      
      private static const ICON_UPGRADECOST:String = "craft_stat_promote";
      
      private static const ICON_ABILITY:String = "craft_stat_ability";
      
      private var mPreviousCard:CardDef;
      
      private var mNextCard:CardDef;
      
      private var mAttackVariation:int;
      
      private var mDefenseVariation:int;
      
      private var mSummonCostVariation:int;
      
      private var mUpgradeCostVariation:int;
      
      private var mAbilityVariation:Boolean;
      
      private var mCurrentIndex:int = 0;
      
      private var mAttackImage:FSImage;
      
      private var mAttackTextField:FSTextfield;
      
      private var mDefenseImage:FSImage;
      
      private var mDefenseTextField:FSTextfield;
      
      private var mSummonCostImage:FSImage;
      
      private var mSummonCostTextField:FSTextfield;
      
      private var mUpgradeCostImage:FSImage;
      
      private var mUpgradeCostTextField:FSTextfield;
      
      private var mAbilityImage:FSImage;
      
      private var mIsAction:Boolean;
      
      private var mActionTier:int;
      
      public function CraftUpgradeProperties(param1:CardDef, param2:CardDef, param3:Boolean = false, param4:int = 1)
      {
         super();
         this.mPreviousCard = param1;
         this.mNextCard = param2;
         this.mIsAction = param3;
         this.mActionTier = param4;
         this.calculateVariations();
      }
      
      public function createUI() : void
      {
         this.createAttackIcon();
         this.createDefenseIcon();
         this.createSummonCostIcon();
         this.createUpgradeCostIcon();
         this.createAbilityIcon();
      }
      
      public function hasSomeUpgrade() : Boolean
      {
         return this.hasAttackVariation() || this.hasDefenseVariation() || this.hasSummonCostVariation() || this.hasUpgradeCostVariation() || this.hasAbilityVariation();
      }
      
      private function createAbilityIcon() : void
      {
         if(this.hasAbilityVariation())
         {
            if(this.mAbilityImage == null)
            {
               this.mAbilityImage = new FSImage(Root.assets.getTexture(ICON_ABILITY));
               this.mAbilityImage.x = this.mAbilityImage.width * this.getMultipierForNextIconX();
               this.mAbilityImage.y = this.mAbilityImage.height * this.getMultipierForNextIconY();
               addChild(this.mAbilityImage);
               this.updateCurrentIndex();
            }
         }
      }
      
      private function createUpgradeCostIcon() : void
      {
         var _loc1_:String = null;
         if(this.hasUpgradeCostVariation())
         {
            if(this.mUpgradeCostImage == null)
            {
               this.mUpgradeCostImage = new FSImage(Root.assets.getTexture(ICON_UPGRADECOST));
               this.mUpgradeCostImage.x = this.mUpgradeCostImage.width * this.getMultipierForNextIconX();
               this.mUpgradeCostImage.y = this.mUpgradeCostImage.height * this.getMultipierForNextIconY();
               addChild(this.mUpgradeCostImage);
               this.updateCurrentIndex();
            }
            if(Boolean(this.mUpgradeCostImage) && this.mUpgradeCostTextField == null)
            {
               if(this.mUpgradeCostVariation > 0)
               {
                  _loc1_ = "+" + this.mUpgradeCostVariation.toString();
               }
               else
               {
                  _loc1_ = this.mUpgradeCostVariation.toString();
               }
               this.mUpgradeCostTextField = new FSTextfield(this.mUpgradeCostImage.width,this.mUpgradeCostImage.height,_loc1_);
               if(this.getColor(TYPE_UPGRADECOST) == UPGRADE_COLOR)
               {
                  this.mUpgradeCostTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               }
               else
               {
                  this.mUpgradeCostTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
               }
               this.mUpgradeCostTextField.scaleX = 0.8;
               this.mUpgradeCostTextField.scaleY = 0.8;
               this.mUpgradeCostTextField.alignPivot();
               this.mUpgradeCostTextField.x = this.mUpgradeCostImage.x;
               this.mUpgradeCostTextField.y = this.mUpgradeCostImage.y;
               addChild(this.mUpgradeCostTextField);
               SpecialFX.createYoYoZoomTransition(this.mUpgradeCostTextField,1,0.7,-1);
            }
         }
      }
      
      private function createSummonCostIcon() : void
      {
         var _loc1_:String = null;
         if(this.hasSummonCostVariation())
         {
            if(this.mSummonCostImage == null)
            {
               this.mSummonCostImage = new FSImage(Root.assets.getTexture(ICON_SUMMONCOST));
               this.mSummonCostImage.x = this.mSummonCostImage.width * this.getMultipierForNextIconX();
               this.mSummonCostImage.y = this.mSummonCostImage.height * this.getMultipierForNextIconY();
               addChild(this.mSummonCostImage);
               this.updateCurrentIndex();
            }
            if(Boolean(this.mSummonCostImage) && this.mSummonCostTextField == null)
            {
               if(this.mSummonCostVariation > 0)
               {
                  _loc1_ = "+" + this.mSummonCostVariation.toString();
               }
               else
               {
                  _loc1_ = this.mSummonCostVariation.toString();
               }
               this.mSummonCostTextField = new FSTextfield(this.mSummonCostImage.width,this.mSummonCostImage.height,_loc1_);
               if(this.getColor(TYPE_SUMMONCOST) == UPGRADE_COLOR)
               {
                  this.mSummonCostTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               }
               else
               {
                  this.mSummonCostTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
               }
               this.mSummonCostTextField.scaleX = 0.8;
               this.mSummonCostTextField.scaleY = 0.8;
               this.mSummonCostTextField.alignPivot();
               this.mSummonCostTextField.x = this.mSummonCostImage.x;
               this.mSummonCostTextField.y = this.mSummonCostImage.y;
               addChild(this.mSummonCostTextField);
               SpecialFX.createYoYoZoomTransition(this.mSummonCostTextField,1,0.7,-1);
            }
         }
      }
      
      private function createAttackIcon() : void
      {
         var _loc1_:String = null;
         if(this.hasAttackVariation())
         {
            if(this.mAttackImage == null)
            {
               this.mAttackImage = new FSImage(Root.assets.getTexture(ICON_ATTACK));
               this.mAttackImage.x = this.mAttackImage.width * this.getMultipierForNextIconX();
               this.mAttackImage.y = this.mAttackImage.height * this.getMultipierForNextIconY();
               addChild(this.mAttackImage);
               this.updateCurrentIndex();
            }
            if(Boolean(this.mAttackImage) && this.mAttackTextField == null)
            {
               if(this.mAttackVariation > 0)
               {
                  _loc1_ = "+" + this.mAttackVariation.toString();
               }
               else
               {
                  _loc1_ = this.mAttackVariation.toString();
               }
               this.mAttackTextField = new FSTextfield(this.mAttackImage.width,this.mAttackImage.height,_loc1_);
               if(this.getColor(TYPE_DAMAGE) == UPGRADE_COLOR)
               {
                  this.mAttackTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               }
               else
               {
                  this.mAttackTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
               }
               this.mAttackTextField.scaleX = 0.8;
               this.mAttackTextField.scaleY = 0.8;
               this.mAttackTextField.alignPivot();
               this.mAttackTextField.x = this.mAttackImage.x;
               this.mAttackTextField.y = this.mAttackImage.y;
               addChild(this.mAttackTextField);
               SpecialFX.createYoYoZoomTransition(this.mAttackTextField,1,0.7,-1);
            }
         }
      }
      
      private function createDefenseIcon() : void
      {
         var _loc1_:String = null;
         if(this.hasDefenseVariation())
         {
            if(this.mDefenseImage == null)
            {
               this.mDefenseImage = new FSImage(Root.assets.getTexture(ICON_DEFENSE));
               this.mDefenseImage.x = this.mDefenseImage.width * this.getMultipierForNextIconX();
               this.mDefenseImage.y = this.mDefenseImage.height * this.getMultipierForNextIconY();
               addChild(this.mDefenseImage);
               this.updateCurrentIndex();
            }
            if(Boolean(this.mDefenseImage) && this.mDefenseTextField == null)
            {
               if(this.mDefenseVariation > 0)
               {
                  _loc1_ = "+" + this.mDefenseVariation.toString();
               }
               else
               {
                  _loc1_ = this.mDefenseVariation.toString();
               }
               this.mDefenseTextField = new FSTextfield(this.mDefenseImage.width,this.mDefenseImage.height,_loc1_);
               if(this.getColor(TYPE_DEFENSE) == UPGRADE_COLOR)
               {
                  this.mDefenseTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               }
               else
               {
                  this.mDefenseTextField.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
               }
               this.mDefenseTextField.scaleX = 0.8;
               this.mDefenseTextField.scaleY = 0.8;
               this.mDefenseTextField.alignPivot();
               this.mDefenseTextField.x = this.mDefenseImage.x;
               this.mDefenseTextField.y = this.mDefenseImage.y;
               addChild(this.mDefenseTextField);
               SpecialFX.createYoYoZoomTransition(this.mDefenseTextField,1,0.7,-1);
            }
         }
      }
      
      private function getMultipierForNextIconX() : int
      {
         return this.mCurrentIndex % MAX_COLUMNS;
      }
      
      private function getMultipierForNextIconY() : int
      {
         return this.mCurrentIndex / MAX_COLUMNS;
      }
      
      private function updateCurrentIndex() : void
      {
         ++this.mCurrentIndex;
      }
      
      private function calculateVariations() : void
      {
         this.calculateAttackVariation();
         this.calculateDefenseVariation();
         this.calculateSummonCostVariation();
         this.calculateUpgradeCostVariation();
         this.calculateAbilityVariation();
      }
      
      private function calculateAttackVariation() : void
      {
         if(Boolean(this.mPreviousCard) && Boolean(this.mNextCard))
         {
            this.mAttackVariation = this.mNextCard.getDamage() - this.mPreviousCard.getDamage();
         }
      }
      
      private function calculateDefenseVariation() : void
      {
         if(Boolean(this.mPreviousCard) && Boolean(this.mNextCard))
         {
            this.mDefenseVariation = this.mNextCard.getDefense() - this.mPreviousCard.getDefense();
         }
      }
      
      private function calculateSummonCostVariation() : void
      {
         if(Boolean(this.mPreviousCard) && Boolean(this.mNextCard))
         {
            if(this.mPreviousCard is AttachmentDef)
            {
               this.mSummonCostVariation = AttachmentDef(this.mNextCard).getAttachmentCost()[0] - AttachmentDef(this.mPreviousCard).getAttachmentCost()[0];
            }
            else if(this.mPreviousCard is ActionDef)
            {
               this.mSummonCostVariation = ActionDef(this.mNextCard).getUpgradeCosts()[this.mActionTier - 1] - ActionDef(this.mPreviousCard).getUpgradeCosts()[this.mActionTier - 1];
            }
            else
            {
               this.mSummonCostVariation = this.mNextCard.getSummonCost() - this.mPreviousCard.getSummonCost();
            }
         }
      }
      
      private function calculateUpgradeCostVariation() : void
      {
         if(Boolean(this.mPreviousCard) && Boolean(this.mNextCard))
         {
            this.mUpgradeCostVariation = this.mNextCard.getUpgradeCost() - this.mPreviousCard.getUpgradeCost();
         }
      }
      
      private function calculateAbilityVariation() : void
      {
         var _loc1_:Array = null;
         if(Boolean(this.mPreviousCard) && Boolean(this.mNextCard))
         {
            if(this.mPreviousCard is ActionDef)
            {
               _loc1_ = this.mNextCard.getCraftAbilities();
               if(Boolean(_loc1_) && Boolean(_loc1_.length > 0) && this.mActionTier - 1 < _loc1_.length)
               {
                  this.mAbilityVariation = _loc1_[this.mActionTier - 1] == 1;
               }
            }
            else
            {
               _loc1_ = this.mNextCard.getCraftAbilities();
               if(Boolean(_loc1_) && _loc1_.length > 0)
               {
                  this.mAbilityVariation = _loc1_[0] == 1;
               }
            }
         }
      }
      
      private function hasAttackVariation() : Boolean
      {
         return this.mAttackVariation != 0;
      }
      
      private function hasDefenseVariation() : Boolean
      {
         return this.mDefenseVariation != 0;
      }
      
      private function hasSummonCostVariation() : Boolean
      {
         return this.mSummonCostVariation != 0;
      }
      
      private function hasUpgradeCostVariation() : Boolean
      {
         return this.mUpgradeCostVariation != 0;
      }
      
      private function hasAbilityVariation() : Boolean
      {
         return this.mAbilityVariation;
      }
      
      private function getColor(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case TYPE_DAMAGE:
               if(this.mAttackVariation > 0)
               {
                  _loc2_ = UPGRADE_COLOR;
               }
               else
               {
                  _loc2_ = DOWNGRADE_COLOR;
               }
               break;
            case TYPE_DEFENSE:
               if(this.mDefenseVariation > 0)
               {
                  _loc2_ = UPGRADE_COLOR;
               }
               else
               {
                  _loc2_ = DOWNGRADE_COLOR;
               }
               break;
            case TYPE_SUMMONCOST:
               if(this.mSummonCostVariation > 0)
               {
                  _loc2_ = DOWNGRADE_COLOR;
               }
               else
               {
                  _loc2_ = UPGRADE_COLOR;
               }
               break;
            case TYPE_UPGRADECOST:
               if(this.mSummonCostVariation > 0)
               {
                  _loc2_ = DOWNGRADE_COLOR;
               }
               else
               {
                  _loc2_ = UPGRADE_COLOR;
               }
         }
         return _loc2_;
      }
      
      public function unload() : void
      {
         if(this.mAttackImage)
         {
            this.mAttackImage.removeFromParent(true);
            this.mAttackImage = null;
         }
         if(this.mAttackTextField)
         {
            TweenMax.killTweensOf(this.mAttackTextField);
            this.mAttackTextField.removeFromParent(true);
            this.mAttackTextField = null;
         }
         if(this.mDefenseImage)
         {
            this.mDefenseImage.removeFromParent(true);
            this.mDefenseImage = null;
         }
         if(this.mDefenseTextField)
         {
            TweenMax.killTweensOf(this.mDefenseTextField);
            this.mDefenseTextField.removeFromParent(true);
            this.mDefenseTextField = null;
         }
         if(this.mSummonCostImage)
         {
            this.mSummonCostImage.removeFromParent(true);
            this.mSummonCostImage = null;
         }
         if(this.mSummonCostTextField)
         {
            TweenMax.killTweensOf(this.mSummonCostTextField);
            this.mSummonCostTextField.removeFromParent(true);
            this.mSummonCostTextField = null;
         }
         if(this.mUpgradeCostImage)
         {
            this.mUpgradeCostImage.removeFromParent(true);
            this.mUpgradeCostImage = null;
         }
         if(this.mUpgradeCostTextField)
         {
            TweenMax.killTweensOf(this.mUpgradeCostTextField);
            this.mUpgradeCostTextField.removeFromParent(true);
            this.mUpgradeCostTextField = null;
         }
         if(this.mAbilityImage)
         {
            this.mAbilityImage.removeFromParent(true);
            this.mAbilityImage = null;
         }
      }
      
      override public function dispose() : void
      {
         this.mPreviousCard = null;
         this.mNextCard = null;
         if(this.mAttackImage)
         {
            this.mAttackImage.removeFromParent(true);
            this.mAttackImage = null;
         }
         if(this.mAttackTextField)
         {
            this.mAttackTextField.removeFromParent(true);
            this.mAttackTextField = null;
         }
         if(this.mDefenseImage)
         {
            this.mDefenseImage.removeFromParent(true);
            this.mDefenseImage = null;
         }
         if(this.mDefenseTextField)
         {
            this.mDefenseTextField.removeFromParent(true);
            this.mDefenseTextField = null;
         }
         if(this.mSummonCostImage)
         {
            this.mSummonCostImage.removeFromParent(true);
            this.mSummonCostImage = null;
         }
         if(this.mSummonCostTextField)
         {
            this.mSummonCostTextField.removeFromParent(true);
            this.mSummonCostTextField = null;
         }
         if(this.mUpgradeCostImage)
         {
            this.mUpgradeCostImage.removeFromParent(true);
            this.mUpgradeCostImage = null;
         }
         if(this.mUpgradeCostTextField)
         {
            this.mUpgradeCostTextField.removeFromParent(true);
            this.mUpgradeCostTextField = null;
         }
         if(this.mAbilityImage)
         {
            this.mAbilityImage.removeFromParent(true);
            this.mAbilityImage = null;
         }
         super.dispose();
      }
   }
}

