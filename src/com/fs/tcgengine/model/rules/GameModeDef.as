package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class GameModeDef extends Def
   {
      
      private var mColor:uint;
      
      public function GameModeDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.doFromJSON(param1);
         if("color" in param1)
         {
            _loc3_ = Utils.cleanMasterString(param1.color);
            this.setColor(int(_loc3_));
         }
      }
      
      public function getColor() : uint
      {
         return this.mColor;
      }
      
      public function setColor(param1:uint) : void
      {
         this.mColor = param1;
      }
   }
}

