package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.rules.ComicStripDef;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.map.ComicStrip;
   import com.fs.tcgengine.view.map.FSMapUnlockedEffect;
   import com.greensock.TweenMax;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   
   public class ComicMng
   {
      
      private var mComicStripsDefs:Array;
      
      private var mComicStripDefsRequested:Boolean;
      
      private var mResourcesLoaded:Boolean = true;
      
      private var mComicStripsCatalog:Dictionary;
      
      private var mCurrentComicStripShowOrderIndex:int = 0;
      
      private var mExitRequested:Boolean = false;
      
      private var mComicSkippable:Boolean = false;
      
      private var mComicContainer:Component;
      
      private var mActiveComicStrip:ComicStrip;
      
      private var mMapUnlockedSku:String;
      
      private var mMapUnlockedFX:FSMapUnlockedEffect;
      
      private var mIsComicViewerReproduction:Boolean;
      
      private var mComicFinished:Boolean = false;
      
      public function ComicMng()
      {
         super();
      }
      
      public function onMapUnlocked(param1:String) : void
      {
         this.mMapUnlockedSku = param1;
         this.mComicSkippable = false;
         if(!this.mComicStripDefsRequested)
         {
            this.mComicStripsDefs = InstanceMng.getComicStripsDefMng().getComicStripsDefsByMapSku(param1);
            this.mComicStripDefsRequested = true;
         }
         this.createComicStrips(param1);
      }
      
      private function createComicStrips(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ComicStripDef = null;
         var _loc6_:String = null;
         if(param2)
         {
            if(!Root.assets.isLoading)
            {
               if(InstanceMng.getCurrentScreen())
               {
                  InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
               }
            }
            else
            {
               TweenMax.delayedCall(1,this.createComicStrips,[param1,true]);
            }
         }
         else if(this.mComicStripsDefs != null && this.mComicStripDefsRequested && this.mMapUnlockedSku != null && this.mMapUnlockedSku != "")
         {
            _loc4_ = int(this.mComicStripsDefs.length);
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().showLoadingIcon(true,true);
            }
            _loc6_ = this.mMapUnlockedSku ? "comic_" + this.mMapUnlockedSku.split("_")[1] : "";
            InstanceMng.getResourcesMng().addResourcesFolderByName("comic/" + _loc6_);
            if(!Utils.isBrowser())
            {
               InstanceMng.getResourcesMng().addSpecialScreenResources("comic/" + _loc6_);
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this.mComicStripsDefs[_loc3_];
               if(_loc5_ != null)
               {
                  if(InstanceMng.getCurrentScreen() is FSMapScreen)
                  {
                     this.createAndLoadComicResources(_loc5_);
                  }
               }
               _loc3_++;
            }
            if(_loc3_ == _loc4_)
            {
               if(InstanceMng.getCurrentScreen())
               {
                  if(!Root.assets.isLoading)
                  {
                     InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
                  }
                  else
                  {
                     TweenMax.delayedCall(1,this.createComicStrips,[param1,true]);
                  }
               }
            }
         }
      }
      
      private function createAndLoadComicResources(param1:ComicStripDef) : void
      {
         var _loc2_:ComicStrip = new ComicStrip();
         _loc2_.init(param1);
         if(this.mComicStripsCatalog == null)
         {
            this.mComicStripsCatalog = new Dictionary(true);
         }
         if(this.mComicStripsCatalog[_loc2_.getIndex()] == null)
         {
            this.mComicStripsCatalog[_loc2_.getIndex()] = _loc2_;
         }
         else if(Capabilities.isDebugger)
         {
            throw new Error("Comic strip already stored at that position.");
         }
      }
      
      public function notifyAssetsLoaded() : void
      {
         var _loc2_:ComicStrip = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
         this.mResourcesLoaded = true;
         var _loc1_:Array = DictionaryUtils.sortDictionaryByKey(this.mComicStripsCatalog);
         if(_loc1_ != null)
         {
            InstanceMng.getCurrentScreen().createTranslucentBG(true,0.999,1.5);
            this.mComicContainer = new Component();
            this.mComicContainer.alpha = 0.001;
            InstanceMng.getCurrentScreen().addChild(this.mComicContainer);
            InstanceMng.getCurrentScreen().setComicContainer(this.mComicContainer);
            _loc3_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               _loc2_ = _loc1_[_loc3_].value;
               this.onComicStripTriggerStepOps(_loc2_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               _loc2_ = _loc1_[_loc3_].value;
               _loc2_.refreshPosition();
               _loc3_++;
            }
            _loc4_ = Starling.current.stage.stageWidth;
            _loc5_ = Starling.current.stage.stageHeight;
            this.mComicContainer.x = (_loc4_ - this.mComicContainer.width) / 2;
            this.mComicContainer.y = (_loc5_ - this.mComicContainer.height) / 2;
            TweenMax.delayedCall(1,this.activateCurrentComicStrip);
         }
      }
      
      private function onComicStripTriggerStepOps(param1:ComicStrip) : void
      {
         this.showComicStrip(param1);
      }
      
      private function showComicStrip(param1:ComicStrip) : void
      {
         if(param1)
         {
            param1.show();
         }
      }
      
      public function activateCurrentComicStrip() : void
      {
         var _loc1_:ComicStrip = this.getActiveComicStrip();
         if(_loc1_ != null)
         {
            this.mComicSkippable = true;
            _loc1_.activate();
         }
         else
         {
            FSDebug.debugTrace("[activateCurrentComicStrip] NOT FOUND COMIC STRIP");
         }
      }
      
      private function getActiveComicStrip() : ComicStrip
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ComicStripDef = null;
         var _loc1_:ComicStrip = null;
         if(this.mComicStripsDefs != null)
         {
            _loc3_ = int(this.mComicStripsDefs.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this.mComicStripsDefs[_loc2_];
               if(_loc4_ != null)
               {
                  if(_loc4_.getShowOrder() == this.mCurrentComicStripShowOrderIndex)
                  {
                     this.mActiveComicStrip = this.mComicStripsCatalog ? this.mComicStripsCatalog[_loc4_.getIndex()] : null;
                     return this.mActiveComicStrip;
                  }
               }
               _loc2_++;
            }
         }
         return _loc1_;
      }
      
      public function activateNextStrip(param1:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc2_:ComicStrip = this.getActiveComicStrip();
         if(_loc2_ != null)
         {
            _loc2_.reset();
         }
         ++this.mCurrentComicStripShowOrderIndex;
         if(this.mComicStripsDefs != null && this.mCurrentComicStripShowOrderIndex < this.mComicStripsDefs.length)
         {
            this.activateCurrentComicStrip();
         }
         else if(!this.mExitRequested)
         {
            _loc3_ = InstanceMng.getApplication().isBrowserVersion() || Utils.isDesktop() ? TextManager.getText("TID_COMIC_CONTINUE_BROWSER") : TextManager.getText("TID_COMIC_CONTINUE");
            Utils.setLogText(_loc3_);
            this.mExitRequested = true;
         }
         else
         {
            Utils.removeLog();
            this.fadeComic();
         }
      }
      
      public function fadeComic() : void
      {
         var _loc1_:ComicStrip = null;
         var _loc3_:Function = null;
         var _loc2_:int = 0;
         if(Boolean(this.mComicStripsCatalog) && Boolean(this.mComicStripsDefs))
         {
            for each(_loc1_ in this.mComicStripsCatalog)
            {
               _loc3_ = null;
               if(_loc2_ == this.mComicStripsDefs.length - 1)
               {
                  _loc3_ = this.onComicFaded;
               }
               if(_loc1_)
               {
                  _loc1_.fade(_loc3_);
                  _loc2_++;
               }
            }
         }
      }
      
      public function onComicFaded() : void
      {
         var _loc1_:Screen = null;
         var _loc2_:ComicStrip = null;
         var _loc3_:MapDef = null;
         var _loc4_:Number = NaN;
         if(!this.mComicFinished)
         {
            this.mComicFinished = true;
            _loc1_ = InstanceMng.getCurrentScreen();
            if(_loc1_)
            {
               _loc1_.createTranslucentBG(false,0.0001,2);
               if(_loc1_ is FSMapScreen)
               {
                  FSMapScreen(_loc1_).setIsShowingComic(false);
               }
               if(_loc1_.getComicContainer())
               {
                  _loc1_.getComicContainer().filter = null;
                  _loc1_.getComicContainer().removeFromParent();
               }
               if(!this.mIsComicViewerReproduction)
               {
                  InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("comic",InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
               }
               if(this.mMapUnlockedSku != null && this.mMapUnlockedSku != "")
               {
                  InstanceMng.getResourcesMng().removeResourcesFromSpecificFolder("comic/comic_" + this.mMapUnlockedSku.split("map_")[1],InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_TEXTURE));
               }
               _loc1_.getComicContainer().removeFromParent(true);
            }
            if(this.mComicStripsCatalog)
            {
               for each(_loc2_ in this.mComicStripsCatalog)
               {
                  if(_loc2_)
                  {
                     _loc2_.removeFromParent(true);
                     _loc2_ = null;
                  }
               }
            }
            DictionaryUtils.clearDictionary(this.mComicStripsCatalog);
            if(!this.mIsComicViewerReproduction)
            {
               _loc3_ = MapDef(InstanceMng.getMapsDefMng().getDefBySku(this.mMapUnlockedSku));
               if(this.mMapUnlockedFX == null)
               {
                  if(_loc3_)
                  {
                     this.mMapUnlockedFX = InstanceMng.getResourcesMng().createMapUnlockedEffect(_loc3_);
                     this.mMapUnlockedFX.init();
                     InstanceMng.getCurrentScreen().addChild(this.mMapUnlockedFX);
                  }
               }
            }
            else
            {
               if(InstanceMng.getCurrentScreen() is FSMapScreen)
               {
                  FSMapScreen(InstanceMng.getCurrentScreen()).setMapsVisible(true);
                  FSMapScreen(InstanceMng.getCurrentScreen()).setMapComponentsVisible(true);
               }
               _loc4_ = 1;
               TweenMax.delayedCall(_loc4_,this.unload);
               InstanceMng.getPopupMng().resumePopupInBackground();
            }
         }
      }
      
      public function getCurrentComicStripIndexShown() : int
      {
         return this.mCurrentComicStripShowOrderIndex;
      }
      
      public function isComicSkippable() : Boolean
      {
         return this.mComicSkippable;
      }
      
      public function unload() : void
      {
         if(this.mComicStripsDefs != null)
         {
            Utils.destroyArray(this.mComicStripsDefs);
            this.mComicStripsDefs = null;
         }
         this.mComicStripDefsRequested = false;
         this.mResourcesLoaded = false;
         DictionaryUtils.clearDictionary(this.mComicStripsCatalog);
         this.mComicStripsCatalog = null;
         this.mCurrentComicStripShowOrderIndex = 0;
         this.mExitRequested = false;
         this.mComicSkippable = false;
         this.mIsComicViewerReproduction = false;
         this.mComicFinished = false;
         this.mActiveComicStrip = null;
         this.mMapUnlockedSku = "";
         if(this.mMapUnlockedFX)
         {
            this.mMapUnlockedFX.removeFromParent();
            this.mMapUnlockedFX = null;
         }
         if(this.mActiveComicStrip)
         {
            this.mActiveComicStrip.removeFromParent();
            this.mActiveComicStrip = null;
         }
         if(this.mComicContainer)
         {
            this.mComicContainer.removeFromParent();
            this.mComicContainer = null;
         }
      }
      
      public function getComicBGStrip() : ComicStrip
      {
         var _loc2_:ComicStrip = null;
         var _loc1_:ComicStrip = null;
         if(this.mComicStripsCatalog)
         {
            for each(_loc2_ in this.mComicStripsCatalog)
            {
               if(Boolean(_loc2_) && Boolean(_loc2_.getComicStripDef()) && _loc2_.getComicStripDef().getIsBG())
               {
                  return _loc2_;
               }
            }
         }
         return _loc1_;
      }
   }
}

