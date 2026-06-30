package starling.display
{
   import flash.geom.Point;
   import starling.geom.Polygon;
   import starling.rendering.IndexData;
   import starling.rendering.VertexData;
   
   public class Canvas extends DisplayObjectContainer
   {
      
      private var _polygons:Vector.<Polygon>;
      
      private var _fillColor:uint;
      
      private var _fillAlpha:Number;
      
      public function Canvas()
      {
         super();
         this._polygons = new Vector.<Polygon>(0);
         this._fillColor = 16777215;
         this._fillAlpha = 1;
         touchGroup = true;
      }
      
      override public function dispose() : void
      {
         this._polygons.length = 0;
         super.dispose();
      }
      
      override public function hitTest(param1:Point) : DisplayObject
      {
         if(!visible || !touchable || !hitTestMask(param1))
         {
            return null;
         }
         var _loc2_:int = 0;
         var _loc3_:int = int(this._polygons.length);
         while(_loc2_ < _loc3_)
         {
            if(this._polygons[_loc2_].containsPoint(param1))
            {
               return this;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function drawCircle(param1:Number, param2:Number, param3:Number, param4:int = -1) : void
      {
         this.appendPolygon(Polygon.createCircle(param1,param2,param3,param4));
      }
      
      public function drawEllipse(param1:Number, param2:Number, param3:Number, param4:Number, param5:int = -1) : void
      {
         var _loc6_:Number = param3 / 2;
         var _loc7_:Number = param4 / 2;
         this.appendPolygon(Polygon.createEllipse(param1 + _loc6_,param2 + _loc7_,_loc6_,_loc7_,param5));
      }
      
      public function drawRectangle(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.appendPolygon(Polygon.createRectangle(param1,param2,param3,param4));
      }
      
      public function drawPolygon(param1:Polygon) : void
      {
         this.appendPolygon(param1);
      }
      
      public function beginFill(param1:uint = 16777215, param2:Number = 1) : void
      {
         this._fillColor = param1;
         this._fillAlpha = param2;
      }
      
      public function endFill() : void
      {
         this._fillColor = 16777215;
         this._fillAlpha = 1;
      }
      
      public function clear() : void
      {
         removeChildren(0,-1,true);
         this._polygons.length = 0;
      }
      
      private function appendPolygon(param1:Polygon) : void
      {
         var _loc2_:VertexData = new VertexData();
         var _loc3_:IndexData = new IndexData(param1.numTriangles * 3);
         param1.triangulate(_loc3_);
         param1.copyToVertexData(_loc2_);
         _loc2_.colorize("color",this._fillColor,this._fillAlpha);
         addChild(new Mesh(_loc2_,_loc3_));
         this._polygons[this._polygons.length] = param1;
      }
   }
}

