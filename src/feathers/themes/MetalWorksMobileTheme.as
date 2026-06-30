package feathers.themes
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class MetalWorksMobileTheme extends BaseMetalWorksMobileTheme
   {
      
      protected static const ATLAS_XML:Class = MetalWorksMobileTheme_ATLAS_XML;
      
      protected static const ATLAS_BITMAP:Class = MetalWorksMobileTheme_ATLAS_BITMAP;
      
      public function MetalWorksMobileTheme()
      {
         super();
         this.initialize();
      }
      
      override protected function initialize() : void
      {
         this.initializeTextureAtlas();
         super.initialize();
      }
      
      protected function initializeTextureAtlas() : void
      {
         var _loc1_:BitmapData = Bitmap(new ATLAS_BITMAP()).bitmapData;
         var _loc2_:Texture = Texture.fromBitmapData(_loc1_,false,false,2);
         _loc2_.root.onRestore = this.atlasTexture_onRestore;
         _loc1_.dispose();
         this.atlas = new TextureAtlas(_loc2_,XML(new ATLAS_XML()));
      }
      
      protected function atlasTexture_onRestore() : void
      {
         var _loc1_:BitmapData = Bitmap(new ATLAS_BITMAP()).bitmapData;
         this.atlas.texture.root.uploadBitmapData(_loc1_);
         _loc1_.dispose();
      }
   }
}

