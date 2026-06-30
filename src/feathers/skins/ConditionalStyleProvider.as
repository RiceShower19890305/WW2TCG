package feathers.skins
{
   import feathers.core.IFeathersControl;
   
   public class ConditionalStyleProvider implements IStyleProvider
   {
      
      protected var _trueStyleProvider:IStyleProvider;
      
      protected var _falseStyleProvider:IStyleProvider;
      
      protected var _conditionalFunction:Function;
      
      public function ConditionalStyleProvider(param1:Function, param2:IStyleProvider = null, param3:IStyleProvider = null)
      {
         super();
         this._conditionalFunction = param1;
         this._trueStyleProvider = param2;
         this._falseStyleProvider = param3;
      }
      
      public function get trueStyleProvider() : IStyleProvider
      {
         return this._trueStyleProvider;
      }
      
      public function set trueStyleProvider(param1:IStyleProvider) : void
      {
         this._trueStyleProvider = param1;
      }
      
      public function get falseStyleProvider() : IStyleProvider
      {
         return this._falseStyleProvider;
      }
      
      public function set falseStyleProvider(param1:IStyleProvider) : void
      {
         this._falseStyleProvider = param1;
      }
      
      public function get conditionalFunction() : Function
      {
         return this._conditionalFunction;
      }
      
      public function set conditionalFunction(param1:Function) : void
      {
         this._conditionalFunction = param1;
      }
      
      public function applyStyles(param1:IFeathersControl) : void
      {
         var _loc2_:Boolean = false;
         if(this._conditionalFunction !== null)
         {
            _loc2_ = this._conditionalFunction(param1) as Boolean;
         }
         if(_loc2_ === true)
         {
            if(this._trueStyleProvider !== null)
            {
               this._trueStyleProvider.applyStyles(param1);
            }
         }
         else if(this._falseStyleProvider !== null)
         {
            this._falseStyleProvider.applyStyles(param1);
         }
      }
   }
}

