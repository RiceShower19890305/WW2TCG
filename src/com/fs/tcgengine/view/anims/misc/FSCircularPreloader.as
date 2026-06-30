package com.fs.tcgengine.view.anims.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class FSCircularPreloader extends Component
   {
      
      private var AnimTexture:Class = FSCircularPreloader_AnimTexture;
      
      private var mStaticAnim:FSImage;
      
      public function FSCircularPreloader()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         var _loc1_:Texture = null;
         if(this.mStaticAnim == null)
         {
            _loc1_ = Texture.fromBitmap(new this.AnimTexture());
            this.mStaticAnim = new FSImage(_loc1_);
            this.mStaticAnim.alignPivot();
            this.mStaticAnim.scale = 0.5;
         }
         addChild(this.mStaticAnim);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.mStaticAnim)
         {
            this.mStaticAnim.rotation += Constants.ROTATION_VALUE;
         }
      }
      
      override public function dispose() : void
      {
         if(this.AnimTexture)
         {
            this.AnimTexture = null;
         }
         if(this.mStaticAnim)
         {
            this.mStaticAnim.removeFromParent(true);
            this.mStaticAnim = null;
         }
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
   }
}

