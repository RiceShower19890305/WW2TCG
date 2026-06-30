package com.fs.tcgengine.view.components.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.popups.map.PlayerStatisticsBar;
   import com.fs.tcgengine.view.popups.Popup;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class CustomizePlayerBanner extends PlayerStatisticsBar
   {
      
      public function CustomizePlayerBanner()
      {
         super();
      }
      
      override protected function createUI() : void
      {
         this.createBG();
         createSelectedPortraitContainer();
         this.createNameTextfield();
         this.createSubtitle();
         createEditButton();
         mBG.addEventListener(TouchEvent.TOUCH,this.onTouch);
         Utils.alignComponentAndFixPosition(this);
         mNameTextfield.touchable = false;
         mSubtitleTextfield.touchable = false;
         mEditButton.touchable = false;
         mPortraitViewer.touchable = false;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Popup = null;
         var _loc2_:Touch = param1.getTouch(mBG,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getPopupMng().getPopupShown();
            if(_loc3_)
            {
               _loc3_.closePopup(InstanceMng.getPopupMng().openEditProfilePopup);
            }
            else
            {
               InstanceMng.getPopupMng().openEditProfilePopup();
            }
         }
         scale = param1.getTouch(mBG,TouchPhase.HOVER) != null ? 1.05 : 1;
      }
      
      override protected function createBG() : void
      {
         if(mBG == null)
         {
            mBG = Utils.createCustomBox(BG_NAME,572);
            addChild(mBG);
         }
      }
      
      override protected function createNameTextfield(param1:int = -1) : void
      {
         var _loc2_:int = mBG.width * 0.9 - (mPortraitViewer.x + mPortraitViewer.width);
         super.createNameTextfield(_loc2_);
      }
      
      override protected function createSubtitle(param1:int = -1) : void
      {
         super.createSubtitle(mNameTextfield.width);
      }
   }
}

