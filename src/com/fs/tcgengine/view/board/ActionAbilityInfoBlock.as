package com.fs.tcgengine.view.board
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAction;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.battle.ActionPointsCounter;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.AbilitiesPanel;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Align;
   
   public class ActionAbilityInfoBlock extends AbilityInfoBlock
   {
      
      private const BG_IMAGE_NAME:String = "ability_socket";
      
      private const ABILITY_SOCKET_BG_NAME:String = "ability_socket_icon";
      
      private const ABILITY_POINT_ON_NAME:String = "ability_point_on";
      
      private const ABILITY_POINT_OFF_NAME:String = "ability_point_off";
      
      private var mBGImage:CustomComponent;
      
      private var mBG:Sprite;
      
      private var mActionDef:ActionDef;
      
      private var mUpgradeCost:int;
      
      private var mActionIconBG:Sprite;
      
      private var mActionPoint1:FSImage;
      
      private var mActionPoint2:FSImage;
      
      private var mActionPoint3:FSImage;
      
      private var mTextfield:FSTextfield;
      
      private var mSelectedCardRef:FSCard;
      
      public function ActionAbilityInfoBlock(param1:AbilityDef, param2:int, param3:int, param4:FSCard, param5:CardDef, param6:FSCard)
      {
         this.mActionDef = ActionDef(param5);
         this.mSelectedCardRef = param6;
         var _loc7_:UserBattleInfo = param4.getParentUserBattleInfo();
         this.mUpgradeCost = _loc7_.getActionCostForAbsPanel(param4,this.mActionDef,param1);
         super(param1,param2,param3,param4);
      }
      
      override protected function init() : void
      {
         this.addEventListeners();
         if(mAbilityDef != null)
         {
            this.createActionIconBG();
            this.createBG();
            this.createActionPointsImages();
         }
         super.init();
         this.update();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new Sprite();
            if(this.mBGImage == null)
            {
               this.mBGImage = Utils.createCustomBox(this.BG_IMAGE_NAME,596);
            }
            this.mBG.addChild(this.mBGImage);
         }
         this.mBG.x = this.mActionIconBG.x + this.mActionIconBG.width / 2;
         this.mBG.y -= (this.mBG.height - this.mActionIconBG.height) / 2;
         addChildAt(this.mBG,0);
      }
      
      private function createActionIconBG() : void
      {
         var _loc1_:FSImage = null;
         if(this.mActionIconBG == null)
         {
            this.mActionIconBG = new Sprite();
            _loc1_ = new FSImage(Root.assets.getTexture(this.ABILITY_SOCKET_BG_NAME));
            this.mActionIconBG.addChild(_loc1_);
         }
         addChild(this.mActionIconBG);
      }
      
      private function createTextfield() : void
      {
         if(this.mTextfield == null)
         {
            this.mTextfield = new FSTextfield(this.mActionPoint1.width,this.mActionPoint1.height,"0");
            this.mTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mTextfield.alignPivot();
            this.mTextfield.x = this.mActionPoint1.x + this.mTextfield.width * 1.2;
            this.mTextfield.y = this.mActionPoint1.y - this.mTextfield.height * 0.25;
            addChild(this.mTextfield);
         }
      }
      
      private function createActionPointsImages() : void
      {
         var _loc1_:String = null;
         if(this.mActionPoint1 == null)
         {
            _loc1_ = this.mUpgradeCost >= 1 ? this.ABILITY_POINT_ON_NAME : this.ABILITY_POINT_OFF_NAME;
            this.mActionPoint1 = new FSImage(Root.assets.getTexture(_loc1_));
            this.mActionPoint1.x = this.mActionPoint1.width / 2;
            this.mActionPoint1.y -= this.mActionPoint1.height / 2;
            this.mBG.addChild(this.mActionPoint1);
         }
         if(Config.getConfig().getActionPointsShowMode() != ActionPointsCounter.AP_MODE_TEXTFIELD && Config.getConfig().getActionPointsShowMode() != ActionPointsCounter.AP_MODE_BOX_TEXTFIELD_LIMITED)
         {
            if(this.mActionPoint2 == null)
            {
               _loc1_ = this.mUpgradeCost > 1 ? this.ABILITY_POINT_ON_NAME : this.ABILITY_POINT_OFF_NAME;
               this.mActionPoint2 = new FSImage(Root.assets.getTexture(_loc1_));
               this.mActionPoint2.x = this.mActionPoint1.x + this.mActionPoint1.width;
               this.mActionPoint2.y -= this.mActionPoint2.height / 2;
               this.mBG.addChild(this.mActionPoint2);
            }
            else
            {
               _loc1_ = this.mUpgradeCost > 1 ? this.ABILITY_POINT_ON_NAME : this.ABILITY_POINT_OFF_NAME;
               this.mActionPoint2.texture = Root.assets.getTexture(_loc1_);
            }
            if(this.mActionPoint3 == null)
            {
               _loc1_ = this.mUpgradeCost > 2 ? this.ABILITY_POINT_ON_NAME : this.ABILITY_POINT_OFF_NAME;
               this.mActionPoint3 = new FSImage(Root.assets.getTexture(_loc1_));
               this.mActionPoint3.x = this.mActionPoint2.x + this.mActionPoint2.width;
               this.mActionPoint3.y -= this.mActionPoint3.height / 2;
               this.mBG.addChild(this.mActionPoint3);
            }
            else
            {
               _loc1_ = this.mUpgradeCost > 2 ? this.ABILITY_POINT_ON_NAME : this.ABILITY_POINT_OFF_NAME;
               this.mActionPoint2.texture = Root.assets.getTexture(_loc1_);
            }
         }
         else
         {
            this.createTextfield();
            if(this.mTextfield)
            {
               this.mTextfield.text = String(this.mUpgradeCost);
            }
         }
      }
      
      override protected function createImage() : void
      {
         if(mImage == null)
         {
            mImage = new FSImage(Root.assets.getTexture(mAbilityDef.getBGXLImageName()));
         }
         mImage.x = (this.mActionIconBG.width - mImage.width) / 2;
         mImage.y = (this.mActionIconBG.height - mImage.height) / 2;
         var _loc1_:String = mAbilityDef.getFactionSku();
         var _loc2_:Boolean = _loc1_ == null || _loc1_ == "" || _loc1_ == mParentCard.getCardDef().getFactionSku();
         mImage.alpha = _loc2_ ? 1 : 0.35;
         if(mBelongsToAttachment && _loc2_)
         {
            mImage.color = 65280;
         }
         this.mActionIconBG.addChild(mImage);
      }
      
      private function enable(param1:Boolean) : void
      {
         touchable = param1;
         alpha = param1 ? 1 : 0.6;
         if(param1)
         {
            mDescTextfield.color = AbilityInfoBlock.DESC_TEXTFIELD_COLOR;
         }
         else
         {
            mDescTextfield.color = 12632256;
         }
      }
      
      override protected function setTitle() : void
      {
      }
      
      override protected function createDesc() : void
      {
         if(mDescTextfield == null)
         {
            mDescTextfield = new FSTextfield(this.mBGImage.width - this.mActionIconBG.width / 2 - this.mBGImage.width * 0.05 * 0.9,this.mBGImage.height - this.mActionPoint1.height,"",DESC_TEXTFIELD_COLOR);
            mDescTextfield.fontName = FSCard(mParentCard).getTempCardXL() ? InstanceMng.getApplication().getZoomInViewMainFontName() : InstanceMng.getApplication().getAbilitiesMainFontName();
            mDescTextfield.fontSize = FSResourceMng.FONT_STD_SMALL_SIZE * Layout.getFontMultiplier();
            mDescTextfield.text = mAbilityDef.getDesc();
            mDescTextfield.format.horizontalAlign = Align.CENTER;
            mDescTextfield.format.verticalAlign = Align.CENTER;
         }
         this.setDescTextfieldPosition();
      }
      
      override protected function setDescTextfieldPosition() : void
      {
         mDescTextfield.x = this.mActionIconBG.width / 2;
         mDescTextfield.y = this.mActionPoint1.y + this.mActionPoint1.height;
         this.mBG.addChild(mDescTextfield);
      }
      
      public function update() : void
      {
         var _loc5_:AbilitiesPanel = null;
         var _loc6_:FSUnit = null;
         var _loc7_:int = 0;
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         var _loc2_:int = _loc1_.isOwnerTurn() ? _loc1_.getOwnerBattleInfo().getActionPointsLeft() : _loc1_.getOpponentBattleInfo().getActionPointsLeft();
         var _loc3_:Boolean = this.mUpgradeCost <= _loc2_;
         var _loc4_:Ability = mParentCard.getAbilityByAbSku(mAbilityDef.getSku());
         if(_loc4_ != null)
         {
            _loc3_ &&= _loc4_.canBeExecutedAndHasTargets(this.mSelectedCardRef);
         }
         if(_loc3_ && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc5_ = FSBattleScreen(InstanceMng.getCurrentScreen()).getAbilitiesChooserPanel();
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_.getSelectedCard();
               if(_loc6_ != null)
               {
                  _loc7_ = mAbilityDef.getTierIndex();
                  _loc3_ = _loc7_ == 0 || _loc7_ == _loc6_.getCardDef().getTier();
               }
            }
         }
         this.enable(_loc3_);
      }
      
      override protected function checkIfBelongsToCurrentTier() : void
      {
      }
      
      public function addEventListeners() : void
      {
         touchable = true;
         addEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:FSBattleScreen = null;
         var _loc4_:AbilitiesPanel = null;
         var _loc5_:FSUnit = null;
         var _loc6_:UserBattleInfo = null;
         var _loc7_:Array = null;
         var _loc8_:Ability = null;
         var _loc9_:UserBattleInfo = null;
         var _loc10_:AbilityDef = null;
         var _loc11_:Boolean = false;
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            if(InstanceMng.getBattleEngine())
            {
               InstanceMng.getBattleEngine().setActionUpgradeCostSelected(this.mUpgradeCost);
               _loc3_ = InstanceMng.getBattleEngine().getBattleScreen();
               if(_loc3_ != null)
               {
                  _loc4_ = _loc3_.getAbilitiesChooserPanel();
                  if(_loc4_ != null)
                  {
                     _loc5_ = _loc4_.getSelectedCard();
                     _loc6_ = _loc4_.getSelectedUserInfo();
                     _loc7_ = new Array();
                     _loc8_ = mParentCard ? mParentCard.getAbilityByAbSku(mAbilityDef.getSku()) : null;
                     if(_loc8_)
                     {
                        if(_loc5_ != null || _loc6_ != null)
                        {
                           if(!InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc8_.getAbilityDef()))
                           {
                              _loc7_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(mAbilityDef,mParentCard,mAbilityDef.getCostRange());
                           }
                           else if(_loc5_ != null)
                           {
                              _loc7_.push(_loc5_);
                           }
                           else if(_loc6_ != null)
                           {
                              _loc7_.push(_loc6_);
                           }
                           FSAction(mParentCard).storeActionMovementFromAbilitiesPanel(_loc7_,_loc5_,_loc6_,_loc8_.getAbilityDef());
                           _loc8_.onTargetSelected(_loc7_);
                           InstanceMng.getBattleEngine().getBattleScreen().suggestPlayableCardON();
                           _loc9_ = mParentCard.getParentUserBattleInfo();
                           if(Boolean(mParentCard) && Boolean(_loc9_))
                           {
                              _loc11_ = false;
                              if(_loc9_.isModifiedCostActive())
                              {
                                 _loc10_ = _loc9_.getExtraSummonCostAbilityDef();
                                 if((Boolean(_loc10_)) && _loc10_.isCardEligibleForAbility(mParentCard))
                                 {
                                    _loc9_.removeSummonCostAbilities();
                                    _loc11_ = true;
                                 }
                              }
                              if(!_loc11_ && _loc9_.isFixedSummonCostActive())
                              {
                                 _loc10_ = _loc9_.getFixedSummonCostAbilityDef();
                                 if((Boolean(_loc10_)) && _loc10_.isCardEligibleForAbility(mParentCard))
                                 {
                                    _loc9_.removeSummonCostAbilities();
                                 }
                              }
                           }
                        }
                        mParentCard = null;
                     }
                  }
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         this.mActionDef = null;
         if(this.mBGImage)
         {
            this.mBGImage.removeFromParent(true);
            this.mBGImage = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mActionIconBG)
         {
            this.mActionIconBG.removeFromParent(true);
            this.mActionIconBG = null;
         }
         if(this.mActionPoint1)
         {
            this.mActionPoint1.removeFromParent(true);
            this.mActionPoint1 = null;
         }
         if(this.mActionPoint2)
         {
            this.mActionPoint2.removeFromParent(true);
            this.mActionPoint2 = null;
         }
         if(this.mActionPoint3)
         {
            this.mActionPoint3.removeFromParent(true);
            this.mActionPoint3 = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         this.mSelectedCardRef = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
      
      override public function destroy() : void
      {
         if(mImage)
         {
            mImage.removeFromParent();
            mImage.destroy();
            mImage = null;
         }
         if(mTitleTextfield)
         {
            mTitleTextfield.removeFromParent();
            mTitleTextfield = null;
         }
         if(mDescTextfield)
         {
            mDescTextfield.removeFromParent();
            mDescTextfield = null;
         }
      }
   }
}

