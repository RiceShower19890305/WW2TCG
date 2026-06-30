package com.fs.tcgengine.config
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.view.components.Component;
   import com.junkbyte.console.Cc;
   import starling.display.Stage;
   
   public class FSDebug extends Component
   {
      
      private static var smDate:Date;
      
      public function FSDebug(param1:Stage = null)
      {
         super();
      }
      
      public static function debugTrace(param1:String, param2:String = "") : void
      {
         var _loc3_:Boolean = Boolean(InstanceMng.getUserDataMng()) && Boolean(InstanceMng.getUserDataMng().getOwnerUserData()) ? InstanceMng.getUserDataMng().getOwnerUserData().isDev() : false;
         if(Config.ONLY_SERVER_TRACES)
         {
            return;
         }
         if(Config.isDebug() || !Config.isDebug() && _loc3_)
         {
            if(param2 != "")
            {
               Cc.ch(param2,[param1]);
            }
            else
            {
               Cc.add([param1]);
            }
         }
         var _loc4_:Number = ServerConnection.smServerTimeMS > 0 ? ServerConnection.smServerTimeMS : TimerUtil.currentTimeMillis();
         if(Config.ONLY_COMBAT_LOG_TRACES && param2 != "" || !Config.ONLY_COMBAT_LOG_TRACES)
         {
            if(smDate == null)
            {
               smDate = new Date();
            }
            smDate.setTime(_loc4_);
         }
      }
   }
}

