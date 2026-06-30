package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IMeasureDisplayObject;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   import starling.utils.Pool;
   
   public class AnchorLayout extends EventDispatcher implements ILayout
   {
      
      protected static const CIRCULAR_REFERENCE_ERROR:String = "It is impossible to create this layout due to a circular reference in the AnchorLayoutData.";
      
      protected var _helperVector1:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _helperVector2:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      public function AnchorLayout()
      {
         super();
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return false;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc16_:Point = null;
         var _loc4_:Number = param2 ? param2.x : 0;
         var _loc5_:Number = param2 ? param2.y : 0;
         var _loc6_:Number = param2 ? param2.minWidth : 0;
         var _loc7_:Number = param2 ? param2.minHeight : 0;
         var _loc8_:Number = param2 ? param2.maxWidth : Number.POSITIVE_INFINITY;
         var _loc9_:Number = param2 ? param2.maxHeight : Number.POSITIVE_INFINITY;
         var _loc10_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc11_:Number = param2 ? param2.explicitHeight : NaN;
         var _loc12_:Number = _loc10_;
         var _loc13_:Number = _loc11_;
         var _loc14_:Boolean = _loc10_ !== _loc10_;
         var _loc15_:Boolean = _loc11_ !== _loc11_;
         if(_loc14_ || _loc15_)
         {
            this.validateItems(param1,_loc10_,_loc11_,_loc8_,_loc9_,true);
            _loc16_ = Pool.getPoint();
            this.measureViewPort(param1,_loc12_,_loc13_,_loc16_);
            if(_loc14_)
            {
               _loc12_ = _loc16_.x;
               if(_loc12_ < _loc6_)
               {
                  _loc12_ = _loc6_;
               }
               else if(_loc12_ > _loc8_)
               {
                  _loc12_ = _loc8_;
               }
            }
            if(_loc15_)
            {
               _loc13_ = _loc16_.y;
               if(_loc13_ < _loc7_)
               {
                  _loc13_ = _loc7_;
               }
               else if(_loc13_ > _loc9_)
               {
                  _loc13_ = _loc9_;
               }
            }
            Pool.putPoint(_loc16_);
         }
         else
         {
            this.validateItems(param1,_loc10_,_loc11_,_loc8_,_loc9_,false);
         }
         this.layoutWithBounds(param1,_loc4_,_loc5_,_loc12_,_loc13_);
         _loc16_ = Pool.getPoint();
         this.measureContent(param1,_loc12_,_loc13_,_loc16_);
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentWidth = _loc16_.x;
         param3.contentHeight = _loc16_.y;
         param3.viewPortWidth = _loc12_;
         param3.viewPortHeight = _loc13_;
         Pool.putPoint(_loc16_);
         return param3;
      }
      
      public function calculateNavigationDestination(param1:Vector.<DisplayObject>, param2:int, param3:uint, param4:LayoutBoundsResult) : int
      {
         return param2;
      }
      
      public function getNearestScrollPositionForIndex(param1:int, param2:Number, param3:Number, param4:Vector.<DisplayObject>, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null) : Point
      {
         return this.getScrollPositionForIndex(param1,param4,param5,param6,param7,param8,param9);
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         if(!param7)
         {
            param7 = new Point();
         }
         param7.x = 0;
         param7.y = 0;
         return param7;
      }
      
      protected function measureViewPort(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Point) : Point
      {
         var _loc8_:Number = NaN;
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         param4.setTo(0,0);
         var _loc5_:Vector.<DisplayObject> = param1;
         var _loc6_:Vector.<DisplayObject> = this._helperVector1;
         this.measureVector(param1,_loc6_,param4);
         var _loc7_:Number = _loc6_.length;
         while(_loc7_ > 0)
         {
            if(_loc6_ == this._helperVector1)
            {
               _loc5_ = this._helperVector1;
               _loc6_ = this._helperVector2;
            }
            else
            {
               _loc5_ = this._helperVector2;
               _loc6_ = this._helperVector1;
            }
            this.measureVector(_loc5_,_loc6_,param4);
            _loc8_ = _loc7_;
            _loc7_ = _loc6_.length;
            if(_loc8_ == _loc7_)
            {
               this._helperVector1.length = 0;
               this._helperVector2.length = 0;
               throw new IllegalOperationError(CIRCULAR_REFERENCE_ERROR);
            }
         }
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         return param4;
      }
      
      protected function measureVector(param1:Vector.<DisplayObject>, param2:Vector.<DisplayObject>, param3:Point = null) : Point
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:AnchorLayoutData = null;
         var _loc9_:Boolean = false;
         var _loc10_:ILayoutDisplayObject = null;
         if(!param3)
         {
            param3 = new Point();
         }
         param2.length = 0;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         for(; _loc6_ < _loc4_; _loc6_++)
         {
            _loc7_ = param1[_loc6_];
            if(_loc7_ is ILayoutDisplayObject)
            {
               _loc10_ = ILayoutDisplayObject(_loc7_);
               if(!_loc10_.includeInLayout)
               {
                  continue;
               }
               _loc8_ = _loc10_.layoutData as AnchorLayoutData;
            }
            _loc9_ = !_loc8_ || this.isReadyForLayout(_loc8_,_loc6_,param1,param2);
            if(!_loc9_)
            {
               param2[_loc5_] = _loc7_;
               _loc5_++;
            }
            else
            {
               this.measureItem(_loc7_,param3);
            }
         }
         return param3;
      }
      
      protected function measureItem(param1:DisplayObject, param2:Point) : void
      {
         var _loc6_:ILayoutDisplayObject = null;
         var _loc7_:AnchorLayoutData = null;
         var _loc8_:Number = NaN;
         var _loc3_:Number = param2.x;
         var _loc4_:Number = param2.y;
         var _loc5_:Boolean = false;
         if(param1 is ILayoutDisplayObject)
         {
            _loc6_ = ILayoutDisplayObject(param1);
            _loc7_ = _loc6_.layoutData as AnchorLayoutData;
            if(_loc7_)
            {
               _loc8_ = this.measureItemHorizontally(_loc6_,_loc7_);
               if(_loc8_ > _loc3_)
               {
                  _loc3_ = _loc8_;
               }
               _loc8_ = this.measureItemVertically(_loc6_,_loc7_);
               if(_loc8_ > _loc4_)
               {
                  _loc4_ = _loc8_;
               }
               _loc5_ = true;
            }
         }
         if(!_loc5_)
         {
            _loc8_ = param1.x - param1.pivotX + param1.width;
            if(_loc8_ > _loc3_)
            {
               _loc3_ = _loc8_;
            }
            _loc8_ = param1.y - param1.pivotY + param1.height;
            if(_loc8_ > _loc4_)
            {
               _loc4_ = _loc8_;
            }
         }
         param2.x = _loc3_;
         param2.y = _loc4_;
      }
      
      protected function measureItemHorizontally(param1:ILayoutDisplayObject, param2:AnchorLayoutData) : Number
      {
         var _loc3_:Number = Number(param1.width);
         var _loc4_:DisplayObject = DisplayObject(param1);
         var _loc5_:Number = this.getLeftOffset(_loc4_);
         var _loc6_:Number = this.getRightOffset(_loc4_);
         return _loc3_ + _loc5_ + _loc6_;
      }
      
      protected function measureItemVertically(param1:ILayoutDisplayObject, param2:AnchorLayoutData) : Number
      {
         var _loc7_:Number = NaN;
         var _loc3_:Number = Number(param1.height);
         if(Boolean(param2) && param1 is IFeathersControl)
         {
            _loc7_ = param2.percentHeight;
            this.doNothing();
            if(_loc7_ === _loc7_)
            {
               _loc3_ = Number(IFeathersControl(param1).minHeight);
            }
         }
         var _loc4_:DisplayObject = DisplayObject(param1);
         var _loc5_:Number = this.getTopOffset(_loc4_);
         var _loc6_:Number = this.getBottomOffset(_loc4_);
         return _loc3_ + _loc5_ + _loc6_;
      }
      
      protected function doNothing() : void
      {
      }
      
      protected function getTopOffset(param1:DisplayObject) : Number
      {
         var _loc2_:ILayoutDisplayObject = null;
         var _loc3_:AnchorLayoutData = null;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:DisplayObject = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:Number = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc2_ = ILayoutDisplayObject(param1);
            _loc3_ = _loc2_.layoutData as AnchorLayoutData;
            if(_loc3_)
            {
               _loc4_ = _loc3_.top;
               _loc5_ = _loc4_ === _loc4_;
               _loc6_ = _loc3_.bottom;
               _loc7_ = _loc6_ === _loc6_;
               _loc8_ = _loc3_.verticalCenter;
               _loc9_ = _loc8_ === _loc8_;
               if(_loc5_)
               {
                  _loc10_ = _loc3_.topAnchorDisplayObject;
                  if(!_loc10_)
                  {
                     return _loc4_;
                  }
                  _loc4_ += _loc10_.height + this.getTopOffset(_loc10_);
               }
               else if(!_loc7_ && !_loc9_)
               {
                  _loc4_ = param1.y;
               }
               else
               {
                  _loc4_ = 0;
               }
               if(_loc7_)
               {
                  _loc11_ = _loc3_.bottomAnchorDisplayObject;
                  if(_loc11_)
                  {
                     _loc4_ = Math.max(_loc4_,-_loc11_.height - _loc6_ + this.getTopOffset(_loc11_));
                  }
               }
               if(_loc9_)
               {
                  _loc12_ = _loc3_.verticalCenterAnchorDisplayObject;
                  if(_loc12_)
                  {
                     _loc13_ = _loc8_ - Math.round((param1.height - _loc12_.height) / 2);
                     _loc4_ = Math.max(_loc4_,_loc13_ + this.getTopOffset(_loc12_));
                  }
                  else if(_loc8_ > 0)
                  {
                     return _loc8_ * 2;
                  }
               }
               return _loc4_;
            }
         }
         return param1.y;
      }
      
      protected function getRightOffset(param1:DisplayObject) : Number
      {
         var _loc2_:ILayoutDisplayObject = null;
         var _loc3_:AnchorLayoutData = null;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:DisplayObject = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:Number = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc2_ = ILayoutDisplayObject(param1);
            _loc3_ = _loc2_.layoutData as AnchorLayoutData;
            if(_loc3_)
            {
               _loc4_ = _loc3_.right;
               _loc5_ = _loc4_ === _loc4_;
               if(_loc5_)
               {
                  _loc10_ = _loc3_.rightAnchorDisplayObject;
                  if(!_loc10_)
                  {
                     return _loc4_;
                  }
                  _loc4_ += _loc10_.width + this.getRightOffset(_loc10_);
               }
               else
               {
                  _loc4_ = 0;
               }
               _loc6_ = _loc3_.left;
               _loc7_ = _loc6_ === _loc6_;
               if(_loc7_)
               {
                  _loc11_ = _loc3_.leftAnchorDisplayObject;
                  if(_loc11_)
                  {
                     _loc4_ = Math.max(_loc4_,-_loc11_.width - _loc6_ + this.getRightOffset(_loc11_));
                  }
               }
               _loc8_ = _loc3_.horizontalCenter;
               _loc9_ = _loc8_ === _loc8_;
               if(_loc9_)
               {
                  _loc12_ = _loc3_.horizontalCenterAnchorDisplayObject;
                  if(_loc12_)
                  {
                     _loc13_ = -_loc8_ - Math.round((param1.width - _loc12_.width) / 2);
                     _loc4_ = Math.max(_loc4_,_loc13_ + this.getRightOffset(_loc12_));
                  }
                  else if(_loc8_ < 0)
                  {
                     return -_loc8_ * 2;
                  }
               }
               return _loc4_;
            }
         }
         return 0;
      }
      
      protected function getBottomOffset(param1:DisplayObject) : Number
      {
         var _loc2_:ILayoutDisplayObject = null;
         var _loc3_:AnchorLayoutData = null;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:DisplayObject = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:Number = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc2_ = ILayoutDisplayObject(param1);
            _loc3_ = _loc2_.layoutData as AnchorLayoutData;
            if(_loc3_)
            {
               _loc4_ = _loc3_.bottom;
               _loc5_ = _loc4_ === _loc4_;
               if(_loc5_)
               {
                  _loc10_ = _loc3_.bottomAnchorDisplayObject;
                  if(!_loc10_)
                  {
                     return _loc4_;
                  }
                  _loc4_ += _loc10_.height + this.getBottomOffset(_loc10_);
               }
               else
               {
                  _loc4_ = 0;
               }
               _loc6_ = _loc3_.top;
               _loc7_ = _loc6_ === _loc6_;
               if(_loc7_)
               {
                  _loc11_ = _loc3_.topAnchorDisplayObject;
                  if(_loc11_)
                  {
                     _loc4_ = Math.max(_loc4_,-_loc11_.height - _loc6_ + this.getBottomOffset(_loc11_));
                  }
               }
               _loc8_ = _loc3_.verticalCenter;
               _loc9_ = _loc8_ === _loc8_;
               if(_loc9_)
               {
                  _loc12_ = _loc3_.verticalCenterAnchorDisplayObject;
                  if(_loc12_)
                  {
                     _loc13_ = -_loc8_ - Math.round((param1.height - _loc12_.height) / 2);
                     _loc4_ = Math.max(_loc4_,_loc13_ + this.getBottomOffset(_loc12_));
                  }
                  else if(_loc8_ < 0)
                  {
                     return -_loc8_ * 2;
                  }
               }
               return _loc4_;
            }
         }
         return 0;
      }
      
      protected function getLeftOffset(param1:DisplayObject) : Number
      {
         var _loc2_:ILayoutDisplayObject = null;
         var _loc3_:AnchorLayoutData = null;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:DisplayObject = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:Number = NaN;
         if(param1 is ILayoutDisplayObject)
         {
            _loc2_ = ILayoutDisplayObject(param1);
            _loc3_ = _loc2_.layoutData as AnchorLayoutData;
            if(_loc3_)
            {
               _loc4_ = _loc3_.left;
               _loc5_ = _loc4_ === _loc4_;
               _loc6_ = _loc3_.right;
               _loc7_ = _loc6_ === _loc6_;
               _loc8_ = _loc3_.horizontalCenter;
               _loc9_ = _loc8_ === _loc8_;
               if(_loc5_)
               {
                  _loc10_ = _loc3_.leftAnchorDisplayObject;
                  if(!_loc10_)
                  {
                     return _loc4_;
                  }
                  _loc4_ += _loc10_.width + this.getLeftOffset(_loc10_);
               }
               else if(!_loc7_ && !_loc9_)
               {
                  _loc4_ = param1.x;
               }
               else
               {
                  _loc4_ = 0;
               }
               if(_loc7_)
               {
                  _loc11_ = _loc3_.rightAnchorDisplayObject;
                  if(_loc11_)
                  {
                     _loc4_ = Math.max(_loc4_,-_loc11_.width - _loc6_ + this.getLeftOffset(_loc11_));
                  }
               }
               if(_loc9_)
               {
                  _loc12_ = _loc3_.horizontalCenterAnchorDisplayObject;
                  if(_loc12_)
                  {
                     _loc13_ = _loc8_ - Math.round((param1.width - _loc12_.width) / 2);
                     _loc4_ = Math.max(_loc4_,_loc13_ + this.getLeftOffset(_loc12_));
                  }
                  else if(_loc8_ > 0)
                  {
                     return _loc8_ * 2;
                  }
               }
               return _loc4_;
            }
         }
         return param1.x;
      }
      
      protected function layoutWithBounds(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc9_:Number = NaN;
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
         var _loc6_:Vector.<DisplayObject> = param1;
         var _loc7_:Vector.<DisplayObject> = this._helperVector1;
         this.layoutVector(param1,_loc7_,param2,param3,param4,param5);
         var _loc8_:Number = _loc7_.length;
         while(_loc8_ > 0)
         {
            if(_loc7_ == this._helperVector1)
            {
               _loc6_ = this._helperVector1;
               _loc7_ = this._helperVector2;
            }
            else
            {
               _loc6_ = this._helperVector2;
               _loc7_ = this._helperVector1;
            }
            this.layoutVector(_loc6_,_loc7_,param2,param3,param4,param5);
            _loc9_ = _loc8_;
            _loc8_ = _loc7_.length;
            if(_loc9_ == _loc8_)
            {
               this._helperVector1.length = 0;
               this._helperVector2.length = 0;
               throw new IllegalOperationError(CIRCULAR_REFERENCE_ERROR);
            }
         }
         this._helperVector1.length = 0;
         this._helperVector2.length = 0;
      }
      
      protected function layoutVector(param1:Vector.<DisplayObject>, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc10_:DisplayObject = null;
         var _loc11_:ILayoutDisplayObject = null;
         var _loc12_:AnchorLayoutData = null;
         var _loc13_:Boolean = false;
         param2.length = 0;
         var _loc7_:int = int(param1.length);
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc10_ = param1[_loc9_];
            _loc11_ = _loc10_ as ILayoutDisplayObject;
            if(!(!_loc11_ || !_loc11_.includeInLayout))
            {
               _loc12_ = _loc11_.layoutData as AnchorLayoutData;
               if(_loc12_)
               {
                  _loc13_ = this.isReadyForLayout(_loc12_,_loc9_,param1,param2);
                  if(!_loc13_)
                  {
                     param2[_loc8_] = _loc10_;
                     _loc8_++;
                  }
                  else
                  {
                     this.positionHorizontally(_loc11_,_loc12_,param3,param4,param5,param6);
                     this.positionVertically(_loc11_,_loc12_,param3,param4,param5,param6);
                  }
               }
            }
            _loc9_++;
         }
      }
      
      protected function positionHorizontally(param1:ILayoutDisplayObject, param2:AnchorLayoutData, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:DisplayObject = null;
         var _loc19_:DisplayObject = null;
         var _loc20_:Number = NaN;
         var _loc21_:DisplayObject = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc7_:IMeasureDisplayObject = param1 as IMeasureDisplayObject;
         var _loc8_:Number = param2.percentWidth;
         if(_loc8_ === _loc8_)
         {
            if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            else if(_loc8_ > 100)
            {
               _loc8_ = 100;
            }
            _loc15_ = _loc8_ * 0.01 * param5;
            if(_loc7_ !== null)
            {
               _loc16_ = _loc7_.explicitMinWidth;
               _loc17_ = _loc7_.explicitMaxWidth;
               if(_loc15_ < _loc16_)
               {
                  _loc15_ = _loc16_;
               }
               else if(_loc15_ > _loc17_)
               {
                  _loc15_ = _loc17_;
               }
            }
            if(_loc15_ > param5)
            {
               _loc15_ = param5;
            }
            if(_loc7_.explicitMaxWidth === _loc7_.explicitMaxWidth && _loc7_.explicitMaxWidth < _loc15_)
            {
               _loc15_ = _loc7_.explicitMaxWidth;
            }
            param1.width = _loc15_;
         }
         var _loc9_:Number = param2.left;
         var _loc10_:Boolean = _loc9_ === _loc9_;
         if(_loc10_)
         {
            _loc18_ = param2.leftAnchorDisplayObject;
            if(_loc18_)
            {
               param1.x = param1.pivotX + _loc18_.x - _loc18_.pivotX + _loc18_.width + _loc9_;
            }
            else
            {
               param1.x = param1.pivotX + param3 + _loc9_;
            }
         }
         var _loc11_:Number = param2.horizontalCenter;
         var _loc12_:Boolean = _loc11_ === _loc11_;
         var _loc13_:Number = param2.right;
         var _loc14_:Boolean = _loc13_ === _loc13_;
         if(_loc14_)
         {
            _loc19_ = param2.rightAnchorDisplayObject;
            if(_loc10_)
            {
               _loc20_ = param5;
               if(_loc19_)
               {
                  _loc20_ = _loc19_.x - _loc19_.pivotX;
               }
               if(_loc18_)
               {
                  _loc20_ -= _loc18_.x - _loc18_.pivotX + _loc18_.width;
               }
               _loc15_ = _loc20_ - _loc13_ - _loc9_;
               if(_loc7_.explicitMaxWidth === _loc7_.explicitMaxWidth && _loc7_.explicitMaxWidth < _loc15_)
               {
                  _loc15_ = _loc7_.explicitMaxWidth;
               }
               param1.width = _loc15_;
            }
            else if(_loc12_)
            {
               _loc21_ = param2.horizontalCenterAnchorDisplayObject;
               if(_loc21_)
               {
                  _loc22_ = _loc21_.x - _loc21_.pivotX + Math.round(_loc21_.width / 2) + _loc11_;
               }
               else
               {
                  _loc22_ = Math.round(param5 / 2) + _loc11_;
               }
               if(_loc19_)
               {
                  _loc23_ = _loc19_.x - _loc19_.pivotX - _loc13_;
               }
               else
               {
                  _loc23_ = param5 - _loc13_;
               }
               _loc15_ = 2 * (_loc23_ - _loc22_);
               if(_loc7_.explicitMaxWidth === _loc7_.explicitMaxWidth && _loc7_.explicitMaxWidth < _loc15_)
               {
                  _loc15_ = _loc7_.explicitMaxWidth;
               }
               param1.width = _loc15_;
               param1.x = param1.pivotX + param5 - _loc13_ - param1.width;
            }
            else if(_loc19_)
            {
               param1.x = param1.pivotX + _loc19_.x - _loc19_.pivotX - param1.width - _loc13_;
            }
            else
            {
               param1.x = param1.pivotX + param3 + param5 - _loc13_ - param1.width;
            }
         }
         else if(_loc12_)
         {
            _loc21_ = param2.horizontalCenterAnchorDisplayObject;
            if(_loc21_)
            {
               _loc22_ = _loc21_.x - _loc21_.pivotX + Math.round(_loc21_.width / 2) + _loc11_;
            }
            else
            {
               _loc22_ = Math.round(param5 / 2) + _loc11_;
            }
            if(_loc10_)
            {
               _loc15_ = 2 * (_loc22_ - param1.x + param1.pivotX);
               if(_loc7_.explicitMaxWidth === _loc7_.explicitMaxWidth && _loc7_.explicitMaxWidth < _loc15_)
               {
                  _loc15_ = _loc7_.explicitMaxWidth;
               }
               param1.width = _loc15_;
            }
            else
            {
               param1.x = param1.pivotX + _loc22_ - Math.round(param1.width / 2);
            }
         }
      }
      
      protected function positionVertically(param1:ILayoutDisplayObject, param2:AnchorLayoutData, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:DisplayObject = null;
         var _loc19_:DisplayObject = null;
         var _loc20_:Number = NaN;
         var _loc21_:DisplayObject = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc7_:IMeasureDisplayObject = param1 as IMeasureDisplayObject;
         var _loc8_:Number = param2.percentHeight;
         if(_loc8_ === _loc8_)
         {
            if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            else if(_loc8_ > 100)
            {
               _loc8_ = 100;
            }
            _loc15_ = _loc8_ * 0.01 * param6;
            if(_loc7_ !== null)
            {
               _loc16_ = _loc7_.explicitMinHeight;
               _loc17_ = _loc7_.explicitMaxHeight;
               if(_loc15_ < _loc16_)
               {
                  _loc15_ = _loc16_;
               }
               else if(_loc15_ > _loc17_)
               {
                  _loc15_ = _loc17_;
               }
            }
            if(_loc15_ > param6)
            {
               _loc15_ = param6;
            }
            if(_loc7_.explicitMaxHeight === _loc7_.explicitMaxHeight && _loc7_.explicitMaxHeight < _loc15_)
            {
               _loc15_ = _loc7_.explicitMaxHeight;
            }
            param1.height = _loc15_;
         }
         var _loc9_:Number = param2.top;
         var _loc10_:Boolean = _loc9_ === _loc9_;
         if(_loc10_)
         {
            _loc18_ = param2.topAnchorDisplayObject;
            if(_loc18_)
            {
               param1.y = param1.pivotY + _loc18_.y - _loc18_.pivotY + _loc18_.height + _loc9_;
            }
            else
            {
               param1.y = param1.pivotY + param4 + _loc9_;
            }
         }
         var _loc11_:Number = param2.verticalCenter;
         var _loc12_:Boolean = _loc11_ === _loc11_;
         var _loc13_:Number = param2.bottom;
         var _loc14_:Boolean = _loc13_ === _loc13_;
         if(_loc14_)
         {
            _loc19_ = param2.bottomAnchorDisplayObject;
            if(_loc10_)
            {
               _loc20_ = param6;
               if(_loc19_)
               {
                  _loc20_ = _loc19_.y - _loc19_.pivotY;
               }
               if(_loc18_)
               {
                  _loc20_ -= _loc18_.y - _loc18_.pivotY + _loc18_.height;
               }
               _loc15_ = _loc20_ - _loc13_ - _loc9_;
               if(_loc7_.explicitMaxHeight === _loc7_.explicitMaxHeight && _loc7_.explicitMaxHeight < _loc15_)
               {
                  _loc15_ = _loc7_.explicitMaxHeight;
               }
               param1.height = _loc15_;
            }
            else if(_loc12_)
            {
               _loc21_ = param2.verticalCenterAnchorDisplayObject;
               if(_loc21_)
               {
                  _loc22_ = _loc21_.y - _loc21_.pivotY + Math.round(_loc21_.height / 2) + _loc11_;
               }
               else
               {
                  _loc22_ = Math.round(param6 / 2) + _loc11_;
               }
               if(_loc19_)
               {
                  _loc23_ = _loc19_.y - _loc19_.pivotY - _loc13_;
               }
               else
               {
                  _loc23_ = param6 - _loc13_;
               }
               _loc15_ = 2 * (_loc23_ - _loc22_);
               if(_loc7_.explicitMaxHeight === _loc7_.explicitMaxHeight && _loc7_.explicitMaxHeight < _loc15_)
               {
                  _loc15_ = _loc7_.explicitMaxHeight;
               }
               param1.height = _loc15_;
               param1.y = param1.pivotY + param6 - _loc13_ - param1.height;
            }
            else if(_loc19_)
            {
               param1.y = param1.pivotY + _loc19_.y - _loc19_.pivotY - param1.height - _loc13_;
            }
            else
            {
               param1.y = param1.pivotY + param4 + param6 - _loc13_ - param1.height;
            }
         }
         else if(_loc12_)
         {
            _loc21_ = param2.verticalCenterAnchorDisplayObject;
            if(_loc21_)
            {
               _loc22_ = _loc21_.y - _loc21_.pivotY + Math.round(_loc21_.height / 2) + _loc11_;
            }
            else
            {
               _loc22_ = Math.round(param6 / 2) + _loc11_;
            }
            if(_loc10_)
            {
               _loc15_ = 2 * (_loc22_ - param1.y + param1.pivotY);
               if(_loc7_.explicitMaxHeight === _loc7_.explicitMaxHeight && _loc7_.explicitMaxHeight < _loc15_)
               {
                  _loc15_ = _loc7_.explicitMaxHeight;
               }
               param1.height = _loc15_;
            }
            else
            {
               param1.y = param1.pivotY + _loc22_ - Math.round(param1.height / 2);
            }
         }
      }
      
      protected function measureContent(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Point = null) : Point
      {
         var _loc9_:DisplayObject = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc5_:Number = param2;
         var _loc6_:Number = param3;
         var _loc7_:int = int(param1.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = param1[_loc8_];
            _loc10_ = _loc9_.x - _loc9_.pivotX + _loc9_.width;
            _loc11_ = _loc9_.y - _loc9_.pivotY + _loc9_.height;
            if(_loc10_ === _loc10_ && _loc10_ > _loc5_)
            {
               _loc5_ = _loc10_;
            }
            if(_loc11_ === _loc11_ && _loc11_ > _loc6_)
            {
               _loc6_ = _loc11_;
            }
            _loc8_++;
         }
         param4.x = _loc5_;
         param4.y = _loc6_;
         return param4;
      }
      
      protected function isReadyForLayout(param1:AnchorLayoutData, param2:int, param3:Vector.<DisplayObject>, param4:Vector.<DisplayObject>) : Boolean
      {
         var _loc5_:int = param2 + 1;
         var _loc6_:DisplayObject = param1.leftAnchorDisplayObject;
         if((Boolean(_loc6_)) && (param3.indexOf(_loc6_,_loc5_) >= _loc5_ || param4.indexOf(_loc6_) >= 0))
         {
            return false;
         }
         var _loc7_:DisplayObject = param1.rightAnchorDisplayObject;
         if((Boolean(_loc7_)) && (param3.indexOf(_loc7_,_loc5_) >= _loc5_ || param4.indexOf(_loc7_) >= 0))
         {
            return false;
         }
         var _loc8_:DisplayObject = param1.topAnchorDisplayObject;
         if((Boolean(_loc8_)) && (param3.indexOf(_loc8_,_loc5_) >= _loc5_ || param4.indexOf(_loc8_) >= 0))
         {
            return false;
         }
         var _loc9_:DisplayObject = param1.bottomAnchorDisplayObject;
         if((Boolean(_loc9_)) && (param3.indexOf(_loc9_,_loc5_) >= _loc5_ || param4.indexOf(_loc9_) >= 0))
         {
            return false;
         }
         var _loc10_:DisplayObject = param1.horizontalCenterAnchorDisplayObject;
         if((Boolean(_loc10_)) && (param3.indexOf(_loc10_,_loc5_) >= _loc5_ || param4.indexOf(_loc10_) >= 0))
         {
            return false;
         }
         var _loc11_:DisplayObject = param1.verticalCenterAnchorDisplayObject;
         if((Boolean(_loc11_)) && (param3.indexOf(_loc11_,_loc5_) >= _loc5_ || param4.indexOf(_loc11_) >= 0))
         {
            return false;
         }
         return true;
      }
      
      protected function isReferenced(param1:DisplayObject, param2:Vector.<DisplayObject>) : Boolean
      {
         var _loc5_:ILayoutDisplayObject = null;
         var _loc6_:AnchorLayoutData = null;
         var _loc3_:int = int(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param2[_loc4_] as ILayoutDisplayObject;
            if(!(!_loc5_ || _loc5_ == param1))
            {
               _loc6_ = _loc5_.layoutData as AnchorLayoutData;
               if(_loc6_)
               {
                  if(_loc6_.leftAnchorDisplayObject == param1 || _loc6_.horizontalCenterAnchorDisplayObject == param1 || _loc6_.rightAnchorDisplayObject == param1 || _loc6_.topAnchorDisplayObject == param1 || _loc6_.verticalCenterAnchorDisplayObject == param1 || _loc6_.bottomAnchorDisplayObject == param1)
                  {
                     return true;
                  }
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean) : void
      {
         var _loc13_:DisplayObject = null;
         var _loc14_:ILayoutDisplayObject = null;
         var _loc15_:AnchorLayoutData = null;
         var _loc16_:Number = NaN;
         var _loc17_:Boolean = false;
         var _loc18_:DisplayObject = null;
         var _loc19_:Number = NaN;
         var _loc20_:DisplayObject = null;
         var _loc21_:Boolean = false;
         var _loc22_:Number = NaN;
         var _loc23_:Boolean = false;
         var _loc24_:IMeasureDisplayObject = null;
         var _loc25_:Number = NaN;
         var _loc26_:Boolean = false;
         var _loc27_:Number = NaN;
         var _loc28_:Boolean = false;
         var _loc29_:DisplayObject = null;
         var _loc30_:Number = NaN;
         var _loc31_:Boolean = false;
         var _loc32_:DisplayObject = null;
         var _loc33_:Number = NaN;
         var _loc34_:Boolean = false;
         var _loc35_:Number = NaN;
         var _loc36_:Boolean = false;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc7_:Boolean = param2 !== param2;
         var _loc8_:Boolean = param3 !== param3;
         var _loc9_:Number = param2;
         if(_loc7_ && param4 < Number.POSITIVE_INFINITY)
         {
            _loc9_ = param4;
         }
         var _loc10_:Number = param3;
         if(_loc8_ && param5 < Number.POSITIVE_INFINITY)
         {
            _loc10_ = param5;
         }
         var _loc11_:int = int(param1.length);
         var _loc12_:int = 0;
         for(; _loc12_ < _loc11_; _loc12_++)
         {
            _loc13_ = param1[_loc12_];
            if(_loc13_ is ILayoutDisplayObject)
            {
               _loc14_ = ILayoutDisplayObject(_loc13_);
               if(!_loc14_.includeInLayout)
               {
                  continue;
               }
               _loc15_ = _loc14_.layoutData as AnchorLayoutData;
               if(_loc15_ !== null)
               {
                  _loc16_ = _loc15_.left;
                  _loc17_ = _loc16_ === _loc16_;
                  _loc18_ = _loc15_.leftAnchorDisplayObject;
                  _loc19_ = _loc15_.right;
                  _loc20_ = _loc15_.rightAnchorDisplayObject;
                  _loc21_ = _loc19_ === _loc19_;
                  _loc22_ = _loc15_.percentWidth;
                  _loc23_ = _loc22_ === _loc22_;
                  _loc24_ = IMeasureDisplayObject(_loc13_);
                  if(_loc7_)
                  {
                     if(_loc17_ && _loc18_ === null && _loc21_ && _loc20_ === null)
                     {
                        _loc24_.width = NaN;
                        _loc24_.maxWidth = param4 - _loc16_ - _loc19_;
                     }
                     else if(_loc23_)
                     {
                        if(_loc22_ < 0)
                        {
                           _loc22_ = 0;
                        }
                        else if(_loc22_ > 100)
                        {
                           _loc22_ = 100;
                        }
                        _loc24_.width = NaN;
                        _loc24_.maxWidth = _loc22_ * 0.01 * param4;
                     }
                  }
                  else if(_loc17_ && _loc18_ === null && _loc21_ && _loc20_ === null)
                  {
                     _loc37_ = _loc9_ - _loc16_ - _loc19_;
                     if(_loc24_.explicitMaxWidth === _loc24_.explicitMaxWidth && _loc24_.explicitMaxWidth < _loc37_)
                     {
                        _loc37_ = _loc24_.explicitMaxWidth;
                     }
                     _loc13_.width = _loc37_;
                  }
                  else if(_loc23_)
                  {
                     if(_loc22_ < 0)
                     {
                        _loc22_ = 0;
                     }
                     else if(_loc22_ > 100)
                     {
                        _loc22_ = 100;
                     }
                     _loc37_ = _loc22_ * 0.01 * _loc9_;
                     if(_loc24_.explicitMaxWidth === _loc24_.explicitMaxWidth && _loc24_.explicitMaxWidth < _loc37_)
                     {
                        _loc37_ = _loc24_.explicitMaxWidth;
                     }
                     _loc13_.width = _loc37_;
                  }
                  _loc25_ = _loc15_.horizontalCenter;
                  _loc26_ = _loc25_ === _loc25_;
                  _loc27_ = _loc15_.top;
                  _loc28_ = _loc27_ === _loc27_;
                  _loc29_ = _loc15_.topAnchorDisplayObject;
                  _loc30_ = _loc15_.bottom;
                  _loc31_ = _loc30_ === _loc30_;
                  _loc32_ = _loc15_.bottomAnchorDisplayObject;
                  _loc33_ = _loc15_.percentHeight;
                  _loc34_ = _loc33_ === _loc33_;
                  if(!_loc8_)
                  {
                     if(_loc28_ && _loc29_ === null && _loc31_ && _loc32_ === null)
                     {
                        _loc38_ = _loc10_ - _loc27_ - _loc30_;
                        if(_loc24_.explicitMaxHeight === _loc24_.explicitMaxHeight && _loc24_.explicitMaxHeight < _loc38_)
                        {
                           _loc38_ = _loc24_.explicitMaxHeight;
                        }
                        _loc13_.height = _loc38_;
                     }
                     else if(_loc34_)
                     {
                        if(_loc33_ < 0)
                        {
                           _loc33_ = 0;
                        }
                        else if(_loc33_ > 100)
                        {
                           _loc33_ = 100;
                        }
                        _loc38_ = _loc33_ * 0.01 * _loc10_;
                        if(_loc24_.explicitMaxHeight === _loc24_.explicitMaxHeight && _loc24_.explicitMaxHeight < _loc38_)
                        {
                           _loc38_ = _loc24_.explicitMaxHeight;
                        }
                        _loc13_.height = _loc38_;
                     }
                  }
                  _loc35_ = _loc15_.verticalCenter;
                  _loc36_ = _loc35_ === _loc35_;
                  if(_loc21_ && !_loc17_ && !_loc26_ || _loc26_)
                  {
                     if(_loc13_ is IValidating)
                     {
                        IValidating(_loc13_).validate();
                     }
                     continue;
                  }
                  if(_loc31_ && !_loc28_ && !_loc36_ || _loc36_)
                  {
                     if(_loc13_ is IValidating)
                     {
                        IValidating(_loc13_).validate();
                     }
                     continue;
                  }
               }
            }
            if(param6 || this.isReferenced(_loc13_,param1))
            {
               if(_loc13_ is IValidating)
               {
                  IValidating(_loc13_).validate();
               }
            }
         }
      }
   }
}

