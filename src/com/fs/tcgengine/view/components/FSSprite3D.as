package com.fs.tcgengine.view.components
{
   import flash.geom.Vector3D;
   import starling.display.Sprite3D;
   import starling.utils.deg2rad;
   
   public class FSSprite3D extends Sprite3D
   {
      
      public function FSSprite3D()
      {
         super();
      }
      
      public function moveForward(param1:Number) : void
      {
         z -= param1;
      }
      
      public function moveBackward(param1:Number) : void
      {
         z += param1;
      }
      
      public function moveUp(param1:Number) : void
      {
         y -= param1;
      }
      
      public function moveDown(param1:Number) : void
      {
         y += param1;
      }
      
      public function moveLeft(param1:Number) : void
      {
         x -= param1;
      }
      
      public function moveRight(param1:Number) : void
      {
         x += param1;
      }
      
      public function moveTo(param1:Number, param2:Number, param3:Number) : void
      {
         x = param1;
         y = param2;
         z = param3;
      }
      
      public function rotate(param1:Vector3D, param2:Number) : void
      {
         rotationX += param1.x == 1 ? deg2rad(param2) : 0;
         rotationY += param1.y == 1 ? deg2rad(param2) : 0;
         rotationZ += param1.z == 1 ? deg2rad(param2) : 0;
      }
      
      public function set position(param1:Vector3D) : void
      {
         x = param1.x;
         y = param1.y;
         z = param1.z;
      }
      
      public function get position() : Vector3D
      {
         return new Vector3D(x,y,z);
      }
   }
}

