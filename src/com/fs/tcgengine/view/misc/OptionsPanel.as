package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.popups.Popup;
   import com.greensock.TweenMax;
   import starling.events.Event;
   
   public class OptionsPanel extends Component implements FSModelUnloadableInterface
   {
      
      private const BG_NAME:String = "options_panel";
      
      private var mBG:Component;
      
      private var mBGImage:FSImage;
      
      private var mMainIcon:FSButton;
      
      private var mParentScreen:Screen;
      
      private var mShowingCredits:Boolean = false;
      
      public function OptionsPanel(param1:Screen)
      {
         super();
         this.mParentScreen = param1;
         this.createMainContainer();
         this.createMainButton();
         this.setEnabled(InstanceMng.getApplication().isGamePlayable());
      }
      
      private function createMainContainer() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new Component();
            addChild(this.mBG);
         }
      }
      
      private function createMainButton() : void
      {
         if(this.mMainIcon == null)
         {
            this.mMainIcon = new FSButton(Root.assets.getTexture("settings_button"));
            this.mMainIcon.addEventListener(Event.TRIGGERED,this.onMainTriggered);
            this.mBG.addChild(this.mMainIcon);
         }
      }
      
      private function createMovablePanel() : void
      {
         if(this.mBGImage == null)
         {
            this.mBGImage = new FSImage(Root.assets.getTexture(this.BG_NAME));
            this.mBGImage.alignPivot();
            this.mBGImage.x = this.mBGImage.width / 2;
            this.mBGImage.y = this.mBGImage.height;
            this.mBG.addChild(this.mBGImage);
         }
      }
      
      private function onMainTriggered(param1:Event) : void
      {
         this.disableButtonTemporarily();
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(_loc2_ is FSMapScreen && FSMapScreen(_loc2_).isShowingComic())
         {
            return;
         }
         if(Boolean(_loc2_ is FSBattleScreen) && Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().getAbilityWaitingForTarget() != null)
         {
            return;
         }
         var _loc3_:Popup = InstanceMng.getPopupMng().getPopupShown();
         if(_loc3_ == null)
         {
            InstanceMng.getPopupMng().openSettingsPopup();
         }
      }
      
      public function setCreditsBeingShown(param1:Boolean) : void
      {
         this.mShowingCredits = param1;
      }
      
      public function areCreditsBeingShown() : Boolean
      {
         return this.mShowingCredits;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(this.mMainIcon)
         {
            this.mMainIcon.enabled = param1;
         }
      }
      
      private function areMiscButtonsAvailable() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:BattleEngine = null;
         var _loc4_:Boolean = false;
         var _loc1_:Boolean = false;
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            _loc2_ = InstanceMng.getBattleEngine().getPlayersStateId();
            _loc3_ = InstanceMng.getBattleEngine();
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.isPvPMatch() && !_loc3_.isOnlineMatch();
               if(!_loc4_)
               {
                  return _loc2_ == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS;
               }
               _loc1_ = _loc2_ == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS || _loc2_ == BattleEngine.STATE_OPPONENT_MOVING_CARDS;
            }
         }
         else
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function isEnabled() : Boolean
      {
         return Boolean(this.mMainIcon) && this.mMainIcon.enabled;
      }
      
      private function disableButtonTemporarily() : void
      {
         this.setEnabled(false);
         TweenMax.delayedCall(1,this.setEnabled,[true]);
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGImage)
         {
            this.mBGImage.removeFromParent(true);
            this.mBGImage = null;
         }
         if(this.mMainIcon)
         {
            this.mMainIcon.removeFromParent(true);
            this.mMainIcon = null;
         }
         this.mParentScreen = null;
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mBGImage)
         {
            this.mBGImage.removeFromParent();
            this.mBGImage.destroy();
            this.mBGImage = null;
         }
         if(this.mMainIcon)
         {
            this.mMainIcon.removeFromParent();
            this.mMainIcon.destroy();
            this.mMainIcon = null;
         }
         this.mParentScreen = null;
      }
   }
}

