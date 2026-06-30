package starling.filters
{
   import starling.rendering.Painter;
   import starling.textures.Texture;
   
   public class GlowFilter extends FragmentFilter
   {
      
      private var _blurFilter:BlurFilter;
      
      private var _compositeFilter:CompositeFilter;
      
      private var _inner:Boolean;
      
      private var _knockout:Boolean;
      
      public function GlowFilter(param1:uint = 16776960, param2:Number = 1, param3:Number = 1, param4:Number = 0.5, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this._compositeFilter = new CompositeFilter();
         this._blurFilter = new BlurFilter(param3,param3);
         this.color = param1;
         this.alpha = param2;
         this.quality = param4;
         this.inner = param5;
         this.knockout = param6;
         this.updatePadding();
      }
      
      private static function getMode(param1:Boolean, param2:Boolean) : String
      {
         return param2 ? (param1 ? CompositeMode.INSIDE_KNOCKOUT : CompositeMode.OUTSIDE_KNOCKOUT) : (param1 ? CompositeMode.INSIDE : CompositeMode.OUTSIDE);
      }
      
      override public function dispose() : void
      {
         this._blurFilter.dispose();
         this._compositeFilter.dispose();
         super.dispose();
      }
      
      override public function process(param1:Painter, param2:IFilterHelper, param3:Texture = null, param4:Texture = null, param5:Texture = null, param6:Texture = null) : Texture
      {
         var _loc7_:Texture = this._blurFilter.process(param1,param2,param3);
         var _loc8_:Texture = this._compositeFilter.process(param1,param2,param3,_loc7_);
         param2.putTexture(_loc7_);
         return _loc8_;
      }
      
      override public function get numPasses() : int
      {
         return this._blurFilter.numPasses + this._compositeFilter.numPasses;
      }
      
      private function updatePadding() : void
      {
         padding.copyFrom(this._blurFilter.padding);
      }
      
      public function get color() : uint
      {
         return this._compositeFilter.getColorAt(1);
      }
      
      public function set color(param1:uint) : void
      {
         if(this.color != param1 || !this._compositeFilter.getReplaceColorAt(1))
         {
            this._compositeFilter.setColorAt(1,param1,true);
            setRequiresRedraw();
         }
      }
      
      public function get alpha() : Number
      {
         return this._compositeFilter.getAlphaAt(1);
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this.alpha != param1)
         {
            this._compositeFilter.setAlphaAt(1,param1);
            setRequiresRedraw();
         }
      }
      
      public function get blur() : Number
      {
         return this._blurFilter.blurX;
      }
      
      public function set blur(param1:Number) : void
      {
         if(this.blur != param1)
         {
            this._blurFilter.blurX = this._blurFilter.blurY = param1;
            setRequiresRedraw();
            this.updatePadding();
         }
      }
      
      public function get quality() : Number
      {
         return this._blurFilter.quality;
      }
      
      public function set quality(param1:Number) : void
      {
         if(this.quality != param1)
         {
            this._blurFilter.quality = param1;
            setRequiresRedraw();
            this.updatePadding();
         }
      }
      
      public function get inner() : Boolean
      {
         return this._inner;
      }
      
      public function set inner(param1:Boolean) : void
      {
         this._inner = param1;
         this._compositeFilter.setModeAt(1,getMode(this._inner,this._knockout));
         this._compositeFilter.setInvertAlphaAt(1,this._inner);
         setRequiresRedraw();
      }
      
      public function get knockout() : Boolean
      {
         return this._knockout;
      }
      
      public function set knockout(param1:Boolean) : void
      {
         this._knockout = param1;
         this._compositeFilter.setModeAt(1,getMode(this._inner,this._knockout));
         setRequiresRedraw();
      }
   }
}

