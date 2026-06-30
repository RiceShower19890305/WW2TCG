package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.view.components.Component;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.textures.Texture;
   
   public class FSLoadingMC extends Component
   {
      
      private var mLoadingIcon:MovieClip;
      
      protected var mSpriteSheetPrefix:String;
      
      protected var mFPS:int;
      
      public function FSLoadingMC()
      {
         super();
         this.createLoadingIconArt();
         touchable = false;
      }
      
      protected function setupSpriteSheet() : void
      {
         this.mSpriteSheetPrefix = "sync_loading_";
         this.mFPS = 25;
      }
      
      private function createLoadingIconArt() : void
      {
         var _loc1_:Vector.<Texture> = null;
         this.setupSpriteSheet();
         if(this.mLoadingIcon == null)
         {
            _loc1_ = Root.assets.getTextures(this.mSpriteSheetPrefix);
            if(!(Boolean(_loc1_) && _loc1_.length > 0))
            {
               return;
            }
            this.mLoadingIcon = new MovieClip(_loc1_,this.mFPS);
            this.mLoadingIcon.touchable = false;
         }
         this.mLoadingIcon.x = Math.ceil(-this.mLoadingIcon.width / 2);
         this.mLoadingIcon.y = Math.ceil(-this.mLoadingIcon.height / 2);
         Starling.juggler.add(this.mLoadingIcon);
         this.addChild(this.mLoadingIcon);
      }
      
      override public function dispose() : void
      {
         if(this.mLoadingIcon)
         {
            this.mLoadingIcon.removeFromParent(true);
            Starling.juggler.remove(this.mLoadingIcon);
            this.mLoadingIcon = null;
         }
         super.dispose();
      }
   }
}

