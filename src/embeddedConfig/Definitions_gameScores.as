package embeddedConfig
{
   import mx.core.ByteArrayAsset;
   
   [Embed(source="/_assets/8_embeddedConfig.Definitions_gameScores.bin", mimeType="application/octet-stream")]
   public class Definitions_gameScores extends ByteArrayAsset
   {
      
      public function Definitions_gameScores()
      {
         super();
      }
   }
}

