package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import starling.core.Starling;
   import starling.display.MovieClip;
   
   public class FSProgressBar extends Component
   {
      
      protected var mAnimMC:MovieClip;
      
      private var mMax:int;
      
      private var mMin:int;
      
      protected var mBarTextfield:FSTextfield;
      
      public var mCurrentRealValue:int;
      
      private var mAnimPrefix:String;
      
      private var mShowTextfieldValue:Boolean = true;
      
      public function FSProgressBar(param1:int, param2:int, param3:String, param4:Boolean = true)
      {
         super();
         this.mAnimPrefix = param3;
         this.mMax = param2;
         this.mMin = param1;
         this.mShowTextfieldValue = param4;
         this.init();
      }
      
      private function init() : void
      {
         this.createAnimMC();
         if(this.mShowTextfieldValue)
         {
            this.createTextfield();
         }
      }
      
      protected function createTextfield() : void
      {
         this.mBarTextfield = new FSTextfield(this.mAnimMC.width,this.mAnimMC.height * 0.95,"0");
         this.mBarTextfield.color = 16777215;
         this.mBarTextfield.x = 0;
         this.mBarTextfield.y = (this.mAnimMC.height - this.mBarTextfield.height) / 2;
         addChild(this.mBarTextfield);
      }
      
      private function createAnimMC() : void
      {
         if(this.mAnimMC == null)
         {
            this.mAnimMC = new MovieClip(Root.assets.getTextures(this.mAnimPrefix),100);
         }
         addChild(this.mAnimMC);
      }
      
      public function setValue(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.mAnimMC != null)
         {
            this.mCurrentRealValue = param1;
            if(param1 > this.mMax)
            {
               param1 = this.mMax;
            }
            _loc2_ = param1 * 100 / this.mMax;
            _loc2_ = this.mAnimMC.numFrames == 100 ? _loc2_ : int(_loc2_ / 2);
            this.mAnimMC.currentFrame = _loc2_ - 1 >= 0 ? int(_loc2_ - 1) : 0;
            this.updateTextfield();
         }
      }
      
      public function setValueAnimated(param1:Number, param2:Number = 3, param3:Function = null, param4:Function = null) : void
      {
         SpecialFX.createFSProgressBarTransition(this,param1,param2,param3,param4);
      }
      
      private function updateTextfield() : void
      {
         if(this.mBarTextfield != null)
         {
            this.mBarTextfield.text = this.mCurrentRealValue.toString();
         }
      }
      
      public function getBarTextfield() : FSTextfield
      {
         return this.mBarTextfield;
      }
      
      public function setBarTextfield(param1:FSTextfield) : void
      {
         this.mBarTextfield = param1;
      }
      
      override public function dispose() : void
      {
         if(this.mAnimMC)
         {
            this.mAnimMC.removeFromParent(true);
            Starling.juggler.remove(this.mAnimMC);
            this.mAnimMC = null;
         }
         if(this.mBarTextfield)
         {
            this.mBarTextfield.removeFromParent(true);
            this.mBarTextfield = null;
         }
         super.dispose();
      }
   }
}

