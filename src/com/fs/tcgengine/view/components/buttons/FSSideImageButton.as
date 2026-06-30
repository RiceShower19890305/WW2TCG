package com.fs.tcgengine.view.components.buttons
{
   import starling.display.DisplayObject;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSSideImageButton extends FSButton
   {
      
      protected var mExtraImage:DisplayObject;
      
      public function FSSideImageButton(param1:Texture, param2:String = "", param3:String = "center", param4:Texture = null, param5:Boolean = false, param6:Texture = null, param7:Texture = null)
      {
         super(param1,param2,param4,param5,param6,param7);
      }
      
      public function addChildToContents(param1:DisplayObject, param2:String = "left") : DisplayObject
      {
         var _loc3_:Number = NaN;
         if(param1)
         {
            this.mExtraImage = param1;
            switch(param2)
            {
               case Align.LEFT:
                  _loc3_ = this.mExtraImage.x + this.mExtraImage.width * 1.25;
                  _textField.format.horizontalAlign = Align.LEFT;
                  _textField.width = width * 0.9 - _loc3_;
                  _textBounds.x = _loc3_;
                  _textField.x = _loc3_;
                  param1.x = 5;
                  break;
               case Align.RIGHT:
                  this.mExtraImage.x = _textBounds.width - this.mExtraImage.width;
                  _textField.format.horizontalAlign = Align.LEFT;
            }
            param1.y = (height - param1.height) / 2;
            _contents.addChild(param1);
            _textBounds.width = upState.width - this.mExtraImage.width * 1.35;
         }
         return param1;
      }
      
      override public function dispose() : void
      {
         if(this.mExtraImage)
         {
            this.mExtraImage.removeFromParent();
            this.mExtraImage = null;
         }
         super.dispose();
      }
   }
}

