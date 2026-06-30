package feathers.utils.display
{
   import flash.errors.IllegalOperationError;
   
   public class ScreenDensityScaleCalculator
   {
      
      protected var _buckets:Vector.<ScreenDensityBucket> = new Vector.<ScreenDensityBucket>(0);
      
      public function ScreenDensityScaleCalculator()
      {
         super();
      }
      
      public function addScaleForDensity(param1:int, param2:Number) : void
      {
         var _loc5_:ScreenDensityBucket = null;
         var _loc3_:int = int(this._buckets.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._buckets[_loc4_];
            if(_loc5_.density > param1)
            {
               break;
            }
            if(_loc5_.density == param1)
            {
               throw new ArgumentError("Screen density cannot be added more than once: " + param1);
            }
            _loc4_++;
         }
         this._buckets.insertAt(_loc4_,new ScreenDensityBucket(param1,param2));
      }
      
      public function removeScaleForDensity(param1:int) : void
      {
         var _loc4_:ScreenDensityBucket = null;
         var _loc2_:int = int(this._buckets.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._buckets[_loc3_];
            if(_loc4_.density == param1)
            {
               this._buckets.removeAt(_loc3_);
               return;
            }
            _loc3_++;
         }
      }
      
      public function getScale(param1:int) : Number
      {
         var _loc6_:Number = NaN;
         if(this._buckets.length == 0)
         {
            throw new IllegalOperationError("Cannot choose scale because none have been added");
         }
         var _loc2_:ScreenDensityBucket = this._buckets[0];
         if(param1 <= _loc2_.density)
         {
            return _loc2_.scale;
         }
         var _loc3_:ScreenDensityBucket = _loc2_;
         var _loc4_:int = int(this._buckets.length);
         var _loc5_:int = 1;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this._buckets[_loc5_];
            if(param1 <= _loc2_.density)
            {
               _loc6_ = (_loc2_.density + _loc3_.density) / 2;
               if(param1 < _loc6_)
               {
                  return _loc3_.scale;
               }
               return _loc2_.scale;
            }
            _loc3_ = _loc2_;
            _loc5_++;
         }
         return _loc2_.scale;
      }
   }
}

class ScreenDensityBucket
{
   
   public var density:Number;
   
   public var scale:Number;
   
   public function ScreenDensityBucket(param1:Number, param2:Number)
   {
      super();
      this.density = param1;
      this.scale = param2;
   }
}
