package com.fs.tcgengine.view.meshes
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.rules.GameModeDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.MapDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.FSSprite3D;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.player.PlayerPortrait;
   import com.fs.tcgengine.view.map.MapPlane;
   import com.fs.tcgengine.view.map.MapPlayerPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quart;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.MeshBatch;
   import starling.display.MovieClip;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class LevelItemContainer extends FSSprite3D
   {
      
      public static const STD_WIDTH:int = 60;
      
      public static const STD_HEIGHT:int = 60;
      
      public static const MAX_PROFILE_PICS_PER_LEVEL:int = 4;
      
      private const LEVEL_ITEM_SIZE:int = 10;
      
      private const LEVEL_ITEMS_PREFIX:String = "level_";
      
      private var mLevelItemImage:FSImage;
      
      private var mArrowMesh:FSSprite3D;
      
      private var mStarSprites:Vector.<MeshBatch>;
      
      private var mStarMeshBatch:MeshBatch;
      
      private var mCollisionBoxInMap:Object;
      
      private var mLevelSku:String;
      
      private var mMapPlaneParent:MapPlane;
      
      private var mLevelDef:LevelDef;
      
      private var mGameModeDef:GameModeDef;
      
      private var mTextfield:FSTextfield;
      
      private var mIsPlayable:Boolean;
      
      private var mIsCurrentLevel:Boolean = false;
      
      private var mRotationVector:Vector3D;
      
      private var mProfilePicsCatalog:Dictionary;
      
      private var mParentMapIndex:int;
      
      private var mHoverHelperPoint:Point;
      
      private var mIsHovered:Boolean;
      
      private var mIsMouseHeldDown:Boolean;
      
      private var mCurrentLevelAnim:MovieClip;
      
      private var mLevelIndexInMap:int;
      
      public function LevelItemContainer(param1:String, param2:MapPlane, param3:Object, param4:int)
      {
         super();
         alignPivot();
         this.mLevelIndexInMap = param4;
         this.initVariables(param1,param2,param3);
         this.addEventListeners();
         this.addTextfieldPlane();
         this.addLevelItem();
         this.addProfilePics();
         this.addArrowMesh();
         this.init();
      }
      
      public function addProfilePics() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc1_:Boolean = false;
         if(_loc1_)
         {
            this.fakeProfilePics();
         }
         else
         {
            _loc2_ = Boolean(InstanceMng.getFacebookPlugin()) && InstanceMng.getFacebookPlugin().isSessionOpen() && InstanceMng.getServerConnection().isUserLoggedIn();
            _loc3_ = InstanceMng.getApplication().isKongregateVersion();
            _loc4_ = _loc2_ || _loc3_ || Utils.isDesktop();
            if(_loc4_)
            {
               this.addFriendsProfilePicByLevel(this.mLevelDef.getLevelIndex());
               if(InstanceMng.getLevelsDefMng().isLastPlayableLevel(this.mLevelDef))
               {
                  this.addFriendsProfilePicByLevel(this.mLevelDef.getLevelIndex() + 1);
               }
            }
         }
      }
      
      public function refreshMesh() : void
      {
         var _loc1_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc2_:Boolean = this.mLevelDef ? this.mLevelDef.getLevelIndex() <= InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc1_) : false;
         var _loc3_:Boolean = Config.getConfig().mapShowsLastMapLevelVisible() && InstanceMng.getMapsDefMng().isLastLevelOfMap(this.mLevelDef.getLevelIndex());
         _loc2_ ||= _loc3_;
         if(this.mLevelItemImage)
         {
            this.mLevelItemImage.visible = _loc2_;
         }
         if(this.mArrowMesh)
         {
            this.mArrowMesh.visible = _loc2_;
         }
      }
      
      public function hasProfilePics() : Boolean
      {
         return DictionaryUtils.getDictionaryLength(this.mProfilePicsCatalog) > 0;
      }
      
      private function addFriendsProfilePicByLevel(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:UserData = null;
         var _loc6_:MapPlayerPortrait = null;
         var _loc7_:String = null;
         var _loc2_:Vector.<UserData> = InstanceMng.getUserDataMng() ? InstanceMng.getUserDataMng().getAllFriendsUserDataByLevel(param1) : null;
         if(_loc2_ != null)
         {
            if(this.mProfilePicsCatalog == null)
            {
               this.mProfilePicsCatalog = new Dictionary(true);
            }
            _loc3_ = int(_loc2_.length);
            _loc7_ = "";
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(_loc4_ < MAX_PROFILE_PICS_PER_LEVEL)
               {
                  _loc5_ = UserData(_loc2_[_loc4_]);
                  if(_loc5_ != null && this.mProfilePicsCatalog[_loc5_.getExtId()] == null)
                  {
                     _loc7_ = _loc5_.getExtId() != "" && _loc5_.getExtId() != null ? _loc5_.getExtId() : "sample";
                     _loc6_ = new MapPlayerPortrait(_loc5_.getPhotoUrl(),_loc7_);
                     this.mProfilePicsCatalog[_loc5_.getExtId()] = _loc6_;
                  }
               }
               _loc4_++;
            }
            this.addProfilePicsToDL();
         }
      }
      
      public function removeOwnerProfilePicture() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:MapPlayerPortrait = null;
         if(this.mProfilePicsCatalog)
         {
            _loc1_ = Utils.getOwnerUserData();
            _loc2_ = this.mProfilePicsCatalog[_loc1_.getExtId()];
            if(_loc2_ != null)
            {
               removeChild(_loc2_);
            }
            this.mProfilePicsCatalog[_loc1_.getExtId()] = null;
            delete this.mProfilePicsCatalog[_loc1_.getExtId()];
         }
      }
      
      private function fakeProfilePics() : void
      {
         var _loc3_:MapPlayerPortrait = null;
         var _loc1_:String = "582075610";
         _loc1_ = "672629550";
         var _loc2_:String = FSFacebookPlugin.FACEBOOK_GRAPH_PREFIX + _loc1_ + PlayerPortrait.FACEBOOK_PIC_SUFFIX;
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < MAX_PROFILE_PICS_PER_LEVEL)
         {
            if(this.mProfilePicsCatalog == null)
            {
               this.mProfilePicsCatalog = new Dictionary(true);
            }
            _loc2_ = _loc4_ % 2 == 0 ? FSFacebookPlugin.FACEBOOK_GRAPH_PREFIX + "672629550" + PlayerPortrait.FACEBOOK_PIC_SUFFIX : FSFacebookPlugin.FACEBOOK_GRAPH_PREFIX + "687434786" + PlayerPortrait.FACEBOOK_PIC_SUFFIX;
            _loc3_ = new MapPlayerPortrait(_loc2_,"672629550" + _loc4_);
            this.mProfilePicsCatalog["672629550" + _loc4_] = _loc3_;
            _loc4_++;
         }
         this.addProfilePicsToDL();
      }
      
      public function removeProfilePics() : void
      {
         var _loc1_:MapPlayerPortrait = null;
         var _loc2_:int = 0;
         if(this.mProfilePicsCatalog)
         {
            for each(_loc1_ in this.mProfilePicsCatalog)
            {
               _loc1_.removeFromParent(true);
            }
            DictionaryUtils.clearDictionary(this.mProfilePicsCatalog);
            this.mProfilePicsCatalog = null;
         }
      }
      
      private function addProfilePicsToDL() : void
      {
         var _loc1_:int = 0;
         var _loc2_:UserData = null;
         var _loc3_:MapPlayerPortrait = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.mProfilePicsCatalog != null)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 1;
            for each(_loc3_ in this.mProfilePicsCatalog)
            {
               _loc7_ = _loc3_.getPicFrameMesh().width;
               if(_loc3_ != null && !contains(_loc3_))
               {
                  if(_loc4_ <= _loc6_)
                  {
                     _loc3_.moveRight(-_loc7_ * 1.5 + _loc4_ * _loc7_ * 1.01);
                  }
                  if(_loc5_ > 0)
                  {
                     _loc3_.moveDown(_loc7_ + _loc5_ * (_loc7_ * 1.01));
                  }
                  else
                  {
                     _loc3_.moveDown(_loc7_);
                  }
                  addChild(_loc3_);
                  _loc5_ = _loc4_ == _loc6_ ? int(_loc5_ + 1) : _loc5_;
                  _loc4_ = _loc4_ == _loc6_ ? 0 : int(_loc4_ + 1);
               }
            }
         }
      }
      
      public function addStarMeshes() : void
      {
         var _loc1_:int = 0;
         if(this.mIsPlayable && this.mStarSprites == null)
         {
            if(InstanceMng.getCurrentScreen() is FSMapScreen)
            {
               if(InstanceMng.getUserDataMng().getOwnerUserData())
               {
                  _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().getScoreByLevelSku(this.mLevelSku);
                  this.onTopScoreInfoACK(_loc1_);
               }
            }
         }
      }
      
      private function addScoreStar(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         if(this.mStarSprites == null)
         {
            this.mStarSprites = new Vector.<MeshBatch>();
         }
         if(this.mStarSprites.length == param1)
         {
            _loc2_ = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : 0;
            _loc3_ = new FSImage(Root.assets.getTexture("level_star_" + _loc2_));
            if(this.mStarMeshBatch == null)
            {
               this.mStarMeshBatch = new MeshBatch();
            }
            switch(param1)
            {
               case 0:
                  _loc3_.x -= _loc3_.width;
                  _loc3_.y -= 5;
                  break;
               case 2:
                  _loc3_.x += _loc3_.width;
                  _loc3_.y -= 5;
            }
            this.mStarMeshBatch.addMesh(_loc3_);
            this.mStarMeshBatch.alignPivot();
            this.mStarMeshBatch.x = this.mLevelItemImage ? this.mLevelItemImage.x : 0;
            this.mStarMeshBatch.y = this.mLevelItemImage ? this.mLevelItemImage.y + this.mLevelItemImage.height / 3 : 0;
            addChild(this.mStarMeshBatch);
            this.mStarSprites.push(this.mStarMeshBatch);
         }
      }
      
      private function addArrowMesh() : void
      {
         var _loc4_:FSImage = null;
         var _loc5_:TweenMax = null;
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = _loc1_ ? _loc1_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 1;
         var _loc3_:Boolean = this.mLevelSku == "level_01" && _loc2_ == 1;
         if(_loc3_)
         {
            if(this.mArrowMesh == null)
            {
               this.mArrowMesh = new FSSprite3D();
               _loc4_ = new FSImage(Root.assets.getTexture("arrow_Diff"));
               this.mArrowMesh.addChild(_loc4_);
               this.mArrowMesh.alignPivot();
               this.mArrowMesh.x = this.mArrowMesh.width / 8;
               this.mArrowMesh.y = this.mLevelItemImage.y - this.mLevelItemImage.height;
               this.mArrowMesh.rotate(new Vector3D(1,0,0),45);
               _loc5_ = new TweenMax(this.mArrowMesh,1,{
                  "x":this.mArrowMesh.x,
                  "y":this.mArrowMesh.y,
                  "z":this.mArrowMesh.z - 90,
                  "yoyo":true,
                  "repeat":-1,
                  "ease":Quart.easeInOut
               });
               addChild(this.mArrowMesh);
            }
         }
      }
      
      public function onTopScoreInfoACK(param1:int) : void
      {
         var _loc2_:int = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
         var _loc3_:int = this.mLevelDef != null ? this.mLevelDef.getMinScoreByDifficulty(_loc2_) : 250;
         var _loc4_:int = this.mLevelDef != null ? this.mLevelDef.getMedScoreByDifficulty(_loc2_) : 1500;
         var _loc5_:int = this.mLevelDef != null ? this.mLevelDef.getMaxScoreByDifficulty(_loc2_) : 2000;
         if(param1 >= _loc3_)
         {
            this.addScoreStar(0);
         }
         if(param1 >= _loc4_)
         {
            this.addScoreStar(1);
         }
         if(param1 >= _loc5_)
         {
            this.addScoreStar(2);
         }
      }
      
      private function addLevelItem() : void
      {
         var _loc1_:String = null;
         if(this.mIsPlayable || this.checkIfLastLevelOfEachMap())
         {
            _loc1_ = "map_button_" + this.mGameModeDef.getSku() + "_up";
            this.mLevelItemImage = new FSImage(Root.assets.getTexture(_loc1_));
            this.mLevelItemImage.alignPivot();
            if(this.mTextfield)
            {
               this.mTextfield.height = this.mLevelItemImage.height / 3;
            }
            this.mLevelItemImage.x = this.mTextfield.x;
            this.mLevelItemImage.y = Utils.isAndroidOrDesktop() || Utils.isBrowser() ? this.mTextfield.y - this.mLevelItemImage.height / 1.5 : this.mTextfield.y - this.mLevelItemImage.height / 2;
            this.mLevelItemImage.touchable = true;
            addChild(this.mLevelItemImage);
         }
      }
      
      public function getLevelIndexInMap() : int
      {
         return this.mLevelIndexInMap;
      }
      
      private function init() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:FSCoordinate = null;
         var _loc4_:int = 0;
         name = this.mLevelSku;
         if(Boolean(this.mCollisionBoxInMap[this.mParentMapIndex]) && this.mCollisionBoxInMap[this.mParentMapIndex][this.mLevelIndexInMap] != null)
         {
            _loc1_ = Number(this.mCollisionBoxInMap[this.mParentMapIndex][this.mLevelIndexInMap].x);
            _loc2_ = Number(this.mCollisionBoxInMap[this.mParentMapIndex][this.mLevelIndexInMap].y);
            _loc3_ = Utils.getSWFCoordinates(_loc1_,_loc2_);
            _loc4_ = this.mMapPlaneParent.getMapPlane() ? int(this.mMapPlaneParent.getMapPlane().width) : 0;
            moveTo(_loc3_.mX - _loc4_ / 2,_loc3_.mY - _loc4_ / 2,-5);
         }
      }
      
      private function initVariables(param1:String, param2:MapPlane, param3:Object) : void
      {
         this.mLevelSku = param1;
         this.mMapPlaneParent = param2;
         this.mParentMapIndex = this.mMapPlaneParent.getMapDef().getIndex();
         this.mCollisionBoxInMap = param3;
         this.mLevelDef = LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(this.mLevelSku));
         if(this.mLevelDef != null)
         {
            this.mGameModeDef = GameModeDef(InstanceMng.getGameModesDefMng().getDefBySku(this.mLevelDef.getGameModeSku()));
         }
         this.checkIfLevelPlayable();
      }
      
      private function checkIfLevelPlayable() : void
      {
         var _loc1_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
         var _loc2_:int = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc1_) : 1;
         this.mIsPlayable = this.mLevelDef.getLevelIndex() <= _loc2_;
      }
      
      private function checkIfLastLevelOfEachMap() : Boolean
      {
         return Config.getConfig().mapShowsLastMapLevelVisible() && InstanceMng.getMapsDefMng().isLastLevelOfMap(this.mLevelDef.getLevelIndex());
      }
      
      private function addTextfieldPlane() : void
      {
         var _loc1_:String = null;
         if(this.mLevelDef != null)
         {
            _loc1_ = this.mLevelDef.getLevelIndex().toString();
            this.mTextfield = new FSTextfield(STD_WIDTH,STD_HEIGHT / 2,_loc1_,16777215,40);
            this.mTextfield.batchable = true;
            this.mTextfield.y += this.mTextfield.height;
            this.mTextfield.alignPivot();
            this.mTextfield.touchable = false;
            this.mTextfield.format.horizontalAlign = Align.CENTER;
            addChild(this.mTextfield);
         }
      }
      
      protected function addEventListeners() : void
      {
         if(this.mIsPlayable)
         {
            addEventListener(TouchEvent.TOUCH,this.onTouch);
         }
      }
      
      private function removeEvListeners() : void
      {
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
      }
      
      public function startHighlight() : void
      {
         var _loc1_:Vector.<Texture> = null;
         this.mIsCurrentLevel = true;
         if(this.mIsCurrentLevel)
         {
            _loc1_ = Root.assets.getTextures("anim_map_icon");
            if(Boolean(_loc1_) && _loc1_.length > 0)
            {
               if(this.mCurrentLevelAnim == null)
               {
                  this.mCurrentLevelAnim = new MovieClip(_loc1_,20);
                  this.mCurrentLevelAnim.touchable = false;
                  this.mCurrentLevelAnim.scale = 2;
                  this.mCurrentLevelAnim.alignPivot();
               }
               this.mCurrentLevelAnim.x = this.mCurrentLevelAnim.x;
               this.mCurrentLevelAnim.y -= this.mCurrentLevelAnim.height / 10;
               Starling.juggler.add(this.mCurrentLevelAnim);
               this.mCurrentLevelAnim.play();
               addChildAt(this.mCurrentLevelAnim,0);
            }
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc2_:Boolean = InstanceMng.getCurrentScreen() is FSMapScreen ? FSMapScreen(InstanceMng.getCurrentScreen()).isPortraitTransitioning() : true;
         if(_loc2_)
         {
            return;
         }
         if(param1)
         {
            if(param1.getTouch(this,TouchPhase.HOVER))
            {
               _loc3_ = "map_button_" + this.mGameModeDef.getSku() + "_over";
            }
            else if(param1.getTouch(this,TouchPhase.BEGAN))
            {
               _loc3_ = "map_button_" + this.mGameModeDef.getSku() + "_down";
               if(this.mMapPlaneParent)
               {
                  this.mMapPlaneParent.setScrollLocked(true);
               }
               this.mIsMouseHeldDown = true;
            }
            else if(param1.getTouch(this,TouchPhase.ENDED))
            {
               this.mHoverHelperPoint = parent ? param1.getTouch(this,TouchPhase.ENDED).getLocation(parent,this.mHoverHelperPoint) : null;
               this.onMouseUp();
               this.mIsMouseHeldDown = false;
               if(this.mMapPlaneParent)
               {
                  this.mMapPlaneParent.setScrollLocked(false);
               }
               _loc3_ = "map_button_" + this.mGameModeDef.getSku() + "_up";
            }
            else
            {
               _loc3_ = "map_button_" + this.mGameModeDef.getSku() + "_up";
               this.mHoverHelperPoint = Boolean(parent) && Boolean(param1.getTouch(this,TouchPhase.MOVED)) ? param1.getTouch(this,TouchPhase.MOVED).getLocation(parent,this.mHoverHelperPoint) : null;
               _loc4_ = this.mHoverHelperPoint ? hitTest(this.mHoverHelperPoint) != null : false;
               if(!_loc4_)
               {
                  this.mIsMouseHeldDown = false;
                  if(this.mMapPlaneParent)
                  {
                     this.mMapPlaneParent.setScrollLocked(false);
                  }
               }
               else
               {
                  if(this.mIsMouseHeldDown)
                  {
                     _loc3_ = "map_button_" + this.mGameModeDef.getSku() + "_down";
                  }
                  if(this.mMapPlaneParent)
                  {
                     this.mMapPlaneParent.setScrollLocked(true);
                  }
               }
            }
            if(this.mLevelItemImage)
            {
               if(Boolean(_loc3_) && _loc3_ != "")
               {
                  this.mLevelItemImage.texture = Root.assets.getTexture(_loc3_);
               }
               this.mLevelItemImage.scale = param1.getTouch(this,TouchPhase.HOVER) ? 1.05 : 1;
            }
         }
      }
      
      private function onMouseUp() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:MapDef = null;
         var _loc10_:Boolean = false;
         if(!Root.assets.isLoading && InstanceMng.getCurrentScreen() is FSMapScreen)
         {
            _loc1_ = hitTest(this.mHoverHelperPoint) != null;
            if(!_loc1_ || !this.mIsMouseHeldDown)
            {
               return;
            }
            _loc2_ = FSMapScreen(InstanceMng.getCurrentScreen()).isSubMenuShown();
            _loc3_ = FSMapScreen(InstanceMng.getCurrentScreen()).isShowingComic();
            _loc4_ = InstanceMng.getCurrentScreen().isUILocked();
            if(!_loc4_ && this.mMapPlaneParent != null && this.mMapPlaneParent.getIsTouchable() && !_loc2_ && !_loc3_ && InstanceMng.getPopupMng().getPopupShown() == null)
            {
               Utils.playSound(Constants.SOUND_CLICK,SoundManager.TYPE_SFX);
               _loc5_ = InstanceMng.getMapsDefMng().isFirstLevelOfMap(this.mLevelDef.getLevelIndex());
               _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getCurrentDifficulty();
               _loc7_ = this.mLevelDef.getLevelIndex() == InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(_loc6_);
               _loc8_ = this.mLevelDef.areDefaultCardsDefined();
               if(_loc5_ && this.mIsCurrentLevel)
               {
                  _loc9_ = this.mMapPlaneParent.getMapDef();
                  _loc10_ = InstanceMng.getUserDataMng().getOwnerUserData().isMapUnlocked(_loc9_.getIndex());
                  if(_loc10_)
                  {
                     Main.smPreviousLevelItem = _loc7_ ? this : null;
                     if(_loc8_)
                     {
                        this.frictionlessPlayLevel();
                     }
                     else
                     {
                        InstanceMng.getPopupMng().openPlayLevelPopup(this.mLevelSku,false,this);
                     }
                  }
                  else if(_loc9_.getUnlockTime() <= 0)
                  {
                     Main.smPreviousLevelItem = _loc7_ ? this : null;
                     InstanceMng.getUserDataMng().onMapUnlockedPerformOperations();
                     if(_loc8_)
                     {
                        this.frictionlessPlayLevel();
                     }
                     else
                     {
                        InstanceMng.getPopupMng().openPlayLevelPopup(this.mLevelSku,false,this);
                     }
                  }
               }
               else
               {
                  Main.smPreviousLevelItem = _loc7_ ? this : null;
                  if(_loc8_)
                  {
                     this.frictionlessPlayLevel();
                  }
                  else
                  {
                     InstanceMng.getPopupMng().openPlayLevelPopup(this.mLevelSku,false,this);
                  }
               }
            }
         }
         else
         {
            FSDebug.debugTrace("Requesting mouse up level item container");
         }
      }
      
      protected function frictionlessPlayLevel() : void
      {
         InstanceMng.getUserDataMng().frictionlessPlayLevel(this.mLevelDef);
      }
      
      public function getLevelSku() : String
      {
         return this.mLevelSku;
      }
      
      public function setLevelSku(param1:String) : void
      {
         this.mLevelSku = param1;
      }
      
      public function getMapPlaneParent() : MapPlane
      {
         return this.mMapPlaneParent;
      }
      
      public function setMapPlaneParent(param1:MapPlane) : void
      {
         this.mMapPlaneParent = param1;
      }
      
      public function getLevelDef() : LevelDef
      {
         return this.mLevelDef;
      }
      
      public function setLevelDef(param1:LevelDef) : void
      {
         this.mLevelDef = param1;
      }
      
      public function getGameModeDef() : GameModeDef
      {
         return this.mGameModeDef;
      }
      
      public function setGameModeDef(param1:GameModeDef) : void
      {
         this.mGameModeDef = param1;
      }
      
      public function getLevelMesh() : FSImage
      {
         return this.mLevelItemImage;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         visible = param1;
      }
      
      public function zoomIn(param1:Number = 0.3) : void
      {
         SpecialFX.zoomInLevelItem(this,param1);
      }
      
      public function zoomOut(param1:Function, param2:Array, param3:Number = 0.3) : void
      {
         SpecialFX.zoomOutLevelItem(this,param1,param2,param3);
      }
      
      override public function dispose() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:int = numChildren;
         if(this.mLevelItemImage)
         {
            this.mLevelItemImage.removeFromParent();
            this.mLevelItemImage.destroy();
            this.mLevelItemImage = null;
         }
         this.mCollisionBoxInMap = null;
         this.mMapPlaneParent = null;
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent();
            this.mTextfield = null;
         }
         if(this.mArrowMesh)
         {
            this.mArrowMesh.removeFromParent();
            this.mArrowMesh = null;
         }
         if(this.mStarSprites)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mStarSprites.length)
            {
               this.mStarSprites[_loc2_].removeFromParent();
               _loc2_++;
            }
            Utils.destroyArray(this.mStarSprites);
            this.mStarSprites = null;
         }
         if(this.mCurrentLevelAnim)
         {
            Starling.juggler.remove(this.mCurrentLevelAnim);
            this.mCurrentLevelAnim.removeFromParent(true);
            this.mCurrentLevelAnim = null;
         }
         this.mRotationVector = null;
         this.mHoverHelperPoint = null;
         this.mLevelDef = null;
         this.mGameModeDef = null;
         this.removeProfilePics();
         this.removeEvListeners();
         super.dispose();
      }
      
      public function getParentMapIndex() : int
      {
         return this.mParentMapIndex;
      }
   }
}

