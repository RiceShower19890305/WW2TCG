package feathers.controls.renderers
{
   import feathers.controls.DataGrid;
   import feathers.controls.DataGridColumn;
   import feathers.controls.ImageLoader;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.data.SortOrder;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.VerticalAlign;
   import feathers.skins.IStyleProvider;
   import feathers.text.FontStylesSet;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import feathers.utils.touch.TapToTrigger;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.text.TextFormat;
   import starling.utils.Pool;
   
   public class DefaultDataGridHeaderRenderer extends FeathersControl implements IDataGridHeaderRenderer
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER:String = "feathers-data-grid-header-renderer-text-renderer";
      
      protected var _tapToTrigger:TapToTrigger = null;
      
      protected var textRendererStyleName:String = "feathers-data-grid-header-renderer-text-renderer";
      
      protected var textRenderer:ITextRenderer;
      
      protected var _data:DataGridColumn = null;
      
      protected var _columnIndex:int = -1;
      
      protected var _owner:DataGrid = null;
      
      protected var _sortOrder:String = "none";
      
      protected var _horizontalAlign:String = "left";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _fontStylesSet:FontStylesSet;
      
      private var _wordWrap:Boolean = false;
      
      protected var _textRendererFactory:Function = null;
      
      protected var _customTextRendererStyleName:String = null;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var _explicitTextRendererWidth:Number;
      
      protected var _explicitTextRendererHeight:Number;
      
      protected var _explicitTextRendererMinWidth:Number;
      
      protected var _explicitTextRendererMinHeight:Number;
      
      protected var _explicitTextRendererMaxWidth:Number;
      
      protected var _explicitTextRendererMaxHeight:Number;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var currentSortIcon:DisplayObject = null;
      
      protected var _sortAscendingIcon:DisplayObject = null;
      
      protected var _sortDescendingIcon:DisplayObject = null;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function DefaultDataGridHeaderRenderer()
      {
         super();
         this.isQuickHitAreaEnabled = true;
         if(this._fontStylesSet === null)
         {
            this._fontStylesSet = new FontStylesSet();
            this._fontStylesSet.addEventListener(Event.CHANGE,this.fontStyles_changeHandler);
         }
      }
      
      protected static function defaultImageLoaderFactory() : ImageLoader
      {
         return new ImageLoader();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DefaultDataGridHeaderRenderer.globalStyleProvider;
      }
      
      public function get data() : DataGridColumn
      {
         return this._data;
      }
      
      public function set data(param1:DataGridColumn) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get columnIndex() : int
      {
         return this._columnIndex;
      }
      
      public function set columnIndex(param1:int) : void
      {
         this._columnIndex = param1;
      }
      
      public function get owner() : DataGrid
      {
         return this._owner;
      }
      
      public function set owner(param1:DataGrid) : void
      {
         if(this._owner === param1)
         {
            return;
         }
         this._owner = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get sortOrder() : String
      {
         return this._sortOrder;
      }
      
      public function set sortOrder(param1:String) : void
      {
         if(this._sortOrder === param1)
         {
            return;
         }
         this._sortOrder = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get fontStyles() : TextFormat
      {
         return this._fontStylesSet.format;
      }
      
      public function set fontStyles(param1:TextFormat) : void
      {
         var savedCallee:Function = null;
         var changeHandler:Function = null;
         var value:TextFormat = param1;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(savedCallee);
         };
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         savedCallee = arguments.callee;
         if(value !== null)
         {
            value.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._fontStylesSet.format = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get disabledFontStyles() : TextFormat
      {
         return this._fontStylesSet.disabledFormat;
      }
      
      public function set disabledFontStyles(param1:TextFormat) : void
      {
         var savedCallee:Function = null;
         var changeHandler:Function = null;
         var value:TextFormat = param1;
         changeHandler = function(param1:Event):void
         {
            processStyleRestriction(savedCallee);
         };
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         savedCallee = arguments.callee;
         if(value !== null)
         {
            value.removeEventListener(Event.CHANGE,changeHandler);
         }
         this._fontStylesSet.disabledFormat = value;
         if(value !== null)
         {
            value.addEventListener(Event.CHANGE,changeHandler);
         }
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get textRendererFactory() : Function
      {
         return this._textRendererFactory;
      }
      
      public function set textRendererFactory(param1:Function) : void
      {
         if(this._textRendererFactory == param1)
         {
            return;
         }
         this._textRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customTextRendererStyleName() : String
      {
         return this._customTextRendererStyleName;
      }
      
      public function set customTextRendererStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customTextRendererStyleName === param1)
         {
            return;
         }
         this._customTextRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._backgroundSkin === param1)
         {
            return;
         }
         if(this._backgroundSkin !== null && this.currentBackgroundSkin === this._backgroundSkin)
         {
            this.removeCurrentBackgroundSkin(this._backgroundSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundSkin = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._backgroundDisabledSkin === param1)
         {
            return;
         }
         if(this._backgroundDisabledSkin !== null && this.currentBackgroundSkin === this._backgroundDisabledSkin)
         {
            this.removeCurrentBackgroundSkin(this._backgroundDisabledSkin);
            this.currentBackgroundSkin = null;
         }
         this._backgroundDisabledSkin = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get sortAscendingIcon() : DisplayObject
      {
         return this._sortAscendingIcon;
      }
      
      public function set sortAscendingIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._sortAscendingIcon === param1)
         {
            return;
         }
         if(this._sortAscendingIcon !== null && this.currentSortIcon === this._sortAscendingIcon)
         {
            this.removeCurrentSortIcon(this._sortAscendingIcon);
            this.currentSortIcon = null;
         }
         this._sortAscendingIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
      
      public function get sortDescendingIcon() : DisplayObject
      {
         return this._sortDescendingIcon;
      }
      
      public function set sortDescendingIcon(param1:DisplayObject) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            if(param1 !== null)
            {
               param1.dispose();
            }
            return;
         }
         if(this._sortDescendingIcon === param1)
         {
            return;
         }
         if(this._sortDescendingIcon !== null && this.currentSortIcon === this._sortDescendingIcon)
         {
            this.removeCurrentSortIcon(this._sortDescendingIcon);
            this.currentSortIcon = null;
         }
         this._sortDescendingIcon = param1;
         this.invalidate(INVALIDATION_FLAG_STYLES);
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
      
      public function get numLines() : int
      {
         if(this.textRenderer === null)
         {
            return 0;
         }
         return this.textRenderer.numLines;
      }
      
      override public function dispose() : void
      {
         if(this._backgroundSkin !== null && this._backgroundSkin.parent !== this)
         {
            this._backgroundSkin.dispose();
         }
         if(this._backgroundDisabledSkin !== null && this._backgroundDisabledSkin.parent !== this)
         {
            this._backgroundDisabledSkin.dispose();
         }
         if(this._fontStylesSet !== null)
         {
            this._fontStylesSet.dispose();
            this._fontStylesSet = null;
         }
         super.dispose();
      }
      
      protected function itemToText(param1:DataGridColumn) : String
      {
         if(param1 !== null)
         {
            if(param1.headerText !== null)
            {
               return param1.headerText;
            }
            if(param1.dataField !== null)
            {
               return param1.dataField;
            }
            return Object(param1).toString();
         }
         return null;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(this._tapToTrigger === null)
         {
            this._tapToTrigger = new TapToTrigger(this);
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
         if(_loc2_ || _loc3_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc2_ || _loc1_)
         {
            this.refreshSortIcon();
         }
         if(_loc5_)
         {
            this.createTextRenderer();
         }
         if(_loc5_ || _loc1_)
         {
            this.commitData();
         }
         if(_loc1_ || _loc2_)
         {
            this.refreshTextRendererStyles();
         }
         if(_loc1_ || _loc3_)
         {
            this.refreshEnabled();
         }
         _loc4_ = this.autoSizeIfNeeded() || _loc4_;
         this.layoutChildren();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         resetFluidChildDimensionsForMeasurement(DisplayObject(this.textRenderer),this._explicitWidth - this._paddingLeft - this._paddingRight,this._explicitHeight - this._paddingTop - this._paddingBottom,this._explicitMinWidth - this._paddingLeft - this._paddingRight,this._explicitMinHeight - this._paddingTop - this._paddingBottom,this._explicitMaxWidth - this._paddingLeft - this._paddingRight,this._explicitMaxHeight - this._paddingTop - this._paddingBottom,this._explicitTextRendererWidth,this._explicitTextRendererHeight,this._explicitTextRendererMinWidth,this._explicitTextRendererMinHeight,this._explicitTextRendererMaxWidth,this._explicitTextRendererMaxHeight);
         this.textRenderer.maxWidth = this._explicitMaxWidth - this._paddingLeft - this._paddingRight;
         this.textRenderer.maxHeight = this._explicitMaxHeight - this._paddingTop - this._paddingBottom;
         var _loc5_:Point = Pool.getPoint();
         this.textRenderer.measureText(_loc5_);
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         var _loc6_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         var _loc7_:Number = this._explicitWidth;
         if(_loc1_)
         {
            _loc7_ = _loc5_.x;
            _loc7_ = _loc7_ + (this._paddingLeft + this._paddingRight);
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.width > _loc7_)
            {
               _loc7_ = this.currentBackgroundSkin.width;
            }
         }
         var _loc8_:Number = this._explicitHeight;
         if(_loc2_)
         {
            _loc8_ = _loc5_.y;
            _loc8_ = _loc8_ + (this._paddingTop + this._paddingBottom);
            if(this.currentBackgroundSkin !== null && this.currentBackgroundSkin.height > _loc8_)
            {
               _loc8_ = this.currentBackgroundSkin.height;
            }
         }
         var _loc9_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            _loc9_ = _loc5_.x;
            _loc9_ = _loc9_ + (this._paddingLeft + this._paddingRight);
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minWidth > _loc9_)
                  {
                     _loc9_ = _loc6_.minWidth;
                  }
               }
               else if(this._explicitBackgroundMinWidth > _loc9_)
               {
                  _loc9_ = this._explicitBackgroundMinWidth;
               }
            }
         }
         var _loc10_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            _loc10_ = _loc5_.y;
            _loc10_ = _loc10_ + (this._paddingTop + this._paddingBottom);
            if(this.currentBackgroundSkin !== null)
            {
               if(_loc6_ !== null)
               {
                  if(_loc6_.minHeight > _loc10_)
                  {
                     _loc10_ = _loc6_.minHeight;
                  }
               }
               else if(this._explicitBackgroundMinHeight > _loc10_)
               {
                  _loc10_ = this._explicitBackgroundMinHeight;
               }
            }
         }
         Pool.putPoint(_loc5_);
         return this.saveMeasurements(_loc7_,_loc8_,_loc9_,_loc10_);
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackgroundSkin;
         this.currentBackgroundSkin = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         if(_loc1_ !== this.currentBackgroundSkin)
         {
            this.removeCurrentBackgroundSkin(_loc1_);
            if(this.currentBackgroundSkin !== null)
            {
               if(this.currentBackgroundSkin is IFeathersControl)
               {
                  IFeathersControl(this.currentBackgroundSkin).initializeNow();
               }
               if(this.currentBackgroundSkin is IMeasureDisplayObject)
               {
                  _loc2_ = IMeasureDisplayObject(this.currentBackgroundSkin);
                  this._explicitBackgroundWidth = _loc2_.explicitWidth;
                  this._explicitBackgroundHeight = _loc2_.explicitHeight;
                  this._explicitBackgroundMinWidth = _loc2_.explicitMinWidth;
                  this._explicitBackgroundMinHeight = _loc2_.explicitMinHeight;
                  this._explicitBackgroundMaxWidth = _loc2_.explicitMaxWidth;
                  this._explicitBackgroundMaxHeight = _loc2_.explicitMaxHeight;
               }
               else
               {
                  this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
                  this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
                  this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
                  this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
                  this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
               }
               this.addChildAt(this.currentBackgroundSkin,0);
            }
         }
      }
      
      protected function refreshSortIcon() : void
      {
         var _loc1_:DisplayObject = this.currentSortIcon;
         this.currentSortIcon = null;
         if(this._sortOrder === SortOrder.ASCENDING)
         {
            this.currentSortIcon = this._sortAscendingIcon;
         }
         else if(this._sortOrder === SortOrder.DESCENDING)
         {
            this.currentSortIcon = this._sortDescendingIcon;
         }
         if(_loc1_ !== this.currentSortIcon)
         {
            this.removeCurrentSortIcon(_loc1_);
            if(this.currentSortIcon !== null)
            {
               this.addChild(this.currentSortIcon);
            }
         }
      }
      
      protected function removeCurrentBackgroundSkin(param1:DisplayObject) : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         if(param1 === null)
         {
            return;
         }
         if(param1.parent === this)
         {
            param1.width = this._explicitBackgroundWidth;
            param1.height = this._explicitBackgroundHeight;
            if(param1 is IMeasureDisplayObject)
            {
               _loc2_ = IMeasureDisplayObject(param1);
               _loc2_.minWidth = this._explicitBackgroundMinWidth;
               _loc2_.minHeight = this._explicitBackgroundMinHeight;
               _loc2_.maxWidth = this._explicitBackgroundMaxWidth;
               _loc2_.maxHeight = this._explicitBackgroundMaxHeight;
            }
            param1.removeFromParent(false);
         }
      }
      
      protected function removeCurrentSortIcon(param1:DisplayObject) : void
      {
         if(param1 === null)
         {
            return;
         }
         if(param1.parent === this)
         {
            param1.removeFromParent(false);
         }
      }
      
      protected function createTextRenderer() : void
      {
         if(this.textRenderer !== null)
         {
            this.removeChild(DisplayObject(this.textRenderer),true);
            this.textRenderer = null;
         }
         var _loc1_:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
         this.textRenderer = ITextRenderer(_loc1_());
         var _loc2_:String = this._customTextRendererStyleName != null ? this._customTextRendererStyleName : this.textRendererStyleName;
         this.textRenderer.styleNameList.add(_loc2_);
         this.addChild(DisplayObject(this.textRenderer));
         this.textRenderer.initializeNow();
         this._explicitTextRendererWidth = this.textRenderer.explicitWidth;
         this._explicitTextRendererHeight = this.textRenderer.explicitHeight;
         this._explicitTextRendererMinWidth = this.textRenderer.explicitMinWidth;
         this._explicitTextRendererMinHeight = this.textRenderer.explicitMinHeight;
         this._explicitTextRendererMaxWidth = this.textRenderer.explicitMaxWidth;
         this._explicitTextRendererMaxHeight = this.textRenderer.explicitMaxHeight;
      }
      
      protected function commitData() : void
      {
         if(this._owner)
         {
            this.textRenderer.text = this.itemToText(this._data);
         }
         else
         {
            this.textRenderer.text = null;
         }
      }
      
      protected function refreshEnabled() : void
      {
         this.textRenderer.isEnabled = this._isEnabled;
      }
      
      protected function refreshTextRendererStyles() : void
      {
         this.textRenderer.fontStyles = this._fontStylesSet;
         this.textRenderer.wordWrap = this._wordWrap;
      }
      
      protected function layoutChildren() : void
      {
         if(this.currentBackgroundSkin !== null)
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
         if(this.currentSortIcon is IValidating)
         {
            IValidating(this.currentSortIcon).validate();
         }
         var _loc1_:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
         if(this.currentSortIcon)
         {
            _loc1_ -= this.currentSortIcon.width;
         }
         this.textRenderer.width = this._explicitTextRendererWidth;
         this.textRenderer.height = this._explicitTextRendererHeight;
         this.textRenderer.minWidth = this._explicitTextRendererMinWidth;
         this.textRenderer.minHeight = this._explicitTextRendererMinHeight;
         this.textRenderer.maxWidth = _loc1_;
         this.textRenderer.maxHeight = this._explicitTextRendererMaxHeight;
         this.textRenderer.validate();
         switch(this._horizontalAlign)
         {
            case HorizontalAlign.CENTER:
               this.textRenderer.x = this._paddingLeft + (_loc1_ - this.textRenderer.width) / 2;
               break;
            case HorizontalAlign.RIGHT:
               this.textRenderer.x = this._paddingLeft + _loc1_ - this.textRenderer.width;
               break;
            default:
               this.textRenderer.x = this._paddingLeft;
         }
         if(this.currentSortIcon !== null)
         {
            this.currentSortIcon.x = this.actualWidth - this._paddingRight - this.currentSortIcon.width;
         }
         switch(this._verticalAlign)
         {
            case VerticalAlign.TOP:
               this.textRenderer.y = this._paddingTop;
               if(this.currentSortIcon !== null)
               {
                  this.currentSortIcon.y = this._paddingTop;
               }
               break;
            case VerticalAlign.BOTTOM:
               this.textRenderer.y = this.actualHeight - this._paddingBottom - this.textRenderer.height;
               if(this.currentSortIcon !== null)
               {
                  this.currentSortIcon.y = this.actualHeight - this._paddingBottom - this.currentSortIcon.height;
               }
               break;
            default:
               this.textRenderer.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.textRenderer.height) / 2;
               if(this.currentSortIcon !== null)
               {
                  this.currentSortIcon.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.currentSortIcon.height) / 2;
               }
         }
      }
      
      protected function fontStyles_changeHandler(param1:Event) : void
      {
         this.invalidate(INVALIDATION_FLAG_STYLES);
      }
   }
}

