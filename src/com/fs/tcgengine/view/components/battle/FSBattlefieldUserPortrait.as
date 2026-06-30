package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.guilds.Guild;
   import com.fs.tcgengine.model.rules.DungeonLevelDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.RaidLevelDef;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.particles.TextParticleWithBG;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.cards.BulletsAnim;
   import com.fs.tcgengine.view.anims.cards.CardAnimation;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSItemTargetedAnim;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.fs.tcgengine.view.components.misc.ChatButton;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.guilds.GuildEmblem;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import starling.events.EnterFrameEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.extensions.ColorArgb;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSBattlefieldUserPortrait extends Component
   {
      
      public static const FRAME_BG_NAME:String = "player_portrait_panel";
      
      public static const ENEMY_FRAME_BG_NAME:String = "enemy_portrait_panel";
      
      public static const NAME_FRAME_BG_NAME:String = "name_panel";
      
      private const FRICTION_CONSTANT:Number = 0.5;
      
      private var mUserData:UserData;
      
      private var mIsOpponent:Boolean;
      
      private var mIsIAOpponent:Boolean;
      
      protected var mFrameContainer:Component;
      
      protected var mFrameBGImg:FSImage;
      
      protected var mNameFrame:Component;
      
      protected var mNameFrameImage:FSImage;
      
      private var mUserImage:FSImage;
      
      protected var mNameTextfield:FSTextfield;
      
      private var mLevelDef:LevelDef;
      
      private var mHeroDef:HeroCharacterDef;
      
      private var mUserBattleInfo:UserBattleInfo;
      
      protected var mPlayerHPViewer:PlayerHPViewer;
      
      protected var mPlayerHPViewerCover:FSImage;
      
      private var mRankInsigniaImage:FSImage;
      
      private var mInvulnerableImage:FSImage;
      
      private var mInvulnerableTextfield:FSTextfield;
      
      private var mInvulnerableSprite:Component;
      
      private var mCardAnimsAttached:Vector.<CardAnimation>;
      
      private var mPortraitImg:FSImage;
      
      private var mRotationAllowed:Boolean = false;
      
      private var mFrictionValue:Number = 0;
      
      protected var mIsInfoPortrait:Boolean = false;
      
      private var mPlayerMessageTextfield:FSTextfield;
      
      private var mPlayerMessageBubble:FSButton;
      
      private var mPortraitBubbleMessage:TextParticleWithBG;
      
      private var mItemTargetedAnim:FSItemTargetedAnim;
      
      protected var mGuildEmblem:GuildEmblem;
      
      protected var mCharacterImage:FSImage;
      
      private var mOriginalCharacterImageCoord:FSCoordinate;
      
      private var mHasSimpleUI:Boolean;
      
      private var mRankBG:FSImage;
      
      public function FSBattlefieldUserPortrait(param1:Boolean, param2:String = "", param3:String = "", param4:Boolean = false)
      {
         super();
         this.mIsInfoPortrait = param4;
         this.mHasSimpleUI = Config.getConfig().battleHasSimpleUI();
         this.init(param1,param2,param3);
         touchable = false;
         this.addEventListeners();
      }
      
      protected function init(param1:Boolean, param2:String = "", param3:String = "") : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc4_:Boolean = Boolean(Root.smBattleData.isDungeon);
         var _loc5_:Boolean = Boolean(Root.smBattleData.isRaid);
         if(_loc4_)
         {
            this.mLevelDef = param2 != "" && param2 != null ? DungeonLevelDef(InstanceMng.getDungeonLevelsDefMng().getDefBySku(param2)) : null;
         }
         else if(_loc5_)
         {
            this.mLevelDef = param2 != "" && param2 != null ? RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getDefBySku(param2)) : null;
         }
         else
         {
            this.mLevelDef = param2 != "" && param2 != null ? LevelDef(InstanceMng.getLevelsDefMng().getDefBySku(param2)) : null;
         }
         this.mHeroDef = param3 != "" && param3 != null ? HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(param3)) : null;
         if(param1)
         {
            this.mUserData = Utils.getOwnerUserData();
         }
         else
         {
            this.setIsOpponent(true);
            this.setIsIAOpponent(!InstanceMng.getBattleEngine().isOnlineMatch() || PvPConnectionMng.smPlayingAgainstBOT);
            _loc6_ = InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isOnlineMatch();
            if(PvPConnectionMng.smPlayingAgainstBOT)
            {
               this.mUserData = InstanceMng.getUserDataMng().getOpponentUserData(false);
            }
            else
            {
               this.mUserData = InstanceMng.getUserDataMng().getOpponentUserData(_loc6_);
            }
            _loc7_ = "";
            if(InstanceMng.getBattleEngine().isPvPMatch())
            {
               if(_loc6_)
               {
                  _loc7_ = InstanceMng.getBattleEngine().isOnlineMatch() ? PvPConnectionMng.smOpponentName : TextManager.getText("TID_PVP_PLAYER_2");
               }
            }
            else
            {
               _loc7_ = "AI";
            }
            if(this.mUserData)
            {
               this.mUserData.setName(_loc7_);
            }
         }
         this.createFrameBase();
         this.createUserPortrait();
         this.createNameFrame();
         this.setPlayerName();
         this.createPlayerHPCover();
         this.createPlayerHPViewer();
         this.addRankInsignia();
         this.createPortrait();
         this.refreshUIPositions();
      }
      
      private function refreshUIPositions() : void
      {
         var _loc1_:int = 0;
         if(this.mHasSimpleUI)
         {
            this.refreshGuildEmblemPos();
            if(this.mPlayerHPViewer)
            {
               this.mPlayerHPViewer.x = 0;
               this.mPlayerHPViewer.y = this.mCharacterImage ? this.mCharacterImage.height - this.mPlayerHPViewer.height : height - this.mPlayerHPViewer.height;
            }
            if(Boolean(this.mPlayerHPViewerCover) && Boolean(this.mPlayerHPViewer))
            {
               this.mPlayerHPViewerCover.x = this.mPlayerHPViewer.x + this.mPlayerHPViewerCover.width / 2;
               this.mPlayerHPViewerCover.y = this.mPlayerHPViewer.y + this.mPlayerHPViewerCover.height / 2;
            }
            if(Boolean(this.mFrameBGImg) && Boolean(this.mPlayerHPViewer))
            {
               this.mFrameBGImg.x = 0;
               this.mFrameBGImg.y = this.mPlayerHPViewer.y - this.mFrameBGImg.height * 1.05;
            }
            if(Boolean(this.mUserImage) && Boolean(this.mFrameBGImg))
            {
               this.mUserImage.x = this.mFrameBGImg.x + (this.mFrameBGImg.width - this.mUserImage.width) / 2;
               this.mUserImage.y = this.mFrameBGImg.y + (this.mFrameBGImg.height - this.mUserImage.height) / 2;
            }
            if(Boolean(this.mNameFrame) && Boolean(this.mPlayerHPViewerCover))
            {
               this.mNameFrame.x = this.mGuildEmblem ? this.mGuildEmblem.x + this.mGuildEmblem.width : 0;
               this.mNameFrame.y = this.mGuildEmblem ? y + this.mPlayerHPViewer.y - this.mGuildEmblem.height * 2 : this.mPlayerHPViewerCover.y - this.mPlayerHPViewerCover.height / 2 - this.mNameFrame.height;
            }
            if(Boolean(this.mFrameBGImg) && Boolean(this.mNameFrame))
            {
               this.mFrameBGImg.x = 0;
               this.mFrameBGImg.y = this.mNameFrame.y - this.mFrameBGImg.height;
            }
            if(Boolean(this.mUserImage) && Boolean(this.mFrameBGImg))
            {
               this.mUserImage.x = this.mFrameBGImg.x + (this.mFrameBGImg.width - this.mUserImage.width) / 2;
               this.mUserImage.y = this.mFrameBGImg.y + (this.mFrameBGImg.height - this.mUserImage.height) / 2;
            }
         }
         else
         {
            if(Boolean(this.mCharacterImage) && Boolean(this.mPortraitImg))
            {
               this.mCharacterImage.x = this.mRankBG ? this.mRankBG.width / 4 : 0;
               this.mCharacterImage.y = 0;
            }
            if(this.mRankBG != null)
            {
               this.mRankBG.x = this.mRankBG.width / 2;
               this.mRankBG.y = this.mCharacterImage ? this.mCharacterImage.height * 0.85 + this.mRankBG.height / 2 : this.mRankBG.height / 2;
            }
            if(Boolean(this.mRankInsigniaImage) && Boolean(this.mRankBG))
            {
               this.mRankInsigniaImage.x = this.mRankBG.x - this.mRankBG.width / 2 + this.mRankInsigniaImage.width / 1.9;
               this.mRankInsigniaImage.y = this.mRankBG.y;
            }
            if(Boolean(this.mPortraitImg != null) && Boolean(this.mRankBG) && Boolean(this.mPortraitImg))
            {
               this.mPortraitImg.scale = 1;
               this.mPortraitImg.alignPivot();
               this.mPortraitImg.x = this.mRankInsigniaImage ? this.mRankInsigniaImage.x + this.mPortraitImg.width / 2 + 5 : 0;
               this.mPortraitImg.y = this.mRankInsigniaImage ? this.mRankInsigniaImage.y : 0;
            }
            if(Boolean(this.mPlayerHPViewerCover && this.mPlayerHPViewer) && Boolean(this.mPortraitImg) && Boolean(this.mRankBG))
            {
               this.mPlayerHPViewer.alignPivot();
               _loc1_ = this.mPlayerHPViewer.getUsefulHeight();
               this.mPlayerHPViewer.x = this.mPortraitImg.x;
               this.mPlayerHPViewer.y = this.mPortraitImg.y + (this.mPlayerHPViewer.height - _loc1_) / 2;
               this.mPlayerHPViewerCover.x = this.mRankBG.x - this.mRankBG.width / 2;
               this.mPlayerHPViewerCover.y = this.mRankBG.y;
            }
            this.refreshGuildEmblemPos();
            if(Boolean(this.mNameFrame) && Boolean(this.mPortraitImg))
            {
               this.mNameFrame.x = this.mGuildEmblem ? this.mGuildEmblem.x + this.mGuildEmblem.width : 0;
               this.mNameFrame.y = this.mGuildEmblem ? this.mGuildEmblem.y : this.mPortraitImg.y + this.mPortraitImg.height / 2;
            }
         }
      }
      
      private function createCharacter(param1:String, param2:Boolean = false) : void
      {
         if(this.mCharacterImage == null)
         {
            this.mCharacterImage = new FSImage(Root.assets.getTexture(param1));
            this.mCharacterImage.scaleX = this.mCharacterImage.scaleY = param2 && this.mHasSimpleUI ? 0.5 : 1;
            if(param2)
            {
               this.mCharacterImage.y -= this.mCharacterImage.height * 0.1;
            }
            this.mCharacterImage.touchable = true;
            this.mFrameContainer.addChildAt(this.mCharacterImage,0);
         }
         else
         {
            this.mCharacterImage.texture = Root.assets.getTexture(param1);
         }
      }
      
      public function getCharacterCurrentTexture() : Texture
      {
         return this.mCharacterImage ? this.mCharacterImage.texture : null;
      }
      
      private function createPlayerHPCover() : void
      {
         if(!this.mIsInfoPortrait)
         {
            if(this.mPlayerHPViewerCover == null)
            {
               this.mPlayerHPViewerCover = new FSImage(Root.assets.getTexture("character_frame"));
               this.mPlayerHPViewerCover.alignPivot();
               this.mPlayerHPViewerCover.touchable = false;
               if(this.mHasSimpleUI)
               {
                  this.mFrameContainer.addChild(this.mPlayerHPViewerCover);
               }
            }
            if(!this.mHasSimpleUI)
            {
               if(this.mRankBG == null)
               {
                  this.mRankBG = new FSImage(Root.assets.getTexture("rank_layer"));
                  this.mRankBG.alignPivot();
                  this.mRankBG.x = this.mRankBG.width / 2;
                  this.mRankBG.y = this.mRankBG.height / 2;
                  this.mRankBG.touchable = false;
                  this.mFrameContainer.addChild(this.mRankBG);
               }
            }
         }
      }
      
      public function getPlayerHPCover() : FSImage
      {
         return this.mPlayerHPViewerCover;
      }
      
      public function getGuildInfo() : void
      {
         var onGuildInfoACK:Function = null;
         var ownerGuild:Guild = null;
         onGuildInfoACK = function(param1:Object):void
         {
            var _loc2_:String = null;
            var _loc3_:String = null;
            var _loc4_:String = null;
            if(Boolean(param1) && (param1 as Array).length > 0)
            {
               param1 = param1[0];
               _loc2_ = param1["emblemBG"];
               _loc3_ = param1["emblemFG"];
               _loc4_ = param1["guildName"];
               createGuildEmblem(_loc2_,_loc3_,_loc4_);
            }
         };
         if(Config.HAS_GUILDS && !this.mIsIAOpponent && this.mUserData != null && this.mUserData.hasGuild())
         {
            if(this.mIsOpponent)
            {
               InstanceMng.getServerConnection().searchInCollection("guilds","{\'guildId\':\'" + this.mUserData.getGuildId() + "\'}",onGuildInfoACK);
            }
            else
            {
               ownerGuild = InstanceMng.getGuildsMng().getMyGuild();
               if(ownerGuild)
               {
                  this.createGuildEmblem(ownerGuild.getEmblemBG(),ownerGuild.getEmblemFG(),ownerGuild.getName());
               }
               else
               {
                  InstanceMng.getServerConnection().getGuildInfo(this.mUserData.getGuildId(),this.onGuildInfoReceived,null);
               }
            }
         }
      }
      
      private function checkIfGuildInfoArrived() : void
      {
         if(Config.HAS_GUILDS && !this.mIsIAOpponent && this.mUserData != null && this.mUserData.hasGuild())
         {
            if(this.mIsOpponent)
            {
               InstanceMng.getServerConnection().getGuildInfo(this.mUserData.getGuildId(),this.onGuildInfoReceived,null);
               TweenMax.delayedCall(3,this.checkIfGuildInfoArrived);
            }
         }
      }
      
      private function onGuildInfoReceived(param1:*) : void
      {
         if(param1)
         {
            TweenMax.killDelayedCallsTo(this.checkIfGuildInfoArrived);
            this.createGuildEmblem(Guild(param1).getEmblemBG(),Guild(param1).getEmblemFG(),Guild(param1).getName());
         }
      }
      
      protected function createGuildEmblem(param1:String, param2:String, param3:String) : void
      {
         if(this.mGuildEmblem == null)
         {
            this.mGuildEmblem = new GuildEmblem(param1,param2);
            this.mGuildEmblem.touchable = true;
            this.mGuildEmblem.width *= Config.getConfig().getPortraitGuildEmblemFactor();
            this.mGuildEmblem.height *= Config.getConfig().getPortraitGuildEmblemFactor();
            this.refreshGuildEmblemPos();
            this.mGuildEmblem.alpha = 0.5;
            if(param3 != null && param3 != "")
            {
               this.mGuildEmblem.setTooltipText(TextManager.getText("TID_GUILD_NAME_SINGLE") + ": " + param3);
            }
         }
      }
      
      public function getPortrait() : FSImage
      {
         return this.mPortraitImg;
      }
      
      public function setGuildEmblemTouchable() : void
      {
         if(this.mGuildEmblem)
         {
            this.mGuildEmblem.alpha = 1;
            this.mGuildEmblem.addEventListener(TouchEvent.TOUCH,this.onGuildEmblemTouch);
         }
      }
      
      public function refreshGuildEmblemPos() : void
      {
         if(Boolean(this.mGuildEmblem) && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            this.mGuildEmblem.x = x + 5;
            if(this.mPlayerHPViewer)
            {
               this.mGuildEmblem.y = this.mHasSimpleUI ? y + this.mPlayerHPViewer.y - this.mGuildEmblem.height * 1.05 : y + this.mPortraitImg.y + this.mPortraitImg.height / 2;
            }
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().addChild(this.mGuildEmblem);
            }
         }
         if(this.mNameFrame)
         {
            this.mNameFrame.x = this.mGuildEmblem ? this.mGuildEmblem.x + this.mGuildEmblem.width : 0;
         }
      }
      
      private function onGuildEmblemTouch(param1:TouchEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc2_:Touch = param1 ? param1.getTouch(this.mGuildEmblem,TouchPhase.ENDED) : null;
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getUserDataMng().getOwnerUserData() ? InstanceMng.getUserDataMng().getOwnerUserData().getCurrentLevelIndex(UserDataMng.DIFFICULTY_EASY) : 0;
            if(_loc3_ >= Config.getConfig().getUnlockGuildsLevel())
            {
               if(Boolean(InstanceMng.getPopupMng()) && Boolean(this.mUserData))
               {
                  InstanceMng.getPopupMng().openGuildsPopup(this.mUserData.getGuildId());
               }
            }
            else
            {
               _loc4_ = TextManager.replaceParameters(TextManager.getText("TID_GEN_FEATURE_LOCKED"),[Config.getConfig().getUnlockGuildsLevel()]);
               Utils.setLogText(_loc4_,true);
            }
         }
      }
      
      protected function createPortrait() : void
      {
         var _loc1_:String = null;
         if(Config.getConfig().gameHasRanks() && !this.mIsInfoPortrait)
         {
            _loc1_ = this.getPortraitFrameAssetName();
            if(this.mPortraitImg == null)
            {
               this.mPortraitImg = new FSImage(Root.assets.getTexture(_loc1_));
               if(this.mRankInsigniaImage)
               {
                  this.mPortraitImg.alignPivot();
                  this.mPortraitImg.x = this.mPlayerHPViewer.x;
                  this.mPortraitImg.y = this.mPlayerHPViewer.y;
               }
            }
            else
            {
               this.mPortraitImg.texture = Root.assets.getTexture(_loc1_);
            }
            if(this.mFrameContainer)
            {
               this.mFrameContainer.addChild(this.mPortraitImg);
            }
         }
      }
      
      public function getPortraitFrameAssetName() : String
      {
         var _loc2_:Boolean = false;
         var _loc3_:HeroCharacterDef = null;
         var _loc4_:RaidLevelDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:PortraitDef = null;
         var _loc9_:String = null;
         var _loc1_:String = "";
         if(Config.getConfig().gameHasRanks())
         {
            if(this.mIsOpponent)
            {
               _loc2_ = Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isPvPMatch();
               if(_loc2_)
               {
                  if(InstanceMng.getBattleEngine().isOnlineMatch() && Config.getConfig().hasPortraits())
                  {
                     _loc1_ = this.mUserData ? this.mUserData.getCurrentPortraitBGImageName(false) : "portrait_frame_01";
                  }
                  else
                  {
                     _loc1_ = this.mUserData ? this.mUserData.getCurrentPortraitBGImageName(false) : "portrait_frame_01";
                  }
               }
               else
               {
                  if(Root.smBattleData.isRaid)
                  {
                     _loc4_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(InstanceMng.getRaidsMng().getCurrentRaidDef().getLevelsByDifficultyIndex(InstanceMng.getRaidsMng().getCurrentRaidDifficulty())));
                     _loc3_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc4_.getEnemyHeroSku(UserData.WORLD_DEFAULT)));
                  }
                  else
                  {
                     _loc5_ = InstanceMng.getBattleEngine().getLevelDef().getMapWorldParentIndex();
                     _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc6_);
                     _loc3_ = this.mHeroDef ? this.mHeroDef : HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mLevelDef.getEnemyHeroSku(_loc6_)));
                  }
                  if(_loc3_)
                  {
                     _loc7_ = _loc3_.getPortraitSku();
                     _loc8_ = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(_loc7_));
                     _loc9_ = _loc8_.getBGImageName();
                     _loc1_ = _loc8_.getBGImageName();
                  }
                  _loc1_ = _loc1_ != "" ? _loc1_ : FSResourceMng.DEFAULT_AI_PORTRAIT_FRAME_NAME;
               }
            }
            else
            {
               _loc1_ = this.mUserData.getCurrentPortraitBGImageName();
            }
         }
         return _loc1_;
      }
      
      private function createFrameBase() : void
      {
         var _loc2_:String = null;
         if(this.mFrameContainer == null)
         {
            this.mFrameContainer = new Component();
            this.mFrameContainer.touchable = true;
            addChild(this.mFrameContainer);
         }
         var _loc1_:Boolean = this.mUserData.flagsShowDefaultAvatar();
         if(this.mFrameBGImg == null && !_loc1_)
         {
            _loc2_ = this.mIsOpponent && Config.getConfig().battleEnemyPortraitSpecial() ? ENEMY_FRAME_BG_NAME : FRAME_BG_NAME;
            this.mFrameBGImg = new FSImage(Root.assets.getTexture(_loc2_));
            this.mFrameBGImg.y += this.mFrameBGImg.height * 0.11;
            this.mFrameContainer.addChild(this.mFrameBGImg);
         }
      }
      
      protected function createUserPortrait() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:HeroCharacterDef = null;
         var _loc3_:HeroCharacterDef = null;
         var _loc4_:RaidLevelDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         if(this.mUserData != null)
         {
            _loc1_ = this.mUserData.flagsShowDefaultAvatar();
            if(this.mIsIAOpponent)
            {
               if(Root.smBattleData.isRaid)
               {
                  _loc4_ = RaidLevelDef(InstanceMng.getRaidLevelsDefMng().getLevelDefByLevelIndex(InstanceMng.getRaidsMng().getCurrentRaidDef().getLevelsByDifficultyIndex(InstanceMng.getRaidsMng().getCurrentRaidDifficulty())));
                  _loc3_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(_loc4_.getEnemyHeroSku(UserData.WORLD_DEFAULT)));
               }
               else
               {
                  _loc5_ = InstanceMng.getBattleEngine().getLevelDef().getMapWorldParentIndex();
                  _loc6_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc6_);
                  _loc3_ = this.mHeroDef ? this.mHeroDef : HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mLevelDef.getEnemyHeroSku(_loc6_)));
               }
               if(_loc3_)
               {
                  if(this.mFrameBGImg)
                  {
                     this.mFrameBGImg.removeFromParent();
                  }
                  this.createCharacter(_loc3_.getBGImageName(),this.mIsInfoPortrait);
               }
               else
               {
                  this.mUserImage = this.mUserData.getPhoto();
                  this.createCharacterImage();
                  this.mUserImage = null;
                  if(this.mFrameBGImg)
                  {
                     this.mFrameBGImg.removeFromParent();
                  }
               }
            }
            else
            {
               this.createCharacterImage();
               if(!_loc1_)
               {
                  this.mUserImage = this.mUserData.getPhoto();
                  if(Boolean(this.mFrameBGImg) && Boolean(this.mUserImage))
                  {
                     this.mFrameBGImg.width = this.mUserImage.width * 1.05;
                     this.mFrameBGImg.height = this.mUserImage.height * 1.05;
                  }
                  _loc7_ = this.mUserData ? this.mUserData.getExtId() : "sample";
                  _loc8_ = false;
                  _loc7_ = _loc8_ ? "582075610" : _loc7_;
                  if(Boolean(this.mUserData) && _loc7_ != "sample")
                  {
                     if(this.mUserData.getPhotoTexture() != null)
                     {
                        this.onProfilePicLoaded(this.mUserData.getPhotoTexture());
                     }
                     else
                     {
                        Utils.loadProfilePicture(_loc7_,this.onProfilePicLoaded);
                     }
                  }
               }
            }
            if(this.mUserImage != null && !_loc1_)
            {
               if(this.mIsOpponent)
               {
                  if(this.mFrameBGImg)
                  {
                     this.mFrameBGImg.scaleX = this.mFrameBGImg.scaleY = 0.45;
                     this.mUserImage.width = this.mUserImage.width = this.mUserImage.height = this.mUserImage.height = this.mFrameBGImg.width * 0.9;
                  }
               }
               else if(this.mFrameBGImg)
               {
                  this.mUserImage.scaleX = this.mUserImage.scaleY = this.mFrameBGImg.scaleX = this.mFrameBGImg.scaleY = 0.65;
               }
               this.mUserImage.x = this.mPortraitImg ? this.mPortraitImg.x - this.mPortraitImg.width / 2 + (this.mPortraitImg.width - this.mUserImage.width) / 2 : this.mFrameBGImg.x + (this.mFrameBGImg.width - this.mUserImage.width) / 2;
               this.mUserImage.y = this.mPortraitImg ? this.mPortraitImg.y - this.mPortraitImg.height / 2 + (this.mPortraitImg.height - this.mUserImage.height) / 2 : this.mFrameBGImg.y + (this.mFrameBGImg.height - this.mUserImage.height) / 2;
               this.mFrameContainer.addChildAt(this.mUserImage,1);
            }
         }
      }
      
      protected function createCharacterImage() : void
      {
         var _loc1_:HeroCharacterDef = null;
         var _loc2_:String = this.mIsIAOpponent ? "player_2_photo" : FSResourceMng.DEFAULT_PHOTO_NAME;
         var _loc3_:UserData = this.mIsOpponent ? InstanceMng.getUserDataMng().getOpponentUserData() : InstanceMng.getUserDataMng().getOwnerUserData();
         var _loc4_:Boolean = Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isPvPMatch();
         if(Config.getConfig().hasSkins())
         {
            if(Config.getConfig().gameHasClassSystem())
            {
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  _loc1_ = FSBattleScreen(InstanceMng.getCurrentScreen()).getHeroCharacterDef(!this.mIsOpponent,_loc4_);
               }
            }
            else
            {
               _loc1_ = _loc3_.getCurrentSkinDef();
            }
            if(_loc1_)
            {
               this.createCharacter(_loc1_.getBGImageName());
            }
         }
         else
         {
            this.createCharacter(_loc2_);
         }
      }
      
      protected function createPlayerHPViewer() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BattleEngine = null;
         var _loc3_:Boolean = false;
         if(!this.mIsInfoPortrait)
         {
            _loc1_ = 0;
            if(this.mLevelDef)
            {
               _loc1_ = this.mIsIAOpponent ? this.mLevelDef.getIAHP() : this.mLevelDef.getHP();
            }
            _loc2_ = InstanceMng.getBattleEngine();
            _loc3_ = Boolean(_loc2_) && _loc2_.isPvPMatch();
            if(_loc3_)
            {
               _loc1_ = PvPConnectionMng.getHPForPvPMatch();
            }
            this.mPlayerHPViewer = new PlayerHPViewer();
            this.mPlayerHPViewer.updateHP(_loc1_,true);
            this.mFrameContainer.addChild(this.mPlayerHPViewer);
         }
         if(Boolean(!this.mIsInfoPortrait) && Boolean(this.mPlayerHPViewerCover) && this.mHasSimpleUI)
         {
            this.mFrameContainer.addChild(this.mPlayerHPViewerCover);
         }
         if(!this.mIsInfoPortrait && Boolean(this.mPlayerHPViewer))
         {
            if(!this.mHasSimpleUI)
            {
               this.mPlayerHPViewer.x = this.mRankBG.x + this.mPlayerHPViewer.width;
               this.mPlayerHPViewer.y = this.mRankBG.y;
            }
            else
            {
               this.mPlayerHPViewer.x = this.mFrameBGImg ? this.mFrameBGImg.x + this.mFrameBGImg.width / 1.95 : 0;
               this.mPlayerHPViewer.y = this.mFrameBGImg ? this.mFrameBGImg.y + this.mFrameBGImg.height * 1.02 : 0;
            }
            this.mPlayerHPViewer.setFontSize(FSResourceMng.FONT_STD_SUBTITLE_SIZE);
         }
      }
      
      protected function createNameFrame() : void
      {
         if(!this.mIsInfoPortrait)
         {
            if(this.mNameFrame == null)
            {
               this.mNameFrame = new Component();
               this.mNameFrame.touchable = false;
               this.mNameFrameImage = new FSImage(Root.assets.getTexture(NAME_FRAME_BG_NAME));
               this.mNameFrameImage.touchable = false;
               this.mNameFrameImage.scaleX *= 1 * Layout.getFontMultiplier();
               this.mNameFrameImage.scaleY *= 0.85 * Layout.getFontMultiplier();
               this.mNameFrame.addChild(this.mNameFrameImage);
            }
            this.mNameFrame.y = 0;
            this.mFrameContainer.addChild(this.mNameFrame);
         }
      }
      
      public function getName() : String
      {
         var name:String = null;
         var mapWorldParentIndex:int = 0;
         var mapWorldChoice:int = 0;
         var heroDef:HeroCharacterDef = null;
         var fbName:String = null;
         var extName:String = null;
         var getDefaultName:Function = function():String
         {
            var _loc1_:Boolean = mUserData ? mUserData.flagsIsFirstChangeName() : false;
            return mUserData != null && _loc1_ ? mUserData.getName() : TextManager.getText("TID_GEN_PLAYER");
         };
         var battleEngine:BattleEngine = InstanceMng.getBattleEngine();
         var isPvP:Boolean = Boolean(battleEngine) && battleEngine.isPvPMatch();
         if(this.mIsOpponent)
         {
            if(isPvP)
            {
               if(Boolean(battleEngine) && battleEngine.isOnlineMatch())
               {
                  name = this.mUserData != null ? this.mUserData.getName() : TextManager.getText("TID_PVP_PLAYER_2");
               }
               else
               {
                  name = TextManager.getText("TID_PVP_PLAYER_2");
               }
            }
            else
            {
               mapWorldParentIndex = InstanceMng.getBattleEngine().getLevelDef().getMapWorldParentIndex();
               mapWorldChoice = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(mapWorldChoice);
               heroDef = this.mHeroDef ? this.mHeroDef : HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mLevelDef.getEnemyHeroSku(mapWorldChoice)));
               name = heroDef != null ? heroDef.getName() : TextManager.getText("TID_PVP_PLAYER_2");
            }
         }
         else if(isPvP)
         {
            if(battleEngine.isOnlineMatch())
            {
               name = this.mUserData != null ? this.mUserData.getName() : TextManager.getText("TID_PVP_PLAYER_1");
            }
            else
            {
               name = TextManager.getText("TID_PVP_PLAYER_1");
            }
         }
         else if(this.mIsInfoPortrait && this.mHeroDef != null)
         {
            name = this.mHeroDef.getName();
         }
         else if(InstanceMng.getFacebookPlugin() != null && InstanceMng.getFacebookPlugin().isSessionOpen())
         {
            fbName = InstanceMng.getFacebookPlugin().getFBName();
            if(fbName != null)
            {
               name = fbName;
            }
            else
            {
               name = getDefaultName();
            }
         }
         else if(InstanceMng.getApplication().isKongregateVersion())
         {
            extName = InstanceMng.getApplication().getKongName();
            if(extName != null && extName != "")
            {
               name = extName;
            }
            else
            {
               name = getDefaultName();
            }
         }
         else
         {
            name = getDefaultName();
         }
         return name;
      }
      
      private function setPlayerName() : void
      {
         var _loc1_:String = this.getName();
         _loc1_ = _loc1_ ? _loc1_ : "";
         this.createNameTextfield(_loc1_);
         if(this.mNameTextfield)
         {
            this.mNameTextfield.text = _loc1_.toUpperCase();
            if(this.mNameFrame)
            {
               this.mNameTextfield.y = 0;
               this.mNameFrame.addChild(this.mNameTextfield);
            }
            else if(this.mFrameContainer)
            {
               this.mFrameContainer.addChild(this.mNameTextfield);
            }
         }
      }
      
      protected function createNameTextfield(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.mIsInfoPortrait)
         {
            return;
         }
         param1 = param1 ? param1 : "";
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         var _loc3_:Boolean = Boolean(_loc2_) && _loc2_.isPvPMatch();
         if(this.mNameTextfield == null)
         {
            _loc5_ = this.mNameFrame ? this.mNameFrame.width * 0.75 : width * 0.75;
            _loc6_ = this.mNameFrame ? this.mNameFrame.height : 40;
            _loc5_ *= Layout.getFontMultiplier();
            this.mNameTextfield = new FSTextfield(_loc5_,_loc6_,param1.toUpperCase());
            this.mNameTextfield.touchable = false;
            this.mNameTextfield.x = this.mNameFrameImage ? this.mNameFrameImage.x + 2 : 2;
            _loc4_ = FSResourceMng.getFontByType();
            this.mNameTextfield.fontSize = Utils.isIphone() ? 21 : this.mNameTextfield.fontSize;
            this.mNameTextfield.fontName = _loc4_;
            this.mNameTextfield.format.horizontalAlign = Align.LEFT;
            this.mNameTextfield.format.verticalAlign = Align.CENTER;
         }
      }
      
      protected function addRankInsignia() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:RankDef = null;
         var _loc3_:Texture = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:HeroCharacterDef = null;
         if(this.mFrameContainer != null)
         {
            _loc1_ = Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isPvPMatch();
            if(this.mIsOpponent)
            {
               if(_loc1_)
               {
                  _loc2_ = this.mUserData.getRankDef();
               }
               else
               {
                  _loc4_ = InstanceMng.getBattleEngine().getLevelDef().getMapWorldParentIndex();
                  _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc5_);
                  _loc6_ = this.mHeroDef ? this.mHeroDef : HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mLevelDef.getEnemyHeroSku(_loc5_)));
                  if(_loc6_)
                  {
                     _loc2_ = RankDef(InstanceMng.getRanksDefMng().getDefBySku(_loc6_.getRankSku()));
                  }
               }
            }
            else
            {
               _loc2_ = this.mUserData.getRankDef();
            }
            _loc3_ = _loc2_ != null ? Root.assets.getTexture(_loc2_.getBGImageName()) : null;
            if(_loc3_ != null)
            {
               this.mRankInsigniaImage = new FSImage(_loc3_);
               this.mRankInsigniaImage.alignPivot();
               this.mFrameContainer.addChild(this.mRankInsigniaImage);
            }
         }
      }
      
      public function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         if(this.mHasSimpleUI)
         {
            addEventListener(EnterFrameEvent.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Ability = null;
         var _loc4_:Boolean = false;
         var _loc5_:FSCard = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            _loc3_ = InstanceMng.getBattleEngine().getAbilityWaitingForTarget();
            if(_loc3_ != null)
            {
               _loc4_ = InstanceMng.getBattleEngine().isPowerWaitingForTarget();
               _loc5_ = _loc3_.getParentCard();
               if(_loc5_ != null && _loc5_.checkIfNeedsToBeStoredInSaveObj(false,false))
               {
                  if(_loc4_)
                  {
                     _loc7_ = this.getUserBattleInfo().isOwnerBattleInfo() ? "owner_portrait" : "opponent_portrait";
                     BattleEnginePvP(InstanceMng.getBattleEngine()).onPowerUnitTargetSelected(_loc7_);
                  }
                  else
                  {
                     _loc8_ = this.getUserBattleInfo().isOwnerBattleInfo() ? "owner_" : "opponent_";
                     _loc8_ = _loc8_ + "portrait";
                     BattleEnginePvP(InstanceMng.getBattleEngine()).onUnitTargetSelected(_loc5_,_loc8_);
                  }
               }
               _loc6_ = new Array();
               _loc6_.push(this.mUserBattleInfo);
               _loc3_.onTargetSelected(_loc6_);
            }
         }
      }
      
      override public function activateSpecialHighlightParticle(param1:ColorArgb = null, param2:ColorArgb = null) : void
      {
         if(this.mFrameContainer)
         {
            this.mFrameContainer.activateSpecialHighlightParticle(param1,param2);
            touchable = true;
            if(this.mItemTargetedAnim == null)
            {
               this.mItemTargetedAnim = new FSItemTargetedAnim();
            }
            TweenMax.killTweensOf(this.mItemTargetedAnim);
            TweenMax.killDelayedCallsTo(this.onItemTargetAnimMotionOff);
            if(Config.getConfig().hasSkins())
            {
               this.mItemTargetedAnim.x = this.mCharacterImage ? this.mCharacterImage.x + this.mCharacterImage.width / 2 : x + width / 2;
               this.mItemTargetedAnim.y = this.mCharacterImage ? this.mCharacterImage.y + this.mCharacterImage.height / 2 : y + height / 2;
            }
            else if(this.mHasSimpleUI)
            {
               this.mItemTargetedAnim.x = this.mUserImage ? this.mUserImage.x + this.mUserImage.width / 2 : x + width / 2;
               this.mItemTargetedAnim.y = this.mUserImage ? this.mUserImage.y + this.mUserImage.height / 2 : y + height / 2;
            }
            else
            {
               this.mItemTargetedAnim.x = this.mCharacterImage ? this.mCharacterImage.x + this.mCharacterImage.width / 2 : x + width / 4;
               this.mItemTargetedAnim.y = this.mCharacterImage ? this.mCharacterImage.y + this.mCharacterImage.height / 2 : y;
            }
            this.mItemTargetedAnim.startMotion(true);
            addChild(this.mItemTargetedAnim);
         }
      }
      
      override public function deactivateSpecialHighlightParticle() : void
      {
         if(this.mFrameContainer)
         {
            this.mFrameContainer.deactivateSpecialHighlightParticle();
         }
         if(this.mItemTargetedAnim)
         {
            this.mItemTargetedAnim.startMotion(false,this.onItemTargetAnimMotionOff);
         }
         touchable = false;
      }
      
      private function onItemTargetAnimMotionOff() : void
      {
         if(this.mItemTargetedAnim)
         {
            this.mItemTargetedAnim.removeFromParent();
            this.mItemTargetedAnim.destroy();
            this.mItemTargetedAnim = null;
         }
      }
      
      public function showAbilityBeingAppliedIcon(param1:Ability) : void
      {
         var _loc3_:FSImage = null;
         var _loc2_:Boolean = !(param1.getAbilityDef().getAnimKey() == null || param1.getAbilityDef().getAnimKey() == "");
         if(param1 != null && !_loc2_)
         {
            _loc3_ = new FSImage(Root.assets.getTexture(param1.getAbilityDef().getBGXLImageName()));
            if(_loc3_ != null)
            {
               _loc3_.x = width / 2 - _loc3_.width / 2;
               _loc3_.y = height / 2 - _loc3_.height / 2;
               addChild(_loc3_);
               SpecialFX.tweenToAlpha(_loc3_,0.001,2,0,Utils.removeImageFromParent,[_loc3_]);
            }
         }
      }
      
      public function setPlayerInvulnerable(param1:Boolean) : void
      {
         if(this.mInvulnerableSprite == null)
         {
            this.mInvulnerableSprite = new Component();
            this.mInvulnerableSprite.x = 0;
            this.mInvulnerableSprite.y = 0;
            this.mInvulnerableSprite.name = "SHIELD";
         }
         if(param1)
         {
            this.mInvulnerableSprite.alpha = 0.999;
            addChild(this.mInvulnerableSprite);
         }
         else if(this.mInvulnerableSprite != null && this.mInvulnerableSprite.parent != null)
         {
            SpecialFX.tweenToAlpha(this.mInvulnerableSprite,0.001,1.5,0,this.removeComponentFromParent,[this.mInvulnerableSprite]);
         }
         if(this.mInvulnerableSprite != null && this.mInvulnerableImage == null)
         {
            this.mInvulnerableImage = new FSImage(Root.assets.getTexture("shield"));
            this.mInvulnerableSprite.y = this.mInvulnerableImage.height / 2;
            this.mInvulnerableSprite.addChild(this.mInvulnerableImage);
         }
         this.setInvulnerableTextfield(param1);
      }
      
      private function removeComponentFromParent(param1:Component) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      private function setInvulnerableTextfield(param1:Boolean) : void
      {
         if(this.mInvulnerableTextfield == null)
         {
            this.mInvulnerableTextfield = new FSTextfield(this.mInvulnerableImage.width,this.mInvulnerableImage.height);
         }
         if(this.mInvulnerableSprite != null && this.mInvulnerableTextfield != null)
         {
            this.mInvulnerableSprite.addChild(this.mInvulnerableTextfield);
            this.mInvulnerableTextfield.text = InstanceMng.getBattleEngine().getTurnsWithoutTakingDamage().toString();
         }
      }
      
      public function performInvulnerableAnim() : void
      {
         var _loc1_:Array = null;
         var _loc2_:FSCoordinate = null;
         if(this.mInvulnerableSprite != null && this.mInvulnerableSprite.parent != null)
         {
            _loc1_ = TweenMax.getTweensOf(this.mInvulnerableSprite);
            if(_loc1_ == null || _loc1_.length == 0)
            {
               _loc2_ = new FSCoordinate(this.mInvulnerableSprite.x,this.mInvulnerableSprite.y - 20);
               SpecialFX.createYoYoTransition(this.mInvulnerableSprite,_loc2_,1);
            }
         }
      }
      
      public function updateHP() : void
      {
         if(!this.mIsInfoPortrait && this.mUserBattleInfo != null)
         {
            this.mPlayerHPViewer.updateHP(this.mUserBattleInfo.getHP());
         }
      }
      
      public function getHPPlayerViewer() : PlayerHPViewer
      {
         return this.mPlayerHPViewer;
      }
      
      public function getUserData() : UserData
      {
         return this.mUserData;
      }
      
      public function setUserData(param1:UserData) : void
      {
         this.mUserData = param1;
      }
      
      public function getIsOpponent() : Boolean
      {
         return this.mIsOpponent;
      }
      
      public function setIsOpponent(param1:Boolean) : void
      {
         this.mIsOpponent = param1;
      }
      
      public function getIsIAOpponent() : Boolean
      {
         return this.mIsIAOpponent;
      }
      
      public function setIsIAOpponent(param1:Boolean) : void
      {
         this.mIsIAOpponent = param1;
      }
      
      public function getUserImage() : FSImage
      {
         return this.mUserImage;
      }
      
      public function setUserImage(param1:FSImage) : void
      {
         this.mUserImage = param1;
      }
      
      public function getUserBattleInfo() : UserBattleInfo
      {
         return this.mUserBattleInfo;
      }
      
      public function setUserBattleInfo(param1:UserBattleInfo) : void
      {
         this.mUserBattleInfo = param1;
      }
      
      public function getInvulnerableSprite() : Component
      {
         return this.mInvulnerableSprite;
      }
      
      public function unload() : void
      {
         var _loc1_:Component = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < numChildren)
         {
            if(getChildAt(_loc2_) != null && getChildAt(_loc2_) is CardAnimation)
            {
               CardAnimation(getChildAt(_loc2_)).unload(true);
            }
            _loc2_++;
         }
         if(this.mPortraitImg)
         {
            this.mPortraitImg.rotation = 0;
         }
      }
      
      public function addPortraitAnimationAttached(param1:CardAnimation) : void
      {
         if(this.mCardAnimsAttached == null)
         {
            this.mCardAnimsAttached = new Vector.<CardAnimation>();
         }
         if(Boolean(this.mCardAnimsAttached) && param1 is BulletsAnim)
         {
            this.removeCardAnimsByAbility(AbilitiesMng.BULLETS_MIX_ANIM);
            this.removeCardAnimsByAbility(AbilitiesMng.EXPLOSION_TANK_ANIM);
         }
         this.mCardAnimsAttached.push(param1);
      }
      
      public function removeCardAnimsByAbility(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:CardAnimation = null;
         var _loc4_:FSImage = null;
         var _loc5_:int = 0;
         if(this.mCardAnimsAttached != null)
         {
            _loc5_ = 0;
            while(_loc5_ < this.mCardAnimsAttached.length)
            {
               _loc3_ = this.mCardAnimsAttached[_loc5_];
               if(_loc3_ != null && _loc3_.isPermanent() && _loc3_.getAbilityItBelongsTo() == param1)
               {
                  if(!param2)
                  {
                     _loc3_.unload();
                     _loc3_.removeFromParent();
                  }
                  else
                  {
                     SpecialFX.tweenToAlpha(_loc3_,0.001,0.5,0,this.onCardAnimFaded,[_loc3_]);
                  }
                  this.mCardAnimsAttached.splice(_loc5_,1);
                  return;
               }
               _loc5_++;
            }
         }
      }
      
      private function onCardAnimFaded(param1:CardAnimation) : void
      {
         if(param1)
         {
            param1.unload();
            param1.removeFromParent();
         }
      }
      
      public function removeCardAnims() : void
      {
         var _loc1_:CardAnimation = null;
         if(this.mCardAnimsAttached != null)
         {
            for each(_loc1_ in this.mCardAnimsAttached)
            {
               _loc1_.unload();
               _loc1_.removeFromParent();
            }
         }
      }
      
      public function getFrameContainer() : Component
      {
         return this.mFrameContainer;
      }
      
      public function startPortraitFrameRotation() : void
      {
         this.mRotationAllowed = true;
         if(this.mCharacterImage)
         {
            if(this.mOriginalCharacterImageCoord == null)
            {
               this.mOriginalCharacterImageCoord = new FSCoordinate(this.mCharacterImage.x,this.mCharacterImage.y);
            }
            this.mCharacterImage.x = this.mOriginalCharacterImageCoord.mX;
            this.mCharacterImage.y = this.mOriginalCharacterImageCoord.mY;
            TweenMax.killTweensOf(this.mCharacterImage);
            SpecialFX.createYoYoTransition(this.mCharacterImage,new FSCoordinate(this.mCharacterImage.x,this.mCharacterImage.y + 6),1,-1,null,Sine.easeInOut);
         }
      }
      
      public function stopPortraitFrameRotation() : void
      {
         this.mRotationAllowed = false;
         if(this.mCharacterImage)
         {
            if(this.mOriginalCharacterImageCoord == null)
            {
               this.mOriginalCharacterImageCoord = new FSCoordinate(this.mCharacterImage.x,this.mCharacterImage.y);
            }
            this.mCharacterImage.x = this.mOriginalCharacterImageCoord.mX;
            this.mCharacterImage.y = this.mOriginalCharacterImageCoord.mY;
            TweenMax.killTweensOf(this.mCharacterImage);
         }
      }
      
      private function onEnterFrame(param1:EnterFrameEvent) : void
      {
         if(this.mRotationAllowed)
         {
            if(this.mPortraitImg != null)
            {
               this.mFrictionValue = 1;
               this.mPortraitImg.rotation += Constants.ROTATION_VALUE / 2;
            }
         }
         else if(this.mFrictionValue >= 0 && this.mFrictionValue > 0)
         {
            if(this.mPortraitImg != null)
            {
               this.mPortraitImg.rotation += Constants.ROTATION_VALUE / 2 * this.mFrictionValue;
               this.mFrictionValue -= 0.005;
            }
         }
      }
      
      public function getNameFrame() : Component
      {
         return this.mNameFrame;
      }
      
      public function getNameTextfield() : FSTextfield
      {
         return this.mNameTextfield;
      }
      
      public function showMessageBubble(param1:int = -1) : void
      {
         var _loc2_:String = null;
         var _loc3_:Point = null;
         if(InstanceMng.getBattleEngine() != null && !InstanceMng.getBattleEngine().isBattleOver() && param1 != -1)
         {
            _loc2_ = this.getChatTextByIndex(param1);
            if(this.mPlayerMessageBubble == null)
            {
               this.mPlayerMessageBubble = new FSButton(Root.assets.getTexture("map_info_bubble"),_loc2_);
               this.mPlayerMessageBubble.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
               this.mPlayerMessageBubble.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
               this.mPlayerMessageBubble.fontColor = 0;
               this.mPlayerMessageBubble.touchable = false;
            }
            else
            {
               this.mPlayerMessageBubble.text = _loc2_;
               this.mPlayerMessageBubble.alpha = 1;
            }
            TweenMax.killTweensOf(this.mPlayerMessageBubble);
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().addChild(this.mPlayerMessageBubble);
            }
            _loc3_ = this.mPortraitImg ? localToGlobal(new Point(this.mPortraitImg.x + this.mPortraitImg.width / 1.8,this.mPortraitImg.y)) : new Point(x + width / 2,y);
            this.mPlayerMessageBubble.x = this.mHasSimpleUI ? _loc3_.x + this.mPlayerMessageBubble.width : _loc3_.x + this.mPlayerMessageBubble.width / 2;
            this.mPlayerMessageBubble.y = this.mHasSimpleUI ? _loc3_.y + this.mPlayerMessageBubble.height : _loc3_.y - this.mPlayerMessageBubble.height;
            setTimeout(SpecialFX.tweenToAlpha,1500,this.mPlayerMessageBubble,0,2,0,this.onPlayerBubbleFaded);
         }
      }
      
      private function onPlayerBubbleFaded() : void
      {
         if(this.mPlayerMessageBubble)
         {
            this.mPlayerMessageBubble.removeFromParent();
         }
      }
      
      public function showMessage(param1:String) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         var _loc4_:FSCoordinate = null;
         if(InstanceMng.getBattleEngine() != null && !InstanceMng.getBattleEngine().isBattleOver() && param1 != null)
         {
            if(this.mPlayerMessageTextfield == null)
            {
               this.mPlayerMessageTextfield = new FSTextfield(width * 2,height,param1);
               this.mPlayerMessageTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
               this.mPlayerMessageTextfield.color = this.mIsOpponent ? 16711680 : 65280;
               this.mPlayerMessageTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
               this.mPlayerMessageTextfield.format.horizontalAlign = Align.LEFT;
               this.mPlayerMessageTextfield.touchable = false;
               if(InstanceMng.getCurrentScreen())
               {
                  InstanceMng.getCurrentScreen().addChild(this.mPlayerMessageTextfield);
               }
            }
            else
            {
               this.mPlayerMessageTextfield.text = param1;
               if(InstanceMng.getCurrentScreen())
               {
                  InstanceMng.getCurrentScreen().addChild(this.mPlayerMessageTextfield);
               }
            }
            if(parent)
            {
               parent.addChild(this);
            }
            TweenMax.killTweensOf(this.mPlayerMessageTextfield);
            this.mPlayerMessageTextfield.alpha = 0.999;
            _loc2_ = this.mPortraitImg ? localToGlobal(new Point(this.mPortraitImg.x + this.mPortraitImg.width / 1.8,this.mPortraitImg.y)) : new Point(0,height);
            this.mPlayerMessageTextfield.x = _loc2_.x;
            this.mPlayerMessageTextfield.y = _loc2_.y;
            _loc3_ = this.mPortraitImg ? this.mPlayerMessageTextfield.y - this.mPortraitImg.height : this.mPlayerMessageTextfield.height * 3;
            _loc4_ = new FSCoordinate(this.mPlayerMessageTextfield.x,_loc3_);
            if(InstanceMng.getCurrentScreen())
            {
               InstanceMng.getCurrentScreen().addChild(this.mPlayerMessageTextfield);
            }
            SpecialFX.createTransition(this.mPlayerMessageTextfield,_loc4_,4,0,this.onPlayerMessageTransitionCompleted);
         }
      }
      
      private function onPlayerMessageTransitionCompleted() : void
      {
         if(this.mPlayerMessageTextfield)
         {
            SpecialFX.tweenToAlpha(this.mPlayerMessageTextfield,0.001,5,0);
         }
      }
      
      private function onProfilePicLoaded(param1:Texture) : void
      {
         if(this.mUserImage)
         {
            this.mUserImage.removeFromParent();
            this.mUserImage.texture = param1;
            this.mFrameContainer.addChild(this.mUserImage);
            if(this.mFrameBGImg)
            {
               this.mFrameBGImg.width = this.mUserImage.width * 1.05;
               this.mFrameBGImg.height = this.mUserImage.height * 1.05;
               this.mFrameBGImg.x = this.mUserImage.x - (this.mFrameBGImg.width - this.mUserImage.width) / 2;
               this.mFrameBGImg.y = this.mUserImage.y - (this.mFrameBGImg.height - this.mUserImage.height) / 2;
            }
            this.mFrameContainer.addChild(this.mFrameBGImg);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:CardAnimation = null;
         if(this.mFrameBGImg)
         {
            this.mFrameBGImg.removeFromParent(true);
            this.mFrameBGImg = null;
         }
         if(this.mPortraitImg)
         {
            TweenMax.killTweensOf(this.mPortraitImg);
            this.mPortraitImg.removeFromParent(true);
            this.mPortraitImg = null;
         }
         if(this.mFrameContainer)
         {
            this.mFrameContainer.removeChildren();
            this.mFrameContainer.removeFromParent(true);
            this.mFrameContainer = null;
         }
         if(this.mNameFrame)
         {
            this.mNameFrame.removeChildren();
            this.mNameFrame.removeFromParent(true);
            this.mNameFrame = null;
         }
         if(this.mNameFrameImage)
         {
            this.mNameFrameImage.removeFromParent(true);
            this.mNameFrameImage = null;
         }
         if(this.mUserImage)
         {
            this.mUserImage.removeFromParent();
            this.mUserImage = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mPlayerHPViewer)
         {
            this.mPlayerHPViewer.removeFromParent(true);
            this.mPlayerHPViewer = null;
         }
         this.mUserData = null;
         this.mLevelDef = null;
         this.mUserBattleInfo = null;
         this.mHeroDef = null;
         if(this.mPlayerHPViewerCover)
         {
            this.mPlayerHPViewerCover.removeFromParent();
            this.mPlayerHPViewerCover.destroy();
            this.mPlayerHPViewerCover = null;
         }
         if(this.mRankInsigniaImage)
         {
            this.mRankInsigniaImage.removeFromParent(true);
            this.mRankInsigniaImage = null;
         }
         if(this.mInvulnerableImage)
         {
            this.mInvulnerableImage.removeFromParent(true);
            this.mInvulnerableImage = null;
         }
         if(this.mInvulnerableSprite)
         {
            this.mInvulnerableSprite.removeFromParent(true);
            this.mInvulnerableSprite = null;
         }
         if(this.mInvulnerableTextfield)
         {
            this.mInvulnerableTextfield.removeFromParent(true);
            this.mInvulnerableTextfield = null;
         }
         if(this.mCardAnimsAttached)
         {
            for each(_loc1_ in this.mCardAnimsAttached)
            {
               _loc1_.unload(true);
               _loc1_.removeFromParent();
            }
            Utils.destroyArray(this.mCardAnimsAttached);
            this.mCardAnimsAttached = null;
         }
         if(this.mPlayerMessageTextfield)
         {
            this.mPlayerMessageTextfield.removeFromParent(true);
            this.mPlayerMessageTextfield = null;
         }
         if(this.mPortraitBubbleMessage)
         {
            this.mPortraitBubbleMessage.removeFromParent();
            this.mPortraitBubbleMessage = null;
         }
         if(this.mItemTargetedAnim)
         {
            this.mItemTargetedAnim.removeFromParent(true);
            this.mItemTargetedAnim = null;
         }
         if(this.mGuildEmblem)
         {
            this.mGuildEmblem.removeFromParent(true);
            this.mGuildEmblem = null;
         }
         if(this.mCharacterImage)
         {
            this.mCharacterImage.removeFromParent();
            this.mCharacterImage.destroy();
            this.mCharacterImage = null;
         }
         this.mOriginalCharacterImageCoord = null;
         removeChildren(0,-1,true);
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         removeEventListener(EnterFrameEvent.ENTER_FRAME,this.onEnterFrame);
         super.dispose();
      }
      
      public function onAffinityTriggeredPlayEffects() : void
      {
         if(this.mPortraitBubbleMessage == null)
         {
            this.mPortraitBubbleMessage = InstanceMng.getTextParticlesMng().createTextParticleWithBG("nice_icon");
            this.mPortraitBubbleMessage.setText(TextManager.getText("TID_GEN_NICE"));
         }
         else
         {
            TweenMax.killTweensOf(this.mPortraitBubbleMessage);
            this.mPortraitBubbleMessage.alpha = 0.999;
            this.mPortraitBubbleMessage.scaleX = 1;
            this.mPortraitBubbleMessage.scaleY = 1;
         }
         this.mPortraitBubbleMessage.x = this.mNameTextfield.x;
         this.mPortraitBubbleMessage.y = this.mNameTextfield.y;
         addChild(this.mPortraitBubbleMessage);
         SpecialFX.createYoYoZoomTransition(this.mPortraitBubbleMessage,1.15,0.5,1,this.onAffinityEffectsPlayed);
      }
      
      private function onAffinityEffectsPlayed() : void
      {
         if(this.mPortraitBubbleMessage)
         {
            SpecialFX.tweenToAlpha(this.mPortraitBubbleMessage,0.001,1,0,this.onAffinityEffectFaded);
         }
      }
      
      private function onAffinityEffectFaded() : void
      {
         if(this.mPortraitBubbleMessage)
         {
            this.mPortraitBubbleMessage.removeFromParent();
         }
      }
      
      public function getUsefulWidth() : Number
      {
         var _loc1_:Number = this.mCharacterImage ? this.mCharacterImage.width * 1.05 : this.mFrameContainer.width * 1.05;
         if(!this.mHasSimpleUI)
         {
            _loc1_ *= 1.25;
         }
         return _loc1_;
      }
      
      public function getUsefulHeight() : Number
      {
         return this.mFrameBGImg.height * 1.5;
      }
      
      public function refreshSkin() : void
      {
         this.createCharacterImage();
      }
      
      public function getChatTextByIndex(param1:int) : String
      {
         switch(param1)
         {
            case ChatButton.CHAT_GOOD_LUCK:
               return TextManager.getText("TID_CHAT_MESSAGE_1");
            case ChatButton.CHAT_WELL_PLAYED:
               return TextManager.getText("TID_CHAT_MESSAGE_2");
            case ChatButton.CHAT_THANKS:
               return TextManager.getText("TID_CHAT_MESSAGE_3");
            case ChatButton.CHAT_GOOD_GAME:
               return TextManager.getText("TID_CHAT_MESSAGE_4");
            case ChatButton.CHAT_MY_BAD:
               return TextManager.getText("TID_CHAT_MESSAGE_5");
            case ChatButton.CHAT_WOW:
               return TextManager.getText("TID_CHAT_MESSAGE_6");
            default:
               return "";
         }
      }
   }
}

