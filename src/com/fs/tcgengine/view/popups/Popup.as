package com.fs.tcgengine.view.popups
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import starling.core.Starling;
   
   public class Popup extends Component
   {
      
      public static const TRANSITION_TIME:Number = 0.35;
      
      protected var mOnClosedFunction:Function;
      
      protected var mClosed:Boolean = true;
      
      protected var mBGName:String;
      
      protected var mBox:Component;
      
      protected var mBG:FSImage;
      
      protected var mFullyLoaded:Boolean = false;
      
      private var mCoordToOpen:FSCoordinate = null;
      
      protected var mLoadingResources:Boolean = false;
      
      protected var mIsClosing:Boolean = false;
      
      protected var mIsBeingHidden:Boolean = false;
      
      public function Popup(param1:String = "")
      {
         InstanceMng.getPopupMng().setPopupIsLoading(true);
         this.getBackgroundName(param1);
         super();
         this.setResourcesToLoad();
      }
      
      protected function setResourcesToLoad() : void
      {
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_ != null)
         {
            _loc1_.showLoadingIcon(true,true);
            this.addBGToLoad();
            InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
            this.mLoadingResources = true;
         }
      }
      
      protected function addBGToLoad() : void
      {
         var _loc1_:Screen = null;
         if(!Config.getConfig().gameHasCustomPopups())
         {
            _loc1_ = InstanceMng.getCurrentScreen();
            if(_loc1_ != null)
            {
               if(this.mBGName != Constants.STD_POPUP_BG_NAME && Root.assets.getTexture(this.mBGName) == null)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("popups/" + this.mBGName,FSResourceMng.TYPE_TEXTURE_PNG);
               }
            }
         }
      }
      
      public function notifyAssetsLoaded() : void
      {
         this.mFullyLoaded = true;
         this.mLoadingResources = false;
         if(InstanceMng.getCurrentScreen())
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         }
         this.createUI();
         this.openPopup(this.mCoordToOpen);
      }
      
      protected function createUI() : void
      {
         this.createBackground(this.mBGName);
         addChild(this.mBox);
      }
      
      protected function getBackgroundName(param1:String) : void
      {
         this.mBGName = param1 == "" || param1 == null ? Constants.STD_POPUP_BG_NAME : param1;
      }
      
      protected function createBackground(param1:String, param2:int = 1000) : void
      {
         this.updateBGTexture(this.mBGName,param2);
      }
      
      public function updateBGTexture(param1:String, param2:int = 1000) : void
      {
         if(this.mBox)
         {
            this.mBox.removeChildren();
         }
         var _loc3_:String = param1 + "_left";
         var _loc4_:String = param1 + "_center";
         if(Config.getConfig().gameHasCustomPopups() && Root.assets.getTexture(_loc3_) != null && Root.assets.getTexture(_loc4_) != null)
         {
            this.mBox = Utils.createCustomBox(param1,param2,false,this.isBackgroundVisible());
         }
         else
         {
            if(this.mBox == null)
            {
               this.mBox = new Component();
            }
            if(this.mBG == null)
            {
               this.mBG = new FSImage(Root.assets.getTexture(param1));
            }
            else
            {
               this.mBG.texture = Root.assets.getTexture(param1);
            }
            this.mBox.addChild(this.mBG);
            this.mBG.visible = this.isBackgroundVisible();
         }
      }
      
      public function openPopup(param1:FSCoordinate = null) : void
      {
         var _loc2_:Screen = null;
         var _loc3_:Boolean = false;
         if(this.mFullyLoaded)
         {
            _loc2_ = InstanceMng.getCurrentScreen();
            _loc3_ = _loc2_ is FSMapScreen;
            if(_loc3_)
            {
               FSMapScreen(_loc2_).make3DSceneVisible(false,0);
            }
            TweenMax.delayedCall(0,this.performOnOpenDefaultOps,[param1]);
         }
         else if(!this.mLoadingResources)
         {
            this.mCoordToOpen = param1;
            this.setResourcesToLoad();
         }
      }
      
      protected function performOnOpenDefaultOps(param1:FSCoordinate, param2:Number = 0.6) : void
      {
         if(this.mClosed || !this.mClosed && InstanceMng.getPopupMng().getPopupInBackground() == this)
         {
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().createTranslucentBG(true,param2);
            }
            this.addButtonsEventListeners();
            x -= width;
            y = Starling.current.stage.stageHeight / 2 - height / 2;
            FSResourceMng.addToStage(this,FSResourceMng.LAYER_UI);
            this.mClosed = false;
            this.performOpeningTransition(param1);
            if(InstanceMng.getPopupMng())
            {
               InstanceMng.getPopupMng().setPopupShown(this);
               InstanceMng.getPopupMng().setPopupIsLoading(false);
            }
         }
      }
      
      protected function performOpeningTransition(param1:FSCoordinate = null) : void
      {
         var _loc2_:int = Starling.current.stage.stageWidth;
         var _loc3_:FSCoordinate = param1 != null ? param1 : new FSCoordinate((_loc2_ - width) / 2,y);
         SpecialFX.createTransition(this,_loc3_,TRANSITION_TIME,0,this.onPopupOpenTransitionOver,null,Back.easeOut);
      }
      
      public function hideTemporarily(param1:Function = null, param2:Array = null) : void
      {
         var coord:FSCoordinate;
         var onHidden:Function = null;
         var onCompleteFunction:Function = param1;
         var onCompleteParams:Array = param2;
         onHidden = function():void
         {
            mIsBeingHidden = false;
            if(onCompleteFunction != null)
            {
               if(onCompleteParams)
               {
                  TweenMax.delayedCall(0,onCompleteFunction,onCompleteParams);
               }
               else
               {
                  TweenMax.delayedCall(0,onCompleteFunction);
               }
            }
         };
         this.mIsBeingHidden = true;
         InstanceMng.getPopupMng().updatePopupInBackground();
         coord = new FSCoordinate(x,-height);
         SpecialFX.createTransition(this,coord,0.25,0,onHidden,null,Back.easeIn);
      }
      
      protected function onPopupOpenTransitionOver() : void
      {
      }
      
      public function closePopup(param1:Function = null) : void
      {
         this.mIsClosing = true;
         TweenMax.killTweensOf(this);
         this.removeButtonsEventListeners();
         this.mOnClosedFunction = param1;
         SpecialFX.createTransition(this,this.getClosingPopupCoords(),TRANSITION_TIME,0,this.removeFromStage,null,Back.easeIn);
      }
      
      public function isClosing() : Boolean
      {
         return this.mIsClosing;
      }
      
      public function isBeingHidden() : Boolean
      {
         return this.mIsBeingHidden;
      }
      
      protected function getClosingPopupCoords() : FSCoordinate
      {
         return new FSCoordinate(Starling.current.stage.stageWidth,y);
      }
      
      protected function removeFromStage() : void
      {
         var _loc3_:Boolean = false;
         InstanceMng.getPopupMng().setPopupShown(null);
         var _loc1_:Popup = InstanceMng.getPopupMng().getPopupInBackground();
         if(this == _loc1_)
         {
            InstanceMng.getPopupMng().setPopupInBackground(null);
         }
         this.mClosed = true;
         var _loc2_:Screen = InstanceMng.getCurrentScreen();
         if(Boolean(_loc2_) && this.removeTranslucentBG())
         {
            _loc3_ = !(_loc2_ is FSDeckBuilderScreen) || _loc2_ is FSDeckBuilderScreen && !FSDeckBuilderScreen(_loc2_).getCraftPanelShown();
            if(_loc3_)
            {
               FSDebug.debugTrace("***********popup - removeFromStage - removeTranslucentBG***********");
               InstanceMng.getCurrentScreen().removeTranslucentBG();
            }
         }
         this.mFullyLoaded = false;
         this.mLoadingResources = false;
         this.mCoordToOpen = null;
         if(this.mBox)
         {
            this.mBox.removeFromParent();
            this.mBox = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mOnClosedFunction != null)
         {
            this.mOnClosedFunction();
            this.mOnClosedFunction = null;
         }
         removeEventListeners();
         this.onPopupClosingSetMapScreenVisibility();
         if(InstanceMng.getPopupMng().getPopupInBackground() != null)
         {
            InstanceMng.getPopupMng().resumePopupInBackground();
         }
         else
         {
            InstanceMng.getPopupMng().showFirstQueuedPopup();
         }
         if(InstanceMng.getCurrentScreen() is FSMapScreen && FSMapScreen(InstanceMng.getCurrentScreen()).isOkToTransitionMapPortrait())
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).performPortraitTransition(true);
         }
         removeFromParent(true);
      }
      
      private function onPopupClosingSetMapScreenVisibility() : void
      {
         if(InstanceMng.getCurrentScreen() is FSMapScreen && InstanceMng.getPopupMng().getPopupInBackground() == null)
         {
            FSMapScreen(InstanceMng.getCurrentScreen()).make3DSceneVisible(true,0.3);
         }
      }
      
      protected function addButtonsEventListeners() : void
      {
      }
      
      protected function removeButtonsEventListeners() : void
      {
      }
      
      public function hasCloseButton() : Boolean
      {
         return false;
      }
      
      public function hasAcceptButton() : Boolean
      {
         return false;
      }
      
      public function hasCancelButton() : Boolean
      {
         return false;
      }
      
      public function onConnectionChange() : void
      {
      }
      
      public function canBeClosedTappingBG() : Boolean
      {
         return this.allowClosureTappingBG() && (this.hasCloseButton() || this.hasCancelButton());
      }
      
      public function allowClosureTappingBG() : Boolean
      {
         return true;
      }
      
      public function removeTranslucentBG() : Boolean
      {
         return true;
      }
      
      protected function isBackgroundVisible() : Boolean
      {
         return true;
      }
   }
}

