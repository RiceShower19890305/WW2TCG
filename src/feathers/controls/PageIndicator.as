package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IValidating;
   import feathers.layout.Direction;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.ILayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.VerticalLayout;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class PageIndicator extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();
      
      private static const SUGGESTED_BOUNDS:ViewPortBounds = new ViewPortBounds();
      
      protected var selectedSymbol:DisplayObject;
      
      protected var cache:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var unselectedSymbols:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var symbols:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var touchPointID:int = -1;
      
      protected var _pageCount:int = 1;
      
      protected var _selectedIndex:int = 0;
      
      protected var _interactionMode:String = "previousNext";
      
      protected var _layout:ILayout;
      
      protected var _direction:String = "horizontal";
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _gap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _normalSymbolFactory:Function = defaultNormalSymbolFactory;
      
      protected var _selectedSymbolFactory:Function = defaultSelectedSymbolFactory;
      
      public function PageIndicator()
      {
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener(TouchEvent.TOUCH,this.touchHandler);
      }
      
      protected static function defaultSelectedSymbolFactory() : Quad
      {
         return new Quad(25,25,16777215);
      }
      
      protected static function defaultNormalSymbolFactory() : Quad
      {
         return new Quad(25,25,13421772);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return PageIndicator.globalStyleProvider;
      }
      
      public function get pageCount() : int
      {
         return this._pageCount;
      }
      
      public function set pageCount(param1:int) : void
      {
         if(this._pageCount == param1)
         {
            return;
         }
         this._pageCount = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         param1 = Math.max(0,Math.min(param1,this._pageCount - 1));
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.invalidate(INVALIDATION_FLAG_SELECTED);
         this.dispatchEventWith(Event.CHANGE);
      }
      
      public function get interactionMode() : String
      {
         return this._interactionMode;
      }
      
      public function set interactionMode(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._interactionMode = param1;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._direction === param1)
         {
            return;
         }
         this._direction = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._horizontalAlign === param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._verticalAlign === param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         this.invalidate(INVALIDATION_FLAG_LAYOUT);
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingTop = param1;
         this.paddingRight = param1;
         this.paddingBottom = param1;
         this.paddingLeft = param1;
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get normalSymbolFactory() : Function
      {
         return this._normalSymbolFactory;
      }
      
      public function set normalSymbolFactory(param1:Function) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._normalSymbolFactory === param1)
         {
            return;
         }
         this._normalSymbolFactory = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get selectedSymbolFactory() : Function
      {
         return this._selectedSymbolFactory;
      }
      
      public function set selectedSymbolFactory(param1:Function) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._selectedSymbolFactory === param1)
         {
            return;
         }
         this._selectedSymbolFactory = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
         if(_loc1_ || _loc2_ || _loc3_)
         {
            this.refreshSymbols(_loc3_);
         }
         this.layoutSymbols(_loc4_);
      }
      
      protected function refreshSymbols(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         this.symbols.length = 0;
         var _loc2_:Vector.<DisplayObject> = this.cache;
         if(param1)
         {
            _loc3_ = int(this.unselectedSymbols.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = this.unselectedSymbols.shift();
               this.removeChild(_loc5_,true);
               _loc4_++;
            }
            if(this.selectedSymbol)
            {
               this.removeChild(this.selectedSymbol,true);
               this.selectedSymbol = null;
            }
         }
         this.cache = this.unselectedSymbols;
         this.unselectedSymbols = _loc2_;
         _loc4_ = 0;
         while(_loc4_ < this._pageCount)
         {
            if(_loc4_ == this._selectedIndex)
            {
               if(!this.selectedSymbol)
               {
                  this.selectedSymbol = this._selectedSymbolFactory();
                  this.addChild(this.selectedSymbol);
               }
               this.symbols.push(this.selectedSymbol);
               if(this.selectedSymbol is IValidating)
               {
                  IValidating(this.selectedSymbol).validate();
               }
            }
            else
            {
               if(this.cache.length > 0)
               {
                  _loc5_ = this.cache.shift();
               }
               else
               {
                  _loc5_ = this._normalSymbolFactory();
                  this.addChild(_loc5_);
               }
               this.unselectedSymbols.push(_loc5_);
               this.symbols.push(_loc5_);
               if(_loc5_ is IValidating)
               {
                  IValidating(_loc5_).validate();
               }
            }
            _loc4_++;
         }
         _loc3_ = int(this.cache.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.cache.shift();
            this.removeChild(_loc5_,true);
            _loc4_++;
         }
      }
      
      protected function layoutSymbols(param1:Boolean) : void
      {
         var _loc2_:VerticalLayout = null;
         var _loc3_:HorizontalLayout = null;
         if(param1)
         {
            if(this._direction == Direction.VERTICAL && !(this._layout is VerticalLayout))
            {
               this._layout = new VerticalLayout();
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            else if(this._direction != Direction.VERTICAL && !(this._layout is HorizontalLayout))
            {
               this._layout = new HorizontalLayout();
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            if(this._layout is VerticalLayout)
            {
               _loc2_ = VerticalLayout(this._layout);
               _loc2_.paddingTop = this._paddingTop;
               _loc2_.paddingRight = this._paddingRight;
               _loc2_.paddingBottom = this._paddingBottom;
               _loc2_.paddingLeft = this._paddingLeft;
               _loc2_.gap = this._gap;
               _loc2_.horizontalAlign = this._horizontalAlign;
               _loc2_.verticalAlign = this._verticalAlign;
            }
            if(this._layout is HorizontalLayout)
            {
               _loc3_ = HorizontalLayout(this._layout);
               _loc3_.paddingTop = this._paddingTop;
               _loc3_.paddingRight = this._paddingRight;
               _loc3_.paddingBottom = this._paddingBottom;
               _loc3_.paddingLeft = this._paddingLeft;
               _loc3_.gap = this._gap;
               _loc3_.horizontalAlign = this._horizontalAlign;
               _loc3_.verticalAlign = this._verticalAlign;
            }
         }
         SUGGESTED_BOUNDS.x = SUGGESTED_BOUNDS.y = 0;
         SUGGESTED_BOUNDS.scrollX = SUGGESTED_BOUNDS.scrollY = 0;
         SUGGESTED_BOUNDS.explicitWidth = this._explicitWidth;
         SUGGESTED_BOUNDS.explicitHeight = this._explicitHeight;
         SUGGESTED_BOUNDS.maxWidth = this._explicitMaxWidth;
         SUGGESTED_BOUNDS.maxHeight = this._explicitMaxHeight;
         SUGGESTED_BOUNDS.minWidth = this._explicitMinWidth;
         SUGGESTED_BOUNDS.minHeight = this._explicitMinHeight;
         this._layout.layout(this.symbols,SUGGESTED_BOUNDS,LAYOUT_RESULT);
         this.saveMeasurements(LAYOUT_RESULT.contentWidth,LAYOUT_RESULT.contentHeight,LAYOUT_RESULT.contentWidth,LAYOUT_RESULT.contentHeight);
      }
      
      protected function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:Point = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(!this._isEnabled || this._pageCount < 2)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,TouchPhase.ENDED,this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            _loc3_ = Pool.getPoint();
            _loc2_.getLocation(this.stage,_loc3_);
            _loc4_ = this.contains(this.stage.hitTest(_loc3_));
            if(_loc4_)
            {
               _loc5_ = this._pageCount - 1;
               this.globalToLocal(_loc3_,_loc3_);
               if(this._direction == Direction.VERTICAL)
               {
                  if(this._interactionMode === PageIndicatorInteractionMode.PRECISE)
                  {
                     _loc6_ = this.selectedSymbol.height + (this.unselectedSymbols[0].height + this._gap) * _loc5_;
                     _loc7_ = Math.round(_loc5_ * (_loc3_.y - this.symbols[0].y) / _loc6_);
                     if(_loc7_ < 0)
                     {
                        _loc7_ = 0;
                     }
                     else if(_loc7_ > _loc5_)
                     {
                        _loc7_ = _loc5_;
                     }
                     this.selectedIndex = _loc7_;
                  }
                  else
                  {
                     if(_loc3_.y < this.selectedSymbol.y)
                     {
                        this.selectedIndex = Math.max(0,this._selectedIndex - 1);
                     }
                     if(_loc3_.y > this.selectedSymbol.y + this.selectedSymbol.height)
                     {
                        this.selectedIndex = Math.min(_loc5_,this._selectedIndex + 1);
                     }
                  }
               }
               else if(this._interactionMode === PageIndicatorInteractionMode.PRECISE)
               {
                  _loc8_ = this.selectedSymbol.width + (this.unselectedSymbols[0].width + this._gap) * _loc5_;
                  _loc7_ = Math.round(_loc5_ * (_loc3_.x - this.symbols[0].x) / _loc8_);
                  if(_loc7_ < 0)
                  {
                     _loc7_ = 0;
                  }
                  else if(_loc7_ >= this._pageCount)
                  {
                     _loc7_ = _loc5_;
                  }
                  this.selectedIndex = _loc7_;
               }
               else
               {
                  if(_loc3_.x < this.selectedSymbol.x)
                  {
                     this.selectedIndex = Math.max(0,this._selectedIndex - 1);
                  }
                  if(_loc3_.x > this.selectedSymbol.x + this.selectedSymbol.width)
                  {
                     this.selectedIndex = Math.min(_loc5_,this._selectedIndex + 1);
                  }
               }
            }
            Pool.putPoint(_loc3_);
         }
         else
         {
            _loc2_ = param1.getTouch(this,TouchPhase.BEGAN);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = _loc2_.id;
         }
      }
   }
}

