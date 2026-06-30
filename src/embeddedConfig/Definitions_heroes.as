package embeddedConfig
{
   import mx.core.ByteArrayAsset;
   
   [Embed(source="/_assets/104_embeddedConfig.Definitions_heroes.bin", mimeType="application/octet-stream")]
   public class Definitions_heroes extends ByteArrayAsset
   {
      
      public function Definitions_heroes()
      {
         super();
      }
   }
}

