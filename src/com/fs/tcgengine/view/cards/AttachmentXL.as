package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.board.AttachmentsInfoBlock;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class AttachmentXL extends FSCardXL
   {
      
      public function AttachmentXL(param1:FSCard)
      {
         super(param1);
      }
      
      override protected function createPromoteInfo() : void
      {
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(mParentCard != null && mParentCard.parent != null && mParentCard.parent is AttachmentsInfoBlock)
            {
               this.onAttachmentXLTouched();
            }
            else
            {
               super.onTouch(param1);
            }
         }
      }
      
      public function onAttachmentXLTouched() : void
      {
         var _loc1_:FSCardSocket = null;
         var _loc2_:FSUnit = null;
         if(mParentCard != null && mParentCard.parent != null && mParentCard.parent is AttachmentsInfoBlock)
         {
            SpecialFX.zoomOut(mParentCard);
            _loc1_ = mParentCard is FSAttachment ? FSAttachment(mParentCard).getAttachedToSocket() : null;
            _loc2_ = Boolean(_loc1_) && Boolean(_loc1_.getParentCard() != null) && _loc1_.getParentCard() is FSUnit ? FSUnit(_loc1_.getParentCard()) : null;
            if(_loc2_ != null)
            {
               _loc2_.notifyCardSelected();
               SpecialFX.zoomIn(_loc2_);
            }
         }
      }
      
      override protected function setMainTitleText() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         if(mMainTitleTextfield)
         {
            mMainTitleTextfield.text = mCardDef.getName() + " (";
            _loc1_ = mCardDef.getAttachedToSubcategorySku();
            _loc2_ = InstanceMng.getSubCategoriesMng().getSubcategoriesNamesByDefSku(_loc1_);
            if(_loc2_ != "")
            {
               mMainTitleTextfield.text += _loc2_.toUpperCase();
            }
            else
            {
               mMainTitleTextfield.text += TextManager.getText("TID_GEN_ALL_UNITS").toUpperCase();
            }
            mMainTitleTextfield.text += ")";
         }
      }
      
      override protected function createDropShadowBG() : void
      {
      }
   }
}

