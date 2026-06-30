package com.fs.tcgengine.view.popups.levels
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.BadgeSlot;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.misc.PopupStandard;
   import com.greensock.easing.Back;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class PopupRankPromote extends PopupStandard
   {
      
      private const BG_NAME:String = "bg_promotion";
      
      private const BG_PORTRAIT_PROMOTION:String = "portrait_promotion";
      
      private const BG_RIBBON_PLATE:String = "ribbon_plate";
      
      private var mRibbonContainer:Component;
      
      private var mRibbonTextfield:FSTextfield;
      
      private var mInsigniaContainer:Component;
      
      private var mInsigniaContainerBG:FSImage;
      
      private var mInsigniaImage:FSImage;
      
      private var mLevelDef:LevelDef;
      
      private var mRankDef:RankDef;
      
      private var mIntroAnimsOver:Boolean = false;
      
      private var mBadgeSlot:BadgeSlot;
      
      private var mIsOpenFromProgress:Boolean = false;
      
      public function PopupRankPromote(param1:Boolean = true)
      {
         super(false);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.mInsigniaContainerBG)
         {
            this.mInsigniaContainerBG.rotation += 0.01;
         }
      }
      
      override protected function setResourcesToLoad() : void
      {
         if(this.mRankDef != null)
         {
            if(Config.getConfig().gameHasBadges())
            {
               InstanceMng.getResourcesMng().addResourceToLoad("badgesXL/" + this.mRankDef.getBGXLImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
            }
            else
            {
               InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + this.mRankDef.getBGXLImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
            }
            InstanceMng.getResourcesMng().addResourceToLoad("popups/" + this.BG_PORTRAIT_PROMOTION,FSResourceMng.TYPE_TEXTURE_PNG);
            InstanceMng.getResourcesMng().addResourceToLoad("popups/" + this.BG_RIBBON_PLATE,FSResourceMng.TYPE_TEXTURE_PNG);
            if(Config.getConfig().gameHasBuildingBadges())
            {
               InstanceMng.getResourcesMng().addResourceToLoad("misc/town",FSResourceMng.TYPE_AUDIO);
            }
            super.setResourcesToLoad();
         }
      }
      
      override protected function addBGToLoad() : void
      {
         InstanceMng.getResourcesMng().enqueueSpecialResourceToLoad(mBGName,"popups",FSResourceMng.TYPE_TEXTURE_PNG);
      }
      
      override protected function removeFromStage() : void
      {
         if(this.mRibbonContainer)
         {
            this.mRibbonContainer.removeFromParent(true);
            this.mRibbonContainer = null;
         }
         if(this.mRibbonTextfield)
         {
            this.mRibbonTextfield.removeFromParent(true);
            this.mRibbonTextfield = null;
         }
         if(this.mInsigniaContainer)
         {
            this.mInsigniaContainer.removeFromParent(true);
            this.mInsigniaContainer = null;
         }
         if(this.mInsigniaContainerBG)
         {
            this.mInsigniaContainerBG.removeFromParent(true);
            this.mInsigniaContainerBG = null;
         }
         if(this.mInsigniaImage)
         {
            this.mInsigniaImage.removeFromParent(true);
            this.mInsigniaImage = null;
         }
         if(this.mBadgeSlot)
         {
            this.mBadgeSlot.removeFromParent(true);
            this.mBadgeSlot = null;
         }
         Root.assets.removeTexture(this.mRankDef.getBGXLImageName());
         Root.assets.removeTexture(this.BG_PORTRAIT_PROMOTION);
         Root.assets.removeTexture(this.BG_RIBBON_PLATE);
         Root.assets.removeTexture(mBGName);
         InstanceMng.getPopupMng().removePopup(FSPopupMng.RANK_PROMOTE_POPUP_NAME);
         super.removeFromStage();
      }
      
      override public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.dispose();
      }
      
      override protected function setupAcceptButton(param1:String, param2:String = "", param3:String = "") : void
      {
      }
      
      override protected function getBackgroundName(param1:String) : void
      {
         mBGName = this.BG_NAME;
      }
      
      override protected function createBackground(param1:String, param2:int = 0) : void
      {
         super.createBackground(param1);
         mBox.touchable = true;
         mBox.scale = 2;
         mBox.addEventListener(TouchEvent.TOUCH,this.onBGTouch);
      }
      
      private function onBGTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(Boolean(_loc2_) && this.mIntroAnimsOver)
         {
            touchable = false;
            closePopup(this.onAcceptPerformOps);
         }
      }
      
      override protected function createUI() : void
      {
         super.createUI();
         this.createInsignia();
         this.createRibbonPlate();
         this.createFields();
         if(Config.getConfig().gameHasBuildingBadges())
         {
            this.createBadgeSlot();
         }
      }
      
      private function createBadgeSlot() : void
      {
         if(this.mBadgeSlot == null)
         {
            this.mBadgeSlot = new BadgeSlot(this.mRankDef,InstanceMng.getUserDataMng().getOwnerUserData().getCityName());
            this.mBadgeSlot.x = width / 4;
            addChild(this.mBadgeSlot);
         }
      }
      
      private function createInsignia() : void
      {
         if(this.mRankDef)
         {
            if(this.mInsigniaContainer == null)
            {
               this.mInsigniaContainer = new Component();
               this.mInsigniaContainer.touchable = false;
            }
            if(this.mInsigniaContainerBG == null)
            {
               this.mInsigniaContainerBG = new FSImage(Root.assets.getTexture(this.BG_PORTRAIT_PROMOTION));
               this.mInsigniaContainerBG.alpha = 0.001;
            }
            this.mInsigniaContainerBG.touchable = false;
            this.mInsigniaContainerBG.alignPivot();
            if(Config.getConfig().gameHasBuildingBadges())
            {
               this.mInsigniaContainerBG.x = mBox.width / 2;
               this.mInsigniaContainerBG.y = mBox.height / 2;
            }
            else
            {
               this.mInsigniaContainerBG.x = mBox.width / 2;
               this.mInsigniaContainerBG.y = mBox.height * 0.55;
            }
            this.mInsigniaContainer.addChild(this.mInsigniaContainerBG);
            if(this.mInsigniaImage == null)
            {
               this.mInsigniaImage = new FSImage(Root.assets.getTexture(this.mRankDef.getBGXLImageName()));
            }
            this.mInsigniaImage.alignPivot();
            this.mInsigniaImage.x = this.mInsigniaContainerBG.x;
            this.mInsigniaImage.y = this.mInsigniaContainerBG.y;
            this.mInsigniaImage.alpha = 0.001;
            this.mInsigniaContainer.addChild(this.mInsigniaImage);
            this.mInsigniaContainer.x = 0;
            this.mInsigniaContainer.y = 0;
            addChild(this.mInsigniaContainer);
         }
      }
      
      private function createRibbonPlate() : void
      {
         var _loc1_:FSImage = null;
         if(this.mRibbonContainer == null)
         {
            this.mRibbonContainer = new Component();
            this.mRibbonContainer.touchable = false;
            _loc1_ = new FSImage(Root.assets.getTexture(this.BG_RIBBON_PLATE));
            this.mRibbonContainer.addChild(_loc1_);
            this.mRibbonContainer.x = (width - this.mRibbonContainer.width) / 2;
            this.mRibbonContainer.y = this.mInsigniaContainer.y + this.mInsigniaContainer.height * 0.75;
         }
         if(this.mRibbonTextfield == null)
         {
            this.mRibbonTextfield = new FSTextfield(this.mRibbonContainer.width / 2.5,this.mRibbonContainer.height * 0.6,this.mRankDef.getName(),16777215,FSResourceMng.FONT_STD_TITLE_SIZE * 2);
            this.mRibbonTextfield.x = (this.mRibbonContainer.width - this.mRibbonTextfield.width) / 2;
            this.mRibbonTextfield.y = (this.mRibbonContainer.height - this.mRibbonTextfield.height) / 1.5;
            this.mRibbonTextfield.touchable = false;
            if(Config.getConfig().gameHasBuildingBadges())
            {
               this.mRibbonTextfield.visible = false;
            }
            this.mRibbonTextfield.x = (this.mRibbonContainer.width - this.mRibbonTextfield.width) / 2;
            this.mRibbonContainer.addChild(this.mRibbonTextfield);
         }
      }
      
      override protected function createFields() : void
      {
         var _loc3_:String = null;
         var _loc1_:Number = this.mRibbonContainer.width;
         var _loc2_:Number = this.mRibbonContainer.height * 1.5;
         var _loc4_:int = InstanceMng.getUserDataMng().getOwnerUserData().getBadgesAmountByBadgeSku(this.mRankDef.getBadgeSku());
         if(Config.getConfig().gameHasBuildingBadges())
         {
            _loc3_ = TextManager.replaceParameters(this.mRankDef.getDesc(),[this.mRankDef.getName()]);
         }
         else
         {
            _loc3_ = this.mRankDef.getMessage() != null && this.mRankDef.getMessage() != "" ? this.mRankDef.getMessage() : TextManager.replaceParameters(TextManager.getText("TID_RANK_PROMOTED"),[this.mRankDef.getName(),_loc4_]);
         }
         mInfoTextfield = new FSTextfield(_loc1_,_loc2_,_loc3_,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
         mInfoTextfield.touchable = false;
         mInfoTextfield.x = this.mRibbonContainer.x;
         if(Config.getConfig().gameHasBuildingBadges())
         {
            mInfoTextfield.y = this.mRibbonContainer.y + this.mRibbonContainer.height * 1.6;
         }
         else
         {
            mInfoTextfield.y = this.mRibbonContainer.y + this.mRibbonContainer.height * 4.2;
         }
         mInfoTextfield.alpha = 0.001;
         if(Config.getConfig().gameHasBuildingBadges() && this.mIsOpenFromProgress)
         {
            mInfoTextfield.visible = false;
         }
         addChild(mInfoTextfield);
      }
      
      public function setRankIndex(param1:int) : void
      {
         this.mRankDef = RankDef(InstanceMng.getRanksDefMng().getDefByIndex(param1));
         if(Root.assets.getTexture(this.mRankDef.getBGXLImageName()) == null)
         {
            this.setResourcesToLoad();
         }
      }
      
      public function setLevelDef(param1:LevelDef) : void
      {
         this.mLevelDef = param1;
      }
      
      private function onAcceptPerformOps() : void
      {
         if(!this.mIsOpenFromProgress)
         {
            InstanceMng.getPopupMng().openLevelCompletedPopup(this.mLevelDef,true);
         }
      }
      
      override protected function onPopupOpenTransitionOver() : void
      {
         super.onPopupOpenTransitionOver();
         if(!mClosed)
         {
            this.performComponentsTransition();
         }
      }
      
      private function performComponentsTransition() : void
      {
         if(this.mInsigniaContainerBG)
         {
            SpecialFX.tweenToAlpha(this.mInsigniaContainerBG,0.999,0.5,0,this.performInsigniaTransition);
         }
      }
      
      private function performInsigniaTransition() : void
      {
         if(this.mInsigniaImage)
         {
            SpecialFX.tweenToAlpha(this.mInsigniaImage,0.999,3,0,this.performRibbonTransition);
         }
      }
      
      private function performRibbonTransition() : void
      {
         var _loc1_:FSCoordinate = null;
         addChild(this.mRibbonContainer);
         this.mRibbonContainer.y = Starling.current.stage.stageHeight;
         if(Config.getConfig().gameHasBuildingBadges())
         {
            _loc1_ = new FSCoordinate(this.mRibbonContainer.x,this.mInsigniaContainer.y - this.mInsigniaContainer.height * 0.35);
         }
         else
         {
            _loc1_ = new FSCoordinate(this.mRibbonContainer.x,this.mInsigniaContainer.y + this.mInsigniaContainer.height * 1.4);
         }
         SpecialFX.createTransition(this.mRibbonContainer,_loc1_,0.5,0,this.performTextTransition,null,Back.easeInOut);
      }
      
      private function performTextTransition() : void
      {
         if(mInfoTextfield)
         {
            addChild(mInfoTextfield);
            SpecialFX.tweenToAlpha(mInfoTextfield,0.999,1,0);
            this.mIntroAnimsOver = true;
         }
      }
      
      override protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         x = Starling.current.stage.stageWidth / 2 - width / 2;
         y = Starling.current.stage.stageHeight;
         var _loc2_:FSCoordinate = param1 != null ? param1 : new FSCoordinate(x,Starling.current.stage.stageHeight - height);
         SpecialFX.createTransition(this,_loc2_,0.5,0,this.onPopupOpenTransitionOver,null,Back.easeOut);
      }
      
      override protected function getClosingPopupCoords() : FSCoordinate
      {
         return new FSCoordinate(x,Starling.current.stage.stageHeight);
      }
      
      public function setIsOpenFromProgress(param1:Boolean) : void
      {
         this.mIsOpenFromProgress = param1;
      }
   }
}

