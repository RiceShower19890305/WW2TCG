package com.fs.tcgengine.view.popups.dungeons
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.DungeonDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import flash.utils.Dictionary;
   import starling.events.Event;
   
   public class PopupDungeonLevelCompleted extends PopupStandard
   {
      
      private const REWARDS_ASSET_NAME:String = "pvp_end_reward";
      
      private const LEVEL_STATUS_NOT_STARTED:int = 0;
      
      private const LEVEL_STATUS_COMPLETED:int = 1;
      
      private const LEVEL_STATUS_FAILED:int = -1;
      
      protected var mTitle:FSTextfield;
      
      protected var mDungeonNameTextfield:FSTextfield;
      
      protected var mLevelsCompletedContainer:Component;
      
      private var mLevelsCompletedVec:Vector.<FSButton>;
      
      protected var mRewardsTitle:FSTextfield;
      
      private var mRewardsContainer:Component;
      
      private var mRewardsBG:FSImage;
      
      private var mRewards:Object;
      
      public function PopupDungeonLevelCompleted(param1:Boolean = false)
      {
         super(param1);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = Constants.POPUP_SETTINGS_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1,720);
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.setupTexts();
         this.createLevelsContainer();
         this.fillLevelsIndicators();
         this.createRewardsSection();
      }
      
      private function createLevelsContainer() : void
      {
         if(this.mLevelsCompletedContainer == null && Boolean(this.mDungeonNameTextfield))
         {
            this.mLevelsCompletedContainer = new Component();
            this.mLevelsCompletedContainer.x = 0;
            this.mLevelsCompletedContainer.y = this.mDungeonNameTextfield.y + this.mDungeonNameTextfield.height * 1.1;
            this.mLevelsCompletedContainer.width = this.mDungeonNameTextfield.width;
            addChild(this.mLevelsCompletedContainer);
         }
      }
      
      private function fillLevelsIndicators() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:FSButton = null;
         var _loc7_:String = null;
         var _loc1_:Dictionary = InstanceMng.getDungeonsMng().getCurrentLevelsStatus();
         if(_loc1_)
         {
            _loc3_ = DictionaryUtils.getKeys(_loc1_);
            _loc3_.sort(Array.NUMERIC);
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc2_ = int(_loc1_[_loc3_[_loc5_]]);
               switch(_loc2_)
               {
                  case this.LEVEL_STATUS_NOT_STARTED:
                     _loc7_ = "phase_icon_incomplete";
                     break;
                  case this.LEVEL_STATUS_COMPLETED:
                     _loc7_ = "phase_icon_victory";
                     break;
                  case this.LEVEL_STATUS_FAILED:
                     _loc7_ = "phase_icon_defeated";
               }
               _loc6_ = new FSButton(Root.assets.getTexture(_loc7_),(_loc5_ + 1).toString());
               _loc6_.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               _loc6_.scaleWhenDown = 1;
               _loc6_.enableScaleOnMouseOver(false);
               this.addButtonToContainer(_loc6_,_loc5_,_loc3_.length);
               _loc5_++;
            }
            if(this.mLevelsCompletedContainer)
            {
               this.mLevelsCompletedContainer.x = (mBox.width - this.mLevelsCompletedContainer.width) / 2;
            }
         }
      }
      
      private function addButtonToContainer(param1:FSButton, param2:int, param3:int) : void
      {
         var _loc4_:FSCoordinate = null;
         if(this.mLevelsCompletedVec == null)
         {
            this.mLevelsCompletedVec = new Vector.<FSButton>();
         }
         this.mLevelsCompletedVec.push(param1);
         if(this.mLevelsCompletedContainer)
         {
            _loc4_ = Utils.getXYPositionInContainer(param2,param1.width,param1.height,mBox.width * 0.9,param1.height,param3,1,true);
            param1.x = param3 == 3 ? _loc4_.getX() : param1.width / 3 + _loc4_.getX();
            param1.y = param1.height / 2 + _loc4_.getY();
            this.mLevelsCompletedContainer.addChild(param1);
         }
      }
      
      private function createRewardsSection() : void
      {
         this.createRewardsText();
      }
      
      protected function createRewardsText() : void
      {
         if(this.mRewardsTitle == null)
         {
            this.mRewardsTitle = new FSTextfield(this.mTitle.width,this.mTitle.height / 2,TextManager.getText("TID_GEN_LEVEL_REWARDS"));
            this.mRewardsTitle.x = this.mTitle.x + (this.mTitle.width - this.mRewardsTitle.width) / 2;
            this.mRewardsTitle.y = this.mLevelsCompletedContainer.y + this.mLevelsCompletedContainer.height * 1.1;
            addChild(this.mRewardsTitle);
         }
      }
      
      protected function createRewardsContainer() : void
      {
         if(this.mRewardsBG == null)
         {
            this.mRewardsBG = new FSImage(Root.assets.getTexture(this.REWARDS_ASSET_NAME));
            Utils.setupImage9Scale(this.mRewardsBG,10,8,1,1,131.5,41);
         }
         if(this.mRewardsContainer == null)
         {
            this.mRewardsContainer = new Component();
            this.mRewardsContainer.addChild(this.mRewardsBG);
            this.mRewardsContainer.x = (mBox.width - this.mRewardsBG.width) / 2;
            this.mRewardsContainer.y = this.mRewardsTitle.y + this.mRewardsTitle.height * 1.15;
            addChild(this.mRewardsContainer);
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         if(!mClosed)
         {
            this.createRewardsContainer();
            this.fillRewardsContainer();
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).updateDungeonRewardsSummary();
            }
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         this.onClosePerformCommonOps();
      }
      
      private function onClosePerformCommonOps() : void
      {
         Utils.stopSound(Constants.SOUND_VICTORY);
         Utils.stopSound(Constants.SOUND_DEFEAT);
      }
      
      private function fillRewardsContainer() : void
      {
         var _loc1_:DungeonDef = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FSCoordinate = null;
         var _loc5_:FSButton = null;
         var _loc6_:FSButton = null;
         if(this.mRewards)
         {
            _loc1_ = InstanceMng.getDungeonsMng().getCurrentDungeonDef();
            if(_loc1_)
            {
               _loc2_ = int(this.mRewards.totalRewards);
               if(_loc2_ > 0)
               {
                  _loc3_ = 0;
                  if(this.mRewards.hasGold)
                  {
                     _loc5_ = new FSButton(Root.assets.getTexture("shop_top_icon_gold"),"0");
                     _loc5_.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                     _loc5_.scaleWhenDown = 1;
                     _loc5_.enableScaleOnMouseOver(false);
                     _loc4_ = Utils.getXYPositionInContainer(_loc3_,_loc5_.width,_loc5_.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc2_,1,true);
                     _loc5_.x = this.mRewardsBG.x + _loc4_.getX() + _loc5_.width / 2;
                     _loc5_.y = this.mRewardsBG.y + _loc4_.getY() + _loc5_.height / 2;
                     this.mRewardsContainer.addChild(_loc5_);
                     _loc3_++;
                     if(_loc5_.getTextfield())
                     {
                        SpecialFX.createTextfieldAmountTransition(_loc5_.getTextfield(),int(this.mRewards.gold),1,true);
                     }
                  }
                  if(this.mRewards.hasCards)
                  {
                     _loc6_ = new FSButton(Root.assets.getTexture("small_random_card_reward"));
                     _loc6_.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
                     _loc6_.scaleWhenDown = 1;
                     _loc6_.enableScaleOnMouseOver(false);
                     _loc4_ = Utils.getXYPositionInContainer(_loc3_,_loc6_.width,_loc6_.height,this.mRewardsBG.width,this.mRewardsBG.height,_loc2_,1,true);
                     _loc6_.x = this.mRewardsBG.x + _loc4_.getX() + _loc6_.width / 2;
                     _loc6_.y = this.mRewardsBG.y + _loc4_.getY() + _loc6_.height / 2;
                     this.mRewardsContainer.addChild(_loc6_);
                     _loc3_++;
                     _loc6_.text = this.mRewards.cards;
                  }
               }
            }
         }
      }
      
      protected function setupTexts() : void
      {
         this.createTitle(TextManager.getText("TID_GEN_LEVEL_VICTORY"));
         this.createDungeonName();
      }
      
      protected function createTitle(param1:String) : void
      {
         if(this.mTitle == null)
         {
            this.mTitle = new FSTextfield(width * 0.9,height * 0.2);
            this.mTitle.x = (mBox.width - this.mTitle.width) / 2;
            this.mTitle.y = mBox.height * 0.035;
            this.mTitle.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
            addChild(this.mTitle);
         }
         this.mTitle.text = param1;
      }
      
      private function createDungeonName() : void
      {
         if(Boolean(this.mDungeonNameTextfield == null) && Boolean(this.mTitle) && Boolean(InstanceMng.getDungeonsMng().getCurrentDungeonDef()))
         {
            this.mDungeonNameTextfield = new FSTextfield(this.mTitle.width,this.mTitle.height / 1.9,InstanceMng.getDungeonsMng().getCurrentDungeonDef().getName());
            this.mDungeonNameTextfield.x = this.mTitle.x;
            this.mDungeonNameTextfield.y = this.mTitle.y + this.mTitle.height * 0.9;
            addChild(this.mDungeonNameTextfield);
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         if(InstanceMng.getServerConnection().isUserLoggedIn())
         {
            super.onAccept(param1);
            mOnClosedFunction = this.onAcceptPerformOps;
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_UNABLE_PROCEED"),true);
            InstanceMng.getPopupMng().getPopupShown().hideTemporarily(InstanceMng.getPopupMng().openErrorPopup,[TextManager.getText("TID_CONNECTION_LOST"),true]);
         }
      }
      
      protected function onAcceptPerformOps() : void
      {
         this.onClosePerformCommonOps();
         InstanceMng.getDungeonsMng().loadNextDungeonLevel();
      }
      
      public function setupRewards(param1:Object) : void
      {
         this.mRewards = param1;
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
         super.setupAcceptButton(TextManager.getText("TID_GEN_NEXT"),param2,param3);
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:int = 0;
         if(this.mTitle)
         {
            this.mTitle.removeFromParent(true);
            this.mTitle = null;
         }
         if(this.mDungeonNameTextfield)
         {
            this.mDungeonNameTextfield.removeFromParent(true);
            this.mDungeonNameTextfield = null;
         }
         if(this.mLevelsCompletedContainer)
         {
            this.mLevelsCompletedContainer.removeFromParent(true);
            this.mLevelsCompletedContainer = null;
         }
         if(this.mLevelsCompletedVec)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mLevelsCompletedVec.length)
            {
               this.mLevelsCompletedVec[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mLevelsCompletedVec);
            this.mLevelsCompletedVec = null;
         }
         if(this.mRewardsTitle)
         {
            this.mRewardsTitle.removeFromParent(true);
            this.mRewardsTitle = null;
         }
         if(this.mRewardsContainer)
         {
            this.mRewardsContainer.removeFromParent(true);
            this.mRewardsContainer = null;
         }
         if(this.mRewardsBG)
         {
            this.mRewardsBG.removeFromParent(true);
            this.mRewardsBG = null;
         }
         this.mRewards = null;
         InstanceMng.getPopupMng().removePopup(FSPopupMng.DUNGEON_LEVEL_COMPLETED_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

