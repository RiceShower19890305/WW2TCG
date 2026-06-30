package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.rules.AuctionTicketDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.Utils;
   import flash.ui.Mouse;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class FSAuctionTicketsVisor extends FSGoldVisor
   {
      
      public function FSAuctionTicketsVisor(param1:String = "", param2:String = "", param3:Boolean = false, param4:Function = null, param5:String = "", param6:Number = 1)
      {
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override public function updateAmount() : void
      {
         var _loc1_:UserData = null;
         if(mAmountTextfield != null)
         {
            _loc1_ = Utils.getOwnerUserData();
            mAmountTextfield.text = _loc1_ ? _loc1_.getAuctionTickets().toString() : "?";
         }
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:AuctionTicketDef = null;
         var _loc2_:Touch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getCurrentScreen() is FSMapScreen && FSMapScreen(InstanceMng.getCurrentScreen()).isSubMenuShown();
            if(_loc3_)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).closeSubMenu();
            }
            Utils.playSound(Constants.SOUND_CLICK,SoundManager.TYPE_SFX);
            if(mOnClickFunction != null)
            {
               mOnClickFunction();
               disableButtonTemporarily();
            }
            else
            {
               _loc4_ = InstanceMng.getTutorialMng().isTutorialOver();
               if(_loc4_)
               {
                  disableButtonTemporarily();
                  _loc5_ = AuctionTicketDef(InstanceMng.getAuctionTicketsDefMng().getDefBySku("token_02"));
                  if(_loc5_)
                  {
                     InstanceMng.getPopupMng().openBuyAuctionTicketsBagPopup(_loc5_);
                  }
               }
            }
         }
         _loc2_ = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
         mBG.scaleX = _loc2_ ? 1.04 : 1;
         mBG.scaleY = _loc2_ ? 1.04 : 1;
         mAmountTextfield.scaleX = _loc2_ ? 1.04 : 1;
         mAmountTextfield.scaleY = _loc2_ ? 1.04 : 1;
         if(mTitleTextfield)
         {
            mTitleTextfield.scaleX = _loc2_ ? 1.04 : 1;
            mTitleTextfield.scaleY = _loc2_ ? 1.04 : 1;
         }
         if(Utils.isBrowser() || Utils.isDesktop())
         {
            Mouse.cursor = _loc2_ ? "hand" : "auto";
         }
      }
   }
}

