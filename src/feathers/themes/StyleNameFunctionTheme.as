package feathers.themes
{
   import feathers.core.IFeathersControl;
   import feathers.skins.ConditionalStyleProvider;
   import feathers.skins.IStyleProvider;
   import feathers.skins.StyleNameFunctionStyleProvider;
   import feathers.skins.StyleProviderRegistry;
   import starling.core.Starling;
   import starling.events.EventDispatcher;
   
   public class StyleNameFunctionTheme extends EventDispatcher
   {
      
      protected static const GLOBAL_STYLE_PROVIDER_PROPERTY_NAME:String = "globalStyleProvider";
      
      protected var starling:Starling;
      
      protected var _registry:StyleProviderRegistry;
      
      protected var _conditionalRegistry:StyleProviderRegistry;
      
      public function StyleNameFunctionTheme()
      {
         super();
         if(this.starling === null)
         {
            this.starling = Starling.current;
         }
         this.createRegistry();
         this._conditionalRegistry = new StyleProviderRegistry(true,this.createConditionalStyleProvider);
      }
      
      public function dispose() : void
      {
         if(this._registry !== null)
         {
            this._registry.dispose();
            this._registry = null;
         }
         if(this._conditionalRegistry !== null)
         {
            this.disposeConditionalRegistry();
         }
      }
      
      public function getStyleProviderForClass(param1:Class) : StyleNameFunctionStyleProvider
      {
         var _loc4_:StyleNameFunctionStyleProvider = null;
         var _loc2_:IStyleProvider = IStyleProvider(param1[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME]);
         var _loc3_:ConditionalStyleProvider = ConditionalStyleProvider(this._conditionalRegistry.getStyleProvider(param1));
         if(_loc3_.trueStyleProvider === null)
         {
            _loc4_ = StyleNameFunctionStyleProvider(this._registry.getStyleProvider(param1));
            _loc3_.trueStyleProvider = _loc4_;
            _loc3_.falseStyleProvider = _loc2_;
         }
         return StyleNameFunctionStyleProvider(_loc3_.trueStyleProvider);
      }
      
      protected function createRegistry() : void
      {
         this._registry = new StyleProviderRegistry(false);
      }
      
      protected function starlingConditional(param1:IFeathersControl) : Boolean
      {
         var _loc2_:Starling = param1.stage !== null ? param1.stage.starling : Starling.current;
         return _loc2_ === this.starling;
      }
      
      protected function createConditionalStyleProvider() : ConditionalStyleProvider
      {
         return new ConditionalStyleProvider(this.starlingConditional);
      }
      
      protected function disposeConditionalRegistry() : void
      {
         var _loc4_:Class = null;
         var _loc5_:IStyleProvider = null;
         var _loc6_:ConditionalStyleProvider = null;
         var _loc7_:ConditionalStyleProvider = null;
         var _loc8_:ConditionalStyleProvider = null;
         var _loc9_:IStyleProvider = null;
         var _loc1_:Vector.<Class> = this._conditionalRegistry.getRegisteredClasses();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            _loc5_ = IStyleProvider(_loc4_[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME]);
            _loc6_ = ConditionalStyleProvider(this._conditionalRegistry.clearStyleProvider(_loc4_));
            _loc7_ = _loc5_ as ConditionalStyleProvider;
            _loc8_ = null;
            while(true)
            {
               if(_loc7_ === null)
               {
                  _loc6_.conditionalFunction = null;
                  _loc6_.trueStyleProvider = null;
                  break;
               }
               _loc9_ = _loc7_.falseStyleProvider;
               if(_loc7_ === _loc6_)
               {
                  if(_loc8_ !== null)
                  {
                     _loc8_.falseStyleProvider = _loc9_;
                  }
                  else
                  {
                     _loc4_[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME] = _loc9_;
                  }
                  break;
               }
               _loc8_ = _loc7_;
               _loc7_ = _loc9_ as ConditionalStyleProvider;
            }
            _loc3_++;
         }
         this._conditionalRegistry = null;
      }
   }
}

