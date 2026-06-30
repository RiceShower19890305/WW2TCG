package feathers.controls
{
   import feathers.controls.renderers.DefaultListItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import feathers.data.IListCollection;
   import feathers.data.VectorCollection;
   import feathers.events.FeathersEventType;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.VerticalAlign;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.roundDownToNearest;
   import feathers.utils.math.roundUpToNearest;
   import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
   import flash.globalization.DateTimeFormatter;
   import flash.globalization.DateTimeNameStyle;
   import flash.globalization.DateTimeStyle;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class DateTimeSpinner extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-date-time-spinner-list";
      
      private static const MS_PER_DAY:int = 86400000;
      
      private static const MIN_MONTH_VALUE:int = 0;
      
      private static const MAX_MONTH_VALUE:int = 11;
      
      private static const MIN_DATE_VALUE:int = 1;
      
      private static const MAX_DATE_VALUE:int = 31;
      
      private static const MIN_HOURS_VALUE:int = 0;
      
      private static const MAX_HOURS_VALUE_12HOURS:int = 11;
      
      private static const MAX_HOURS_VALUE_24HOURS:int = 23;
      
      private static const MIN_MINUTES_VALUE:int = 0;
      
      private static const MAX_MINUTES_VALUE:int = 59;
      
      private static const HELPER_DATE:Date = new Date();
      
      private static const DAYS_IN_MONTH:Vector.<int> = new Vector.<int>(0);
      
      protected static const INVALIDATION_FLAG_LOCALE:String = "locale";
      
      protected static const INVALIDATION_FLAG_EDITING_MODE:String = "editingMode";
      
      protected static const INVALIDATION_FLAG_PENDING_SCROLL:String = "pendingScroll";
      
      protected static const INVALIDATION_FLAG_SPINNER_LIST_FACTORY:String = "spinnerListFactory";
      
      protected var listStyleName:String = "feathers-date-time-spinner-list";
      
      protected var monthsList:SpinnerList;
      
      protected var datesList:SpinnerList;
      
      protected var yearsList:SpinnerList;
      
      protected var dateAndTimeDatesList:SpinnerList;
      
      protected var hoursList:SpinnerList;
      
      protected var minutesList:SpinnerList;
      
      protected var meridiemList:SpinnerList;
      
      protected var listGroup:LayoutGroup;
      
      protected var _locale:String = "i-default";
      
      protected var _value:Date;
      
      protected var _minimum:Date;
      
      protected var _maximum:Date;
      
      protected var _minuteStep:int = 1;
      
      protected var _editingMode:String = "dateAndTime";
      
      protected var _formatter:DateTimeFormatter;
      
      protected var _longestMonthNameIndex:int;
      
      protected var _localeMonthNames:Vector.<String>;
      
      protected var _localeWeekdayNames:Vector.<String>;
      
      protected var _ignoreListChanges:Boolean = false;
      
      protected var _monthFirst:Boolean = true;
      
      protected var _showMeridiem:Boolean = true;
      
      protected var _lastMeridiemValue:int = 0;
      
      protected var _listMinYear:int;
      
      protected var _listMaxYear:int;
      
      protected var _minYear:int;
      
      protected var _maxYear:int;
      
      protected var _minMonth:int;
      
      protected var _maxMonth:int;
      
      protected var _minDate:int;
      
      protected var _maxDate:int;
      
      protected var _minHours:int;
      
      protected var _maxHours:int;
      
      protected var _minMinute:int;
      
      protected var _maxMinute:int;
      
      protected var _scrollDuration:Number = 0.5;
      
      protected var _itemRendererFactory:Function = null;
      
      protected var _listFactory:Function;
      
      protected var _customListStyleName:String;
      
      protected var _customItemRendererStyleName:String;
      
      protected var _lastValidate:Date;
      
      protected var _todayLabel:String = null;
      
      protected var _explicitBackgroundWidth:Number;
      
      protected var _explicitBackgroundHeight:Number;
      
      protected var _explicitBackgroundMinWidth:Number;
      
      protected var _explicitBackgroundMinHeight:Number;
      
      protected var _explicitBackgroundMaxWidth:Number;
      
      protected var _explicitBackgroundMaxHeight:Number;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _amString:String;
      
      protected var _pmString:String;
      
      protected var pendingScrollToDate:Date;
      
      protected var pendingScrollDuration:Number;
      
      public function DateTimeSpinner()
      {
         var _loc1_:int = 0;
         super();
         if(DAYS_IN_MONTH.length == 0)
         {
            HELPER_DATE.setFullYear(2015);
            _loc1_ = MIN_MONTH_VALUE;
            while(_loc1_ <= MAX_MONTH_VALUE)
            {
               HELPER_DATE.setMonth(_loc1_ + 1,-1);
               DAYS_IN_MONTH[_loc1_] = HELPER_DATE.date + 1;
               _loc1_++;
            }
            DAYS_IN_MONTH.fixed = true;
         }
      }
      
      protected static function defaultListFactory() : SpinnerList
      {
         return new SpinnerList();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DateTimeSpinner.globalStyleProvider;
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(param1:String) : void
      {
         if(this._locale == param1)
         {
            return;
         }
         this._locale = param1;
         this._formatter = null;
         this.invalidate(INVALIDATION_FLAG_LOCALE);
      }
      
      public function get value() : Date
      {
         return this._value;
      }
      
      public function set value(param1:Date) : void
      {
         var _loc2_:Number = param1.time;
         if(Boolean(this._minimum) && this._minimum.time > _loc2_)
         {
            _loc2_ = this._minimum.time;
         }
         if(Boolean(this._maximum) && this._maximum.time < _loc2_)
         {
            _loc2_ = this._maximum.time;
         }
         if(Boolean(this._value) && this._value.time == _loc2_)
         {
            return;
         }
         this._value = new Date(_loc2_);
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get minimum() : Date
      {
         return this._minimum;
      }
      
      public function set minimum(param1:Date) : void
      {
         if(this._minimum == param1)
         {
            return;
         }
         this._minimum = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get maximum() : Date
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Date) : void
      {
         if(this._maximum == param1)
         {
            return;
         }
         this._maximum = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get minuteStep() : int
      {
         return this._minuteStep;
      }
      
      public function set minuteStep(param1:int) : void
      {
         if(60 % param1 != 0)
         {
            throw new ArgumentError("minuteStep must evenly divide into 60.");
         }
         if(this._minuteStep == param1)
         {
            return;
         }
         this._minuteStep = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      public function get editingMode() : String
      {
         return this._editingMode;
      }
      
      public function set editingMode(param1:String) : void
      {
         if(this._editingMode == param1)
         {
            return;
         }
         this._editingMode = param1;
         this.invalidate(INVALIDATION_FLAG_EDITING_MODE);
      }
      
      public function get scrollDuration() : Number
      {
         return this._scrollDuration;
      }
      
      public function set scrollDuration(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._scrollDuration == param1)
         {
            return;
         }
         this._scrollDuration = param1;
      }
      
      public function get itemRendererFactory() : Function
      {
         return this._itemRendererFactory;
      }
      
      public function set itemRendererFactory(param1:Function) : void
      {
         if(this._itemRendererFactory === param1)
         {
            return;
         }
         this._itemRendererFactory = param1;
         this.invalidate(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);
      }
      
      public function get listFactory() : Function
      {
         return this._listFactory;
      }
      
      public function set listFactory(param1:Function) : void
      {
         if(this._listFactory == param1)
         {
            return;
         }
         this._listFactory = param1;
         this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
      }
      
      public function get customListStyleName() : String
      {
         return this._customListStyleName;
      }
      
      public function set customListStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customListStyleName === param1)
         {
            return;
         }
         this._customListStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);
      }
      
      public function get customItemRendererStyleName() : String
      {
         return this._customItemRendererStyleName;
      }
      
      public function set customItemRendererStyleName(param1:String) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._customItemRendererStyleName === param1)
         {
            return;
         }
         this._customItemRendererStyleName = param1;
         this.invalidate(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);
      }
      
      public function get todayLabel() : String
      {
         return this._todayLabel;
      }
      
      public function set todayLabel(param1:String) : void
      {
         if(this._todayLabel == param1)
         {
            return;
         }
         this._todayLabel = param1;
         this.invalidate(INVALIDATION_FLAG_DATA);
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
         this.invalidate(INVALIDATION_FLAG_SKIN);
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
         this.invalidate(INVALIDATION_FLAG_SKIN);
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
      
      public function scrollToDate(param1:Date, param2:Number = NaN) : void
      {
         if(Boolean(this.pendingScrollToDate) && Boolean(this.pendingScrollToDate.time == param1.time) && this.pendingScrollDuration == param2)
         {
            return;
         }
         this.pendingScrollToDate = param1;
         this.pendingScrollDuration = param2;
         this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
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
         super.dispose();
      }
      
      override protected function initialize() : void
      {
         var _loc1_:HorizontalLayout = null;
         if(this.listGroup === null)
         {
            _loc1_ = new HorizontalLayout();
            _loc1_.horizontalAlign = HorizontalAlign.CENTER;
            _loc1_.verticalAlign = VerticalAlign.JUSTIFY;
            this.listGroup = new LayoutGroup();
            this.listGroup.layout = _loc1_;
            this.addChild(this.listGroup);
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
         var _loc2_:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
         var _loc3_:Boolean = this.isInvalid(INVALIDATION_FLAG_EDITING_MODE);
         var _loc4_:Boolean = this.isInvalid(INVALIDATION_FLAG_LOCALE);
         var _loc5_:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
         var _loc6_:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_SCROLL);
         var _loc7_:Boolean = this.isInvalid(INVALIDATION_FLAG_SPINNER_LIST_FACTORY);
         if(this._todayLabel)
         {
            this._lastValidate = new Date();
         }
         if(_loc1_ || _loc2_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc4_ || _loc3_)
         {
            this.refreshLocale();
         }
         if(_loc4_ || _loc3_ || _loc7_)
         {
            this.refreshLists(_loc3_ || _loc7_,_loc4_);
         }
         if(_loc4_ || _loc3_ || _loc5_ || _loc7_)
         {
            this.useDefaultsIfNeeded();
            this.refreshValidRanges();
            this.refreshSelection();
         }
         if(_loc4_ || _loc3_ || _loc2_ || _loc7_)
         {
            this.refreshEnabled();
         }
         this.autoSizeIfNeeded();
         this.layoutChildren();
         if(_loc6_)
         {
            this.handlePendingScroll();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc1_:Boolean = this._explicitWidth !== this._explicitWidth;
         var _loc2_:Boolean = this._explicitHeight !== this._explicitHeight;
         var _loc3_:Boolean = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:Boolean = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc2_ && !_loc3_ && !_loc4_)
         {
            return false;
         }
         var _loc5_:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
         resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,this._explicitWidth,this._explicitHeight,this._explicitMinWidth,this._explicitMinHeight,this._explicitMaxWidth,this._explicitMaxHeight,this._explicitBackgroundWidth,this._explicitBackgroundHeight,this._explicitBackgroundMinWidth,this._explicitBackgroundMinHeight,this._explicitBackgroundMaxWidth,this._explicitBackgroundMaxHeight);
         if(this.currentBackgroundSkin is IValidating)
         {
            IValidating(this.currentBackgroundSkin).validate();
         }
         this.listGroup.width = this._explicitWidth;
         this.listGroup.height = this._explicitHeight;
         this.listGroup.minWidth = this._explicitMinWidth;
         this.listGroup.minHeight = this._explicitMinHeight;
         this.listGroup.validate();
         var _loc6_:Number = this._explicitMinWidth;
         if(_loc3_)
         {
            if(_loc5_ !== null)
            {
               _loc6_ = _loc5_.minWidth;
            }
            else if(this.currentBackgroundSkin !== null)
            {
               _loc6_ = this._explicitBackgroundMinWidth;
            }
            else
            {
               _loc6_ = 0;
            }
            _loc10_ = this.listGroup.minWidth;
            _loc10_ = _loc10_ + (this._paddingLeft + this._paddingRight);
            if(_loc10_ > _loc6_)
            {
               _loc6_ = _loc10_;
            }
         }
         var _loc7_:Number = this._explicitMinHeight;
         if(_loc4_)
         {
            if(_loc5_ !== null)
            {
               _loc7_ = _loc5_.minHeight;
            }
            else if(this.currentBackgroundSkin !== null)
            {
               _loc7_ = this._explicitBackgroundMinHeight;
            }
            else
            {
               _loc7_ = 0;
            }
            _loc11_ = this.listGroup.minHeight;
            _loc11_ = _loc11_ + (this._paddingTop + this._paddingBottom);
            if(_loc11_ > _loc7_)
            {
               _loc7_ = _loc11_;
            }
         }
         var _loc8_:Number = this._explicitWidth;
         if(_loc1_)
         {
            if(this.currentBackgroundSkin !== null)
            {
               _loc8_ = this.currentBackgroundSkin.width;
            }
            else
            {
               _loc8_ = 0;
            }
            _loc12_ = this.listGroup.width + this._paddingLeft + this._paddingRight;
            if(_loc12_ > _loc8_)
            {
               _loc8_ = _loc12_;
            }
         }
         var _loc9_:Number = this._explicitHeight;
         if(_loc2_)
         {
            if(this.currentBackgroundSkin !== null)
            {
               _loc9_ = this.currentBackgroundSkin.height;
            }
            else
            {
               _loc9_ = 0;
            }
            _loc13_ = this.listGroup.height + this._paddingTop + this._paddingBottom;
            if(_loc13_ > _loc9_)
            {
               _loc9_ = _loc13_;
            }
         }
         return this.saveMeasurements(_loc8_,_loc9_,_loc6_,_loc7_);
      }
      
      protected function refreshBackgroundSkin() : void
      {
         var _loc2_:IMeasureDisplayObject = null;
         var _loc1_:DisplayObject = this.currentBackgroundSkin;
         this.currentBackgroundSkin = this.getCurrentBackgroundSkin();
         if(this.currentBackgroundSkin !== _loc1_)
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
            this.setRequiresRedraw();
            param1.removeFromParent(false);
         }
      }
      
      protected function getCurrentBackgroundSkin() : DisplayObject
      {
         if(!this._isEnabled && this._backgroundDisabledSkin !== null)
         {
            return this._backgroundDisabledSkin;
         }
         return this._backgroundSkin;
      }
      
      protected function refreshLists(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:IListCollection = null;
         var _loc4_:IListCollection = null;
         if(param1)
         {
            this.createYearList();
            this.createMonthList();
            this.createDateList();
            this.createHourList();
            this.createMinuteList();
            this.createMeridiemList();
            this.createDateAndTimeDateList();
         }
         else if(this._showMeridiem && !this.meridiemList || Boolean(!this._showMeridiem) && Boolean(this.meridiemList))
         {
            this.createMeridiemList();
         }
         if(this._editingMode == DateTimeMode.DATE)
         {
            if(this._monthFirst)
            {
               this.listGroup.setChildIndex(this.monthsList,0);
            }
            else
            {
               this.listGroup.setChildIndex(this.datesList,0);
            }
         }
         if(param2)
         {
            if(this.monthsList)
            {
               _loc3_ = this.monthsList.dataProvider;
               if(_loc3_)
               {
                  _loc3_.updateAll();
               }
            }
            if(this.dateAndTimeDatesList)
            {
               _loc4_ = this.dateAndTimeDatesList.dataProvider;
               if(_loc4_)
               {
                  _loc4_.updateAll();
               }
            }
         }
      }
      
      protected function createYearList() : void
      {
         if(this.yearsList)
         {
            this.listGroup.removeChild(this.yearsList,true);
            this.yearsList = null;
         }
         if(this._editingMode !== DateTimeMode.DATE)
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.yearsList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.yearsList.styleNameList.add(_loc2_);
         if(this._itemRendererFactory !== null)
         {
            this.yearsList.itemRendererFactory = this._itemRendererFactory;
         }
         if(this._customItemRendererStyleName !== null)
         {
            this.yearsList.customItemRendererStyleName = this._customItemRendererStyleName;
         }
         this.yearsList.addEventListener(FeathersEventType.RENDERER_ADD,this.yearsList_rendererAddHandler);
         this.yearsList.addEventListener(Event.CHANGE,this.yearsList_changeHandler);
         this.listGroup.addChild(this.yearsList);
      }
      
      protected function createMonthList() : void
      {
         if(this.monthsList)
         {
            this.listGroup.removeChild(this.monthsList,true);
            this.monthsList = null;
         }
         if(this._editingMode !== DateTimeMode.DATE)
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.monthsList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.monthsList.styleNameList.add(_loc2_);
         this.monthsList.dataProvider = new IntegerRangeCollection(MIN_MONTH_VALUE,MAX_MONTH_VALUE,1);
         this.monthsList.typicalItem = this._longestMonthNameIndex;
         if(this._itemRendererFactory !== null)
         {
            this.monthsList.itemRendererFactory = this._itemRendererFactory;
         }
         if(this._customItemRendererStyleName !== null)
         {
            this.monthsList.customItemRendererStyleName = this._customItemRendererStyleName;
         }
         this.monthsList.addEventListener(FeathersEventType.RENDERER_ADD,this.monthsList_rendererAddHandler);
         this.monthsList.addEventListener(Event.CHANGE,this.monthsList_changeHandler);
         this.listGroup.addChildAt(this.monthsList,0);
      }
      
      protected function createDateList() : void
      {
         if(this.datesList)
         {
            this.listGroup.removeChild(this.datesList,true);
            this.datesList = null;
         }
         if(this._editingMode !== DateTimeMode.DATE)
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.datesList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.datesList.styleNameList.add(_loc2_);
         this.datesList.dataProvider = new IntegerRangeCollection(MIN_DATE_VALUE,MAX_DATE_VALUE,1);
         if(this._itemRendererFactory !== null)
         {
            this.datesList.itemRendererFactory = this._itemRendererFactory;
         }
         if(this._customItemRendererStyleName !== null)
         {
            this.datesList.customItemRendererStyleName = this._customItemRendererStyleName;
         }
         this.datesList.addEventListener(FeathersEventType.RENDERER_ADD,this.datesList_rendererAddHandler);
         this.datesList.addEventListener(Event.CHANGE,this.datesList_changeHandler);
         this.listGroup.addChildAt(this.datesList,0);
      }
      
      protected function createHourList() : void
      {
         if(this.hoursList)
         {
            this.listGroup.removeChild(this.hoursList,true);
            this.hoursList = null;
         }
         if(this._editingMode === DateTimeMode.DATE)
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.hoursList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.hoursList.styleNameList.add(_loc2_);
         if(this._itemRendererFactory !== null)
         {
            this.hoursList.itemRendererFactory = this._itemRendererFactory;
         }
         if(this._customItemRendererStyleName !== null)
         {
            this.hoursList.customItemRendererStyleName = this._customItemRendererStyleName;
         }
         this.hoursList.addEventListener(FeathersEventType.RENDERER_ADD,this.hoursList_rendererAddHandler);
         this.hoursList.addEventListener(Event.CHANGE,this.hoursList_changeHandler);
         this.listGroup.addChild(this.hoursList);
      }
      
      protected function createMinuteList() : void
      {
         if(this.minutesList)
         {
            this.listGroup.removeChild(this.minutesList,true);
            this.minutesList = null;
         }
         if(this._editingMode === DateTimeMode.DATE)
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.minutesList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.minutesList.styleNameList.add(_loc2_);
         this.minutesList.dataProvider = new IntegerRangeCollection(MIN_MINUTES_VALUE,MAX_MINUTES_VALUE,this._minuteStep);
         if(this._itemRendererFactory !== null)
         {
            this.minutesList.itemRendererFactory = this._itemRendererFactory;
         }
         if(this._customItemRendererStyleName !== null)
         {
            this.minutesList.customItemRendererStyleName = this._customItemRendererStyleName;
         }
         this.minutesList.addEventListener(FeathersEventType.RENDERER_ADD,this.minutesList_rendererAddHandler);
         this.minutesList.addEventListener(Event.CHANGE,this.minutesList_changeHandler);
         this.listGroup.addChild(this.minutesList);
      }
      
      protected function createMeridiemList() : void
      {
         if(this.meridiemList)
         {
            this.listGroup.removeChild(this.meridiemList,true);
            this.meridiemList = null;
         }
         if(!this._showMeridiem)
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.meridiemList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.meridiemList.styleNameList.add(_loc2_);
         if(this._itemRendererFactory !== null)
         {
            this.meridiemList.itemRendererFactory = this._itemRendererFactory;
         }
         if(this._customItemRendererStyleName !== null)
         {
            this.meridiemList.customItemRendererStyleName = this._customItemRendererStyleName;
         }
         this.meridiemList.addEventListener(Event.CHANGE,this.meridiemList_changeHandler);
         this.listGroup.addChild(this.meridiemList);
      }
      
      protected function createDateAndTimeDateList() : void
      {
         if(this.dateAndTimeDatesList)
         {
            this.listGroup.removeChild(this.dateAndTimeDatesList,true);
            this.dateAndTimeDatesList = null;
         }
         if(this._editingMode !== DateTimeMode.DATE_AND_TIME)
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.dateAndTimeDatesList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.dateAndTimeDatesList.styleNameList.add(_loc2_);
         if(this._itemRendererFactory !== null)
         {
            this.dateAndTimeDatesList.itemRendererFactory = this._itemRendererFactory;
         }
         if(this._customItemRendererStyleName !== null)
         {
            this.dateAndTimeDatesList.customItemRendererStyleName = this._customItemRendererStyleName;
         }
         this.dateAndTimeDatesList.addEventListener(FeathersEventType.RENDERER_ADD,this.dateAndTimeDatesList_rendererAddHandler);
         this.dateAndTimeDatesList.addEventListener(Event.CHANGE,this.dateAndTimeDatesList_changeHandler);
         this.dateAndTimeDatesList.typicalItem = {};
         this.listGroup.addChildAt(this.dateAndTimeDatesList,0);
      }
      
      protected function refreshLocale() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(!this._formatter || this._formatter.requestedLocaleIDName != this._locale)
         {
            this._formatter = new DateTimeFormatter(this._locale,DateTimeStyle.SHORT,DateTimeStyle.SHORT);
            _loc1_ = this._formatter.getDateTimePattern();
            _loc2_ = _loc1_.indexOf("M");
            _loc3_ = _loc1_.indexOf("d");
            this._monthFirst = _loc2_ < _loc3_;
            this._showMeridiem = this._editingMode !== DateTimeMode.DATE && _loc1_.indexOf("a") >= 0;
            if(this._showMeridiem)
            {
               this._formatter.setDateTimePattern("a");
               HELPER_DATE.setHours(1);
               this._amString = this._formatter.format(HELPER_DATE);
               HELPER_DATE.setHours(13);
               this._pmString = this._formatter.format(HELPER_DATE);
               this._formatter.setDateTimePattern(_loc1_);
            }
         }
         if(this._editingMode === DateTimeMode.DATE)
         {
            this._localeMonthNames = this._formatter.getMonthNames(DateTimeNameStyle.FULL);
            this._localeWeekdayNames = null;
         }
         else if(this._editingMode === DateTimeMode.DATE_AND_TIME)
         {
            this._localeMonthNames = this._formatter.getMonthNames(DateTimeNameStyle.SHORT_ABBREVIATION);
            this._localeWeekdayNames = this._formatter.getWeekdayNames(DateTimeNameStyle.LONG_ABBREVIATION);
         }
         else
         {
            this._localeMonthNames = null;
            this._localeWeekdayNames = null;
         }
         if(this._localeMonthNames !== null)
         {
            this._longestMonthNameIndex = 0;
            _loc4_ = this._localeMonthNames[0];
            _loc5_ = int(this._localeMonthNames.length);
            _loc6_ = 1;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = this._localeMonthNames[_loc6_];
               if(_loc7_.length > _loc4_.length)
               {
                  _loc4_ = _loc7_;
                  this._longestMonthNameIndex = _loc6_;
               }
               _loc6_++;
            }
         }
      }
      
      protected function refreshSelection() : void
      {
         var _loc2_:IntegerRangeCollection = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:IntegerRangeCollection = null;
         var _loc8_:IntegerRangeCollection = null;
         var _loc1_:Boolean = this._ignoreListChanges;
         this._ignoreListChanges = true;
         if(this._editingMode === DateTimeMode.DATE)
         {
            _loc2_ = IntegerRangeCollection(this.yearsList.dataProvider);
            if(_loc2_ !== null)
            {
               _loc2_.minimum = this._listMinYear;
               _loc2_.maximum = this._listMaxYear;
            }
            else
            {
               this.yearsList.dataProvider = new IntegerRangeCollection(this._listMinYear,this._listMaxYear,1);
            }
         }
         else
         {
            _loc3_ = this._maximum.time - this._minimum.time;
            _loc4_ = _loc3_ / MS_PER_DAY;
            if(this._editingMode === DateTimeMode.DATE_AND_TIME)
            {
               _loc8_ = IntegerRangeCollection(this.dateAndTimeDatesList.dataProvider);
               if(_loc8_ !== null)
               {
                  _loc8_.maximum = _loc4_;
               }
               else
               {
                  this.dateAndTimeDatesList.dataProvider = new IntegerRangeCollection(0,_loc4_,1);
               }
            }
            _loc5_ = MIN_HOURS_VALUE;
            _loc6_ = this._showMeridiem ? MAX_HOURS_VALUE_12HOURS : MAX_HOURS_VALUE_24HOURS;
            _loc7_ = IntegerRangeCollection(this.hoursList.dataProvider);
            if(_loc7_ !== null)
            {
               _loc7_.minimum = _loc5_;
               _loc7_.maximum = _loc6_;
            }
            else
            {
               this.hoursList.dataProvider = new IntegerRangeCollection(_loc5_,_loc6_,1);
            }
            if(this._showMeridiem && !this.meridiemList.dataProvider)
            {
               this.meridiemList.dataProvider = new VectorCollection(new <String>[this._amString,this._pmString]);
            }
         }
         if(Boolean(this.monthsList) && !this.monthsList.isScrolling)
         {
            this.monthsList.selectedItem = this._value.month;
         }
         if(Boolean(this.datesList) && !this.datesList.isScrolling)
         {
            this.datesList.selectedItem = this._value.date;
         }
         if(Boolean(this.yearsList) && !this.yearsList.isScrolling)
         {
            this.yearsList.selectedItem = this._value.fullYear;
         }
         if(this.dateAndTimeDatesList)
         {
            this.dateAndTimeDatesList.selectedIndex = (this._value.time - this._minimum.time) / MS_PER_DAY;
         }
         if(this.hoursList)
         {
            if(this._showMeridiem)
            {
               this.hoursList.selectedIndex = this._value.hours % 12;
            }
            else
            {
               this.hoursList.selectedIndex = this._value.hours;
            }
         }
         if(this.minutesList)
         {
            this.minutesList.selectedItem = this._value.minutes;
         }
         if(this.meridiemList)
         {
            this.meridiemList.selectedIndex = this._value.hours <= MAX_HOURS_VALUE_12HOURS ? 0 : 1;
         }
         this._ignoreListChanges = _loc1_;
      }
      
      protected function refreshEnabled() : void
      {
         var _loc3_:SpinnerList = null;
         var _loc1_:int = this.listGroup.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = SpinnerList(this.listGroup.getChildAt(_loc2_));
            _loc3_.isEnabled = this._isEnabled;
            _loc2_++;
         }
      }
      
      protected function getMinMonth(param1:int) : int
      {
         if(param1 == this._minYear)
         {
            return this._minimum.month;
         }
         return MIN_MONTH_VALUE;
      }
      
      protected function getMaxMonth(param1:int) : int
      {
         if(param1 == this._maxYear)
         {
            return this._maximum.month;
         }
         return MAX_MONTH_VALUE;
      }
      
      protected function getMinDate(param1:int, param2:int) : int
      {
         if(param1 == this._minYear && param2 == this._minimum.month)
         {
            return this._minimum.date;
         }
         return MIN_DATE_VALUE;
      }
      
      protected function getMaxDate(param1:int, param2:int) : int
      {
         if(param1 == this._maxYear && param2 == this._maximum.month)
         {
            return this._maximum.date;
         }
         if(param2 == 1)
         {
            HELPER_DATE.setFullYear(param1,param2 + 1,-1);
            return HELPER_DATE.date + 1;
         }
         return DAYS_IN_MONTH[param2];
      }
      
      protected function getMinHours(param1:int, param2:int, param3:int) : int
      {
         if(this._editingMode === DateTimeMode.DATE_AND_TIME)
         {
            if(param1 == this._minYear && param2 == this._minimum.month && param3 == this._minimum.date)
            {
               return this._minimum.hours;
            }
            return MIN_HOURS_VALUE;
         }
         return this._minimum.hours;
      }
      
      protected function getMaxHours(param1:int, param2:int, param3:int) : int
      {
         if(this._editingMode === DateTimeMode.DATE_AND_TIME)
         {
            if(param1 == this._maxYear && param2 == this._maximum.month && param3 == this._maximum.date)
            {
               return this._maximum.hours;
            }
            return MAX_HOURS_VALUE_24HOURS;
         }
         return this._maximum.hours;
      }
      
      protected function getMinMinutes(param1:int, param2:int, param3:int, param4:int) : int
      {
         if(this._editingMode === DateTimeMode.DATE_AND_TIME)
         {
            if(param1 == this._minYear && param2 == this._minimum.month && param3 == this._minimum.date && param4 == this._minimum.hours)
            {
               return this._minimum.minutes;
            }
            return MIN_MINUTES_VALUE;
         }
         if(param4 == this._minHours)
         {
            return this._minimum.minutes;
         }
         return MIN_MINUTES_VALUE;
      }
      
      protected function getMaxMinutes(param1:int, param2:int, param3:int, param4:int) : int
      {
         if(this._editingMode === DateTimeMode.DATE_AND_TIME)
         {
            if(param1 == this._maxYear && param2 == this._maximum.month && param3 == this._maximum.date && param4 == this._maximum.hours)
            {
               return this._maximum.minutes;
            }
            return MAX_MINUTES_VALUE;
         }
         if(param4 == this._maxHours)
         {
            return this._maximum.minutes;
         }
         return MAX_MINUTES_VALUE;
      }
      
      protected function getValidDateForYearAndMonth(param1:int, param2:int) : int
      {
         var _loc3_:int = this._value.date;
         var _loc4_:int = this.getMinDate(param1,param2);
         var _loc5_:int = this.getMaxDate(param1,param2);
         if(_loc3_ < _loc4_)
         {
            _loc3_ = _loc4_;
         }
         else if(_loc3_ > _loc5_)
         {
            _loc3_ = _loc5_;
         }
         return _loc3_;
      }
      
      protected function refreshValidRanges() : void
      {
         var _loc1_:int = this._minYear;
         var _loc2_:int = this._maxYear;
         var _loc3_:int = this._minMonth;
         var _loc4_:int = this._maxMonth;
         var _loc5_:int = this._minDate;
         var _loc6_:int = this._maxDate;
         var _loc7_:int = this._minHours;
         var _loc8_:int = this._maxHours;
         var _loc9_:int = this._minMinute;
         var _loc10_:int = this._maxMinute;
         var _loc11_:int = this._value.fullYear;
         var _loc12_:int = this._value.month;
         var _loc13_:int = this._value.date;
         var _loc14_:int = this._value.hours;
         this._minYear = this._minimum.fullYear;
         this._maxYear = this._maximum.fullYear;
         this._minMonth = this.getMinMonth(_loc11_);
         this._maxMonth = this.getMaxMonth(_loc11_);
         this._minDate = this.getMinDate(_loc11_,_loc12_);
         this._maxDate = this.getMaxDate(_loc11_,_loc12_);
         this._minHours = this.getMinHours(_loc11_,_loc12_,_loc13_);
         this._maxHours = this.getMaxHours(_loc11_,_loc12_,_loc13_);
         this._minMinute = this.getMinMinutes(_loc11_,_loc12_,_loc13_,_loc14_);
         this._maxMinute = this.getMaxMinutes(_loc11_,_loc12_,_loc13_,_loc14_);
         var _loc15_:IListCollection = this.yearsList ? this.yearsList.dataProvider : null;
         if((Boolean(_loc15_)) && (_loc1_ != this._minYear || _loc2_ != this._maxYear))
         {
            _loc15_.updateAll();
         }
         var _loc16_:IListCollection = this.monthsList ? this.monthsList.dataProvider : null;
         if((Boolean(_loc16_)) && (_loc3_ != this._minMonth || _loc4_ != this._maxMonth))
         {
            _loc16_.updateAll();
         }
         var _loc17_:IListCollection = this.datesList ? this.datesList.dataProvider : null;
         if((Boolean(_loc17_)) && (_loc5_ != this._minDate || _loc6_ != this._maxDate))
         {
            _loc17_.updateAll();
         }
         var _loc18_:IListCollection = this.dateAndTimeDatesList ? this.dateAndTimeDatesList.dataProvider : null;
         if((Boolean(_loc18_)) && (_loc1_ != this._minYear || _loc2_ != this._maxYear || _loc3_ != this._minMonth || _loc4_ != this._maxMonth || _loc5_ != this._minDate || _loc6_ != this._maxDate))
         {
            _loc18_.updateAll();
         }
         var _loc19_:IListCollection = this.hoursList ? this.hoursList.dataProvider : null;
         if((Boolean(_loc19_)) && (_loc7_ != this._minHours || _loc8_ != this._maxHours || this._showMeridiem && this._lastMeridiemValue != this.meridiemList.selectedIndex))
         {
            _loc19_.updateAll();
         }
         var _loc20_:IListCollection = this.minutesList ? this.minutesList.dataProvider : null;
         if((Boolean(_loc20_)) && (_loc9_ != this._minMinute || _loc10_ != this._maxMinute))
         {
            _loc20_.updateAll();
         }
         if(this._showMeridiem)
         {
            this._lastMeridiemValue = this._value.hours <= MAX_HOURS_VALUE_12HOURS ? 0 : 1;
         }
      }
      
      protected function useDefaultsIfNeeded() : void
      {
         if(!this._value)
         {
            this._value = new Date();
            if(Boolean(this._minimum) && this._value.time < this._minimum.time)
            {
               this._value.time = this._minimum.time;
            }
            else if(Boolean(this._maximum) && this._value.time > this._maximum.time)
            {
               this._value.time = this._maximum.time;
            }
         }
         if(this._minimum)
         {
            if(this._editingMode === DateTimeMode.DATE_AND_TIME)
            {
               this._listMinYear = this._minimum.fullYear - 1;
            }
            else
            {
               this._listMinYear = this._minimum.fullYear - 10;
            }
         }
         else if(this._editingMode === DateTimeMode.DATE_AND_TIME)
         {
            HELPER_DATE.time = this._value.time;
            this._listMinYear = HELPER_DATE.fullYear - 1;
            this._minimum = new Date(this._listMinYear,MIN_MONTH_VALUE,MIN_DATE_VALUE,MIN_HOURS_VALUE,MIN_MINUTES_VALUE);
         }
         else
         {
            HELPER_DATE.time = this._value.time;
            this._listMinYear = roundDownToNearest(HELPER_DATE.fullYear - 100,50);
            this._minimum = new Date(this._listMinYear,MIN_MONTH_VALUE,MIN_DATE_VALUE,MIN_HOURS_VALUE,MIN_MINUTES_VALUE);
         }
         if(this._maximum)
         {
            if(this._editingMode === DateTimeMode.DATE_AND_TIME)
            {
               this._listMaxYear = this._maximum.fullYear + 1;
            }
            else
            {
               this._listMaxYear = this._maximum.fullYear + 10;
            }
         }
         else if(this._editingMode === DateTimeMode.DATE_AND_TIME)
         {
            HELPER_DATE.time = this._value.time;
            this._listMaxYear = HELPER_DATE.fullYear + 1;
            this._maximum = new Date(this._listMaxYear,MAX_MONTH_VALUE,DAYS_IN_MONTH[MAX_MONTH_VALUE],MAX_HOURS_VALUE_24HOURS,MAX_MINUTES_VALUE);
         }
         else
         {
            HELPER_DATE.time = this._value.time;
            this._listMaxYear = roundUpToNearest(HELPER_DATE.fullYear + 100,50);
            this._maximum = new Date(this._listMaxYear,MAX_MONTH_VALUE,DAYS_IN_MONTH[MAX_MONTH_VALUE],MAX_HOURS_VALUE_24HOURS,MAX_MINUTES_VALUE);
         }
      }
      
      protected function layoutChildren() : void
      {
         if(this.currentBackgroundSkin !== null && (this.currentBackgroundSkin.width != this.actualWidth || this.currentBackgroundSkin.height != this.actualHeight))
         {
            this.currentBackgroundSkin.width = this.actualWidth;
            this.currentBackgroundSkin.height = this.actualHeight;
         }
         this.listGroup.x = this._paddingLeft;
         this.listGroup.y = this._paddingTop;
         this.listGroup.width = this.actualWidth - this._paddingLeft - this._paddingRight;
         this.listGroup.height = this.actualHeight - this._paddingTop - this._paddingBottom;
         this.listGroup.validate();
      }
      
      protected function handlePendingScroll() : void
      {
         var _loc3_:int = 0;
         var _loc4_:IntegerRangeCollection = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(!this.pendingScrollToDate)
         {
            return;
         }
         var _loc1_:Date = this.pendingScrollToDate;
         this.pendingScrollToDate = null;
         var _loc2_:Number = this.pendingScrollDuration;
         if(_loc2_ !== _loc2_)
         {
            _loc2_ = this._scrollDuration;
         }
         if(this.yearsList)
         {
            _loc3_ = _loc1_.fullYear;
            if(this.yearsList.selectedItem != _loc3_)
            {
               _loc4_ = IntegerRangeCollection(this.yearsList.dataProvider);
               this.yearsList.scrollToDisplayIndex(_loc3_ - _loc4_.minimum,_loc2_);
            }
         }
         if(this.monthsList)
         {
            _loc5_ = _loc1_.month;
            if(this.monthsList.selectedItem != _loc5_)
            {
               this.monthsList.scrollToDisplayIndex(_loc5_,_loc2_);
            }
         }
         if(this.datesList)
         {
            _loc6_ = _loc1_.date;
            if(this.datesList.selectedItem != _loc6_)
            {
               this.datesList.scrollToDisplayIndex(_loc6_ - 1,_loc2_);
            }
         }
         if(this.dateAndTimeDatesList)
         {
            _loc7_ = (_loc1_.time - this._minimum.time) / MS_PER_DAY;
            if(this.dateAndTimeDatesList.selectedIndex != _loc7_)
            {
               this.dateAndTimeDatesList.scrollToDisplayIndex(_loc7_,_loc2_);
            }
         }
         if(this.hoursList)
         {
            _loc8_ = _loc1_.hours;
            if(this._showMeridiem)
            {
               _loc8_ %= 12;
            }
            if(this.hoursList.selectedItem != _loc8_)
            {
               this.hoursList.scrollToDisplayIndex(_loc8_,_loc2_);
            }
         }
         if(this.minutesList)
         {
            _loc9_ = _loc1_.minutes;
            if(this.minutesList.selectedItem != _loc9_)
            {
               this.minutesList.scrollToDisplayIndex(_loc9_,_loc2_);
            }
         }
         if(this.meridiemList)
         {
            _loc10_ = _loc1_.hours < MAX_HOURS_VALUE_12HOURS ? 0 : 1;
            if(this.meridiemList.selectedIndex != _loc10_)
            {
               this.meridiemList.scrollToDisplayIndex(_loc10_,_loc2_);
            }
         }
      }
      
      protected function isMonthEnabled(param1:int) : Boolean
      {
         return param1 >= this._minMonth && param1 <= this._maxMonth;
      }
      
      protected function isYearEnabled(param1:int) : Boolean
      {
         return param1 >= this._minYear && param1 <= this._maxYear;
      }
      
      protected function isDateEnabled(param1:int) : Boolean
      {
         return param1 >= this._minDate && param1 <= this._maxDate;
      }
      
      protected function isHourEnabled(param1:int) : Boolean
      {
         if(this._showMeridiem && this.meridiemList.selectedIndex != 0)
         {
            param1 += 12;
         }
         return param1 >= this._minHours && param1 <= this._maxHours;
      }
      
      protected function isMinuteEnabled(param1:int) : Boolean
      {
         return param1 >= this._minMinute && param1 <= this._maxMinute;
      }
      
      protected function formatHours(param1:int) : String
      {
         if(this._showMeridiem)
         {
            if(param1 == 0)
            {
               param1 = 12;
            }
            return param1.toString();
         }
         var _loc2_:String = param1.toString();
         if(_loc2_.length < 2)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      protected function formatMinutes(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         if(_loc2_.length < 2)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      protected function formatDateAndTimeWeekday(param1:Object) : String
      {
         if(param1 is int)
         {
            HELPER_DATE.setTime(this._minimum.time);
            HELPER_DATE.setDate(HELPER_DATE.date + param1);
            if(this._todayLabel)
            {
               if(HELPER_DATE.fullYear == this._lastValidate.fullYear && HELPER_DATE.month == this._lastValidate.month && HELPER_DATE.date == this._lastValidate.date)
               {
                  return "";
               }
            }
            return this._localeWeekdayNames[HELPER_DATE.day] as String;
         }
         return "Wom";
      }
      
      protected function formatDateAndTimeDate(param1:Object) : String
      {
         var _loc2_:String = null;
         if(param1 is int)
         {
            HELPER_DATE.setTime(this._minimum.time);
            HELPER_DATE.setDate(HELPER_DATE.date + param1);
            if(this._todayLabel)
            {
               if(HELPER_DATE.fullYear == this._lastValidate.fullYear && HELPER_DATE.month == this._lastValidate.month && HELPER_DATE.date == this._lastValidate.date)
               {
                  return this._todayLabel;
               }
            }
            _loc2_ = this._localeMonthNames[HELPER_DATE.month] as String;
            if(this._monthFirst)
            {
               return _loc2_ + " " + HELPER_DATE.date;
            }
            return HELPER_DATE.date + " " + _loc2_;
         }
         return "Wom 30";
      }
      
      protected function formatMonthName(param1:int) : String
      {
         return this._localeMonthNames[param1] as String;
      }
      
      protected function validateNewValue() : void
      {
         var _loc1_:Number = this._value.time;
         var _loc2_:Number = this._minimum.time;
         var _loc3_:Number = this._maximum.time;
         var _loc4_:Boolean = false;
         if(_loc1_ < _loc2_)
         {
            _loc4_ = true;
            this._value.setTime(_loc2_);
         }
         else if(_loc1_ > _loc3_)
         {
            _loc4_ = true;
            this._value.setTime(_loc3_);
         }
         if(_loc4_)
         {
            this.scrollToDate(this._value);
         }
      }
      
      protected function updateHoursFromLists() : Boolean
      {
         var _loc1_:int = this.hoursList.selectedItem as int;
         if(Boolean(this.meridiemList) && this.meridiemList.selectedIndex == 1)
         {
            _loc1_ += 12;
         }
         if(this._value.hours == _loc1_)
         {
            return false;
         }
         this._value.setHours(_loc1_);
         return true;
      }
      
      protected function minutesList_rendererAddHandler(param1:Event, param2:DefaultListItemRenderer) : void
      {
         param2.labelFunction = this.formatMinutes;
         param2.enabledFunction = this.isMinuteEnabled;
         param2.itemHasEnabled = true;
      }
      
      protected function hoursList_rendererAddHandler(param1:Event, param2:DefaultListItemRenderer) : void
      {
         param2.labelFunction = this.formatHours;
         param2.enabledFunction = this.isHourEnabled;
         param2.itemHasEnabled = true;
      }
      
      protected function dateAndTimeDatesList_rendererAddHandler(param1:Event, param2:DefaultListItemRenderer) : void
      {
         param2.labelFunction = this.formatDateAndTimeDate;
         param2.accessoryLabelFunction = this.formatDateAndTimeWeekday;
      }
      
      protected function monthsList_rendererAddHandler(param1:Event, param2:DefaultListItemRenderer) : void
      {
         param2.labelFunction = this.formatMonthName;
         param2.enabledFunction = this.isMonthEnabled;
         param2.itemHasEnabled = true;
      }
      
      protected function datesList_rendererAddHandler(param1:Event, param2:DefaultListItemRenderer) : void
      {
         param2.enabledFunction = this.isDateEnabled;
         param2.itemHasEnabled = true;
      }
      
      protected function yearsList_rendererAddHandler(param1:Event, param2:DefaultListItemRenderer) : void
      {
         param2.enabledFunction = this.isYearEnabled;
         param2.itemHasEnabled = true;
      }
      
      protected function monthsList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         var _loc2_:int = this.monthsList.selectedItem as int;
         var _loc3_:int = this.getValidDateForYearAndMonth(this._value.fullYear,_loc2_);
         var _loc4_:Boolean = this._value.date != _loc3_;
         if(!_loc4_ && this._value.month == _loc2_)
         {
            return;
         }
         this._value.setMonth(_loc2_,_loc3_);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith(Event.CHANGE);
         if(_loc4_)
         {
            this.scrollToDate(this._value);
         }
      }
      
      protected function datesList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         var _loc2_:int = this.datesList.selectedItem as int;
         if(this._value.date == _loc2_)
         {
            return;
         }
         this._value.setDate(_loc2_);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith(Event.CHANGE);
      }
      
      protected function yearsList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         var _loc2_:int = this.yearsList.selectedItem as int;
         if(this._value.fullYear == _loc2_)
         {
            return;
         }
         this._value.setFullYear(_loc2_);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith(Event.CHANGE);
      }
      
      protected function dateAndTimeDatesList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         this._value.setFullYear(this._minimum.fullYear,this._minimum.month,this._minimum.date + this.dateAndTimeDatesList.selectedIndex);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith(Event.CHANGE);
      }
      
      protected function hoursList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         if(!this.updateHoursFromLists())
         {
            return;
         }
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith(Event.CHANGE);
      }
      
      protected function minutesList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         var _loc2_:int = this.minutesList.selectedItem as int;
         if(this._value.minutes == _loc2_)
         {
            return;
         }
         this._value.setMinutes(_loc2_);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith(Event.CHANGE);
      }
      
      protected function meridiemList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         if(!this.updateHoursFromLists())
         {
            return;
         }
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith(Event.CHANGE);
      }
   }
}

import feathers.data.IListCollection;
import feathers.events.CollectionEventType;
import starling.events.Event;
import starling.events.EventDispatcher;

class IntegerRangeCollection extends EventDispatcher implements IListCollection
{
   
   protected var _minimum:int;
   
   protected var _maximum:int;
   
   protected var _step:int;
   
   public function IntegerRangeCollection(param1:int = 0, param2:int = 1, param3:int = 1)
   {
      super();
      this._minimum = param1;
      this._maximum = param2;
      this._step = param3;
   }
   
   public function get minimum() : int
   {
      return this._minimum;
   }
   
   public function set minimum(param1:int) : void
   {
      if(this._minimum == param1)
      {
         return;
      }
      this._minimum = param1;
      this.dispatchEventWith(CollectionEventType.RESET);
      this.dispatchEventWith(Event.CHANGE);
   }
   
   public function get maximum() : int
   {
      return this._maximum;
   }
   
   public function set maximum(param1:int) : void
   {
      if(this._maximum == param1)
      {
         return;
      }
      this._maximum = param1;
      this.dispatchEventWith(CollectionEventType.RESET);
      this.dispatchEventWith(Event.CHANGE);
   }
   
   public function get step() : int
   {
      return this._step;
   }
   
   public function set step(param1:int) : void
   {
      if(this._step == param1)
      {
         return;
      }
      this._step = param1;
      this.dispatchEventWith(CollectionEventType.RESET);
      this.dispatchEventWith(Event.CHANGE);
   }
   
   public function get filterFunction() : Function
   {
      return null;
   }
   
   public function set filterFunction(param1:Function) : void
   {
      throw new Error("Not implemented");
   }
   
   public function get sortCompareFunction() : Function
   {
      return null;
   }
   
   public function set sortCompareFunction(param1:Function) : void
   {
      throw new Error("Not implemented");
   }
   
   public function get data() : Object
   {
      return null;
   }
   
   public function set data(param1:Object) : void
   {
      throw new Error("Not implemented");
   }
   
   public function get length() : int
   {
      return 1 + int((this._maximum - this._minimum) / this._step);
   }
   
   public function getItemAt(param1:int) : Object
   {
      var _loc2_:int = int(this._maximum);
      var _loc3_:int = this._minimum + param1 * this._step;
      if(_loc3_ > _loc2_)
      {
         _loc3_ = _loc2_;
      }
      return _loc3_;
   }
   
   public function contains(param1:Object) : Boolean
   {
      if(!(param1 is int))
      {
         return false;
      }
      var _loc2_:int = param1 as int;
      return Math.ceil((_loc2_ - this._minimum) / this._step) != -1;
   }
   
   public function getItemIndex(param1:Object) : int
   {
      if(!(param1 is int))
      {
         return -1;
      }
      var _loc2_:int = param1 as int;
      return Math.ceil((_loc2_ - this._minimum) / this._step);
   }
   
   public function refreshFilter() : void
   {
      throw new Error("Not implemented");
   }
   
   public function refresh() : void
   {
      throw new Error("Not implemented");
   }
   
   public function setItemAt(param1:Object, param2:int) : void
   {
      throw new Error("Not implemented");
   }
   
   public function addItem(param1:Object) : void
   {
      throw new Error("Not implemented");
   }
   
   public function addItemAt(param1:Object, param2:int) : void
   {
      throw new Error("Not implemented");
   }
   
   public function push(param1:Object) : void
   {
      throw new Error("Not implemented");
   }
   
   public function shift() : Object
   {
      throw new Error("Not implemented");
   }
   
   public function removeItem(param1:Object) : void
   {
      throw new Error("Not implemented");
   }
   
   public function removeItemAt(param1:int) : Object
   {
      throw new Error("Not implemented");
   }
   
   public function unshift(param1:Object) : void
   {
      throw new Error("Not implemented");
   }
   
   public function removeAll() : void
   {
      throw new Error("Not implemented");
   }
   
   public function pop() : Object
   {
      throw new Error("Not implemented");
   }
   
   public function addAll(param1:IListCollection) : void
   {
      throw new Error("Not implemented");
   }
   
   public function addAllAt(param1:IListCollection, param2:int) : void
   {
      throw new Error("Not implemented");
   }
   
   public function reset(param1:IListCollection) : void
   {
      throw new Error("Not implemented");
   }
   
   public function updateItemAt(param1:int) : void
   {
      this.dispatchEventWith(CollectionEventType.UPDATE_ITEM,false,param1);
   }
   
   public function updateAll() : void
   {
      this.dispatchEventWith(CollectionEventType.UPDATE_ALL);
   }
   
   public function dispose(param1:Function) : void
   {
      throw new Error("Not implemented");
   }
}
