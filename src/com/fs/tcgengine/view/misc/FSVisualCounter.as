package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   
   public class FSVisualCounter extends Component implements FSModelUnloadableInterface
   {
      
      private var mTextfield:FSTextfield;
      
      private var mText:String;
      
      private var mColor:uint;
      
      private var mShape:FSImage;
      
      public function FSVisualCounter(param1:String, param2:uint)
      {
         super();
         this.mText = param1;
         this.mColor = param2;
         this.createBG(param2);
         this.createTextfield();
         touchable = false;
         alignPivot();
      }
      
      private function createBG(param1:uint) : void
      {
         this.mShape = new FSImage(Root.assets.getTexture("claim_warning"));
         this.mShape.scale = 1.2;
         this.mShape.touchable = false;
         addChild(this.mShape);
      }
      
      private function createTextfield() : void
      {
         if(this.mTextfield == null)
         {
            this.mTextfield = new FSTextfield(this.mShape.width,this.mShape.height,this.mText);
            this.mTextfield.touchable = false;
            addChild(this.mTextfield);
         }
      }
      
      public function updateText(param1:String) : void
      {
         this.mText = param1;
         if(this.mTextfield)
         {
            this.mTextfield.text = this.mText;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mShape)
         {
            this.mShape.removeFromParent(true);
            this.mShape = null;
         }
      }
      
      public function destroy() : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent();
            this.mTextfield = null;
         }
         if(this.mShape)
         {
            this.mShape.removeFromParent();
            this.mShape.destroy();
            this.mShape = null;
         }
      }
   }
}

