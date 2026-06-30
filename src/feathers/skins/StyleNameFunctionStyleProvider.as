package feathers.skins
{
   import feathers.core.IFeathersControl;
   import feathers.core.TokenList;
   
   public class StyleNameFunctionStyleProvider implements IStyleProvider
   {
      
      protected var _defaultStyleFunction:Function;
      
      protected var _styleNameMap:Object;
      
      public function StyleNameFunctionStyleProvider(param1:Function = null)
      {
         super();
         this._defaultStyleFunction = param1;
      }
      
      public function get defaultStyleFunction() : Function
      {
         return this._defaultStyleFunction;
      }
      
      public function set defaultStyleFunction(param1:Function) : void
      {
         this._defaultStyleFunction = param1;
      }
      
      public function setFunctionForStyleName(param1:String, param2:Function) : void
      {
         if(!this._styleNameMap)
         {
            this._styleNameMap = {};
         }
         this._styleNameMap[param1] = param2;
      }
      
      public function applyStyles(param1:IFeathersControl) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:TokenList = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Function = null;
         if(this._styleNameMap)
         {
            _loc2_ = false;
            _loc3_ = param1.styleNameList;
            _loc4_ = _loc3_.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_.item(_loc5_);
               _loc7_ = this._styleNameMap[_loc6_] as Function;
               if(_loc7_ != null)
               {
                  _loc2_ = true;
                  _loc7_(param1);
               }
               _loc5_++;
            }
            if(_loc2_)
            {
               return;
            }
         }
         if(this._defaultStyleFunction != null)
         {
            this._defaultStyleFunction(param1);
         }
      }
   }
}

