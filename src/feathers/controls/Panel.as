package feathers.controls
{
   import feathers.core.IFeathersControl;
   import feathers.core.IFocusExtras;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.events.FeathersEventType;
   import feathers.skins.IStyleProvider;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class Panel extends ScrollContainer implements IFocusExtras
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_HEADER:String = "feathers-panel-header";
      
      public static const DEFAULT_CHILD_STYLE_NAME_FOOTER:String = "feathers-panel-footer";
      
      protected static const INVALIDATION_FLAG_HEADER_FACTORY:String = "headerFactory";
      
      protected static const INVALIDATION_FLAG_FOOTER_FACTORY:String = "footerFactory";
      
      protected var header:IFeathersControl;
      
      protected var footer:IFeathersControl;
      
      protected var headerStyleName:String = "feathers-panel-header";
      
      protected var footerStyleName:String = "feathers-panel-footer";
      
      protected var _explicitHeaderWidth:Number;
      
      protected var _explicitHeaderHeight:Number;
      
      protected var _explicitHeaderMinWidth:Number;
      
      protected var _explicitHeaderMinHeight:Number;
      
      protected var _explicitFooterWidth:Number;
      
      protected var _explicitFooterHeight:Number;
      
      protected var _explicitFooterMinWidth:Number;
      
      protected var _explicitFooterMinHeight:Number;
      
      protected var _title:String = null;
      
      protected var _headerTitleField:String = "title";
      
      protected var _headerFactory:Function;
      
      protected var _customHeaderStyleName:String;
      
      protected var _headerProperties:PropertyProxy;
      
      protected var _footerFactory:Function;
      
      protected var _customFooterStyleName:String;
      
      protected var _footerProperties:PropertyProxy;
      
      private var _focusExtrasBefore:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private var _focusExtrasAfter:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _outerPaddingTop:Number = 0;
      
      protected var _outerPaddingRight:Number = 0;
      
      protected var _outerPaddingBottom:Number = 0;
      
      protected var _outerPaddingLeft:Number = 0;
      
      protected var _ignoreHeaderResizing:Boolean = false;
      
      protected var _ignoreFooterResizing:Boolean = false;
      
      public function Panel()
      {
         super();
      }
      
      protected static function defaultHeaderFactory() : IFeathersControl
      {
         return new Header();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Panel.globalStyleProvider;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         if(this._title == param1)
         {
            return;
         }
         this._title = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get headerTitleField() : String
      {
         return this._headerTitleField;
      }
      
      public function set headerTitleField(param1:String) : void
      {
         if(this._headerTitleField == param1)
         {
            return;
         }
         this._headerTitleField = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get headerFactory() : Function
      {
         return this._headerFactory;
      }
      
      public function set headerFactory(param1:Function) : void
      {
         if(this._headerFactory == param1)
         {
            return;
         }
         this._headerFactory = param1;
         this.invalidate(INVALIDATION_FLAG_HEADER_FACTORY);
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get customHeaderStyleName() : String
      {
         return this._customHeaderStyleName;
      }
      
      public function set customHeaderStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customHeaderStyleName === param1)
         {
            return;
         }
         this._customHeaderStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_HEADER_FACTORY);
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get headerProperties() : Object
      {
         if(!this._headerProperties)
         {
            this._headerProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._headerProperties;
      }
      
      public function set headerProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._headerProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc2_ = new PropertyProxy();
            for(_loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            param1 = _loc2_;
         }
         if(this._headerProperties)
         {
            this._headerProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._headerProperties = PropertyProxy(param1);
         if(this._headerProperties)
         {
            this._headerProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get footerFactory() : Function
      {
         return this._footerFactory;
      }
      
      public function set footerFactory(param1:Function) : void
      {
         if(this._footerFactory == param1)
         {
            return;
         }
         this._footerFactory = param1;
         this.invalidate(INVALIDATION_FLAG_FOOTER_FACTORY);
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get customFooterStyleName() : String
      {
         return this._customFooterStyleName;
      }
      
      public function set customFooterStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customFooterStyleName === param1)
         {
            return;
         }
         this._customFooterStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_FOOTER_FACTORY);
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      public function get footerProperties() : Object
      {
         if(!this._footerProperties)
         {
            this._footerProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._footerProperties;
      }
      
      public function set footerProperties(param1:Object) : void
      {
         var _loc2_:PropertyProxy = null;
         var _loc3_:String = null;
         if(this._footerProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc2_ = new PropertyProxy();
            for(_loc3_ in param1)
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            param1 = _loc2_;
         }
         if(this._footerProperties)
         {
            this._footerProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._footerProperties = PropertyProxy(param1);
         if(this._footerProperties)
         {
            this._footerProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get focusExtrasBefore() : Vector.<DisplayObject>
      {
         return this._focusExtrasBefore;
      }
      
      public function get focusExtrasAfter() : Vector.<DisplayObject>
      {
         return this._focusExtrasAfter;
      }
      
      public function get outerPadding() : Number
      {
         return this._outerPaddingTop;
      }
      
      public function set outerPadding(param1:Number) : void
      {
         this.outerPaddingTop = param1;
         this.outerPaddingRight = param1;
         this.outerPaddingBottom = param1;
         this.outerPaddingLeft = param1;
      }
      
      public function get outerPaddingTop() : Number
      {
         return this._outerPaddingTop;
      }
      
      public function set outerPaddingTop(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._outerPaddingTop == param1)
         {
            return;
         }
         this._outerPaddingTop = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get outerPaddingRight() : Number
      {
         return this._outerPaddingRight;
      }
      
      public function set outerPaddingRight(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._outerPaddingRight == param1)
         {
            return;
         }
         this._outerPaddingRight = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get outerPaddingBottom() : Number
      {
         return this._outerPaddingBottom;
      }
      
      public function set outerPaddingBottom(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._outerPaddingBottom == param1)
         {
            return;
         }
         this._outerPaddingBottom = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get outerPaddingLeft() : Number
      {
         return this._outerPaddingLeft;
      }
      
      public function set outerPaddingLeft(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._outerPaddingLeft == param1)
         {
            return;
         }
         this._outerPaddingLeft = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_HEADER_FACTORY);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_FOOTER_FACTORY);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         if(_loc1_)
         {
            this.createHeader();
         }
         if(_loc2_)
         {
            this.createFooter();
         }
         if(_loc1_ || _loc3_)
         {
            this.refreshHeaderStyles();
         }
         if(_loc2_ || _loc3_)
         {
            this.refreshFooterStyles();
         }
         super.draw();
      }
      
      override protected function autoSizeIfNeeded() : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         if(this._autoSizeMode === AutoSizeMode.STAGE)
         {
            return super.autoSizeIfNeeded();
         }
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc5_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         var _loc6_:Number = this._explicitWidth;
         var _loc7_:Number = this._explicitHeight;
         var _loc8_:Number = this._explicitMinWidth;
         var _loc9_:Number = this._explicitMinHeight;
         if(_loc1_)
         {
            if(this._measureViewPort)
            {
               _loc6_ = this._viewPort.visibleWidth;
            }
            else
            {
               _loc6_ = 0;
            }
            _loc6_ += this._rightViewPortOffset + this._leftViewPortOffset;
            _loc10_ = this.header.width + this._outerPaddingLeft + this._outerPaddingRight;
            if(_loc10_ > _loc6_)
            {
               _loc6_ = _loc10_;
            }
            if(this.footer !== null)
            {
               _loc11_ = this.footer.width + this._outerPaddingLeft + this._outerPaddingRight;
               if(_loc11_ > _loc6_)
               {
                  _loc6_ = _loc11_;
               }
            }
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc6_)
            {
               _loc6_ = this.currentBackgroundSkin.width;
            }
         }
         if(_loc2_)
         {
            if(this._measureViewPort)
            {
               _loc7_ = this._viewPort.visibleHeight;
            }
            else
            {
               _loc7_ = 0;
            }
            _loc7_ += this._bottomViewPortOffset + this._topViewPortOffset;
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc7_)
            {
               _loc7_ = this.currentBackgroundSkin.height;
            }
         }
         if(_loc3_)
         {
            if(this._measureViewPort)
            {
               _loc8_ = this._viewPort.minVisibleWidth;
            }
            else
            {
               _loc8_ = 0;
            }
            _loc8_ += this._rightViewPortOffset + this._leftViewPortOffset;
            _loc12_ = this.header.minWidth + this._outerPaddingLeft + this._outerPaddingRight;
            if(_loc12_ > _loc8_)
            {
               _loc8_ = _loc12_;
            }
            if(this.footer !== null)
            {
               _loc13_ = this.footer.minWidth + this._outerPaddingLeft + this._outerPaddingRight;
               if(_loc13_ > _loc8_)
               {
                  _loc8_ = _loc13_;
               }
            }
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc5_ !== null)
               {
                  if(_loc5_.minWidth > _loc8_)
                  {
                     _loc8_ = _loc5_.minWidth;
                  }
               }
               else if(this._explicitBackgroundMinWidth > _loc8_)
               {
                  _loc8_ = this._explicitBackgroundMinWidth;
               }
            }
         }
         if(_loc4_)
         {
            if(this._measureViewPort)
            {
               _loc9_ = this._viewPort.minVisibleHeight;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc9_ += this._bottomViewPortOffset + this._topViewPortOffset;
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc5_ !== null)
               {
                  if(_loc5_.minHeight > _loc9_)
                  {
                     _loc9_ = _loc5_.minHeight;
                  }
               }
               else if(this._explicitBackgroundMinHeight > _loc9_)
               {
                  _loc9_ = this._explicitBackgroundMinHeight;
               }
            }
         }
         return this.saveMeasurements(_loc6_,_loc7_,_loc8_,_loc9_);
      }
      
      protected function createHeader() : void
      {
         var _loc3_:DisplayObject = null;
         if(this.header !== null)
         {
            this.header.removeEventListener(FeathersEventType.RESIZE,this.header_resizeHandler);
            _loc3_ = DisplayObject(this.header);
            this._focusExtrasBefore.splice(this._focusExtrasBefore.indexOf(_loc3_),1);
            this.removeRawChild(_loc3_,true);
            this.header = null;
         }
         var _loc1_:Function = this._headerFactory != null ? this._headerFactory : defaultHeaderFactory;
         var _loc2_:String = this._customHeaderStyleName != null ? this._customHeaderStyleName : this.headerStyleName;
         this.header = IFeathersControl(_loc1_());
         this.header.styleNameList.add(_loc2_);
         _loc3_ = DisplayObject(this.header);
         this.addRawChild(_loc3_);
         this._focusExtrasBefore.push(_loc3_);
         this.header.addEventListener(FeathersEventType.RESIZE,this.header_resizeHandler);
         this.header.initializeNow();
         this._explicitHeaderWidth = this.header.explicitWidth;
         this._explicitHeaderHeight = this.header.explicitHeight;
         this._explicitHeaderMinWidth = this.header.explicitMinWidth;
         this._explicitHeaderMinHeight = this.header.explicitMinHeight;
      }
      
      protected function createFooter() : void
      {
         var _loc2_:DisplayObject = null;
         if(this.footer !== null)
         {
            this.footer.removeEventListener(FeathersEventType.RESIZE,this.footer_resizeHandler);
            _loc2_ = DisplayObject(this.footer);
            this._focusExtrasAfter.splice(this._focusExtrasAfter.indexOf(_loc2_),1);
            this.removeRawChild(_loc2_,true);
            this.footer = null;
         }
         if(this._footerFactory === null)
         {
            return;
         }
         var _loc1_:String = this._customFooterStyleName != null ? this._customFooterStyleName : this.footerStyleName;
         this.footer = IFeathersControl(this._footerFactory());
         this.footer.styleNameList.add(_loc1_);
         this.footer.addEventListener(FeathersEventType.RESIZE,this.footer_resizeHandler);
         _loc2_ = DisplayObject(this.footer);
         this.addRawChild(_loc2_);
         this._focusExtrasAfter.push(_loc2_);
         this.footer.initializeNow();
         this._explicitFooterWidth = this.footer.explicitWidth;
         this._explicitFooterHeight = this.footer.explicitHeight;
         this._explicitFooterMinWidth = this.footer.explicitMinWidth;
         this._explicitFooterMinHeight = this.footer.explicitMinHeight;
      }
      
      protected function refreshHeaderStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(Object(this.header).hasOwnProperty(this._headerTitleField))
         {
            this.header[this._headerTitleField] = this._title;
         }
         for(_loc1_ in this._headerProperties)
         {
            _loc2_ = this._headerProperties[_loc1_];
            this.header[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshFooterStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for(_loc1_ in this._footerProperties)
         {
            _loc2_ = this._footerProperties[_loc1_];
            this.footer[_loc1_] = _loc2_;
         }
      }
      
      override protected function calculateViewPortOffsets(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc4_:Boolean = false;
         super.calculateViewPortOffsets(param1);
         this._leftViewPortOffset += this._outerPaddingLeft;
         this._rightViewPortOffset += this._outerPaddingRight;
         var _loc3_:Boolean = this._ignoreHeaderResizing;
         this._ignoreHeaderResizing = true;
         if(param2)
         {
            this.header.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
            this.header.minWidth = this.actualMinWidth - this._outerPaddingLeft - this._outerPaddingRight;
         }
         else
         {
            this.header.width = this._explicitWidth - this._outerPaddingLeft - this._outerPaddingRight;
            this.header.minWidth = this._explicitMinWidth - this._outerPaddingLeft - this._outerPaddingRight;
         }
         this.header.maxWidth = this._explicitMaxWidth - this._outerPaddingLeft - this._outerPaddingRight;
         this.header.height = this._explicitHeaderHeight;
         this.header.minHeight = this._explicitHeaderMinHeight;
         this.header.validate();
         this._topViewPortOffset += this.header.height + this._outerPaddingTop;
         this._ignoreHeaderResizing = _loc3_;
         if(this.footer !== null)
         {
            _loc4_ = this._ignoreFooterResizing;
            this._ignoreFooterResizing = true;
            if(param2)
            {
               this.footer.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
               this.footer.minWidth = this.actualMinWidth - this._outerPaddingLeft - this._outerPaddingRight;
            }
            else
            {
               this.footer.width = this._explicitWidth - this._outerPaddingLeft - this._outerPaddingRight;
               this.footer.minWidth = this._explicitMinWidth - this._outerPaddingLeft - this._outerPaddingRight;
            }
            this.footer.maxWidth = this._explicitMaxWidth - this._outerPaddingLeft - this._outerPaddingRight;
            this.footer.height = this._explicitFooterHeight;
            this.footer.minHeight = this._explicitFooterMinHeight;
            this.footer.validate();
            this._bottomViewPortOffset += this.footer.height + this._outerPaddingBottom;
            this._ignoreFooterResizing = _loc4_;
         }
         else
         {
            this._bottomViewPortOffset += this._outerPaddingBottom;
         }
      }
      
      override protected function layoutChildren() : void
      {
         var _loc2_:Boolean = false;
         super.layoutChildren();
         var _loc1_:Boolean = this._ignoreHeaderResizing;
         this._ignoreHeaderResizing = true;
         this.header.x = this._outerPaddingLeft;
         this.header.y = this._outerPaddingTop;
         this.header.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
         this.header.height = this._explicitHeaderHeight;
         this.header.validate();
         this._ignoreHeaderResizing = _loc1_;
         if(this.footer !== null)
         {
            _loc2_ = this._ignoreFooterResizing;
            this._ignoreFooterResizing = true;
            this.footer.x = this._outerPaddingLeft;
            this.footer.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
            this.footer.height = this._explicitFooterHeight;
            this.footer.validate();
            this.footer.y = this.actualHeight - this.footer.height - this._outerPaddingBottom;
            this._ignoreFooterResizing = _loc2_;
         }
      }
      
      protected function header_resizeHandler(param1:Event) : void
      {
         if(this._ignoreHeaderResizing)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
      
      protected function footer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreFooterResizing)
         {
            return;
         }
         this.invalidate(INVALIDATION_FLAG_SIZE);
      }
   }
}

