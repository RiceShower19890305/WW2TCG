package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   
   public class DeckSelectorPvP extends DeckSelectorMini
   {
      
      public function DeckSelectorPvP(param1:Boolean = false, param2:Boolean = false)
      {
         super(param1,param2);
      }
      
      override protected function createBG() : void
      {
         if(mBG == null)
         {
            mBG = Utils.createCustomBox(DeckCardsPanel.DECK_PANEL_NAME,DeckCardsPanel.DECK_PANEL_WIDTH);
            mBG.alignPivot();
            mBG.scaleX = -1;
            mBG.x += mBG.width / 2;
            mBG.y += mBG.height / 2;
            addChild(mBG);
         }
      }
      
      override protected function createTitle(param1:Number = 5) : void
      {
         super.createTitle();
         if(mTitleTextfield != null)
         {
            mTitleTextfield.fontName = mIsOpponent ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE);
            mTitleTextfield.text = mIsOpponent ? TextManager.getText("TID_PVP_PLAYER_2") : TextManager.getText("TID_PVP_PLAYER_1");
         }
      }
      
      override protected function createDeckTitle(param1:int, param2:Boolean = false) : DeckTitleDeckSelector
      {
         return new DeckTitleDeckSelectorPvP(param1,param2,this,mIsPvP,mIsOpponent);
      }
      
      override protected function getSelectedDeckIndex() : int
      {
         return InstanceMng.getUserDataMng().getOwnerUserData().getSelectedDeckIndexPvP();
      }
   }
}

