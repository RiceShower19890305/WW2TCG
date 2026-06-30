package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.cards.PermanentParticleAnimation;
   import com.fs.tcgengine.view.board.AbilityInfoBlock;
   import starling.core.Starling;
   
   public class FSInfoCardXL extends FSCardXL
   {
      
      private var mParticleSystem:PermanentParticleAnimation;
      
      public function FSInfoCardXL(param1:FSCard)
      {
         super(param1);
      }
      
      override protected function initializeCard(param1:CardDef, param2:Boolean = false) : void
      {
         super.initializeCard(param1,param2);
         if(Config.getConfig().XLViewUsesParticles())
         {
            this.mParticleSystem = InstanceMng.getCardAnimsMng().requestZoomInAnimation(this);
         }
      }
      
      override protected function removeMainElements(param1:Boolean = false) : void
      {
         if(Config.getConfig().XLViewUsesParticles())
         {
            if(this.mParticleSystem)
            {
               this.mParticleSystem.unload();
               this.mParticleSystem.removeFromParent(true);
               this.mParticleSystem = null;
            }
         }
         super.removeMainElements(param1);
      }
      
      override protected function createAttachmentsBlock() : void
      {
      }
      
      override protected function createPromoteInfo() : void
      {
      }
      
      override protected function setHeightPercentages() : void
      {
         if(Config.getConfig().XLViewHasCustomBG())
         {
            mAbilitiesHeightBlockPercent = ABILITIES_BLOCK_HEIGHT_PERCENTAGE * 1.95;
            mDescBlockHeightPercent = DESCRIPTION_BLOCK_HEIGHT_PERCENTAGE / 1.5;
         }
         else if(mParentCard is FSAction)
         {
            mAbilitiesHeightBlockPercent = FSCardXL.ABILITIES_BLOCK_HEIGHT_PERCENTAGE;
            mDescBlockHeightPercent = 100;
         }
         else
         {
            super.setHeightPercentages();
         }
      }
      
      override protected function createAbilitiesScrollContainer(param1:Boolean = false) : void
      {
         super.createAbilitiesScrollContainer(Config.getConfig().XLViewHasCustomBG());
      }
      
      override public function createTierFrame(param1:Boolean = false) : void
      {
         var _loc2_:int = mParentCard.getType();
         if(_loc2_ != FSCard.TYPE_ACTION && _loc2_ != FSCard.TYPE_POWER)
         {
            super.createTierFrame(param1);
         }
      }
      
      override public function showDamageAndShield(param1:Boolean = false) : void
      {
         var _loc2_:int = mParentCard.getType();
         if(_loc2_ != FSCard.TYPE_ACTION && _loc2_ != FSCard.TYPE_POWER)
         {
            super.showDamageAndShield(param1);
         }
      }
      
      override protected function createDescriptionInfoBlock() : void
      {
         super.createDescriptionInfoBlock();
         if(Boolean(mParentCard) && Boolean(mParentCard is FSAction) && Boolean(mDescriptionInfoBlock))
         {
            mDescriptionInfoBlock.y = mFrameBG ? mFrameBG.y : Starling.current.stage.stageHeight * 0.25;
         }
         if(Config.getConfig().XLViewHasCustomBG())
         {
            if(mDescriptionInfoBlock)
            {
               if(Utils.isAndroidOrDesktop() || Utils.isIphone())
               {
                  mDescriptionInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.15 : width + width * 0.5;
               }
               else
               {
                  mDescriptionInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.15 : width + 15;
               }
               mDescriptionInfoBlock.y = mFrameBG ? mFrameBG.y : 0;
            }
         }
      }
      
      override protected function createCardUpgradesThumbnails() : void
      {
         super.createCardUpgradesThumbnails();
         if(Config.getConfig().XLViewHasCustomBG())
         {
            if(Boolean(mCardUpgradesInfoBlock) && (mFrameBG != null || mBG != null || mBGAnimated != null))
            {
               mCardUpgradesInfoBlock.x = mFrameBG ? mFrameBG.x + mFrameBG.width * 1.1 : width * 1.2;
               if(mFrameBG)
               {
                  mCardUpgradesInfoBlock.y = mFrameBG.y + mFrameBG.height * 0.85;
               }
               else
               {
                  mCardUpgradesInfoBlock.y = mBG ? mBG.y + mBG.height * 0.85 : mBGAnimated.y + mBGAnimated.height * 0.85;
               }
            }
         }
      }
      
      override protected function addAbBlockToScrollableContainer(param1:AbilityInfoBlock) : void
      {
         super.addAbBlockToScrollableContainer(param1);
         if(Config.getConfig().XLViewHasCustomBG() && Utils.isAndroidOrDesktop() && Boolean(mAbilitiesScrollContainer))
         {
            mAbilitiesScrollContainer.x = mFrameBG ? mFrameBG.x - param1.width * 1.35 : mFactionFrameBG.x - param1.width * 1.35;
         }
      }
      
      override protected function setMainTitleText() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         if(mMainTitleTextfield)
         {
            mMainTitleTextfield.text = mCardDef.getName() + " (";
            if(mParentCard is FSAttachment)
            {
               _loc1_ = mCardDef.getAttachedToSubcategorySku();
               _loc2_ = InstanceMng.getSubCategoriesMng().getSubcategoriesNamesByDefSku(_loc1_);
               if(_loc2_ != "")
               {
                  mMainTitleTextfield.text += _loc2_.toUpperCase() + ")";
               }
               else
               {
                  mMainTitleTextfield.text += TextManager.getText("TID_GEN_ALL_UNITS").toUpperCase() + ")";
               }
            }
            else
            {
               super.setMainTitleText();
            }
         }
      }
   }
}

