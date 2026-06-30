package com.fs.tcgengine.view.popups.raids
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TargetMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.BoostDef;
   import com.fs.tcgengine.model.rules.RaidDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.PostBoostButton;
   import com.fs.tcgengine.view.popups.Popup;
   import flash.utils.setTimeout;
   import starling.events.Event;
   
   public class PopupRaidLevelFailed extends PopupRaidLevelCompleted
   {
      
      public static const OUT_OF_LIFES:int = 0;
      
      public static const OUT_OF_TURNS:int = 1;
      
      public static const OUT_OF_LIFES_AND_TURNS:int = 2;
      
      private var mPostBoostButton:PostBoostButton;
      
      private var mPlayerWillReplayMatch:Boolean;
      
      public function PopupRaidLevelFailed(param1:Boolean = true)
      {
         super(param1);
      }
      
      override public function onClose(param1:Event) : void
      {
         super.onClose(param1);
         this.onClosePerformCommonOps();
      }
      
      override protected function onClosePerformCommonOps() : void
      {
         var _loc1_:RaidDef = InstanceMng.getRaidsMng().getCurrentRaidDef();
         var _loc2_:int = InstanceMng.getRaidsMng().getCurrentRaidDifficulty();
         var _loc3_:RaidLevelDef = _loc1_ ? RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(_loc1_.getLevelsByDifficultyIndex(_loc2_))) : null;
         var _loc4_:Boolean = _loc1_.getIsMultiPlayer() ? InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsMultiPlayer() > 0 : InstanceMng.getUserDataMng().getOwnerUserData().getRaidTicketsSinglePlayer() > 0;
         this.mPlayerWillReplayMatch = _loc4_ && Boolean(_loc1_) && Boolean(_loc3_);
         if(this.mPlayerWillReplayMatch)
         {
            InstanceMng.getPopupMng().openPlayRaidLevelPopup(_loc3_.getSku());
         }
         else
         {
            super.onClosePerformCommonOps();
         }
      }
      
      override protected function createTitle(param1:String) : void
      {
         super.createTitle(TextManager.getText("TID_GEN_LEVEL_DEFEAT"));
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
         var _loc6_:int = 0;
         if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc3_ = InstanceMng.getTargetMng();
            _loc4_ = _loc3_ ? InstanceMng.getTargetMng().getCurrentLevelRequiredTurns() : 0;
            _loc5_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getOwnerBattleInfo().getHP() : 0;
            if(_loc4_ > 0)
            {
               _loc6_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getCurrentTurnId() : 0;
               _loc2_ = _loc6_ < _loc4_;
            }
            _loc1_ = _loc5_ > 0;
            if(!_loc1_)
            {
               if(_loc4_ > 0)
               {
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
               else
               {
                  this.configurePopup(OUT_OF_LIFES);
               }
            }
            else if(!_loc2_ && _loc4_ > 0)
            {
               this.configurePopup(OUT_OF_TURNS);
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
      
      public function disablePostBoostButtonTemporarily(param1:int = 2) : void
      {
         if(this.mPostBoostButton)
         {
            this.enablePostBoostButton(false);
            setTimeout(this.enablePostBoostButton,param1 * 1000,true);
            Utils.setLogText(TextManager.getText("TID_GEN_WAIT") + " (" + param1 + " " + TextManager.getText("TID_GEN_TIME_SECONDS_ABR") + ")");
         }
      }
      
      private function enablePostBoostButton(param1:Boolean) : void
      {
         if(this.mPostBoostButton)
         {
            this.mPostBoostButton.setEnabled(param1);
         }
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
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mPostBoostButton)
         {
            this.mPostBoostButton.removeFromParent();
            this.mPostBoostButton.destroy();
            this.mPostBoostButton = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.RAID_LEVEL_FAILED_POPUP_NAME);
         super.removeFromStage();
      }
      
      override public function allowClosureTappingBG() : Boolean
      {
         return false;
      }
   }
}

