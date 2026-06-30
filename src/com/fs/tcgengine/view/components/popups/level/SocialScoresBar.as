package com.fs.tcgengine.view.components.popups.level
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.popups.player.PlayerScorePortrait;
   import feathers.controls.ScrollBarDisplayMode;
   import feathers.controls.ScrollContainer;
   import feathers.layout.HorizontalLayout;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class SocialScoresBar extends Component
   {
      
      public static const ARROW_BG_NAME:String = "scroll_side_icon";
      
      public static const SCORE_FIELD_BG_NAME:String = "hs_button";
      
      private var mBGContainer:Component;
      
      private var mBG:Quad;
      
      private var mLeftArrow:FSButton;
      
      private var mRightArrow:FSButton;
      
      private var mConnectToFBButton:FSButton;
      
      private var mGetFriendsButton:FSButton;
      
      private var mPlayerScoresVector:Vector.<PlayerScorePortrait>;
      
      private var mScrollContainer:ScrollContainer;
      
      private var mOwnerPlayerScoreRef:PlayerScorePortrait;
      
      private var mLevelDef:LevelDef;
      
      private var mParentPopupClosed:Boolean = false;
      
      public function SocialScoresBar(param1:LevelDef)
      {
         super();
         this.mLevelDef = param1;
         this.createUI();
      }
      
      public function setParentPopupAsClosed() : void
      {
         this.mParentPopupClosed = true;
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createSocialComponents();
      }
      
      public function createSocialComponents() : void
      {
         var _loc1_:FSFacebookPlugin = InstanceMng.getFacebookPlugin();
         if(Boolean(_loc1_) && Boolean(!_loc1_.isSessionOpen()) || _loc1_ == null)
         {
            this.createConnectToFBButton();
         }
         var _loc2_:UserData = Utils.getOwnerUserData();
         if(Boolean(_loc2_) && !_loc2_.flagsFBFriendsAllowed())
         {
            if(Boolean(_loc1_) && _loc1_.isSessionOpen())
            {
               this.createShowFriendsButton();
            }
         }
      }
      
      private function createShowFriendsButton() : void
      {
         if(this.mGetFriendsButton == null)
         {
            this.mGetFriendsButton = new FSButton(Root.assets.getTexture(Constants.SOCIAL_SHARE_BUTTON),TextManager.getText("TID_PVP_FRIENDS"));
            this.mGetFriendsButton.addEventListener(Event.TRIGGERED,this.onGetFriendsTriggered);
            this.mGetFriendsButton.x = this.mGetFriendsButton.width;
            this.mGetFriendsButton.y = -this.mGetFriendsButton.height / 2;
            this.mBGContainer.addChild(this.mGetFriendsButton);
         }
      }
      
      private function onGetFriendsTriggered(param1:Event) : void
      {
         var fb:FSFacebookPlugin = null;
         var onRequested:Function = null;
         var e:Event = param1;
         onRequested = function(param1:Boolean, param2:Boolean, param3:String = null):void
         {
            var onInvitableFriendsACK:Function;
            var userData:UserData = null;
            var $success:Boolean = param1;
            var $userCancelled:Boolean = param2;
            var $error:String = param3;
            if($success)
            {
               onInvitableFriendsACK = function():void
               {
                  InstanceMng.getServerConnection().loginViaFB();
                  setTimeout(InstanceMng.getServerConnection().getFriendsWhoPlay,1500,requestFriendsScores);
               };
               userData = Utils.getOwnerUserData();
               userData.setFBFriendsAllowed(true);
               InstanceMng.getUserDataMng().updateFlags();
               fb.getInvitableFriendsList(onInvitableFriendsACK);
            }
         };
         fb = InstanceMng.getFacebookPlugin();
         if(fb)
         {
            fb.reRequestDeclinedPermissions(["user_friends"],onRequested,true);
         }
      }
      
      public function requestFriendsScores() : void
      {
         var _loc1_:Vector.<UserData> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:UserData = null;
         if(this.mLevelDef)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(true,false,Align.RIGHT,Align.CENTER,1,null,this);
            _loc2_ = InstanceMng.getLevelsDefMng().getDefsAmount();
            _loc3_ = 0;
            _loc3_ = _loc4_ = this.mLevelDef.getLevelIndex();
            while(_loc3_ <= _loc2_)
            {
               _loc1_ = InstanceMng.getUserDataMng().getAllFriendsUserDataByLevel(_loc3_);
               if(_loc1_ != null)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc1_.length)
                  {
                     _loc7_ = _loc1_[_loc6_];
                     if(_loc7_ != null)
                     {
                        if(_loc5_ == null)
                        {
                           _loc5_ = new Array();
                        }
                        _loc5_.push(_loc7_.getAccountId());
                     }
                     _loc6_++;
                  }
               }
               _loc3_++;
            }
            if(_loc5_ != null && this.mPlayerScoresVector == null)
            {
               InstanceMng.getUserDataMng().getFriendsTopScoreByLevelSku(this.mLevelDef.getSku(),this.onFriendsScoreReceived,_loc5_,true);
            }
            else
            {
               this.addOwnerScore();
            }
         }
      }
      
      private function addOwnerScore() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:Number = _loc1_ ? Number(_loc1_.getScoreByLevelSku(this.mLevelDef.getSku())) : 0;
         if(Boolean(_loc2_ > 0 && !this.mParentPopupClosed) && Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            this.createArrows();
            if(InstanceMng.getServerConnection())
            {
               if(_loc1_)
               {
                  this.mOwnerPlayerScoreRef = new PlayerScorePortrait(_loc1_.getExtId(),1,TextManager.getText("TID_SOCIAL_ME"),_loc2_,true);
                  this.addPlayerScoreObj(this.mOwnerPlayerScoreRef);
                  this.requestPortraitPics();
                  InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
               }
            }
         }
      }
      
      private function onFriendsScoreReceived(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Array = null;
         var _loc5_:Dictionary = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:UserData = null;
         var _loc9_:PlayerScorePortrait = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         if(param1)
         {
            for each(_loc2_ in param1)
            {
               if(_loc2_.score != null && _loc2_.uid != null)
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = new Dictionary(true);
                  }
                  if(_loc3_[_loc2_.uid] != null)
                  {
                     _loc3_[_loc2_.uid] = _loc3_[_loc2_.uid] < _loc2_.score ? _loc2_.score : _loc3_[_loc2_.uid];
                  }
                  else
                  {
                     _loc3_[_loc2_.uid] = _loc2_.score;
                  }
               }
            }
         }
         if(Boolean(!this.mParentPopupClosed) && Boolean(InstanceMng.getCurrentScreen()) && InstanceMng.getCurrentScreen().isFullyLoaded())
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(false,false);
            if(_loc3_ != null)
            {
               _loc4_ = DictionaryUtils.sortDictionaryByValue(_loc3_);
               if(_loc4_ != null)
               {
                  this.createArrows();
                  if(Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getServerConnection()))
                  {
                     _loc5_ = InstanceMng.getUserDataMng().getExtIdsThatReceivedLives();
                     _loc10_ = false;
                     _loc11_ = false;
                     _loc7_ = 0;
                     while(_loc7_ < _loc4_.length)
                     {
                        _loc6_ = _loc4_[_loc7_].key;
                        _loc10_ = _loc6_ == InstanceMng.getServerConnection().getUserId();
                        if(_loc10_)
                        {
                           _loc8_ = Utils.getOwnerUserData();
                           if(_loc8_)
                           {
                              this.mOwnerPlayerScoreRef = new PlayerScorePortrait(_loc8_.getExtId(),_loc7_ + 1,TextManager.getText("TID_SOCIAL_ME"),_loc4_[_loc7_].value,_loc10_);
                              this.addPlayerScoreObj(this.mOwnerPlayerScoreRef);
                           }
                        }
                        else
                        {
                           _loc8_ = InstanceMng.getUserDataMng().getFriendUserDataByAccId(_loc6_);
                           if(_loc8_)
                           {
                              _loc11_ = _loc5_ != null && _loc5_[_loc8_.getExtId()] != null;
                              _loc12_ = _loc8_.getName() ? _loc8_.getName() : "Unknown";
                              _loc9_ = new PlayerScorePortrait(_loc8_.getExtId(),_loc7_ + 1,_loc12_,_loc4_[_loc7_].value,_loc10_,_loc11_);
                              this.addPlayerScoreObj(_loc9_);
                           }
                        }
                        _loc7_++;
                     }
                     if(this.mConnectToFBButton)
                     {
                        this.mConnectToFBButton.removeFromParent();
                     }
                     this.requestPortraitPics();
                  }
               }
            }
            else
            {
               this.addOwnerScore();
            }
         }
      }
      
      private function addPlayerScoreObj(param1:PlayerScorePortrait) : void
      {
         if(this.mPlayerScoresVector == null)
         {
            this.mPlayerScoresVector = new Vector.<PlayerScorePortrait>();
         }
         this.mPlayerScoresVector.push(param1);
         this.addToScrollContainer(param1);
      }
      
      private function addToScrollContainer(param1:PlayerScorePortrait) : void
      {
         var _loc2_:HorizontalLayout = null;
         if(param1)
         {
            if(this.mScrollContainer == null)
            {
               this.mScrollContainer = new ScrollContainer();
               this.mScrollContainer.snapToPages = true;
               this.mScrollContainer.x = this.mLeftArrow ? this.mLeftArrow.x + this.mLeftArrow.width : 0;
               this.mScrollContainer.y = this.mBG.height / 2 - param1.height / 2;
               this.mScrollContainer.height = param1.height;
               this.mScrollContainer.width = this.mLeftArrow ? this.mBG.width - this.mLeftArrow.width * 3 : this.mBG.width * 0.7;
               _loc2_ = new HorizontalLayout();
               _loc2_.gap = 50;
               this.mScrollContainer.layout = _loc2_;
               this.mScrollContainer.scrollBarDisplayMode = ScrollBarDisplayMode.NONE;
               this.mBGContainer.addChild(this.mScrollContainer);
            }
            this.mScrollContainer.addChild(param1);
         }
      }
      
      private function onGoToFirstPosTriggered(param1:Event) : void
      {
         if(this.mScrollContainer)
         {
            this.mScrollContainer.scrollToPageIndex(0,0,0.5);
         }
      }
      
      public function getUsefulHeight() : int
      {
         return this.mBG ? int(this.mBG.height) : int(height);
      }
      
      private function onGoToOwnerPosTriggered(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(Boolean(this.mScrollContainer) && this.mOwnerPlayerScoreRef != null)
         {
            _loc2_ = this.mOwnerPlayerScoreRef.x;
            _loc3_ = this.mScrollContainer.pageWidth;
            _loc4_ = _loc2_ / _loc3_;
            if(_loc4_ != -1)
            {
               if(this.mScrollContainer.horizontalPageCount >= _loc4_)
               {
                  this.mScrollContainer.scrollToPageIndex(_loc4_,0,0.5);
               }
            }
         }
      }
      
      private function createBG() : void
      {
         if(this.mBGContainer == null)
         {
            this.mBGContainer = new Component();
            addChild(this.mBGContainer);
         }
         if(this.mBG == null)
         {
            this.mBG = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight * 0.12,0);
            this.mBG.alpha = 0.85;
            this.mBG.setVertexAlpha(0,0);
            this.mBG.setVertexAlpha(1,0);
            this.mBG.setVertexAlpha(2,0.85);
            this.mBG.setVertexAlpha(3,0.85);
            this.mBGContainer.addChild(this.mBG);
         }
      }
      
      private function createConnectToFBButton() : void
      {
         var _loc1_:Boolean = InstanceMng.getApplication().appleSignInIsSupported() && !InstanceMng.getApplication().hasUserSignedIntoApple() || !InstanceMng.getApplication().appleSignInIsSupported();
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:int = _loc2_ ? _loc2_.getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
         var _loc4_:Boolean = _loc3_ > 5;
         if(this.mConnectToFBButton == null && _loc4_ && InstanceMng.getFacebookPlugin() != null && !InstanceMng.getApplication().isKongregateVersion() && _loc1_)
         {
            if(this.mConnectToFBButton == null)
            {
               this.mConnectToFBButton = new FSButton(Root.assets.getTexture("fb_button_up"),"",Root.assets.getTexture("fb_button_down"));
               this.mConnectToFBButton.fontName = FSResourceMng.getFontByType();
               this.mConnectToFBButton.fontColor = 16777215;
               this.mConnectToFBButton.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
               this.mConnectToFBButton.addEventListener(Event.TRIGGERED,this.onFBTriggered);
               this.mConnectToFBButton.x = this.mBG.width / 2;
               this.mConnectToFBButton.y = this.mBG.height / 2;
            }
            this.mConnectToFBButton.setEnabled(Utils.isMobile() && Utils.smInternetAvailable);
            this.mBGContainer.addChild(this.mConnectToFBButton);
         }
      }
      
      public function setFBButtonVisibility() : void
      {
         if(this.mConnectToFBButton)
         {
            this.mConnectToFBButton.setEnabled(Utils.smInternetAvailable);
         }
      }
      
      private function onFBTriggered() : void
      {
         if(this.mConnectToFBButton)
         {
            this.mConnectToFBButton.removeFromParent();
         }
         Utils.setLogText(TextManager.getText("TID_GEN_WAITING").toUpperCase() + "...");
         if(Boolean(InstanceMng.getPopupMng()) && Boolean(InstanceMng.getPopupMng().getPopupShown()))
         {
            InstanceMng.getPopupMng().getPopupShown().hideTemporarily();
         }
         var _loc1_:FSFacebookPlugin = InstanceMng.getFacebookPlugin();
         if(Boolean(_loc1_) && _loc1_.isSessionOpen())
         {
            this.requestFriendsScores();
         }
         else if(_loc1_)
         {
            _loc1_.login(this.onFBLoginSuccess);
         }
      }
      
      private function onFBLoginSuccess() : void
      {
         Utils.setLogText(TextManager.getText("TID_FACEBOOK_SYNC"));
         if(InstanceMng.getPopupMng().getPopupInBackground())
         {
            InstanceMng.getPopupMng().getPopupInBackground().openPopup();
         }
         var _loc1_:FSFacebookPlugin = InstanceMng.getFacebookPlugin();
         if(Boolean(_loc1_) && _loc1_.isSessionOpen())
         {
            this.requestFriendsScores();
         }
      }
      
      private function createArrows() : void
      {
         if(Root.assets.getTexture(ARROW_BG_NAME))
         {
            if(this.mLeftArrow == null)
            {
               this.mLeftArrow = new FSButton(Root.assets.getTexture(ARROW_BG_NAME));
               this.mLeftArrow.x = this.mLeftArrow.width / 2;
               this.mLeftArrow.y = this.mBG.height / 2;
               this.mLeftArrow.addEventListener(Event.TRIGGERED,this.onLeftArrowTriggered);
               this.mLeftArrow.scaleX = -1;
               this.mLeftArrow.enableScaleOnMouseOver(false);
               this.mBGContainer.addChild(this.mLeftArrow);
            }
            if(this.mRightArrow == null)
            {
               this.mRightArrow = new FSButton(Root.assets.getTexture(ARROW_BG_NAME));
               this.mRightArrow.addEventListener(Event.TRIGGERED,this.onRightArrowTriggered);
               this.mRightArrow.x = this.mBG.width - this.mRightArrow.width / 2;
               this.mRightArrow.y = this.mBG.height / 2;
               this.mRightArrow.enableScaleOnMouseOver(false);
               this.mBGContainer.addChild(this.mRightArrow);
            }
         }
      }
      
      private function onLeftArrowTriggered(param1:Event) : void
      {
         if(this.mScrollContainer)
         {
            if(this.mScrollContainer.horizontalPageIndex > 0)
            {
               this.mScrollContainer.validate();
               this.mScrollContainer.scrollToPageIndex(this.mScrollContainer.horizontalPageIndex - 1,NaN,0.2);
            }
         }
      }
      
      private function onRightArrowTriggered(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.mScrollContainer)
         {
            _loc2_ = this.mScrollContainer.horizontalPageCount;
            if(this.mScrollContainer.horizontalPageIndex < _loc2_)
            {
               this.mScrollContainer.validate();
               this.mScrollContainer.scrollToPageIndex(this.mScrollContainer.horizontalPageIndex + 1,0,0.2);
            }
         }
      }
      
      public function requestPortraitPics() : void
      {
         var _loc1_:PlayerScorePortrait = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mPlayerScoresVector != null)
         {
            _loc3_ = int(this.mPlayerScoresVector.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this.mPlayerScoresVector[_loc2_];
               _loc1_.loadProfilePicture();
               _loc2_++;
            }
         }
      }
      
      public function cancelPortraitPicsRequest() : void
      {
         var _loc1_:PlayerScorePortrait = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mPlayerScoresVector != null)
         {
            _loc3_ = int(this.mPlayerScoresVector.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this.mPlayerScoresVector[_loc2_];
               _loc2_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this.mBG != null)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGContainer)
         {
            this.mBGContainer.removeFromParent(true);
            this.mBGContainer = null;
         }
         if(this.mLeftArrow)
         {
            this.mLeftArrow.removeFromParent(true);
            this.mLeftArrow = null;
         }
         if(this.mRightArrow)
         {
            this.mRightArrow.removeFromParent(true);
            this.mRightArrow = null;
         }
         if(this.mConnectToFBButton)
         {
            this.mConnectToFBButton.removeFromParent();
            this.mConnectToFBButton = null;
         }
         if(this.mScrollContainer)
         {
            this.mScrollContainer.removeChildren(0,-1,true);
            this.mScrollContainer.removeFromParent(true);
            this.mScrollContainer = null;
         }
         if(this.mPlayerScoresVector)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.mPlayerScoresVector.length)
            {
               this.mPlayerScoresVector[_loc1_].removeFromParent(true);
               _loc1_++;
            }
            Utils.destroyArray(this.mPlayerScoresVector);
            this.mPlayerScoresVector = null;
         }
         this.mLevelDef = null;
         this.mOwnerPlayerScoreRef = null;
         super.dispose();
      }
   }
}

