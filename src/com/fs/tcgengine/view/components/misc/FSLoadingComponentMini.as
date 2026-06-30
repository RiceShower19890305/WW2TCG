package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.Event;
   
   public class FSLoadingComponentMini extends Component
   {
      
      private var mLoadingImage:FSImage;
      
      private var mBlack:Boolean;
      
      public function FSLoadingComponentMini(param1:Boolean = true)
      {
         super();
         this.mBlack = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:String = null;
         if(this.mLoadingImage == null)
         {
            _loc1_ = this.mBlack ? "spinner_mini_black" : "spinner_mini_white";
            this.mLoadingImage = new FSImage(Root.assets.getTexture(_loc1_));
            this.mLoadingImage.pivotX = this.mLoadingImage.width / 2;
            this.mLoadingImage.pivotY = this.mLoadingImage.height / 2;
         }
         addChild(this.mLoadingImage);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.mLoadingImage)
         {
            this.mLoadingImage.rotation += Constants.ROTATION_VALUE;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mLoadingImage)
         {
            this.mLoadingImage.removeFromParent(true);
            this.mLoadingImage = null;
         }
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.dispose();
      }
   }
}

