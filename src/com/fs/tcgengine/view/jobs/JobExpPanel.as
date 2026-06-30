package com.fs.tcgengine.view.jobs
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.JobsMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.JobLevelsDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Ease;
   import com.greensock.easing.Sine;
   import starling.events.Event;
   import starling.utils.Align;
   
   public class JobExpPanel extends Component
   {
      
      private static const LEFT_RIGHT_IMAGE:String = "level_up_animation_wing";
      
      private static const CENTER_IMAGE:String = "level_up_animation_circle";
      
      private static const REWARD_BG_IMAGE:String = "level_up_layer_info";
      
      private var mJobDef:JobDef;
      
      private var mProgressBar:FSGaugeProgressBar;
      
      private var mBG:FSImage;
      
      private var mHighlightsBG:FSImage;
      
      private var mExpWon:Number;
      
      private var mPreviousExp:Number;
      
      private var mPostExp:Number;
      
      private var mLevelBG:FSImage;
      
      private var mLevelTextfield:FSTextfield;
      
      private var mJobNameTextfield:FSTextfield;
      
      private var mRewardImg:FSImage;
      
      private var mRewardTextfield:FSTextfield;
      
      private var mLevelUpEffect1:FSImage;
      
      public function JobExpPanel(param1:JobDef, param2:Number, param3:Number, param4:Number)
      {
         this.mJobDef = param1;
         this.mPreviousExp = param3;
         this.mPostExp = param4;
         this.mExpWon = param2;
         super();
         this.createUI();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         InstanceMng.getCurrentScreen().addChild(this);
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createProgressBar();
         this.createLevelBG();
         this.createHighlightBG();
         this.createJobNameTextfield();
         this.createLevelTextfield();
         this.createRewardImage();
         this.createRewardTextfield();
         this.createSpecialFX();
         alignPivot();
      }
      
      private function createSpecialFX() : void
      {
         if(this.mLevelUpEffect1 == null)
         {
            this.mLevelUpEffect1 = new FSImage(Root.assets.getTexture("job_effect_1"));
            this.mLevelUpEffect1.scale = 5;
            this.mLevelUpEffect1.alignPivot();
            this.mLevelUpEffect1.x = this.mProgressBar.x + this.mProgressBar.width / 2;
            this.mLevelUpEffect1.y = this.mLevelBG.height / 2;
            this.mLevelUpEffect1.visible = false;
         }
      }
      
      private function createLevelBG() : void
      {
         if(this.mLevelBG == null)
         {
            this.mLevelBG = new FSImage(Root.assets.getTexture(this.mJobDef.getLevelUpFrame()));
            this.mLevelBG.alignPivot();
            this.mLevelBG.x = this.mProgressBar.x + this.mProgressBar.width / 2;
            this.mLevelBG.y = this.mLevelBG.height / 2;
            addChild(this.mLevelBG);
         }
      }
      
      private function createLevelTextfield() : void
      {
         var _loc1_:JobLevelsDef = null;
         if(this.mLevelTextfield == null)
         {
            _loc1_ = InstanceMng.getJobLevelsDefMng().getJobLevelDefByJobExp(this.mPreviousExp);
            if(_loc1_)
            {
               this.mLevelTextfield = new FSTextfield(this.mProgressBar.width / 3,this.mProgressBar.height * 0.8,_loc1_.getLevel().toString());
               this.mLevelTextfield.format.horizontalAlign = Align.CENTER;
               this.mLevelTextfield.alignPivot();
               this.mLevelTextfield.x = this.mProgressBar.x + this.mProgressBar.width / 2;
               this.mLevelTextfield.y = this.mLevelTextfield.height / 2;
               addChild(this.mLevelTextfield);
            }
         }
      }
      
      private function createJobNameTextfield() : void
      {
         if(this.mJobNameTextfield == null)
         {
            this.mJobNameTextfield = new FSTextfield(this.mBG.width / 4,this.mProgressBar.height * 0.8,this.mJobDef.getName());
            this.mJobNameTextfield.format.horizontalAlign = Align.CENTER;
            this.mJobNameTextfield.x = this.mJobNameTextfield.width / 8;
            this.mJobNameTextfield.y = 0;
            addChild(this.mJobNameTextfield);
         }
      }
      
      private function createProgressBar() : void
      {
         var _loc1_:Number = NaN;
         if(this.mProgressBar == null)
         {
            this.mProgressBar = new FSGaugeProgressBar("","job_level_progress",1,false,this.mBG.width * 0.5);
            _loc1_ = this.getRatioToShow(true);
            this.mProgressBar.x = (this.mBG.width - this.mProgressBar.width) / 2;
            this.mProgressBar.y = this.mProgressBar.y;
            if(_loc1_ >= 0)
            {
               this.mProgressBar.setRatio(_loc1_);
               this.mProgressBar.touchable = false;
               addChild(this.mProgressBar);
               addChild(this.mBG);
            }
         }
      }
      
      private function getRatioToShow(param1:Boolean) : Number
      {
         var _loc2_:Number = param1 ? this.mPreviousExp : this.mPostExp;
         var _loc3_:JobLevelsDef = InstanceMng.getJobLevelsDefMng().getJobLevelDefByJobExp(_loc2_);
         var _loc4_:Number = _loc3_ ? _loc3_.getMaxXP() - _loc3_.getMinXP() : 0;
         if(_loc3_ == null)
         {
            return 1;
         }
         return (_loc2_ - _loc3_.getMinXP()) / _loc4_;
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture("job_level_popup"),false);
            addChild(this.mBG);
         }
      }
      
      private function createHighlightBG() : void
      {
         if(this.mHighlightsBG == null)
         {
            this.mHighlightsBG = new FSImage(Root.assets.getTexture("job_effect_3"),false);
            this.mHighlightsBG.scale = 2;
            this.mHighlightsBG.alignPivot();
            this.mHighlightsBG.x = this.mProgressBar.x + this.mProgressBar.width / 2;
            this.mHighlightsBG.y = this.mHighlightsBG.height / 2;
            this.mHighlightsBG.visible = false;
            addChild(this.mHighlightsBG);
         }
      }
      
      private function createRewardImage() : void
      {
         var _loc1_:String = null;
         if(this.mRewardImg == null)
         {
            _loc1_ = JobsMng.getRewardAsset(this.mJobDef);
            if(_loc1_)
            {
               this.mRewardImg = new FSImage(Root.assets.getTexture(JobsMng.getRewardAsset(this.mJobDef)));
               this.mRewardImg.x = this.mProgressBar.x + this.mProgressBar.width + 5;
               this.mRewardImg.y = 5;
               addChild(this.mRewardImg);
            }
         }
      }
      
      private function createRewardTextfield() : void
      {
         if(Boolean(this.mRewardImg) && this.mRewardTextfield == null)
         {
            this.mRewardTextfield = new FSTextfield(this.mBG.width / 7,this.mProgressBar.height * 0.8,JobsMng.getRewardDesc(this.mJobDef));
            this.mRewardTextfield.x = this.mRewardImg.x + this.mRewardImg.width + 5;
            this.mRewardTextfield.y = this.mRewardImg.y;
            addChild(this.mRewardTextfield);
         }
      }
      
      public function showPanel() : void
      {
         FSResourceMng.addToStage(this,FSResourceMng.LAYER_UI);
         var _loc1_:FSCoordinate = new FSCoordinate(x,height / 2);
         SpecialFX.createTransition(this,_loc1_,0.5,0,this.performProgressBarTransition,null,Back.easeOut);
      }
      
      private function performProgressBarTransition(param1:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Function = null;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:Ease = null;
         var _loc8_:Number = NaN;
         var _loc2_:Boolean = !param1 ? JobsMng.willLevelUpAfterWinningExp(this.mJobDef,this.mPreviousExp,this.mExpWon) : false;
         if(this.mProgressBar)
         {
            if(param1)
            {
               this.mProgressBar.setRatio(0);
            }
            _loc3_ = _loc2_ ? 1 : this.getRatioToShow(false);
            _loc4_ = _loc2_ ? this.performProgressBarTransition : this.onTransitionEnd;
            _loc5_ = _loc2_ ? [true] : null;
            _loc6_ = param1 || _loc2_ ? 1 : 2;
            _loc7_ = _loc2_ ? Sine.easeIn : Sine.easeOut;
            _loc7_ = !_loc2_ && !param1 ? Sine.easeInOut : _loc7_;
            this.mProgressBar.setValueAnimated(_loc3_,_loc6_,_loc4_,_loc5_,null,null,_loc7_);
         }
         if(param1)
         {
            if(this.mLevelTextfield)
            {
               this.mLevelTextfield.text = JobsMng.getJobLevel(this.mJobDef).toString();
               SpecialFX.createYoYoZoomTransition(this.mLevelTextfield,1.5,0.75,3,null,null,false);
               Utils.playSound("level_up",SoundManager.TYPE_SFX);
            }
            if(this.mHighlightsBG)
            {
               this.mHighlightsBG.visible = true;
               SpecialFX.tweenToAlpha(this.mHighlightsBG,0.5,1,3);
            }
            if(this.mLevelUpEffect1)
            {
               this.mLevelUpEffect1.visible = true;
               _loc8_ = this.mLevelUpEffect1.scale;
               SpecialFX.createZoomAlphaTween(this.mLevelUpEffect1,1,0.999,0.001,0.1,_loc8_);
               addChild(this.mLevelUpEffect1);
               SpecialFX.createRotation(this.mLevelUpEffect1,360);
            }
         }
         if(!param1)
         {
            InstanceMng.getTextParticlesMng().showStandardTextParticle("+" + this.mExpWon + " xp",16777215,this,FSResourceMng.FONT_STD_DEFAULT_SIZE,Align.CENTER,Align.BOTTOM,"",Align.BOTTOM);
         }
      }
      
      private function onTransitionEnd() : void
      {
         if(this.mLevelUpEffect1)
         {
            this.mLevelUpEffect1.removeFromParent();
            this.mLevelUpEffect1.destroy();
            this.mLevelUpEffect1 = null;
         }
         TweenMax.delayedCall(2,this.onPanelTimeOut);
      }
      
      private function onPanelTimeOut() : void
      {
         var _loc1_:FSCoordinate = new FSCoordinate(x,-height);
         SpecialFX.createTransition(this,_loc1_,2,0,this.onPanelExitOver,null,Back.easeOut);
      }
      
      private function onPanelExitOver() : void
      {
         removeFromParent(true);
      }
      
      override public function dispose() : void
      {
         if(this.mProgressBar)
         {
            this.mProgressBar.removeFromParent(true);
            this.mProgressBar = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mHighlightsBG)
         {
            this.mHighlightsBG.removeFromParent();
            this.mHighlightsBG.destroy();
            this.mHighlightsBG = null;
         }
         if(this.mLevelBG)
         {
            this.mLevelBG.removeFromParent();
            this.mLevelBG.destroy();
            this.mLevelBG = null;
         }
         if(this.mLevelTextfield)
         {
            this.mLevelTextfield.removeFromParent(true);
            this.mLevelTextfield = null;
         }
         if(this.mJobNameTextfield)
         {
            this.mJobNameTextfield.removeFromParent(true);
            this.mJobNameTextfield = null;
         }
         if(this.mRewardImg)
         {
            this.mRewardImg.removeFromParent();
            this.mRewardImg.destroy();
            this.mRewardImg = null;
         }
         if(this.mRewardTextfield)
         {
            this.mRewardTextfield.removeFromParent(true);
            this.mRewardTextfield = null;
         }
         if(this.mLevelUpEffect1)
         {
            this.mLevelUpEffect1.removeFromParent();
            this.mLevelUpEffect1.destroy();
            this.mLevelUpEffect1 = null;
         }
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.mJobDef = null;
         super.dispose();
      }
   }
}

