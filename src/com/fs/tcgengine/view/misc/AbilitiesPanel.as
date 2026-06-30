package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.board.ActionAbilityInfoBlock;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class AbilitiesPanel extends Component
   {
      
      private var mBG:Sprite;
      
      private var mQuad:Quad;
      
      public var mTitleTextfield:FSTextfield;
      
      private var mParentCard:FSAction;
      
      private var mCancelButton:FSButton;
      
      private var mAbilitiesInfoBlocksCatalog:Dictionary;
      
      private var mSelectedCard:FSUnit;
      
      private var mSelectedUserInfo:UserBattleInfo;
      
      public function AbilitiesPanel()
      {
         super();
      }
      
      private function init() : void
      {
         this.createBG();
         this.createTitle();
      }
      
      private function createTitle() : void
      {
         if(this.mTitleTextfield == null)
         {
            this.mTitleTextfield = new FSTextfield(this.mBG.width * 0.8,Starling.current.stage.stageHeight * 0.1);
            this.mTitleTextfield.x = (this.mBG.width - this.mTitleTextfield.width) / 2;
            this.mTitleTextfield.y = this.mTitleTextfield.height / 2;
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mTitleTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mBG.addChild(this.mTitleTextfield);
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:int = 0;
         if(this.mBG == null)
         {
            if(this.mQuad == null)
            {
               _loc1_ = Starling.current.stage.stageWidth * 0.4;
               this.mQuad = new Quad(_loc1_,Starling.current.stage.stageHeight,0);
            }
            this.mBG = new Sprite();
            this.mBG.addChild(this.mQuad);
            addChild(this.mBG);
         }
      }
      
      private function createBGImage() : void
      {
         var _loc1_:FSImage = null;
         _loc1_ = new FSImage(Root.assets.getTexture(this.mParentCard.getCardDef().getBGImageName()));
         _loc1_.scaleX = this.mBG.width / _loc1_.width;
         _loc1_.scaleY = _loc1_.scaleX;
         _loc1_.x = 0;
         _loc1_.y = this.mBG.height - _loc1_.height;
         _loc1_.setVertexAlpha(0,0);
         _loc1_.setVertexAlpha(1,0);
         this.mBG.addChild(_loc1_);
      }
      
      public function setupPanel(param1:FSAction, param2:*) : void
      {
         this.init();
         this.mParentCard = param1;
         if(param2 is FSUnit)
         {
            this.mSelectedCard = param2;
         }
         else
         {
            this.mSelectedUserInfo = param2;
         }
         this.performOpeningFX();
         this.manageHighlighting();
         this.createBGImage();
      }
      
      private function performOpeningFX() : void
      {
         x -= this.mBG.width;
         var _loc1_:FSCoordinate = new FSCoordinate(0,0);
         SpecialFX.createTransition(this,_loc1_,0.5,0,this.onBGCreated);
      }
      
      private function onBGCreated() : void
      {
         this.createAbilitiesBlock();
         this.showCancelButton();
      }
      
      private function manageHighlighting() : void
      {
         var _loc1_:FSCardSocket = null;
         var _loc2_:Vector.<UserBattleInfo> = null;
         if(this.mSelectedCard != null)
         {
            _loc1_ = this.mSelectedCard.getAttachedToSocket();
            this.mParentCard.addCardSocketToPlayableSocketsVector(_loc1_);
            _loc1_.activateHighlightTween();
         }
         if(this.mSelectedUserInfo != null)
         {
            _loc2_ = new Vector.<UserBattleInfo>();
            _loc2_.push(this.mSelectedUserInfo);
            this.mParentCard.highlightPlayablePortraitsVector(_loc2_);
         }
         InstanceMng.getBattleEngine().abilityPickingLockUI();
      }
      
      private function createAbilitiesBlock() : void
      {
         var _loc1_:Ability = null;
         var _loc2_:AbilityDef = null;
         var _loc3_:ActionAbilityInfoBlock = null;
         var _loc4_:int = 0;
         var _loc11_:FSCoordinate = null;
         var _loc12_:FSCoordinate = null;
         var _loc5_:Vector.<Ability> = this.mParentCard != null ? this.mParentCard.getAbilities() : null;
         var _loc6_:int = _loc5_ != null ? int(_loc5_.length) : 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = Starling.current.stage.stageHeight * 0.8;
         var _loc10_:int = 0;
         _loc12_ = new FSCoordinate();
         var _loc13_:int = Starling.current.stage.stageWidth * 0.4;
         for each(_loc1_ in _loc5_)
         {
            _loc2_ = _loc1_.getAbilityDef();
            _loc4_ = _loc2_.getTierIndex();
            _loc3_ = this.createAbInfoBlock(_loc2_,1,_loc4_);
            _loc7_ = _loc7_ == 0 ? int(_loc3_.width) : _loc7_;
            _loc8_ = _loc8_ == 0 ? int(_loc3_.height) : _loc8_;
            _loc11_ = Utils.getXYPositionInContainer(_loc10_,_loc7_,_loc8_,_loc13_,Starling.current.stage.stageHeight * 0.7,1,_loc6_,true);
            _loc3_.x = -_loc3_.width;
            _loc3_.y = this.mTitleTextfield.y + this.mTitleTextfield.height * 2 + _loc11_.getY();
            addChild(_loc3_);
            _loc12_.setX((this.mBG.width - _loc3_.width) / 2);
            _loc12_.setY(_loc3_.y);
            SpecialFX.createTransition(_loc3_,_loc12_,0.2,_loc10_ / 3);
            this.addAbilityInfoBlock(_loc3_);
            _loc10_++;
         }
         SpecialFX.typeWriterEffect(this.mTitleTextfield,TextManager.getText("TID_GEN_SELECT_ABILITY"));
      }
      
      private function createAbInfoBlock(param1:AbilityDef, param2:int, param3:int, param4:Boolean = false) : ActionAbilityInfoBlock
      {
         return new ActionAbilityInfoBlock(param1,param2,param3,this.mParentCard,this.mParentCard.getCardDef(),this.mSelectedCard);
      }
      
      public function showCancelButton() : void
      {
         if(this.mCancelButton == null)
         {
            this.mCancelButton = new FSButton(Root.assets.getTexture(Constants.ACCEPT_BUTTON_UP_NAME),TextManager.getText("TID_GEN_BUTTON_CANCEL"),Root.assets.getTexture(Constants.ACCEPT_BUTTON_DOWN_NAME));
            this.mCancelButton.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            this.mCancelButton.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
            this.mCancelButton.fontColor = 16777215;
            this.mCancelButton.x = this.mBG ? this.mBG.width / 2 : width / 2;
            this.mCancelButton.y = this.mBG ? this.mBG.height - this.mCancelButton.height : height - this.mCancelButton.height;
            this.mCancelButton.addEventListener(Event.TRIGGERED,this.onButtonTriggered);
         }
         addChild(this.mCancelButton);
      }
      
      private function onButtonTriggered(param1:Event) : void
      {
         this.forceClose();
      }
      
      public function forceClose() : void
      {
         if(this.mParentCard)
         {
            this.mParentCard.unHighlightAllPlayableItems();
         }
         InstanceMng.getBattleEngine().resetUILock();
         InstanceMng.getBattleEngine().setActionUpgradeCostSelected(-1);
         InstanceMng.getBattleEngine().getBattleScreen().suggestPlayableCardON();
         this.cleanAndClose();
      }
      
      public function cleanAndClose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mQuad)
         {
            this.mQuad.removeFromParent(true);
            this.mQuad = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mCancelButton)
         {
            this.mCancelButton.removeFromParent(true);
            this.mCancelButton = null;
         }
         this.mParentCard = null;
         this.mSelectedCard = null;
         this.mSelectedUserInfo = null;
         this.removeAbilitiesInfoBlocks();
         removeFromParent();
      }
      
      private function addAbilityInfoBlock(param1:ActionAbilityInfoBlock) : void
      {
         var _loc2_:String = null;
         if(this.mAbilitiesInfoBlocksCatalog == null)
         {
            this.mAbilitiesInfoBlocksCatalog = new Dictionary(true);
         }
         if(param1 != null)
         {
            _loc2_ = param1.getAbilityDef().getSku();
            if(this.mAbilitiesInfoBlocksCatalog[_loc2_] == null)
            {
               this.mAbilitiesInfoBlocksCatalog[_loc2_] = param1;
            }
         }
      }
      
      private function removeAbilitiesInfoBlocks() : void
      {
         var _loc1_:ActionAbilityInfoBlock = null;
         if(this.mAbilitiesInfoBlocksCatalog != null)
         {
            for each(_loc1_ in this.mAbilitiesInfoBlocksCatalog)
            {
               _loc1_.removeFromParent();
               _loc1_.destroy();
               _loc1_ = null;
            }
            DictionaryUtils.clearDictionary(this.mAbilitiesInfoBlocksCatalog);
            this.mAbilitiesInfoBlocksCatalog = null;
         }
      }
      
      public function getParentCard() : FSAction
      {
         return this.mParentCard;
      }
      
      public function getSelectedCard() : FSUnit
      {
         return this.mSelectedCard;
      }
      
      public function getSelectedUserInfo() : UserBattleInfo
      {
         return this.mSelectedUserInfo;
      }
      
      override public function dispose() : void
      {
         this.cleanAndClose();
         super.dispose();
      }
   }
}

