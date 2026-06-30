package com.fs.wwiitcg.resources
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import flash.filesystem.File;
   
   public class ResourceMng extends FSResourceMng
   {
      
      public function ResourceMng()
      {
         super();
      }
      
      override public function getFileFromStorage(param1:String, param2:String = "main") : *
      {
         return File.applicationDirectory.resolvePath(param1);
      }
      
      override public function getSoundTrack() : Vector.<String>
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         var _loc5_:File = null;
         var _loc1_:File = this.getFileFromStorage(InstanceMng.getResourcesMng().getAssetsOnDemandURL(FSResourceMng.PREFIX_AUDIO) + "soundtrack/");
         if(_loc1_ == null || !_loc1_.exists)
         {
            return null;
         }
         var _loc2_:Array = _loc1_.getDirectoryListing();
         if(_loc2_ != null)
         {
            _loc3_ = new Vector.<String>();
            _loc4_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_ = _loc2_[_loc4_];
               if(_loc5_.name.indexOf(".mp3") != -1)
               {
                  _loc3_.push(_loc5_.name.split(".")[0]);
               }
               _loc4_++;
            }
         }
         _loc3_.sort(Utils.randomize);
         return _loc3_;
      }
      
      override public function checkIfFileExists(param1:String) : Boolean
      {
         var _loc2_:File = this.getFileFromStorage(param1);
         return _loc2_ != null && Boolean(_loc2_.exists);
      }
   }
}

