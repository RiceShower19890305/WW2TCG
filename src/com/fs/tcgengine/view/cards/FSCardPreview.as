package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.rules.CategoriesDefMng;
   import com.fs.tcgengine.model.rules.CategoryDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSAuctionsScreen;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.battle.GraveyardViewer;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class FSCardPreview extends FSCard
   {
      
      public function FSCardPreview(param1:String)
      {
         super(param1);
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         if(Config.smDebugTooltips)
         {
            mCardTouch = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
            if(mCardTouch)
            {
               setTooltipText(mCardDef.getSku());
            }
         }
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         var _loc3_:Boolean = false;
         if(_loc2_ is FSDeckBuilderScreen)
         {
            _loc3_ = FSDeckBuilderScreen(_loc2_).getCraftingON();
         }
         if(_loc2_ is FSAuctionsScreen)
         {
            _loc2_.setSelectedCard(this);
         }
         if(parent != null)
         {
            mCardTouch = param1.getTouch(this,TouchPhase.ENDED);
            if(Boolean(mCardTouch) && Boolean(!(parent is GraveyardViewer)) && !_loc3_)
            {
               if(!Root.assets.isLoading && !mZoomedIn && _loc2_.getSelectedCard() != null)
               {
                  SpecialFX.zoomOut(_loc2_.getSelectedCard());
                  notifyCardSelected();
                  setZoomedIn(true);
                  SpecialFX.zoomIn(this);
               }
            }
            else if(Boolean(mCardTouch) && parent is GraveyardViewer)
            {
               GraveyardViewer(parent).removeFromGraveyard(this);
            }
         }
      }
      
      override public function createTierFrame(param1:Boolean = false) : void
      {
         if(getType() != FSCard.TYPE_ACTION && getType() != FSCard.TYPE_POWER)
         {
            super.createTierFrame(param1);
         }
      }
      
      override public function showDamageAndShield(param1:Boolean = false) : void
      {
         var _loc2_:CategoryDef = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(getType() != FSCard.TYPE_ACTION && getType() != FSCard.TYPE_POWER)
         {
            _loc2_ = mCardDef ? CategoryDef(InstanceMng.getCategoriesDefMng().getDefBySku(mCardDef.getCategorySku())) : null;
            _loc3_ = _loc2_ ? _loc2_.getIndex() == CategoriesDefMng.CATEGORY_ATTACHMENTS : false;
            if(mBG)
            {
               _loc4_ = mBG.height / 3;
            }
            else if(mBGAnimated)
            {
               _loc4_ = mBGAnimated.height / 3;
            }
            else
            {
               _loc4_ = height / 3;
            }
            if(mDamageTextfield == null)
            {
               mDamageTextfield = new FSTextfield(width,_loc4_,"");
               mDamageTextfield.fontName = _loc3_ ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
               mDamageTextfield.touchable = false;
            }
            if(mDefenseTextfield == null)
            {
               mDefenseTextfield = new FSTextfield(width,_loc4_,"");
               mDefenseTextfield.fontName = _loc3_ ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
               mDefenseTextfield.touchable = false;
            }
            if(mDamageImage == null)
            {
               mDamageImage = new FSImage(Root.assets.getTexture(DAMAGE_IMG_NAME));
               mDamageImage.scaleX = 0.5;
               mDamageImage.scaleY = 0.5;
               mDamageImage.touchable = false;
            }
            if(mDefenseImage == null)
            {
               mDefenseImage = new FSImage(Root.assets.getTexture(DEFENSE_IMG_NAME));
               mDefenseImage.scaleX = 0.5;
               mDefenseImage.scaleY = 0.5;
               mDefenseImage.touchable = false;
            }
            setDamageDefenseTextfieldPosAndSize();
            _loc5_ = getDamage();
            _loc6_ = getDefense();
            mDamageTextfield.text = _loc5_.toString();
            mDamageTextfield.fontSize = 32;
            mDefenseTextfield.text = _loc6_.toString();
            mDefenseTextfield.fontSize = 32;
            addChild(mDamageImage);
            addChild(mDefenseImage);
            addChild(mDamageTextfield);
            addChild(mDefenseTextfield);
            checkSummonCooldownFilter();
         }
      }
      
      override protected function createDropShadowBG() : void
      {
      }
   }
}

