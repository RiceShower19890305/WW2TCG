package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.view.misc.FSImage;
   import feathers.core.FeathersControl;
   import starling.textures.Texture;
   
   public class RadialProgressBar extends FeathersControl
   {
      
      private var radialPolygon:RadialPolygon;
      
      private var _background:FSImage;
      
      private var _progress:FSImage;
      
      private var _backgroundTexture:Texture;
      
      private var _progressTexture:Texture;
      
      private var _backgroundOffsetX:Number = 0;
      
      private var _backgroundOffsetY:Number = 0;
      
      public function RadialProgressBar()
      {
         super();
         this.radialPolygon = new RadialPolygon();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(this.backgroundTexture != null)
         {
            this._background = new FSImage(this.backgroundTexture);
         }
         this._progress = new FSImage(this.progressTexture);
         if(this._background)
         {
            addChild(this._background);
         }
         addChild(this._progress);
         addChild(this.radialPolygon);
         width = this._progress.width;
         height = this._progress.height;
         this._progress.mask = this.radialPolygon;
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalid(INVALIDATION_FLAG_SIZE))
         {
            this._progress.width = width;
            this._progress.height = height;
            this.radialPolygon.radius = width / 2;
            this.radialPolygon.x = width / 2;
            this.radialPolygon.y = height / 2;
            if(this._background)
            {
               this._background.scale = this._progress.scaleX;
               this._background.x = this._backgroundOffsetX * this._progress.scale;
               this._background.y = this._backgroundOffsetY * this._progress.scale;
            }
         }
      }
      
      public function get backgroundImage() : FSImage
      {
         return this._background;
      }
      
      public function get progressImage() : FSImage
      {
         return this._progress;
      }
      
      public function get backgroundTexture() : Texture
      {
         return this._backgroundTexture;
      }
      
      public function set backgroundTexture(param1:Texture) : void
      {
         this._backgroundTexture = param1;
         if(this._background)
         {
            this._background.texture = param1;
         }
      }
      
      public function get progressTexture() : Texture
      {
         return this._progressTexture;
      }
      
      public function set progressTexture(param1:Texture) : void
      {
         this._progressTexture = param1;
         if(this._progress)
         {
            this._progress.texture = param1;
         }
      }
      
      public function get backgroundOffsetX() : Number
      {
         return this._backgroundOffsetX;
      }
      
      public function set backgroundOffsetX(param1:Number) : void
      {
         this._backgroundOffsetX = param1;
         if(this._background)
         {
            this._background.x = param1;
         }
      }
      
      public function get backgroundOffsetY() : Number
      {
         return this._backgroundOffsetY;
      }
      
      public function set backgroundOffsetY(param1:Number) : void
      {
         this._backgroundOffsetY = param1;
         if(this._background)
         {
            this._background.y = param1;
         }
      }
      
      public function get loadingAnimationEnabled() : Boolean
      {
         return this.radialPolygon.loadingAnimationEnabled;
      }
      
      public function set loadingAnimationEnabled(param1:Boolean) : void
      {
         this.radialPolygon.loadingAnimationEnabled = param1;
      }
      
      public function tweenTo(param1:Number, param2:Number = 5, param3:Function = null) : void
      {
         this.radialPolygon.tweenTo(param1,param2,param3);
      }
      
      public function get value() : Number
      {
         return this.radialPolygon.value;
      }
      
      public function set value(param1:Number) : void
      {
         this.radialPolygon.value = param1;
      }
      
      override public function dispose() : void
      {
         if(this.radialPolygon)
         {
            this.radialPolygon.removeFromParent(true);
            this.radialPolygon = null;
         }
         if(this._background)
         {
            this._background.removeFromParent(true);
            this._background = null;
         }
         if(this._progress)
         {
            this._progress.removeFromParent(true);
            this._progress = null;
         }
         this._backgroundTexture = this._progressTexture = null;
         super.dispose();
      }
   }
}

