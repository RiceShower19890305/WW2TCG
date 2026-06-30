package feathers.core
{
   import feathers.controls.text.BitmapFontTextRenderer;
   import feathers.controls.text.StageTextTextEditor;
   import feathers.events.FeathersEventType;
   import feathers.layout.ILayoutData;
   import feathers.layout.ILayoutDisplayObject;
   import feathers.motion.effectClasses.IEffectContext;
   import feathers.motion.effectClasses.IMoveEffectContext;
   import feathers.motion.effectClasses.IResizeEffectContext;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import flash.errors.IllegalOperationError;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.utils.MatrixUtil;
   import starling.utils.Pool;
   
   public class FeathersControl extends Sprite implements IFeathersControl, ILayoutDisplayObject
   {
      
      private static const HELPER_POINT:Point = new Point();
      
      public static const INVALIDATION_FLAG_ALL:String = "all";
      
      public static const INVALIDATION_FLAG_STATE:String = "state";
      
      public static const INVALIDATION_FLAG_SIZE:String = "size";
      
      public static const INVALIDATION_FLAG_STYLES:String = "styles";
      
      public static const INVALIDATION_FLAG_SKIN:String = "skin";
      
      public static const INVALIDATION_FLAG_LAYOUT:String = "layout";
      
      public static const INVALIDATION_FLAG_DATA:String = "data";
      
      public static const INVALIDATION_FLAG_SCROLL:String = "scroll";
      
      public static const INVALIDATION_FLAG_SELECTED:String = "selected";
      
      public static const INVALIDATION_FLAG_FOCUS:String = "focus";
      
      protected static const INVALIDATION_FLAG_TEXT_RENDERER:String = "textRenderer";
      
      protected static const INVALIDATION_FLAG_TEXT_EDITOR:String = "textEditor";
      
      protected static const ILLEGAL_WIDTH_ERROR:String = "A component\'s width cannot be NaN.";
      
      protected static const ILLEGAL_HEIGHT_ERROR:String = "A component\'s height cannot be NaN.";
      
      protected static const ABSTRACT_CLASS_ERROR:String = "FeathersControl is an abstract class. For a lightweight Feathers wrapper, use feathers.controls.LayoutGroup.";
      
      public static function defaultTextRendererFactory():ITextRenderer
      {
         return new BitmapFontTextRenderer();
      }
      public static function defaultTextEditorFactory():ITextEditor
      {
         return new StageTextTextEditor();
      }
      protected var _showEffectContext:IEffectContext = null;
      
      protected var _showEffect:Function = null;
      
      protected var _hideEffectContext:IEffectContext = null;
      
      protected var _hideEffect:Function = null;
      
      protected var _pendingVisible:Boolean = true;
      
      protected var _focusInEffectContext:IEffectContext = null;
      
      protected var _focusInEffect:Function = null;
      
      protected var _focusOutEffectContext:IEffectContext = null;
      
      protected var _focusOutEffect:Function = null;
      
      protected var _addedEffectContext:IEffectContext = null;
      
      protected var _addedEffect:Function = null;
      
      protected var _removedEffectContext:IEffectContext = null;
      
      protected var _disposeAfterRemovedEffect:Boolean = false;
      
      protected var _validationQueue:ValidationQueue;
      
      protected var _styleNameList:TokenList = new TokenList();
      
      protected var _styleProvider:IStyleProvider;
      
      protected var _isQuickHitAreaEnabled:Boolean = false;
      
      protected var _hitArea:flash.geom.Rectangle = new flash.geom.Rectangle();
      
      protected var _isInitializing:Boolean = false;
      
      protected var _isInitialized:Boolean = false;
      
      protected var _applyingStyles:Boolean = false;
      
      protected var _restrictedStyles:Dictionary;
      
      protected var _isAllInvalid:Boolean = false;
      
      protected var _invalidationFlags:Object = {};
      
      protected var _delayedInvalidationFlags:Object = {};
      
      protected var _isEnabled:Boolean = true;
      
      protected var _explicitWidth:Number = NaN;
      
      protected var _resizeEffectContext:IEffectContext = null;
      
      protected var _resizeEffect:Function = null;
      
      protected var _moveEffectContext:IEffectContext = null;
      
      protected var _moveEffect:Function = null;
      
      protected var actualWidth:Number = 0;
      
      protected var scaledActualWidth:Number = 0;
      
      protected var _explicitHeight:Number = NaN;
      
      protected var actualHeight:Number = 0;
      
      protected var scaledActualHeight:Number = 0;
      
      protected var _minTouchWidth:Number = 0;
      
      protected var _minTouchHeight:Number = 0;
      
      protected var _explicitMinWidth:Number = NaN;
      
      protected var actualMinWidth:Number = 0;
      
      protected var scaledActualMinWidth:Number = 0;
      
      protected var _explicitMinHeight:Number = NaN;
      
      protected var actualMinHeight:Number = 0;
      
      protected var scaledActualMinHeight:Number = 0;
      
      protected var _explicitMaxWidth:Number = Infinity;
      
      protected var _explicitMaxHeight:Number = Infinity;
      
      protected var _includeInLayout:Boolean = true;
      
      protected var _layoutData:ILayoutData;
      
      protected var _toolTip:String;
      
      protected var _focusManager:IFocusManager;
      
      protected var _focusOwner:IFocusDisplayObject;
      
      protected var _isFocusEnabled:Boolean = true;
      
      protected var _nextTabFocus:IFocusDisplayObject = null;
      
      protected var _previousTabFocus:IFocusDisplayObject = null;
      
      protected var _nextUpFocus:IFocusDisplayObject = null;
      
      protected var _nextRightFocus:IFocusDisplayObject = null;
      
      protected var _nextDownFocus:IFocusDisplayObject = null;
      
      protected var _nextLeftFocus:IFocusDisplayObject = null;
      
      protected var _focusIndicatorSkin:DisplayObject;
      
      protected var _focusPaddingTop:Number = 0;
      
      protected var _focusPaddingRight:Number = 0;
      
      protected var _focusPaddingBottom:Number = 0;
      
      protected var _focusPaddingLeft:Number = 0;
      
      protected var _hasFocus:Boolean = false;
      
      protected var _showFocus:Boolean = false;
      
      protected var _isValidating:Boolean = false;
      
      protected var _hasValidated:Boolean = false;
      
      protected var _depth:int = -1;
      
      protected var _suspendEffectsCount:int = 0;
      
      protected var _ignoreNextStyleRestriction:Boolean = false;
      
      protected var _invalidateCount:int = 0;
      
      protected var _isDisposed:Boolean = false;
      
      public function FeathersControl()
      {
         super();
         if(Object(this).constructor == FeathersControl)
         {
            throw new Error(ABSTRACT_CLASS_ERROR);
         }
         this.styleProvider = this.defaultStyleProvider;
         this.addEventListener(Event.ADDED_TO_STAGE,this.feathersControl_addedToStageHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.feathersControl_removedFromStageHandler);
         if(this is IFocusDisplayObject)
         {
            this.addEventListener(FeathersEventType.FOCUS_IN,this.focusInHandler);
            this.addEventListener(FeathersEventType.FOCUS_OUT,this.focusOutHandler);
         }
      }
      
      public function get showEffect() : Function
      {
         return this._showEffect;
      }
      
      public function set showEffect(param1:Function) : void
      {
         this._showEffect = param1;
      }
      
      public function get hideEffect() : Function
      {
         return this._hideEffect;
      }
      
      public function set hideEffect(param1:Function) : void
      {
         this._hideEffect = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(param1 == this._pendingVisible)
         {
            return;
         }
         this._pendingVisible = param1;
         if(this._suspendEffectsCount == 0 && this._hideEffectContext !== null)
         {
            this._hideEffectContext.interrupt();
            this._hideEffectContext = null;
         }
         if(this._suspendEffectsCount == 0 && this._showEffectContext !== null)
         {
            this._showEffectContext.interrupt();
            this._showEffectContext = null;
         }
         if(this._pendingVisible)
         {
            super.visible = this._pendingVisible;
            if(this.isCreated && this._suspendEffectsCount == 0 && this._showEffect !== null && this.stage !== null)
            {
               this._showEffectContext = IEffectContext(this._showEffect(this));
               this._showEffectContext.addEventListener(Event.COMPLETE,this.showEffectContext_completeHandler);
               this._showEffectContext.play();
            }
         }
         else if(!this.isCreated || this._suspendEffectsCount > 0 || this._hideEffect === null || this.stage === null)
         {
            super.visible = this._pendingVisible;
         }
         else
         {
            this._hideEffectContext = IEffectContext(this._hideEffect(this));
            this._hideEffectContext.addEventListener(Event.COMPLETE,this.hideEffectContext_completeHandler);
            this._hideEffectContext.play();
         }
      }
      
      public function get focusInEffect() : Function
      {
         return this._focusInEffect;
      }
      
      public function set focusInEffect(param1:Function) : void
      {
         this._focusInEffect = param1;
      }
      
      public function get focusOutEffect() : Function
      {
         return this._focusOutEffect;
      }
      
      public function set focusOutEffect(param1:Function) : void
      {
         this._focusOutEffect = param1;
      }
      
      public function get addedEffect() : Function
      {
         return this._addedEffect;
      }
      
      public function set addedEffect(param1:Function) : void
      {
         this._addedEffect = param1;
      }
      
      public function get styleName() : String
      {
         return this._styleNameList.value;
      }
      
      public function set styleName(param1:String) : void
      {
         this._styleNameList.value = param1;
      }
      
      public function get styleNameList() : TokenList
      {
         return this._styleNameList;
      }
      
      public function get styleProvider() : IStyleProvider
      {
         return this._styleProvider;
      }
      
      public function set styleProvider(param1:IStyleProvider) : void
      {
         if(this._styleProvider === param1)
         {
            return;
         }
         if(this._applyingStyles)
         {
            throw new IllegalOperationError("Cannot change styleProvider while the current style provider is applying styles.");
         }
         if(this._styleProvider !== null && this._styleProvider is EventDispatcher)
         {
            EventDispatcher(this._styleProvider).removeEventListener(Event.CHANGE,this.styleProvider_changeHandler);
         }
         this._styleProvider = param1;
         if(this._styleProvider !== null)
         {
            if(this.isInitialized)
            {
               this._applyingStyles = true;
               this._styleProvider.applyStyles(this);
               this._applyingStyles = false;
            }
            if(this._styleProvider is EventDispatcher)
            {
               EventDispatcher(this._styleProvider).addEventListener(Event.CHANGE,this.styleProvider_changeHandler);
            }
         }
      }
      
      protected function get defaultStyleProvider() : IStyleProvider
      {
         return null;
      }
      
      public function get isQuickHitAreaEnabled() : Boolean
      {
         return this._isQuickHitAreaEnabled;
      }
      
      public function set isQuickHitAreaEnabled(param1:Boolean) : void
      {
         this._isQuickHitAreaEnabled = param1;
      }
      
      public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      public function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         if(this._isEnabled == param1)
         {
            return;
         }
         this._isEnabled = param1;
         this.invalidate(INVALIDATION_FLAG_STATE);
      }
      
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      public function get resizeEffect() : Function
      {
         return this._resizeEffect;
      }
      
      public function set resizeEffect(param1:Function) : void
      {
         this._resizeEffect = param1;
      }
      
      public function get moveEffect() : Function
      {
         return this._moveEffect;
      }
      
      public function set moveEffect(param1:Function) : void
      {
         this._moveEffect = param1;
      }
      
      override public function set x(param1:Number) : void
      {
         var _loc3_:IMoveEffectContext = null;
         var _loc2_:Number = this.y;
         if(this._suspendEffectsCount == 0 && this._moveEffectContext !== null)
         {
            if(this._moveEffectContext is IMoveEffectContext)
            {
               _loc3_ = IMoveEffectContext(this._moveEffectContext);
               _loc2_ = _loc3_.newY;
            }
            this._moveEffectContext.interrupt();
            this._moveEffectContext = null;
         }
         if(this.isCreated && this._suspendEffectsCount == 0 && this._moveEffect !== null)
         {
            this._moveEffectContext = IEffectContext(this._moveEffect(this));
            this._moveEffectContext.addEventListener(Event.COMPLETE,this.moveEffectContext_completeHandler);
            if(this._moveEffectContext is IMoveEffectContext)
            {
               _loc3_ = IMoveEffectContext(this._moveEffectContext);
               _loc3_.oldX = this.x;
               _loc3_.oldY = this.y;
               _loc3_.newX = param1;
               _loc3_.newY = _loc2_;
            }
            else
            {
               super.x = param1;
            }
            this._moveEffectContext.play();
         }
         else
         {
            super.x = param1;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         var _loc3_:IMoveEffectContext = null;
         var _loc2_:Number = this.x;
         if(this._suspendEffectsCount == 0 && this._moveEffectContext !== null)
         {
            if(this._moveEffectContext is IMoveEffectContext)
            {
               _loc3_ = IMoveEffectContext(this._moveEffectContext);
               _loc2_ = _loc3_.newX;
            }
            this._moveEffectContext.interrupt();
            this._moveEffectContext = null;
         }
         if(this.isCreated && this._suspendEffectsCount == 0 && this._moveEffect !== null)
         {
            this._moveEffectContext = IEffectContext(this._moveEffect(this));
            this._moveEffectContext.addEventListener(Event.COMPLETE,this.moveEffectContext_completeHandler);
            if(this._moveEffectContext is IMoveEffectContext)
            {
               _loc3_ = IMoveEffectContext(this._moveEffectContext);
               _loc3_.oldX = this.x;
               _loc3_.oldY = this.y;
               _loc3_.newX = _loc2_;
               _loc3_.newY = param1;
            }
            else
            {
               super.y = param1;
            }
            this._moveEffectContext.play();
         }
         else
         {
            super.y = param1;
         }
      }
      
      override public function get width() : Number
      {
         return this.scaledActualWidth;
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc5_:IResizeEffectContext = null;
         var _loc6_:Boolean = false;
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitWidth !== this._explicitWidth)
         {
            return;
         }
         if(this.scaleX != 1)
         {
            param1 /= this.scaleX;
         }
         if(this._explicitWidth == param1)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:Number = this.actualHeight;
         if(this._suspendEffectsCount == 0 && this._resizeEffectContext !== null)
         {
            if(this._resizeEffectContext is IResizeEffectContext)
            {
               _loc5_ = IResizeEffectContext(this._resizeEffectContext);
               _loc4_ = _loc5_.newHeight;
            }
            this._resizeEffectContext.interrupt();
            this._resizeEffectContext = null;
         }
         if(!_loc2_ && this.isCreated && this._suspendEffectsCount == 0 && this._resizeEffect !== null)
         {
            this._resizeEffectContext = IEffectContext(this._resizeEffect(this));
            this._resizeEffectContext.addEventListener(Event.COMPLETE,this.resizeEffectContext_completeHandler);
            if(this._resizeEffectContext is IResizeEffectContext)
            {
               _loc5_ = IResizeEffectContext(this._resizeEffectContext);
               _loc5_.oldWidth = this.actualWidth;
               _loc5_.oldHeight = this.actualHeight;
               _loc5_.newWidth = param1;
               _loc5_.newHeight = _loc4_;
            }
            else
            {
               this._explicitWidth = param1;
               _loc3_ = true;
            }
            this._resizeEffectContext.play();
         }
         else
         {
            this._explicitWidth = param1;
            _loc3_ = true;
         }
         if(_loc3_)
         {
            if(_loc2_)
            {
               this.actualWidth = this.scaledActualWidth = 0;
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
            else
            {
               _loc6_ = this.saveMeasurements(param1,this.actualHeight,this.actualMinWidth,this.actualMinHeight);
               if(_loc6_)
               {
                  this.invalidate(INVALIDATION_FLAG_SIZE);
               }
            }
         }
      }
      
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      override public function get height() : Number
      {
         return this.scaledActualHeight;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc5_:IResizeEffectContext = null;
         var _loc6_:Boolean = false;
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitHeight !== this._explicitHeight)
         {
            return;
         }
         if(this.scaleY != 1)
         {
            param1 /= this.scaleY;
         }
         if(this._explicitHeight == param1)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:Number = this.actualWidth;
         if(this._suspendEffectsCount == 0 && this._resizeEffectContext !== null)
         {
            if(this._resizeEffectContext is IResizeEffectContext)
            {
               _loc5_ = IResizeEffectContext(this._resizeEffectContext);
               _loc4_ = _loc5_.newWidth;
            }
            this._resizeEffectContext.interrupt();
            this._resizeEffectContext = null;
         }
         if(!_loc2_ && this.isCreated && this._suspendEffectsCount == 0 && this._resizeEffect !== null)
         {
            this._resizeEffectContext = IEffectContext(this._resizeEffect(this));
            this._resizeEffectContext.addEventListener(Event.COMPLETE,this.resizeEffectContext_completeHandler);
            if(this._resizeEffectContext is IResizeEffectContext)
            {
               _loc5_ = IResizeEffectContext(this._resizeEffectContext);
               _loc5_.oldWidth = this.actualWidth;
               _loc5_.oldHeight = this.actualHeight;
               _loc5_.newWidth = _loc4_;
               _loc5_.newHeight = param1;
            }
            else
            {
               this._explicitHeight = param1;
               _loc3_ = true;
            }
            this._resizeEffectContext.play();
         }
         else
         {
            this._explicitHeight = param1;
            _loc3_ = true;
         }
         if(_loc3_)
         {
            if(_loc2_)
            {
               this.actualHeight = this.scaledActualHeight = 0;
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
            else
            {
               _loc6_ = this.saveMeasurements(this.actualWidth,param1,this.actualMinWidth,this.actualMinHeight);
               if(_loc6_)
               {
                  this.invalidate(INVALIDATION_FLAG_SIZE);
               }
            }
         }
      }
      
      public function get minTouchWidth() : Number
      {
         return this._minTouchWidth;
      }
      
      public function set minTouchWidth(param1:Number) : void
      {
         if(this._minTouchWidth == param1)
         {
            return;
         }
         this._minTouchWidth = param1;
         this.refreshHitAreaX();
      }
      
      public function get minTouchHeight() : Number
      {
         return this._minTouchHeight;
      }
      
      public function set minTouchHeight(param1:Number) : void
      {
         if(this._minTouchHeight == param1)
         {
            return;
         }
         this._minTouchHeight = param1;
         this.refreshHitAreaY();
      }
      
      public function get explicitMinWidth() : Number
      {
         return this._explicitMinWidth;
      }
      
      public function get minWidth() : Number
      {
         return this.scaledActualMinWidth;
      }
      
      public function set minWidth(param1:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitMinWidth !== this._explicitMinWidth)
         {
            return;
         }
         if(this.scaleX != 1)
         {
            param1 /= this.scaleX;
         }
         if(this._explicitMinWidth == param1)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinWidth;
         this._explicitMinWidth = param1;
         if(_loc2_)
         {
            this.actualMinWidth = this.scaledActualMinWidth = 0;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            _loc4_ = this.actualWidth;
            this.saveMeasurements(_loc4_,this.actualHeight,param1,this.actualMinHeight);
            if(this._explicitWidth !== this._explicitWidth && (_loc4_ < param1 || _loc4_ == _loc3_))
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
         }
      }
      
      public function get explicitMinHeight() : Number
      {
         return this._explicitMinHeight;
      }
      
      public function get minHeight() : Number
      {
         return this.scaledActualMinHeight;
      }
      
      public function set minHeight(param1:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Boolean = param1 !== param1;
         if(_loc2_ && this._explicitMinHeight !== this._explicitMinHeight)
         {
            return;
         }
         if(this.scaleY != 1)
         {
            param1 /= this.scaleY;
         }
         if(this._explicitMinHeight == param1)
         {
            return;
         }
         var _loc3_:Number = this._explicitMinHeight;
         this._explicitMinHeight = param1;
         if(_loc2_)
         {
            this.actualMinHeight = this.scaledActualMinHeight = 0;
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         else
         {
            _loc4_ = this.actualHeight;
            this.saveMeasurements(this.actualWidth,_loc4_,this.actualMinWidth,param1);
            if(this._explicitHeight !== this._explicitHeight && (_loc4_ < param1 || _loc4_ == _loc3_))
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
         }
      }
      
      public function get explicitMaxWidth() : Number
      {
         return this._explicitMaxWidth;
      }
      
      public function get maxWidth() : Number
      {
         return this._explicitMaxWidth;
      }
      
      public function set maxWidth(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this._explicitMaxWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxWidth cannot be NaN");
         }
         var _loc2_:Number = this._explicitMaxWidth;
         this._explicitMaxWidth = param1;
         if(this._explicitWidth !== this._explicitWidth && (this.actualWidth > param1 || this.actualWidth == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      public function get explicitMaxHeight() : Number
      {
         return this._explicitMaxHeight;
      }
      
      public function get maxHeight() : Number
      {
         return this._explicitMaxHeight;
      }
      
      public function set maxHeight(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(this._explicitMaxHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxHeight cannot be NaN");
         }
         var _loc2_:Number = this._explicitMaxHeight;
         this._explicitMaxHeight = param1;
         if(this._explicitHeight !== this._explicitHeight && (this.actualHeight > param1 || this.actualHeight == _loc2_))
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         this.saveMeasurements(this.actualWidth,this.actualHeight,this.actualMinWidth,this.actualMinHeight);
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         this.saveMeasurements(this.actualWidth,this.actualHeight,this.actualMinWidth,this.actualMinHeight);
      }
      
      public function get includeInLayout() : Boolean
      {
         return this._includeInLayout;
      }
      
      public function set includeInLayout(param1:Boolean) : void
      {
         if(this._includeInLayout == param1)
         {
            return;
         }
         this._includeInLayout = param1;
         this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
      }
      
      public function get layoutData() : ILayoutData
      {
         return this._layoutData;
      }
      
      public function set layoutData(param1:ILayoutData) : void
      {
         if(this._layoutData == param1)
         {
            return;
         }
         if(this._layoutData)
         {
            this._layoutData.removeEventListener(Event.CHANGE,this.layoutData_changeHandler);
         }
         this._layoutData = param1;
         if(this._layoutData)
         {
            this._layoutData.addEventListener(Event.CHANGE,this.layoutData_changeHandler);
         }
         this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
      }
      
      public function get toolTip() : String
      {
         return this._toolTip;
      }
      
      public function set toolTip(param1:String) : void
      {
         this._toolTip = param1;
      }
      
      public function get focusManager() : IFocusManager
      {
         return this._focusManager;
      }
      
      public function set focusManager(param1:IFocusManager) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot pass a focus manager to a component that does not implement feathers.core.IFocusDisplayObject");
         }
         if(this._focusManager == param1)
         {
            return;
         }
         this._focusManager = param1;
      }
      
      public function get focusOwner() : IFocusDisplayObject
      {
         return this._focusOwner;
      }
      
      public function set focusOwner(param1:IFocusDisplayObject) : void
      {
         this._focusOwner = param1;
      }
      
      public function get isFocusEnabled() : Boolean
      {
         return this._isEnabled && this._isFocusEnabled;
      }
      
      public function set isFocusEnabled(param1:Boolean) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot enable focus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         if(this._isFocusEnabled == param1)
         {
            return;
         }
         this._isFocusEnabled = param1;
      }
      
      public function get isShowingFocus() : Boolean
      {
         return this._showFocus;
      }
      
      public function get maintainTouchFocus() : Boolean
      {
         return false;
      }
      
      public function get nextTabFocus() : IFocusDisplayObject
      {
         return this._nextTabFocus;
      }
      
      public function set nextTabFocus(param1:IFocusDisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set nextTabFocus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         this._nextTabFocus = param1;
      }
      
      public function get previousTabFocus() : IFocusDisplayObject
      {
         return this._previousTabFocus;
      }
      
      public function set previousTabFocus(param1:IFocusDisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set previousTabFocus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         this._previousTabFocus = param1;
      }
      
      public function get nextUpFocus() : IFocusDisplayObject
      {
         return this._nextUpFocus;
      }
      
      public function set nextUpFocus(param1:IFocusDisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set nextUpFocus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         this._nextUpFocus = param1;
      }
      
      public function get nextRightFocus() : IFocusDisplayObject
      {
         return this._nextRightFocus;
      }
      
      public function set nextRightFocus(param1:IFocusDisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set nextRightFocus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         this._nextRightFocus = param1;
      }
      
      public function get nextDownFocus() : IFocusDisplayObject
      {
         return this._nextDownFocus;
      }
      
      public function set nextDownFocus(param1:IFocusDisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set nextDownFocus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         this._nextDownFocus = param1;
      }
      
      public function get nextLeftFocus() : IFocusDisplayObject
      {
         return this._nextLeftFocus;
      }
      
      public function set nextLeftFocus(param1:IFocusDisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set nextLeftFocus on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         this._nextLeftFocus = param1;
      }
      
      public function get focusIndicatorSkin() : DisplayObject
      {
         return this._focusIndicatorSkin;
      }
      
      public function set focusIndicatorSkin(param1:DisplayObject) : void
      {
         if(!(this is IFocusDisplayObject))
         {
            throw new IllegalOperationError("Cannot set focus indicator skin on a component that does not implement feathers.core.IFocusDisplayObject");
         }
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._focusIndicatorSkin === param1)
         {
            return;
         }
         if(this._focusIndicatorSkin)
         {
            if(this._focusIndicatorSkin.parent == this)
            {
               this._focusIndicatorSkin.removeFromParent(false);
            }
            if(this._focusIndicatorSkin is IStateObserver && this is IStateContext)
            {
               IStateObserver(this._focusIndicatorSkin).stateContext = null;
            }
         }
         this._focusIndicatorSkin = param1;
         if(this._focusIndicatorSkin)
         {
            this._focusIndicatorSkin.touchable = false;
         }
         if(this._focusIndicatorSkin is IStateObserver && this is IStateContext)
         {
            IStateObserver(this._focusIndicatorSkin).stateContext = IStateContext(this);
         }
         if(Boolean(this._focusManager) && this._focusManager.focus == this)
         {
            this.invalidate(INVALIDATION_FLAG_STYLES);
         }
      }
      
      public function get focusPadding() : Number
      {
         return this._focusPaddingTop;
      }
      
      public function set focusPadding(param1:Number) : void
      {
         this.focusPaddingTop = param1;
         this.focusPaddingRight = param1;
         this.focusPaddingBottom = param1;
         this.focusPaddingLeft = param1;
      }
      
      public function get focusPaddingTop() : Number
      {
         return this._focusPaddingTop;
      }
      
      public function set focusPaddingTop(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._focusPaddingTop == param1)
         {
            return;
         }
         this._focusPaddingTop = param1;
         this.invalidate(INVALIDATION_FLAG_FOCUS);
      }
      
      public function get focusPaddingRight() : Number
      {
         return this._focusPaddingRight;
      }
      
      public function set focusPaddingRight(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._focusPaddingRight == param1)
         {
            return;
         }
         this._focusPaddingRight = param1;
         this.invalidate(INVALIDATION_FLAG_FOCUS);
      }
      
      public function get focusPaddingBottom() : Number
      {
         return this._focusPaddingBottom;
      }
      
      public function set focusPaddingBottom(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._focusPaddingBottom == param1)
         {
            return;
         }
         this._focusPaddingBottom = param1;
         this.invalidate(INVALIDATION_FLAG_FOCUS);
      }
      
      public function get focusPaddingLeft() : Number
      {
         return this._focusPaddingLeft;
      }
      
      public function set focusPaddingLeft(param1:Number) : void
      {
         if(this.processStyleRestriction(arguments.callee))
         {
            return;
         }
         if(this._focusPaddingLeft == param1)
         {
            return;
         }
         this._focusPaddingLeft = param1;
         this.invalidate(INVALIDATION_FLAG_FOCUS);
      }
      
      public function get effectsSuspended() : Boolean
      {
         return this._suspendEffectsCount > 0;
      }
      
      public function get isCreated() : Boolean
      {
         return this._hasValidated;
      }
      
      public function get depth() : int
      {
         return this._depth;
      }
      
      override public function getBounds(param1:DisplayObject, param2:flash.geom.Rectangle = null) : flash.geom.Rectangle
      {
         var _loc7_:Matrix = null;
         if(!param2)
         {
            param2 = new flash.geom.Rectangle();
         }
         var _loc3_:Number = Number.MAX_VALUE;
         var _loc4_:Number = -Number.MAX_VALUE;
         var _loc5_:Number = Number.MAX_VALUE;
         var _loc6_:Number = -Number.MAX_VALUE;
         if(param1 == this)
         {
            _loc3_ = 0;
            _loc5_ = 0;
            _loc4_ = this.actualWidth;
            _loc6_ = this.actualHeight;
         }
         else
         {
            _loc7_ = Pool.getMatrix();
            this.getTransformationMatrix(param1,_loc7_);
            MatrixUtil.transformCoords(_loc7_,0,0,HELPER_POINT);
            _loc3_ = _loc3_ < HELPER_POINT.x ? _loc3_ : HELPER_POINT.x;
            _loc4_ = _loc4_ > HELPER_POINT.x ? _loc4_ : HELPER_POINT.x;
            _loc5_ = _loc5_ < HELPER_POINT.y ? _loc5_ : HELPER_POINT.y;
            _loc6_ = _loc6_ > HELPER_POINT.y ? _loc6_ : HELPER_POINT.y;
            MatrixUtil.transformCoords(_loc7_,0,this.actualHeight,HELPER_POINT);
            _loc3_ = _loc3_ < HELPER_POINT.x ? _loc3_ : HELPER_POINT.x;
            _loc4_ = _loc4_ > HELPER_POINT.x ? _loc4_ : HELPER_POINT.x;
            _loc5_ = _loc5_ < HELPER_POINT.y ? _loc5_ : HELPER_POINT.y;
            _loc6_ = _loc6_ > HELPER_POINT.y ? _loc6_ : HELPER_POINT.y;
            MatrixUtil.transformCoords(_loc7_,this.actualWidth,0,HELPER_POINT);
            _loc3_ = _loc3_ < HELPER_POINT.x ? _loc3_ : HELPER_POINT.x;
            _loc4_ = _loc4_ > HELPER_POINT.x ? _loc4_ : HELPER_POINT.x;
            _loc5_ = _loc5_ < HELPER_POINT.y ? _loc5_ : HELPER_POINT.y;
            _loc6_ = _loc6_ > HELPER_POINT.y ? _loc6_ : HELPER_POINT.y;
            MatrixUtil.transformCoords(_loc7_,this.actualWidth,this.actualHeight,HELPER_POINT);
            _loc3_ = _loc3_ < HELPER_POINT.x ? _loc3_ : HELPER_POINT.x;
            _loc4_ = _loc4_ > HELPER_POINT.x ? _loc4_ : HELPER_POINT.x;
            _loc5_ = _loc5_ < HELPER_POINT.y ? _loc5_ : HELPER_POINT.y;
            _loc6_ = _loc6_ > HELPER_POINT.y ? _loc6_ : HELPER_POINT.y;
            Pool.putMatrix(_loc7_);
         }
         param2.x = _loc3_;
         param2.y = _loc5_;
         param2.width = _loc4_ - _loc3_;
         param2.height = _loc6_ - _loc5_;
         return param2;
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(this._isQuickHitAreaEnabled)
         {
            if(!this.visible || !this.touchable)
            {
               return null;
            }
            if(Boolean(this.mask) && !this.hitTestMask(param1))
            {
               return null;
            }
            return this._hitArea.containsPoint(param1) ? this : null;
         }
         return super.hitTest(param1);
      }
      
      override public function dispose() : void
      {
         if(this._focusIndicatorSkin !== null && this._focusIndicatorSkin.parent !== this)
         {
            this._focusIndicatorSkin.dispose();
         }
         this._isDisposed = true;
         this._validationQueue = null;
         this.layoutData = null;
         this._styleNameList.removeEventListeners();
         super.dispose();
      }
      
      public function invalidate(param1:String = "all") : void
      {
         var _loc4_:String = null;
         var _loc2_:Boolean = this.isInvalid();
         var _loc3_:Boolean = false;
         if(this._isValidating)
         {
            var _loc5_:int = 0;
            var _loc6_:* = this._delayedInvalidationFlags;
            for(_loc4_ in _loc6_)
            {
               _loc3_ = true;
            }
         }
         if(!param1 || param1 == INVALIDATION_FLAG_ALL)
         {
            if(this._isValidating)
            {
               this._delayedInvalidationFlags[INVALIDATION_FLAG_ALL] = true;
            }
            else
            {
               this._isAllInvalid = true;
            }
         }
         else if(this._isValidating)
         {
            this._delayedInvalidationFlags[param1] = true;
         }
         else if(param1 != INVALIDATION_FLAG_ALL && !this._invalidationFlags.hasOwnProperty(param1))
         {
            this._invalidationFlags[param1] = true;
         }
         if(this._validationQueue === null || !this._isInitialized)
         {
            return;
         }
         if(this._isValidating)
         {
            if(_loc3_)
            {
               return;
            }
            ++this._invalidateCount;
            if(this._invalidateCount >= 10)
            {
               throw new Error(getQualifiedClassName(this) + " returned to validation queue too many times during validation. This may be an infinite loop. Try to avoid doing anything that calls invalidate() during validation.");
            }
            this._validationQueue.addControl(this);
            return;
         }
         if(_loc2_)
         {
            return;
         }
         this._invalidateCount = 0;
         this._validationQueue.addControl(this);
      }
      
      public function validate() : void
      {
         var _loc1_:String = null;
         if(this._isDisposed)
         {
            return;
         }
         if(!this._isInitialized)
         {
            if(this._isInitializing)
            {
               throw new IllegalOperationError("A component cannot validate until after it has finished initializing.");
            }
            this.initializeNow();
         }
         if(!this.isInvalid())
         {
            return;
         }
         if(this._isValidating)
         {
            return;
         }
         this._isValidating = true;
         this.draw();
         for(_loc1_ in this._invalidationFlags)
         {
            delete this._invalidationFlags[_loc1_];
         }
         this._isAllInvalid = false;
         for(_loc1_ in this._delayedInvalidationFlags)
         {
            if(_loc1_ == INVALIDATION_FLAG_ALL)
            {
               this._isAllInvalid = true;
            }
            else
            {
               this._invalidationFlags[_loc1_] = true;
            }
            delete this._delayedInvalidationFlags[_loc1_];
         }
         this._isValidating = false;
         if(!this._hasValidated)
         {
            this._hasValidated = true;
            this.dispatchEventWith(FeathersEventType.CREATION_COMPLETE);
            if(this._suspendEffectsCount == 0 && this.stage !== null && this._addedEffect !== null)
            {
               this._addedEffectContext = IEffectContext(this._addedEffect(this));
               this._addedEffectContext.addEventListener(Event.COMPLETE,this.addedEffectContext_completeHandler);
               this._addedEffectContext.play();
            }
         }
      }
      
      public function isInvalid(param1:String = null) : Boolean
      {
         if(this._isAllInvalid)
         {
            return true;
         }
         if(!param1)
         {
            var _loc2_:int = 0;
            var _loc3_:* = this._invalidationFlags;
            for(param1 in _loc3_)
            {
               return true;
            }
            return false;
         }
         return this._invalidationFlags[param1];
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc6_:IResizeEffectContext = null;
         var _loc7_:Boolean = false;
         var _loc3_:Boolean = false;
         if(this._suspendEffectsCount == 0 && this._resizeEffectContext !== null)
         {
            this._resizeEffectContext.interrupt();
            this._resizeEffectContext = null;
         }
         var _loc4_:Boolean = param1 !== param1;
         var _loc5_:Boolean = param2 !== param2;
         if((!_loc4_ || !_loc5_) && this.isCreated && this._suspendEffectsCount == 0 && this._resizeEffect !== null)
         {
            this._resizeEffectContext = IEffectContext(this._resizeEffect(this));
            this._resizeEffectContext.addEventListener(Event.COMPLETE,this.resizeEffectContext_completeHandler);
            if(this._resizeEffectContext is IResizeEffectContext)
            {
               _loc6_ = IResizeEffectContext(this._resizeEffectContext);
               _loc6_.oldWidth = this.actualWidth;
               _loc6_.oldHeight = this.actualHeight;
               if(_loc4_)
               {
                  _loc6_.newWidth = this.actualWidth;
               }
               else
               {
                  _loc6_.newWidth = param1;
               }
               if(_loc5_)
               {
                  _loc6_.newHeight = this.actualHeight;
               }
               else
               {
                  _loc6_.newHeight = param2;
               }
            }
            else
            {
               this._explicitWidth = param1;
               this._explicitHeight = param2;
               _loc3_ = true;
            }
            this._resizeEffectContext.play();
         }
         else
         {
            this._explicitWidth = param1;
            this._explicitHeight = param2;
            _loc3_ = true;
         }
         if(_loc3_)
         {
            if(_loc4_)
            {
               this.actualWidth = this.scaledActualWidth = 0;
            }
            if(_loc5_)
            {
               this.actualHeight = this.scaledActualHeight = 0;
            }
            if(_loc4_ || _loc5_)
            {
               this.invalidate(INVALIDATION_FLAG_SIZE);
            }
            else
            {
               _loc7_ = this.saveMeasurements(param1,param2,this.actualMinWidth,this.actualMinHeight);
               if(_loc7_)
               {
                  this.invalidate(INVALIDATION_FLAG_SIZE);
               }
            }
         }
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         var _loc3_:IMoveEffectContext = null;
         if(this._suspendEffectsCount == 0 && this._moveEffectContext !== null)
         {
            this._moveEffectContext.interrupt();
            this._moveEffectContext = null;
         }
         if(this.isCreated && this._suspendEffectsCount == 0 && this._moveEffect !== null)
         {
            this._moveEffectContext = IEffectContext(this._moveEffect(this));
            this._moveEffectContext.addEventListener(Event.COMPLETE,this.moveEffectContext_completeHandler);
            if(this._moveEffectContext is IMoveEffectContext)
            {
               _loc3_ = IMoveEffectContext(this._moveEffectContext);
               _loc3_.oldX = this.x;
               _loc3_.oldY = this.y;
               _loc3_.newX = param1;
               _loc3_.newY = param2;
            }
            else
            {
               super.x = param1;
               super.y = param2;
            }
            this._moveEffectContext.play();
         }
         else
         {
            super.x = param1;
            super.y = param2;
         }
      }
      
      public function removeFromParentWithEffect(param1:Function, param2:Boolean = false) : void
      {
         if(this.isCreated && this._suspendEffectsCount == 0)
         {
            this._disposeAfterRemovedEffect = param2;
            this._removedEffectContext = IEffectContext(param1(this));
            this._removedEffectContext.addEventListener(Event.COMPLETE,this.removedEffectContext_completeHandler);
            this._removedEffectContext.play();
         }
         else
         {
            this.removeFromParent(param2);
         }
      }
      
      public function resetStyleProvider() : void
      {
         this.styleProvider = this.defaultStyleProvider;
      }
      
      public function suspendEffects() : void
      {
         ++this._suspendEffectsCount;
      }
      
      public function resumeEffects() : void
      {
         --this._suspendEffectsCount;
      }
      
      public function showFocus() : void
      {
         if(!this._hasFocus || !this._focusIndicatorSkin)
         {
            return;
         }
         this._showFocus = true;
         this.invalidate(INVALIDATION_FLAG_FOCUS);
      }
      
      public function hideFocus() : void
      {
         if(!this._hasFocus || !this._focusIndicatorSkin)
         {
            return;
         }
         this._showFocus = false;
         this.invalidate(INVALIDATION_FLAG_FOCUS);
      }
      
      public function initializeNow() : void
      {
         if(this._isInitialized || this._isInitializing)
         {
            return;
         }
         this._isInitializing = true;
         this.initialize();
         this.invalidate();
         this._isInitializing = false;
         this._isInitialized = true;
         this.dispatchEventWith(FeathersEventType.INITIALIZE);
         if(this._styleProvider !== null)
         {
            this._applyingStyles = true;
            this._styleProvider.applyStyles(this);
            this._applyingStyles = false;
         }
         this._styleNameList.addEventListener(Event.CHANGE,this.styleNameList_changeHandler);
      }
      
      protected function setSizeInternal(param1:Number, param2:Number, param3:Boolean) : Boolean
      {
         var _loc4_:Boolean = this.saveMeasurements(param1,param2,this.actualMinWidth,this.actualMinHeight);
         if(param3 && _loc4_)
         {
            this.invalidate(INVALIDATION_FLAG_SIZE);
         }
         return _loc4_;
      }
      
      protected function saveMeasurements(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : Boolean
      {
         if(this._explicitMinWidth === this._explicitMinWidth)
         {
            param3 = this._explicitMinWidth;
         }
         else if(param3 > this._explicitMaxWidth)
         {
            param3 = this._explicitMaxWidth;
         }
         if(this._explicitMinHeight === this._explicitMinHeight)
         {
            param4 = this._explicitMinHeight;
         }
         else if(param4 > this._explicitMaxHeight)
         {
            param4 = this._explicitMaxHeight;
         }
         if(this._explicitWidth === this._explicitWidth)
         {
            param1 = this._explicitWidth;
         }
         else if(param1 < param3)
         {
            param1 = param3;
         }
         else if(param1 > this._explicitMaxWidth)
         {
            param1 = this._explicitMaxWidth;
         }
         if(this._explicitHeight === this._explicitHeight)
         {
            param2 = this._explicitHeight;
         }
         else if(param2 < param4)
         {
            param2 = param4;
         }
         else if(param2 > this._explicitMaxHeight)
         {
            param2 = this._explicitMaxHeight;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError(ILLEGAL_WIDTH_ERROR);
         }
         if(param2 !== param2)
         {
            throw new ArgumentError(ILLEGAL_HEIGHT_ERROR);
         }
         var _loc5_:Number = this.scaleX;
         if(_loc5_ < 0)
         {
            _loc5_ = -_loc5_;
         }
         var _loc6_:Number = this.scaleY;
         if(_loc6_ < 0)
         {
            _loc6_ = -_loc6_;
         }
         var _loc7_:Boolean = false;
         if(this.actualWidth != param1)
         {
            this.actualWidth = param1;
            this.refreshHitAreaX();
            _loc7_ = true;
         }
         if(this.actualHeight != param2)
         {
            this.actualHeight = param2;
            this.refreshHitAreaY();
            _loc7_ = true;
         }
         if(this.actualMinWidth != param3)
         {
            this.actualMinWidth = param3;
            _loc7_ = true;
         }
         if(this.actualMinHeight != param4)
         {
            this.actualMinHeight = param4;
            _loc7_ = true;
         }
         param1 = this.scaledActualWidth;
         param2 = this.scaledActualHeight;
         this.scaledActualWidth = this.actualWidth * _loc5_;
         this.scaledActualHeight = this.actualHeight * _loc6_;
         this.scaledActualMinWidth = this.actualMinWidth * _loc5_;
         this.scaledActualMinHeight = this.actualMinHeight * _loc6_;
         if(param1 != this.scaledActualWidth || param2 != this.scaledActualHeight)
         {
            _loc7_ = true;
            this.dispatchEventWith(Event.RESIZE);
         }
         return _loc7_;
      }
      
      protected function initialize() : void
      {
      }
      
      protected function draw() : void
      {
      }
      
      protected function setInvalidationFlag(param1:String) : void
      {
         if(this._invalidationFlags.hasOwnProperty(param1))
         {
            return;
         }
         this._invalidationFlags[param1] = true;
      }
      
      protected function clearInvalidationFlag(param1:String) : void
      {
         delete this._invalidationFlags[param1];
      }
      
      protected function processStyleRestriction(param1:Object) : Boolean
      {
         var _loc2_:Boolean = this._ignoreNextStyleRestriction;
         this._ignoreNextStyleRestriction = false;
         if(this._applyingStyles)
         {
            return this._restrictedStyles !== null && param1 in this._restrictedStyles;
         }
         if(_loc2_)
         {
            return false;
         }
         if(this._restrictedStyles === null)
         {
            this._restrictedStyles = new Dictionary();
         }
         this._restrictedStyles[param1] = true;
         return false;
      }
      
      protected function ignoreNextStyleRestriction() : void
      {
         this._ignoreNextStyleRestriction = true;
      }
      
      protected function refreshFocusIndicator() : void
      {
         if(this._focusIndicatorSkin)
         {
            if(this._hasFocus && this._showFocus)
            {
               if(this._focusIndicatorSkin.parent != this)
               {
                  this.addChild(this._focusIndicatorSkin);
               }
               else
               {
                  this.setChildIndex(this._focusIndicatorSkin,this.numChildren - 1);
               }
            }
            else if(this._focusIndicatorSkin.parent)
            {
               this._focusIndicatorSkin.removeFromParent(false);
            }
            this._focusIndicatorSkin.x = this._focusPaddingLeft;
            this._focusIndicatorSkin.y = this._focusPaddingTop;
            this._focusIndicatorSkin.width = this.actualWidth - this._focusPaddingLeft - this._focusPaddingRight;
            this._focusIndicatorSkin.height = this.actualHeight - this._focusPaddingTop - this._focusPaddingBottom;
         }
      }
      
      protected function refreshHitAreaX() : void
      {
         if(this.actualWidth < this._minTouchWidth)
         {
            this._hitArea.width = this._minTouchWidth;
         }
         else
         {
            this._hitArea.width = this.actualWidth;
         }
         var _loc1_:Number = (this.actualWidth - this._hitArea.width) / 2;
         if(_loc1_ !== _loc1_)
         {
            this._hitArea.x = 0;
         }
         else
         {
            this._hitArea.x = _loc1_;
         }
      }
      
      protected function refreshHitAreaY() : void
      {
         if(this.actualHeight < this._minTouchHeight)
         {
            this._hitArea.height = this._minTouchHeight;
         }
         else
         {
            this._hitArea.height = this.actualHeight;
         }
         var _loc1_:Number = (this.actualHeight - this._hitArea.height) / 2;
         if(_loc1_ !== _loc1_)
         {
            this._hitArea.y = 0;
         }
         else
         {
            this._hitArea.y = _loc1_;
         }
      }
      
      protected function focusInHandler(param1:Event) : void
      {
         this._hasFocus = true;
         this.invalidate(INVALIDATION_FLAG_FOCUS);
         if(this._focusOutEffectContext !== null)
         {
            this._focusOutEffectContext.interrupt();
            this._focusOutEffectContext = null;
         }
         if(this._suspendEffectsCount == 0 && this._focusInEffect !== null)
         {
            this._focusInEffectContext = IEffectContext(this._focusInEffect(this));
            this._focusInEffectContext.addEventListener(Event.COMPLETE,this.focusInEffectContext_completeHandler);
            this._focusInEffectContext.play();
         }
      }
      
      protected function focusOutHandler(param1:Event) : void
      {
         this._hasFocus = false;
         this._showFocus = false;
         this.invalidate(INVALIDATION_FLAG_FOCUS);
         if(this._focusInEffectContext !== null)
         {
            this._focusInEffectContext.interrupt();
            this._focusInEffectContext = null;
         }
         if(this._suspendEffectsCount == 0 && this._focusOutEffect !== null)
         {
            this._focusOutEffectContext = IEffectContext(this._focusOutEffect(this));
            this._focusOutEffectContext.addEventListener(Event.COMPLETE,this.focusOutEffectContext_completeHandler);
            this._focusOutEffectContext.play();
         }
      }
      
      protected function feathersControl_addedToStageHandler(param1:Event) : void
      {
         if(this.stage === null)
         {
            return;
         }
         if(!this._isInitialized)
         {
            this.initializeNow();
         }
         this._depth = getDisplayObjectDepthFromStage(this);
         this._validationQueue = ValidationQueue.forStarling(this.stage.starling);
         if(this.isInvalid())
         {
            this._invalidateCount = 0;
            this._validationQueue.addControl(this);
         }
         if(this._removedEffectContext !== null)
         {
            this._removedEffectContext.interrupt();
         }
         if(this.isCreated && this._suspendEffectsCount == 0 && this._addedEffect !== null)
         {
            this._addedEffectContext = IEffectContext(this._addedEffect(this));
            this._addedEffectContext.addEventListener(Event.COMPLETE,this.addedEffectContext_completeHandler);
            this._addedEffectContext.play();
         }
      }
      
      protected function feathersControl_removedFromStageHandler(param1:Event) : void
      {
         if(this._addedEffectContext !== null)
         {
            this._addedEffectContext.interrupt();
         }
         this._depth = -1;
         this._validationQueue = null;
      }
      
      protected function addedEffectContext_completeHandler(param1:Event) : void
      {
         this._addedEffectContext = null;
      }
      
      protected function removedEffectContext_completeHandler(param1:Event, param2:Boolean) : void
      {
         this._removedEffectContext = null;
         if(!param2)
         {
            this.removeFromParent(this._disposeAfterRemovedEffect);
         }
      }
      
      protected function showEffectContext_completeHandler(param1:Event) : void
      {
         this._showEffectContext.removeEventListener(Event.COMPLETE,this.showEffectContext_completeHandler);
         this._showEffectContext = null;
      }
      
      protected function hideEffectContext_completeHandler(param1:Event, param2:Boolean) : void
      {
         this._hideEffectContext.removeEventListener(Event.COMPLETE,this.hideEffectContext_completeHandler);
         this._hideEffectContext = null;
         if(!param2)
         {
            this.suspendEffects();
            super.visible = this._pendingVisible;
            this.resumeEffects();
         }
      }
      
      private function focusInEffectContext_completeHandler(param1:Event) : void
      {
         this._focusInEffectContext.removeEventListener(Event.COMPLETE,this.focusInEffectContext_completeHandler);
         this._focusInEffectContext = null;
      }
      
      private function focusOutEffectContext_completeHandler(param1:Event) : void
      {
         this._focusOutEffectContext.removeEventListener(Event.COMPLETE,this.focusOutEffectContext_completeHandler);
         this._focusOutEffectContext = null;
      }
      
      protected function moveEffectContext_completeHandler(param1:Event) : void
      {
         this._moveEffectContext.removeEventListener(Event.COMPLETE,this.moveEffectContext_completeHandler);
         this._moveEffectContext = null;
      }
      
      protected function resizeEffectContext_completeHandler(param1:Event) : void
      {
         this._resizeEffectContext.removeEventListener(Event.COMPLETE,this.resizeEffectContext_completeHandler);
         this._resizeEffectContext = null;
      }
      
      protected function layoutData_changeHandler(param1:Event) : void
      {
         this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
      }
      
      protected function styleNameList_changeHandler(param1:Event) : void
      {
         if(this._styleProvider === null)
         {
            return;
         }
         if(this._applyingStyles)
         {
            throw new IllegalOperationError("Cannot change styleNameList while the style provider is applying styles.");
         }
         this._applyingStyles = true;
         this._styleProvider.applyStyles(this);
         this._applyingStyles = false;
      }
      
      protected function styleProvider_changeHandler(param1:Event) : void
      {
         if(!this._isInitialized)
         {
            return;
         }
         if(this._applyingStyles)
         {
            throw new IllegalOperationError("Cannot change style provider while it is applying styles.");
         }
         this._applyingStyles = true;
         this._styleProvider.applyStyles(this);
         this._applyingStyles = false;
      }
   }
}

