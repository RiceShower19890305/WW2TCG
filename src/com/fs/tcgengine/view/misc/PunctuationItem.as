package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import starling.textures.Texture;
   
   public class PunctuationItem extends Component
   {
      
      private const TEXTFIELD_BG_NAME:String = "score_frame";
      
      private var mImage:FSImage;
      
      private var mTextfield:FSTextfield;
      
      public var mValue:int;
      
      private var mTextfieldBG:FSImage;
      
      public function PunctuationItem(param1:String, param2:String)
      {
         super();
         this.setup(param1,param2);
      }
      
      private function setup(param1:String, param2:String) : void
      {
         this.mImage = new FSImage(Root.assets.getTexture(param1));
         addChild(this.mImage);
         var _loc3_:int = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
         this.mTextfield = new FSTextfield(this.mImage.width * 2,_loc3_,param2);
         this.mTextfield.y = this.mImage.y + this.mImage.height;
         addChild(this.mTextfield);
         this.mImage.x += (width - this.mImage.width) / 2;
         this.createTextfieldBGImage();
      }
      
      private function createTextfieldBGImage() : void
      {
         var _loc1_:Texture = null;
         if(this.mTextfieldBG == null)
         {
            _loc1_ = Root.assets.getTexture(this.TEXTFIELD_BG_NAME);
            if(_loc1_)
            {
               this.mTextfieldBG = new FSImage(_loc1_);
               this.mTextfieldBG.x = this.mTextfield ? this.mTextfield.x + (this.mTextfield.width - this.mTextfieldBG.width) / 2 : 0;
               this.mTextfieldBG.y = this.mTextfield ? this.mTextfield.y - 2 + (this.mTextfield.height - this.mTextfieldBG.height) / 2 : 0;
               addChildAt(this.mTextfieldBG,0);
            }
         }
      }
      
      public function setValue(param1:int, param2:Number = 1.5) : void
      {
         TweenMax.to(this,1.5,{
            "mValue":param1,
            "onUpdate":this.updateValue
         });
      }
      
      private function updateValue() : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.text = "+" + this.mValue;
         }
      }
      
      public function getValue() : int
      {
         return this.mValue;
      }
      
      override public function dispose() : void
      {
         if(this.mImage)
         {
            this.mImage.removeFromParent(true);
            this.mImage = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         if(this.mTextfieldBG)
         {
            this.mTextfieldBG.removeFromParent(true);
            this.mTextfieldBG = null;
         }
         super.dispose();
      }
   }
}

