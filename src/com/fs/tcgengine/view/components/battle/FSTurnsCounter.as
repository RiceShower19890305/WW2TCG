package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class FSTurnsCounter extends Component
   {
      
      public static const BG_IMAGE_ASSET_TEXT_NAME:String = "button_turn_text";
      
      public static const BG_IMAGE_ASSET_AMOUNT_NAME:String = "button_turn_number";
      
      public static const AMOUNT_TEXTFIELD_DEFAULT_FONT:String = FSResourceMng.getFontByType();
      
      private const BG_IMAGE_ASSET_NAME:String = "turns_value_panel";
      
      protected var mBG:FSImage;
      
      protected var mTitleTextfield:FSTextfield;
      
      protected var mAmountTextfield:FSTextfield;
      
      private var mProgressBar:MovieClip;
      
      private var mProgressBarGauge:FSGaugeProgressBar;
      
      private var mProgressBarMaxValue:int;
      
      protected var mBGAmount:FSImage;
      
      protected var mHasSimpleTurns:Boolean = Config.getConfig().gameTurnsSimple();
      
      protected var mAttackButton:FSAttackButton = this.retrieveAttackButton();
      
      private var mHasSimpleUI:Boolean = Config.getConfig().battleHasSimpleUI();
      
      public function FSTurnsCounter(param1:int)
      {
         this.mProgressBarMaxValue = param1;
         super();
         this.init();
         touchable = false;
      }
      
      private function retrieveAttackButton() : FSAttackButton
      {
         var _loc1_:Screen = InstanceMng.getCurrentScreen();
         return _loc1_ != null && _loc1_ is FSBattleScreen ? FSBattleScreen(_loc1_).getAttackButton() : null;
      }
      
      private function init() : void
      {
         this.createBG();
         this.createTitleTextfield();
         this.createAmountTextfield();
         this.createProgressBar();
      }
      
      private function createProgressBar() : void
      {
         var _loc1_:FSBattleScreen = null;
         var _loc2_:Boolean = false;
         _loc1_ = InstanceMng.getCurrentScreen() is FSBattleScreen ? FSBattleScreen(InstanceMng.getCurrentScreen()) : null;
         if(this.mHasSimpleUI)
         {
            if(this.mProgressBar == null)
            {
               this.mProgressBar = new MovieClip(Root.assets.getTextures("time_bar_bg_"));
               this.mProgressBar.stop();
               this.mProgressBar.touchable = false;
               if(_loc1_ != null)
               {
                  this.mProgressBar.x = _loc1_.getAttackButton().x + _loc1_.getAttackButton().width / 2 - this.mProgressBar.width * Config.getConfig().battleGetTurnsUIFactorX();
                  this.mProgressBar.y = _loc1_.getAttackButton().y - _loc1_.getAttackButton().height / Config.getConfig().battleGetTurnsUIFactorY();
                  this.mProgressBar.rotation = deg2rad(Config.getConfig().battleGetTurnsUIRotation());
                  Starling.juggler.add(this.mProgressBar);
                  _loc1_.addChild(this.mProgressBar);
               }
            }
            this.mProgressBar.fps = 30;
         }
         else
         {
            this.mProgressBarGauge = new FSGaugeProgressBar("","turns_panel",1,false,-1,false);
            _loc2_ = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().isPvPMatch() : false;
            if(!_loc2_)
            {
               this.mProgressBarGauge.touchable = true;
               this.mProgressBarGauge.setTooltipText(TextManager.getText("TID_TURNS_PANEL_INFO"));
            }
            else
            {
               this.mProgressBarGauge.touchable = false;
            }
            this.mProgressBarGauge.setRatio(1);
            if(_loc1_ != null)
            {
               this.mProgressBarGauge.x = _loc1_.getAttackButton().x + _loc1_.getAttackButton().getButton().width / 2;
               this.mProgressBarGauge.y = _loc1_.getAttackButton().y - this.mProgressBarGauge.height / 2;
            }
            _loc1_.addChild(this.mProgressBarGauge);
         }
      }
      
      protected function createBG() : void
      {
         var _loc2_:String = null;
         if(this.mHasSimpleTurns)
         {
            return;
         }
         var _loc1_:Boolean = Config.getConfig().battleTurnsCounterSplitIn2();
         if(this.mBG == null)
         {
            _loc2_ = _loc1_ ? BG_IMAGE_ASSET_TEXT_NAME : this.BG_IMAGE_ASSET_NAME;
            this.mBG = new FSImage(Root.assets.getTexture(_loc2_));
            this.mBG.touchable = false;
            addChild(this.mBG);
         }
         if(_loc1_)
         {
            if(this.mBGAmount == null)
            {
               this.mBGAmount = new FSImage(Root.assets.getTexture(BG_IMAGE_ASSET_AMOUNT_NAME));
               this.mBGAmount.alignPivot();
               this.mBGAmount.touchable = false;
               this.mBGAmount.x = this.mBG.x + this.mBG.width + 1 + this.mBGAmount.width / 2;
               this.mBGAmount.y = this.mBG.y + this.mBGAmount.height / 2;
               addChild(this.mBGAmount);
            }
         }
      }
      
      public function getBG() : FSImage
      {
         return this.mBG;
      }
      
      protected function createTitleTextfield() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mTitleTextfield == null) && Boolean(this.mBG) && !this.mHasSimpleTurns)
         {
            _loc1_ = TextManager.getText("TID_GEN_LEVEL_TURNS").toUpperCase();
            this.mTitleTextfield = new FSTextfield(this.mBG.width,this.mBG.height * 0.4,_loc1_,16777215);
            this.mTitleTextfield.touchable = false;
            this.mTitleTextfield.fontName = FSResourceMng.getFontByType();
            this.mTitleTextfield.fontSize = FSResourceMng.FONT_STD_SMALL_SIZE;
            this.mTitleTextfield.x = (this.mBG.width - this.mTitleTextfield.width) / 2;
            this.mTitleTextfield.y = 0;
            if(Config.getConfig().battleTurnsCounterSplitIn2())
            {
               this.mTitleTextfield.format.horizontalAlign = Align.CENTER;
               this.mTitleTextfield.height = this.mBG.height;
               this.mTitleTextfield.x += 5;
               this.mTitleTextfield.fontName = FSResourceMng.getFontByType();
            }
         }
         if(this.mTitleTextfield)
         {
            addChild(this.mTitleTextfield);
         }
      }
      
      protected function createAmountTextfield() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mAmountTextfield == null && !this.mHasSimpleTurns)
         {
            _loc1_ = Config.getConfig().battleTurnsCounterSplitIn2() ? int(this.mBGAmount.width) : int(this.mBG.width * 0.9);
            _loc2_ = Config.getConfig().battleTurnsCounterSplitIn2() ? int(this.mBGAmount.height) : int(this.mBG.height - this.mTitleTextfield.height);
            this.mAmountTextfield = new FSTextfield(_loc1_,_loc2_,"",16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mAmountTextfield.touchable = false;
            this.mAmountTextfield.alignPivot();
            this.mAmountTextfield.fontName = AMOUNT_TEXTFIELD_DEFAULT_FONT;
            this.mAmountTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            if(Config.getConfig().battleTurnsCounterSplitIn2())
            {
               this.mAmountTextfield.x = this.mBGAmount.x;
               this.mAmountTextfield.y = this.mBGAmount.y;
            }
            else
            {
               this.mAmountTextfield.x = (this.mBG.width - this.mAmountTextfield.width) / 2 + this.mAmountTextfield.width / 2;
               this.mAmountTextfield.y = this.mTitleTextfield.y + this.mTitleTextfield.height + this.mAmountTextfield.height / 2;
            }
         }
         if(this.mAmountTextfield)
         {
            addChild(this.mAmountTextfield);
         }
      }
      
      protected function getAmountTextfield() : FSTextfield
      {
         if(this.mHasSimpleTurns)
         {
            if(this.mAttackButton == null)
            {
               this.mAttackButton = this.retrieveAttackButton();
            }
            if(this.mAttackButton != null)
            {
               return this.mAttackButton.mTurnsTextfield;
            }
            return null;
         }
         return this.mAmountTextfield;
      }
      
      public function updateCounterAmount(param1:String, param2:int = 4) : void
      {
         var _loc3_:Array = null;
         if(this.mHasSimpleTurns)
         {
            if(this.mAttackButton == null)
            {
               this.mAttackButton = this.retrieveAttackButton();
            }
            this.mAttackButton.updateTurnsForSimpleCounter(param1,param2);
            this.updateProgressBar(int(param1));
         }
         else
         {
            if(this.mAmountTextfield != null)
            {
               this.mAmountTextfield.text = param1;
            }
            this.updateProgressBar(int(param1));
            if(int(param1) < param2 && param1 != "--")
            {
               this.startAlertEffects();
            }
            else
            {
               if(this.mAmountTextfield.fontName != AMOUNT_TEXTFIELD_DEFAULT_FONT)
               {
                  this.mAmountTextfield.fontName = AMOUNT_TEXTFIELD_DEFAULT_FONT;
               }
               if(this.mAmountTextfield)
               {
                  TweenMax.killTweensOf(this.mAmountTextfield);
               }
               this.mAmountTextfield.scaleX = 1;
               this.mAmountTextfield.scaleY = 1;
            }
            if(Config.getConfig().battleTurnsCounterRotate() && Boolean(this.mBGAmount))
            {
               _loc3_ = TweenMax.getTweensOf(this.mBGAmount);
               if(_loc3_ == null || Boolean(_loc3_) && Boolean(_loc3_.length == 0))
               {
                  SpecialFX.tweenRotate(this.mBGAmount,8,-1,Linear.easeIn);
               }
            }
         }
      }
      
      protected function updateProgressBar(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Tween = null;
         var _loc5_:Number = NaN;
         if(param1 >= 0)
         {
            if(this.mHasSimpleUI)
            {
               _loc2_ = this.mProgressBar.numFrames - 1;
               _loc3_ = Math.floor(_loc2_ - _loc2_ * param1 / this.mProgressBarMaxValue);
               if(_loc3_ != this.mProgressBar.currentFrame)
               {
                  _loc4_ = new Tween(this.mProgressBar,0.3);
                  Starling.juggler.add(_loc4_);
                  if(this.mProgressBar.numFrames >= _loc3_ && _loc3_ >= 0)
                  {
                     _loc4_.animate("currentFrame",_loc3_);
                  }
               }
            }
            else
            {
               _loc5_ = param1 / this.mProgressBarMaxValue;
               if(Boolean(this.mProgressBarGauge) && this.mProgressBarGauge.getRatio() != _loc5_)
               {
                  this.mProgressBarGauge.setRatio(_loc5_);
               }
            }
         }
      }
      
      public function updateProgressBarMaxValue(param1:int) : void
      {
         this.mProgressBarMaxValue = param1;
      }
      
      protected function startAlertEffects() : void
      {
         var _loc1_:Array = null;
         if(this.mAmountTextfield)
         {
            if(this.mAmountTextfield.fontName != FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED))
            {
               this.mAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_RED);
            }
            _loc1_ = TweenMax.getTweensOf(this.mAmountTextfield);
            if(_loc1_ == null || Boolean(_loc1_) && Boolean(_loc1_.length == 0))
            {
               SpecialFX.createYoYoZoomTransition(this.mAmountTextfield,1.8,1,-1,null,null,false);
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGAmount)
         {
            this.mBGAmount.removeFromParent(true);
            this.mBGAmount = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
            this.mAmountTextfield = null;
         }
         if(this.mProgressBar)
         {
            this.mProgressBar.stop();
            Starling.juggler.remove(this.mProgressBar);
            this.mProgressBar.removeFromParent(true);
            this.mProgressBar = null;
         }
         if(this.mProgressBarGauge)
         {
            this.mProgressBarGauge.removeFromParent(true);
            this.mProgressBarGauge = null;
         }
         super.dispose();
      }
      
      public function getProgressBar() : *
      {
         return this.mHasSimpleUI ? this.mProgressBar : this.mProgressBarGauge;
      }
   }
}

