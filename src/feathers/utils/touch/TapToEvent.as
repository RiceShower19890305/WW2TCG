package feathers.utils.touch
{
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class TapToEvent
   {
      
      protected var _target:DisplayObject;
      
      protected var _eventType:String = null;
      
      protected var _touchPointID:int = -1;
      
      protected var _isEnabled:Boolean = true;
      
      protected var _tapCount:int = -1;
      
      protected var _customHitTest:Function;
      
      public function TapToEvent(param1:DisplayObject = null, param2:String = null)
      {
         super();
         this.target = param1;
         this.eventType = param2;
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function set target(param1:DisplayObject) : void
      {
         if(this._target == param1)
         {
            return;
         }
         if(this._target)
         {
            this._target.removeEventListener(TouchEvent.TOUCH,this.target_touchHandler);
         }
         this._target = param1;
         if(this._target)
         {
            this._touchPointID = -1;
            this._target.addEventListener(TouchEvent.TOUCH,this.target_touchHandler);
         }
      }
      
      public function get eventType() : String
      {
         return this._eventType;
      }
      
      public function set eventType(param1:String) : void
      {
         this._eventType = param1;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled === param1)
         {
            return;
         }
         this._isEnabled = param1;
         if(!param1)
         {
            this._touchPointID = -1;
         }
      }
      
      public function get tapCount() : int
      {
         return this._tapCount;
      }
      
      public function set tapCount(param1:int) : void
      {
         this._tapCount = param1;
      }
      
      public function get customHitTest() : Function
      {
         return this._customHitTest;
      }
      
      public function set customHitTest(param1:Function) : void
      {
         this._customHitTest = param1;
      }
      
      protected function target_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Stage = null;
         var _loc4_:Point = null;
         var _loc5_:Boolean = false;
         if(!this._isEnabled)
         {
            this._touchPointID = -1;
            return;
         }
         if(this._touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this._target,null,this._touchPointID);
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.phase == TouchPhase.ENDED)
            {
               _loc3_ = this._target.stage;
               if(_loc3_ !== null)
               {
                  _loc4_ = Pool.getPoint();
                  _loc2_.getLocation(_loc3_,_loc4_);
                  if(this._target is DisplayObjectContainer)
                  {
                     _loc5_ = DisplayObjectContainer(this._target).contains(_loc3_.hitTest(_loc4_));
                  }
                  else
                  {
                     _loc5_ = this._target === _loc3_.hitTest(_loc4_);
                  }
                  Pool.putPoint(_loc4_);
                  if(_loc5_ && (this._tapCount == -1 || this._tapCount == _loc2_.tapCount))
                  {
                     this._target.dispatchEventWith(this._eventType);
                  }
               }
               this._touchPointID = -1;
            }
            return;
         }
         _loc2_ = param1.getTouch(DisplayObject(this._target),TouchPhase.BEGAN);
         if(!_loc2_)
         {
            return;
         }
         if(this._customHitTest !== null)
         {
            _loc4_ = Pool.getPoint();
            _loc2_.getLocation(DisplayObject(this._target),_loc4_);
            _loc5_ = this._customHitTest(_loc4_);
            Pool.putPoint(_loc4_);
            if(!_loc5_)
            {
               return;
            }
         }
         this._touchPointID = _loc2_.id;
      }
   }
}

