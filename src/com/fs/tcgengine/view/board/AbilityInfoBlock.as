package com.fs.tcgengine.view.board
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.core.Starling;
   import starling.text.TextFieldAutoSize;
   import starling.utils.Align;
   
   public class AbilityInfoBlock extends Component implements FSModelUnloadableInterface
   {
      
      public static const TITLE_TEXTFIELD_HEIGHT:int = FSResourceMng.FONT_STD_SUBTITLE_SIZE * Layout.getFontMultiplier();
      
      public static const DESC_TEXTFIELD_HEIGHT:int = FSResourceMng.FONT_STD_SUBTITLE_SIZE * 2.5 * Layout.getFontMultiplier();
      
      public static const TITLE_TEXTFIELD_COLOR:uint = 16744448;
      
      public static const DESC_TEXTFIELD_COLOR:uint = 16777215;
      
      protected var mImage:FSImage;
      
      protected var mTitleTextfield:FSTextfield;
      
      protected var mDescTextfield:FSTextfield;
      
      protected var mAbilityDef:AbilityDef;
      
      private var mBelongsToTier:int;
      
      private var mCurrentTier:int;
      
      protected var mParentCard:FSCard;
      
      protected var mBelongsToAttachment:Boolean;
      
      public function AbilityInfoBlock(param1:AbilityDef, param2:int, param3:int, param4:FSCard, param5:Boolean = false)
      {
         super();
         this.mAbilityDef = param1;
         this.mCurrentTier = param2;
         this.mBelongsToTier = param3;
         this.mParentCard = param4;
         this.mBelongsToAttachment = param5;
         this.init();
      }
      
      protected function init() : void
      {
         if(this.mAbilityDef != null)
         {
            this.createImage();
            this.setTitle();
            this.createDesc();
            this.checkIfBelongsToCurrentTier();
         }
      }
      
      protected function createImage() : void
      {
         if(this.mImage == null)
         {
            this.mImage = new FSImage(Root.assets.getTexture(this.mAbilityDef.getBGXLImageName()));
         }
         this.mImage.y = (TITLE_TEXTFIELD_HEIGHT + DESC_TEXTFIELD_HEIGHT) / 2 - this.mImage.height / 2;
         var _loc1_:String = this.mAbilityDef.getFactionSku();
         var _loc2_:Boolean = _loc1_ == null || _loc1_ == "" || _loc1_ == this.mParentCard.getCardDef().getFactionSku();
         this.mImage.alpha = _loc2_ ? 1 : 0.35;
         if(this.mBelongsToAttachment && _loc2_)
         {
            this.mImage.color = 65280;
         }
         addChild(this.mImage);
      }
      
      protected function setTitle() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this.mAbilityDef)
         {
            if(this.mTitleTextfield == null)
            {
               this.mTitleTextfield = new FSTextfield(Starling.current.stage.stageWidth / 5,TITLE_TEXTFIELD_HEIGHT);
               this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
               this.mTitleTextfield.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.VERTICAL;
               this.mTitleTextfield.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE * Layout.getFontMultiplier();
               this.mTitleTextfield.format.horizontalAlign = Align.LEFT;
               this.mTitleTextfield.format.verticalAlign = Align.BOTTOM;
            }
            this.mTitleTextfield.text = this.mAbilityDef.getName() ? this.mAbilityDef.getName().toUpperCase() : "";
            _loc1_ = "";
            if(Boolean(this.mParentCard) && Boolean(this.mParentCard.getCardDef()))
            {
               _loc2_ = this.mParentCard.getCardDef().getSku();
               if(Utils.getNextTierCardDef(_loc2_) != null || Utils.getPreviousTierCardDef(_loc2_) != null)
               {
                  _loc1_ = " (" + TextManager.replaceParameters(TextManager.getText("TID_GEN_RANK"),[this.mBelongsToTier]) + ")";
               }
            }
            this.mTitleTextfield.text = this.mBelongsToTier > 0 ? this.mTitleTextfield.text + _loc1_ : this.mTitleTextfield.text;
            this.mTitleTextfield.text = this.mTitleTextfield.text.toUpperCase();
            this.mTitleTextfield.x = this.mImage ? this.mImage.width + 5 : 0;
            addChild(this.mTitleTextfield);
         }
      }
      
      protected function createDesc() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.mDescTextfield == null)
         {
            this.mDescTextfield = new FSTextfield(FSCardXL.COLUMN_WIDTH * 0.9,DESC_TEXTFIELD_HEIGHT,"",DESC_TEXTFIELD_COLOR);
            this.mDescTextfield.fontName = InstanceMng.getApplication().getZoomInViewMainFontName();
            this.mDescTextfield.fontSize = FSResourceMng.FONT_STD_SMALL_SIZE * Layout.getFontMultiplier();
            this.mDescTextfield.autoSize = TextFieldAutoSize.VERTICAL;
            this.mDescTextfield.autoScale = false;
            _loc1_ = Boolean(Config.getConfig().gameActionsDescShowCost()) && Boolean(this.mParentCard) && this.mParentCard is FSAction ? "(" + TextManager.getText("TID_GEN_COST",true) + ": " + ActionDef(this.mParentCard.getCardDef()).getUpgradeCostByAbilitySku(this.mAbilityDef.getSku()) + ") " : "";
            _loc2_ = Config.smDebugTooltips ? "[" + this.mAbilityDef.getSku() + "] " : "";
            _loc3_ = this.mAbilityDef.isParentAbility() ? _loc2_ + this.mAbilityDef.getCompositeName() : _loc2_ + this.mAbilityDef.getDesc();
            this.mDescTextfield.text = _loc1_ + _loc3_;
            this.mDescTextfield.format.horizontalAlign = Align.LEFT;
            this.mDescTextfield.format.verticalAlign = Align.TOP;
         }
         this.setDescTextfieldPosition();
      }
      
      protected function setDescTextfieldPosition() : void
      {
         this.mDescTextfield.x = this.mTitleTextfield.x;
         this.mDescTextfield.y = this.mTitleTextfield.y + this.mTitleTextfield.height;
         addChild(this.mDescTextfield);
      }
      
      protected function checkIfBelongsToCurrentTier() : void
      {
         var _loc1_:Number = this.mCurrentTier != this.mBelongsToTier ? 0.4 : 0.999;
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.alpha = _loc1_;
         }
         if(this.mImage)
         {
            this.mImage.alpha = _loc1_;
         }
         if(this.mDescTextfield)
         {
            this.mDescTextfield.alpha = _loc1_;
         }
      }
      
      public function updateCurrentTier(param1:int) : void
      {
         this.setCurrentTier(param1);
         this.setTitle();
         this.checkIfBelongsToCurrentTier();
      }
      
      public function getAbilityDef() : AbilityDef
      {
         return this.mAbilityDef;
      }
      
      public function getCurrentTier() : int
      {
         return this.mCurrentTier;
      }
      
      public function setCurrentTier(param1:int) : void
      {
         this.mCurrentTier = param1;
      }
      
      override public function dispose() : void
      {
         if(this.mImage)
         {
            this.mImage.removeFromParent(true);
            this.mImage = null;
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
         this.mParentCard = null;
         this.mAbilityDef = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mImage)
         {
            this.mImage.removeFromParent();
            this.mImage.destroy();
            this.mImage = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent();
            this.mTitleTextfield = null;
         }
         if(this.mDescTextfield)
         {
            this.mDescTextfield.removeFromParent();
            this.mDescTextfield = null;
         }
         this.mParentCard = null;
      }
   }
}

