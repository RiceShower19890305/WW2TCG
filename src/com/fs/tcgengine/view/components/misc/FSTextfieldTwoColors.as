package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.Component;
   import starling.utils.Align;
   
   public class FSTextfieldTwoColors extends Component
   {
      
      private var mTextfield1:FSTextfield;
      
      private var mTextfield2:FSTextfield;
      
      public function FSTextfieldTwoColors(param1:String, param2:uint, param3:String, param4:String, param5:uint, param6:String, param7:int, param8:int)
      {
         super();
         this.createTextfields(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      private function createTextfields(param1:String, param2:uint, param3:String, param4:String, param5:uint, param6:String, param7:int, param8:int) : void
      {
         if(this.mTextfield1 == null)
         {
            this.mTextfield1 = new FSTextfield(param7,FSResourceMng.FONT_STD_DEFAULT_SIZE,param1,param2);
            this.mTextfield1.fontName = param3;
            this.mTextfield1.format.horizontalAlign = Align.LEFT;
            addChild(this.mTextfield1);
         }
         if(this.mTextfield2 == null)
         {
            this.mTextfield2 = new FSTextfield(param8,FSResourceMng.FONT_STD_DEFAULT_SIZE,param4,param5);
            this.mTextfield2.fontName = param6;
            this.mTextfield2.format.horizontalAlign = Align.LEFT;
            this.mTextfield2.x = this.mTextfield1.x + this.mTextfield1.width;
            this.mTextfield2.y = this.mTextfield1.y;
            addChild(this.mTextfield2);
         }
      }
      
      public function setHeight(param1:int) : void
      {
         if(this.mTextfield1)
         {
            this.mTextfield1.height = param1;
            this.mTextfield1.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
         }
         if(this.mTextfield2)
         {
            this.mTextfield2.height = param1;
            this.mTextfield2.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mTextfield2.x = this.mTextfield1.x + this.mTextfield1.width + 5;
            this.mTextfield2.y = this.mTextfield1.y;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mTextfield1)
         {
            this.mTextfield1.removeFromParent(true);
            this.mTextfield1 = null;
         }
         if(this.mTextfield2)
         {
            this.mTextfield2.removeFromParent(true);
            this.mTextfield2 = null;
         }
         super.dispose();
      }
      
      public function setTextfield1Text(param1:String) : void
      {
         if(this.mTextfield1)
         {
            this.mTextfield1.text = param1;
         }
      }
      
      public function setTextfield2Text(param1:String) : void
      {
         if(this.mTextfield2)
         {
            this.mTextfield2.text = param1;
         }
      }
      
      public function setTextfield2FontName(param1:String) : void
      {
         if(this.mTextfield2)
         {
            this.mTextfield2.fontName = param1;
         }
      }
   }
}

