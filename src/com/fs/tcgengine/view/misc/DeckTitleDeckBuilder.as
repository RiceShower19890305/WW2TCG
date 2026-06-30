package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   import flash.utils.Dictionary;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class DeckTitleDeckBuilder extends DeckTitleDeckSelector
   {
      
      public function DeckTitleDeckBuilder(param1:int, param2:Boolean, param3:DeckSelectorMini, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function performOnTouchOps() : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:int = 0;
         var _loc1_:ScrollContainer = parent is LayoutViewPort ? ScrollContainer(parent.parent) : null;
         var _loc2_:Boolean = _loc1_ ? _loc1_.isScrolling : false;
         if(_loc2_)
         {
            return;
         }
         if(InstanceMng.getTutorialDeckBuilderMng().isTutorialON())
         {
            if(mDeckIndex != 0)
            {
               return;
            }
         }
         Utils.playSound(Constants.SOUND_CLICK,SoundManager.TYPE_SFX);
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen && (!mIsEmpty || InstanceMng.getUserDataMng().isDeckBought(mDeckIndex)))
         {
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData().getCardCollection();
            _loc4_ = DictionaryUtils.getCatalogCardsAmountCheckingRestrictions(_loc3_,true,Config.getConfig().getDeckCardsAmount());
            if(_loc4_ >= Config.getConfig().getDeckCardsAmount())
            {
               if(FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_CREATION_MODE || FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).isViewAllCardsModeON())
               {
                  Utils.setLogText(TextManager.getText("TID_DECKBUILDER_VIEWALL"));
               }
               else
               {
                  FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).onStartEditingDeck();
                  if(Config.getConfig().gameHasClassSystem())
                  {
                     InstanceMng.getUserDataMng().getOwnerUserData().setSelectedDeckIndex(mDeckIndex);
                     FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).lockUI(true);
                     FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).openJobPanel(this);
                  }
                  else
                  {
                     this.openDeckPanel();
                  }
               }
            }
            else
            {
               Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_DECKBUILDER_DECK_USE"),[Config.getConfig().getDeckCardsAmount()]),true);
            }
         }
         else if(isPurchasable())
         {
            if(Boolean(InstanceMng.getApplication()) && !InstanceMng.getApplication().hasPermanentBoosts())
            {
               Utils.setLogText(TextManager.getText("TID_GEN_OS_FEATURE"),true);
            }
            else
            {
               InstanceMng.getPopupMng().openDeckSlotPopup(mDeckSlotDef);
            }
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_SHOP_DECKSLOT_SUCCESS"));
         }
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         super.onTouch(param1);
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.HOVER);
         mBG.alpha = _loc2_ ? 0.8 : 1;
      }
      
      public function openDeckPanel() : void
      {
         FSDebug.debugTrace("Opening deck");
         if(mParentDeckSelector != null)
         {
            mParentDeckSelector.movePanelDown(this.showDeckPanel);
         }
      }
      
      private function showDeckPanel() : void
      {
         var _loc1_:FSDeckBuilderScreen = null;
         if(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            _loc1_ = FSDeckBuilderScreen(InstanceMng.getCurrentScreen());
            if(_loc1_ != null)
            {
               _loc1_.showDeckPanel(mDeckIndex);
               _loc1_.updateDeckTitleLabel(mDeckIndex);
               _loc1_.showDeckTitle(true);
               _loc1_.setEditButtonVisible(true);
            }
         }
      }
   }
}

