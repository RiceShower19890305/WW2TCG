package com.fs.tcgengine.view.popups.social
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class PopupRegisterKong extends PopupStandard
   {
      
      public function PopupRegisterKong(param1:Boolean = true)
      {
         super(false);
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = "register_kong";
      }
      
      override public function notifyAssetsLoaded() : void
      {
         super.notifyAssetsLoaded();
         mBox.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
      }
      
      private function onBGTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            InstanceMng.getApplication().kongShowRegistrationBox();
         }
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function removeFromStage() : void
      {
         InstanceMng.getPopupMng().removePopup(FSPopupMng.REGISTER_KONG_POPUP_NAME);
         super.removeFromStage();
      }
   }
}

