package com.fs.tcgengine.view.popups.dungeons
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TargetMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.PacksDefMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.DungeonLevelDef;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSTracker;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.PostBoostButton;
   import com.fs.tcgengine.view.misc.RewardsEffect;
   import com.fs.tcgengine.view.popups.Popup;
   import starling.events.Event;
   
   public class PopupDungeonLevelFailed extends PopupDungeonLevelCompleted
   {
      
      public static const OUT_OF_LIFES:int = 0;
      
      public static const OUT_OF_TURNS:int = 1;
      
      public static const OUT_OF_LIFES_AND_TURNS:int = 2;
      
      private var mPostBoostButton:PostBoostButton;
      
      public function PopupDungeonLevelFailed(param1:Boolean = false)
      {
         super(true);
      }
      
      override protected function createTitle(param1:String) : void
      {
         super.createTitle(TextManager.getText("TID_GEN_LEVEL_DEFEAT"));
      }
      
      override protected function createRewardsText() : void
      {
         if(Boolean(mRewardsTitle == null) && Boolean(mTitle) && Boolean(mLevelsCompletedContainer))
         {
            mRewardsTitle = new FSTextfield(mTitle.width,mTitle.height * 1.5,TextManager.getText("TID_DUNGEON_STAGE_LOSE_INFO"));
            mRewardsTitle.x = mTitle.x + (mTitle.width - mRewardsTitle.width) / 2;
            mRewardsTitle.y = mLevelsCompletedContainer.y + mLevelsCompletedContainer.height * 1.1;
            addChild(mRewardsTitle);
         }
      }
      
      override protected function createRewardsContainer() : void
      {
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.setupPopup();
      }
      
      public function setupPopup() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:TargetMng = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc3_ = InstanceMng.getTargetMng();
            _loc4_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP() : 0;
            if(_loc4_ <= 0)
            {
               _loc5_ = _loc3_ ? InstanceMng.getTargetMng().getCurrentLevelRequiredTurns() : 0;
               if(_loc5_ > 0)
               {
                  _loc6_ = _loc3_ ? InstanceMng.getTargetMng().isSurvivalMode() : false;
                  if(_loc6_)
                  {
                     this.configurePopup(OUT_OF_LIFES);
                  }
                  else
                  {
                     _loc7_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getCurrentTurnId() : 0;
                     _loc2_ = _loc7_ < _loc5_;
                     _loc1_ = _loc4_ > 0;
                     if(!_loc2_ && !_loc1_)
                     {
                        this.configurePopup(OUT_OF_LIFES_AND_TURNS);
                     }
                     else
                     {
                        if(!_loc2_)
                        {
                           this.configurePopup(OUT_OF_TURNS);
                        }
                        if(!_loc1_)
                        {
                           this.configurePopup(OUT_OF_LIFES);
                        }
                     }
                  }
               }
               else
               {
                  this.configurePopup(OUT_OF_LIFES);
               }
            }
         }
         else
         {
            closePopup();
         }
      }
      
      private function configurePopup(param1:int) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case OUT_OF_LIFES:
               _loc2_ = TextManager.getText("TID_GEN_LEVEL_OUT_LIFES");
               break;
            case OUT_OF_TURNS:
               _loc2_ = TextManager.getText("TID_GEN_LEVEL_OUT_TURNS");
               break;
            case OUT_OF_LIFES_AND_TURNS:
               _loc2_ = TextManager.getText("TID_GEN_LIFES_TURNS_OUT");
         }
         setMainFieldText(_loc2_);
         this.createPostBoostButton(param1);
      }
      
      private function createPostBoostButton(param1:int) : void
      {
         this.mPostBoostButton = new PostBoostButton(param1);
         this.mPostBoostButton.x = mBox.width / 2;
         this.mPostBoostButton.y = mBox.height - this.mPostBoostButton.height / 4;
         addChild(this.mPostBoostButton);
         this.mPostBoostButton.setEnabled(Config.smPostBoostsEnabled);
      }
      
      public function onPostBoostButtonClicked(param1:BoostDef) : void
      {
         this.openBuyPostBoostPopup();
      }
      
      private function openBuyPostBoostPopup() : void
      {
         var _loc2_:Popup = null;
         var _loc1_:BoostDef = this.mPostBoostButton.getBoostDef();
         if(_loc1_ != null)
         {
            _loc2_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc2_)
            {
               _loc2_.hideTemporarily(InstanceMng.getPopupMng().openBuyPostBoostPopup,[_loc1_]);
            }
            else
            {
               InstanceMng.getPopupMng().openBuyPostBoostPopup(_loc1_);
            }
         }
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         mOnClosedFunction = this.onClosePerformOps;
      }
      
      private function onClosePerformOps() : void
      {
         var _loc1_:Object = null;
         FSTracker.trackMiscAction(FSTracker.CATEGORY_DUNGEONS,FSTracker.ACTION_DUNGEON_ABANDONED);
         if(InstanceMng.getCurrentScreen() is FSBattleScreen && Boolean(FSBattleScreen(InstanceMng.getCurrentScreen())))
         {
            _loc1_ = InstanceMng.getDungeonsMng().getDungeonRewardsToClaimSummary();
            if(Boolean(_loc1_) && (Boolean(_loc1_.hasGold) || Boolean(_loc1_.hasCards) || Boolean(_loc1_.hasPacks) || Boolean(_loc1_.hasPortraits)))
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).performCardsLeavingFX(0,this.onCardsReturnedOpenDungeonRewardsEffect);
            }
            else
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).performCardsLeavingFX(0,this.showDungeonsScreen);
            }
         }
         InstanceMng.getQuestsMng().onLevelFailed();
      }
      
      private function showDungeonsScreen() : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).showDungeonsScreen();
         }
      }
      
      private function onCardsReturnedOpenDungeonRewardsEffect() : void
      {
         var _loc1_:Object = InstanceMng.getDungeonsMng().getDungeonRewardsToClaimSummary();
         var _loc2_:DungeonLevelDef = Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getLevelDef()) ? DungeonLevelDef(InstanceMng.getBattleEngine().getLevelDef()) : null;
         var _loc3_:RewardsEffect = new RewardsEffect(PacksDefMng.PACK_DUNGEONS,_loc1_,true,_loc2_.getChestBG());
         _loc3_.alpha = 0;
         SpecialFX.tweenToAlpha(_loc3_,1,0.3,0);
         InstanceMng.getCurrentScreen().addChild(_loc3_);
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mPostBoostButton)
         {
            this.mPostBoostButton.removeFromParent();
         }
         super.removeFromStage();
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
   }
}

