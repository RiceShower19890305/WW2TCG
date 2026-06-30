package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.easing.Ease;
   
   public class FSGaugeProgressBar extends Component implements FSModelUnloadableInterface
   {
      
      private var mImage:FSImage;
      
      private var mBG:FSImage;
      
      public var mRatio:Number;
      
      private var mTextfield:FSTextfield;
      
      private var mMaxScaleX:Number;
      
      private var mMaxScaleY:Number;
      
      private var mScaleHorizontally:Boolean;
      
      private var mHasSimpleUI:Boolean;
      
      public function FSGaugeProgressBar(param1:String = "", param2:String = "gauge", param3:Number = 0.75, param4:Boolean = false, param5:Number = -1, param6:Boolean = true, param7:Number = -1)
      {
         super();
         this.mHasSimpleUI = Config.getConfig().battleHasSimpleUI();
         if(!param4)
         {
            this.mBG = new FSImage(Root.assets.getTexture(param2 + "_bg"));
            this.mBG.width = param5 != -1 ? param5 : this.mBG.width;
            if(this.mBG)
            {
               this.mBG.scaleY = param3;
            }
            this.mBG.alignPivot();
            this.mBG.x = this.mBG.width / 2;
            this.mBG.y = this.mBG.height / 2;
         }
         this.mScaleHorizontally = param6;
         this.mImage = new FSImage(Root.assets.getTexture(param2 + "_inner"));
         this.mMaxScaleX = param5 != -1 ? param5 : 1;
         this.mMaxScaleY = param7 != -1 ? param7 : 1;
         this.mImage.scaleY = param3;
         this.mImage.x = Boolean(this.mBG) && param5 == -1 ? this.mBG.x - this.mBG.width / 2 : 0;
         this.mImage.y = this.mBG ? this.mBG.y - this.mBG.height / 2 : 0;
         if(this.mBG)
         {
            addChild(this.mBG);
         }
         addChild(this.mImage);
         if(param1 != "")
         {
            this.setText(param1);
         }
         if(!this.mScaleHorizontally)
         {
            this.mImage.y = this.mImage.height;
         }
      }
      
      public function setText(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.mTextfield == null)
         {
            _loc2_ = this.mBG ? int(this.mBG.width) : int(this.mImage.width);
            this.mTextfield = new FSTextfield(_loc2_,this.mBG.height,param1);
            this.mTextfield.alignPivot();
            this.mTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
            this.mTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mTextfield.x = this.mBG.x;
            this.mTextfield.y = this.mBG.y;
            addChild(this.mTextfield);
         }
         else
         {
            this.mTextfield.text = param1;
            this.mTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            addChild(this.mTextfield);
         }
      }
      
      private function update() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:int = Main.smScaleFactor == 4 ? int(Main.smScaleFactor / 2) : int(Main.smScaleFactor);
         if(this.mImage)
         {
            if(this.mScaleHorizontally)
            {
               this.mImage.scaleX = this.mMaxScaleX != 1 ? this.mRatio * (this.mMaxScaleX * _loc1_) : this.mRatio * this.mMaxScaleX;
               this.mImage.setTexCoords(1,this.mRatio,0);
               this.mImage.setTexCoords(3,this.mRatio,1);
            }
            else
            {
               _loc2_ = 1 - this.mRatio;
               this.mImage.scaleY = this.mMaxScaleY != 1 ? this.mRatio * (this.mMaxScaleY * _loc1_) : -this.mRatio * this.mMaxScaleY;
               this.mImage.setTexCoords(2,0,this.mRatio);
               this.mImage.setTexCoords(3,1,this.mRatio);
            }
         }
      }
      
      public function getRatio() : Number
      {
         return this.mRatio;
      }
      
      public function setRatio(param1:Number, param2:String = "") : void
      {
         this.mRatio = Math.max(0,Math.min(1,param1));
         if(param2 != "" && Boolean(this.mTextfield))
         {
            this.mTextfield.text = param2;
         }
         this.update();
      }
      
      public function setWidth(param1:int) : void
      {
         if(this.mBG)
         {
            this.mBG.width = param1;
            this.mBG.alignPivot();
            this.mBG.x = this.mBG.width / 2;
         }
         this.mImage.width = param1;
         this.mImage.x = this.mBG.x - this.mBG.width / 2;
         var _loc2_:int = Main.smScaleFactor == 4 ? 2 : 1;
         this.mMaxScaleX = this.mImage.scaleX / (Main.smScaleFactor / _loc2_);
         if(this.mTextfield)
         {
            this.mTextfield.width = this.mBG.width;
            this.mTextfield.alignPivot();
            this.mTextfield.x = this.mBG.x;
         }
      }
      
      public function setValueAnimated(param1:Number, param2:Number = 3, param3:Function = null, param4:Array = null, param5:Function = null, param6:Array = null, param7:Ease = null) : void
      {
         SpecialFX.createFSGaugeProgressBarTransition(this,param1,param2,param3,param4,param5,param6,param7);
      }
      
      override public function dispose() : void
      {
         this.destroy();
         super.dispose();
      }
      
      public function getUsefulHeight() : int
      {
         return this.mBG.height;
      }
      
      public function destroy() : void
      {
         if(this.mImage)
         {
            this.mImage.removeFromParent();
            this.mImage.destroy();
            this.mImage = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent();
            this.mTextfield = null;
         }
      }
   }
}

