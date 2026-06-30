package feathers.text
{
   import feathers.core.IFeathersControl;
   import feathers.core.IStateContext;
   import feathers.core.IStateObserver;
   import feathers.core.IToggle;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.text.TextFormat;
   
   public class FontStylesSet extends EventDispatcher
   {
      
      protected var _stateToFormat:Object = null;
      
      protected var _format:TextFormat;
      
      protected var _disabledFormat:TextFormat;
      
      protected var _selectedFormat:TextFormat;
      
      public function FontStylesSet()
      {
         super();
      }
      
      public function get format() : TextFormat
      {
         return this._format;
      }
      
      public function set format(param1:TextFormat) : void
      {
         if(this._format === param1)
         {
            return;
         }
         if(this._format !== null)
         {
            this._format.removeEventListener(Event.CHANGE,this.format_changeHandler);
         }
         this._format = param1;
         if(this._format !== null)
         {
            this._format.addEventListener(Event.CHANGE,this.format_changeHandler);
         }
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get disabledFormat() : TextFormat
      {
         return this._disabledFormat;
      }
      
      public function set disabledFormat(param1:TextFormat) : void
      {
         if(this._disabledFormat === param1)
         {
            return;
         }
         if(this._disabledFormat !== null)
         {
            this._disabledFormat.removeEventListener(Event.CHANGE,this.format_changeHandler);
         }
         this._disabledFormat = param1;
         if(this._disabledFormat !== null)
         {
            this._disabledFormat.addEventListener(Event.CHANGE,this.format_changeHandler);
         }
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get selectedFormat() : TextFormat
      {
         return this._selectedFormat;
      }
      
      public function set selectedFormat(param1:TextFormat) : void
      {
         if(this._selectedFormat === param1)
         {
            return;
         }
         if(this._selectedFormat !== null)
         {
            this._selectedFormat.removeEventListener(Event.CHANGE,this.format_changeHandler);
         }
         this._selectedFormat = param1;
         if(this._selectedFormat !== null)
         {
            this._selectedFormat.addEventListener(Event.CHANGE,this.format_changeHandler);
         }
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function dispose() : void
      {
         var _loc1_:String = null;
         this.format = null;
         this.disabledFormat = null;
         this.selectedFormat = null;
         for(_loc1_ in this._stateToFormat)
         {
            this.setFormatForState(_loc1_,null);
         }
      }
      
      public function getFormatForState(param1:String) : TextFormat
      {
         if(this._stateToFormat === null)
         {
            return null;
         }
         return TextFormat(this._stateToFormat[param1]);
      }
      
      public function setFormatForState(param1:String, param2:TextFormat) : void
      {
         var _loc3_:TextFormat = null;
         if(param2 !== null)
         {
            if(this._stateToFormat === null)
            {
               this._stateToFormat = {};
            }
            else
            {
               _loc3_ = TextFormat(this._stateToFormat[param1]);
            }
            if(_loc3_ !== null)
            {
               _loc3_.removeEventListener(Event.CHANGE,this.format_changeHandler);
            }
            this._stateToFormat[param1] = param2;
            param2.addEventListener(Event.CHANGE,this.format_changeHandler);
         }
         else if(this._stateToFormat !== null)
         {
            _loc3_ = TextFormat(this._stateToFormat[param1]);
            if(_loc3_ !== null)
            {
               _loc3_.removeEventListener(Event.CHANGE,this.format_changeHandler);
               delete this._stateToFormat[param1];
            }
         }
      }
      
      public function getTextFormatForTarget(param1:IFeathersControl) : TextFormat
      {
         var _loc2_:TextFormat = null;
         var _loc3_:IStateContext = null;
         var _loc4_:String = null;
         if(param1 is IStateObserver)
         {
            _loc3_ = IStateObserver(param1).stateContext;
         }
         if(_loc3_ !== null)
         {
            if(this._stateToFormat !== null)
            {
               _loc4_ = _loc3_.currentState;
               if(_loc4_ in this._stateToFormat)
               {
                  _loc2_ = TextFormat(this._stateToFormat[_loc4_]);
               }
            }
            if(_loc2_ === null && this._disabledFormat !== null && _loc3_ is IFeathersControl && !IFeathersControl(_loc3_).isEnabled)
            {
               _loc2_ = this._disabledFormat;
            }
            if(_loc2_ === null && this._selectedFormat !== null && _loc3_ is IToggle && IToggle(_loc3_).isSelected)
            {
               _loc2_ = this._selectedFormat;
            }
         }
         else if(this._disabledFormat !== null && !param1.isEnabled)
         {
            _loc2_ = this._disabledFormat;
         }
         if(_loc2_ === null)
         {
            _loc2_ = this._format;
         }
         return _loc2_;
      }
      
      protected function format_changeHandler(param1:Event) : void
      {
         this.dispatchEventWith(Event.CHANGE);
      }
   }
}

