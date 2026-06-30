package com.fs.tcgengine.view.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.FSSprite3D;
   import com.fs.tcgengine.view.meshes.LevelItemContainer;
   import com.fs.tcgengine.view.meshes.MapText;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.BlendMode;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   
   public class MapPlane extends FSSprite3D
   {
      
      public static const MAP_EPISODES_PREFIX:String = "map_";
      
      public static const MAP_ROTATION:int = 35;
      
      public static const SCROLL_NONE:String = "none";
      
      public static const SCROLL_UP:String = "up";
      
      public static const SCROLL_DOWN:String = "down";
      
      private const LEVEL_ITEMS_PREFIX:String = "level_";
      
      private const MAP_TITLE_PREFIX:String = "title_";
      
      private const PATH_ITEM_PREFIX:String = "path_";
      
      public var mDistanceMovedFromOrigPos:Number = 0;
      
      public var mDistanceToMoveRequested:Number = 0;
      
      private var mMapSufix:String;
      
      private var mLevelItemsCatalog:Dictionary;
      
      private var mMapDef:MapDef;
      
      private var mOwnerCurrentLevelSku:String;
      
      private var mMapNameTitle:MapText;
      
      private var mMouseHeldDown:Boolean = false;
      
      private var mPlane:FSImage;
      
      private var mIsTouchable:Boolean = true;
      
      private var mMapComponentsCreated:Boolean = false;
      
      private var mHovered:Boolean = false;
      
      private var mScrollInfo:String;
      
      private var mScrollSpeed:Number = 0;
      
      private var mScrollLocked:Boolean;
      
      private var mHoverHelperPoint:Point;
      
      public function MapPlane(param1:String)
      {
         super();
         alignPivot();
         this.mMapSufix = param1;
         this.mMapDef = MapDef(InstanceMng.getMapsDefMng().getDefBySku(MAP_EPISODES_PREFIX + this.mMapSufix));
         this.init();
         this.loadComponents();
      }
      
      public function getMapSuffix() : int
      {
         return int(this.mMapSufix);
      }
      
      private function init() : void
      {
         this.addEventListeners();
         name = "map";
         var _loc1_:Number = 0;
         if(Utils.isIOS())
         {
            _loc1_ = Utils.isIphone() ? 230 : 210;
         }
         else
         {
            _loc1_ = Utils.isTablet() ? 40 : 115;
         }
         moveBackward(_loc1_);
         rotate(new Vector3D(1,0,0),-MAP_ROTATION);
         this.translateMap(-100,false);
      }
      
      private function loadComponents() : void
      {
         this.updateOwnerCurrentLevelSku();
         this.loadBGImage();
      }
      
      public function notifyAssetsLoaded() : void
      {
         if(this.mMapDef)
         {
            this.createMapTextureMaterial(Root.assets.getTexture(this.mMapDef.calculateBGName()));
         }
      }
      
      public function loadBGImage() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mMapSufix) && Boolean(this.mMapDef))
         {
            _loc1_ = this.mMapDef.calculateBGName();
            if(Root.assets.getTexture(_loc1_) == null)
            {
               if(!Root.assets.isLoading && Boolean(InstanceMng.getCurrentScreen()))
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("maps/" + _loc1_,FSResourceMng.TYPE_TEXTURE_JPG);
                  InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
               }
               else
               {
                  TweenMax.delayedCall(0.0001,this.loadBGImage);
               }
            }
            else
            {
               this.notifyAssetsLoaded();
            }
         }
      }
      
      private function createMapTextureMaterial(param1:Texture) : void
      {
         if(this.mPlane == null)
         {
            this.mPlane = new FSImage(param1);
         }
         else
         {
            this.mPlane.texture = param1;
         }
         this.mPlane.blendMode = BlendMode.NONE;
         this.mPlane.alignPivot();
         this.mPlane.scale = Utils.getMapScaleFactor();
         addChild(this.mPlane);
         if(InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            this.createMapComponents();
            InstanceMng.getCurrentScreen().notifyAssetsLoaded({"mapMaterialLoaded":true});
         }
         visible = InstanceMng.getCurrentScreen() is FSMapScreen ? !FSMapScreen(InstanceMng.getCurrentScreen()).isShowingComic() : false;
      }
      
      public function createMapComponents() : void
      {
         if(!this.mMapComponentsCreated)
         {
            this.mMapComponentsCreated = true;
            this.createMapTitle();
            if(InstanceMng.getCurrentScreen() is FSMapScreen && !InstanceMng.getCurrentScreen().contains(this))
            {
               FSMapScreen(InstanceMng.getCurrentScreen()).addMapPlaneToStage(this);
               this.createLevelItems();
            }
         }
      }
      
      private function createMapTitle() : void
      {
         var _loc1_:Object = Root.assets.getObject("mapLevelsPositions");
         var _loc2_:Boolean = !this.mMapDef.isWorldMap() || this.mMapDef.isWorldMap() && InstanceMng.getUserDataMng().getOwnerUserData().hasAlreadyChoosenWorld(this.mMapDef.getWorldParentIndex());
         if(Boolean(_loc1_) && _loc2_)
         {
            if(this.mMapNameTitle == null)
            {
               this.mMapNameTitle = new MapText(this,_loc1_);
            }
            if(this.mMapNameTitle)
            {
               addChild(this.mMapNameTitle);
            }
         }
      }
      
      public function createLevelItems() : void
      {
         var _loc1_:String = null;
         var _loc2_:LevelItemContainer = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:LevelDef = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:UserData = null;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc20_:Boolean = false;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:String = null;
         var _loc24_:Boolean = false;
         if(this.mOwnerCurrentLevelSku)
         {
            if(this.mLevelItemsCatalog == null)
            {
               this.mLevelItemsCatalog = new Dictionary(true);
            }
            _loc3_ = this.calculateStartingIndex();
            _loc4_ = _loc3_;
            _loc8_ = int(this.mOwnerCurrentLevelSku.split("_")[1]);
            _loc11_ = Utils.getOwnerUserData();
            _loc12_ = Root.assets.getObject("mapLevelsPositions");
            _loc14_ = this.mMapDef.getLevelsAmount();
            _loc13_ = 1;
            while(_loc13_ <= _loc14_)
            {
               _loc4_++;
               _loc1_ = Utils.transformValueToString(_loc13_.toString(),2);
               if(_loc12_)
               {
                  _loc15_ = _loc4_ > 99 ? 3 : 2;
                  _loc7_ = this.LEVEL_ITEMS_PREFIX + Utils.transformValueToString(_loc4_.toString(),_loc15_);
                  _loc5_ = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(_loc7_));
                  _loc6_ = _loc5_ ? _loc5_.getLevelIndex() <= _loc8_ && _loc5_ != null : false;
                  if(this.mLevelItemsCatalog != null && this.mLevelItemsCatalog[_loc1_] == null)
                  {
                     if(_loc5_ != null)
                     {
                        _loc2_ = this.createLevelItem(_loc12_,_loc7_,_loc13_);
                        this.mLevelItemsCatalog[_loc1_] = _loc2_;
                        _loc9_ = Config.getConfig().mapShowsLastMapLevelVisible() && InstanceMng.getMapsDefMng().isLastLevelOfMap(_loc5_.getLevelIndex());
                        _loc9_ = (_loc9_) && (!Config.getConfig().gameHasWorlds() || Config.getConfig().gameHasWorlds() && _loc11_ && _loc11_.hasAlreadyChoosenWorld(this.mMapDef.getWorldParentIndex()));
                        _loc10_ = _loc2_.hasProfilePics();
                        if(_loc6_ || _loc9_ || _loc10_)
                        {
                           if(_loc10_ && !_loc6_)
                           {
                              _loc2_.refreshMesh();
                           }
                           _loc21_ = !this.mMapDef.isWorldMap() || this.mMapDef.isWorldMap() && _loc11_ && _loc11_.hasAlreadyChoosenWorld(this.mMapDef.getWorldParentIndex());
                           if(_loc21_)
                           {
                              addChild(_loc2_);
                           }
                        }
                     }
                  }
                  else
                  {
                     FSDebug.debugTrace("Level item already created, skipping");
                  }
                  _loc16_ = _loc7_ == this.mOwnerCurrentLevelSku && _loc5_ == null;
                  _loc17_ = _loc6_ && InstanceMng.getLevelsDefMng().isLastPlayableLevel(_loc2_.getLevelDef());
                  _loc18_ = _loc11_ ? _loc11_.getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
                  _loc19_ = _loc11_ ? _loc11_.getCurrentLevelSkuByDifficulty(_loc18_) : "level_01";
                  _loc20_ = _loc2_ ? _loc2_.getLevelSku() == _loc19_ : false;
                  if(InstanceMng.getCurrentScreen() is FSMapScreen)
                  {
                     _loc22_ = _loc6_ && (_loc20_ || _loc17_);
                     if((_loc16_ || _loc22_) && _loc2_ != null)
                     {
                        FSMapScreen(InstanceMng.getCurrentScreen()).highlightCurrentLevelItem(_loc2_);
                     }
                     _loc23_ = _loc11_ ? _loc11_.getLastLevelPlayedSkuByDifficulty() : "level_01";
                     _loc24_ = _loc2_ ? _loc2_.getLevelSku() == _loc23_ : false;
                     if((_loc24_) && _loc2_ != null)
                     {
                        FSMapScreen(InstanceMng.getCurrentScreen()).updateLastLevelPlayedLevelItem(_loc2_);
                     }
                  }
               }
               _loc13_++;
            }
         }
      }
      
      public function checkLevelItemsMeshVisibility() : void
      {
         var _loc1_:LevelItemContainer = null;
         var _loc2_:int = 0;
         var _loc3_:LevelDef = null;
         var _loc4_:FSImage = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(this.mLevelItemsCatalog)
         {
            if(this.mOwnerCurrentLevelSku)
            {
               _loc2_ = int(this.mOwnerCurrentLevelSku.split("_")[1]);
               for each(_loc1_ in this.mLevelItemsCatalog)
               {
                  if(_loc1_)
                  {
                     _loc3_ = _loc1_.getLevelDef();
                     if(_loc3_)
                     {
                        _loc5_ = Config.getConfig().mapShowsLastMapLevelVisible() && InstanceMng.getMapsDefMng().isLastLevelOfMap(_loc3_.getLevelIndex());
                        _loc6_ = _loc3_ != null && (_loc3_.getLevelIndex() <= _loc2_ || _loc5_);
                        if(_loc1_)
                        {
                           _loc4_ = _loc1_.getLevelMesh();
                           if(_loc4_)
                           {
                              _loc4_.visible = _loc6_;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function calculateStartingIndex() : int
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         if(this.mMapDef != null)
         {
            _loc2_ = this.mMapDef.getIndex();
            _loc1_ = InstanceMng.getMapsDefMng().getPreviousLevelsAmountByIndex(_loc2_);
         }
         return _loc1_;
      }
      
      private function createLevelItem(param1:Object, param2:String, param3:int) : LevelItemContainer
      {
         return new LevelItemContainer(param2,this,param1,param3);
      }
      
      public function translateMap(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:Number = NaN;
         if(!this.mScrollLocked)
         {
            _loc3_ = Utils.calculateZMovement(param1,this);
            moveUp(-param1);
            moveBackward(_loc3_);
            if(param2)
            {
               if(Boolean(InstanceMng.getCurrentScreen() is FSMapScreen) && Boolean(this.mMapDef) && FSMapScreen(InstanceMng.getCurrentScreen()).getCurrentMapIndex() == this.mMapDef.getIndex())
               {
               }
               dispatchEventWith(FSMapScreen.MAP_DRAGGED,true,{"d":param1});
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:LevelItemContainer = null;
         if(this.mLevelItemsCatalog)
         {
            for each(_loc1_ in this.mLevelItemsCatalog)
            {
               _loc1_.removeFromParent(true);
            }
         }
         DictionaryUtils.clearDictionary(this.mLevelItemsCatalog);
         this.mLevelItemsCatalog = null;
         if(this.mMapNameTitle)
         {
            this.mMapNameTitle.removeFromParent(true);
            this.mMapNameTitle = null;
         }
         this.mMouseHeldDown = false;
         if(this.mPlane)
         {
            this.mPlane.removeFromParent();
            this.mPlane.destroy();
            this.mPlane = null;
         }
         this.removeEvListeners();
         this.mDistanceMovedFromOrigPos = 0;
         this.mDistanceToMoveRequested = 0;
         this.mHoverHelperPoint = null;
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         super.dispose();
      }
      
      private function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(param1)
         {
            if(param1.getTouch(this,TouchPhase.BEGAN))
            {
               this.onMouseDown();
            }
            else if(param1.getTouch(this,TouchPhase.ENDED))
            {
               this.onMouseOut();
               this.onMouseUp(param1);
            }
            else if(param1.getTouch(this,TouchPhase.HOVER))
            {
               this.onMouseOver();
            }
            else if(param1.getTouch(this,TouchPhase.MOVED))
            {
               this.onMouseMoved(param1);
            }
         }
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:Screen = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(Boolean(this.mHovered) && Boolean(param1) && !this.mMouseHeldDown)
         {
            _loc2_ = InstanceMng.getCurrentScreen();
            _loc3_ = Boolean(_loc2_) && _loc2_.isFullyLoaded() && !_loc2_.isTransparentBGShown();
            _loc4_ = InstanceMng.getPopupMng() ? InstanceMng.getPopupMng().getPopupShown() == null && !InstanceMng.getPopupMng().isPopupLoading() : false;
            _loc5_ = !FSMapScreen(_loc2_).isShowingComic();
            _loc6_ = !this.mMouseHeldDown && Boolean(this.mMapDef);
            if(_loc3_ && _loc4_ && _loc5_ && _loc6_)
            {
               _loc7_ = FSMapScreen(_loc2_).getCurrentMapIndex();
               if(_loc7_ != this.mMapDef.getIndex())
               {
                  FSMapScreen(_loc2_).getMapPlaneByMapIndex(_loc7_).setHovered(false);
               }
               FSMapScreen(_loc2_).setMapPlaneAsActive(this.mMapDef.getIndex());
               _loc8_ = param1.delta > 0 ? 1 : -1;
               _loc9_ = Utils.isBrowser() ? 15 : 45;
               FSMapScreen(_loc2_).dragMaps(_loc9_ * _loc8_,null,false,true);
               if(FSMapScreen(_loc2_).isSubMenuShown())
               {
                  FSMapScreen(_loc2_).closeSubMenu();
               }
            }
         }
      }
      
      public function setHovered(param1:Boolean) : void
      {
         this.mHovered = param1;
      }
      
      private function onMouseMoved(param1:TouchEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         if(this.mMouseHeldDown && !this.mScrollLocked && Boolean(param1))
         {
            if(Boolean(param1.getTouches(this,TouchPhase.MOVED)) && param1.getTouches(this,TouchPhase.MOVED).length > 0)
            {
               _loc2_ = param1.getTouches(this,TouchPhase.MOVED)[0] ? param1.getTouches(this,TouchPhase.MOVED)[0].getMovement(parent).y : 0;
               if(_loc2_ != 0)
               {
                  this.mScrollInfo = _loc2_ < 0 ? SCROLL_UP : SCROLL_DOWN;
                  _loc3_ = this.isMovable(_loc2_);
                  if(_loc2_ < 0)
                  {
                     _loc2_ = _loc2_ > -30 ? _loc2_ : -30;
                  }
                  else
                  {
                     _loc2_ = _loc2_ < 30 ? _loc2_ : 30;
                  }
                  this.mScrollSpeed = _loc2_;
                  if(_loc3_)
                  {
                     this.translateMap(_loc2_);
                  }
                  if(Boolean(InstanceMng.getCurrentScreen()) && Boolean(InstanceMng.getCurrentScreen() is FSMapScreen) && FSMapScreen(InstanceMng.getCurrentScreen()).isSubMenuShown())
                  {
                     FSMapScreen(InstanceMng.getCurrentScreen()).closeSubMenu();
                  }
               }
            }
         }
      }
      
      public function isMovable(param1:Number) : Boolean
      {
         var _loc2_:Boolean = true;
         var _loc3_:int = this.getMaxBoundary();
         if(this.isLastMap())
         {
            _loc2_ = param1 < 0 || y + param1 < _loc3_;
         }
         else if(this.isFirstMap())
         {
            _loc2_ = param1 > 0 || y + param1 > _loc3_;
         }
         return _loc2_;
      }
      
      public function getMaxBoundary() : int
      {
         var _loc1_:int = 0;
         if(this.isLastMap())
         {
            if(Utils.isIOS())
            {
               _loc1_ = Utils.isIphone() ? 0 : -50;
               _loc1_ += Config.getConfig().getMap3DTopOffsetPos();
            }
            else
            {
               _loc1_ = 0;
               _loc1_ += Config.getConfig().getMap3DTopOffsetAndroid();
            }
         }
         else if(Boolean(this.mMapDef) && this.mMapDef.getIndex() == 1)
         {
            if(Utils.isIOS())
            {
               _loc1_ = Utils.isIphone() ? -90 : -50;
            }
            else
            {
               _loc1_ = -20;
            }
         }
         return _loc1_;
      }
      
      protected function onMouseOver() : void
      {
         this.mHovered = true;
      }
      
      private function removeEvListeners() : void
      {
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      private function onMouseUp(param1:TouchEvent) : void
      {
         var _loc2_:Boolean = false;
         if(!this.mScrollLocked && InstanceMng.getCurrentScreen().isFullyLoaded() && InstanceMng.getCurrentScreen() is FSMapScreen && !FSMapScreen(InstanceMng.getCurrentScreen()).isWaitingToCenterCamOnCurrentLevel())
         {
            this.mMouseHeldDown = false;
            this.mScrollSpeed = Utils.isDesktop() || Utils.isBrowser() ? 0 : this.mScrollSpeed;
            if(this.mScrollSpeed != 0)
            {
               _loc2_ = this.isMovable(this.mScrollSpeed);
               if(_loc2_)
               {
                  SpecialFX.create3DTransition(this,x,this.mScrollSpeed,0.25,this.onMapScrollOver);
               }
            }
            this.mScrollInfo = SCROLL_NONE;
         }
      }
      
      public function onMapScrollOver() : void
      {
         this.mScrollSpeed = 0;
      }
      
      private function onMouseOut() : void
      {
         this.mHovered = false;
         if(InstanceMng.getCurrentScreen().isFullyLoaded() && InstanceMng.getCurrentScreen() is FSMapScreen && !FSMapScreen(InstanceMng.getCurrentScreen()).isWaitingToCenterCamOnCurrentLevel())
         {
            this.mMouseHeldDown = false;
         }
      }
      
      private function onMouseDown() : void
      {
         var _loc2_:Boolean = false;
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         if(_loc1_ is FSMapScreen && _loc1_.isFullyLoaded())
         {
            _loc2_ = FSMapScreen(_loc1_).isShowingComic();
            if(!_loc2_ && !this.mMouseHeldDown)
            {
               this.mScrollSpeed = 0;
               this.mScrollInfo = SCROLL_NONE;
               FSMapScreen(_loc1_).setMapPlaneAsActive(this.mMapDef.getIndex());
               this.mMouseHeldDown = true;
               if(FSMapScreen(_loc1_).isSubMenuShown())
               {
                  FSMapScreen(_loc1_).closeSubMenu();
               }
            }
         }
      }
      
      public function setTouchable(param1:Boolean) : void
      {
         if(param1)
         {
            this.addEventListeners();
         }
         else
         {
            this.removeEvListeners();
         }
         this.mIsTouchable = param1;
      }
      
      public function tweenLevelVisibility(param1:Boolean, param2:Number = 0.3) : void
      {
         var _loc3_:LevelItemContainer = null;
         var _loc4_:LevelItemContainer = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(Boolean(this.mLevelItemsCatalog) && InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            _loc4_ = FSMapScreen(InstanceMng.getCurrentScreen()).getCurrentLevelItem();
            _loc5_ = FSMapScreen(InstanceMng.getCurrentScreen()).isWaitingToTransitionPortraitToNextLevel();
            _loc6_ = Main.smPreviousLevelItem != null;
            for each(_loc3_ in this.mLevelItemsCatalog)
            {
               if(contains(_loc3_))
               {
                  if(param1)
                  {
                     _loc3_.visible = true;
                     if(_loc3_ != _loc4_ || !_loc6_ || _loc3_ == _loc4_ && !_loc5_)
                     {
                        _loc3_.zoomIn(param2);
                     }
                  }
                  else
                  {
                     _loc3_.zoomOut(this.setItemVisibility,[_loc3_,false],param2);
                  }
               }
            }
         }
      }
      
      private function setItemVisibility(param1:LevelItemContainer, param2:Boolean) : void
      {
         if(param1)
         {
            param1.setVisible(param2);
         }
      }
      
      public function setLevelItemsVisible(param1:Boolean) : void
      {
         var _loc2_:LevelItemContainer = null;
         if(this.mLevelItemsCatalog)
         {
            for each(_loc2_ in this.mLevelItemsCatalog)
            {
               if(contains(_loc2_))
               {
                  _loc2_.visible = param1;
               }
            }
         }
      }
      
      public function removePlayerPortraitPics() : void
      {
         var _loc1_:LevelItemContainer = null;
         if(this.mLevelItemsCatalog)
         {
            for each(_loc1_ in this.mLevelItemsCatalog)
            {
               _loc1_.removeProfilePics();
            }
         }
      }
      
      public function requestPlayerPortraitPics() : void
      {
         var _loc1_:LevelItemContainer = null;
         if(this.mLevelItemsCatalog)
         {
            for each(_loc1_ in this.mLevelItemsCatalog)
            {
               _loc1_.addProfilePics();
            }
         }
      }
      
      public function getMapDef() : MapDef
      {
         return this.mMapDef;
      }
      
      public function updateOwnerCurrentLevelSku() : void
      {
         var _loc1_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
         this.mOwnerCurrentLevelSku = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelSkuByDifficulty(_loc1_) : "level_01";
      }
      
      public function getIsTouchable() : Boolean
      {
         return this.mIsTouchable;
      }
      
      public function setIsTouchable(param1:Boolean) : void
      {
         this.mIsTouchable = param1;
      }
      
      public function areComponentsCreated() : Boolean
      {
         return this.mMapComponentsCreated;
      }
      
      public function isLastMap() : Boolean
      {
         return Boolean(this.mMapDef) && this.mMapDef.getIndex() == InstanceMng.getMapsDefMng().getLastMapIndex();
      }
      
      public function isFirstMap() : Boolean
      {
         return Boolean(this.mMapDef) && this.mMapDef.getIndex() == 1;
      }
      
      public function getMapPlane() : FSImage
      {
         return this.mPlane;
      }
      
      public function isOwnerCurrentMap() : Boolean
      {
         var _loc1_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : 0;
         var _loc2_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentMapIndex(_loc1_) : 1;
         return this.mMapDef.getIndex() == _loc2_;
      }
      
      public function hasToDrawFullPathImageOnMap() : Boolean
      {
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc2_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentMapIndex(_loc1_) : 1;
         return this.mMapDef.getIndex() < _loc2_;
      }
      
      public function createLevelItemStars() : void
      {
         var _loc1_:LevelItemContainer = null;
         if(this.mLevelItemsCatalog)
         {
            for each(_loc1_ in this.mLevelItemsCatalog)
            {
               _loc1_.addStarMeshes();
            }
         }
      }
      
      public function isScrolling() : Boolean
      {
         return this.mScrollSpeed != 0;
      }
      
      public function setScrollLocked(param1:Boolean) : void
      {
         this.mScrollLocked = param1;
      }
   }
}

