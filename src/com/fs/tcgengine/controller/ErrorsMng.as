package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.Utils;
   import flash.events.UncaughtErrorEvent;
   import flash.utils.Dictionary;
   
   public class ErrorsMng
   {
      
      private static var smErrorsTracked:Dictionary;
      
      public function ErrorsMng()
      {
         super();
      }
      
      public static function startMonitoring() : void
      {
         if(InstanceMng.getApplication().loaderInfo)
         {
            InstanceMng.getApplication().loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,handleGlobalErrors,false,0,true);
         }
      }
      
      public static function resetErrorsTrackedCatalog() : void
      {
         if(smErrorsTracked)
         {
            DictionaryUtils.clearDictionary(smErrorsTracked);
            smErrorsTracked = null;
         }
      }
      
      private static function handleGlobalErrors(param1:UncaughtErrorEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:int = int(param1.error.errorID);
         var _loc3_:String = param1.error.getStackTrace();
         if(_loc3_ != "" && _loc3_ != null)
         {
            _loc4_ = "[handleGlobalErrors] - Uncaught err caught: " + param1.toString() + " err id: " + _loc2_ + " Stack trace: " + _loc3_;
            FSDebug.debugTrace(_loc4_);
            _loc5_ = addErrorToCatalog(_loc3_);
            if(_loc5_ <= 1)
            {
               _loc6_ = InstanceMng.getCurrentScreen().getScreenName();
               _loc6_ = _loc6_ + (InstanceMng.getCurrentScreen() is FSBattleScreenPvP ? "PvP" : "");
               if(InstanceMng.getServerConnection().isUserLoggedIn())
               {
                  if(Utils.isIOS() && _loc2_ == 3768 || _loc2_ == 3672)
                  {
                     return;
                  }
                  InstanceMng.getServerConnection().createUncaughtErrInstance(_loc2_,_loc3_,_loc6_,true);
               }
            }
         }
         if(Boolean(InstanceMng.getBattleEngine()) && Boolean(InstanceMng.getServerConnection()))
         {
            PvPConnectionMng.trackCombatLog();
         }
         if(InstanceMng.getServerConnection())
         {
            InstanceMng.getServerConnection().addUserActionBlock();
         }
      }
      
      private static function addErrorToCatalog(param1:String) : int
      {
         var _loc2_:int = 0;
         if(smErrorsTracked == null)
         {
            smErrorsTracked = new Dictionary(true);
         }
         if(smErrorsTracked[param1] == null)
         {
            smErrorsTracked[param1] = 1;
         }
         else
         {
            smErrorsTracked[param1] += 1;
         }
         _loc2_ = int(smErrorsTracked[param1]);
         FSDebug.debugTrace("Tracked error, count: " + _loc2_);
         return _loc2_;
      }
   }
}

