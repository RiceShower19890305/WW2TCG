package com.fs.tcgengine.view.components
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.utils.Layout;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.textures.Texture;
   
   public class CustomComponent extends Component
   {
      
      private var mSideLeftImg:FSImage;
      
      private var mSideRightImg:FSImage;
      
      private var mCenterImg:FSImage;
      
      private var mOriginalCenterImgWidth:Number;
      
      private var mOriginalLeftSideImgWidth:Number;
      
      private var mOriginalRightSideImgWidth:Number;
      
      private var mBackgroundVisible:Boolean;
      
      public function CustomComponent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = true)
      {
         super();
         var _loc5_:Number = param3 ? param2 : Layout.getFinalWidth(param2);
         this.mBackgroundVisible = param4;
         this.createUI(param1,_loc5_);
      }
      
      private function createUI(param1:String, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Texture = null;
         var _loc8_:Texture = null;
         var _loc9_:Texture = null;
         var _loc10_:Boolean = false;
         var _loc11_:Number = NaN;
         if(param1 != "")
         {
            _loc4_ = param1 + "_left";
            _loc5_ = param1 + "_center";
            _loc6_ = param1 + "_right";
            _loc7_ = Root.assets.getTexture(_loc4_);
            _loc8_ = Root.assets.getTexture(_loc5_);
            _loc9_ = Root.assets.getTexture(_loc6_);
            _loc10_ = false;
            if(_loc9_ == null)
            {
               _loc9_ = _loc7_;
               _loc10_ = true;
            }
            if(Boolean(_loc7_) && Boolean(_loc8_))
            {
               if(this.mSideLeftImg == null)
               {
                  this.mSideLeftImg = new FSImage(_loc7_);
               }
               else
               {
                  this.mSideLeftImg.texture = _loc7_;
               }
               this.mOriginalLeftSideImgWidth = _loc7_.width;
               if(this.mSideRightImg == null)
               {
                  this.mSideRightImg = new FSImage(_loc9_);
               }
               else
               {
                  this.mSideRightImg.texture = _loc9_;
               }
               this.mOriginalRightSideImgWidth = _loc9_.width;
               if(this.mCenterImg == null)
               {
                  this.mCenterImg = new FSImage(_loc8_);
               }
               else
               {
                  this.mCenterImg.texture = _loc8_;
               }
               this.mOriginalCenterImgWidth = _loc8_.width;
               this.mSideLeftImg.readjustSize();
               this.mCenterImg.readjustSize();
               this.mSideRightImg.readjustSize();
               this.mSideLeftImg.visible = this.mBackgroundVisible;
               this.mCenterImg.visible = this.mBackgroundVisible;
               this.mSideRightImg.visible = this.mBackgroundVisible;
               if(param3)
               {
                  return;
               }
               _loc11_ = _loc10_ ? this.mOriginalLeftSideImgWidth * 2 : this.mOriginalLeftSideImgWidth + this.mOriginalRightSideImgWidth;
               param2 = param2 != 0 ? param2 : 0;
               param2 = param2 != 0 ? param2 - _loc11_ : 0;
               this.mCenterImg.width = param2 != 0 ? param2 : this.mCenterImg.width;
               this.mCenterImg.x = this.mSideLeftImg.x + this.mSideLeftImg.width;
               this.mSideRightImg.scaleX = _loc10_ ? -1 : 1;
               this.mSideRightImg.x = _loc10_ ? this.mCenterImg.x + this.mCenterImg.width + this.mSideRightImg.width : this.mCenterImg.x + this.mCenterImg.width;
               addChild(this.mSideLeftImg);
               addChild(this.mCenterImg);
               addChild(this.mSideRightImg);
            }
            else
            {
               _loc8_ = Root.assets.getTexture(param1);
               if(_loc8_)
               {
                  if(this.mCenterImg == null)
                  {
                     this.mCenterImg = new FSImage(_loc8_);
                  }
                  else
                  {
                     this.mCenterImg.texture = _loc8_;
                  }
                  addChild(this.mCenterImg);
                  this.mCenterImg.visible = this.mBackgroundVisible;
               }
            }
         }
      }
      
      public function updateTextures(param1:String, param2:int, param3:Boolean = true) : void
      {
         this.createUI(param1,Layout.getFinalWidth(param2),param3);
      }
      
      override public function dispose() : void
      {
         if(this.mSideLeftImg)
         {
            this.mSideLeftImg.removeFromParent(true);
            this.mSideLeftImg = null;
         }
         if(this.mSideRightImg)
         {
            this.mSideRightImg.removeFromParent(true);
            this.mSideRightImg = null;
         }
         if(this.mCenterImg)
         {
            this.mCenterImg.removeFromParent(true);
            this.mCenterImg = null;
         }
         super.dispose();
      }
   }
}

