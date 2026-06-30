package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import feathers.controls.Callout;
   import mx.utils.StringUtil;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.textures.Texture;
   
   public class FSImage extends Image implements FSModelUnloadableInterface
   {
      
      private var mDisposeTextureOnDispose:Boolean = true;
      
      private var mTooltip:Callout;
      
      private var mTooltipText:String;
      
      public function FSImage(param1:Texture, param2:Boolean = true)
      {
         if(param1 == null && Utils.isBrowser())
         {
            Utils.setLogText(TextManager.getText("TID_GEN_ADD_BLOCK"));
         }
         super(param1);
         this.mDisposeTextureOnDispose = param2;
      }
      
      override public function dispose() : void
      {
         if(filter)
         {
            filter.dispose();
            filter = null;
         }
         removeFromParent();
         if(texture != null && this.mDisposeTextureOnDispose)
         {
            texture.dispose();
         }
         this.destroy();
         super.dispose();
      }
      
      public function destroy() : void
      {
         this.removeTooltip();
      }
      
      public function reset(param1:Boolean = true) : void
      {
         if(!Config.USE_CARD_POOLING)
         {
            return;
         }
         Utils.resetComponent(this);
         this.destroy();
         if(param1)
         {
            texture = null;
         }
         removeFromParent();
      }
      
      public function setTooltipText(param1:String) : void
      {
         this.mTooltipText = param1 != null && param1 != "" ? StringUtil.trim(param1) : "";
      }
      
      public function showTooltip() : void
      {
         if(this.mTooltip == null && this.mTooltipText != null && this.mTooltipText != "")
         {
            if(stage == null)
            {
               return;
            }
            this.mTooltip = Callout.show(Utils.getTooltipContent(this.mTooltipText),this,null,false);
            this.mTooltip.closeOnTouchEndedOutside = true;
            this.mTooltip.closeOnTouchBeganOutside = true;
            this.mTooltip.disposeContent = false;
            this.mTooltip.maxWidth = Starling.current.stage.stageWidth / 3;
            this.mTooltip.touchable = false;
            this.mTooltip.alpha = 0.001;
            SpecialFX.tweenToAlpha(this.mTooltip,0.999,0.25,0);
         }
      }
      
      public function closeTooltip() : void
      {
         if(this.mTooltip)
         {
            SpecialFX.tweenToAlpha(this.mTooltip,0.001,0.25,0,this.removeTooltip);
         }
      }
      
      private function removeTooltip() : void
      {
         if(this.mTooltip)
         {
            this.mTooltip.close();
            this.mTooltip.removeFromParent(true);
            this.mTooltip = null;
         }
      }
   }
}

