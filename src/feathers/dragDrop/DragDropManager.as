package feathers.dragDrop
{
   import feathers.core.PopUpManager;
   import feathers.events.DragDropEvent;
   import flash.errors.IllegalOperationError;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.utils.Pool;
   
   public class DragDropManager
   {
      
      protected static var _dragSourceStage:Stage;
      
      protected static var _dragSource:IDragSource;
      
      protected static var _dragData:DragData;
      
      protected static var dropTarget:IDropTarget;
      
      protected static var avatar:DisplayObject;
      
      protected static var avatarOffsetX:Number;
      
      protected static var avatarOffsetY:Number;
      
      protected static var dropTargetLocalX:Number;
      
      protected static var dropTargetLocalY:Number;
      
      protected static var avatarOldTouchable:Boolean;
      
      protected static var _touchPointID:int = -1;
      
      protected static var isAccepted:Boolean = false;
      
      public function DragDropManager()
      {
         super();
      }
      
      public static function get touchPointID() : int
      {
         return _touchPointID;
      }
      
      public static function get dragSource() : IDragSource
      {
         return _dragSource;
      }
      
      public static function get isDragging() : Boolean
      {
         return _dragData != null;
      }
      
      public static function get dragData() : DragData
      {
         return _dragData;
      }
      
      public static function startDrag(param1:IDragSource, param2:Touch, param3:DragData, param4:DisplayObject = null, param5:Number = 0, param6:Number = 0) : void
      {
         var _loc7_:Point = null;
         if(isDragging)
         {
            cancelDrag();
         }
         if(!param1)
         {
            throw new ArgumentError("Drag source cannot be null.");
         }
         if(!param3)
         {
            throw new ArgumentError("Drag data cannot be null.");
         }
         _dragSource = param1;
         _dragData = param3;
         _touchPointID = param2.id;
         avatar = param4;
         avatarOffsetX = param5;
         avatarOffsetY = param6;
         _dragSourceStage = DisplayObject(param1).stage;
         _loc7_ = Pool.getPoint();
         param2.getLocation(_dragSourceStage,_loc7_);
         if(avatar)
         {
            avatarOldTouchable = avatar.touchable;
            avatar.touchable = false;
            avatar.x = _loc7_.x + avatarOffsetX;
            avatar.y = _loc7_.y + avatarOffsetY;
            PopUpManager.addPopUp(avatar,false,false);
         }
         _dragSourceStage.addEventListener(TouchEvent.TOUCH,stage_touchHandler);
         var _loc8_:Starling = _dragSourceStage.starling;
         _loc8_.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN,nativeStage_keyDownHandler,false,0,true);
         _dragSource.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_START,param3,false,NaN,NaN,_dragSource));
         updateDropTarget(_loc7_);
         Pool.putPoint(_loc7_);
      }
      
      public static function acceptDrag(param1:IDropTarget) : void
      {
         if(dropTarget != param1)
         {
            throw new ArgumentError("Drop target cannot accept a drag at this time. Acceptance may only happen after the DragDropEvent.DRAG_ENTER event is dispatched and before the DragDropEvent.DRAG_EXIT event is dispatched.");
         }
         isAccepted = true;
      }
      
      public static function cancelDrag() : void
      {
         if(!isDragging)
         {
            return;
         }
         completeDrag(false);
      }
      
      protected static function completeDrag(param1:Boolean) : void
      {
         if(!isDragging)
         {
            throw new IllegalOperationError("Drag cannot be completed because none is currently active.");
         }
         if(dropTarget)
         {
            dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_EXIT,_dragData,false,dropTargetLocalX,dropTargetLocalY,_dragSource));
            dropTarget = null;
         }
         var _loc2_:IDragSource = _dragSource;
         var _loc3_:DragData = _dragData;
         cleanup();
         _loc2_.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_COMPLETE,_loc3_,param1,NaN,NaN,_loc2_));
      }
      
      protected static function cleanup() : void
      {
         if(avatar)
         {
            if(PopUpManager.isPopUp(avatar))
            {
               PopUpManager.removePopUp(avatar);
            }
            avatar.touchable = avatarOldTouchable;
            avatar = null;
         }
         var _loc1_:Starling = _dragSourceStage.starling;
         _dragSourceStage.removeEventListener(TouchEvent.TOUCH,stage_touchHandler);
         _loc1_.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN,nativeStage_keyDownHandler);
         _dragSource = null;
         _dragData = null;
         _dragSourceStage = null;
      }
      
      protected static function updateDropTarget(param1:Point) : void
      {
         var _loc2_:DisplayObject = _dragSourceStage.hitTest(param1);
         while(Boolean(_loc2_) && !(_loc2_ is IDropTarget))
         {
            _loc2_ = _loc2_.parent;
         }
         if(_loc2_)
         {
            _loc2_.globalToLocal(param1,param1);
         }
         if(_loc2_ != dropTarget)
         {
            if(dropTarget)
            {
               dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_EXIT,_dragData,false,dropTargetLocalX,dropTargetLocalY,_dragSource));
            }
            dropTarget = IDropTarget(_loc2_);
            isAccepted = false;
            if(dropTarget)
            {
               dropTargetLocalX = param1.x;
               dropTargetLocalY = param1.y;
               dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_ENTER,_dragData,false,dropTargetLocalX,dropTargetLocalY,_dragSource));
            }
         }
         else if(dropTarget)
         {
            dropTargetLocalX = param1.x;
            dropTargetLocalY = param1.y;
            dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_MOVE,_dragData,false,dropTargetLocalX,dropTargetLocalY,_dragSource));
         }
      }
      
      protected static function nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE || param1.keyCode == Keyboard.BACK)
         {
            param1.preventDefault();
            cancelDrag();
         }
      }
      
      protected static function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Boolean = false;
         var _loc2_:Stage = Stage(param1.currentTarget);
         var _loc3_:Touch = param1.getTouch(_loc2_,null,_touchPointID);
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.phase == TouchPhase.MOVED)
         {
            _loc4_ = Pool.getPoint();
            _loc3_.getLocation(_loc2_,_loc4_);
            if(avatar)
            {
               avatar.x = _loc4_.x + avatarOffsetX;
               avatar.y = _loc4_.y + avatarOffsetY;
            }
            updateDropTarget(_loc4_);
            Pool.putPoint(_loc4_);
         }
         else if(_loc3_.phase == TouchPhase.ENDED)
         {
            _touchPointID = -1;
            _loc5_ = false;
            if(Boolean(dropTarget) && isAccepted)
            {
               dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_DROP,_dragData,true,dropTargetLocalX,dropTargetLocalY,_dragSource));
               _loc5_ = true;
            }
            dropTarget = null;
            completeDrag(_loc5_);
         }
      }
   }
}

