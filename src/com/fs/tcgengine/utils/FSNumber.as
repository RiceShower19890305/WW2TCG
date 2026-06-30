package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   
   public class FSNumber implements FSModelUnloadableInterface
   {
      
      private var mValue:String;
      
      public function FSNumber(param1:Number = 0)
      {
         super();
         this.setValue(param1);
      }
      
      private function setValue(param1:Number) : void
      {
         this.mValue = Config.isEncryptionOn() ? Utils.encodeBase64(param1.toString()) : String(param1);
      }
      
      public function get value() : Number
      {
         return Config.isEncryptionOn() ? Number(Utils.decodeBase64(this.mValue)) : Number(this.mValue);
      }
      
      public function set value(param1:Number) : void
      {
         this.setValue(param1);
      }
      
      public function destroy() : void
      {
         this.mValue = null;
      }
   }
}

