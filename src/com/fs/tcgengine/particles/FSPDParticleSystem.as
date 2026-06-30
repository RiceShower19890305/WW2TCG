package com.fs.tcgengine.particles
{
   import com.fs.tcgengine.resources.AssetsParticles;
   import starling.extensions.PDParticleSystem;
   import starling.textures.Texture;
   
   public class FSPDParticleSystem extends PDParticleSystem
   {
      
      private var mSku:String;
      
      private var mConfig:XML;
      
      public function FSPDParticleSystem(param1:XML, param2:Texture)
      {
         this.mConfig = param1;
         super(param1,param2);
      }
      
      public function setSku(param1:String) : void
      {
         this.mSku = param1;
      }
      
      override public function removeFromParent(param1:Boolean = false) : void
      {
         super.removeFromParent();
         stop();
         if(param1)
         {
            parseConfig(this.mConfig);
            AssetsParticles.addParticleSystemToPool(this.mSku,this);
         }
      }
      
      override public function dispose() : void
      {
      }
   }
}

