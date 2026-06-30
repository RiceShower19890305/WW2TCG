package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.utils.Utils;
   
   public class ResourceDef extends Def
   {
      
      private var mPath:String;
      
      private var mFolderSku:String;
      
      public function ResourceDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         if("path" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.path);
            this.setPath(_loc2_);
         }
         if("folderSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.folderSku);
            this.setFolderSku(_loc2_);
         }
      }
      
      public function getPath() : String
      {
         return this.mPath;
      }
      
      private function setPath(param1:String) : void
      {
         this.mPath = param1;
      }
      
      public function getFolderSku() : String
      {
         return this.mFolderSku;
      }
      
      private function setFolderSku(param1:String) : void
      {
         this.mFolderSku = param1;
      }
   }
}

