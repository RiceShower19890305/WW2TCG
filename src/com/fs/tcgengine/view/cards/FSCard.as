package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.AbilitiesMng;
   import com.fs.tcgengine.controller.FSCardAnimsMng;
   import com.fs.tcgengine.controller.FSSoundFXMng;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.ScoreMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.SubCategoriesMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.battle.BattleEnginePvP;
   import com.fs.tcgengine.model.board.card.Ability;
   import com.fs.tcgengine.model.board.card.SpecialAbility;
   import com.fs.tcgengine.model.rules.AbilityDef;
   import com.fs.tcgengine.model.rules.ActionDef;
   import com.fs.tcgengine.model.rules.AttachmentDef;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.rules.PassiveAbilityDef;
   import com.fs.tcgengine.model.rules.PowerDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.SubCategoryDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.screens.FSDeckBuilderScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.anims.cards.BulletsAnim;
   import com.fs.tcgengine.view.anims.cards.CardAnimation;
   import com.fs.tcgengine.view.anims.cards.LightningAnimation;
   import com.fs.tcgengine.view.anims.cards.MovieClipZoomAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.AbilitiesPanel;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Expo;
   import com.greensock.easing.Sine;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.MovieClip;
   import starling.display.Sprite3D;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.extensions.ColorArgb;
   import starling.extensions.lighting.LightSource;
   import starling.extensions.lighting.LightStyle;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class FSCard extends Component implements FSModelUnloadableInterface
   {
      
      protected static var smBGIntersectionRect:flash.geom.Rectangle;
      
      protected static var smSocketIntersectionRect:flash.geom.Rectangle;
      
      public static const TYPE_UNIT:int = 0;
      
      public static const TYPE_ATTACHMENT:int = 1;
      
      public static const TYPE_ACTION:int = 2;
      
      public static const TYPE_POWER:int = 3;
      
      public static const TYPE_EVENT:int = 4;
      
      public static const DEFAULT_MOVE_ELEVATED_CARD_TIME:int = 0;
      
      public static const DEFAULT_ELEVATE_CARD_FOR_ATTACK_TIME:int = 1;
      
      public static const DEFAULT_DELAY_BEFORE_ATTACK_TIME:int = 2;
      
      public static const DEFAULT_SCALE_FACTOR_CARDS_ELEVATION:Number = 1.04;
      
      private static const MAX_ROTATION_RADS:Number = deg2rad(60);
      
      private static const ABS_LAYER_ATTACHED_ON_CARD:Boolean = true;
      
      protected const DAMAGE_IMG_NAME:String = "attack_card_icon";
      
      protected const DEFENSE_IMG_NAME:String = "defense_card_icon";
      
      protected const FRAME_SUMMON_ICON:String = "frame_summon_icon";
      
      protected const FRAME_SUMMON_ICON_XL:String = "frame_summon_icon_XL";
      
      protected const FRAME_SUMMON_ICON_COST_MODIFIED:String = "frame_summon_icon_cost_modified";
      
      private const DEGTORAD:Number = deg2rad(1);
      
      private var mId:int = -1;
      
      protected var mBG:FSImage;
      
      private var mBGLightStyle:LightStyle;
      
      private var mBGLight:LightSource;
      
      protected var mBGAnimated:MovieClip;
      
      protected var mFrameBG:CompositeFrame;
      
      protected var mFactionFrameBG:CompositeFrame;
      
      protected var mBottomFrameBG:FSImage;
      
      protected var mFrameSummonIcon:FSImage;
      
      protected var mSummonTextfield:FSTextfield;
      
      private var mAbilitiesAnimsLayer:Component;
      
      protected var mTierFrame:CompositeFrame;
      
      protected var mDefenseTextfield:FSTextfield;
      
      protected var mDamageTextfield:FSTextfield;
      
      protected var mDamageImage:FSImage;
      
      protected var mDefenseImage:FSImage;
      
      public var mAttachedToSocket:FSCardSocket;
      
      protected var mAbilities:Vector.<Ability>;
      
      public var mCardDef:CardDef;
      
      protected var mIsUnit:Boolean;
      
      protected var mZoomedIn:Boolean;
      
      protected var mBattleSceneParent:FSBattleScreen;
      
      private var mTier:int;
      
      protected var mDisableIntersections:Boolean;
      
      protected var mUpgradeCostTextfield:FSTextfield;
      
      protected var mIsMoving:Boolean;
      
      protected var mSummonCooldownTurnsLeft:int;
      
      protected var mIsOnBattlefield:Boolean;
      
      protected var mParentUserBattleInfo:UserBattleInfo;
      
      protected var mDefense:FSNumber;
      
      protected var mDamage:FSNumber;
      
      protected var mType:int;
      
      private var mBFId:int;
      
      private var mPlayableCardId:int;
      
      protected var mTurnsAlive:int;
      
      private var mCardAnimsAttached:Vector.<CardAnimation>;
      
      protected var mAbilitiesIcons:Dictionary;
      
      private var mPreviousTiersCardsDefs:Vector.<CardDef>;
      
      protected var mTempCardXL:FSCardXL;
      
      private var mIsAttacking:Boolean;
      
      protected var mFightingWithCard:FSCard;
      
      protected var mPlayableSockets:Vector.<FSCardSocket>;
      
      protected var mPlayableBFPortraits:Vector.<FSBattlefieldUserPortrait>;
      
      protected var mSummonCooldownImage:FSImage;
      
      private var mPlayableSocketsHighlighted:Boolean;
      
      protected var mIsInfoCard:Boolean = false;
      
      protected var mDieOnEndTurn:Boolean = false;
      
      protected var mCardPressedAndMoving:Boolean = false;
      
      private var mCardPressed:Boolean = false;
      
      protected var mShadow:FSCardShadow;
      
      private var mUpdateShadow:Boolean = false;
      
      private var mShadowTween:TweenMax;
      
      protected var mDefeated:Boolean = false;
      
      protected var mCardTouch:Touch;
      
      protected var mItemTargetedAnim:FSItemTargetedAnim;
      
      private var mIsCardBeingPromoted:Boolean;
      
      private var mSummonCost:int;
      
      protected var mBack:FSImage;
      
      protected var mSubComponentsContainer:Component;
      
      protected var mBattleComponents:Component;
      
      private var mHelperPoint3D:Vector3D = new Vector3D();
      
      private var mFusionIcon:FSImage;
      
      protected var mAnimAura:MovieClip;
      
      private var mDropShadow:Sprite3D;
      
      private var mIsRewardCard:Boolean = false;
      
      private var mFusionLayer:CardFusionLayer;
      
      private var mDeathAnimMC:MovieClip;
      
      private var mIsZoomingOut:Boolean;
      
      private var mEnhancedImage:FSImage;
      
      private var mEnhancedText:FSTextfield;
      
      protected var mIntersectionTopIndex:int;
      
      private var mChampionImage:FSImage;
      
      private var mLeaderImage:FSImage;
      
      protected var mOldSocketIndexCode:String;
      
      public var mCostModifiedByAbility:String;
      
      private var mPvPStoredEligibleItemCode:String;
      
      private var mPvPStoredAbilitySku:String;
      
      private var mFXDeltaMovementPoint:Point;
      
      private var mFXStartTouchPosX:Number;
      
      private var mFXStartTouchPosY:Number;
      
      private var mFXMouseTarget:Point;
      
      private var mFXMouseDown:Boolean = false;
      
      private var mFXCardX:Number;
      
      private var mFXCardY:Number;
      
      private var mFXOldCardX:Number;
      
      private var mFXOldCardY:Number;
      
      private var mFXTargetX:Number;
      
      private var mFXTargetY:Number;
      
      private var mFXRotX:Number;
      
      private var mFXRotY:Number;
      
      private var mFXTargetRotX:Number;
      
      private var mFXTargetRotY:Number;
      
      private var mFXStageWidth:Number;
      
      private var mFXStageHeight:Number;
      
      public function FSCard(param1:String)
      {
         super();
         this.reset(param1);
      }
      
      public function reset(param1:String = "") : void
      {
         if(Config.USE_CARD_POOLING)
         {
            Utils.resetComponent(this);
            rotationX = rotationY = rotationZ = 0;
            this.mId = -1;
            this.mCardDef = null;
            this.mIsUnit = false;
            this.mZoomedIn = this is FSCardXL;
            this.mTier = 0;
            this.mOldSocketIndexCode = "";
            this.mDisableIntersections = false;
            this.mIsMoving = false;
            this.mSummonCooldownTurnsLeft = 0;
            this.mIsOnBattlefield = false;
            if(this.mDefense)
            {
               this.mDefense.value = 0;
            }
            if(this.mDamage)
            {
               this.mDamage.value = 0;
            }
            this.mType = 0;
            this.mBFId = 0;
            this.mPlayableCardId = 0;
            this.mTurnsAlive = 0;
            this.mIsAttacking = false;
            this.mPlayableSocketsHighlighted = false;
            this.mIsInfoCard = false;
            this.mDieOnEndTurn = false;
            this.mCardPressedAndMoving = false;
            this.mCardPressed = false;
            this.mUpdateShadow = false;
            this.mDefeated = false;
            this.mIsCardBeingPromoted = false;
            this.mSummonCost = 0;
            this.mIsRewardCard = false;
            this.mIsZoomingOut = false;
            this.mIntersectionTopIndex = 0;
            this.mFXStartTouchPosX = 0;
            this.mFXStartTouchPosY = 0;
            if(this.mFXDeltaMovementPoint)
            {
               this.mFXDeltaMovementPoint.x = 0;
               this.mFXDeltaMovementPoint.y = 0;
            }
            if(this.mShadowTween)
            {
               this.mShadowTween.kill();
            }
            if(this.mCardTouch)
            {
               this.mCardTouch.globalX = 0;
               this.mCardTouch.globalY = 0;
            }
            if(this.mBG)
            {
               this.mBG.reset();
            }
            if(this.mFrameBG)
            {
               this.mFrameBG.reset();
            }
            if(this.mFactionFrameBG)
            {
               this.mFactionFrameBG.reset();
            }
            if(this.mBottomFrameBG)
            {
               this.mBottomFrameBG.reset();
            }
            if(this.mFrameSummonIcon)
            {
               this.mFrameSummonIcon.reset();
            }
            if(this.mSummonTextfield)
            {
               this.mSummonTextfield.setup();
            }
            if(this.mTierFrame)
            {
               this.mTierFrame.reset();
            }
            if(this.mBack)
            {
               this.mBack.reset();
            }
            if(this.mFusionIcon)
            {
               this.mFusionIcon.reset();
            }
            if(this.mEnhancedImage)
            {
               this.mEnhancedImage.reset();
            }
            if(this.mChampionImage)
            {
               this.mChampionImage.reset();
            }
            if(this.mLeaderImage)
            {
               this.mLeaderImage.reset();
            }
            if(this.mBGAnimated)
            {
               this.mBGAnimated.stop();
               this.mBGAnimated.removeFromParent();
            }
            if(this.mAnimAura)
            {
               this.mAnimAura.stop();
               this.mAnimAura.removeFromParent();
            }
            if(this.mDefenseTextfield)
            {
               this.mDefenseTextfield.setup();
            }
            if(this.mDamageTextfield)
            {
               this.mDamageTextfield.setup();
            }
            if(this.mUpgradeCostTextfield)
            {
               this.mUpgradeCostTextfield.setup();
            }
            if(this.mEnhancedText)
            {
               this.mEnhancedText.setup();
            }
            this.mAttachedToSocket = null;
            this.mBattleSceneParent = null;
            this.mParentUserBattleInfo = null;
            this.mTempCardXL = null;
            this.mFightingWithCard = null;
            if(this.mPreviousTiersCardsDefs)
            {
               this.mPreviousTiersCardsDefs.length = 0;
            }
            if(this.mPlayableSockets)
            {
               this.mPlayableSockets.length = 0;
            }
            if(this.mPlayableBFPortraits)
            {
               this.mPlayableBFPortraits.length = 0;
            }
            if(this.mAbilities)
            {
               this.mAbilities.length = 0;
            }
            if(this.mCardAnimsAttached)
            {
               this.mCardAnimsAttached.length = 0;
            }
            this.mAbilitiesIcons = null;
            this.setCostModifiedByAbility("");
         }
         useHandCursor = true;
         this.removeTouchEventListeners();
         if(param1 != "")
         {
            this.addEventListeners();
            this.setCardDef(CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1)));
            this.performExtraChecks();
         }
         alignPivot();
         this.mFXStageWidth = Starling.current.stage.stageWidth;
         this.mFXStageHeight = Starling.current.stage.stageHeight;
         this.mFXCardX = x;
         this.mFXCardY = y;
         this.mFXOldCardX = this.mFXCardX;
         this.mFXOldCardY = this.mFXCardY;
         this.mFXTargetX = this.mFXCardX;
         this.mFXTargetY = this.mFXCardY;
         this.mFXRotX = 0;
         this.mFXRotY = 0;
         this.mFXTargetRotX = 0;
         this.mFXTargetRotY = 0;
         this.mFXMouseDown = false;
         if(this.mFXMouseTarget == null)
         {
            this.mFXMouseTarget = new Point(this.mFXCardX,this.mFXCardY);
         }
         this.mFXMouseTarget.x = this.mFXCardX;
         this.mFXMouseTarget.y = this.mFXCardY;
      }
      
      protected function performExtraChecks() : void
      {
         this.initializeCard(this.mCardDef);
      }
      
      public function notifyResourceLoaded() : void
      {
      }
      
      public function addEventListeners() : void
      {
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function removeTouchEventListeners() : void
      {
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         this.handleCardMovement();
         if(Boolean(this.mFXMouseTarget) && this.mFXMouseDown)
         {
            this.handleDragEffect();
         }
         this.handleCardShadowProperties();
         this.updateCardBackVisibility();
         if(this.mIsMoving && this.mFXMouseDown)
         {
            this.performIntersectionTest(true);
         }
      }
      
      public function handleCardMovement(param1:Boolean = false, param2:Number = -1, param3:Number = -1) : void
      {
         if(param1)
         {
            if(this.mFXMouseTarget == null)
            {
               this.mFXMouseTarget = new Point();
            }
            this.mFXMouseTarget.x = param2;
            this.mFXMouseTarget.y = param3;
         }
         if(Boolean(this.mFXMouseTarget) && Boolean(this.mFXMouseDown) || param1)
         {
            if(this.mFXMouseTarget.x < 0)
            {
               this.mFXMouseTarget.x = 0;
            }
            if(this.mFXMouseTarget.x > this.mFXStageWidth)
            {
               this.mFXMouseTarget.x = this.mFXStageWidth;
            }
            if(this.mFXMouseTarget.y < 0)
            {
               this.mFXMouseTarget.y = 0;
            }
            if(this.mFXMouseTarget.y > this.mFXStageHeight)
            {
               this.mFXMouseTarget.y = this.mFXStageHeight;
            }
            TweenLite.to(this,0.2,{
               "x":this.mFXMouseTarget.x,
               "y":this.mFXMouseTarget.y
            });
         }
      }
      
      public function handleDragEffect(param1:Boolean = false, param2:Number = -1, param3:Number = -1) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc4_:Boolean = param1;
         var _loc5_:Boolean = param1;
         if(!param1)
         {
            _loc6_ = this is FSEvent || this.mBattleSceneParent != null && InstanceMng.getBattleEngine() && InstanceMng.getBattleEngine().getBattleStateId() != BattleEngine.BATTLE_STATE_DEALING_CARDS && !InstanceMng.getBattleEngine().isReshufflingHand();
            _loc7_ = InstanceMng.getCurrentScreen() is FSDeckBuilderScreen && FSDeckBuilderScreen(InstanceMng.getCurrentScreen()).getEdidionStatus() == FSDeckBuilderScreen.STATUS_EDITING;
            _loc8_ = Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isOnlineMatch();
            _loc9_ = (_loc8_) && this.isEnemyCard();
            _loc10_ = (_loc9_) && (this.mAttachedToSocket != null && !this.mAttachedToSocket.isBattlefieldSocket());
            _loc11_ = _loc8_ && _loc9_ && _loc10_;
            _loc12_ = this.isEnemyCard(true);
            _loc13_ = !_loc12_ || _loc12_ && !InstanceMng.getBattleEngine().isOnlineMatch();
            _loc4_ = _loc6_ || _loc7_;
            _loc5_ = !_loc11_ && _loc13_;
         }
         else
         {
            if(this.mFXMouseTarget == null)
            {
               this.mFXMouseTarget = new Point();
            }
            this.mFXMouseTarget.x = param2;
            this.mFXMouseTarget.y = param3;
         }
         if(this.mFXMouseTarget == null || !this.mFXMouseDown && !param1)
         {
            _loc4_ = false;
            _loc5_ = false;
         }
         if(_loc4_)
         {
            this.mFXTargetX = this.mFXMouseTarget.x - x;
            this.mFXTargetY = this.mFXMouseTarget.y - y;
            this.mFXCardX += this.mFXTargetX * 0.25;
            this.mFXCardY += this.mFXTargetY * 0.25;
            if(this.mFXCardX < 0)
            {
               this.mFXCardX = 0;
            }
            if(this.mFXCardX > this.mFXStageWidth)
            {
               this.mFXCardX = this.mFXStageWidth;
            }
            if(this.mFXCardY < 0)
            {
               this.mFXCardY = 0;
            }
            if(this.mFXCardY > this.mFXStageHeight)
            {
               this.mFXCardY = this.mFXStageHeight;
            }
            this.mFXTargetRotX = (this.mFXOldCardY - this.mFXCardY - this.mFXRotX) * 3;
            this.mFXTargetRotY = (this.mFXCardX - this.mFXOldCardX - this.mFXRotY) * 3;
            _loc14_ = param1 ? 45 : 30;
            this.mFXTargetRotX = Math.min(this.mFXTargetRotX,_loc14_);
            this.mFXTargetRotX = Math.max(this.mFXTargetRotX,-_loc14_);
            this.mFXTargetRotY = Math.min(this.mFXTargetRotY,_loc14_);
            this.mFXTargetRotY = Math.max(this.mFXTargetRotY,-_loc14_);
            _loc15_ = 0.05;
            _loc16_ = param1 ? 0.3 : 0.15;
            this.mFXRotX += int(this.mFXCardX) == int(this.mFXOldCardX) ? this.mFXTargetRotX * _loc15_ : this.mFXTargetRotX * _loc16_;
            this.mFXRotY += int(this.mFXCardY) == int(this.mFXOldCardY) ? this.mFXTargetRotY * _loc15_ : this.mFXTargetRotY * _loc16_;
            rotationX = -deg2rad(this.mFXRotX * 3.25);
            if(_loc5_ && this.mFXRotY != 0)
            {
               rotationY = -deg2rad(this.mFXRotY * 3.25);
            }
            this.mFXOldCardX = this.mFXCardX;
            this.mFXOldCardY = this.mFXCardY;
            if(Boolean(!ABS_LAYER_ATTACHED_ON_CARD) && Boolean(this.mAbilitiesAnimsLayer) && Boolean(this.mAbilitiesAnimsLayer.parent))
            {
               this.mAbilitiesAnimsLayer.parent.addChild(this.mAbilitiesAnimsLayer);
            }
         }
      }
      
      private function handleCardShadowProperties() : void
      {
         if(Boolean(this.mUpdateShadow) && Boolean(this.mShadow) && this.mShadow.visible)
         {
            this.mShadow.rotationX = rotationX;
            this.mShadow.rotationY = rotationY;
            this.mShadow.rotationZ = rotationZ;
            this.mShadow.scaleX = scaleX;
            this.mShadow.scaleY = scaleY;
            this.mShadow.x = x - this.mShadow.getOffsetToMoveX();
            this.mShadow.y = y + this.mShadow.getOffsetToMoveY();
         }
      }
      
      protected function initializeCard(param1:CardDef, param2:Boolean = false) : void
      {
         var _loc3_:AbilityDef = null;
         var _loc4_:BattleEngine = null;
         var _loc5_:Boolean = false;
         this.mCardDef = param2 ? param1 : this.mCardDef;
         if(this.mCardDef != null)
         {
            if(!param2)
            {
               this.setIsUnit(this.mCardDef is UnitDef);
               this.mIsOnBattlefield = false;
               this.mSummonCooldownTurnsLeft = this.isUnit() ? UnitDef(this.mCardDef).getSummonCooldown() : 0;
               if(this.mSubComponentsContainer == null)
               {
                  this.mSubComponentsContainer = new Component();
               }
               addChild(this.mSubComponentsContainer);
               this.createFactionFrameBG();
               this.createBGImage();
               this.createFrameBG();
               this.createFrameSummonIcon();
               this.createFusionIcon();
               this.createAbsAnimsLayer();
               this.setBFId(-1);
               this.setTurnsAlive(0);
               if(this.mCardDef.hasAura())
               {
                  this.createAuraAnim(true);
               }
            }
            _loc3_ = this.getCostModifierAbilityDef();
            this.mSummonCost = this.getCardCostByType(_loc3_);
            this.createSummonCostTextfield();
            this.mTier = this.mCardDef.getTier();
            this.setDefense(this.mCardDef.getDefense());
            this.setDamage(this.mCardDef.getDamage());
            this.addAbilities();
            _loc4_ = InstanceMng.getBattleEngine();
            _loc5_ = this.mType != TYPE_ACTION && this.mType != TYPE_POWER && (_loc4_ == null || _loc4_ != null && _loc4_.hasToShowUpgradeCost()) || InstanceMng.getCurrentScreen() is FSDeckBuilderScreen;
            if(_loc5_)
            {
               this.createTierFrame(param2);
               this.setSummonIconOnTop();
            }
            this.createCardInfoText();
            this.showDamageAndShield(param2);
            this.createAbilitiesIcons();
            this.createEnhanceImage();
            this.createChampionImage();
            this.createLeaderImage();
            if(!(InstanceMng.getCurrentScreen() is FSDeckBuilderScreen))
            {
               this.addCardBack();
            }
            if(Boolean(this.mBattleComponents) && Boolean(this.mSubComponentsContainer))
            {
               this.mSubComponentsContainer.addChild(this.mBattleComponents);
            }
         }
         if(param2 && Boolean(this.mBattleSceneParent))
         {
            this.mBattleSceneParent.suggestPlayableCardON();
         }
      }
      
      private function createEnhanceImage() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mCardDef) && this.mCardDef.getEnhanceLevel() > 0)
         {
            if(this.mEnhancedImage == null)
            {
               _loc1_ = this.isZoomedIn() ? "enhance_icon_XL" : "enhance_icon";
               this.mEnhancedImage = new FSImage(Root.assets.getTexture(_loc1_));
               this.mEnhancedImage.alignPivot();
               this.mEnhancedImage.x = this.mFrameBG ? this.mFrameBG.x + this.mFrameBG.width - this.mEnhancedImage.width / 2 : width - this.mEnhancedImage.width / 2;
               this.mEnhancedImage.y = this.mEnhancedImage.height / 2;
               if(this.mBattleComponents)
               {
                  this.mBattleComponents.addChild(this.mEnhancedImage);
               }
            }
            if(this.mEnhancedText == null)
            {
               this.mEnhancedText = new FSTextfield(this.mEnhancedImage.width * 0.85,this.mEnhancedImage.height * 0.85,this.mCardDef.getEnhanceLevel().toString());
            }
            else
            {
               this.mEnhancedText.text = this.mCardDef.getEnhanceLevel().toString();
            }
            this.mEnhancedText.fontSize = FSResourceMng.FONT_STD_BIG_TITLE_SIZE;
            this.mEnhancedText.alignPivot();
            this.mEnhancedText.x = this.mEnhancedImage.x + this.mEnhancedImage.width * 0.12;
            this.mEnhancedText.y = this.mEnhancedImage.y + this.mEnhancedImage.height * 0.04;
            if(this.mBattleComponents)
            {
               this.mBattleComponents.addChild(this.mEnhancedText);
            }
         }
         else
         {
            if(this.mEnhancedImage)
            {
               this.mEnhancedImage.removeFromParent();
            }
            if(this.mEnhancedText)
            {
               this.mEnhancedText.removeFromParent();
            }
         }
      }
      
      private function createChampionImage() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mCardDef) && this.mCardDef.isChampion())
         {
            if(this.mChampionImage == null)
            {
               _loc1_ = this.isZoomedIn() ? "champion_icon_XL" : "champion_icon";
               this.mChampionImage = new FSImage(Root.assets.getTexture(_loc1_));
               this.mChampionImage.alignPivot();
               this.mChampionImage.x = this.mFrameBG ? this.mFrameBG.x + this.mFrameBG.width - this.mChampionImage.width / 2 : width - this.mChampionImage.width / 2;
               this.mChampionImage.y = this.mChampionImage.height / 2;
               if(this.mBattleComponents)
               {
                  this.mBattleComponents.addChild(this.mChampionImage);
               }
            }
         }
         else if(this.mChampionImage)
         {
            this.mChampionImage.removeFromParent();
         }
      }
      
      private function createLeaderImage() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mCardDef) && Boolean(this.mCardDef is UnitDef) && UnitDef(this.mCardDef).isLeader())
         {
            if(this.mLeaderImage == null)
            {
               _loc1_ = UnitDef(this.mCardDef).getLeaderIcon();
               this.mLeaderImage = new FSImage(Root.assets.getTexture(_loc1_));
               this.mLeaderImage.scale = this.isZoomedIn() ? 1.25 : 0.75;
               this.mLeaderImage.alignPivot();
               this.mLeaderImage.x = this.mFrameBG ? this.mFrameBG.x + this.mFrameBG.width - this.mLeaderImage.width / 2 : width - this.mLeaderImage.width / 2;
               this.mLeaderImage.y = this.mLeaderImage.height / 2;
               if(this.mBattleComponents)
               {
                  this.mBattleComponents.addChild(this.mLeaderImage);
               }
            }
         }
         else if(this.mLeaderImage)
         {
            this.mLeaderImage.removeFromParent();
         }
      }
      
      protected function createFusionIcon() : void
      {
         if(this.mFusionIcon == null)
         {
            if(this.mCardDef.isFusion())
            {
               this.mFusionIcon = new FSImage(Root.assets.getTexture("upgrade_icon"));
               addChild(this.mFusionIcon);
            }
         }
         else if(!this.mCardDef.isFusion())
         {
            this.mFusionIcon.removeFromParent();
         }
      }
      
      public function addCardBack() : void
      {
         var _loc1_:FactionDef = null;
         if(!(this is FSCardXL))
         {
            _loc1_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(this.mCardDef.getFactionSku()));
            if(_loc1_ != null)
            {
               if(this.mBack == null)
               {
                  this.mBack = new FSImage(Root.assets.getTexture(_loc1_.getBackBGName()));
               }
               else
               {
                  this.mBack.texture = Root.assets.getTexture(_loc1_.getBackBGName());
               }
            }
            this.mBack.x = this.mBack.width;
            this.mBack.y = 0;
            this.mBack.scaleX = -1;
            this.mBack.visible = true;
            addChild(this.mBack);
            this.updateCardBackVisibility();
         }
      }
      
      public function updateCardBackVisibility() : void
      {
         if(this.mBack)
         {
            if(stage)
            {
               if(this.mHelperPoint3D == null)
               {
                  this.mHelperPoint3D = new Vector3D();
               }
               stage.getCameraPosition(this,this.mHelperPoint3D);
               if(this.mHelperPoint3D)
               {
                  this.mSubComponentsContainer.visible = this.mHelperPoint3D.z < 0;
                  this.mBack.visible = this.mHelperPoint3D.z >= 0;
                  if(this.isOnBF())
                  {
                     if(Config.getConfig().getCardBGType() == "png")
                     {
                        this.mBack.visible = false;
                     }
                  }
               }
            }
         }
      }
      
      protected function createSummonCostTextfield() : void
      {
         var _loc1_:AbilityDef = null;
         if(Boolean(Config.getConfig().getShowSummonCost()) && Boolean(this.mFrameSummonIcon) && this.mCardDef.getIsVisible())
         {
            if(this.canShowSummonCost())
            {
               if(this.mSummonTextfield == null)
               {
                  this.mSummonTextfield = new FSTextfield(1,1,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
               }
               this.mSummonTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
               this.mSummonTextfield.touchable = false;
               this.mSummonTextfield.width = this.mFrameSummonIcon.width;
               this.mSummonTextfield.height = this.mFrameSummonIcon.height;
               this.mSummonTextfield.alignPivot();
               this.mSummonTextfield.x = this.mFrameSummonIcon.x + this.mFrameSummonIcon.width / 2;
               this.mSummonTextfield.y = this.mFrameSummonIcon.y + this.mFrameSummonIcon.height / 2;
               _loc1_ = this.getCostModifierAbilityDef();
               this.mSummonTextfield.text = String(this.getCardCostByType(_loc1_));
               this.formatSummonCostTextfield();
               this.formatSummonIconTexture();
               this.mSubComponentsContainer.addChild(this.mSummonTextfield);
            }
         }
      }
      
      private function getOriginalSummonCost(param1:Ability = null) : int
      {
         var _loc3_:Array = null;
         var _loc4_:ActionDef = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         switch(this.getType())
         {
            case TYPE_UNIT:
               _loc2_ = this.getCardDef().getSummonCost();
               break;
            case TYPE_ATTACHMENT:
               _loc3_ = AttachmentDef(this.mCardDef).getAttachmentCost();
               _loc2_ = int(_loc3_[0]);
               break;
            case FSCard.TYPE_ACTION:
               _loc4_ = this.getCardDef() is ActionDef ? this.getCardDef() as ActionDef : null;
               if(_loc4_ != null)
               {
                  _loc5_ = _loc4_.getUpgradeCosts();
                  _loc6_ = _loc4_.getAbilities();
                  if(_loc5_ != null && _loc6_ != null)
                  {
                     if(param1 != null)
                     {
                        _loc7_ = 0;
                        while(_loc7_ < _loc6_.length)
                        {
                           if(_loc6_[_loc7_] == param1.getAbilityDef().getSku())
                           {
                              return _loc5_.length > _loc7_ ? int(_loc5_[_loc7_]) : 0;
                           }
                           _loc7_++;
                        }
                     }
                     else
                     {
                        _loc2_ = int(_loc5_[0]);
                     }
                  }
                  else
                  {
                     _loc2_ = 0;
                  }
               }
               else
               {
                  _loc2_ = 0;
               }
               break;
            default:
               _loc2_ = this.getCardDef().getSummonCost();
         }
         return _loc2_;
      }
      
      public function getCardCostByType(param1:AbilityDef = null, param2:Ability = null) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:UserBattleInfo = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc3_ = this.getOriginalSummonCost(param2);
         if(InstanceMng.getBattleEngine())
         {
            _loc4_ = InstanceMng.getBattleEngine().isOwnerTurn();
            _loc5_ = _loc4_ ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
            _loc6_ = false;
            if(_loc5_)
            {
               _loc7_ = _loc5_.getExtraSummonCostTurns();
               if(!_loc6_ && (_loc7_ > 0 || _loc7_ == -1 || _loc7_ == -2))
               {
                  if(Boolean(param1) && param1.isCardEligibleForAbility(this))
                  {
                     _loc3_ = _loc3_ + _loc5_.getExtraSummonCost() >= 0 ? int(_loc3_ + _loc5_.getExtraSummonCost()) : 0;
                     _loc6_ = true;
                     this.setCostModifiedByAbility(AbilitiesMng.SPECIAL_MODIFYCOST);
                  }
               }
               _loc8_ = _loc5_.getTurnsFixedSummonCost();
               if(_loc8_ > 0 || _loc8_ == -1 || _loc8_ == -2)
               {
                  if(Boolean(param1) && param1.isCardEligibleForAbility(this))
                  {
                     _loc3_ = _loc5_.getFixedSummonCost() >= 0 ? _loc5_.getFixedSummonCost() : 0;
                     _loc6_ = true;
                     this.setCostModifiedByAbility(AbilitiesMng.SPECIAL_FIXEDCOST);
                  }
               }
            }
            if(!_loc6_)
            {
               this.setCostModifiedByAbility("");
            }
            this.mSummonCost = _loc3_;
         }
         return _loc3_;
      }
      
      protected function canShowSummonCost() : Boolean
      {
         return (this.mBG != null || this.mBGAnimated != null) && (this.getType() != TYPE_ACTION || this.getType() == TYPE_ACTION && Config.getConfig().cardShowSummonCostOnActions());
      }
      
      protected function createFrameSummonIcon() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:String = null;
         if(this.mCardDef.getIsVisible())
         {
            if(this.canShowSummonCost())
            {
               _loc1_ = Root.assets.getTexture(this.FRAME_SUMMON_ICON);
               if(_loc1_ == null)
               {
                  FSDebug.debugTrace("TEXTURE NOT FOUND");
               }
               if(this.mFrameSummonIcon == null)
               {
                  this.mFrameSummonIcon = new FSImage(_loc1_,false);
               }
               else
               {
                  this.mFrameSummonIcon.texture = _loc1_;
               }
               if(this.getType() == TYPE_POWER && Boolean(this.mBGAnimated))
               {
                  _loc2_ = Config.getConfig().cardPowerSummonCostPosition();
                  if(_loc2_ != "left")
                  {
                     this.mFrameSummonIcon.x = this.mBGAnimated.width / 2 - this.mFrameSummonIcon.width / 4;
                     this.mFrameSummonIcon.y = this.mBGAnimated.height + this.mFrameSummonIcon.height / 2;
                  }
               }
               if(!this.mSubComponentsContainer.contains(this.mFrameSummonIcon))
               {
                  this.mSubComponentsContainer.addChild(this.mFrameSummonIcon);
               }
            }
         }
      }
      
      private function formatSummonIconTexture() : void
      {
         var _loc1_:int = 0;
         if(this.mFrameSummonIcon)
         {
            _loc1_ = this.getOriginalSummonCost();
            if(this.mSummonTextfield == null)
            {
               this.mFrameSummonIcon.texture = this.mSummonCost > _loc1_ ? Root.assets.getTexture(this.FRAME_SUMMON_ICON_COST_MODIFIED) : Root.assets.getTexture(this.FRAME_SUMMON_ICON);
            }
            else
            {
               this.mFrameSummonIcon.texture = this.mSummonCost != _loc1_ ? Root.assets.getTexture(this.FRAME_SUMMON_ICON_COST_MODIFIED) : Root.assets.getTexture(this.FRAME_SUMMON_ICON);
            }
         }
      }
      
      private function setSummonIconOnTop() : void
      {
         if(Config.getConfig().getShowSummonCost())
         {
            if(Boolean(this.mFrameSummonIcon) && Boolean(this.mSummonTextfield))
            {
               this.mSubComponentsContainer.addChild(this.mFrameSummonIcon);
               this.mSubComponentsContainer.addChild(this.mSummonTextfield);
            }
            else
            {
               this.createFrameSummonIcon();
               this.createSummonCostTextfield();
            }
         }
      }
      
      protected function createAbsAnimsLayer() : void
      {
         if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            if(this.mAbilitiesAnimsLayer == null)
            {
               this.mAbilitiesAnimsLayer = new Component();
            }
            this.setAbilitiesLayerOnTop();
         }
      }
      
      public function setAbilitiesLayerOnTop() : void
      {
         if(this.mAbilitiesAnimsLayer)
         {
            if(ABS_LAYER_ATTACHED_ON_CARD)
            {
               if(this.hasAnimatedBG())
               {
                  if(this.mBGAnimated)
                  {
                     this.mAbilitiesAnimsLayer.x = this.mBGAnimated.x;
                     this.mAbilitiesAnimsLayer.y = this.mBGAnimated.y;
                  }
               }
               else if(this.mBG != null)
               {
                  this.mAbilitiesAnimsLayer.x = this.mBG.x;
                  this.mAbilitiesAnimsLayer.y = this.mBG.y;
               }
               this.mSubComponentsContainer.addChild(this.mAbilitiesAnimsLayer);
            }
            else
            {
               if(this.hasAnimatedBG() && Boolean(this.mBGAnimated))
               {
                  this.mAbilitiesAnimsLayer.x = x + this.mBGAnimated.x - this.mBGAnimated.width / 2;
                  this.mAbilitiesAnimsLayer.y = y + this.mBGAnimated.y - this.mBGAnimated.height / 2;
               }
               else if(this.mBG != null)
               {
                  this.mAbilitiesAnimsLayer.x = x + this.mBG.x - this.mBG.width / 2;
                  this.mAbilitiesAnimsLayer.y = y + this.mBG.y - this.mBG.height / 2;
               }
               InstanceMng.getCurrentScreen().addChild(this.mAbilitiesAnimsLayer);
            }
         }
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         if(!ABS_LAYER_ATTACHED_ON_CARD)
         {
            if(this.mAbilitiesAnimsLayer)
            {
               if(this.hasAnimatedBG() && Boolean(this.mBGAnimated))
               {
                  this.mAbilitiesAnimsLayer.x = x + this.mBGAnimated.x - this.mBGAnimated.width / 2;
               }
               else if(this.mBG != null)
               {
                  this.mAbilitiesAnimsLayer.x = x + this.mBG.x - this.mBG.width / 2;
               }
            }
         }
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         if(!ABS_LAYER_ATTACHED_ON_CARD)
         {
            if(this.mAbilitiesAnimsLayer)
            {
               if(this.hasAnimatedBG() && Boolean(this.mBGAnimated))
               {
                  this.mAbilitiesAnimsLayer.y = y + this.mBGAnimated.y - this.mBGAnimated.height / 2;
               }
               else if(this.mBG != null)
               {
                  this.mAbilitiesAnimsLayer.y = y + this.mBG.y - this.mBG.height / 2;
               }
            }
         }
      }
      
      public function refreshUnitStatsAfterAttachment(param1:Boolean = true) : void
      {
         this.showDamageAndShield(true);
         this.removeAbilityIcons();
         this.createAbilitiesIcons();
      }
      
      public function showDamageAndShield(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mCardDef != null && this.mType != TYPE_ACTION && this.mType != TYPE_POWER)
         {
            if(this.mDamageTextfield == null)
            {
               this.mDamageTextfield = new FSTextfield(1,1,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            }
            if(this.mCardDef.isFusion())
            {
               this.mDamageTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN);
            }
            else
            {
               this.mDamageTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            }
            this.mDamageTextfield.touchable = false;
            if(this.mDefenseTextfield == null)
            {
               this.mDefenseTextfield = new FSTextfield(1,1,"",16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            }
            if(this.mCardDef.isFusion())
            {
               this.mDefenseTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN);
            }
            else
            {
               this.mDefenseTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            }
            this.mDefenseTextfield.touchable = false;
            if(this.mDamageImage == null)
            {
               this.mDamageImage = new FSImage(Root.assets.getTexture(this.DAMAGE_IMG_NAME));
            }
            this.mDamageImage.scaleX = 0.75;
            this.mDamageImage.scaleY = 0.75;
            this.mDamageImage.touchable = false;
            if(this.mDefenseImage == null)
            {
               this.mDefenseImage = new FSImage(Root.assets.getTexture(this.DEFENSE_IMG_NAME));
            }
            this.mDefenseImage.scaleX = 0.75;
            this.mDefenseImage.scaleY = 0.75;
            this.mDefenseImage.touchable = false;
            if(!param1)
            {
               this.setDamageDefenseTextfieldPosAndSize();
            }
            if(!this.mCardDef.isFusion())
            {
               this.getColorForDamageAndDefenseTextfield();
            }
            _loc2_ = this.getDamage();
            _loc3_ = this.getDefense();
            _loc2_ = _loc2_ >= 0 ? _loc2_ : 0;
            _loc3_ = _loc3_ >= 0 ? _loc3_ : 0;
            this.createBattleContainer();
            if(this.mBattleComponents)
            {
               this.mBattleComponents.addChild(this.mDamageImage);
               this.mBattleComponents.addChild(this.mDefenseImage);
               this.mBattleComponents.addChild(this.mDamageTextfield);
               this.mBattleComponents.addChild(this.mDefenseTextfield);
            }
            if(param1)
            {
               if(this.mDamageTextfield)
               {
                  SpecialFX.createTextfieldAmountTransition(this.mDamageTextfield,_loc2_,0.5,_loc2_ > int(this.mDamageTextfield.text));
               }
               if(this.mDefenseTextfield)
               {
                  SpecialFX.createTextfieldAmountTransition(this.mDefenseTextfield,_loc3_,0.5,_loc3_ > int(this.mDefenseTextfield.text));
               }
            }
            else
            {
               if(this.mDamageTextfield)
               {
                  this.mDamageTextfield.text = _loc2_.toString();
               }
               if(this.mDefenseTextfield)
               {
                  this.mDefenseTextfield.text = _loc3_.toString();
               }
               this.setDefenseTextfieldsAlpha(1);
            }
            this.checkSummonCooldownFilter();
         }
         else
         {
            if(this.mDamageTextfield)
            {
               this.mDamageTextfield.removeFromParent();
            }
            if(this.mDefenseTextfield)
            {
               this.mDefenseTextfield.removeFromParent();
            }
            if(this.mDefenseImage)
            {
               this.mDefenseImage.removeFromParent();
            }
            if(this.mDamageImage)
            {
               this.mDamageImage.removeFromParent();
            }
         }
      }
      
      protected function createBattleContainer() : void
      {
         if(this.mBattleComponents == null && Boolean(this.mSubComponentsContainer))
         {
            this.mBattleComponents = new Component();
            this.mSubComponentsContainer.addChild(this.mBattleComponents);
            this.mBattleComponents.z = -5;
            this.mSubComponentsContainer.addChild(this.mBattleComponents);
         }
      }
      
      private function setDefenseTextfieldsAlpha(param1:Number) : void
      {
         this.mDamageTextfield.alpha = param1;
         this.mDefenseTextfield.alpha = param1;
      }
      
      protected function setDamageDefenseTextfieldPosAndSize() : void
      {
         var _loc1_:Number = Utils.isIphone() ? 0.8 * Layout.getFontMultiplier() : Layout.getFontMultiplier();
         var _loc2_:Number = Config.getConfig().getCardStatsSizeFactor();
         _loc1_ *= this is FSCardXL || this is FSCardPreview ? _loc2_ : 1;
         if(this.mDamageTextfield)
         {
            if(this.mDamageImage)
            {
               this.mDamageTextfield.width = this.mDamageImage.width * _loc1_;
               this.mDamageTextfield.height = this.mDamageImage.height * _loc1_;
               this.mDamageImage.width = this.mDamageTextfield.width;
               this.mDamageImage.height = this.mDamageTextfield.height;
               this.mDamageTextfield.alignPivot();
               if(this.mFrameBG)
               {
                  this.mDamageImage.x = this.mFrameBG.x;
                  this.mDamageImage.y = this.mFrameBG.y + this.mFrameBG.height - this.mDamageImage.height;
               }
               this.mDamageTextfield.x = this.mDamageImage.x + this.mDamageImage.width / 2;
               this.mDamageTextfield.y = this.mDamageImage.y + this.mDamageImage.height / 2;
            }
         }
         if(this.mDefenseTextfield)
         {
            if(this.mDefenseImage)
            {
               this.mDefenseTextfield.width = this.mDefenseImage.width * _loc1_;
               this.mDefenseTextfield.height = this.mDefenseImage.height * _loc1_;
               this.mDefenseImage.width = this.mDefenseTextfield.width;
               this.mDefenseImage.height = this.mDefenseTextfield.height;
               this.mDefenseTextfield.alignPivot();
               if(this.mFrameBG)
               {
                  this.mDefenseImage.x = this.mFrameBG.x + this.mFrameBG.width - this.mDefenseImage.width;
                  this.mDefenseImage.y = this.mFrameBG.y + this.mFrameBG.height - this.mDefenseImage.height;
               }
               this.mDefenseTextfield.x = this.mDefenseImage.x + this.mDefenseImage.width / 2;
               this.mDefenseTextfield.y = this.mDefenseImage.y + this.mDefenseImage.height / 2;
            }
         }
      }
      
      public function addAbilities() : void
      {
         var _loc1_:Ability = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:AbilityDef = null;
         if(this.mCardDef != null)
         {
            _loc2_ = this.mCardDef.getAbilities();
            if(_loc2_ != null)
            {
               if(this.mAbilities == null)
               {
                  this.mAbilities = new Vector.<Ability>();
               }
               else
               {
                  this.mAbilities.length = 0;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc2_[_loc3_]));
                  this.addAbility(_loc4_);
                  _loc3_++;
               }
            }
            else if(this.mAbilities)
            {
               this.mAbilities.length = 0;
               this.mAbilities = null;
            }
         }
         else if(this.mAbilities)
         {
            this.mAbilities.length = 0;
            this.mAbilities = null;
         }
      }
      
      public function addAbility(param1:AbilityDef) : Boolean
      {
         var _loc3_:AbilityDef = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Ability = null;
         var _loc7_:Boolean = false;
         var _loc2_:Boolean = false;
         if(this.mAbilities == null)
         {
            this.mAbilities = new Vector.<Ability>();
         }
         if(param1)
         {
            _loc5_ = 0;
            _loc7_ = this.checkIfAbilityIsAvailable(param1,this.mAbilities);
            if(!_loc7_)
            {
               if(param1.isParentAbility())
               {
                  _loc4_ = param1.getChildAbs();
                  if((Boolean(_loc4_)) && Boolean(_loc4_.length))
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc4_.length)
                     {
                        _loc3_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc4_[_loc5_]));
                        _loc6_ = _loc3_.isSpecial() ? new SpecialAbility(_loc3_,this) : new Ability(_loc3_,this);
                        _loc6_.setParentAbilityRef(param1);
                        this.mAbilities.push(_loc6_);
                        _loc2_ = true;
                        _loc5_++;
                     }
                  }
               }
               else
               {
                  _loc6_ = param1.isSpecial() ? new SpecialAbility(param1,this) : new Ability(param1,this);
                  this.mAbilities.push(_loc6_);
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      protected function createCardInfoText() : void
      {
         var _loc1_:Boolean = true;
         if(this.mIsUnit)
         {
            _loc1_ = this.mZoomedIn;
         }
         this.showUpgradeCost();
         this.createTitle();
      }
      
      protected function showUpgradeCost(param1:int = -1) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:LevelDef = null;
         var _loc11_:UserData = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         var _loc3_:Boolean = _loc2_ == null || _loc2_ != null && _loc2_.hasToShowUpgradeCost() || InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSDeckBuilderScreen;
         if(_loc3_)
         {
            _loc5_ = this.mFrameBG ? int(this.mFrameBG.width) : int(width);
            if(this is FSCardXL)
            {
               _loc4_ = this.mFrameBG ? int(this.mFrameBG.height * 0.15) : int(height * 0.15);
            }
            else
            {
               _loc4_ = this.mFrameBG ? int(this.mFrameBG.height * 0.18) : int(height * 0.18);
            }
            if(this.mUpgradeCostTextfield == null)
            {
               this.mUpgradeCostTextfield = new FSTextfield(_loc5_,_loc4_);
            }
            this.mUpgradeCostTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mUpgradeCostTextfield.format.horizontalAlign = Align.CENTER;
            this.mUpgradeCostTextfield.format.verticalAlign = Align.CENTER;
            this.mUpgradeCostTextfield.width = _loc5_;
            this.mUpgradeCostTextfield.height = _loc4_;
            _loc6_ = Utils.isIOS() && !Utils.isIphone() ? 21 : 18;
            _loc7_ = this is FSCardXL ? 2 : 1;
            this.mUpgradeCostTextfield.fontSize = _loc6_ * _loc7_ * Layout.getFontMultiplier();
            this.mUpgradeCostTextfield.touchable = true;
            if(Config.getConfig().gameHasEmblems() && (Boolean(this.mCardDef) && Boolean(this.mCardDef is UnitDef)))
            {
               _loc8_ = UnitDef(this.mCardDef).getEmblemRequiredToPromote();
            }
            else if(this.mCardDef)
            {
               _loc8_ = param1 != -1 ? param1 : this.mCardDef.getUpgradeCost();
            }
            _loc9_ = _loc8_ == 0 || _loc8_ == -1 ? "" : _loc8_.toString();
            this.mUpgradeCostTextfield.text = _loc9_;
            this.mUpgradeCostTextfield.x = this.mFrameBG ? this.mFrameBG.x + 1.25 : 1.25;
            this.mUpgradeCostTextfield.y = this.mFrameBG ? this.mFrameBG.y + this.mFrameBG.height - this.mUpgradeCostTextfield.height : height - this.mUpgradeCostTextfield.height;
            if(this.mSubComponentsContainer)
            {
               this.mSubComponentsContainer.addChild(this.mUpgradeCostTextfield);
            }
            _loc10_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getLevelDef() : null;
            _loc11_ = Utils.getOwnerUserData();
            _loc12_ = _loc11_ ? _loc11_.getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            _loc13_ = _loc12_ == UserDataMng.DIFFICULTY_EASY && Boolean(_loc10_) ? _loc10_.getLevelIndex() < 10 : false;
            if((_loc13_) && this.mUpgradeCostTextfield.text != "")
            {
               this.mUpgradeCostTextfield.setTooltipText(TextManager.getText("TID_TUTORIAL_PROMOTE_COST"));
            }
         }
      }
      
      protected function createTitle() : void
      {
      }
      
      protected function createBGImage(param1:int = 0) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Texture> = null;
         if(this.mCardDef)
         {
            if(!this.mCardDef.hasAnimatedBG())
            {
               _loc2_ = this.mCardDef.getBGImageName();
               if(Root.assets.getTexture(_loc2_))
               {
                  this.setBG(_loc2_);
                  if(this.mBG)
                  {
                     this.mBG.x = this.mFactionFrameBG ? (this.mFactionFrameBG.width - this.mBG.width) / 2 : 0;
                     this.mBG.y = this.mFactionFrameBG ? (this.mFactionFrameBG.height - this.mBG.height) / 2 : 0;
                  }
                  if(Config.getConfig().cardBGOverlapsFrame())
                  {
                     this.createBattleContainer();
                     if(this.mBattleComponents)
                     {
                        this.mBattleComponents.addChild(this.mBG);
                     }
                  }
                  else if(this.mSubComponentsContainer)
                  {
                     this.mSubComponentsContainer.addChild(this.mBG);
                  }
               }
               else if(param1 < 3)
               {
                  TweenMax.delayedCall(0.1,this.createBGImage,[param1 + 1]);
               }
            }
            else if(this.mCardDef)
            {
               _loc3_ = this.mCardDef.getAnimatedBG();
               _loc4_ = this.mCardDef.getAnimatedBGFPS();
               _loc5_ = Root.assets.getTextures(_loc3_ + "_");
               if((Boolean(_loc5_)) && _loc5_.length > 0)
               {
                  this.mBGAnimated = new MovieClip(_loc5_,_loc4_);
                  this.mBGAnimated.x = this.mFactionFrameBG ? (this.mFactionFrameBG.width - this.mBGAnimated.width) / 2 : 0;
                  this.mBGAnimated.y = this.mFactionFrameBG ? (this.mFactionFrameBG.height - this.mBGAnimated.height) / 2 : 0;
                  Starling.juggler.add(this.mBGAnimated);
                  this.mBGAnimated.play();
                  if(Config.getConfig().cardBGOverlapsFrame())
                  {
                     this.createBattleContainer();
                     if(this.mBattleComponents)
                     {
                        this.mBattleComponents.addChild(this.mBGAnimated);
                     }
                  }
                  else if(this.mSubComponentsContainer)
                  {
                     this.mSubComponentsContainer.addChild(this.mBGAnimated);
                  }
               }
               else if(param1 < 3)
               {
                  TweenMax.delayedCall(0.1,this.createBGImage,[param1 + 1]);
               }
            }
            if(Boolean(this.mBG) || Boolean(this.mBGAnimated))
            {
               if(Config.getConfig().cardFrameOverlapsBG())
               {
                  if(Boolean(this.mFactionFrameBG) && Boolean(this.mSubComponentsContainer))
                  {
                     this.mSubComponentsContainer.addChild(this.mFactionFrameBG);
                  }
                  if(Boolean(this.mBottomFrameBG) && Boolean(this.mSubComponentsContainer))
                  {
                     this.mSubComponentsContainer.addChild(this.mBottomFrameBG);
                  }
               }
            }
         }
      }
      
      public function createAbilitiesIcons(param1:int = 0) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:AbilityDef = null;
         var _loc5_:Ability = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         if(this.mCardDef != null)
         {
            _loc2_ = this.mCardDef.getAbilities();
            if(_loc2_ != null)
            {
               _loc6_ = 0;
               _loc7_ = this is FSAttachment;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc2_[_loc3_]));
                  if(this.isAbilityConditionalAndWasTriggered(_loc4_))
                  {
                     _loc4_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc4_.getUnlockAbilitySku()));
                  }
                  if(_loc4_.isIconVisible() && this.isAllowedToCreateAbilityIcon(_loc4_))
                  {
                     _loc8_ = InstanceMng.getCardsMng().createAbilityIcon(this,_loc4_,param1,_loc7_);
                     param1 += _loc8_ ? 1 : 0;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function isAbilityConditional(param1:AbilityDef) : Boolean
      {
         return param1 != null && param1.getKeyName() == AbilitiesMng.SPECIAL_CONDITIONAL;
      }
      
      private function isAbilityConditionalAndWasTriggered(param1:AbilityDef) : Boolean
      {
         return this.isAbilityConditional(param1) && this.getAbilityByAbSku(param1.getSku(),true) == null;
      }
      
      public function getLastAbilityIconCount() : int
      {
         var _loc3_:AbilityDef = null;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Vector.<Ability> = this.getAbilities();
         if(_loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_].getAbilityDef();
               if(_loc3_.isIconVisible() && this.isAllowedToCreateAbilityIcon(_loc3_))
               {
                  _loc1_++;
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      protected function isAllowedToCreateAbilityIcon(param1:AbilityDef) : Boolean
      {
         return this.checkIfAbilityIsAvailable(param1,this.mAbilities);
      }
      
      protected function checkIfAbilityIsAvailable(param1:AbilityDef, param2:Vector.<Ability>) : Boolean
      {
         var _loc3_:AbilityDef = null;
         var _loc4_:Array = null;
         var _loc5_:AbilityDef = null;
         var _loc6_:int = 0;
         var _loc7_:AbilityDef = null;
         var _loc8_:int = 0;
         if(param2)
         {
            _loc6_ = 0;
            while(_loc6_ < param2.length)
            {
               _loc3_ = param2[_loc6_].getAbilityDef();
               if(_loc3_)
               {
                  if(_loc3_.getSku() == param1.getSku())
                  {
                     return true;
                  }
                  if(_loc3_.isParentAbility())
                  {
                     _loc4_ = _loc3_.getChildAbs();
                     if((Boolean(_loc4_)) && _loc4_.length > 0)
                     {
                        _loc8_ = 0;
                        while(_loc8_ < _loc4_.length)
                        {
                           _loc5_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc4_[_loc8_]));
                           if(_loc5_.getSku() == param1.getSku())
                           {
                              return true;
                           }
                           _loc8_++;
                        }
                     }
                  }
                  else
                  {
                     _loc7_ = param2[_loc6_].getParentAbilityRef();
                     if(_loc7_ != null)
                     {
                        if(_loc7_.getSku() == param1.getSku())
                        {
                           return true;
                        }
                     }
                  }
               }
               _loc6_++;
            }
         }
         return false;
      }
      
      public function getSubcomponentsContainer() : Component
      {
         if(this.mSubComponentsContainer == null)
         {
            this.mSubComponentsContainer = new Component();
         }
         return this.mSubComponentsContainer;
      }
      
      public function getBattleSubcomponentsContainer() : Component
      {
         if(this.mBattleComponents == null)
         {
            this.createBattleContainer();
         }
         return this.mBattleComponents;
      }
      
      public function createFrameBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         if(this.mBG != null || this.mBGAnimated != null)
         {
            _loc1_ = this.mCardDef.getFrameRarityBGName();
            if(this.mFrameBG == null)
            {
               this.mFrameBG = new CompositeFrame(_loc1_);
            }
            else
            {
               this.mFrameBG.updateTexture(_loc1_);
            }
            if(this.mFactionFrameBG)
            {
               this.mFrameBG.scale = this.mFactionFrameBG.scale * 0.975;
            }
            _loc2_ = !Config.getConfig().XLViewUsesXLTextures() ? 1 : 0.5;
            this.mFrameBG.scale *= this.isZoomedIn() ? 1 : _loc2_;
            if(this.mFactionFrameBG)
            {
               this.mFrameBG.x = (this.mFactionFrameBG.width - this.mFrameBG.width) / 2;
               this.mFrameBG.y = (this.mFactionFrameBG.height - this.mFrameBG.height) / 2;
            }
            if(!this.mSubComponentsContainer.contains(this.mFrameBG))
            {
               this.mSubComponentsContainer.addChild(this.mFrameBG);
            }
            this.setSummonIconOnTop();
         }
         if(Config.getConfig().cardBGOverlapsFrame())
         {
            this.createBattleContainer();
            if(this.hasAnimatedBG())
            {
               if(this.mBGAnimated)
               {
                  this.mBattleComponents.addChild(this.mBGAnimated);
               }
            }
            else if(this.mBG)
            {
               this.mBattleComponents.addChild(this.mBG);
            }
         }
      }
      
      public function createTierFrame(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         if(Config.getConfig().gameHasTierFrames() && Boolean(this.mCardDef))
         {
            _loc2_ = this.mCardDef.getCompositeTierFrameName();
            if(this.mTierFrame != null)
            {
               this.mTierFrame.removeFromParent();
            }
            if(this.mTierFrame == null)
            {
               this.mTierFrame = new CompositeFrame(_loc2_);
            }
            else
            {
               this.mTierFrame.updateTexture(_loc2_);
            }
            this.mTierFrame.alignPivot();
            this.mTierFrame.width = this.mFrameBG ? this.mFrameBG.width : this.mTierFrame.width;
            this.mTierFrame.height = this.mFrameBG ? this.mFrameBG.height : this.mTierFrame.height;
            this.mTierFrame.x = this.mFrameBG ? this.mFrameBG.x + this.mFrameBG.width / 2 : width / 2;
            this.mTierFrame.y = this.mFrameBG ? this.mFrameBG.y + this.mFrameBG.height / 2 : height / 2;
            if(this.mSubComponentsContainer)
            {
               this.mSubComponentsContainer.addChild(this.mTierFrame);
            }
         }
         if(!Config.getConfig().gameHasTierFrames() && param1 && Boolean(this.mTierFrame))
         {
            this.mTierFrame.visible = false;
            this.mTierFrame.alpha = 0.999;
         }
      }
      
      public function removeTierFrame() : void
      {
         var _loc1_:Number = NaN;
         if(this.mTierFrame != null)
         {
            _loc1_ = Config.getConfig().getDefaultDelayPromoteRemoveTierFrameAnimDuration();
            TweenMax.delayedCall(_loc1_,SpecialFX.tweenToAlpha,[this.mTierFrame,0.001,_loc1_,0,this.removeTierFrameFromParent,[this.mTierFrame]]);
         }
      }
      
      private function removeTierFrameFromParent(param1:CompositeFrame) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      public function createFactionFrameBG() : void
      {
         var _loc1_:String = this.mCardDef.getFactionFrameBGName();
         if(_loc1_ != "")
         {
            this.setFactionFrameBG(_loc1_);
            if(!this.mSubComponentsContainer.contains(this.mFactionFrameBG))
            {
               this.mSubComponentsContainer.addChild(this.mFactionFrameBG);
               if(this.mBottomFrameBG)
               {
                  this.mSubComponentsContainer.addChild(this.mBottomFrameBG);
               }
            }
         }
      }
      
      private function canBeMoved() : Boolean
      {
         return !this.mZoomedIn && !this.isEnemyCard() && InstanceMng.getBattleEngine() && InstanceMng.getBattleEngine().getAbilityWaitingForTarget() == null && !InstanceMng.getBattleEngine().isSacrificeWaitingForTarget() && (!InstanceMng.getBattleEngine().isOnlineMatch() || InstanceMng.getBattleEngine().isOnlineMatch() && PvPConnectionMng.smExpirationTimeLeft >= 0);
      }
      
      public function requestShowShadow(param1:Number = 1.04, param2:Boolean = true, param3:Number = -1, param4:Boolean = true) : void
      {
         param3 = param3 == -1 ? this.getTransitionCardTime(DEFAULT_MOVE_ELEVATED_CARD_TIME) : param3 * Utils.getDefaultSpeedTime();
         if(Config.getConfig().getCardShadowsEnabled())
         {
            if(this.mShadow == null)
            {
               this.createShadow();
               if(this.mShadow)
               {
                  this.mShadow.width = width;
                  this.mShadow.height = height;
               }
            }
            if(!param2)
            {
               if(this.mShadow)
               {
                  this.mShadow.visible = true;
               }
            }
            if(param2 && !this.mCardPressedAndMoving && !this.mShadow.visible)
            {
               SpecialFX.createCardZoomTransition(this,scaleX * param1,param3,param4);
            }
         }
         this.activateDropShadow(false);
      }
      
      public function onShadowTweeningOver(param1:Boolean) : void
      {
         if(param1)
         {
            this.mUpdateShadow = true;
            this.mShadowTween = null;
         }
      }
      
      public function onShadowTweeningInit() : void
      {
      }
      
      public function onShadowTweeningUpdate() : void
      {
         if(this.mShadow)
         {
            this.mShadow.onShadowTweeningUpdate();
         }
      }
      
      public function onCardZoomTransitionUpdate() : void
      {
         if(this.mBattleSceneParent != null)
         {
            if(this.mShadow)
            {
               this.mBattleSceneParent.addChild(this.mShadow);
            }
            this.mBattleSceneParent.addChild(this);
         }
      }
      
      protected function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Array = null;
         var _loc5_:Vector.<Touch> = null;
         var _loc6_:Ability = null;
         var _loc7_:FSCard = null;
         var _loc8_:Boolean = false;
         var _loc9_:String = null;
         var _loc10_:String = null;
         if(Config.smDebugTooltips)
         {
            this.mCardTouch = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
            if(this.mCardTouch)
            {
               setTooltipText(this.mCardDef.getSku() + " C.V.:" + "[" + this.mCardDef.getCardValue() + "]");
            }
         }
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(Boolean(_loc2_) && Boolean(_loc2_.isBattleOver()) || _loc2_ == null)
         {
            return;
         }
         if(this.mBattleSceneParent != null)
         {
            _loc3_ = _loc2_ ? _loc2_.canPerformUIActions() : false;
            if(!_loc3_)
            {
               if(Boolean(_loc2_) && _loc2_.isOnlineMatch())
               {
                  if(Boolean(_loc2_) && _loc2_.getPlayersStateId() == BattleEngine.STATE_OPPONENT_RECEIVING_CARDS_FROM_DECK)
                  {
                     this.mCardTouch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
                     if(this.mCardTouch)
                     {
                        if(!this.mIsMoving)
                        {
                           if(!Root.assets.isLoading && !this.mZoomedIn && (Boolean(this.mBattleSceneParent) && (Boolean(this.mBattleSceneParent.getSelectedCard() == null || this.mBattleSceneParent.getSelectedCard() != null && !this.mBattleSceneParent.getSelectedCard().isZoomedIn()))))
                           {
                              this.notifyCardSelected();
                              SpecialFX.zoomIn(this);
                           }
                        }
                     }
                  }
               }
               return;
            }
         }
         if(this.mDisableIntersections)
         {
            _loc4_ = TweenMax.getTweensOf(this);
            if(_loc4_ != null && _loc4_.length > 0)
            {
               return;
            }
         }
         this.handleCardFXOnTouch(param1);
         this.mCardTouch = param1 ? param1.getTouch(this,TouchPhase.BEGAN) : null;
         if(Boolean(this.mCardTouch) && this.canBeMoved())
         {
            Utils.removeLog();
            if(InstanceMng.getCurrentScreen() is FSBattleScreenPvP)
            {
               FSBattleScreenPvP(InstanceMng.getCurrentScreen()).closeChatButtonCarroussel();
            }
         }
         if(param1)
         {
            _loc5_ = param1.getTouches(this,TouchPhase.MOVED);
            if(_loc5_ != null && _loc5_.length == 1 && this.canBeMoved())
            {
               if(this.mUpgradeCostTextfield)
               {
                  this.mUpgradeCostTextfield.closeTooltip();
               }
               if(Boolean(!this.mIsMoving) && Boolean(this.mBattleSceneParent) && this.mFXMouseDown)
               {
                  this.mBattleSceneParent.suggestPlayableCardOFF();
                  this.activateDropShadow(false);
                  if(parent != null)
                  {
                     parent.addChild(this);
                  }
                  if(InstanceMng.getSoundFXMng() != null)
                  {
                     InstanceMng.getSoundFXMng().playCardSound(this,FSSoundFXMng.CARD_SELECTED);
                  }
               }
               this.setDisableIntersections(false);
               if(Boolean(this.mIsMoving) && Boolean(this.mBattleSceneParent) && !this.mPlayableSocketsHighlighted)
               {
                  this.highlightPlayableSocketsVector();
               }
            }
         }
         this.mCardTouch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(this.mCardTouch)
         {
            if(this.mUpgradeCostTextfield)
            {
               this.mUpgradeCostTextfield.closeTooltip();
            }
            if(this.mCardTouch.tapCount >= 1 && !this.mIsMoving)
            {
               _loc6_ = _loc2_ ? _loc2_.getAbilityWaitingForTarget() : null;
               if(_loc2_.isPowerWaitingForTarget() && (this.mAttachedToSocket != null && this.mAttachedToSocket.isBattlefieldSocket()))
               {
                  _loc8_ = this.checkIfNeedsToBeStoredInSaveObj(false,false);
                  if(_loc8_)
                  {
                     _loc9_ = this.mParentUserBattleInfo.isOwnerBattleInfo() ? "owner_card_" : "opponent_card_";
                     if(_loc2_)
                     {
                        BattleEnginePvP(_loc2_).onPowerUnitTargetSelected(_loc9_ + this.mAttachedToSocket.getSocketIndex());
                     }
                  }
                  this.setTouchable(false);
                  this.onAbilityWaitingTriggered();
                  return;
               }
               if(_loc6_ != null && (this.mAttachedToSocket != null && this.mAttachedToSocket.isBattlefieldSocket()))
               {
                  if(this.checkIfNeedsToBeStoredInSaveObj(false,false))
                  {
                     _loc10_ = this.mParentUserBattleInfo.isOwnerBattleInfo() ? "owner_" : "opponent_";
                     _loc10_ = _loc10_ + ("card_" + this.mAttachedToSocket.getSocketIndex());
                     if(_loc2_)
                     {
                        BattleEnginePvP(_loc2_).onUnitTargetSelected(_loc6_.getParentCard(),_loc10_);
                     }
                  }
                  this.onAbilityWaitingTriggered();
                  return;
               }
               if(_loc2_.isSacrificeWaitingForTarget() && this is FSUnit && this.isOnBF())
               {
                  this.onSacrificeTargetSelected();
                  return;
               }
               if(this.mBattleSceneParent == null)
               {
                  return;
               }
               _loc7_ = this.mBattleSceneParent.getSelectedCard();
               if(!(!Root.assets.isLoading && !this.mZoomedIn && (_loc7_ == null || _loc7_ != null && !_loc7_.isZoomedIn() && !_loc7_.isMoving())))
               {
                  return;
               }
               SpecialFX.zoomIn(this);
            }
            this.notifyCardSelected();
            if(Boolean(this.mCardTouch) && this.mCardTouch.tapCount >= 1)
            {
               if(!this.mDisableIntersections && this.mIsMoving)
               {
                  this.performIntersectionTest();
               }
            }
         }
         if(!this.mIsMoving)
         {
            this.mCardTouch = param1 ? param1.getTouch(this,TouchPhase.HOVER) : null;
            if(!Utils.isMobile() && Boolean(this.mAttachedToSocket))
            {
               width = Boolean(this.mCardTouch) && !this.mZoomedIn ? this.mAttachedToSocket.width * 1.05 : this.mAttachedToSocket.width;
               height = Boolean(this.mCardTouch) && !this.mZoomedIn ? this.mAttachedToSocket.height * 1.05 : this.mAttachedToSocket.height;
            }
         }
      }
      
      private function handleCardFXBegan(param1:TouchEvent) : void
      {
         this.mCardTouch = param1 ? param1.getTouch(this,TouchPhase.BEGAN) : null;
         if(Boolean(this.mCardTouch) && this.canBeMoved())
         {
            Utils.removeLog();
            if(this.mFXMouseTarget == null)
            {
               this.mFXMouseTarget = new Point();
            }
            this.mFXMouseTarget.x = this.mCardTouch.globalX;
            this.mFXMouseTarget.y = this.mCardTouch.globalY;
            this.mFXStartTouchPosX = this.mCardTouch.globalX;
            this.mFXStartTouchPosY = this.mCardTouch.globalY;
         }
      }
      
      private function handleCardFXMoved(param1:TouchEvent) : void
      {
         var _loc2_:Vector.<Touch> = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         if(param1)
         {
            _loc2_ = param1.getTouches(this,TouchPhase.MOVED);
            if(_loc2_ != null && _loc2_.length == 1 && this.canBeMoved() && Boolean(this.mFXMouseTarget))
            {
               _loc3_ = this.mFXStartTouchPosX - _loc2_[0].globalX;
               _loc4_ = this.mFXStartTouchPosY - _loc2_[0].globalY;
               this.mFXMouseTarget.x = _loc2_[0].globalX;
               this.mFXMouseTarget.y = _loc2_[0].globalY;
               this.mFXDeltaMovementPoint = _loc2_[0].getMovement(parent,this.mFXDeltaMovementPoint);
               _loc5_ = 0.04;
               _loc6_ = Capabilities.screenDPI / Starling.current.contentScaleFactor;
               _loc7_ = Math.abs(_loc3_) / _loc6_;
               _loc8_ = Math.abs(_loc4_) / _loc6_;
               _loc9_ = Utils.isBrowser() || Utils.isDesktop() || _loc7_ > _loc5_;
               _loc10_ = Utils.isBrowser() || Utils.isDesktop() || _loc8_ > _loc5_;
               if(_loc9_ || _loc10_)
               {
                  this.mFXMouseDown = true;
                  this.handleCardShadowOnDrag();
                  this.mIsMoving = true;
               }
            }
         }
      }
      
      private function handleCardFXEnd(param1:TouchEvent) : void
      {
         var _loc2_:Ability = null;
         this.mCardTouch = param1 ? param1.getTouch(this,TouchPhase.ENDED) : null;
         if(this.mCardTouch)
         {
            this.mFXMouseDown = false;
            this.mCardPressedAndMoving = false;
         }
      }
      
      public function handleCardFXOnTouch(param1:TouchEvent) : void
      {
         this.handleCardFXBegan(param1);
         this.handleCardFXMoved(param1);
         this.handleCardFXEnd(param1);
      }
      
      private function handleCardShadowOnDrag() : void
      {
         var _loc1_:Number = NaN;
         if(!this.mUpdateShadow)
         {
            if(Boolean(this.mAttachedToSocket) && this.mAttachedToSocket.isBattlefieldSocket())
            {
               _loc1_ = DEFAULT_SCALE_FACTOR_CARDS_ELEVATION;
            }
            else if(this.mBattleSceneParent != null && this.mBattleSceneParent.getOwnerBFSocketCatalog() != null && this.mBattleSceneParent.getOwnerBFSocketCatalog()[0] != null)
            {
               _loc1_ = FSCardSocket(this.mBattleSceneParent.getOwnerBFSocketCatalog()[0]).width / width;
            }
            else
            {
               _loc1_ = DEFAULT_SCALE_FACTOR_CARDS_ELEVATION;
            }
            this.requestShowShadow(_loc1_,true,-1,false);
         }
      }
      
      public function isCardBeingMoved() : Boolean
      {
         return this.mFXMouseDown && this.mIsMoving;
      }
      
      public function setCardPressedAndMoving(param1:Boolean) : void
      {
         this.mCardPressedAndMoving = param1;
      }
      
      public function onSacrificeTargetSelected() : void
      {
         var _loc3_:String = null;
         this.touchable = false;
         var _loc1_:int = this.mAttachedToSocket ? this.mAttachedToSocket.getSocketIndex() : -1;
         InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_CARD_SACRIFIED,this);
         InstanceMng.getBattleEngine().setSacrificeWaitingForTarget(false);
         var _loc2_:LightningAnimation = InstanceMng.getCurrentScreen() is FSBattleScreen ? FSBattleScreen(InstanceMng.getCurrentScreen()).getLightning() : null;
         if(_loc2_)
         {
            _loc2_.fadeOff();
         }
         InstanceMng.getCardAnimsMng().requestSacrificeAnimation(this);
         if(Config.getConfig().gameHasSacrifice())
         {
            this.mParentUserBattleInfo.setSacrificeAvailable(false);
         }
         InstanceMng.getBattleEngine().notifyActionDone(Config.getConfig().getSacrificeCost());
         Utils.playSound(Constants.SOUND_SACRIFICE_TRIGGER,SoundManager.TYPE_SFX);
         TweenMax.delayedCall(Config.getConfig().getSacrificeDuration(),this.updateStatsAfterAttack,[0]);
         TweenMax.delayedCall(Config.getConfig().getSacrificeDuration() + Config.getConfig().getDefaultDeathAnimDuration(),this.onSacrificeTargetSacrified);
         if(this.checkIfNeedsToBeStoredInSaveObj(false,this.isEnemyCard()))
         {
            _loc3_ = this.mParentUserBattleInfo.isOwnerBattleInfo() ? "owner_" : "opponent_";
            _loc3_ += "card_" + this.mAttachedToSocket.getSocketIndex();
            if(InstanceMng.getBattleEngine())
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onSacrificeUnitTargetSelected(_loc3_);
            }
         }
      }
      
      private function onSacrificeTargetSacrified() : void
      {
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getBattleScreen()))
         {
            InstanceMng.getBattleEngine().getBattleScreen().highlightSacrificeTargets(false);
            if(Config.getConfig().gameHasSacrifice() && this.mParentUserBattleInfo != null)
            {
               InstanceMng.getBattleEngine().getBattleScreen().enableSacrificeButton(this.mParentUserBattleInfo.isOwnerBattleInfo(),false);
            }
         }
         Utils.playSound(Constants.SOUND_SACRIFICE_END,SoundManager.TYPE_SFX);
      }
      
      public function createShadow() : FSCardShadow
      {
         if(this.mShadow == null)
         {
            this.mShadow = InstanceMng.getResourcesMng().createCardShadow(this);
            this.mShadow.touchable = false;
            this.mShadow.setOnDefaultPos();
            this.mShadow.visible = false;
         }
         return this.mShadow;
      }
      
      protected function onAbilityWaitingTriggered() : void
      {
         var _loc1_:Ability = InstanceMng.getBattleEngine().getAbilityWaitingForTarget();
         var _loc2_:Array = new Array();
         _loc2_.push(this);
         if(_loc1_)
         {
            _loc1_.onTargetSelected(_loc2_);
         }
      }
      
      override public function dispose() : void
      {
         this.removeCardElemsFromDisplayList(true);
         if(!Config.USE_CARD_POOLING)
         {
            super.dispose();
         }
      }
      
      public function destroy() : void
      {
         this.removeCardElemsFromDisplayList();
      }
      
      public function notifyCardSelected() : void
      {
         if(this.getBattleSceneParent() != null)
         {
            this.getBattleSceneParent().setSelectedCard(this);
         }
      }
      
      protected function performIntersectionTest(param1:Boolean = false) : Boolean
      {
         var _loc2_:FSCardSocket = null;
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         var _loc3_:Boolean = false;
         if(this.mBattleSceneParent != null && this.canCardBeMoved())
         {
            if(InstanceMng.getBattleEngine() != null)
            {
               _loc4_ = InstanceMng.getBattleEngine().isOwnerTurn() ? this.mBattleSceneParent.getOwnerBFSocketCatalog() : this.mBattleSceneParent.getOpponentBFSocketCatalog();
               if(_loc4_ != null)
               {
                  if(this.hasAnimatedBG())
                  {
                     smBGIntersectionRect = this.mBGAnimated ? this.mBGAnimated.getBounds(parent,smBGIntersectionRect) : null;
                  }
                  else
                  {
                     smBGIntersectionRect = this.mBG ? this.mBG.getBounds(parent,smBGIntersectionRect) : null;
                  }
                  for each(_loc2_ in _loc4_)
                  {
                     if(Boolean(_loc2_) && !_loc3_)
                     {
                        smSocketIntersectionRect = _loc2_.getBounds(parent,smSocketIntersectionRect);
                        smSocketIntersectionRect.width *= 0.5;
                        smSocketIntersectionRect.height *= 0.5;
                        smSocketIntersectionRect.x += smSocketIntersectionRect.width / 2;
                        smSocketIntersectionRect.y += smSocketIntersectionRect.height / 2;
                        if(Boolean(smBGIntersectionRect) && smBGIntersectionRect.intersects(smSocketIntersectionRect))
                        {
                           if(_loc2_.getParentCard() != this)
                           {
                              if(InstanceMng.getBattleEngine().isCardAttachableToSocket(this,_loc2_,!param1))
                              {
                                 if(param1)
                                 {
                                    this.mIntersectionTopIndex = _loc2_.getSocketIndex();
                                    _loc3_ = true;
                                 }
                                 else
                                 {
                                    this.mIntersectionTopIndex = -1;
                                    this.checkIntersection(_loc2_);
                                    _loc3_ = true;
                                 }
                              }
                           }
                        }
                        else if(Boolean(smBGIntersectionRect) && !smBGIntersectionRect.intersects(smSocketIntersectionRect))
                        {
                           if(param1)
                           {
                              this.mIntersectionTopIndex = -1;
                           }
                        }
                     }
                  }
                  if(param1 && _loc3_ == false)
                  {
                     this.mIntersectionTopIndex = -1;
                  }
                  if(param1 && Boolean(_loc4_))
                  {
                     this.processPostIntersection(_loc4_);
                  }
                  if(!this.mIsOnBattlefield && !param1 && !_loc3_)
                  {
                     this.showCantPlaceCardOnDeckMessage();
                  }
               }
            }
         }
         if(!_loc3_ && !param1)
         {
            this.onNoIntersectionFound();
            this.mIntersectionTopIndex = -1;
            this.processPostIntersection(_loc4_);
         }
         return _loc3_;
      }
      
      private function processSocketPreIntersection(param1:FSCardSocket, param2:Boolean) : void
      {
         var _loc4_:FSCard = null;
         var _loc3_:Boolean = this is FSAction;
         if(param1.getParentCard() == null)
         {
            param2 &&= !_loc3_ || _loc3_ && !this.mIsZoomingOut;
            param1.activateTargetIntersectedAnim(param2);
         }
         else
         {
            _loc4_ = param1.getParentCard();
            if(_loc4_ != this)
            {
               if(param2)
               {
                  if(this.isSocketInPlayableSockets(param1))
                  {
                     param1.getParentCard().activateHighlightTween(65280,true,1,null,null,!(this is FSUnit));
                  }
               }
               else
               {
                  param1.getParentCard().deactivateHighlightTween();
                  if(_loc3_ && !this.mIsZoomingOut && this.isSocketInPlayableSockets(param1))
                  {
                     param1.getParentCard().activateHighlightTween();
                  }
               }
            }
         }
      }
      
      protected function processPostIntersection(param1:Dictionary) : void
      {
         var _loc2_:FSCardSocket = null;
         for each(_loc2_ in param1)
         {
            this.processSocketPreIntersection(_loc2_,_loc2_.getSocketIndex() == this.mIntersectionTopIndex);
         }
      }
      
      public function onNoIntersectionFound() : void
      {
         SpecialFX.zoomOut(this);
         this.unHighlightAllPlayableItems(true);
         if(this.mBattleSceneParent)
         {
            this.mBattleSceneParent.suggestPlayableCardON();
         }
      }
      
      protected function showNotAbleToPlaceCardMessage() : void
      {
         Utils.setLogText(TextManager.getText("TID_LOG_SOCKET_UNIT"),true);
         if(Config.getConfig().battleGetVoiceOnError())
         {
            Utils.playSound(Constants.SOUND_CANT_DO_THAT,SoundManager.TYPE_SFX);
         }
      }
      
      protected function showCantPlaceCardOnDeckMessage() : void
      {
         Utils.setLogText(TextManager.getText("TID_LOG_SOCKET_BATTLEFIELD"),true);
         if(Config.getConfig().battleGetVoiceOnError())
         {
            Utils.playSound(Constants.SOUND_CANT_DO_THAT,SoundManager.TYPE_SFX);
         }
      }
      
      protected function showNotAbleToPlaceSameHeroMessage() : void
      {
         Utils.setLogText(TextManager.getText("TID_SAME_FAMILY_CARD"),true);
      }
      
      protected function checkIntersection(param1:FSCardSocket) : void
      {
         var _loc7_:int = 0;
         var _loc2_:Boolean = this.mBattleSceneParent.getBattleEngine().existCardWithSameName(this.mCardDef);
         var _loc3_:Boolean = this.mBattleSceneParent.getBattleEngine().canCardBePlayedByFaction(this.mCardDef);
         var _loc4_:Boolean = this.mBattleSceneParent.getBattleEngine().isOnlineMatch();
         var _loc5_:Boolean = _loc4_ ? this.mBattleSceneParent.getBattleEngine().canRectifyCard(this) : true;
         var _loc6_:Boolean = this.isCardSocketRectification();
         if(this.mBattleSceneParent.getBattleEngine().canPlayerDoMoreActions(this.mSummonCost) && !_loc2_ && _loc3_ || _loc6_)
         {
            if(_loc6_)
            {
               if(_loc5_)
               {
                  this.setAttachedToSocket(param1,_loc6_);
                  if(_loc4_)
                  {
                     this.mBattleSceneParent.getBattleEngine().addCardRectification(this);
                     _loc7_ = this.mBattleSceneParent.getBattleEngine().getCardRectificationsLeft(this);
                     if(_loc7_ > 0)
                     {
                        Utils.setLogText(TextManager.replaceParameters(TextManager.getText("TID_PVP_RECTIFY_MOV"),[_loc7_]),false,false,false);
                     }
                     else
                     {
                        Utils.setLogText(TextManager.getText("TID_PVP_RECTIFY_LIMIT"),false,false,false);
                     }
                  }
               }
               else
               {
                  Utils.setLogText(TextManager.getText("TID_PVP_RECTIFY_LIMIT"),false,false,false);
                  this.performNotAbleToPlaceCardOps();
               }
            }
            else
            {
               this.setAttachedToSocket(param1,_loc6_);
            }
         }
         else
         {
            if(_loc2_)
            {
               this.showNotAbleToPlaceSameHeroMessage();
            }
            else if(!_loc3_)
            {
               Utils.setLogText(TextManager.getText("TID_LOG_SPECIFIC_FACTION_REQUIRED"),true);
            }
            else if(InstanceMng.getCurrentScreen() != null && InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).showNotEnoughAPEffect(this);
            }
            this.performNotAbleToPlaceCardOps();
         }
         SpecialFX.zoomOut(this);
      }
      
      private function performNotAbleToPlaceCardOps() : void
      {
         var _loc1_:FSCardSocket = null;
         var _loc3_:int = 0;
         var _loc2_:Dictionary = InstanceMng.getBattleEngine().isOwnerTurn() ? this.mBattleSceneParent.getOwnerBFSocketCatalog() : this.mBattleSceneParent.getOpponentBFSocketCatalog();
         if(_loc2_ != null)
         {
            for each(_loc1_ in _loc2_)
            {
               if(_loc1_)
               {
                  _loc1_.activateTargetIntersectedAnim(false);
               }
            }
         }
         this.unHighlightAllPlayableItems();
         this.mBattleSceneParent.suggestPlayableCardON();
      }
      
      protected function canCardBeMoved() : Boolean
      {
         var _loc1_:Boolean = false;
         return !this.mIsOnBattlefield || this.mIsOnBattlefield && this.isOnSupportLane() && this.mTurnsAlive == 0;
      }
      
      protected function isCardSocketRectification() : Boolean
      {
         return false;
      }
      
      public function getAbsAnimsLayer() : Component
      {
         return this.mAbilitiesAnimsLayer;
      }
      
      public function getBG() : FSImage
      {
         return this.mBG;
      }
      
      public function setBG(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:UserData = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(param1),param2);
            if(this.mFactionFrameBG)
            {
               this.mBG.scale = this.mFactionFrameBG.scale;
            }
            this.mBGLightStyle = new LightStyle();
            this.mBGLightStyle.ambientRatio = 1;
            this.mBGLightStyle.diffuseRatio = 0.3;
            this.mBGLightStyle.specularRatio = 0.35;
            this.mBGLightStyle.shininess = 8;
            _loc3_ = Utils.getOwnerUserData();
            _loc4_ = InstanceMng.getBattleEngine() == null || InstanceMng.getBattleEngine() != null && InstanceMng.getBattleEngine().isBattleOver();
            _loc5_ = !(InstanceMng.getCurrentScreen() is FSBattleScreen);
            _loc6_ = (_loc5_) || !_loc5_ && _loc4_;
            if(Boolean(_loc3_) && Boolean(_loc3_.flagsGetShowLightFX()) && _loc6_)
            {
               if(this.mBG)
               {
                  this.mBG.style = this.mBGLightStyle;
               }
               this.mBGLight = LightSource.createPointLight(16777215,0.3);
               this.mBGLight.x = this.mBG.width / 2;
               this.mBGLight.y = this.mBG.height / 2;
               this.mBGLight.z = -30;
               addChild(this.mBGLight);
            }
            else if(this.mBG)
            {
               this.mBG.style = null;
            }
         }
         else
         {
            this.mBG.texture = Root.assets.getTexture(param1);
            if(this.mFactionFrameBG)
            {
               this.mBG.scale = this.mFactionFrameBG.scale;
            }
            this.mBG.readjustSize();
         }
      }
      
      public function getBGAnimated() : MovieClip
      {
         return this.mBGAnimated;
      }
      
      public function getFrameBG() : CompositeFrame
      {
         return this.mFrameBG;
      }
      
      public function getTierFrameBG() : CompositeFrame
      {
         return this.mTierFrame;
      }
      
      public function getTier() : int
      {
         return this.mTier;
      }
      
      public function getFactionFrameBG() : CompositeFrame
      {
         return this.mFactionFrameBG;
      }
      
      public function setFactionFrameBG(param1:String) : void
      {
         if(this.mFactionFrameBG == null)
         {
            this.mFactionFrameBG = new CompositeFrame(param1);
         }
         this.mFactionFrameBG.updateTexture(param1);
         this.mFactionFrameBG.scale = Config.getConfig().getNoXLTexturesFactor();
         this.createBottomFrameBG();
      }
      
      private function createBottomFrameBG() : void
      {
         if(this.mType == TYPE_UNIT || this.mType == TYPE_ATTACHMENT)
         {
            if(this.mBottomFrameBG == null)
            {
               this.mBottomFrameBG = new FSImage(Root.assets.getTexture(this.mCardDef.getFactionFrameBGName() + "_bottom"));
            }
            else
            {
               this.mBottomFrameBG.texture = Root.assets.getTexture(this.mCardDef.getFactionFrameBGName() + "_bottom");
            }
            this.mBottomFrameBG.scale = this.mFactionFrameBG.scale;
            this.mBottomFrameBG.x = this.mFactionFrameBG.x;
            this.mBottomFrameBG.y = this.mFactionFrameBG.y + this.mFactionFrameBG.height - this.mBottomFrameBG.height;
            this.mSubComponentsContainer.addChild(this.mBottomFrameBG);
         }
      }
      
      public function getAbilities() : Vector.<Ability>
      {
         this.sortAbilitiesBySku(this.mAbilities);
         return this.mAbilities;
      }
      
      public function getParentAbilitiesDefs() : Vector.<AbilityDef>
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:AbilityDef = null;
         var _loc1_:Vector.<AbilityDef> = null;
         if(this.mCardDef)
         {
            _loc2_ = this.mCardDef.getAbilities();
            if(_loc2_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc2_[_loc3_]));
                  if((Boolean(_loc4_)) && _loc4_.isParentAbility())
                  {
                     if(_loc1_ == null)
                     {
                        _loc1_ = new Vector.<AbilityDef>();
                     }
                     _loc1_.push(_loc4_);
                  }
                  _loc3_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function nullifyAbilities() : void
      {
         this.mAbilities = null;
      }
      
      public function removeAbility(param1:Ability) : void
      {
         var _loc2_:int = 0;
         if(this.mAbilities)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAbilities.length)
            {
               if(this.mAbilities[_loc2_].getAbilityDef().getSku() == param1.getAbilityDef().getSku())
               {
                  this.mAbilities.splice(_loc2_,1);
                  if(Boolean(this.mAbilitiesIcons) && this.mAbilitiesIcons[param1.getAbilityDef().getSku()] != null)
                  {
                     FSImage(this.mAbilitiesIcons[param1.getAbilityDef().getSku()]).removeFromParent();
                     this.mAbilitiesIcons[param1.getAbilityDef().getSku()] = null;
                     delete this.mAbilitiesIcons[param1.getAbilityDef().getSku()];
                  }
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      public function getAttachedToSocket() : FSCardSocket
      {
         return this.mAttachedToSocket;
      }
      
      public function isAttacking() : Boolean
      {
         var _loc1_:Boolean = this.getParentUserBattleInfo() != null && this.getParentUserBattleInfo().isOwnerBattleInfo();
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         var _loc3_:Boolean = _loc2_.getBattleStateId() != BattleEngine.BATTLE_STATE_DEALING_CARDS;
         return _loc2_ != null && _loc3_ && (_loc2_.isOwnerTurn() && _loc1_ || !_loc2_.isOwnerTurn() && !_loc1_);
      }
      
      public function setIsAttacking(param1:Boolean, param2:FSCard) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         this.mIsAttacking = param1;
         if(param2 != null)
         {
            _loc3_ = param2 is FSUnit && FSUnit(param2).isArtillery();
            _loc4_ = param2.isOnSupportLane();
            if(!this.mIsAttacking && _loc3_ && _loc4_)
            {
               return;
            }
         }
         this.mFightingWithCard = param2;
         if(this.mIsAttacking)
         {
            this.activateDropShadow(!this.mIsAttacking);
         }
      }
      
      public function getFightingWithCard() : FSCard
      {
         return this.mFightingWithCard;
      }
      
      public function getPlayableSockets() : Vector.<FSCardSocket>
      {
         return this.mPlayableSockets;
      }
      
      public function isSocketInPlayableSockets(param1:FSCardSocket) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(Boolean(this.mPlayableSockets) && Boolean(param1))
         {
            _loc3_ = 0;
            while(_loc3_ < this.mPlayableSockets.length)
            {
               if(this.mPlayableSockets[_loc3_] == param1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function getPlayablePortraits() : Vector.<FSBattlefieldUserPortrait>
      {
         return this.mPlayableBFPortraits;
      }
      
      public function getDieOnEndTurn() : Boolean
      {
         return this.mDieOnEndTurn;
      }
      
      public function setDieOnEndTurn(param1:Boolean) : void
      {
         this.mDieOnEndTurn = param1;
      }
      
      public function getShadow() : FSCardShadow
      {
         return this.mShadow;
      }
      
      public function setUpdateShadow(param1:Boolean) : void
      {
         this.mUpdateShadow = param1;
      }
      
      public function setShadowTween(param1:TweenMax) : void
      {
         this.mShadowTween = param1;
      }
      
      public function getShadowTween() : TweenMax
      {
         return this.mShadowTween;
      }
      
      public function isMoving() : Boolean
      {
         return this.mIsMoving;
      }
      
      public function setIsMoving(param1:Boolean) : void
      {
         this.mIsMoving = param1;
      }
      
      public function checkIfNeedsToBeStoredInSaveObj(param1:Boolean = false, param2:Boolean = false) : Boolean
      {
         var _loc4_:BattleEngine = null;
         var _loc3_:Boolean = false;
         if(!param2)
         {
            _loc4_ = InstanceMng.getBattleEngine();
            if(_loc4_ != null && _loc4_.isOnlineMatch() && !param1 && _loc4_.isOwnerTurn())
            {
               if(this.getType() == TYPE_POWER)
               {
                  _loc3_ = true;
               }
               else if(this.mAttachedToSocket != null)
               {
                  if(this.mAttachedToSocket != null)
                  {
                     _loc3_ = true;
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function getOldSocketIndexCode(param1:int = -1) : String
      {
         var _loc2_:String = "";
         var _loc3_:BattleEnginePvP = BattleEnginePvP(InstanceMng.getBattleEngine());
         if(this.mAttachedToSocket != null)
         {
            if(this.mAttachedToSocket != null)
            {
               _loc2_ = this.mAttachedToSocket.isBattlefieldSocket() ? "bf_" : "side_";
               _loc2_ += param1 != -1 ? param1 : this.mAttachedToSocket.getSocketIndex();
            }
         }
         return _loc2_;
      }
      
      public function setAttachedToSocket(param1:FSCardSocket, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:Boolean = false;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:BattleEngine = null;
         var _loc25_:Boolean = false;
         var _loc26_:Boolean = false;
         var _loc27_:Boolean = false;
         var _loc28_:Boolean = false;
         this.deactivateHighlightTween();
         var _loc5_:Boolean = this.checkIfNeedsToBeStoredInSaveObj(param2,param3);
         var _loc6_:String = "";
         var _loc7_:int = this.mAttachedToSocket ? this.mAttachedToSocket.getSocketIndex() : -1;
         if(_loc5_)
         {
            _loc6_ = this.getOldSocketIndexCode();
         }
         var _loc8_:Boolean = Boolean(this.mAttachedToSocket) && Boolean(param1) && this.mAttachedToSocket == param1;
         if(param1 != null)
         {
            param1.setParentCard(this);
            param1.deactivateHighlightTween();
            param1.activateTargetIntersectedAnim(false);
            this.unHighlightAllPlayableItems();
         }
         if(param3 || this.mAttachedToSocket != null)
         {
            if(param3 || this.mAttachedToSocket != null && !this.mAttachedToSocket.isBattlefieldSocket())
            {
               if(this.mParentUserBattleInfo)
               {
                  this.mParentUserBattleInfo.removeCardFromPlayableCardsCatalog(this);
                  this.mBattleSceneParent.disableFreeReshuffle(this.mParentUserBattleInfo);
               }
            }
            if(this.mAttachedToSocket != null)
            {
               this.mAttachedToSocket.deactivateHighlightTween();
               this.mAttachedToSocket.activateTargetIntersectedAnim(false);
               this.mAttachedToSocket.setParentCard(null);
            }
         }
         this.mAttachedToSocket = param1;
         if(this.mAttachedToSocket)
         {
            this.mAttachedToSocket.deactivateHighlightTween();
            this.mAttachedToSocket.activateTargetIntersectedAnim(false);
         }
         if(param1 != null && param1.isBattlefieldSocket())
         {
            this.createAuraAnim();
            _loc10_ = this.setIsOnBattlefield(true,this.isEnemyCard());
            this.mParentUserBattleInfo.setFightCardOnBattlefield(this);
            if(_loc10_)
            {
               this.updateAbilitiesAppliedOnNextCard();
            }
            this.removeSummonFrameIcon();
            this.removeFusionIcon();
            _loc11_ = param2 ? BattleEngine.COMBAT_LOG_CARD_POS_MODIFIED : BattleEngine.COMBAT_LOG_CARD_MOVED_TO_BF;
            InstanceMng.getBattleEngine().storeCombatLogAction(_loc11_,this);
         }
         if(!param2)
         {
            if(!param3)
            {
               InstanceMng.getScoreMng().trackAction(ScoreMng.PLAY_UNIT);
               if(!this.mBattleSceneParent.getBattleEngine().isPvPMatch())
               {
                  InstanceMng.getTargetMng().addCardPlayed(this);
               }
            }
            if(Config.getConfig().hasQuests())
            {
               InstanceMng.getQuestsMng().onCardPlayed(this);
            }
            _loc12_ = this.hasTargetSelectionAbilities();
            _loc13_ = this.hasOnPlayAbilities();
            _loc14_ = this.hasTargetSelectionAbsWithPlayableTargets();
            _loc15_ = this.getCompositeAbilitiesVector() != null;
            _loc16_ = this.hasScoutDivisionAndIsTriggereable();
            _loc17_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_CODEINTERCEPTION) != null || this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MASSCODEINTERCEPTION) != null;
            _loc18_ = Config.getConfig().getDefaultZoomOutTime() + this.getRotationTimeToDefaultPos(Config.getConfig().getDefaultZoomOutTime());
            _loc19_ = this.mCardDef.getAPGeneratedOnPlay();
            if(_loc19_ != 0)
            {
               TweenMax.delayedCall(_loc18_,this.mParentUserBattleInfo.increaseAPGenerated,[_loc19_]);
               TweenMax.delayedCall(_loc18_ + 0.25,InstanceMng.getTextParticlesMng().showTextParticleOnBattle,["-" + this.mCardDef.getSummonCost(),16777215,this,FSResourceMng.FONT_STD_SEMI_SMALL_SIZE,Align.LEFT,Align.TOP,FSResourceMng.FONT_TYPE_STD_RED,"frame_summon_icon",true,"up",Align.RIGHT,true]);
            }
            if(_loc15_ && (_loc14_ && _loc12_ || _loc16_ || _loc17_))
            {
               InstanceMng.getBattleEngine().getBattleScreen().setCardAnimsON(true);
               if(_loc16_ || _loc17_)
               {
                  TweenMax.delayedCall(_loc18_ + Config.getConfig().getDefaultAbilityAnimDuration(),this.setBattleScreenAnimsON,[false]);
               }
               TweenMax.delayedCall(_loc18_,this.triggerOnAttachedAbilities);
            }
            else if(_loc15_ && !_loc12_)
            {
               this.touchable = false;
               TweenMax.delayedCall(_loc18_,this.triggerOnAttachedAbilities);
            }
         }
         if(!param2)
         {
            this.onCardPlayedPerformPvPChecks();
         }
         var _loc9_:Boolean = this.mBattleSceneParent != null && !param2 && (this.hasTargetSelectionAbilities() && !this.hasTargetSelectionAbsWithPlayableTargets() || !this.hasTargetSelectionAbilities());
         if(_loc9_)
         {
            this.mBattleSceneParent.getBattleEngine().notifyActionDone(this.mSummonCost);
            TweenMax.delayedCall(Config.getConfig().getDefaultZoomOutTime(),this.playCardSound,[FSSoundFXMng.CARD_MOVED_TO_BF]);
         }
         this.mOldSocketIndexCode = _loc6_;
         if(_loc5_)
         {
            if(PvPConnectionMng.realTimeAllowed())
            {
               if(_loc9_)
               {
                  _loc20_ = this.hasRandomTargetAbilities();
                  _loc21_ = this.hasRandomStatsAbilities();
                  _loc22_ = this.hasMulticastAbilities();
                  _loc23_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_RECRUIT) != null;
                  if(!_loc20_ && !_loc21_ && !_loc22_ && !_loc23_)
                  {
                     BattleEnginePvP(InstanceMng.getBattleEngine()).onCardMoved(this,_loc6_,param1.getSocketIndex());
                  }
               }
            }
            else
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onCardMoved(this,_loc6_,param1.getSocketIndex());
            }
         }
         else
         {
            _loc24_ = InstanceMng.getBattleEngine();
            _loc25_ = _loc24_.isOwnerTurn();
            if((_loc25_) && !param3 && _loc24_.isOnlineMatch())
            {
               _loc26_ = this.isUnit() && this.abilityAllowsMovement(this.mAttachedToSocket);
               _loc27_ = !_loc8_ && param1 != null && param1.isBattlefieldSocket() && this.mAttachedToSocket != null && this.mAttachedToSocket.isBattlefieldSocket();
               _loc28_ = _loc24_.isMovingCardsFromSupportToAttack();
               if(_loc27_ && (this.mTurnsAlive == 0 || _loc26_ && !_loc28_) && !param4)
               {
                  BattleEnginePvP(InstanceMng.getBattleEngine()).onCardRectification(this,param1.getSocketIndex(),_loc7_);
               }
            }
         }
         if(this.mBattleSceneParent)
         {
            this.mBattleSceneParent.suggestPlayableCardON();
            this.mBattleSceneParent.updateEmblems();
         }
      }
      
      private function createAuraAnim(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:RarityDef = null;
         var _loc6_:String = null;
         var _loc7_:SubCategoryDef = null;
         if(this.mCardDef)
         {
            _loc2_ = "";
            _loc3_ = 15;
            if(this.mAnimAura == null)
            {
               if(!param1)
               {
                  _loc4_ = this.mCardDef.getCardRarity();
                  _loc5_ = (Boolean(_loc4_)) && _loc4_ != "" ? RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(_loc4_)) : null;
                  if((Boolean(_loc5_)) && _loc5_.getHasAura())
                  {
                     _loc6_ = this.mCardDef.getSubCategorySku()[0];
                     _loc7_ = _loc6_ ? SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc6_)) : null;
                     _loc2_ = _loc7_ ? _loc7_.getAnimAura() : "";
                  }
               }
               if(_loc2_ == "" && this.mCardDef.hasAura())
               {
                  _loc2_ = this.mCardDef.getAuraBGName();
               }
            }
            if(_loc2_ != "" && _loc2_ != null)
            {
               this.createCardAura(_loc2_);
            }
         }
      }
      
      private function createCardAura(param1:String) : void
      {
         var _loc2_:String = param1;
         var _loc3_:int = 15;
         var _loc4_:Vector.<Texture> = Root.assets.getTextures(_loc2_ + "_");
         if((Boolean(_loc4_)) && _loc4_.length > 0)
         {
            if(this.mAnimAura == null)
            {
               this.mAnimAura = new MovieClip(_loc4_,_loc3_);
               this.mAnimAura.touchable = false;
            }
            Starling.juggler.add(this.mAnimAura);
            this.mAnimAura.play();
            if(this.mBG)
            {
               this.mAnimAura.width = this.mBG.width * 0.98;
               this.mAnimAura.height = this.mBG.height * 0.98;
               this.mAnimAura.x = this.mBG.x + (this.mBG.width - this.mAnimAura.width) / 2;
               this.mAnimAura.y = this.mBG.y + (this.mBG.height - this.mAnimAura.height) / 2;
            }
            else if(this.mBGAnimated)
            {
               this.mAnimAura.width = this.mBGAnimated.width * 0.98;
               this.mAnimAura.height = this.mBGAnimated.height * 0.98;
               this.mAnimAura.x = this.mBGAnimated.x + (this.mBGAnimated.width - this.mBGAnimated.width) / 2;
               this.mAnimAura.y = this.mBGAnimated.y + (this.mBGAnimated.height - this.mBGAnimated.height) / 2;
            }
            if(Config.getConfig().cardBGOverlapsFrame())
            {
               this.createBattleContainer();
               if(this.mBattleComponents)
               {
                  this.mBattleComponents.addChild(this.mAnimAura);
               }
            }
            else if(this.mSubComponentsContainer)
            {
               this.mSubComponentsContainer.addChild(this.mAnimAura);
            }
            if(Config.getConfig().getCardBGType() == "png")
            {
               if(Config.getConfig().cardBGOverlapsFrame())
               {
                  this.createBattleContainer();
                  if(this.mBattleComponents)
                  {
                     this.mBattleComponents.addChild(this.mBG);
                  }
               }
               else if(this.mSubComponentsContainer)
               {
                  this.mSubComponentsContainer.addChild(this.mBG);
               }
            }
         }
      }
      
      private function removeFusionIcon() : void
      {
         if(this.mFusionIcon)
         {
            this.mFusionIcon.removeFromParent();
            this.mFusionIcon.destroy();
            this.mFusionIcon = null;
         }
      }
      
      private function onCardPlayedPerformPvPChecks() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Vector.<Ability> = null;
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         if(InstanceMng.getBattleEngine())
         {
            if(InstanceMng.getBattleEngine().isOnlineMatch())
            {
               if(InstanceMng.getBattleEngine().isOwnerTurn())
               {
                  _loc1_ = InstanceMng.getBattleEngine().getBattleStateId() == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS;
                  if(_loc1_)
                  {
                     _loc2_ = this.getAbilities();
                     _loc5_ = false;
                     if(_loc2_)
                     {
                        _loc4_ = 0;
                        while(_loc4_ < _loc2_.length)
                        {
                           _loc3_ = _loc2_[_loc4_];
                           if(Boolean(!_loc5_) && Boolean(_loc3_.getAbilityDef()) && _loc3_.getAbilityDef().stopsResumedPvPActions())
                           {
                              if(!PvPConnectionMng.realTimeAllowed())
                              {
                                 PvPConnectionMng.storeStopResumedPvPActions();
                              }
                              _loc5_ = true;
                           }
                           _loc4_++;
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function removeSummonFrameIcon(param1:Boolean = true) : void
      {
         if(param1)
         {
            if(this.mSummonTextfield)
            {
               SpecialFX.tweenToAlpha(this.mSummonTextfield,0,0.5,0,this.removeSummonFrameIcon,[false]);
            }
            if(this.mFrameSummonIcon)
            {
               SpecialFX.tweenToAlpha(this.mFrameSummonIcon,0,0.5,0);
            }
         }
         else
         {
            if(this.mSummonTextfield)
            {
               this.mSummonTextfield.removeFromParent();
               this.mSummonTextfield = null;
            }
            if(this.mFrameSummonIcon)
            {
               this.mFrameSummonIcon.removeFromParent();
               this.mFrameSummonIcon.destroy();
               this.mFrameSummonIcon = null;
            }
         }
      }
      
      private function playCardSound(param1:int) : void
      {
         if(InstanceMng.getSoundFXMng())
         {
            InstanceMng.getSoundFXMng().playCardSound(this,param1);
         }
      }
      
      private function setBattleScreenAnimsON(param1:Boolean) : void
      {
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getBattleScreen()))
         {
            InstanceMng.getBattleEngine().getBattleScreen().setCardAnimsON(param1);
         }
      }
      
      public function hasTargetSelectionAbsWithPlayableTargets() : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Ability = null;
         var _loc1_:Boolean = false;
         var _loc2_:Vector.<Ability> = this.getCompositeAbilitiesVector();
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_[_loc4_];
               if(_loc5_.canBeExecutedAndHasTargets())
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      public function abilityAllowsMovement(param1:FSCardSocket = null) : Boolean
      {
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:AbilityDef = null;
         var _loc2_:Boolean = false;
         if(this.mAbilities != null)
         {
            _loc4_ = int(this.mAbilities.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = this.mAbilities[_loc5_];
               _loc6_ = _loc3_.getAbilityDef();
               if(_loc6_ != null && _loc6_.isSpecial())
               {
                  if(_loc6_.getKeyName() == AbilitiesMng.SPECIAL_FAST)
                  {
                     if(param1 != null)
                     {
                        if(this.mIsOnBattlefield)
                        {
                           return param1.getRowIndex() == this.getAttachedToSocket().getRowIndex();
                        }
                        return FSCardSocket(param1).isSupportSocket();
                     }
                     return true;
                  }
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function abilityAllowsMovingToAttackLane() : Boolean
      {
         var _loc2_:Ability = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc1_:Boolean = false;
         if(this.mAbilities != null)
         {
            _loc3_ = int(this.mAbilities.length);
            _loc5_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_DEPLOY) != null;
            _loc6_ = this.hasScoutDivisionAndIsTriggereable();
            _loc1_ = _loc5_ || _loc6_;
         }
         return _loc1_;
      }
      
      public function hasTargetSelectionAbilities() : Boolean
      {
         var _loc2_:Ability = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc1_:Boolean = false;
         if(this.mAbilities != null)
         {
            _loc3_ = int(this.mAbilities.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = this.mAbilities[_loc4_];
               if(InstanceMng.getAbilitiesMng().isTargetSelectionAbility(_loc2_.getAbilityDef()))
               {
                  _loc5_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(_loc2_.getAbilityDef(),this,_loc2_.getAbilityDef().getCostRange());
                  if(_loc5_ != null && _loc5_.length > 0)
                  {
                     return true;
                  }
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      public function hasOnPlayAbilities() : Boolean
      {
         var _loc2_:Ability = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = false;
         if(this.mAbilities != null)
         {
            _loc3_ = int(this.mAbilities.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = this.mAbilities[_loc4_];
               if(_loc2_.getAbilityDef().getTriggerIndex() == AbilitiesMng.TRIGGERS_ON_PLAY)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      public function hasRandomTargetAbilities() : Boolean
      {
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc1_:Vector.<Ability> = this.getCompositeAbilitiesVector();
         var _loc2_:Boolean = false;
         if(_loc1_ != null)
         {
            _loc4_ = int(_loc1_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _loc1_[_loc5_];
               _loc6_ = _loc3_.canBeExecutedAndHasTargets();
               _loc7_ = InstanceMng.getAbilitiesMng().isRandomTargetAbility(_loc3_.getAbilityDef());
               if(_loc6_ && _loc7_)
               {
                  return true;
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function hasPassiveAbilities() : Boolean
      {
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc1_:Vector.<Ability> = this.getCompositeAbilitiesVector();
         var _loc2_:Boolean = false;
         if(_loc1_ != null)
         {
            _loc4_ = int(_loc1_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _loc1_[_loc5_];
               _loc6_ = _loc3_.canBeExecutedAndHasTargets();
               _loc7_ = InstanceMng.getAbilitiesMng().isRandomTargetAbility(_loc3_.getAbilityDef());
               if(_loc6_ && _loc7_)
               {
                  return true;
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function hasTriggerOnPromoteAbilities() : Boolean
      {
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Vector.<Ability> = this.getCompositeAbilitiesVector();
         var _loc2_:Boolean = false;
         if(_loc1_ != null)
         {
            _loc4_ = int(_loc1_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _loc1_[_loc5_];
               if(Boolean(_loc3_ != null) && Boolean(_loc3_.getAbilityDef()) && _loc3_.getAbilityDef().getTriggerIndex() == AbilitiesMng.TRIGGERS_ON_PROMOTE)
               {
                  return true;
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function hasRandomStatsAbilities() : Boolean
      {
         var _loc3_:Ability = null;
         var _loc4_:AbilityDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:Vector.<Ability> = this.getCompositeAbilitiesVector();
         var _loc2_:Boolean = false;
         if(_loc1_ != null)
         {
            _loc5_ = int(_loc1_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_ = _loc1_[_loc6_];
               if(_loc3_.canBeExecutedAndHasTargets())
               {
                  _loc4_ = _loc3_.getAbilityDef();
                  if(_loc4_.getRandomDamageAmount() != 0 || _loc4_.getRandomDefenseAmount() != 0 || _loc4_.getRandomHealAmount() != 0)
                  {
                     return true;
                  }
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      public function hasMulticastAbilities() : Boolean
      {
         var _loc3_:Ability = null;
         var _loc4_:AbilityDef = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:Vector.<Ability> = this.getCompositeAbilitiesVector();
         var _loc2_:Boolean = false;
         if(_loc1_ != null)
         {
            _loc5_ = int(_loc1_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_ = _loc1_[_loc6_];
               _loc4_ = _loc3_.getAbilityDef();
               if(_loc3_.canBeExecutedAndHasTargets() && _loc4_.getChances() != null)
               {
                  return true;
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      public function triggerOnPromoteAbilities() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:UserBattleInfo = null;
         var _loc6_:PassiveAbilityDef = null;
         var _loc7_:Array = null;
         var _loc8_:AbilityDef = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc1_:Boolean = true;
         if(InstanceMng.getBattleEngine())
         {
            if(!InstanceMng.getBattleEngine().isOwnerTurn())
            {
               _loc1_ = InstanceMng.getBattleEngine().isPvPMatch() || Config.smAIAbilitiesOn;
            }
            if(_loc1_)
            {
               _loc2_ = InstanceMng.getBattleEngine().triggerCardAbilities(this,0,true,AbilitiesMng.TRIGGERS_ON_PROMOTE);
               _loc3_ = _loc2_ * Config.getConfig().getDefaultAbilityAnimDuration();
               TweenMax.delayedCall(_loc3_,InstanceMng.getBattleEngine().checkCardsKilledInCombat);
               TweenMax.delayedCall(_loc3_,InstanceMng.getBattleEngine().checkIfBattleOver,[false]);
            }
         }
         if(Config.getConfig().gameHasPassive())
         {
            _loc4_ = InstanceMng.getBattleEngine().isOwnerTurn();
            _loc5_ = _loc4_ ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
            _loc6_ = _loc5_.getPassiveAbilityDef();
            _loc7_ = _loc6_ ? _loc6_.getAbilitiesSkus() : null;
            _loc8_ = (Boolean(_loc7_)) && _loc7_.length > 0 ? AbilityDef(InstanceMng.getAbilitiesDefMng().getDefBySku(_loc7_[0])) : null;
            _loc9_ = (Boolean(_loc8_)) && _loc8_.getTriggerIndex() == AbilitiesMng.TRIGGERS_ON_PROMOTE;
            _loc10_ = (_loc9_) && (_loc4_ || InstanceMng.getBattleEngine().isPvPMatch());
            if(_loc10_)
            {
               _loc5_.executePassive(this);
            }
         }
      }
      
      public function canExecutePassiveAbilities() : Boolean
      {
         return this.mParentUserBattleInfo != null && this.mParentUserBattleInfo.hasRandomPassiveAbilities(this);
      }
      
      public function hasDamageTakenAbility() : Boolean
      {
         return this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_DAMAGETAKEN) != null;
      }
      
      public function triggerOnDamageTakenAbilities() : void
      {
         var _loc1_:AbilityDef = null;
         var _loc2_:Ability = null;
         var _loc3_:Number = NaN;
         if(this.hasDamageTakenAbility())
         {
            if(InstanceMng.getBattleEngine())
            {
               _loc1_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_DAMAGETAKEN);
               _loc2_ = this.getAbilityByAbSku(_loc1_.getSku());
               _loc2_.execute();
               _loc3_ = Config.getConfig().getDefaultAbilityAnimDuration();
               TweenMax.delayedCall(_loc3_,InstanceMng.getBattleEngine().checkCardsKilledInCombat);
               TweenMax.delayedCall(_loc3_,InstanceMng.getBattleEngine().checkIfBattleOver,[false]);
            }
         }
      }
      
      public function triggerOnAttachedAbilities() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc1_:Boolean = true;
         if(InstanceMng.getBattleEngine())
         {
            if(!InstanceMng.getBattleEngine().isOwnerTurn())
            {
               _loc1_ = InstanceMng.getBattleEngine().isPvPMatch() || Config.smAIAbilitiesOn;
            }
            if(_loc1_)
            {
               _loc5_ = InstanceMng.getBattleEngine().triggerCardAbilities(this,0,true);
               _loc6_ = _loc5_ * Config.getConfig().getDefaultAbilityAnimDuration();
               TweenMax.delayedCall(_loc6_,InstanceMng.getBattleEngine().checkCardsKilledInCombat);
               TweenMax.delayedCall(_loc6_,InstanceMng.getBattleEngine().checkIfBattleOver,[false]);
               if(_loc5_ == 0)
               {
                  this.touchable = true;
               }
            }
            _loc2_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MERCENARY) != null;
            if(_loc2_)
            {
               this.performMercenaryOps();
            }
            _loc3_ = this.hasTargetSelectionAbsWithPlayableTargets();
            _loc4_ = this.hasTargetSelectionAbilities();
            if(_loc5_ == 0)
            {
               this.executePassive();
            }
            else if(_loc5_ > 0 && (_loc3_ && !_loc4_))
            {
               _loc6_ = _loc5_ * Config.getConfig().getDefaultAbilityAnimDuration();
               TweenMax.delayedCall(_loc6_,this.executePassive);
            }
         }
      }
      
      private function hasScoutDivisionAndIsTriggereable() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:AbilityDef = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SCOUTDIVISION);
         var _loc3_:Boolean = _loc2_ != null;
         if(_loc3_)
         {
            _loc1_ = InstanceMng.getAbilitiesMng().isAbilityTriggereable(this.getAbilityByAbSku(_loc2_.getSku()));
         }
         return _loc1_;
      }
      
      public function getScoutDivisionEligibleTargets(param1:AbilityDef) : Dictionary
      {
         var _loc4_:int = 0;
         var _loc2_:Dictionary = new Dictionary(true);
         var _loc3_:Array = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(param1,this);
         if(Boolean(_loc3_) && Boolean(_loc3_.length))
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_] is FSUnit)
               {
                  _loc2_[_loc4_] = _loc3_[_loc4_];
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function executePassive() : void
      {
         if(InstanceMng.getBattleEngine().isOwnerTurn())
         {
            InstanceMng.getBattleEngine().getOwnerBattleInfo().executePassive(this);
         }
         else
         {
            InstanceMng.getBattleEngine().getOpponentBattleInfo().executePassive(this);
         }
      }
      
      private function performSupportToAttackMovement(param1:Boolean, param2:Dictionary = null) : void
      {
         if(InstanceMng.getBattleEngine())
         {
            InstanceMng.getBattleEngine().performSupportToAttackMovement(param1,param2);
         }
      }
      
      private function performMercenaryOps() : void
      {
         var _loc1_:BattleEngine = null;
         var _loc2_:Boolean = false;
         var _loc3_:UserBattleInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:LevelDef = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:AbilityDef = null;
         var _loc10_:int = 0;
         if(this.mParentUserBattleInfo != null)
         {
            _loc1_ = InstanceMng.getBattleEngine();
            _loc2_ = _loc1_.isOwnerTurn();
            _loc3_ = _loc2_ ? _loc1_.getOpponentBattleInfo() : _loc1_.getOwnerBattleInfo();
            _loc4_ = _loc3_.getHP();
            _loc5_ = this.mParentUserBattleInfo.getHP();
            _loc6_ = InstanceMng.getBattleEngine().getLevelDef();
            _loc7_ = _loc2_ ? _loc6_.getActionPointsPerTurn() : _loc6_.getAIActionPointsPerTurn();
            _loc8_ = _loc2_ ? this.mParentUserBattleInfo.getAPGenerated() : _loc3_.getAPGenerated();
            _loc7_ += _loc8_;
            if(_loc5_ < _loc4_ && this.mParentUserBattleInfo.getActionPointsLeft() <= _loc7_)
            {
               _loc9_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MERCENARY);
               _loc10_ = _loc9_.getApValue();
               this.mParentUserBattleInfo.setActionPointsLeft(this.mParentUserBattleInfo.getActionPointsLeft() + _loc10_);
               this.mBattleSceneParent.updateActionPointsLeft();
            }
         }
      }
      
      public function detachCard(param1:Boolean = false) : void
      {
         this.activateDropShadow(false);
         var _loc2_:Boolean = this.isEnemyCard();
         if(this.mParentUserBattleInfo)
         {
            this.mParentUserBattleInfo.removeFightCardFromBattlefield(this);
         }
         if(this.mAttachedToSocket != null)
         {
            this.mAttachedToSocket.setParentCard(null);
         }
         this.mAttachedToSocket = null;
         var _loc3_:Boolean = false;
         if(this.mIsOnBattlefield)
         {
            _loc3_ = this.setIsOnBattlefield(false,_loc2_);
         }
         if(!param1 && !Config.getConfig().gameHasGraveyard() && Boolean(this.mParentUserBattleInfo))
         {
            this.mParentUserBattleInfo.addCardSkuToCatalogs(this.getCardDef().getSku(),1);
            if(_loc3_)
            {
               this.updateAbilitiesAppliedOnNextCard();
            }
         }
      }
      
      public function getCardDef() : CardDef
      {
         return this.mCardDef;
      }
      
      public function setCardDef(param1:CardDef) : void
      {
         this.mCardDef = param1;
         this.setType();
      }
      
      public function isUnit() : Boolean
      {
         return this.mIsUnit;
      }
      
      public function setIsUnit(param1:Boolean) : void
      {
         this.mIsUnit = param1;
      }
      
      public function getDefense() : int
      {
         return this.mDefense ? int(this.mDefense.value) : 0;
      }
      
      private function combatLogCanTrackCard() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc1_:Boolean = false;
         if(InstanceMng.getBattleEngine())
         {
            _loc2_ = InstanceMng.getBattleEngine().getPlayersStateId();
            _loc3_ = this is FSCardPreview || this is FSCardPreviewXL;
            _loc1_ = !_loc3_ && !this.isZoomedIn();
         }
         return _loc1_;
      }
      
      public function setDefense(param1:int, param2:Boolean = false) : void
      {
         if(this.mDefense == null)
         {
            this.mDefense = new FSNumber();
         }
         var _loc3_:Boolean = this.mDefense.value > param1;
         if(_loc3_)
         {
            this.triggerOnDamageTakenAbilities();
         }
         var _loc4_:Boolean = this.combatLogCanTrackCard();
         var _loc5_:int = this.mAttachedToSocket ? this.mAttachedToSocket.getSocketIndex() : -1;
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(_loc4_) && this.mDefense.value != Number(param1))
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_CARD_DEF_MODIFIED,this,"",{"VALUE":this.mDefense.value + " -> " + Number(param1)});
         }
         this.mDefense.value = Number(param1);
      }
      
      public function addDefense(param1:int) : void
      {
         if(this.mDefense == null)
         {
            this.mDefense = new FSNumber();
         }
         var _loc2_:Boolean = param1 < 0;
         if(_loc2_)
         {
            this.triggerOnDamageTakenAbilities();
         }
         var _loc3_:int = int(this.mDefense.value) + param1 > 0 ? int(int(this.mDefense.value) + param1) : 0;
         var _loc4_:int = this.mAttachedToSocket ? this.mAttachedToSocket.getSocketIndex() : -1;
         if(Boolean(InstanceMng.getBattleEngine()) && this.mDefense.value != _loc3_)
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_CARD_DEF_MODIFIED,this,"",{"VALUE":this.mDefense.value + " -> " + _loc3_});
         }
         this.mDefense.value = int(this.mDefense.value) + param1 > 0 ? int(this.mDefense.value) + param1 : 0;
      }
      
      public function getDamage() : int
      {
         return this.mDamage ? int(this.mDamage.value) : 0;
      }
      
      public function getOriginalDamage() : int
      {
         return this.mDamage ? int(this.mDamage.value) : 0;
      }
      
      public function setDamage(param1:int) : void
      {
         if(this.mDamage == null)
         {
            this.mDamage = new FSNumber();
         }
         var _loc2_:Boolean = this.combatLogCanTrackCard();
         var _loc3_:int = this.mAttachedToSocket ? this.mAttachedToSocket.getSocketIndex() : -1;
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(_loc2_) && this.mDamage.value != Number(param1))
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_CARD_DMG_MODIFIED,this,"",{"VALUE":this.mDamage.value + " -> " + Number(param1)});
         }
         this.mDamage.value = Number(param1);
      }
      
      public function addDamage(param1:int) : void
      {
         if(this.mDamage == null)
         {
            this.mDamage = new FSNumber();
         }
         this.setDamage(this.mDamage.value + param1);
      }
      
      public function isZoomedIn() : Boolean
      {
         return this.mZoomedIn;
      }
      
      public function setZoomedIn(param1:Boolean) : void
      {
         if(param1)
         {
            FSDebug.debugTrace("zooming in");
         }
         else
         {
            FSDebug.debugTrace("zooming out");
            InstanceMng.getCurrentScreen().showLoadingIcon(false,true);
            this.unHighlightPlayableSocketsVector();
         }
         this.mZoomedIn = param1;
      }
      
      public function getBattleSceneParent() : FSBattleScreen
      {
         return this.mBattleSceneParent;
      }
      
      public function setBattleSceneParent(param1:FSBattleScreen) : void
      {
         this.mBattleSceneParent = param1;
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function setType() : void
      {
         if(this.mCardDef is UnitDef)
         {
            this.mType = TYPE_UNIT;
         }
         else if(this.mCardDef is AttachmentDef)
         {
            this.mType = TYPE_ATTACHMENT;
         }
         else if(this.mCardDef is ActionDef)
         {
            this.mType = TYPE_ACTION;
         }
         else if(this.mCardDef is PowerDef)
         {
            this.mType = TYPE_POWER;
         }
      }
      
      public function getId() : int
      {
         return this.mId;
      }
      
      public function setId(param1:int) : void
      {
         this.mId = param1;
      }
      
      public function getBFId() : int
      {
         return this.mBFId;
      }
      
      public function setBFId(param1:int) : void
      {
         this.mBFId = param1;
      }
      
      public function getPlayableCardId() : int
      {
         return this.mPlayableCardId;
      }
      
      public function setPlayableCardId(param1:int) : void
      {
         this.mPlayableCardId = param1;
      }
      
      public function isEnemyCard(param1:Boolean = false) : Boolean
      {
         var _loc3_:BattleEngine = null;
         var _loc2_:Boolean = true;
         if(this.mBattleSceneParent != null)
         {
            _loc3_ = InstanceMng.getBattleEngine();
            if(_loc3_ != null && param1 == false)
            {
               if(_loc3_.isPvPMatch())
               {
                  if(!BattleEnginePvP(_loc3_).isOnlineMatch())
                  {
                     if(this.mAttachedToSocket)
                     {
                        if(_loc3_.isOwnerTurn())
                        {
                           return this.mAttachedToSocket.getIsEnemy();
                        }
                        return !this.mAttachedToSocket.getIsEnemy();
                     }
                     _loc2_ = this.mParentUserBattleInfo != null ? !this.mParentUserBattleInfo.isOwnerBattleInfo() : true;
                  }
               }
            }
         }
         if(this.mAttachedToSocket)
         {
            _loc2_ = this.mAttachedToSocket.getIsEnemy();
         }
         else
         {
            _loc2_ = this.mParentUserBattleInfo != null ? !this.mParentUserBattleInfo.isOwnerBattleInfo() : true;
         }
         return _loc2_;
      }
      
      public function setDisableIntersections(param1:Boolean) : void
      {
         this.mDisableIntersections = param1;
      }
      
      public function isOnSummonCooldown() : Boolean
      {
         return this.mSummonCooldownTurnsLeft > 0;
      }
      
      public function setIsOnBattlefield(param1:Boolean, param2:Boolean = true) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:Boolean = false;
         if(!param2)
         {
            if(this.mId == -1)
            {
               if(InstanceMng.getBattleEngine() == null)
               {
                  return false;
               }
               this.mId = param1 ? InstanceMng.getBattleEngine().getCardId() : -1;
               InstanceMng.getBattleEngine().addCardsCount();
            }
            if(param1 == false)
            {
               this.mId = -1;
            }
         }
         this.mIsOnBattlefield = param1;
         if(this.mBFId == -1)
         {
            _loc3_ = true;
            if(this.mParentUserBattleInfo == null)
            {
               return false;
            }
            _loc4_ = param1 ? DictionaryUtils.getLowestAvailableKeyOnDictionary(this.mParentUserBattleInfo.getFightCards()) : -1;
            this.setBFId(_loc4_);
         }
         if(param1 == false)
         {
            this.setBFId(-1);
         }
         if(param1)
         {
            this.createZoomIconInCombat();
         }
         return _loc3_;
      }
      
      public function updateAbilitiesAppliedOnNextCard(param1:Boolean = false, param2:Ability = null) : void
      {
         var _loc3_:AbilityDef = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         if(Boolean(this.mParentUserBattleInfo) && Boolean(this.mParentUserBattleInfo.applyCostModifierAbilityOnNextCard()) && (!this.hasTargetSelectionAbilities() || this.hasTargetSelectionAbilities() && !this.hasTargetSelectionAbsWithPlayableTargets() || param1))
         {
            _loc3_ = null;
            _loc5_ = false;
            if(this.mParentUserBattleInfo.isModifiedCostActive())
            {
               _loc3_ = this.mParentUserBattleInfo.getExtraSummonCostAbilityDef();
               _loc5_ = this.mParentUserBattleInfo.applyCostModifierAbilityOnNextCard() && _loc3_ && _loc3_.isCardEligibleForAbility(this) && this.mParentUserBattleInfo.getModifySummonCostParentCard() != this;
               if(_loc5_)
               {
                  this.mParentUserBattleInfo.removeSummonCostAbilities();
                  return;
               }
            }
            if(this.mParentUserBattleInfo.isFixedSummonCostActive())
            {
               _loc3_ = this.mParentUserBattleInfo.getFixedSummonCostAbilityDef();
               _loc4_ = this.mParentUserBattleInfo.getFixedSummonCost();
               _loc5_ = this.mParentUserBattleInfo.applyCostModifierAbilityOnNextCard() && _loc3_ && _loc3_.isCardEligibleForAbility(this) && this.mParentUserBattleInfo.getFixedSummonCostParentCard() != this && this.getCardCostByType(_loc3_) == _loc4_;
               if(_loc5_)
               {
                  this.mParentUserBattleInfo.removeSummonCostAbilities();
                  return;
               }
            }
         }
      }
      
      protected function createZoomIconInCombat() : void
      {
         var _loc2_:Ability = null;
         var _loc6_:FSImage = null;
         var _loc1_:Vector.<Ability> = this.getAbilities();
         var _loc3_:int = _loc1_ != null ? int(_loc1_.length) : 0;
         var _loc4_:* = _loc3_;
         var _loc5_:Boolean = this is FSAttachment;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.getAbilityDef().getZoomIconInCombat())
            {
               _loc6_ = this.getAbilityIconImage(_loc2_.getAbilityDef());
               TweenMax.killTweensOf(_loc6_);
               TweenMax.killTweensOf(_loc6_);
               InstanceMng.getCardsMng().assignScaleToAbilityIcon(_loc6_,this);
               if(_loc6_)
               {
                  setTimeout(SpecialFX.createYoYoZoomTransition,750,_loc6_,_loc6_.scaleX + _loc6_.scaleX * 0.2,0.5,-1,null,null,false);
               }
            }
            _loc4_--;
         }
      }
      
      public function getParentUserBattleInfo() : UserBattleInfo
      {
         return this.mParentUserBattleInfo;
      }
      
      public function setParentUserBattleInfo(param1:UserBattleInfo) : void
      {
         this.mParentUserBattleInfo = param1;
      }
      
      public function getTurnsAlive() : int
      {
         return this.mTurnsAlive;
      }
      
      public function setTurnsAlive(param1:int) : void
      {
         this.mTurnsAlive = param1;
      }
      
      public function increaseTurnsAlive() : void
      {
         ++this.mTurnsAlive;
      }
      
      public function getTempCardXL() : FSCardXL
      {
         return this.mTempCardXL;
      }
      
      public function setTempCardXL(param1:FSCardXL) : void
      {
         this.mTempCardXL = param1;
      }
      
      public function addCardAnim(param1:CardAnimation) : void
      {
         if(this.mCardAnimsAttached == null)
         {
            this.mCardAnimsAttached = new Vector.<CardAnimation>();
         }
         this.mCardAnimsAttached.push(param1);
      }
      
      public function removeCardAnims(param1:Boolean = false) : void
      {
         var _loc2_:CardAnimation = null;
         if(this.mCardAnimsAttached != null)
         {
            for each(_loc2_ in this.mCardAnimsAttached)
            {
               if(!param1 || param1 && _loc2_.getAbilityItBelongsTo() != AbilitiesMng.SPECIAL_CAPTURED)
               {
                  _loc2_.unload();
                  _loc2_.removeFromParent();
               }
            }
         }
      }
      
      public function removeBulletAnims() : void
      {
         var _loc1_:CardAnimation = null;
         if(this.mCardAnimsAttached != null)
         {
            for each(_loc1_ in this.mCardAnimsAttached)
            {
               if(_loc1_.getAbilityItBelongsTo() != AbilitiesMng.SPECIAL_CAPTURED && _loc1_ is BulletsAnim)
               {
                  _loc1_.unload();
                  _loc1_.removeFromParent();
               }
            }
         }
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
                  if(_loc3_ is MovieClipZoomAnimation)
                  {
                     MovieClipZoomAnimation(_loc3_).removeZoomAnim();
                  }
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
      
      public function getAbilityIconImage(param1:AbilityDef) : FSImage
      {
         var _loc2_:FSImage = null;
         if(this.mAbilitiesIcons != null)
         {
            _loc2_ = this.mAbilitiesIcons[param1.getSku()];
         }
         return _loc2_;
      }
      
      public function addAbilityIconImage(param1:FSImage, param2:AbilityDef) : void
      {
         if(this.mAbilitiesIcons == null)
         {
            this.mAbilitiesIcons = new Dictionary(true);
         }
         var _loc3_:String = Config.smDebugTooltips ? "[" + param2.getSku() + "] " : "";
         var _loc4_:String = param2.getName();
         var _loc5_:String = param2.isParentAbility() ? _loc3_ + param2.getCompositeName() : _loc3_ + param2.getDesc();
         _loc5_ = _loc4_ + "\n" + _loc5_;
         param1.setTooltipText(_loc5_);
         param1.addEventListener(TouchEvent.TOUCH,this.onAbilityImageTouch);
         this.mAbilitiesIcons[param2.getSku()] = param1;
      }
      
      private function onAbilityImageTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(DisplayObject(param1.currentTarget),TouchPhase.HOVER);
         var _loc3_:FSImage = FSImage(param1.target);
         if(_loc2_)
         {
            if(_loc3_)
            {
               _loc3_.showTooltip();
            }
         }
         else if(_loc3_)
         {
            _loc3_.closeTooltip();
         }
      }
      
      public function removeAbilityIcons(param1:Boolean = false) : void
      {
         var _loc2_:FSImage = null;
         if(this.mAbilitiesIcons != null)
         {
            for each(_loc2_ in this.mAbilitiesIcons)
            {
               if(_loc2_ != null && contains(_loc2_))
               {
                  _loc2_.removeFromParent(param1);
               }
            }
         }
      }
      
      private function addPreviousCardDef(param1:CardDef) : void
      {
         if(this.mPreviousTiersCardsDefs == null)
         {
            this.mPreviousTiersCardsDefs = new Vector.<CardDef>();
         }
         this.mPreviousTiersCardsDefs.push(param1);
      }
      
      public function getPreviousCardsDefs() : Vector.<CardDef>
      {
         return this.mPreviousTiersCardsDefs;
      }
      
      public function isOnSupportLane() : Boolean
      {
         var _loc3_:LevelDef = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc1_:Boolean = false;
         var _loc2_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getLevelDef();
            _loc4_ = _loc3_ ? _loc3_.getRowsAmount() : 2;
            if(_loc2_.isPvPMatch() && !_loc2_.isOnlineMatch() && !_loc2_.isOwnerTurn())
            {
               _loc5_ = !this.isEnemyCard();
            }
            else
            {
               _loc5_ = this.isEnemyCard();
            }
            _loc6_ = _loc5_ || _loc4_ == 1 ? 0 : 1;
            if(this.mAttachedToSocket != null)
            {
               _loc1_ = this.mAttachedToSocket.getRowIndex() == _loc6_;
            }
         }
         return _loc1_;
      }
      
      public function isMovableToAttackLane(param1:Boolean = false) : Boolean
      {
         var _loc2_:Boolean = this.mIsOnBattlefield;
         var _loc3_:FSCardSocket = this.getEmptyAttackSocketForSupportCard();
         var _loc4_:Boolean = _loc3_ != null && _loc3_.isEmpty();
         var _loc5_:Boolean = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SIEGE) != null;
         var _loc6_:Boolean = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SLOW) != null;
         var _loc7_:Boolean = this is FSUnit && FSUnit(this).getTurnsAmountWithoutMovingToAttackLane() > 0;
         var _loc8_:Boolean = _loc6_ ? this.mTurnsAlive > 1 : this.mTurnsAlive > 0;
         _loc8_ = (_loc8_) && !_loc7_;
         if(param1)
         {
            _loc8_ = true;
            this.updateSummonCooldown(0);
         }
         return _loc2_ && _loc4_ && this.isOnSupportLane() && !this.isOnSummonCooldown() && _loc8_ && !_loc5_;
      }
      
      public function isMovableFromAttackLaneToSupportLane() : Boolean
      {
         var _loc1_:Boolean = this.mIsOnBattlefield;
         var _loc2_:FSCardSocket = this.getEmptySupportSocketForAttackCard();
         var _loc3_:Boolean = _loc2_ != null && _loc2_.isEmpty();
         return _loc1_ && _loc3_ && !this.isOnSupportLane();
      }
      
      public function getEmptyAttackSocketForSupportCard() : FSCardSocket
      {
         if(this.getAttachedToSocket() == null)
         {
            return null;
         }
         var _loc1_:int = this.getAttachedToSocket().getBFCoords().getY();
         return this.getAttackSocketByColumnIndex(_loc1_);
      }
      
      public function getEmptySupportSocketForAttackCard() : FSCardSocket
      {
         var _loc1_:int = this.getAttachedToSocket().getBFCoords().getY();
         return this.getSupportSocketByColumnIndex(_loc1_);
      }
      
      private function getSupportSocketByColumnIndex(param1:int) : FSCardSocket
      {
         var _loc2_:FSCardSocket = null;
         var _loc5_:FSCardSocket = null;
         var _loc7_:FSCoordinate = null;
         var _loc3_:Boolean = this.getParentUserBattleInfo().isOwnerBattleInfo();
         var _loc4_:Dictionary = _loc3_ ? this.mBattleSceneParent.getOwnerBFSocketCatalog() : this.mBattleSceneParent.getOpponentBFSocketCatalog();
         var _loc6_:int = _loc3_ ? 1 : 0;
         for each(_loc5_ in _loc4_)
         {
            _loc7_ = _loc5_.getBFCoords();
            if(_loc7_.getY() == param1)
            {
               if(_loc7_.getX() == _loc6_)
               {
                  return _loc5_;
               }
            }
         }
         return _loc2_;
      }
      
      private function getAttackSocketByColumnIndex(param1:int) : FSCardSocket
      {
         var _loc2_:FSCardSocket = null;
         var _loc5_:FSCardSocket = null;
         var _loc7_:Boolean = false;
         var _loc9_:FSCoordinate = null;
         var _loc3_:Boolean = this.getParentUserBattleInfo().isOwnerBattleInfo();
         var _loc4_:Dictionary = _loc3_ ? this.mBattleSceneParent.getOwnerBFSocketCatalog() : this.mBattleSceneParent.getOpponentBFSocketCatalog();
         var _loc6_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc6_.isPvPMatch() && !_loc6_.isOnlineMatch() && !_loc6_.isOwnerTurn())
         {
            _loc7_ = !this.isEnemyCard();
         }
         else
         {
            _loc7_ = this.isEnemyCard();
         }
         var _loc8_:int = _loc7_ ? 1 : 0;
         for each(_loc5_ in _loc4_)
         {
            _loc9_ = _loc5_.getBFCoords();
            if(_loc9_.getY() == param1)
            {
               if(_loc9_.getX() == _loc8_)
               {
                  return _loc5_;
               }
            }
         }
         return _loc2_;
      }
      
      public function getAdjacentCards() : Vector.<FSCard>
      {
         var _loc1_:Vector.<FSCard> = null;
         var _loc4_:FSCardSocket = null;
         var _loc6_:FSCoordinate = null;
         var _loc2_:Boolean = this.getParentUserBattleInfo().isOwnerBattleInfo();
         var _loc3_:Dictionary = _loc2_ ? this.mBattleSceneParent.getOwnerBFSocketCatalog() : this.mBattleSceneParent.getOpponentBFSocketCatalog();
         var _loc5_:int = this.isEnemyCard() ? 1 : 0;
         var _loc7_:FSCoordinate = this.getAttachedToSocket().getBFCoords();
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = _loc4_.getBFCoords();
            if(_loc6_.getY() == _loc7_.getY())
            {
               if(_loc6_.getX() == _loc7_.getX() - 1 || _loc6_.getX() == _loc7_.getX() + 1)
               {
                  if(_loc4_.getParentCard() != null)
                  {
                     if(_loc1_ == null)
                     {
                        _loc1_ = new Vector.<FSCard>();
                     }
                     _loc1_.push(_loc4_.getParentCard());
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function getAttackLaneCard() : FSCard
      {
         var _loc1_:FSCard = null;
         var _loc2_:FSCardSocket = null;
         if(this.isOnSupportLane())
         {
            _loc2_ = this.getEmptyAttackSocketForSupportCard();
            if(_loc2_ != null && !_loc2_.isEmpty())
            {
               _loc1_ = _loc2_.getParentCard();
            }
         }
         return _loc1_;
      }
      
      public function getEligibleToAttackCards(param1:Boolean = false, param2:Boolean = false) : Array
      {
         var _loc5_:UserBattleInfo = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:FSUnit = null;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc3_ == null)
         {
            return null;
         }
         var _loc4_:Boolean = _loc3_.isOwnerTurn();
         if(_loc4_)
         {
            _loc5_ = !param1 ? _loc3_.getOpponentBattleInfo() : _loc3_.getOwnerBattleInfo();
         }
         else
         {
            _loc5_ = !param1 ? _loc3_.getOwnerBattleInfo() : _loc3_.getOpponentBattleInfo();
         }
         _loc6_ = this.getAttachedToSocket() ? this.getAttachedToSocket().getColumnIndex() : -1;
         if(_loc6_ == -1)
         {
            return null;
         }
         _loc7_ = _loc5_ ? _loc3_.getBFCardsByColumnIndex(_loc6_,_loc5_.getFightCards()) : null;
         if(!param2 && Boolean(_loc7_))
         {
            if(this is FSUnit)
            {
               _loc11_ = FSUnit(this).isAirUnit();
               _loc12_ = FSUnit(this).isSubmarineUnit();
               _loc14_ = 0;
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc13_ = _loc7_[_loc8_];
                  _loc15_ = _loc13_ ? _loc13_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_TAUNT) != null : false;
                  if(_loc15_)
                  {
                     if(_loc9_ == null)
                     {
                        _loc9_ = new Array();
                     }
                     _loc9_[_loc14_] = _loc13_;
                     _loc14_++;
                     if(_loc10_ == null)
                     {
                        _loc10_ = new Array();
                     }
                     _loc10_[_loc10_.length] = _loc13_;
                  }
                  else if(!param1)
                  {
                     if(_loc11_)
                     {
                        if(_loc9_ == null)
                        {
                           _loc9_ = new Array();
                        }
                        _loc16_ = _loc13_ ? _loc13_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_AIRDEFENSE) != null : false;
                        if(_loc13_.isAirUnit() || _loc16_)
                        {
                           _loc9_[_loc14_] = _loc13_;
                           _loc14_++;
                        }
                     }
                     else if(_loc12_)
                     {
                        if(_loc9_ == null)
                        {
                           _loc9_ = new Array();
                        }
                        _loc17_ = _loc13_ ? _loc13_.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SUBMARINEDEFENSE) != null : false;
                        if(_loc13_.isSubmarineUnit() || _loc17_)
                        {
                           _loc9_[_loc14_] = _loc13_;
                           _loc14_++;
                        }
                     }
                  }
                  _loc8_++;
               }
            }
         }
         if(_loc9_ != null)
         {
            _loc7_ = _loc9_;
         }
         if(!param2 && this is FSUnit && FSUnit(this).isUnblockable() && !param1)
         {
            _loc7_.length = 0;
            if(_loc10_ != null)
            {
               _loc7_ = _loc10_;
            }
         }
         return _loc7_;
      }
      
      public function getAttackableCard(param1:Boolean = true, param2:Array = null, param3:Boolean = false, param4:Boolean = false) : FSCard
      {
         var _loc5_:FSCard = null;
         var _loc7_:int = 0;
         var _loc8_:FSCard = null;
         var _loc9_:FSCard = null;
         var _loc10_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:FSCardSocket = null;
         var _loc15_:FSCard = null;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:int = 0;
         var _loc20_:FSCard = null;
         var _loc21_:FSCard = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc6_:Array = param2 == null ? this.getEligibleToAttackCards(param3,param4) : param2;
         var _loc11_:int = Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getLevelDef()) ? InstanceMng.getBattleEngine().getLevelDef().getRowsAmount() : 2;
         var _loc12_:Boolean = _loc11_ > 1 ? this.isOnSupportLane() : false;
         if(_loc12_)
         {
            _loc13_ = this.mAttachedToSocket ? int(this.mAttachedToSocket.getBFCoords().getY()) : -1;
            _loc14_ = _loc13_ != -1 ? this.getAttackSocketByColumnIndex(_loc13_) : null;
            _loc15_ = _loc14_ ? _loc14_.getParentCard() : null;
            _loc16_ = _loc15_ ? FSUnit(_loc15_).canAttackFromCurrentPosition() : false;
            _loc17_ = _loc15_ != null && _loc16_;
            if((_loc17_) && _loc15_.getFightingWithCard() != null)
            {
               _loc18_ = _loc15_.getFightingWithCard() ? _loc15_.getFightingWithCard().getAbilityDefByKeyName(AbilitiesMng.SPECIAL_TAUNT) != null : false;
               if(!_loc18_)
               {
                  _loc19_ = -1;
                  _loc20_ = _loc15_.getAttackableCard(true);
                  if(_loc20_)
                  {
                     _loc19_ = _loc6_.indexOf(_loc20_);
                     if(_loc19_ != -1)
                     {
                        _loc6_.removeAt(_loc19_);
                     }
                  }
                  else
                  {
                     _loc21_ = _loc15_.getAttackableCard(false);
                     if(_loc21_)
                     {
                        _loc19_ = _loc6_.indexOf(_loc21_);
                        if(_loc19_ != -1)
                        {
                           _loc6_.removeAt(_loc19_);
                        }
                     }
                  }
               }
            }
         }
         if(_loc6_ != null)
         {
            _loc7_ = int(_loc6_.length);
            if(_loc7_ > 1)
            {
               _loc22_ = FSCard(_loc6_[0]).isOnSupportLane() ? 0 : 1;
               _loc23_ = _loc22_ == 0 ? 1 : 0;
               _loc9_ = _loc6_[_loc22_];
               _loc8_ = _loc6_[_loc23_];
            }
            else if(_loc7_ == 1)
            {
               if(FSCard(_loc6_[0]).isOnSupportLane())
               {
                  _loc9_ = _loc6_[0];
               }
               else
               {
                  _loc8_ = _loc6_[0];
               }
            }
         }
         return param1 ? _loc8_ : _loc9_;
      }
      
      public function hasTargetsToAttack() : Boolean
      {
         var _loc2_:FSCard = null;
         var _loc3_:FSCard = null;
         var _loc1_:Array = this.getEligibleToAttackCards();
         if(_loc1_ != null)
         {
            _loc2_ = this.getAttackableCard(true,_loc1_);
            _loc3_ = this.getAttackableCard(false,_loc1_);
            if(_loc2_ != null || _loc3_ != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isAlive() : Boolean
      {
         return this.getDefense() > 0;
      }
      
      public function performAttackMovement(param1:Boolean, param2:Function = null, param3:Array = null, param4:Function = null, param5:Boolean = false) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:FSCoordinate = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:FSCoordinate = null;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:UserBattleInfo = null;
         var _loc18_:FSBattlefieldUserPortrait = null;
         var _loc6_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc6_)
         {
            _loc8_ = Config.getConfig().getAttackMovementMode();
            if(_loc8_ == BattleEngine.ATTACK_MOVEMENT_BOTH_SIDES_MOVE)
            {
               _loc9_ = _loc6_.isOwnerTurn() ? 1 : -1;
               _loc9_ = param1 ? _loc9_ : int(_loc9_ * -1);
               _loc10_ = _loc9_ * height * 0.1;
               _loc11_ = new FSCoordinate();
               _loc11_.setX(x);
               _loc11_.setY(y + _loc10_);
               _loc7_ = Config.getConfig().getDefaultReachTargetTransitionTime();
               if(param2 != null)
               {
                  if(param3 != null)
                  {
                     TweenMax.delayedCall(_loc7_,param2,param3);
                  }
                  else
                  {
                     TweenMax.delayedCall(_loc7_,param2);
                  }
               }
               _loc12_ = 1;
               SpecialFX.createYoYoTransition(this,_loc11_,_loc7_,_loc12_,param4);
            }
            else if(_loc8_ == BattleEngine.ATTACK_MOVEMENT_ATTACKER_MOVES)
            {
               _loc7_ = Config.getConfig().getDefaultReachTargetTransitionTime();
               _loc13_ = !param1 && !this.isAttacking() && this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_SNIPER) != null;
               if((param1 || _loc13_) && !param5)
               {
                  if(this.mFightingWithCard)
                  {
                     if(this.mBG)
                     {
                        _loc16_ = this.mBG.y;
                     }
                     else
                     {
                        if(!this.mBGAnimated)
                        {
                           return;
                        }
                        _loc16_ = this.mBGAnimated.y;
                     }
                     _loc14_ = new FSCoordinate();
                     _loc14_.setX(this.mFightingWithCard.x);
                     if(_loc6_.isOwnerTurn())
                     {
                        _loc15_ = this.mFightingWithCard.y + this.mFightingWithCard.height / 2 - _loc16_;
                        _loc15_ = _loc15_ > y ? y : _loc15_;
                        _loc14_.setY(_loc15_);
                     }
                     else
                     {
                        _loc15_ = this.mFightingWithCard.y - this.mFightingWithCard.height / 2 + _loc16_;
                        _loc15_ = _loc15_ < y ? y : _loc15_;
                        _loc14_.setY(_loc15_);
                     }
                  }
                  else
                  {
                     _loc17_ = _loc6_.isOwnerTurn() ? InstanceMng.getBattleEngine().getOpponentBattleInfo() : InstanceMng.getBattleEngine().getOwnerBattleInfo();
                     _loc18_ = _loc17_ ? _loc17_.getUserBattlePortrait() : null;
                     if(_loc18_)
                     {
                        _loc14_ = new FSCoordinate();
                        if(_loc6_.isOwnerTurn())
                        {
                           _loc14_.setX(_loc18_.x + _loc18_.width / 2);
                        }
                        else
                        {
                           _loc14_.setX(_loc18_.x + _loc18_.width / 2 + width / 2);
                        }
                        if(_loc6_.isOwnerTurn())
                        {
                           _loc14_.setY(_loc18_.y);
                        }
                        else
                        {
                           _loc14_.setY(_loc18_.y - height / 2);
                        }
                     }
                  }
                  if(_loc14_ != null)
                  {
                     SpecialFX.createYoYoTransition(this,_loc14_,_loc7_,1,param4,Expo.easeIn);
                  }
                  else
                  {
                     TweenMax.delayedCall(_loc7_,param4);
                  }
               }
               if(param2 != null)
               {
                  if(param3 != null)
                  {
                     TweenMax.delayedCall(_loc7_,param2,param3);
                  }
                  else
                  {
                     TweenMax.delayedCall(_loc7_,param2);
                  }
               }
            }
         }
      }
      
      private function getRecoilAmountForAnimation(param1:String) : Number
      {
         var _loc2_:Number = 0.1;
         switch(param1)
         {
            case FSCardAnimsMng.INFANTRY_DAMAGE_ANIM:
            case FSCardAnimsMng.INFANTRY_GERMAN_DAMAGE_ANIM:
            case FSCardAnimsMng.INFANTRY_RUSSIAN_DAMAGE_ANIM:
            case FSCardAnimsMng.INFANTRY_JAPANESE_DAMAGE_ANIM:
               _loc2_ = 0.05;
               break;
            case FSCardAnimsMng.TANK_DAMAGE_ANIM:
            case FSCardAnimsMng.ARTILLERY_DAMAGE_ANIM:
            case FSCardAnimsMng.SNIPER_DAMAGE_ANIM:
            case FSCardAnimsMng.SHIP_DAMAGE_ANIM:
            case FSCardAnimsMng.SUBMARINE_DAMAGE_ANIM:
               _loc2_ = 0.1;
               break;
            case FSCardAnimsMng.AIR_DAMAGE_ANIM:
               _loc2_ = 0.035;
         }
         return _loc2_;
      }
      
      private function getBulletsAmountForAnimation(param1:String) : int
      {
         var _loc2_:int = 1;
         switch(param1)
         {
            case FSCardAnimsMng.INFANTRY_DAMAGE_ANIM:
               _loc2_ = 5;
               break;
            case FSCardAnimsMng.INFANTRY_GERMAN_DAMAGE_ANIM:
               _loc2_ = 2;
               break;
            case FSCardAnimsMng.INFANTRY_RUSSIAN_DAMAGE_ANIM:
               _loc2_ = 4;
               break;
            case FSCardAnimsMng.INFANTRY_JAPANESE_DAMAGE_ANIM:
               _loc2_ = 5;
               break;
            case FSCardAnimsMng.TANK_DAMAGE_ANIM:
               _loc2_ = 1;
               break;
            case FSCardAnimsMng.ARTILLERY_DAMAGE_ANIM:
               _loc2_ = 1;
               break;
            case FSCardAnimsMng.AIR_DAMAGE_ANIM:
               _loc2_ = 4;
               break;
            case FSCardAnimsMng.SHIP_DAMAGE_ANIM:
               _loc2_ = 3;
               break;
            case FSCardAnimsMng.SUBMARINE_DAMAGE_ANIM:
               _loc2_ = 1;
               break;
            case FSCardAnimsMng.SNIPER_DAMAGE_ANIM:
               _loc2_ = 1;
         }
         return _loc2_;
      }
      
      public function updateStatsAfterAttack(param1:int, param2:Number = 0) : void
      {
         if(param1 <= 0)
         {
            this.touchable = false;
         }
         if(param2 > 0)
         {
            TweenMax.delayedCall(param2,this.setDefense,[param1]);
         }
         else
         {
            this.setDefense(param1);
         }
         if(param2 > 0)
         {
            TweenMax.delayedCall(param2,this.showDamageAndShield,[true]);
         }
         else
         {
            this.showDamageAndShield(true);
         }
      }
      
      public function performDamageAndShieldAnim() : void
      {
         this.showDamageAndShield(true);
      }
      
      public function onCardDefeated() : void
      {
         var _loc1_:int = this.mAttachedToSocket ? this.mAttachedToSocket.getSocketIndex() : -1;
         InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_CARD_DEFEATED,this);
         if(this.mBattleSceneParent)
         {
            this.mBattleSceneParent.suggestPlayableCardON();
         }
         this.detachCard();
         this.createDeathAnimation();
         SpecialFX.tweenToAlpha(this,0.001,Config.getConfig().getDefaultDeathAnimDuration(),0,this.removeCardElemsFromDisplayList);
         if(this.mShadow)
         {
            SpecialFX.tweenToAlpha(this.mShadow,0.001,Config.getConfig().getDefaultDeathAnimDuration(),0);
         }
         this.playOnDefeatSound();
         this.onCardDefeatedPerformPvPChecks();
      }
      
      public function createDeathAnimation(param1:int = 0, param2:int = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(Config.USE_DEATH_ANIM)
         {
            _loc3_ = param1 != 0 ? param1 : int(x);
            _loc4_ = param2 != 0 ? param2 : int(y);
            this.mDeathAnimMC = Utils.createExplosionEffect("death_anim_",_loc3_,_loc4_,true,30,1.25,1.25);
         }
      }
      
      private function onCardDefeatedPerformPvPChecks() : void
      {
         var _loc1_:Boolean = false;
         if(InstanceMng.getBattleEngine())
         {
            if(InstanceMng.getBattleEngine().isOnlineMatch())
            {
               if(InstanceMng.getBattleEngine().isOwnerTurn())
               {
                  _loc1_ = InstanceMng.getBattleEngine().getBattleStateId() == BattleEngine.BATTLE_STATE_PLAYER_MOVING_CARDS;
                  if(_loc1_)
                  {
                     if(!this.isEnemyCard())
                     {
                        PvPConnectionMng.storeStopResumedPvPActions();
                     }
                  }
               }
            }
         }
      }
      
      protected function playOnDefeatSound() : void
      {
         var _loc1_:Array = null;
         var _loc2_:SubCategoryDef = null;
         var _loc3_:int = 0;
         if(Config.getConfig().playSoundOnDefeat())
         {
            _loc1_ = this.mCardDef ? this.mCardDef.getSubCategorySku() : null;
            if(_loc1_)
            {
               _loc2_ = SubCategoryDef(InstanceMng.getSubCategoriesDefMng().getDefBySku(_loc1_[0]));
               _loc3_ = _loc2_ ? _loc2_.getIndex() : -1;
               switch(_loc3_)
               {
                  case SubCategoriesMng.SUBCATEGORY_01:
                  case SubCategoriesMng.SUBCATEGORY_02:
                  case SubCategoriesMng.SUBCATEGORY_05:
                     break;
                  case SubCategoriesMng.SUBCATEGORY_03:
                     Utils.playSound(Constants.SOUND_AIRPLANE_CRASH,SoundManager.TYPE_SFX);
                     break;
                  case SubCategoriesMng.SUBCATEGORY_04:
                     Utils.playSound(Constants.SOUND_SHIP_CRASH,SoundManager.TYPE_SFX);
               }
            }
         }
      }
      
      public function revertCardToActionDeck() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mBattleSceneParent) && Boolean(InstanceMng.getBattleEngine()))
         {
            if(InstanceMng.getBattleEngine().isOnlineMatch())
            {
               PvPConnectionMng.revertLastMovement();
               InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_CARD_REVERTED_TO_DECK,this);
            }
            this.detachCard(true);
            _loc1_ = this.mCardDef.getAPGeneratedOnPlay();
            if(_loc1_ != 0)
            {
               this.mParentUserBattleInfo.increaseAPGenerated(-_loc1_);
            }
            if(this.mParentUserBattleInfo)
            {
               this.mParentUserBattleInfo.addPlayableCard(this);
            }
            this.moveCardBackToItsOriginalDeckSlot(true);
         }
      }
      
      public function moveCardBackToItsOriginalDeckSlot(param1:Boolean = false) : void
      {
         var _loc2_:FSCardSocket = this.mBattleSceneParent.getCardSocketByIndex(this.mPlayableCardId,this.mBattleSceneParent.getOwnerSideDeckSocketCatalog());
         if(_loc2_)
         {
            TweenLite.killTweensOf(this);
            TweenMax.killTweensOf(this);
            this.mFXMouseDown = false;
            this.mIsMoving = false;
            this.mFXMouseTarget = null;
            removeEventListener(TouchEvent.TOUCH,this.onTouch);
            if(param1)
            {
               this.setAttachedToSocket(_loc2_,true);
            }
            SpecialFX.zoomOut(this);
            this.unHighlightAllPlayableItems();
         }
      }
      
      protected function removeMainElements(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = Config.USE_CARD_POOLING;
         if(this.mBG)
         {
            this.mBG.removeFromParent(param1);
            if(!_loc2_)
            {
               this.mBG = null;
            }
            else
            {
               this.mBG.reset();
            }
         }
         if(this.mFrameBG)
         {
            this.mFrameBG.removeFromParent(param1);
            if(!_loc2_)
            {
               this.mFrameBG = null;
            }
            else
            {
               this.mFrameBG.reset();
            }
         }
         if(this.mFactionFrameBG)
         {
            this.mFactionFrameBG.removeFromParent(param1);
            if(this.mFactionFrameBG.filter)
            {
               this.mFactionFrameBG.filter.dispose();
               this.mFactionFrameBG.filter = null;
            }
            if(!_loc2_)
            {
               this.mFactionFrameBG = null;
            }
            else
            {
               this.mFactionFrameBG.reset();
            }
         }
         if(this.mBottomFrameBG)
         {
            this.mBottomFrameBG.removeFromParent(param1);
            if(this.mBottomFrameBG.filter)
            {
               this.mBottomFrameBG.filter.dispose();
               this.mBottomFrameBG.filter = null;
            }
            if(!_loc2_)
            {
               this.mBottomFrameBG = null;
            }
            else
            {
               this.mBottomFrameBG.reset();
            }
         }
         if(this.mTierFrame)
         {
            this.mTierFrame.removeFromParent(param1);
            if(!_loc2_)
            {
               this.mTierFrame = null;
            }
            else
            {
               this.mTierFrame.reset();
            }
         }
         if(this.mBGAnimated)
         {
            this.mBGAnimated.stop();
            Starling.juggler.remove(this.mBGAnimated);
            this.mBGAnimated.removeFromParent(param1);
            this.mBGAnimated = null;
         }
      }
      
      public function removeCardElemsFromDisplayList(param1:Boolean = false) : void
      {
         var sounds:Vector.<String>;
         var checkIfUnloadable:Boolean;
         var bgUnloadable:Boolean;
         var i:int = 0;
         var onDeadAnimationFinished:Function = null;
         var soundUnloadable:Boolean = false;
         var cardAnim:CardAnimation = null;
         var bfPortrait:FSBattlefieldUserPortrait = null;
         var dispose:Boolean = param1;
         onDeadAnimationFinished = function():void
         {
            if(mDeathAnimMC)
            {
               mDeathAnimMC.stop();
               Starling.juggler.remove(mDeathAnimMC);
               mDeathAnimMC.removeFromParent();
               mDeathAnimMC = null;
            }
         };
         var useCardPooling:Boolean = Config.USE_CARD_POOLING;
         dispose = dispose ? !useCardPooling : false;
         var battleEngine:BattleEngine = InstanceMng.getBattleEngine();
         this.removeCardAnims();
         this.removeMainElements(dispose);
         sounds = InstanceMng.getCardsMng().getCardAllPossibleSounds(this);
         if(Boolean(sounds) && sounds.length > 0)
         {
            i = 0;
            while(i < sounds.length)
            {
               if(sounds[i] != null && sounds[i] != "")
               {
                  soundUnloadable = battleEngine != null && this.mCardDef != null && battleEngine.isSoundUnloadable(this,sounds[i]);
                  if(soundUnloadable)
                  {
                     Root.assets.removeSound(sounds[i]);
                  }
               }
               i++;
            }
         }
         if(this.mDamageTextfield)
         {
            this.mDamageTextfield.removeFromParent(dispose);
            this.mDamageTextfield = null;
         }
         if(this.mDefenseTextfield)
         {
            this.mDefenseTextfield.removeFromParent(dispose);
            this.mDefenseTextfield = null;
         }
         Utils.destroyArray(this.mAbilities);
         if(!Config.USE_CARD_POOLING)
         {
            this.mAbilities = null;
         }
         this.mBattleSceneParent = null;
         if(this.mUpgradeCostTextfield)
         {
            this.mUpgradeCostTextfield.removeFromParent(dispose);
            this.mUpgradeCostTextfield = null;
         }
         this.mParentUserBattleInfo = null;
         if(this.mCardAnimsAttached)
         {
            for each(cardAnim in this.mCardAnimsAttached)
            {
               if(cardAnim)
               {
                  cardAnim.unload(true);
                  cardAnim.removeFromParent();
               }
            }
            Utils.destroyArray(this.mCardAnimsAttached);
            this.mCardAnimsAttached = null;
         }
         if(this.mAbilitiesAnimsLayer)
         {
            this.mAbilitiesAnimsLayer.removeFromParent();
            if(!useCardPooling)
            {
               this.mAbilitiesAnimsLayer = null;
            }
         }
         this.removeAbilityIcons(dispose);
         DictionaryUtils.clearDictionary(this.mAbilitiesIcons);
         if(!useCardPooling)
         {
            this.mAbilitiesIcons = null;
         }
         Utils.destroyArray(this.mPreviousTiersCardsDefs);
         this.mPreviousTiersCardsDefs = null;
         DictionaryUtils.disposeCardXL(this.mTempCardXL);
         this.mTempCardXL = null;
         this.mFightingWithCard = null;
         Utils.destroyArray(this.mPlayableSockets);
         if(!useCardPooling)
         {
            this.mPlayableSockets = null;
         }
         if(this.mPlayableBFPortraits)
         {
            for each(bfPortrait in this.mPlayableBFPortraits)
            {
               if(bfPortrait)
               {
                  bfPortrait.deactivateSpecialHighlightParticle();
               }
            }
            Utils.destroyArray(this.mPlayableBFPortraits);
            if(!useCardPooling)
            {
               this.mPlayableBFPortraits = null;
            }
         }
         if(this.mShadowTween)
         {
            this.mShadowTween.kill();
            this.mShadowTween = null;
         }
         if(this.mShadow)
         {
            this.mShadow.removeFromParent(dispose);
            if(!useCardPooling)
            {
               this.mShadow = null;
            }
         }
         if(!useCardPooling)
         {
            if(this.mSummonCooldownImage)
            {
               this.mSummonCooldownImage.removeFromParent(dispose);
               this.mSummonCooldownImage = null;
            }
            if(this.mDamageImage)
            {
               this.mDamageImage.removeFromParent(dispose);
               this.mDamageImage = null;
            }
            if(this.mDefenseImage)
            {
               this.mDefenseImage.removeFromParent(dispose);
               this.mDefenseImage = null;
            }
            if(this.mItemTargetedAnim)
            {
               this.mItemTargetedAnim.removeFromParent(dispose);
               this.mItemTargetedAnim = null;
            }
            if(this.mFrameSummonIcon)
            {
               this.mFrameSummonIcon.removeFromParent();
               this.mFrameSummonIcon.destroy();
               this.mFrameSummonIcon = null;
            }
            if(this.mEnhancedImage)
            {
               this.mEnhancedImage.removeFromParent();
               this.mEnhancedImage.destroy();
               this.mEnhancedImage = null;
            }
            if(this.mFusionIcon)
            {
               this.mFusionIcon.removeFromParent();
               this.mFusionIcon.destroy();
               this.mFusionIcon = null;
            }
            if(this.mChampionImage)
            {
               this.mChampionImage.removeFromParent(true);
               this.mChampionImage.destroy();
               this.mChampionImage = null;
            }
            if(this.mLeaderImage)
            {
               this.mLeaderImage.removeFromParent(true);
               this.mLeaderImage.destroy();
               this.mLeaderImage = null;
            }
            if(this.mDropShadow)
            {
               this.mDropShadow.removeFromParent();
               this.mDropShadow = null;
            }
            if(this.mFusionLayer)
            {
               this.mFusionLayer.removeFromParent(true);
               this.mFusionLayer = null;
            }
            if(this.mDeathAnimMC)
            {
               SpecialFX.tweenToAlpha(this.mDeathAnimMC,0,2,0,onDeadAnimationFinished);
            }
            if(this.mBack)
            {
               this.mBack.removeFromParent();
               this.mBack = null;
            }
            if(this.mSubComponentsContainer)
            {
               this.mSubComponentsContainer.removeChildren();
               this.mSubComponentsContainer = null;
            }
            if(this.mBattleComponents)
            {
               this.mBattleComponents.removeChildren();
               this.mBattleComponents = null;
            }
         }
         this.mAttachedToSocket = null;
         if(this.mSummonTextfield)
         {
            this.mSummonTextfield.removeFromParent();
            this.mSummonTextfield = null;
         }
         if(this.mEnhancedText)
         {
            this.mEnhancedText.removeFromParent(true);
            this.mEnhancedText = null;
         }
         if(this.mAnimAura)
         {
            this.mAnimAura.stop();
            Starling.juggler.remove(this.mAnimAura);
            this.mAnimAura.removeFromParent();
            this.mAnimAura = null;
         }
         this.mBGLightStyle = null;
         if(this.mBGLight)
         {
            this.mBGLight.removeFromParent(true);
            this.mBGLight = null;
         }
         Utils.destroyObject(this.mDefense);
         this.mDefense = null;
         Utils.destroyObject(this.mDamage);
         this.mDamage = null;
         this.mCardTouch = null;
         this.mHelperPoint3D = null;
         smBGIntersectionRect = null;
         smSocketIntersectionRect = null;
         this.mFXDeltaMovementPoint = null;
         this.removeTouchEventListeners();
         removeParticleSystem(true);
         removeFromParent();
         removeChildren();
         checkIfUnloadable = !this.mZoomedIn && battleEngine != null && this.mCardDef != null;
         bgUnloadable = checkIfUnloadable && battleEngine.isBGImageUnloadable(this);
         if(bgUnloadable)
         {
            if(Boolean(this.mCardDef) && this.mCardDef.hasAnimatedBG())
            {
               battleEngine.unloadCardBGResource(this.mCardDef.getAnimatedBG(),true);
            }
            else
            {
               battleEngine.unloadCardBGResource(this.mCardDef.getBGImageName());
            }
         }
      }
      
      public function cardTweeningOver(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc6_:String = null;
         if(param1)
         {
            _loc6_ = this.mAttachedToSocket != null && this.mAttachedToSocket.isBattlefieldSocket() ? Constants.SOUND_CARD_TO_BF : Constants.SOUND_CARD_TO_ACTION_DECK;
            Utils.playSound(_loc6_,SoundManager.TYPE_SFX);
         }
         this.mIsMoving = false;
         this.setIsZoomingOut(false);
         if(this.mShadow)
         {
            this.mUpdateShadow = false;
            this.mShadow.visible = false;
            this.mShadow.setOnDefaultPos();
            this.mShadow.onCardTweeningOver();
         }
         this.setDisableIntersections(false);
         this.checkSummonCooldownFilter();
         this.checkIfFramesNeedToVanish();
         if(this.isOnBF() && Config.getConfig().getCardBGType() == "png")
         {
            if(this.mCardDef.getEnhanceLevel() > 0)
            {
               if(this.mEnhancedImage)
               {
                  this.mEnhancedImage.removeFromParent();
               }
               if(this.mEnhancedText)
               {
                  this.mEnhancedText.removeFromParent();
               }
            }
            if(this.mChampionImage)
            {
               this.mChampionImage.removeFromParent();
            }
            if(this.mLeaderImage)
            {
               this.mLeaderImage.removeFromParent();
            }
         }
         if(Boolean(param2) && Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getBattleScreen()))
         {
            InstanceMng.getBattleEngine().getBattleScreen().createAttachedAnimation(this);
         }
         var _loc3_:BattleEngine = InstanceMng.getBattleEngine();
         var _loc4_:FSBattleScreen = _loc3_ ? _loc3_.getBattleScreen() : null;
         var _loc5_:AbilitiesPanel = _loc4_ ? _loc4_.getAbilitiesChooserPanel() : null;
         if((Boolean(_loc5_)) && Boolean(_loc5_.parent) && _loc5_.visible)
         {
            _loc5_.parent.addChild(_loc5_);
         }
         this.activateDropShadow(true);
      }
      
      private function checkIfFramesNeedToVanish() : void
      {
         if(!Config.getConfig().gameHasTierFrames())
         {
            if(this.isOnBF())
            {
               if(this.mFrameBG)
               {
                  TweenMax.to(this.mFrameBG,Config.getConfig().getDefaultZoomOutTime(),{
                     "alpha":0.001,
                     "ease":Back.easeIn,
                     "onComplete":this.onCardTweeningOverFramesFaded
                  });
               }
               if(this.mFactionFrameBG)
               {
                  TweenMax.to(this.mFactionFrameBG,Config.getConfig().getDefaultZoomOutTime(),{
                     "alpha":0.001,
                     "ease":Back.easeIn,
                     "onComplete":this.onCardTweeningOverFramesFaded
                  });
               }
               if(this.mBottomFrameBG)
               {
                  TweenMax.to(this.mBottomFrameBG,Config.getConfig().getDefaultZoomOutTime(),{
                     "alpha":0.001,
                     "ease":Back.easeIn,
                     "onComplete":this.onCardTweeningOverFramesFaded
                  });
               }
               if(this.mTierFrame)
               {
                  TweenMax.to(this.mTierFrame,Config.getConfig().getDefaultZoomOutTime(),{
                     "alpha":0,
                     "ease":Back.easeIn,
                     "onComplete":this.onCardTweeningOverFramesFaded
                  });
               }
            }
         }
      }
      
      private function onCardTweeningOverFramesFaded() : void
      {
         if(this.mFrameBG)
         {
            this.mFrameBG.visible = false;
            this.mFrameBG.alpha = 0.999;
         }
         if(this.mFactionFrameBG)
         {
            this.mFactionFrameBG.visible = false;
            this.mFactionFrameBG.alpha = 0.999;
         }
         if(this.mBottomFrameBG)
         {
            this.mBottomFrameBG.visible = false;
            this.mBottomFrameBG.alpha = 0.999;
         }
         if(this.mTierFrame)
         {
            this.mTierFrame.visible = false;
            this.mTierFrame.alpha = 0.999;
         }
      }
      
      public function checkSummonCooldownFilter() : void
      {
         if(this.mIsOnBattlefield && !this.mZoomedIn && !this.mIsMoving)
         {
            if(this.isOnSummonCooldown())
            {
               if(this.mSummonCooldownImage == null)
               {
                  this.mSummonCooldownImage = new FSImage(Root.assets.getTexture(Constants.DISABLED_ICON_NAME));
               }
               if(!contains(this.mSummonCooldownImage))
               {
                  this.mSummonCooldownImage.x = this.mDamageImage ? -(this.mSummonCooldownImage.width - this.mDamageImage.width) / 2 : 0;
                  this.mSummonCooldownImage.y = this.mDamageImage ? this.mDamageImage.y - (this.mSummonCooldownImage.height - this.mDamageImage.height) / 2 : height - this.mSummonCooldownImage.height;
               }
               if(this.mBattleComponents)
               {
                  this.mBattleComponents.addChild(this.mSummonCooldownImage);
               }
               this.mSummonCooldownImage.alpha = 0.75;
            }
            else if(this.mSummonCooldownImage != null && contains(this.mSummonCooldownImage))
            {
               this.mSummonCooldownImage.removeFromParent();
            }
            this.getColorForDamageAndDefenseTextfield();
         }
      }
      
      private function getColorForDamageAndDefenseTextfield() : void
      {
         var _loc1_:String = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
         if(this.mType == TYPE_UNIT && FSUnit(this).hasAttachments() || this.mType == TYPE_ATTACHMENT)
         {
            _loc1_ = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_GREEN);
         }
         if(this.mDamageTextfield)
         {
            this.mDamageTextfield.color = 16777215;
            this.mDamageTextfield.fontName = _loc1_;
         }
         if(this.mDefenseTextfield)
         {
            this.mDefenseTextfield.color = 16777215;
            this.mDefenseTextfield.fontName = _loc1_;
         }
      }
      
      public function updateSummonCooldown(param1:int = -1) : void
      {
         this.mSummonCooldownTurnsLeft = param1 == -1 ? int(Math.max(0,this.mSummonCooldownTurnsLeft - 1)) : param1;
         this.checkSummonCooldownFilter();
      }
      
      public function canBePromoted() : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = false;
         var _loc2_:UserBattleInfo = this.getParentUserBattleInfo();
         if(_loc2_)
         {
            _loc3_ = Config.getConfig().gameHasEmblems() && this.getCardDef() is UnitDef ? int(_loc2_.getEmblems()[this.getCardDef().getFactionSku()]) : _loc2_.getActionPointsLeft();
            _loc4_ = Config.getConfig().gameHasEmblems() && this.getCardDef() is UnitDef ? UnitDef(this.getCardDef()).getEmblemRequiredToPromote() : this.getCardDef().getUpgradeCost();
            _loc1_ = !this.isTopTier() && _loc3_ >= _loc4_ && _loc4_ != -1 && this.mIsOnBattlefield;
         }
         return _loc1_;
      }
      
      public function isTopTier() : Boolean
      {
         return CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.getCardDef().getUpgradeSku())) == null;
      }
      
      public function promoteCard(param1:String) : void
      {
         var _loc2_:UserBattleInfo = this.getParentUserBattleInfo();
         var _loc3_:int = Config.getConfig().gameHasEmblems() ? int(_loc2_.getEmblems()[this.getCardDef().getFactionSku()]) : _loc2_.getActionPointsLeft();
         var _loc4_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         var _loc5_:int = Config.getConfig().gameHasEmblems() && this.getCardDef() is UnitDef ? UnitDef(this.getCardDef()).getEmblemRequiredToPromote() : this.getCardDef().getUpgradeCost();
         if(_loc4_ != null && _loc3_ >= _loc5_ && _loc5_ != -1 && this.mIsOnBattlefield)
         {
            if(_loc2_.isOwnerBattleInfo())
            {
               this.trackCardPromoted(_loc5_);
            }
            if(Config.getConfig().gameHasEmblems())
            {
               _loc2_.spendEmblems(this.getCardDef());
               this.mBattleSceneParent.updateEmblems();
            }
            else
            {
               this.mBattleSceneParent.getBattleEngine().notifyActionDone(_loc5_);
            }
            this.onCardPromote(_loc4_);
            this.mBattleSceneParent.setCardAnimsON(true);
            Utils.playSound(Constants.SOUND_PROMOTE_CARD,SoundManager.TYPE_SFX);
         }
      }
      
      public function demoteCard(param1:String) : void
      {
         var _loc2_:CardDef = CardDef(InstanceMng.getCardsDefMng().getDefBySku(param1));
         if(_loc2_)
         {
            this.onCardPromote(_loc2_,false,true);
         }
         if(Boolean(this.mBattleSceneParent) && _loc2_ != null)
         {
            this.mBattleSceneParent.setCardAnimsON(true);
         }
         Utils.playSound(Constants.SOUND_DEBUFF,SoundManager.TYPE_SFX);
      }
      
      public function promoteCardFree(param1:int = -1, param2:Boolean = false) : void
      {
         var _loc4_:CardDef = null;
         var _loc5_:int = 0;
         var _loc6_:CardDef = null;
         var _loc3_:UserBattleInfo = this.getParentUserBattleInfo();
         if(Boolean(_loc3_) && _loc3_.isOwnerBattleInfo())
         {
            _loc5_ = this.getCardDef().getUpgradeCost();
            this.trackCardPromoted(_loc5_);
         }
         _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(this.getCardDef().getUpgradeSku()));
         if((Boolean(_loc4_)) && _loc4_.getTier() < param1)
         {
            _loc4_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc4_.getUpgradeSku()));
         }
         if(param2)
         {
            _loc6_ = CardDef(InstanceMng.getCardsDefMng().getDefBySku(_loc4_.getUpgradeSku()));
            if(_loc6_)
            {
               _loc4_ = _loc6_;
            }
         }
         if(_loc4_)
         {
            this.onCardPromote(_loc4_,true);
         }
         if(Boolean(this.mBattleSceneParent) && _loc4_ != null)
         {
            this.mBattleSceneParent.setCardAnimsON(true);
         }
         Utils.playSound(Constants.SOUND_PROMOTE_CARD,SoundManager.TYPE_SFX);
      }
      
      private function trackCardPromoted(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.mCardDef.getTier();
         if(param1 == 1)
         {
            switch(_loc2_)
            {
               case 1:
                  _loc3_ = ScoreMng.UPGRADE_TIER_1_COST_1;
                  break;
               case 2:
                  _loc3_ = ScoreMng.UPGRADE_TIER_2_COST_1;
            }
         }
         else if(param1 == 2)
         {
            switch(_loc2_)
            {
               case 1:
                  _loc3_ = ScoreMng.UPGRADE_TIER_1_COST_2;
                  break;
               case 2:
                  _loc3_ = ScoreMng.UPGRADE_TIER_2_COST_2;
            }
         }
         else if(param1 == 3)
         {
            switch(_loc2_)
            {
               case 1:
                  _loc3_ = ScoreMng.UPGRADE_TIER_1_COST_3;
                  break;
               case 2:
                  _loc3_ = ScoreMng.UPGRADE_TIER_2_COST_3;
            }
         }
         InstanceMng.getScoreMng().trackAction(_loc3_);
      }
      
      protected function onCardPromote(param1:CardDef, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:String = null;
         this.mIsCardBeingPromoted = true;
         this.touchable = false;
         this.removeTierFrame();
         this.removeCardAnims(true);
         this.removeAbilityIcons();
         this.addPreviousCardDef(this.getCardDef());
         _loc4_ = this.mType == TYPE_UNIT ? Config.getConfig().getDefaultDelayPromoteFadeTextfieldsAnimDuration() : 0;
         SpecialFX.tweenToAlpha(this.mDamageTextfield,0.001,_loc4_,0);
         SpecialFX.tweenToAlpha(this.mDefenseTextfield,0.001,_loc4_,0);
         TweenMax.delayedCall(_loc4_ + 0.01,this.performVisualFXForCardPromote,[param1]);
         if(this.mType == TYPE_UNIT && !param2)
         {
            if(InstanceMng.getBattleEngine().isOnlineMatch())
            {
               BattleEnginePvP(InstanceMng.getBattleEngine()).onCardPromoted(this,param1.getSku(),param3);
            }
         }
         _loc5_ = param3 ? BattleEngine.COMBAT_LOG_CARD_DEMOTED : BattleEngine.COMBAT_LOG_CARD_PROMOTED;
         _loc6_ = param1 ? param1.getSku() + " (" + param1.getName(false,true) + ")" : "???";
         var _loc7_:int = this.mAttachedToSocket ? this.mAttachedToSocket.getSocketIndex() : -1;
         InstanceMng.getBattleEngine().storeCombatLogAction(_loc5_,this,"",{"FUTURE_CARD":_loc6_});
         if(Boolean(param1) && this.mCardDef.getTier() < param1.getTier())
         {
            this.triggerOnPromoteAbilities();
         }
         this.mIsCardBeingPromoted = false;
         if(Config.getConfig().cardBGChangesOnPromote())
         {
            if(this.hasAnimatedBG())
            {
               SpecialFX.tweenToAlpha(this.mBGAnimated,0.001,Config.getConfig().getDefaultDelayPromoteAttachNewFrameAnimDuration(),0);
            }
            else
            {
               SpecialFX.tweenToAlpha(this.mBG,0.001,Config.getConfig().getDefaultDelayPromoteAttachNewFrameAnimDuration(),0);
            }
            InstanceMng.getCardAnimsMng().requestShiningPromoteCardAnim(this);
         }
         if(this.mAbilities)
         {
            this.mAbilities.length = 0;
            this.mAbilities = null;
         }
         if(Config.getConfig().hasQuests())
         {
            InstanceMng.getQuestsMng().onCardPromoted(this);
         }
      }
      
      public function isCardBeingPromoted() : Boolean
      {
         return this.mIsCardBeingPromoted;
      }
      
      protected function performVisualFXForCardPromote(param1:CardDef) : void
      {
         var setBattleScreenParentAnimsOn:Function = null;
         var t:Texture = null;
         var scaleTo:Number = NaN;
         var nextTierCardDef:CardDef = param1;
         setBattleScreenParentAnimsOn = function(param1:Boolean):void
         {
            if(mBattleSceneParent)
            {
               mBattleSceneParent.setCardAnimsON(param1);
            }
            activateDropShadow(true);
         };
         if(nextTierCardDef)
         {
            this.initializeCard(nextTierCardDef,true);
            if(this.isOnSummonCooldown())
            {
               if(Boolean(this.mSummonCooldownImage) && Boolean(this.mSubComponentsContainer))
               {
                  this.mSubComponentsContainer.addChild(this.mSummonCooldownImage);
                  this.mSummonCooldownImage.alpha = 0.75;
               }
            }
            if(this.mType == TYPE_UNIT)
            {
               this.removeSummonFrameIcon();
               if(Config.getConfig().cardBGChangesOnPromote())
               {
                  if(!this.hasAnimatedBG())
                  {
                     t = Root.assets.getTexture(nextTierCardDef.getBGImageName());
                     if(Boolean(t) && Boolean(this.mBG))
                     {
                        this.mBG.texture = t;
                     }
                     SpecialFX.tweenToAlpha(this.mBG,0.999,Config.getConfig().getDefaultDelayPromoteAttachNewFrameAnimDuration(),0,this.setTouchable,[true]);
                  }
               }
               else if(this.mTierFrame)
               {
                  this.mTierFrame.alpha = 0.001;
                  this.mTierFrame.scale = 2;
                  SpecialFX.tweenToAlpha(this.mTierFrame,0.999,Config.getConfig().getDefaultDelayPromoteAttachNewFrameAnimDuration(),0);
                  scaleTo = Config.getConfig().getNoXLTexturesFactor();
                  SpecialFX.createZoomTransition(this.mTierFrame,scaleTo,Config.getConfig().getDefaultDelayPromoteAttachNewFrameAnimDuration(),this.setTouchable,[true]);
               }
               TweenMax.delayedCall(Config.getConfig().getDefaultDelayPromoteAttachNewFrameAnimDuration(),setBattleScreenParentAnimsOn,[false]);
               if(Config.getConfig().playSoundOnPromote())
               {
                  TweenMax.delayedCall(Config.getConfig().getDefaultDelayPromoteAttachNewFrameAnimDuration(),InstanceMng.getSoundFXMng().playCardSound,[this,FSSoundFXMng.PROMOTE]);
               }
            }
            if(this.mShadow)
            {
               this.mShadow.onPromote();
            }
         }
      }
      
      private function setTouchable(param1:Boolean) : void
      {
         this.touchable = param1;
      }
      
      override public function set touchable(param1:Boolean) : void
      {
         param1 = param1 ? !this.isDefeated() : param1;
         super.touchable = param1;
      }
      
      public function createZoomedCard() : void
      {
         if(this.mTempCardXL == null)
         {
            this.mTempCardXL = InstanceMng.getCardsMng().createZoomedCard(this);
         }
         else
         {
            this.onXLCardImageLoaded(true);
         }
      }
      
      public function onXLCardImageLoaded(param1:Boolean = false) : void
      {
         var _loc2_:BattleEngine = null;
         var _loc3_:Boolean = false;
         if(this.isZoomedIn() || this.mIsInfoCard)
         {
            if(!param1)
            {
               this.mTempCardXL.x = Starling.current.stage.stageWidth / 2 - this.mTempCardXL.width / 2;
               this.mTempCardXL.y = Starling.current.stage.stageHeight / 2 - this.mTempCardXL.height / 1.65;
            }
            InstanceMng.getCurrentScreen().addChild(this.mTempCardXL);
            InstanceMng.getCurrentScreen().setZoomedCardXL(this.mTempCardXL);
            this.mTempCardXL.createExtraInfoBlocks();
            this.mTempCardXL.createCardBack();
            if(param1)
            {
               this.mTempCardXL.showDamageAndShield();
               _loc2_ = InstanceMng.getBattleEngine();
               _loc3_ = _loc2_ != null && _loc2_.hasToShowUpgradeCost() || InstanceMng.getCurrentScreen() is FSDeckBuilderScreen;
               if(_loc3_)
               {
                  this.mTempCardXL.createTierFrame();
               }
               this.mTempCardXL.showUpgradeCost();
               this.mTempCardXL.refreshPromoteInfoVisibility();
               this.mTempCardXL.refreshUpgradesThumbnailsVisibility();
            }
         }
      }
      
      public function isCardAttachableToSocket(param1:FSCardSocket, param2:Boolean = false) : Boolean
      {
         return false;
      }
      
      public function highlightPlayablePortraitsVector(param1:Vector.<UserBattleInfo>) : void
      {
         var _loc2_:UserBattleInfo = null;
         var _loc3_:FSBattlefieldUserPortrait = null;
         if(param1 != null)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = _loc2_.getUserBattlePortrait();
               if(_loc3_ != null)
               {
                  if(this.mPlayableBFPortraits == null)
                  {
                     this.mPlayableBFPortraits = new Vector.<FSBattlefieldUserPortrait>();
                  }
                  this.mPlayableBFPortraits.push(_loc3_);
                  if(InstanceMng.getBattleEngine().isOwnerTurn() || InstanceMng.getBattleEngine().isPvPMatch() && !InstanceMng.getBattleEngine().isOnlineMatch())
                  {
                     _loc3_.activateSpecialHighlightParticle();
                  }
               }
            }
         }
      }
      
      public function unHighlightPlayablePortraitsVector(param1:Boolean = false) : void
      {
         var _loc2_:FSBattlefieldUserPortrait = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.mPlayableBFPortraits != null)
         {
            _loc3_ = int(this.mPlayableBFPortraits.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = this.mPlayableBFPortraits.pop();
               if(_loc2_)
               {
                  _loc2_.deactivateSpecialHighlightParticle();
               }
               _loc4_++;
            }
            this.mPlayableBFPortraits.length = 0;
         }
      }
      
      public function unHighlightPlayableSocketsVector(param1:Boolean = false) : void
      {
         var _loc2_:FSCardSocket = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.mPlayableSockets != null)
         {
            _loc3_ = int(this.mPlayableSockets.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = this.mPlayableSockets.pop();
               if(_loc2_)
               {
                  _loc2_.deactivateHighlightTween(param1);
                  _loc2_.activateTargetIntersectedAnim(false);
               }
               _loc4_++;
            }
            this.mPlayableSockets.length = 0;
         }
         this.mPlayableSocketsHighlighted = false;
      }
      
      public function unHighlightAllPlayableItems(param1:Boolean = false) : void
      {
         this.unHighlightPlayableSocketsVector(param1);
         this.unHighlightPlayablePortraitsVector(param1);
         if(this.mAttachedToSocket != null)
         {
            this.mAttachedToSocket.deactivateHighlightTween();
            this.mAttachedToSocket.activateTargetIntersectedAnim(false);
         }
      }
      
      public function highlightPlayableSocketsVector(param1:Boolean = false, param2:Ability = null) : void
      {
         this.mPlayableSocketsHighlighted = true;
      }
      
      public function addCardSocketToPlayableSocketsVector(param1:FSCardSocket) : void
      {
         var _loc2_:FSCardSocket = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(this.mPlayableSockets == null)
         {
            this.mPlayableSockets = new Vector.<FSCardSocket>();
         }
         _loc4_ = false;
         _loc3_ = 0;
         while(_loc3_ < this.mPlayableSockets.length)
         {
            if(this.mPlayableSockets[_loc3_] == param1)
            {
               _loc4_ = true;
               break;
            }
            _loc3_++;
         }
         if(!_loc4_)
         {
            this.mPlayableSockets.push(param1);
         }
      }
      
      public function getPlayableSocketsByAbilityOnCard(param1:Ability) : Vector.<FSCardSocket>
      {
         var _loc2_:Vector.<FSCardSocket> = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         if(param1.canBeExecuted())
         {
            _loc3_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(param1.getAbilityDef(),this,param1.getAbilityDef().getCostRange());
            _loc3_ = this.getAbilityTargetsTierFiltered(param1,_loc3_);
            if(_loc3_ != null)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(_loc4_ is FSCard)
                  {
                     if(param1.getAbilityDef().isCardEligibleForAbility(_loc4_))
                     {
                        if(_loc2_ == null)
                        {
                           _loc2_ = new Vector.<FSCardSocket>();
                        }
                        _loc2_.push(FSCard(_loc4_).getAttachedToSocket());
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function fillSocketsPlayableByAbilitiesOnCard() : Vector.<FSCardSocket>
      {
         var _loc1_:Vector.<FSCardSocket> = null;
         var _loc2_:Array = null;
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         if(this.mAbilities != null)
         {
            _loc4_ = this.mAbilities ? int(this.mAbilities.length) : 0;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = this.mAbilities[_loc5_];
               if(_loc3_.canBeExecuted())
               {
                  _loc2_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(_loc3_.getAbilityDef(),this,_loc3_.getAbilityDef().getCostRange());
                  _loc2_ = this.getAbilityTargetsTierFiltered(_loc3_,_loc2_);
                  if(_loc2_ != null)
                  {
                     for each(_loc6_ in _loc2_)
                     {
                        if(_loc6_ is FSCard)
                        {
                           if(_loc3_.getAbilityDef().isCardEligibleForAbility(_loc6_))
                           {
                              if(_loc1_ == null)
                              {
                                 _loc1_ = new Vector.<FSCardSocket>();
                              }
                              _loc1_.push(FSCard(_loc6_).getAttachedToSocket());
                           }
                        }
                     }
                  }
               }
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function getAbilityTargetsTierFiltered(param1:Ability, param2:Array) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         if(param2 != null)
         {
            for each(_loc4_ in param2)
            {
               if(_loc4_ is FSCard)
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = new Array();
                  }
                  _loc5_ = param1.getAbilityDef().getTargetTierIndex();
                  if(_loc5_ == 0 || _loc5_ == FSCard(_loc4_).getCardDef().getTier())
                  {
                     _loc3_.push(FSCard(_loc4_));
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function fillUserBattleInfosPlayableByAbilitiesOnCard() : Vector.<UserBattleInfo>
      {
         var _loc1_:Vector.<UserBattleInfo> = null;
         var _loc2_:Array = null;
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         if(this.mAbilities != null)
         {
            _loc4_ = this.mAbilities ? int(this.mAbilities.length) : 0;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = this.mAbilities[_loc5_];
               if(_loc3_.canBeExecuted())
               {
                  _loc2_ = InstanceMng.getAbilitiesMng().getEligibleTargetsByTargetIndex(_loc3_.getAbilityDef(),this,_loc3_.getAbilityDef().getCostRange());
               }
               _loc5_++;
            }
         }
         if(_loc2_ != null)
         {
            for each(_loc6_ in _loc2_)
            {
               if(_loc6_ is UserBattleInfo)
               {
                  if(_loc1_ == null)
                  {
                     _loc1_ = new Vector.<UserBattleInfo>();
                  }
                  _loc1_.push(UserBattleInfo(_loc6_));
               }
            }
         }
         return _loc1_;
      }
      
      public function getExtraDefenseGainedByAbilities(param1:FSCard) : int
      {
         var _loc2_:int = 0;
         var _loc3_:AbilityDef = null;
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Boolean = false;
         _loc2_ = 0;
         _loc3_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_REINFORCED);
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.getShield();
         }
         _loc3_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_EVASION);
         if(_loc3_ != null)
         {
            if(param1 != null)
            {
               _loc5_ = param1.getCardDef().getSubCategorySku();
               _loc6_ = param1.getCardDef().getGroupsIds();
               _loc7_ = _loc3_.getSubCategorySku();
               _loc8_ = _loc3_.getGroupsIds();
               _loc9_ = false;
               if(_loc7_ != null)
               {
                  _loc9_ = Utils.isAnySubcategorySkuAllowed(_loc7_,_loc5_);
               }
               else if(_loc8_ != null)
               {
                  _loc9_ = Utils.isAnyGroupIdAllowed(_loc8_,_loc6_);
               }
               if(_loc9_)
               {
                  _loc2_ += _loc3_.getShield();
                  if(!this.isEnemyCard() && Config.getConfig().battleHasAffinities())
                  {
                     this.mParentUserBattleInfo.getUserBattlePortrait().onAffinityTriggeredPlayEffects();
                  }
               }
            }
         }
         _loc4_ = this is FSUnit && FSUnit(this).getInvulnerableTurns() > 0;
         if(_loc4_)
         {
            _loc2_ += param1.getDamage();
         }
         return _loc2_;
      }
      
      public function getAbilityDefByKeyName(param1:String) : AbilityDef
      {
         var _loc2_:AbilityDef = null;
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:AbilityDef = null;
         _loc4_ = this.mAbilities ? int(this.mAbilities.length) : 0;
         _loc5_ = param1 == AbilitiesMng.SPECIAL_REINFORCED;
         _loc6_ = null;
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc3_ = this.mAbilities[_loc7_];
            _loc8_ = _loc3_.getAbilityDef();
            if(_loc8_ != null)
            {
               if(_loc8_.isSpecial())
               {
                  if(_loc8_.getKeyName() == param1)
                  {
                     if(!_loc5_)
                     {
                        return _loc8_;
                     }
                     if(_loc6_ == null)
                     {
                        _loc6_ = new Array();
                     }
                     _loc6_.push(_loc8_);
                  }
               }
            }
            _loc7_++;
         }
         if(Boolean(_loc6_) && _loc6_.length > 0)
         {
            _loc6_.sort(DictionaryUtils.sortAbilitiesDefsByShield);
            return AbilityDef(_loc6_[0]);
         }
         return _loc2_;
      }
      
      override public function activateHighlightTween(param1:uint = 65280, param2:Boolean = true, param3:Number = 1, param4:ColorArgb = null, param5:ColorArgb = null, param6:Boolean = false) : void
      {
         mHighlightRequested = true;
         TweenMax.killDelayedCallsTo(removeParticleSystem);
         if(this.mItemTargetedAnim == null)
         {
            this.mItemTargetedAnim = new FSItemTargetedAnim(param6);
            this.mItemTargetedAnim.width *= 0.7;
            this.mItemTargetedAnim.height *= 0.7;
         }
         else
         {
            this.mItemTargetedAnim.setIsHovered(param6);
         }
         TweenMax.killTweensOf(this.mItemTargetedAnim);
         TweenMax.killDelayedCallsTo(this.onItemTargetAnimMotionOff);
         if(this.hasAnimatedBG())
         {
            this.mItemTargetedAnim.x = this.mBGAnimated ? this.mBGAnimated.x + this.mBGAnimated.width / 2 : width / 2;
            this.mItemTargetedAnim.y = this.mBGAnimated ? this.mBGAnimated.y + this.mBGAnimated.height / 2 : height / 2;
         }
         else
         {
            this.mItemTargetedAnim.x = this.mBG ? this.mBG.x + this.mBG.width / 2 : width / 2;
            this.mItemTargetedAnim.y = this.mBG ? this.mBG.y + this.mBG.height / 2 : height / 2;
         }
         if(!this.mItemTargetedAnim.isMotionStarted())
         {
            this.mItemTargetedAnim.startMotion(true);
         }
         if(this.mSubComponentsContainer)
         {
            this.mSubComponentsContainer.addChild(this.mItemTargetedAnim);
         }
      }
      
      override public function deactivateHighlightTween(param1:Boolean = false) : void
      {
         if(Utils.isBrowser())
         {
            if(Config.getConfig().gameHasTierFrames())
            {
               if(filter)
               {
                  filter.clearCache();
                  filter.dispose();
                  filter = null;
               }
            }
            else if(this.hasAnimatedBG())
            {
               if(Boolean(this.mBGAnimated) && Boolean(this.mBGAnimated.filter))
               {
                  this.mBGAnimated.filter.dispose();
                  this.mBGAnimated.filter = null;
               }
            }
            else if(Boolean(this.mBG) && Boolean(this.mBG.filter))
            {
               this.mBG.filter.dispose();
               this.mBG.filter = null;
            }
         }
         if(Boolean(this.mItemTargetedAnim) && this.mItemTargetedAnim.isMotionStarted())
         {
            this.mItemTargetedAnim.startMotion(false,this.onItemTargetAnimMotionOff);
         }
         mHighlightRequested = false;
         super.deactivateHighlightTween(param1);
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
         var _loc2_:Boolean = false;
         var _loc3_:FSImage = null;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         _loc2_ = Boolean(param1) && Boolean(param1.getAbilityDef()) && !(param1.getAbilityDef().getAnimKey() == null || param1.getAbilityDef().getAnimKey() == "");
         if(Boolean(param1 != null) && Boolean(param1.getAbilityDef()) && !_loc2_)
         {
            _loc3_ = new FSImage(Root.assets.getTexture(param1.getAbilityDef().getBGXLImageName()),false);
            _loc3_.alignPivot();
            if(_loc3_ != null)
            {
               _loc4_ = InstanceMng.getAbilitiesMng() ? InstanceMng.getAbilitiesMng().isPersistentAbilityIcon(param1) : false;
               if(_loc4_)
               {
                  _loc3_.alignPivot();
                  if(this.mSubComponentsContainer)
                  {
                     if(this.mFrameBG)
                     {
                        _loc3_.x = this.mFrameBG.width / 2;
                        _loc3_.y = this.mFrameBG.height / 2;
                     }
                     else if(this.mFactionFrameBG)
                     {
                        _loc3_.x = this.mFactionFrameBG.width / 2;
                        _loc3_.y = this.mFactionFrameBG.height / 2;
                     }
                     this.mSubComponentsContainer.addChild(_loc3_);
                  }
               }
               else if(this.mSubComponentsContainer)
               {
                  _loc3_.scaleX *= 2;
                  _loc3_.scaleY *= 2;
                  if(this.mFrameBG)
                  {
                     _loc3_.x = this.mFrameBG.width / 2;
                     _loc3_.y = this.mFrameBG.height / 2;
                  }
                  else if(this.mFactionFrameBG)
                  {
                     _loc3_.x = this.mFactionFrameBG.width / 2 - _loc3_.width / 2;
                     _loc3_.y = this.mFactionFrameBG.height / 2 - _loc3_.height / 2;
                  }
                  this.mSubComponentsContainer.addChild(_loc3_);
               }
               if(!_loc4_)
               {
                  _loc5_ = CardAnimation.getMaxDuration() * 3;
                  SpecialFX.tweenToAlpha(_loc3_,0.001,_loc5_,0,this.removeABImageFromParent,[_loc3_]);
               }
            }
         }
      }
      
      private function removeABImageFromParent(param1:FSImage) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      public function getCompositeAbilitiesVector(param1:int = -1000) : Vector.<Ability>
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<Ability> = null;
         var _loc4_:Vector.<Ability> = null;
         var _loc5_:Vector.<Ability> = null;
         var _loc6_:Vector.<Ability> = null;
         var _loc7_:Ability = null;
         if(!Config.smAbilitiesOn || Boolean(this.getParentUserBattleInfo() && !this.getParentUserBattleInfo().isOwnerBattleInfo()) && Boolean(!Config.smAIAbilitiesOn))
         {
            return null;
         }
         _loc3_ = Utils.createAbilitiesVectorCopy(this.getAbilities());
         if(this is FSUnit)
         {
            _loc6_ = this.getUsableAbilitiesFromAttachments();
            _loc5_ = _loc6_ != null ? Utils.createAbilitiesVectorCopy(_loc6_) : null;
         }
         _loc3_ = Utils.mergeAbilitiesVectors(_loc3_,_loc5_);
         if(param1 != -1000 && _loc3_ != null)
         {
            for each(_loc7_ in _loc3_)
            {
               if(_loc7_.getAbilityDef().getTriggerIndex() == param1)
               {
                  if(_loc4_ == null)
                  {
                     _loc4_ = new Vector.<Ability>();
                  }
                  _loc4_.push(_loc7_);
               }
            }
         }
         else
         {
            _loc4_ = _loc3_;
         }
         this.sortAbilitiesBySku(_loc4_);
         return _loc4_;
      }
      
      public function getUsableAbilitiesFromAttachments() : Vector.<Ability>
      {
         return null;
      }
      
      public function getUsableAbilitiesDefsFromAttachments() : Vector.<AbilityDef>
      {
         return null;
      }
      
      public function calculateTimeEllapsedForTriggeringAbilities() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Vector.<Ability> = null;
         var _loc3_:Ability = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         _loc1_ = 0;
         _loc2_ = this.getCompositeAbilitiesVector();
         if(_loc2_ != null)
         {
            _loc4_ = this.mAbilities ? int(this.mAbilities.length) : 0;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = this.mAbilities[_loc5_];
               if(_loc3_.canBeExecutedAndHasTargets())
               {
                  _loc1_ += Config.getConfig().getDefaultAbilityAnimDuration();
                  if(_loc3_.hasAnimation() && Config.getConfig().getShowAbilitiesAnimations())
                  {
                     _loc6_ = _loc3_.getAbilityDef().getAnimDuration() * Config.getConfig().getDefaultGeneralSpeedFactor();
                     _loc1_ += _loc6_ > 0 ? _loc6_ : CardAnimation.getMaxDuration();
                  }
               }
               else
               {
                  _loc7_ = this.hasScoutDivisionAndIsTriggereable();
                  _loc8_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_CODEINTERCEPTION) != null || this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_MASSCODEINTERCEPTION) != null;
                  if(_loc7_ || _loc8_)
                  {
                     _loc1_ += Config.getConfig().getDefaultZoomOutTime() * 2;
                  }
               }
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function getAbilityByAbSku(param1:String, param2:Boolean = false) : Ability
      {
         var _loc3_:Ability = null;
         var _loc4_:Ability = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = null;
         _loc5_ = this.mAbilities ? int(this.mAbilities.length) : 0;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = this.mAbilities[_loc6_];
            if(_loc4_.getAbilityDef().getSku() == param1)
            {
               return _loc4_;
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public function isInfoCard() : Boolean
      {
         return this.mIsInfoCard;
      }
      
      public function setIsInfoCard(param1:Boolean) : void
      {
         this.mIsInfoCard = param1;
      }
      
      public function getSummonCooldownTurnsLeft() : int
      {
         return this.mSummonCooldownTurnsLeft;
      }
      
      public function isOnBF() : Boolean
      {
         return this.mIsOnBattlefield;
      }
      
      public function isDefeated() : Boolean
      {
         return this.mDefeated;
      }
      
      public function getDamageImage() : FSImage
      {
         return this.mDamageImage;
      }
      
      public function getAttachments() : Vector.<FSAttachment>
      {
         return null;
      }
      
      public function getAttachmentsAmount() : int
      {
         return 0;
      }
      
      public function hasAnimatedBG() : Boolean
      {
         return this.mCardDef.hasAnimatedBG();
      }
      
      public function updateSummonCost(param1:AbilityDef) : void
      {
         this.mSummonCost = this.getCardCostByType(param1);
         if(this.mSummonTextfield)
         {
            this.mSummonTextfield.text = this.mSummonCost.toString();
            this.formatSummonCostTextfield();
         }
         this.formatSummonIconTexture();
      }
      
      private function formatSummonCostTextfield() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.getOriginalSummonCost();
         if(this.mSummonTextfield)
         {
            this.mSummonTextfield.fontName = this.mSummonCost != _loc1_ ? FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN) : FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
         }
      }
      
      public function getCardSummonCost() : int
      {
         return this.mSummonCost;
      }
      
      public function activateDropShadow(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(param1)
         {
            if(!(this is FSCardPreview))
            {
               this.createDropShadowBG();
            }
         }
         _loc2_ = this.isDropShadowAvailableToSetVisible();
         if(Boolean(Config.getConfig().getCardHasDropShadow()) && Boolean(this.mDropShadow) && _loc2_)
         {
            this.mDropShadow.visible = param1;
         }
         if(Boolean(this.mDropShadow && this.mAttachedToSocket) && Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getBattleEngine().getBattleScreen()))
         {
            _loc3_ = InstanceMng.getBattleEngine().getBattleScreen().canApplyEffectPlayableToCardSocketPromote(this.mAttachedToSocket,InstanceMng.getBattleEngine().isOwnerTurn());
            _loc4_ = !this.mAttachedToSocket.isBattlefieldSocket() && InstanceMng.getBattleEngine().getBattleScreen().canApplyEffectPlayableToCardSocketSummon(this.mAttachedToSocket,InstanceMng.getBattleEngine().isOwnerTurn());
            _loc5_ = !InstanceMng.getBattleEngine().isOwnerTurn() && (!InstanceMng.getBattleEngine().isPvPMatch() || InstanceMng.getBattleEngine().isPvPMatch() && InstanceMng.getBattleEngine().isOnlineMatch() && PvPConnectionMng.isPlayingVSAI());
            this.mDropShadow.alpha = Config.getConfig().getActivateSuggestPlayable() && !_loc5_ && (_loc3_ || _loc4_) ? 0 : 1;
         }
      }
      
      public function setupDropshadow() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Screen = null;
         var _loc3_:int = 0;
         if(this.mDropShadow)
         {
            _loc1_ = this.isDropShadowAvailableToSetVisible();
            this.mDropShadow.visible = _loc1_;
            this.setCardDropShadowAlpha(1);
            this.setDropShadowSize();
            this.mDropShadow.alignPivot();
            _loc2_ = InstanceMng.getCurrentScreen();
            if(_loc2_)
            {
               if(parent != null && _loc2_ is FSDeckBuilderScreen)
               {
                  parent.addChild(this.mDropShadow);
               }
               else
               {
                  _loc3_ = this.mAttachedToSocket ? _loc2_.getChildIndex(this.mAttachedToSocket) : _loc2_.getChildIndex(this);
                  _loc3_ = _loc3_ != -1 ? _loc3_ : 0;
                  _loc2_.addChildAt(this.mDropShadow,_loc3_);
               }
               if(this.mAttachedToSocket == null && parent != null)
               {
                  parent.addChild(this);
               }
               this.mDropShadow.x = x;
               this.mDropShadow.y = y;
               this.mDropShadow.rotation = rotation;
               this.addSpecialFX();
            }
         }
      }
      
      public function setDropShadowSize() : void
      {
         if(this.mDropShadow)
         {
            this.mDropShadow.rotation = this.mAttachedToSocket ? this.mAttachedToSocket.rotation : rotation;
            this.mDropShadow.width = this.mAttachedToSocket ? this.mAttachedToSocket.width * 1.15 : width * 1.15;
            this.mDropShadow.height = this.mAttachedToSocket ? this.mAttachedToSocket.height * 1.15 : height * 1.15;
         }
      }
      
      public function addSpecialFX() : void
      {
         if(this.isUnit() && this is FSUnit && FSUnit(this).isAirUnit() && InstanceMng.getCurrentScreen() is FSDeckBuilderScreen)
         {
            this.createFloatingFX();
            this.createGlidingFX(3);
         }
      }
      
      override public function set alpha(param1:Number) : void
      {
         super.alpha = param1;
         if(this.mDropShadow)
         {
            this.mDropShadow.alpha = param1;
         }
      }
      
      private function createGlidingFX(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = 3;
         SpecialFX.create3DYoYoTransition(this,_loc2_,{
            "rotationY":deg2rad(param1),
            "repeat":0
         },this.createGlidingFX,[param1 * -1],Sine.easeInOut);
         SpecialFX.create3DYoYoTransition(this.mDropShadow,_loc2_,{
            "rotationY":deg2rad(param1),
            "repeat":0
         },null,null,Sine.easeInOut);
      }
      
      private function createFloatingFX() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = 10;
         _loc2_ = 6;
         if(this.mDropShadow)
         {
            this.setDropShadowSize();
            SpecialFX.create3DYoYoTransition(this,_loc2_,{
               "z":_loc1_,
               "repeat":-1
            },null,null,Sine.easeInOut);
            SpecialFX.create3DYoYoTransition(this,_loc2_,{
               "scale":scale * 1.06,
               "repeat":-1
            },null,null,Sine.easeInOut);
            SpecialFX.create3DYoYoTransition(this.mDropShadow,_loc2_,{
               "z":_loc1_ / 2,
               "repeat":-1
            },null,null,Sine.easeInOut);
            SpecialFX.create3DYoYoTransition(this.mDropShadow,_loc2_,{
               "repeat":-1,
               "scale":this.mDropShadow.scale * 1.15,
               "alpha":0.5
            },null,null,Sine.easeInOut);
         }
      }
      
      protected function createDropShadowBG() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:FSImage = null;
         _loc1_ = this.isDropShadowAvailableToSetVisible();
         _loc2_ = _loc1_ && !this.isRewardCard() && (InstanceMng.getCurrentScreen() is FSDeckBuilderScreen || InstanceMng.getCurrentScreen() is FSBattleScreen);
         if(Config.getConfig().getCardHasDropShadow() && _loc2_ && this.mDropShadow == null)
         {
            this.mDropShadow = new Sprite3D();
            _loc3_ = new FSImage(Root.assets.getTexture("card_dropshadow"),false);
            this.mDropShadow.addChild(_loc3_);
            this.mDropShadow.visible = false;
            this.mDropShadow.touchable = false;
         }
         this.setupDropshadow();
      }
      
      private function isDropShadowAvailableToSetVisible() : Boolean
      {
         var _loc1_:Boolean = false;
         return !(this is FSAttachment) || this is FSAttachment && this.mAttachedToSocket && !this.mAttachedToSocket.isBattlefieldSocket();
      }
      
      public function setCardDropShadowAlpha(param1:int) : void
      {
         var _loc2_:Boolean = false;
         if(this.mDropShadow)
         {
            _loc2_ = this.isDropShadowAvailableToSetVisible();
            if(_loc2_ || param1 == 0)
            {
               this.mDropShadow.alpha = param1;
            }
         }
      }
      
      public function getCardDropShadow() : Sprite3D
      {
         return this.mDropShadow;
      }
      
      public function removeDropShadow() : void
      {
         if(this.mDropShadow)
         {
            this.mDropShadow.removeFromParent();
         }
      }
      
      public function setIsRewardCard(param1:Boolean) : void
      {
         this.mIsRewardCard = param1;
      }
      
      public function isRewardCard() : Boolean
      {
         return this.mIsRewardCard;
      }
      
      public function getRotationTimeToDefaultPos(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         _loc2_ = 0;
         if(rotationX != 0 || rotationY != 0)
         {
            _loc2_ = param1 / 2;
         }
         return _loc2_;
      }
      
      public function createFusionLayer() : void
      {
         if(this.mFusionLayer == null)
         {
            if(this.mCardDef.isFusion())
            {
               this.mFusionLayer = new CardFusionLayer(this);
            }
            else
            {
               this.mFusionLayer = new CardCraftLayer(this);
            }
         }
         this.mFusionLayer.x = width / 2;
         this.mFusionLayer.y = height / 2;
         this.mSubComponentsContainer.addChild(this.mFusionLayer);
      }
      
      public function setIsZoomingOut(param1:Boolean) : void
      {
         this.mIsZoomingOut = param1;
      }
      
      public function isZoomingOut() : Boolean
      {
         return this.mIsZoomingOut;
      }
      
      public function getCostModifierAbilityDef() : AbilityDef
      {
         var _loc2_:Boolean = false;
         var _loc3_:AbilityDef = null;
         var _loc4_:AbilityDef = null;
         var _loc5_:AbilityDef = null;
         var _loc1_:Boolean = this is FSAction;
         _loc2_ = this is FSPower;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         if(Boolean(this.mParentUserBattleInfo) && !_loc2_)
         {
            if(this.mParentUserBattleInfo.isFixedSummonCostActive())
            {
               _loc4_ = this.mParentUserBattleInfo.getFixedSummonCostAbilityDef();
               _loc3_ = (Boolean(_loc4_)) && _loc4_.isCardEligibleForAbility(this) ? _loc4_ : null;
            }
            if(this.mParentUserBattleInfo.isModifiedCostActive())
            {
               _loc5_ = this.mParentUserBattleInfo.getExtraSummonCostAbilityDef();
               _loc3_ = (Boolean(_loc5_)) && _loc5_.isCardEligibleForAbility(this) ? _loc5_ : _loc3_;
            }
         }
         return _loc3_;
      }
      
      public function getTransitionCardTime(param1:int) : Number
      {
         var _loc2_:int = 0;
         _loc2_ = 1;
         switch(param1)
         {
            case DEFAULT_MOVE_ELEVATED_CARD_TIME:
               return 0.05 * Utils.getDefaultSpeedTime();
            case DEFAULT_ELEVATE_CARD_FOR_ATTACK_TIME:
               return 0.55 * Utils.getDefaultSpeedTime();
            case DEFAULT_DELAY_BEFORE_ATTACK_TIME:
               return 0.5 * Utils.getDefaultSpeedTime();
            default:
               return _loc2_;
         }
      }
      
      public function startNotEnoughAPEffect() : void
      {
         if(this.mSummonTextfield)
         {
            this.mSummonTextfield.color = 16777215;
            SpecialFX.tweenToColor(this.mSummonTextfield,0.2,16711680,3);
         }
      }
      
      public function getSoundFXAudioNames() : Vector.<String>
      {
         var returnValue:Vector.<String> = null;
         var catalog:Dictionary = null;
         var s:String = null;
         var abs:Vector.<Ability> = null;
         var i:int = 0;
         var addSoundToVec:Function = function(param1:String):void
         {
            if(Boolean(param1) && param1 != "")
            {
               if(catalog == null)
               {
                  catalog = new Dictionary(true);
               }
               if(catalog[param1] == null)
               {
                  catalog[param1] = 1;
                  if(returnValue == null)
                  {
                     returnValue = new Vector.<String>();
                  }
                  returnValue.push(param1);
               }
            }
         };
         returnValue = null;
         catalog = new Dictionary(true);
         if(Boolean(this.mCardDef) && this.isUnit())
         {
            s = UnitDef(this.mCardDef).getDamageAudioName();
            addSoundToVec(s);
         }
         abs = this.getCompositeAbilitiesVector();
         if(Boolean(abs) && abs.length > 0)
         {
            i = 0;
            while(i < abs.length)
            {
               s = abs[i].getAbilityDef().getSoundName();
               addSoundToVec(s);
               i++;
            }
         }
         return returnValue;
      }
      
      private function sortAbilitiesBySku(param1:Vector.<Ability>) : void
      {
         var abs:Vector.<Ability> = param1;
         var printAbs:Function = function(param1:Boolean):void
         {
            var _loc2_:int = 0;
            if(Config.isDebug())
            {
               FSDebug.debugTrace("*************");
               FSDebug.debugTrace(param1 ? "BEFORE sorting abs" : "AFTER sorting abs","Abs");
               _loc2_ = 0;
               while(_loc2_ < abs.length)
               {
                  FSDebug.debugTrace("Ability: " + abs[_loc2_].getAbilityDef().getSku(),"Abs");
                  _loc2_++;
               }
               if(!param1)
               {
                  FSDebug.debugTrace("*************");
               }
            }
         };
         if(abs)
         {
            abs.sort(DictionaryUtils.sortAbilitiesBySku);
         }
      }
      
      public function isQuestConditionOKForCraft() : Boolean
      {
         var _loc1_:UserData = null;
         var _loc2_:Boolean = false;
         _loc1_ = Utils.getOwnerUserData();
         _loc2_ = this.mCardDef.needsQuestToCraft() && _loc1_ != null ? _loc1_.isQuestAlreadyClaimed(this.mCardDef.getCraftQuestSku()) : true;
         return _loc1_ ? _loc2_ : false;
      }
      
      public function hasWellEquipped(param1:FSCard) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:AbilityDef = null;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         _loc2_ = param1.getCardDef().getFactionSku();
         _loc3_ = this.getAbilityDefByKeyName(AbilitiesMng.SPECIAL_WELLEQUIPED);
         _loc4_ = _loc3_ ? _loc3_.getFactionSku() : "";
         return _loc4_ == null || _loc4_ == _loc2_;
      }
      
      public function getStoredOldSocketIndexCode() : String
      {
         return this.mOldSocketIndexCode;
      }
      
      public function setStoredOldSocketIndexCode(param1:String) : void
      {
         this.mOldSocketIndexCode = param1;
      }
      
      public function getCostModifiedByAbility() : String
      {
         return this.mCostModifiedByAbility;
      }
      
      public function setCostModifiedByAbility(param1:String) : void
      {
         this.mCostModifiedByAbility = param1;
      }
      
      public function setStoredEligibleItemCode(param1:String) : void
      {
         this.mPvPStoredEligibleItemCode = param1;
      }
      
      public function setStoredAbilitySku(param1:String) : void
      {
         this.mPvPStoredAbilitySku = param1;
      }
      
      public function getStoredEligibleItemCode() : String
      {
         return this.mPvPStoredEligibleItemCode;
      }
      
      public function getStoredAbilitySku() : String
      {
         return this.mPvPStoredAbilitySku;
      }
   }
}

