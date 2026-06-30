package com.fs.tcgengine.view.popups.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.misc.DeckSelectorPvP;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.easing.Back;
   import starling.core.Starling;
   import starling.events.Event;
   
   public class PopupPlayPvPOffline extends PopupStandard
   {
      
      public static const BG_NAME:String = "pvp_vs_panel";
      
      private var mLevelDef:LevelDef;
      
      protected var mDeckSelectorOwner:DeckSelectorPvP;
      
      protected var mDeckSelectorOpponent:DeckSelectorPvP;
      
      public function PopupPlayPvPOffline(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mDeckSelectorOwner)
         {
            this.mDeckSelectorOwner.removeFromParent();
            this.mDeckSelectorOwner.destroy();
            this.mDeckSelectorOwner = null;
         }
         if(this.mDeckSelectorOpponent)
         {
            this.mDeckSelectorOpponent.removeFromParent();
            this.mDeckSelectorOpponent.destroy();
            this.mDeckSelectorOpponent = null;
         }
         InstanceMng.getPopupMng().removePopup(FSPopupMng.PLAY_PVP_OFFLINE_POPUP_NAME);
         super.removeFromStage();
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = BG_NAME;
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createDeckSelectors();
      }
      
      protected function createDeckSelectors() : void
      {
         this.createDeckSelector(true);
         this.createDeckSelector(false);
      }
      
      protected function createDeckSelector(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.mDeckSelectorOwner == null)
            {
               this.mDeckSelectorOwner = new DeckSelectorPvP(true,false);
            }
            this.mDeckSelectorOwner.x = mBox.width + 5;
            this.mDeckSelectorOwner.y = mBox.y;
            this.mDeckSelectorOwner.visible = false;
            this.mDeckSelectorOwner.refresh();
            addChild(this.mDeckSelectorOwner);
         }
         else
         {
            if(this.mDeckSelectorOpponent == null)
            {
               this.mDeckSelectorOpponent = new DeckSelectorPvP(true,true);
            }
            this.mDeckSelectorOpponent.x = 0;
            this.mDeckSelectorOpponent.y = mBox.y;
            mBox.x += this.mDeckSelectorOpponent.width + 5;
            this.mDeckSelectorOwner.x += this.mDeckSelectorOpponent.width + 5;
            mAcceptButton.x += this.mDeckSelectorOpponent.width + 5;
            mCloseButton.x += this.mDeckSelectorOpponent.width + 5;
            this.mDeckSelectorOpponent.visible = false;
            this.mDeckSelectorOpponent.refresh();
            addChild(this.mDeckSelectorOpponent);
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         super.onPopupOpenTransitionOver();
         if(!mClosed)
         {
            this.performTransitionTweenDeckSelector();
         }
      }
      
      private function performTransitionTweenDeckSelector() : void
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:FSCoordinate = null;
         if(this.mDeckSelectorOwner)
         {
            this.mDeckSelectorOwner.x = Starling.current.stage.stageWidth;
            this.mDeckSelectorOwner.visible = true;
            _loc1_ = new FSCoordinate(mBox.x + mBox.width + 5,mBox.y);
            SpecialFX.createTransition(this.mDeckSelectorOwner,_loc1_,0.5);
         }
         if(this.mDeckSelectorOpponent)
         {
            this.mDeckSelectorOpponent.x = -this.mDeckSelectorOpponent.width * 2;
            this.mDeckSelectorOpponent.visible = true;
            _loc2_ = new FSCoordinate(mBox.x - this.mDeckSelectorOpponent.width,mBox.y);
            SpecialFX.createTransition(this.mDeckSelectorOpponent,_loc2_,0.5);
         }
      }
      
      override protected function onAccept(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:UserData = null;
         var _loc2_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isSelectedDeckSizeCorrect(null,true);
         if(_loc2_)
         {
            if(param1)
            {
               param1.stopImmediatePropagation();
            }
            if(this.mDeckSelectorOpponent)
            {
               _loc3_ = this.mDeckSelectorOpponent.getUISelectedDeckIndex();
               _loc4_ = InstanceMng.getUserDataMng().getOpponentUserData(false);
               if(_loc4_)
               {
                  _loc4_.setSelectedDeckIndexPvP(_loc3_);
               }
            }
            closePopup(this.onAcceptPerformActions);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_DECK_AVAILABLE"));
         }
      }
      
      public function setupPopup(param1:String) : void
      {
         this.mLevelDef = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param1));
      }
      
      protected function onAcceptPerformActions() : void
      {
         PvPConnectionMng.smPvPBattleData = null;
         InstanceMng.getUserDataMng().updateSelectedDeckIndexPvP();
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(Root.smBattleData != null)
         {
            Root.smBattleData.online = false;
         }
         _loc1_.startBattle(null,true);
      }
      
      override protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         x = Starling.current.stage.stageWidth / 2 - width / 2;
         y = -height;
         var _loc2_:FSCoordinate = param1 != null ? param1 : new FSCoordinate(x,Starling.current.stage.stageHeight / 2 - height / 2);
         SpecialFX.createTransition(this,_loc2_,0.5,0,this.onPopupOpenTransitionOver,null,Back.easeOut);
      }
   }
}

