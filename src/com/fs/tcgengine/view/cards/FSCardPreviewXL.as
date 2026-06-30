package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class FSCardPreviewXL extends FSCardXL
   {
      
      public function FSCardPreviewXL(param1:FSCard)
      {
         super(param1);
      }
      
      override protected function createPromoteInfo() : void
      {
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc4_:Touch = null;
         var _loc5_:Touch = null;
         var _loc6_:Touch = null;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = param1.getTouch(mFavouriteButton,TouchPhase.ENDED);
            if(_loc3_ == null)
            {
               _loc4_ = param1.getTouch(mCraftButton,TouchPhase.ENDED);
               if(_loc4_ == null)
               {
                  _loc5_ = param1.getTouch(mCardFusionButton,TouchPhase.ENDED);
                  if(_loc5_ == null)
                  {
                     _loc6_ = param1.getTouch(mCardSkinButton,TouchPhase.ENDED);
                     if(_loc6_ == null)
                     {
                        mCardTouch = param1.getTouch(this,TouchPhase.ENDED);
                        if(Boolean(mCardTouch) && (mAbilitiesScrollContainer == null || mAbilitiesScrollContainer != null && !mAbilitiesScrollContainer.isScrolling))
                        {
                           if(mParentCard != null)
                           {
                              InstanceMng.getCardsMng().onCardPreviewXLTouched(mParentCard,mCardDef);
                           }
                           else
                           {
                              super.onTouch(param1);
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function onCardPreviewXLTouched() : void
      {
         var _loc1_:CardDef = null;
         var _loc2_:Screen = null;
         var _loc3_:FSCardPreview = null;
         if(mParentCard != null)
         {
            SpecialFX.zoomOut(mParentCard);
            _loc1_ = Utils.getPreviousTierCardDef(mCardDef.getSku());
            _loc2_ = InstanceMng.getCurrentScreen();
            if(_loc1_ != null)
            {
               if(_loc1_.getTier() == _loc2_.getSelectedCard().getCardDef().getTier())
               {
                  SpecialFX.zoomIn(_loc2_.getSelectedCard());
               }
               else
               {
                  _loc3_ = new FSCardPreview(_loc1_.getSku());
                  SpecialFX.zoomIn(_loc3_);
               }
            }
            else
            {
               _loc2_.removeTranslucentBG(true);
            }
         }
      }
   }
}

