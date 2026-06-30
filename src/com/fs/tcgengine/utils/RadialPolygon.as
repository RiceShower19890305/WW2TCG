package com.fs.tcgengine.utils
{
   import starling.animation.Transitions;
   import starling.core.Starling;
   import starling.display.Canvas;
   import starling.events.EnterFrameEvent;
   import starling.geom.Polygon;
   
   public class RadialPolygon extends Canvas
   {
      
      private var polygon:Polygon;
      
      private var _loadingAnimationEnabled:Boolean = false;
      
      private var _sides:Number = 4;
      
      private var _value:Number = 0;
      
      private var _radius:Number;
      
      public function RadialPolygon()
      {
         super();
      }
      
      protected function draw() : void
      {
         pivotX = pivotY = this.radius;
         this.polygon = new Polygon();
         this.updatePolygon(this.value,this.radius,this.radius,this.radius,Math.PI / 2);
         clear();
         beginFill(16711680);
         drawPolygon(this.polygon);
         endFill();
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         if(this._value != param1)
         {
            this._value = param1;
            this.draw();
         }
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
      
      public function set radius(param1:Number) : void
      {
         if(this._value != param1)
         {
            this._radius = param1;
            this.draw();
         }
      }
      
      public function get sides() : Number
      {
         return this._sides;
      }
      
      public function set sides(param1:Number) : void
      {
         if(this._value != param1)
         {
            this._sides = param1;
            this.draw();
         }
      }
      
      public function get loadingAnimationEnabled() : Boolean
      {
         return this._loadingAnimationEnabled;
      }
      
      public function set loadingAnimationEnabled(param1:Boolean) : void
      {
         this._loadingAnimationEnabled = param1;
         this.value = 0;
         if(param1)
         {
            Starling.juggler.tween(this,1,{
               "value":1,
               "onRepeat":this.onLoadingAnimationStepComplete,
               "repeatCount":0,
               "reverse":true,
               "transition":Transitions.EASE_IN_OUT
            });
            addEventListener(EnterFrameEvent.ENTER_FRAME,this.onLoadingAnimationFrame);
         }
         else
         {
            Starling.juggler.removeTweens(this);
            removeEventListener(EnterFrameEvent.ENTER_FRAME,this.onLoadingAnimationFrame);
            rotation = 0;
         }
      }
      
      public function tweenTo(param1:Number, param2:Number = 5, param3:Function = null) : void
      {
         Starling.juggler.tween(this,param2,{
            "value":param1,
            "onComplete":param3,
            "transition":Transitions.EASE_IN_OUT
         });
      }
      
      private function lineToRadians(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.polygon.addVertices(Math.cos(param1) * param2 + param3,Math.sin(param1) * param2 + param4);
      }
      
      private function updatePolygon(param1:Number, param2:Number = 50, param3:Number = 0, param4:Number = 0, param5:Number = 0) : void
      {
         this.polygon.addVertices(param3,param4);
         if(this.sides < 3)
         {
            this.sides = 3;
         }
         param2 /= Math.cos(1 / this.sides * Math.PI);
         var _loc6_:int = Math.floor(param1 * this.sides);
         var _loc7_:int = 0;
         while(_loc7_ <= _loc6_)
         {
            this.lineToRadians(_loc7_ / this.sides * (Math.PI * 2) + param5,param2,param3,param4);
            _loc7_++;
         }
         if(param1 * this.sides != _loc6_)
         {
            this.lineToRadians(param1 * (Math.PI * 2) + param5,param2,param3,param4);
         }
      }
      
      private function onLoadingAnimationFrame(param1:EnterFrameEvent) : void
      {
         rotation += 0.03;
      }
      
      private function onLoadingAnimationStepComplete() : void
      {
         scaleX = -scaleX;
      }
   }
}

