package feathers.core
{
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   
   public class FocusManager
   {
      
      protected static const FOCUS_MANAGER_NOT_ENABLED_ERROR:String = "The specified action is not permitted when the focus manager is not enabled.";
      
      protected static const FOCUS_MANAGER_ROOT_MUST_BE_ON_STAGE_ERROR:String = "A focus manager may not be added or removed for a display object that is not on stage.";
      
      protected static const STAGE_TO_STACK:Dictionary = new Dictionary(true);
      
      public static var focusManagerFactory:Function = defaultFocusManagerFactory;
      
      public function FocusManager()
      {
         super();
      }
      
      public static function getFocusManagerForStage(param1:Stage) : IFocusManager
      {
         var _loc2_:Vector.<IFocusManager> = STAGE_TO_STACK[param1] as Vector.<IFocusManager>;
         if(_loc2_ === null || _loc2_.length == 0)
         {
            return null;
         }
         return _loc2_[_loc2_.length - 1];
      }
      
      public static function defaultFocusManagerFactory(param1:DisplayObjectContainer) : IFocusManager
      {
         return new DefaultFocusManager(param1);
      }
      
      public static function isEnabledForStage(param1:Stage) : Boolean
      {
         var _loc2_:Vector.<IFocusManager> = STAGE_TO_STACK[param1];
         return _loc2_ != null;
      }
      
      public static function setEnabledForStage(param1:Stage, param2:Boolean) : void
      {
         var _loc4_:IFocusManager = null;
         var _loc3_:Vector.<IFocusManager> = STAGE_TO_STACK[param1];
         if(Boolean(param2) && Boolean(_loc3_) || !param2 && !_loc3_)
         {
            return;
         }
         if(param2)
         {
            STAGE_TO_STACK[param1] = new Vector.<IFocusManager>(0);
            pushFocusManager(param1);
         }
         else
         {
            while(_loc3_.length > 0)
            {
               _loc4_ = _loc3_.pop();
               _loc4_.isEnabled = false;
            }
            delete STAGE_TO_STACK[param1];
         }
      }
      
      public static function get focus() : IFocusDisplayObject
      {
         var _loc1_:IFocusManager = getFocusManagerForStage(Starling.current.stage);
         if(_loc1_)
         {
            return _loc1_.focus;
         }
         return null;
      }
      
      public static function set focus(param1:IFocusDisplayObject) : void
      {
         var _loc2_:IFocusManager = getFocusManagerForStage(Starling.current.stage);
         if(!_loc2_)
         {
            throw new Error(FOCUS_MANAGER_NOT_ENABLED_ERROR);
         }
         _loc2_.focus = param1;
      }
      
      public static function pushFocusManager(param1:DisplayObjectContainer) : IFocusManager
      {
         var _loc5_:IFocusManager = null;
         var _loc2_:Stage = param1.stage;
         if(!_loc2_)
         {
            throw new ArgumentError(FOCUS_MANAGER_ROOT_MUST_BE_ON_STAGE_ERROR);
         }
         var _loc3_:Vector.<IFocusManager> = STAGE_TO_STACK[_loc2_] as Vector.<IFocusManager>;
         if(!_loc3_)
         {
            throw new Error(FOCUS_MANAGER_NOT_ENABLED_ERROR);
         }
         var _loc4_:IFocusManager = FocusManager.focusManagerFactory(param1);
         _loc4_.isEnabled = true;
         if(_loc3_.length > 0)
         {
            _loc5_ = _loc3_[_loc3_.length - 1];
            _loc5_.isEnabled = false;
         }
         _loc3_.push(_loc4_);
         return _loc4_;
      }
      
      public static function removeFocusManager(param1:IFocusManager) : void
      {
         var _loc2_:Stage = param1.root.stage;
         var _loc3_:Vector.<IFocusManager> = STAGE_TO_STACK[_loc2_] as Vector.<IFocusManager>;
         if(!_loc3_)
         {
            throw new Error(FOCUS_MANAGER_NOT_ENABLED_ERROR);
         }
         var _loc4_:int = _loc3_.indexOf(param1);
         if(_loc4_ < 0)
         {
            return;
         }
         param1.isEnabled = false;
         _loc3_.removeAt(_loc4_);
         if(_loc4_ > 0 && _loc4_ == _loc3_.length)
         {
            param1 = _loc3_[_loc3_.length - 1];
            param1.isEnabled = true;
         }
      }
      
      public function disableAll() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Stage = null;
         var _loc3_:Vector.<IFocusManager> = null;
         var _loc4_:IFocusManager = null;
         for(_loc1_ in STAGE_TO_STACK)
         {
            _loc2_ = Stage(_loc1_);
            _loc3_ = STAGE_TO_STACK[_loc2_];
            while(_loc3_.length > 0)
            {
               _loc4_ = _loc3_.pop();
               _loc4_.isEnabled = false;
            }
            delete STAGE_TO_STACK[_loc2_];
         }
      }
   }
}

