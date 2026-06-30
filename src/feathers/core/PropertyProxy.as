package feathers.core
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public final dynamic class PropertyProxy extends Proxy
   {
      
      private var _subProxyName:String;
      
      private var _onChangeCallbacks:Vector.<Function> = new Vector.<Function>(0);
      
      private var _names:Array = [];
      
      private var _storage:Object = {};
      
      public function PropertyProxy(param1:Function = null)
      {
         super();
         if(param1 != null)
         {
            this._onChangeCallbacks[this._onChangeCallbacks.length] = param1;
         }
      }
      
      public static function fromObject(param1:Object, param2:Function = null) : PropertyProxy
      {
         var _loc4_:String = null;
         var _loc3_:PropertyProxy = new PropertyProxy(param2);
         for(_loc4_ in param1)
         {
            _loc3_[_loc4_] = param1[_loc4_];
         }
         return _loc3_;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return this._storage.hasOwnProperty(param1);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var _loc2_:String = null;
         var _loc3_:PropertyProxy = null;
         if(this.flash_proxy::isAttribute(param1))
         {
            _loc2_ = param1 is QName ? QName(param1).localName : param1.toString();
            if(!this._storage.hasOwnProperty(_loc2_))
            {
               _loc3_ = new PropertyProxy(this.subProxy_onChange);
               _loc3_._subProxyName = _loc2_;
               this._storage[_loc2_] = _loc3_;
               this._names[this._names.length] = _loc2_;
               this.fireOnChangeCallback(_loc2_);
            }
            return this._storage[_loc2_];
         }
         return this._storage[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var _loc3_:String = param1 is QName ? QName(param1).localName : param1.toString();
         this._storage[_loc3_] = param2;
         if(this._names.indexOf(_loc3_) < 0)
         {
            this._names[this._names.length] = _loc3_;
         }
         this.fireOnChangeCallback(_loc3_);
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         var _loc2_:String = param1 is QName ? QName(param1).localName : param1.toString();
         var _loc3_:int = this._names.indexOf(_loc2_);
         if(_loc3_ >= 0)
         {
            this._names.removeAt(_loc3_);
         }
         var _loc4_:Boolean = delete this._storage[_loc2_];
         if(_loc4_)
         {
            this.fireOnChangeCallback(_loc2_);
         }
         return _loc4_;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 < this._names.length)
         {
            return param1 + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this._names[param1 - 1];
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         var _loc2_:* = this._names[param1 - 1];
         return this._storage[_loc2_];
      }
      
      public function addOnChangeCallback(param1:Function) : void
      {
         this._onChangeCallbacks[this._onChangeCallbacks.length] = param1;
      }
      
      public function removeOnChangeCallback(param1:Function) : void
      {
         var _loc2_:int = this._onChangeCallbacks.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         if(_loc2_ == 0)
         {
            this._onChangeCallbacks.shift();
            return;
         }
         var _loc3_:int = this._onChangeCallbacks.length - 1;
         if(_loc2_ == _loc3_)
         {
            this._onChangeCallbacks.pop();
            return;
         }
         this._onChangeCallbacks.removeAt(_loc2_);
      }
      
      public function toString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "[object PropertyProxy";
         for(_loc2_ in this)
         {
            _loc1_ += " " + _loc2_;
         }
         return _loc1_ + "]";
      }
      
      private function fireOnChangeCallback(param1:String) : void
      {
         var _loc4_:Function = null;
         var _loc2_:int = int(this._onChangeCallbacks.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._onChangeCallbacks[_loc3_] as Function;
            _loc4_(this,param1);
            _loc3_++;
         }
      }
      
      private function subProxy_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.fireOnChangeCallback(param1._subProxyName);
      }
   }
}

