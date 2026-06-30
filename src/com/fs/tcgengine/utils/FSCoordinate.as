package com.fs.tcgengine.utils
{
   public class FSCoordinate
   {
      
      public var mX:Number;
      
      public var mY:Number;
      
      public var mZ:Number;
      
      public function FSCoordinate(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.mX = param1;
         this.mY = param2;
         this.mZ = param3;
      }
      
      public function getX() : Number
      {
         return this.mX;
      }
      
      public function setX(param1:Number) : void
      {
         this.mX = param1;
      }
      
      public function getY() : Number
      {
         return this.mY;
      }
      
      public function setY(param1:Number) : void
      {
         this.mY = param1;
      }
      
      public function getZ() : Number
      {
         return this.mZ;
      }
      
      public function setZ(param1:Number) : void
      {
         this.mZ = param1;
      }
      
      public function copy(param1:FSCoordinate) : void
      {
         this.mX = param1.mX;
         this.mY = param1.mY;
         this.mZ = param1.mZ;
      }
      
      public function toString(param1:Boolean = true) : String
      {
         if(param1)
         {
            return "(" + this.mX + "," + this.mY + ")";
         }
         return "(" + this.mX + "," + this.mY + "," + this.mZ + ")";
      }
      
      public function isInSameCol(param1:FSCoordinate) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1 != null)
         {
            _loc2_ = this.getY() == param1.getY();
         }
         return _loc2_;
      }
   }
}

