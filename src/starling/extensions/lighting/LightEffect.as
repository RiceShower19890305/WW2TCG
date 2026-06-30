package starling.extensions.lighting
{
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.geom.Vector3D;
   import starling.rendering.MeshEffect;
   import starling.rendering.Program;
   import starling.rendering.VertexDataFormat;
   import starling.textures.Texture;
   import starling.utils.Color;
   import starling.utils.MathUtil;
   import starling.utils.RenderUtil;
   import starling.utils.StringUtil;
   
   public class LightEffect extends MeshEffect
   {
      
      public static const VERTEX_FORMAT:VertexDataFormat = MeshEffect.VERTEX_FORMAT.extend("normalTexCoords:float2, material:bytes4, xAxis:float2, yAxis:float2, zScale:float1");
      
      private static const sVector:Vector.<Number> = new Vector.<Number>(4,true);
      
      private var _lights:Vector.<Light>;
      
      private var _normalTexture:Texture;
      
      private var _cameraPosition:Vector3D;
      
      public function LightEffect()
      {
         super();
         this._lights = new Vector.<Light>(0);
         this._cameraPosition = new Vector3D();
      }
      
      override protected function createProgram() : Program
      {
         var numLights:int;
         var i:int;
         var light:Light = null;
         var lPos:String = null;
         var lCol:String = null;
         var calcLightVector:String = null;
         var nrm:Function = function(param1:String):String
         {
            return StringUtil.format("mul {0}.xyz, {0}.xyz, fc0.www \n" + "nrm {0}.xyz, {0}.xyz",param1);
         };
         var vertexShader:Array = ["mov vt0, va4","mul vt0.w, vt0.w, vc5.w","m44  op, va0, vc0","mov  v0, va0     ","mov  v1, va1     ","mul  v2, va2, vc4","mov  v3, va3     ","mov  v4, vt0     ","crs vt1.xyz, va5.xyz, va6.xyz","mul vt1.xyz, vt1.xyz, va7.xxx","mov v5.xw, va5.xw","mov v6.xw, va5.yw","mov v7.xw, va5.zw","mov v5.y, va6.x","mov v6.y, va6.y","mov v7.y, va6.z","mov v5.z, vt1.x","mov v6.z, vt1.y","mov v7.z, vt1.z"];
         var fragmentShader:Array = [tex("ft0","v1",0,texture),"mul ft0, ft0, v2"];
         if(this._normalTexture)
         {
            fragmentShader.push(tex("ft1","v3",1,this.normalTexture,false),"mul ft1.xy, ft1.xy, fc0.zz","sub ft1.xy, ft1.xy, fc0.yy","neg ft1.z, ft1.z","neg ft1.y, ft1.y");
         }
         else
         {
            fragmentShader.push("mov ft1, fc0.xxyy","neg ft1.z,  ft1.z");
         }
         fragmentShader.push("m33 ft1.xyz, ft1.xyz, v5","nrm ft1.xyz, ft1.xyz");
         numLights = MathUtil.min(this._lights.length,LightStyle.MAX_NUM_LIGHTS);
         i = 0;
         while(i < numLights)
         {
            light = this._lights[i];
            lPos = "fc" + (10 + 2 * i);
            lCol = "fc" + (11 + 2 * i);
            if(light.type == LightSource.TYPE_AMBIENT)
            {
               fragmentShader.push("mul ft2, ft0, " + lCol,"mul ft2, ft2, v4.xxxx");
            }
            else
            {
               calcLightVector = light.type == LightSource.TYPE_POINT ? "sub ft2, " + lPos + ", v0" : "mov ft2, " + lPos;
               fragmentShader.push(calcLightVector,nrm("ft2"),"dp3 ft3, ft2, ft1","sat ft3, ft3","mul ft4, ft3, fc0.z","mul ft4, ft4, ft1","sub ft4, ft4, ft2","sub ft5, fc3, v0",nrm("ft5"),"dp3 ft2, ft4, ft5","sat ft2, ft2","mul ft3, ft3, " + lCol,"mul ft3, ft3, v4.yyyy","pow ft4, ft2, v4.wwww","mul ft4, ft4, " + lCol,"mul ft4, ft4, v4.zzzz","mul ft4, ft4, ft0.wwww","mul ft2, ft0, ft3","add ft2, ft2, ft4");
            }
            fragmentShader.push(i == 0 ? "mov ft6, ft2" : "add ft6, ft6, ft2");
            i++;
         }
         if(numLights == 0)
         {
            fragmentShader.push("mov ft6, fc0.xxxx");
         }
         fragmentShader.push("mov ft6.w, ft0.w","mov oc, ft6");
         return Program.fromSource(vertexShader.join("\n"),fragmentShader.join("\n"));
      }
      
      override protected function beforeDraw(param1:Context3D) : void
      {
         var _loc4_:Light = null;
         var _loc5_:Boolean = false;
         super.beforeDraw(param1);
         sVector[0] = sVector[1] = sVector[2] = sVector[3] = LightStyle.MAX_SHININESS;
         param1.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,sVector);
         sVector[0] = 0;
         sVector[1] = 1;
         sVector[2] = 2;
         sVector[3] = 0.1;
         param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,sVector);
         sVector[0] = this._cameraPosition.x;
         sVector[1] = this._cameraPosition.y;
         sVector[2] = this._cameraPosition.z;
         sVector[3] = this._cameraPosition.w;
         param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,sVector);
         var _loc2_:int = 0;
         var _loc3_:int = int(this._lights.length);
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._lights[_loc2_];
            sVector[0] = _loc4_.x;
            sVector[1] = _loc4_.y;
            sVector[2] = _loc4_.z;
            sVector[3] = 1;
            param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,10 + 2 * _loc2_,sVector);
            Color.toVector(_loc4_.color,sVector);
            param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,11 + 2 * _loc2_,sVector);
            _loc2_++;
         }
         if(this._normalTexture)
         {
            _loc5_ = textureRepeat && this._normalTexture.root.isPotTexture;
            RenderUtil.setSamplerStateAt(1,this._normalTexture.mipMapping,textureSmoothing,_loc5_);
            param1.setTextureAt(1,this._normalTexture.base);
         }
         this.vertexFormat.setVertexBufferAt(3,vertexBuffer,"normalTexCoords");
         this.vertexFormat.setVertexBufferAt(4,vertexBuffer,"material");
         this.vertexFormat.setVertexBufferAt(5,vertexBuffer,"xAxis");
         this.vertexFormat.setVertexBufferAt(6,vertexBuffer,"yAxis");
         this.vertexFormat.setVertexBufferAt(7,vertexBuffer,"zScale");
      }
      
      override protected function afterDraw(param1:Context3D) : void
      {
         param1.setTextureAt(1,null);
         param1.setVertexBufferAt(3,null);
         param1.setVertexBufferAt(4,null);
         param1.setVertexBufferAt(5,null);
         param1.setVertexBufferAt(6,null);
         param1.setVertexBufferAt(7,null);
         super.afterDraw(param1);
      }
      
      override protected function get programVariantName() : uint
      {
         var _loc5_:Light = null;
         var _loc6_:uint = 0;
         var _loc1_:uint = RenderUtil.getTextureVariantBits(this._normalTexture);
         var _loc2_:int = int(this._lights.length);
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._lights[_loc4_];
            switch(_loc5_.type)
            {
               case LightSource.TYPE_AMBIENT:
                  _loc6_ = 3;
                  break;
               case LightSource.TYPE_DIRECTIONAL:
                  _loc6_ = 2;
                  break;
               default:
                  _loc6_ = 1;
            }
            _loc3_ |= _loc6_ << _loc4_ * 2;
            _loc4_++;
         }
         return super.programVariantName | _loc1_ << 8 | _loc3_ << 16;
      }
      
      override public function get vertexFormat() : VertexDataFormat
      {
         return VERTEX_FORMAT;
      }
      
      public function get numLights() : int
      {
         return this._lights.length;
      }
      
      public function set numLights(param1:int) : void
      {
         var _loc2_:int = int(this._lights.length);
         var _loc3_:int = _loc2_;
         while(_loc3_ < param1)
         {
            this._lights[_loc3_] = new Light();
            _loc3_++;
         }
         this._lights.length = param1;
      }
      
      public function setLightAt(param1:int, param2:String, param3:uint, param4:Vector3D) : void
      {
         if(param1 >= this.numLights)
         {
            this.numLights = param1 + 1;
         }
         var _loc5_:Light = this._lights[param1];
         _loc5_.type = param2;
         _loc5_.color = param3;
         _loc5_.x = param4.x;
         _loc5_.y = param4.y;
         _loc5_.z = param4.z;
      }
      
      public function get cameraPosition() : Vector3D
      {
         return this._cameraPosition;
      }
      
      public function set cameraPosition(param1:Vector3D) : void
      {
         this._cameraPosition.copyFrom(param1);
      }
      
      public function get normalTexture() : Texture
      {
         return this._normalTexture;
      }
      
      public function set normalTexture(param1:Texture) : void
      {
         this._normalTexture = param1;
      }
   }
}

class Light
{
   
   public var x:Number;
   
   public var y:Number;
   
   public var z:Number;
   
   public var color:uint;
   
   public var type:String;
   
   public function Light(param1:uint = 16777215, param2:String = "point")
   {
      super();
      this.x = this.y = this.z = 0;
      this.color = param1;
      this.type = param2;
   }
}
