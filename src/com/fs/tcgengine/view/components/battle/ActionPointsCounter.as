package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.LevelDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSPower;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.TouchEvent;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class ActionPointsCounter extends Component
   {
      
      public static const AP_MODE_BOX:int = 0;
      
      public static const AP_MODE_TEXTFIELD:int = 1;
      
      public static const AP_MODE_BOX_TEXTFIELD:int = 2;
      
      public static const AP_MODE_BOX_TEXTFIELD_LIMITED:int = 3;
      
      public static const AP_MODE_PROG_BAR_TEXTFIELD:int = 4;
      
      private const CONTAINER_BG_NAME:String = "ap_bg";
      
      private const AP_POINT_BOX_BG_NAME:String = "ap_crate_bf";
      
      private var mAPBoxesVec:Vector.<FSImage>;
      
      private var mIsOwner:Boolean;
      
      private var mTextfield:FSTextfield;
      
      private var mTextfieldBG:FSImage;
      
      private var mAPLeft:FSNumber;
      
      private var mAPShowMode:Number;
      
      private var mActionPointLeftMc:MovieClip;
      
      private var mFullAPAmount:int;
      
      private var mProgressBar:FSGaugeProgressBar;
      
      private var mProgressBarFG:FSImage;
      
      public function ActionPointsCounter(param1:Boolean)
      {
         super();
         this.mIsOwner = param1;
         this.mAPShowMode = Config.getConfig().getActionPointsShowMode();
         this.init();
      }
      
      public function getAPShowMode() : Number
      {
         return this.mAPShowMode;
      }
      
      private function init() : void
      {
         if(this.mAPShowMode == AP_MODE_PROG_BAR_TEXTFIELD)
         {
            this.createProgressBar();
         }
         if(this.mAPShowMode != AP_MODE_BOX)
         {
            this.createTextfieldBG();
            this.createTextfield();
            this.createAPAnimation();
         }
      }
      
      private function createProgressBar() : void
      {
         if(this.mProgressBarFG == null)
         {
            this.mProgressBarFG = new FSImage(Root.assets.getTexture("action_points_bar_frame"));
            addChild(this.mProgressBarFG);
         }
         if(this.mProgressBar == null)
         {
            this.mProgressBar = new FSGaugeProgressBar("","action_points_bar",1,false,this.mProgressBarFG.width);
            this.mProgressBar.alignPivot();
            this.mProgressBar.x = this.mProgressBarFG.x + this.mProgressBarFG.width / 2;
            this.mProgressBar.y = this.mProgressBarFG.y + this.mProgressBarFG.height / 2;
            this.mProgressBar.setRatio(0.75);
            this.mProgressBar.touchable = false;
            addChildAt(this.mProgressBar,0);
         }
      }
      
      public function refreshAnimationPosition() : void
      {
         if(this.mActionPointLeftMc)
         {
            this.mActionPointLeftMc.x = x - this.mActionPointLeftMc.width * 0.3;
            this.mActionPointLeftMc.y = y - this.mActionPointLeftMc.height * 0.3;
            if(InstanceMng.getCurrentScreen() is FSBattleScreen)
            {
               FSBattleScreen(InstanceMng.getCurrentScreen()).addChild(this.mActionPointLeftMc);
            }
         }
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this.refreshAnimationPosition();
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         this.refreshAnimationPosition();
      }
      
      private function createAPAnimation(param1:int = 0) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Texture> = null;
         if(this.mActionPointLeftMc == null && Config.getConfig().gameHasActionPointAnimation())
         {
            _loc2_ = "ap_use";
            _loc3_ = 20;
            _loc4_ = Root.assets.getTextures(_loc2_ + "_");
            if((Boolean(_loc4_)) && _loc4_.length > 0)
            {
               if(this.mActionPointLeftMc == null)
               {
                  this.mActionPointLeftMc = new MovieClip(_loc4_,_loc3_);
                  this.mActionPointLeftMc.touchable = false;
               }
               Starling.juggler.add(this.mActionPointLeftMc);
               this.mActionPointLeftMc.stop();
               this.mActionPointLeftMc.visible = false;
               this.mActionPointLeftMc.scaleX = 0.75;
               this.mActionPointLeftMc.scaleY = 0.75;
               if(InstanceMng.getCurrentScreen() is FSBattleScreen)
               {
                  FSBattleScreen(InstanceMng.getCurrentScreen()).addChild(this.mActionPointLeftMc);
               }
            }
            else if(param1 < 3)
            {
               TweenMax.delayedCall(0.1,this.createAPAnimation,[param1 + 1]);
            }
         }
      }
      
      private function createOneAPBox() : void
      {
         var _loc1_:FSImage = null;
         if(this.mAPBoxesVec == null)
         {
            this.mAPBoxesVec = new Vector.<FSImage>();
         }
         _loc1_ = new FSImage(Root.assets.getTexture(this.AP_POINT_BOX_BG_NAME));
         _loc1_.alignPivot();
         _loc1_.x = this.mAPShowMode == AP_MODE_BOX_TEXTFIELD_LIMITED ? _loc1_.width / 2 - _loc1_.width * 1 : _loc1_.width - _loc1_.width * 0;
         _loc1_.y = this.mAPShowMode == AP_MODE_BOX_TEXTFIELD_LIMITED ? _loc1_.height / 2 - (_loc1_.height - this.mTextfieldBG.height) / 2 : _loc1_.height / 2;
         _loc1_.rotation = deg2rad(Utils.randomNumber(-15,15));
         _loc1_.alpha = 0;
         SpecialFX.tweenToAlpha(_loc1_,0.999,0.5,0);
         addChild(_loc1_);
         this.mAPBoxesVec.push(_loc1_);
         SpecialFX.tweenToAlpha(_loc1_,0.3,0.5,0);
      }
      
      private function updateProgressBar(param1:int, param2:int) : void
      {
         var _loc3_:Number = param1 / param2;
         if(Boolean(this.mProgressBar) && this.mProgressBar.getRatio() != _loc3_)
         {
            this.mProgressBar.setValueAnimated(param1 / param2,0.25);
         }
      }
      
      private function showAPBoxes() : void
      {
         var _loc1_:FSImage = null;
         var _loc2_:int = 0;
         if(this.mAPBoxesVec == null)
         {
            this.mAPBoxesVec = new Vector.<FSImage>();
         }
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.mAPBoxesVec.length)
         {
            if(_loc2_ < this.getAPLeft())
            {
               _loc1_ = this.mAPBoxesVec[_loc2_];
               if(_loc1_)
               {
                  SpecialFX.tweenToAlpha(_loc1_,0.999,0.5,0);
                  _loc3_++;
               }
            }
            _loc2_++;
         }
         if(_loc3_ < this.getAPLeft())
         {
            _loc2_ = _loc3_;
            while(_loc2_ < this.getAPLeft())
            {
               if(_loc2_ < this.getAPLeft())
               {
                  _loc1_ = new FSImage(Root.assets.getTexture(this.AP_POINT_BOX_BG_NAME));
                  _loc1_.alignPivot();
                  _loc1_.x = this.mAPShowMode == AP_MODE_BOX_TEXTFIELD ? _loc1_.width / 2 - _loc1_.width * (_loc2_ + 1) : _loc1_.width - _loc1_.width * _loc2_;
                  _loc1_.y = this.mAPShowMode == AP_MODE_BOX_TEXTFIELD ? _loc1_.height / 2 - (_loc1_.height - this.mTextfieldBG.height) / 2 : _loc1_.height / 2;
                  _loc1_.rotation = deg2rad(Utils.randomNumber(-15,15));
                  _loc1_.alpha = 0;
                  SpecialFX.tweenToAlpha(_loc1_,0.999,0.5,0);
                  addChild(_loc1_);
                  this.mAPBoxesVec.push(_loc1_);
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         if(this.mAPBoxesVec.length > _loc3_)
         {
            _loc2_ = _loc3_;
            while(_loc2_ < this.mAPBoxesVec.length)
            {
               _loc1_ = this.mAPBoxesVec[_loc2_];
               if(_loc1_)
               {
                  SpecialFX.tweenToAlpha(_loc1_,0.3,0.5,0);
               }
               _loc2_++;
            }
         }
      }
      
      private function createTextfieldBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:LevelDef = null;
         var _loc3_:UserData = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         if(this.mTextfieldBG == null)
         {
            _loc1_ = Config.getConfig().battleHasSimpleUI() ? "ap_value_panel" : "action_points_layer";
            this.mTextfieldBG = new FSImage(Root.assets.getTexture(_loc1_));
            _loc2_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getLevelDef() : null;
            _loc3_ = Utils.getOwnerUserData();
            _loc4_ = Boolean(_loc3_) && _loc3_.getCurrentDifficulty() == UserDataMng.DIFFICULTY_EASY;
            if(Boolean(_loc2_) && Boolean(_loc2_.getLevelIndex() < 30) && _loc4_)
            {
               _loc5_ = TextManager.getText("TID_BATTLE_ACTIONPOINTS_INFO");
               if(_loc5_ != null && _loc5_ != "")
               {
                  this.mTextfieldBG.setTooltipText(_loc5_);
                  this.mTextfieldBG.addEventListener(TouchEvent.TOUCH,this.onBGTouched);
               }
            }
            this.mTextfieldBG.x = this.mAPShowMode == AP_MODE_PROG_BAR_TEXTFIELD ? this.mProgressBarFG.x + this.mProgressBarFG.width * 1.05 : 0;
            this.mTextfieldBG.y = this.mAPShowMode == AP_MODE_PROG_BAR_TEXTFIELD ? this.mProgressBarFG.y : 0;
            addChild(this.mTextfieldBG);
         }
      }
      
      private function onBGTouched(param1:TouchEvent) : void
      {
         if(param1.getTouch(this.mTextfieldBG))
         {
            this.mTextfieldBG.showTooltip();
         }
         else
         {
            this.mTextfieldBG.closeTooltip();
         }
      }
      
      private function createTextfield() : void
      {
         if(this.mTextfield == null)
         {
            this.mTextfield = new FSTextfield(this.mTextfieldBG.width * 0.95,this.mTextfieldBG.height,"0");
            this.mTextfield.alignPivot();
            this.mTextfield.touchable = false;
            this.mTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mTextfield.fontSize = Config.getConfig().battleHasSimpleUI() ? FSResourceMng.FONT_STD_TITLE_SIZE : FSResourceMng.FONT_STD_DEFAULT_SIZE;
            this.mTextfield.format.horizontalAlign = Config.getConfig().battleHasSimpleUI() ? Align.CENTER : Align.RIGHT;
            this.mTextfield.x = this.mTextfieldBG.x + this.mTextfieldBG.width / 2;
            this.mTextfield.y = this.mTextfieldBG.y + this.mTextfieldBG.height / 2;
            addChild(this.mTextfield);
         }
      }
      
      public function updateActionPointsLeft(param1:int, param2:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:UserBattleInfo = this.mIsOwner ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
         if(param2)
         {
            _loc4_ = this.mIsOwner ? int(InstanceMng.getBattleEngine().getLevelDef().getMaxActionPoints()) : int(InstanceMng.getBattleEngine().getLevelDef().getMaxAIActionPoints());
            param1 = param1 > _loc4_ && _loc4_ > 0 ? _loc4_ : param1;
            this.setFullAPAmount(param1);
         }
         if(this.mAPLeft)
         {
            if(this.mAPLeft.value > Number(param1))
            {
               this.showAnimationAPLeft();
            }
         }
         this.setAPLeft(param1);
         this.updateProgressBar(param1,this.mFullAPAmount);
         if(this.mAPShowMode != AP_MODE_TEXTFIELD && this.mAPShowMode != AP_MODE_BOX_TEXTFIELD_LIMITED)
         {
            this.showAPBoxes();
         }
         else if(this.mAPShowMode == AP_MODE_BOX_TEXTFIELD_LIMITED)
         {
            this.createOneAPBox();
         }
         if(this.mTextfield)
         {
            _loc5_ = param1 > this.mFullAPAmount ? param1 : this.mFullAPAmount;
            this.updateVisualCurrentAPs(_loc5_);
         }
         this.enableDisablePowerButton(InstanceMng.getBattleEngine().isOwnerTurn());
      }
      
      private function enableDisablePowerButton(param1:Boolean) : void
      {
         var _loc2_:FSPower = null;
         var _loc3_:Boolean = false;
         if(Config.getConfig().gameHasPowers())
         {
            _loc2_ = param1 ? InstanceMng.getBattleEngine().getOwnerPower() : InstanceMng.getBattleEngine().getOpponentPower();
            _loc3_ = param1 ? InstanceMng.getBattleEngine().isOwnerPowerActive() : InstanceMng.getBattleEngine().isOpponentPowerActive();
            if(_loc2_ != null)
            {
               if(Number(_loc2_.getCardCostByType()) > this.mAPLeft.value)
               {
                  if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                  {
                     if(_loc3_)
                     {
                        if(param1)
                        {
                           InstanceMng.getBattleEngine().enableOwnerPowerButton(false);
                        }
                        else
                        {
                           InstanceMng.getBattleEngine().enableOpponentPowerButton(false);
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function showAnimationAPLeft() : void
      {
         if(this.mActionPointLeftMc)
         {
            this.onAnimationOver();
            this.mActionPointLeftMc.play();
            this.mActionPointLeftMc.visible = true;
            Utils.playSound("ap_anim_fx",SoundManager.TYPE_SFX);
            TweenMax.delayedCall(1,this.onAnimationOver);
         }
      }
      
      private function onAnimationOver() : void
      {
         TweenMax.killDelayedCallsTo(this.onAnimationOver);
         if(this.mActionPointLeftMc)
         {
            this.mActionPointLeftMc.stop();
            this.mActionPointLeftMc.visible = false;
         }
      }
      
      public function getAPLeft() : int
      {
         return this.mAPLeft ? int(this.mAPLeft.value) : 0;
      }
      
      public function setAPLeft(param1:int) : void
      {
         if(this.mAPLeft == null)
         {
            this.mAPLeft = new FSNumber();
         }
         this.mAPLeft.value = Number(param1);
      }
      
      public function startZoomTransition(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FSImage = null;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         if(Boolean(this.mAPBoxesVec) && this.mAPBoxesVec.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAPBoxesVec.length)
            {
               _loc3_ = this.mAPBoxesVec[_loc2_];
               if(_loc3_)
               {
                  _loc4_ = param1 ? Boolean(_loc3_) && _loc3_.alpha == 0.999 : Boolean(_loc3_) && _loc3_.alpha != 0.999;
                  if(_loc4_)
                  {
                     _loc6_ = TweenMax.getTweensOf(_loc3_);
                     if(_loc6_ != null && _loc6_.length == 0)
                     {
                        SpecialFX.createYoYoZoomTransition(_loc3_,1.2,1,-1,null,null,false);
                        _loc5_ = param1 ? 0.3 : 0.999;
                        SpecialFX.createYoYoAlphaTransition(_loc3_,_loc5_,0.4);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function stopZoomTransition() : void
      {
         var _loc1_:int = 0;
         var _loc2_:FSImage = null;
         var _loc3_:Array = null;
         if(Boolean(this.mAPBoxesVec) && this.mAPBoxesVec.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mAPBoxesVec.length)
            {
               _loc2_ = this.mAPBoxesVec[_loc1_];
               if(_loc2_ != null)
               {
                  _loc3_ = TweenMax.getTweensOf(_loc2_);
                  if(_loc3_ != null && _loc3_.length > 0)
                  {
                     TweenMax.killTweensOf(_loc2_);
                     _loc2_.scaleX = 1;
                     _loc2_.scaleY = 1;
                  }
               }
               _loc1_++;
            }
            if(this.mAPShowMode != AP_MODE_TEXTFIELD && this.mAPShowMode != AP_MODE_BOX_TEXTFIELD_LIMITED)
            {
               this.showAPBoxes();
            }
            else if(this.mAPShowMode == AP_MODE_BOX_TEXTFIELD_LIMITED)
            {
               this.createOneAPBox();
            }
         }
      }
      
      public function triggerNotEnoughAPAnim() : void
      {
         this.startZoomTransition(true);
         TweenMax.delayedCall(2,this.stopZoomTransition);
      }
      
      override public function dispose() : void
      {
         var _loc1_:FSImage = null;
         var _loc2_:int = 0;
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mTextfieldBG)
         {
            this.mTextfieldBG.removeFromParent(true);
            this.mTextfieldBG = null;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent(true);
            this.mProgressBar = null;
         }
         if(this.mProgressBarFG)
         {
            this.mProgressBarFG.removeFromParent(true);
            this.mProgressBarFG = null;
         }
         if(this.mAPBoxesVec)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mAPBoxesVec.length)
            {
               _loc1_ = this.mAPBoxesVec[_loc2_];
               _loc1_.removeFromParent();
               _loc1_.destroy();
               _loc2_++;
            }
            Utils.destroyArray(this.mAPBoxesVec);
            this.mAPBoxesVec = null;
         }
         if(this.mActionPointLeftMc)
         {
            this.mActionPointLeftMc.stop();
            Starling.juggler.remove(this.mActionPointLeftMc);
            this.mActionPointLeftMc.removeFromParent();
            this.mActionPointLeftMc = null;
         }
         Utils.destroyObject(this.mAPLeft);
         this.mAPLeft = null;
         super.dispose();
      }
      
      public function getAPTextfield() : FSTextfield
      {
         return this.mTextfield;
      }
      
      public function getFullAPAmount() : int
      {
         return this.mFullAPAmount;
      }
      
      public function setFullAPAmount(param1:int) : void
      {
         var _loc2_:String = this.mIsOwner ? "Owner" : "Opponent";
         if(Boolean(InstanceMng.getBattleEngine()) && this.mFullAPAmount != param1)
         {
            InstanceMng.getBattleEngine().storeCombatLogAction(BattleEngine.COMBAT_LOG_MAX_AP_MODIFIED,null,"",{
               "TARGET":_loc2_,
               "VALUE":this.mFullAPAmount + " -> " + param1
            });
         }
         this.mFullAPAmount = param1;
      }
      
      public function updateVisualCurrentAPs(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(this.mTextfield)
         {
            _loc2_ = TweenMax.getTweensOf(this.mTextfield);
            if(_loc2_ != null && _loc2_.length > 0)
            {
               _loc6_ = TweenMax(_loc2_[0])._duration;
               TweenMax(_loc2_[0]).totalProgress(_loc6_);
            }
            _loc3_ = this.mIsOwner ? int(InstanceMng.getBattleEngine().getLevelDef().getMaxActionPoints()) : int(InstanceMng.getBattleEngine().getLevelDef().getMaxAIActionPoints());
            _loc4_ = param1 > _loc3_ && _loc3_ > 0 ? _loc3_ : param1;
            this.setFullAPAmount(_loc4_);
            _loc5_ = this.mAPLeft.value > this.mFullAPAmount ? this.mFullAPAmount : int(this.mAPLeft.value);
            if(Config.getConfig().battleAPViewerAnimateTextfield())
            {
               _loc7_ = "/" + this.mFullAPAmount;
               _loc8_ = this.mTextfield.text.indexOf("/");
               _loc9_ = int(this.mTextfield.text.substring(0,_loc8_));
               _loc10_ = int(this.mTextfield.text.substring(_loc8_ + 1));
               if(this.mTextfield.text != _loc5_ + _loc7_)
               {
                  SpecialFX.createComplexTextfieldAmountTransition(this.mTextfield,_loc9_,_loc5_,_loc10_,this.mFullAPAmount,1,true,null,null,Linear.easeIn,_loc7_);
               }
            }
            else
            {
               this.mTextfield.text = _loc5_.toString() + "/" + param1;
            }
         }
      }
      
      public function startNotEnoughAPEffect() : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.color = 16777215;
            SpecialFX.tweenToColor(this.mTextfield,0.2,16711680,3);
            SpecialFX.createYoYoZoomTransition(this.mTextfield,1.5,0.25,1,null,null,false);
         }
      }
   }
}

