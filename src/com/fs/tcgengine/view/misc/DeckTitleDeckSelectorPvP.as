package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.Utils;
   import feathers.controls.ScrollContainer;
   import feathers.controls.supportClasses.LayoutViewPort;
   
   public class DeckTitleDeckSelectorPvP extends DeckTitleDeckSelector
   {
      
      public static const BG_NAME_OWNER:String = "deck_title_blue";
      
      public static const BG_NAME_OPPONENT:String = "deck_title_red";
      
      public function DeckTitleDeckSelectorPvP(param1:int, param2:Boolean, param3:DeckSelectorMini, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:Boolean = InstanceMng.getUserDataMng().isDeckBought(mDeckIndex);
         alpha = _loc1_ ? 1 : 0.65;
      }
      
      override protected function createBG() : void
      {
         var _loc1_:String = mIsOpponent ? BG_NAME_OPPONENT : BG_NAME_OWNER;
         if(mBG == null)
         {
            mBG = new FSImage(Root.assets.getTexture(_loc1_));
            addChild(mBG);
         }
      }
      
      override protected function createBGDecoration() : void
      {
         super.createBGDecoration();
         if(mIsOpponent)
         {
            mBGDecoration.x = mBG.width * 0.1;
         }
      }
      
      override public function createBGActiveDeck() : void
      {
         super.createBGActiveDeck();
         if(mIsOpponent)
         {
            mBGActiveDeck.x = mBG.width * 0.1;
         }
      }
      
      override protected function updateIncompleteBG() : void
      {
         super.updateIncompleteBG();
         if(mIsOpponent)
         {
            mBGIncompleteDeck.x = mBG.width * 0.1;
         }
      }
      
      override protected function createStatusLight() : void
      {
         super.createStatusLight();
         if(mStatusLight != null)
         {
            if(mIsOpponent)
            {
               mStatusLight.x = width - mStatusLight.width;
            }
         }
      }
      
      override protected function createStatusTextfield() : void
      {
         super.createStatusTextfield();
         if(mStatusTextfield != null)
         {
            if(mIsOpponent)
            {
               mStatusTextfield.x = mStatusLight.x - mStatusTextfield.width * 0.915;
            }
            if(!InstanceMng.getUserDataMng().isDeckBought(mDeckIndex))
            {
               mStatusTextfield.text = TextManager.getText("TID_GEN_LOCKED");
            }
         }
      }
      
      override protected function performOnTouchOps() : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:UserData = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:DeckTitleDeckSelector = null;
         var _loc1_:ScrollContainer = parent is LayoutViewPort ? ScrollContainer(parent.parent) : null;
         var _loc2_:Boolean = _loc1_ ? _loc1_.isScrolling : false;
         if(_loc2_)
         {
            return;
         }
         if(mAvailable)
         {
            _loc3_ = InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isOnlineMatch();
            _loc4_ = mIsOpponent ? InstanceMng.getUserDataMng().getOpponentUserData(_loc3_) : InstanceMng.getUserDataMng().getOwnerUserData();
            _loc5_ = _loc4_.getSelectedDeckIndexPvP();
            if(mParentDeckSelector != null)
            {
               _loc7_ = mParentDeckSelector.getDeckTitleByIndex(_loc5_);
               if(_loc7_ != null)
               {
                  _loc7_.setIsSelectedDeck(false);
               }
            }
            _loc4_.setSelectedDeckIndexPvP(mDeckIndex);
            _loc6_ = TextManager.getText("TID_GEN_DECK_SELECTED") + " " + InstanceMng.getUserDataMng().getOwnerUserData().getDeckName(mDeckIndex);
            Utils.setLogText(_loc6_);
            setIsSelectedDeck(true);
         }
         else
         {
            Utils.setLogText(TextManager.getText("TID_GEN_GO_DB"),true,false,false);
         }
      }
   }
}

