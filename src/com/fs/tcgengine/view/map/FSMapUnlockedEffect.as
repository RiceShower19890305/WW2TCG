package com.fs.tcgengine.view.map
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.Filters;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.filters.FragmentFilter;
   import starling.utils.Align;
   
   public class FSMapUnlockedEffect extends Component
   {
      
      private var mMapDef:MapDef;
      
      private var mBGQuad:Quad;
      
      protected var mTitleTextfield:FSTextfield;
      
      private var mNameTextfield:FSTextfield;
      
      public function FSMapUnlockedEffect(param1:MapDef)
      {
         super();
         this.mMapDef = param1;
      }
      
      public function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FragmentFilter = null;
         var _loc3_:String = null;
         if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()))
         {
            InstanceMng.getUserDataMng().getOwnerUserData().addComicRead(this.mMapDef.getSku(),false);
            InstanceMng.getUserDataMng().persistenceSaveData();
         }
         if(this.mBGQuad == null)
         {
            this.mBGQuad = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,0);
         }
         addChild(this.mBGQuad);
         if(this.mTitleTextfield == null)
         {
            this.mTitleTextfield = new FSTextfield(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight / 8,TextManager.getText("TID_MAP_UNLOCKED") + "...",16777215,60);
            this.mTitleTextfield.touchable = false;
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
            switch(_loc1_)
            {
               case UserDataMng.DIFFICULTY_EASY:
                  _loc2_ = Filters.requestFilter(Constants.FILTER_GLOW_BLUE);
                  break;
               case UserDataMng.DIFFICULTY_MEDIUM:
                  _loc2_ = Filters.requestFilter(Constants.FILTER_GLOW_ORANGE);
                  break;
               case UserDataMng.DIFFICULTY_HARD:
                  _loc2_ = Filters.requestFilter(Constants.FILTER_GLOW_RED);
                  break;
               default:
                  _loc2_ = Filters.requestFilter(Constants.FILTER_GLOW_BLUE);
            }
            this.mTitleTextfield.filter = _loc2_;
            this.mTitleTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mTitleTextfield.format.horizontalAlign = Align.CENTER;
            this.mTitleTextfield.x = 0;
            this.mTitleTextfield.y = (Starling.current.stage.stageHeight - this.mTitleTextfield.height) / 2;
         }
         this.mTitleTextfield.alpha = 0.001;
         TweenMax.delayedCall(1,SpecialFX.tweenToAlpha,[this.mTitleTextfield,0.999,1,0]);
         addChild(this.mTitleTextfield);
         if(this.mNameTextfield == null && Boolean(this.mMapDef))
         {
            _loc3_ = this.mMapDef.getDesc() != null && this.mMapDef.getDesc() != "" ? this.mMapDef.calculateMapName() + ": " + this.mMapDef.calculateMapDesc() : this.mMapDef.calculateMapName();
            this.mNameTextfield = new FSTextfield(Starling.current.stage.stageWidth,this.mTitleTextfield.height / 2,_loc3_);
            this.mNameTextfield.touchable = false;
            this.mNameTextfield.format.horizontalAlign = Align.CENTER;
            this.mNameTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mNameTextfield.x = 0;
            this.mNameTextfield.y = this.mTitleTextfield.y + this.mTitleTextfield.height;
         }
         this.mNameTextfield.alpha = 0.001;
         TweenMax.delayedCall(1.5,SpecialFX.tweenToAlpha,[this.mNameTextfield,0.999,1.5,0]);
         addChild(this.mNameTextfield);
         TweenMax.delayedCall(3,this.removeEffect);
      }
      
      private function removeEffect() : void
      {
         var ratePopupShown:Boolean;
         var setMapUnlockedEffectActive:Function = null;
         var performMapPortraitTransition:Function = null;
         var ownerLevel:int = 0;
         setMapUnlockedEffectActive = function(param1:Boolean):void
         {
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).setIsMapUnlockedEffectActive(param1);
            }
         };
         performMapPortraitTransition = function(param1:Boolean):void
         {
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).performPortraitTransition(param1);
            }
         };
         var delayTextfields:Number = 1.5;
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).setMapsVisible(true);
            FSMapScreen(InstanceMng.getCurrentScreen()).setMapComponentsVisible(true);
         }
         TweenMax.killDelayedCallsTo(this.removeEffect);
         SpecialFX.tweenToAlpha(this.mTitleTextfield,0.001,delayTextfields,0,this.removeTextfieldFromParent,[this.mTitleTextfield]);
         SpecialFX.tweenToAlpha(this.mNameTextfield,0.001,delayTextfields,0,this.removeTextfieldFromParent,[this.mNameTextfield]);
         TweenMax.delayedCall(delayTextfields,SpecialFX.tweenToAlpha,[this.mBGQuad,0.001,1,0,this.removeQuadFromParent,[this.mBGQuad]]);
         TweenMax.delayedCall(delayTextfields,this.removeTranslucentBG);
         ratePopupShown = false;
         if(Boolean(InstanceMng.getUserDataMng()) && InstanceMng.getUserDataMng().getOwnerUserData() != null)
         {
            if(UserDataMng.smRatePopupShownThisSession == false && !Utils.isDesktop() && !InstanceMng.getUserDataMng().getOwnerUserData().flagsGetRatePopupShown() && InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() == UserDataMng.DIFFICULTY_EASY)
            {
               ownerLevel = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
               if(ownerLevel > 10)
               {
                  ratePopupShown = true;
                  TweenMax.delayedCall(delayTextfields + 0.25,this.openRateAppPopup);
               }
            }
         }
         TweenMax.delayedCall(delayTextfields + 0.5,removeFromParent,[true]);
         TweenMax.delayedCall(delayTextfields + 0.5,setMapUnlockedEffectActive,[false]);
         if(!ratePopupShown)
         {
            TweenMax.delayedCall(delayTextfields + 0.6,performMapPortraitTransition,[true]);
         }
      }
      
      private function openRateAppPopup() : void
      {
         if(Boolean(InstanceMng.getPopupMng()) && !Utils.isDesktop())
         {
            UserDataMng.smRatePopupShownThisSession = true;
            InstanceMng.getPopupMng().openRateAppPopup();
         }
      }
      
      private function removeTextfieldFromParent(param1:FSTextfield) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      private function removeTranslucentBG() : void
      {
         if(InstanceMng.getCurrentScreen())
         {
            InstanceMng.getCurrentScreen().removeTranslucentBG();
         }
      }
      
      private function removeQuadFromParent(param1:Quad) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBGQuad)
         {
            this.mBGQuad.removeFromParent(true);
            this.mBGQuad = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(InstanceMng.getComicsMng())
         {
            InstanceMng.getComicsMng().unload();
         }
         this.mMapDef = null;
         super.dispose();
      }
   }
}

