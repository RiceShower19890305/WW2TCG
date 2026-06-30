package starling.core
{
   import flash.geom.Rectangle;
   import flash.system.System;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.styles.MeshStyle;
   import starling.text.BitmapFont;
   import starling.text.TextField;
   import starling.utils.Align;
   
   internal class StatsDisplay extends Sprite
   {
      
      private static const UPDATE_INTERVAL:Number = 0.5;
      
      private static const B_TO_MB:Number = 1 / (1024 * 1024);
      
      private var _background:Quad;
      
      private var _labels:TextField;
      
      private var _values:TextField;
      
      private var _frameCount:int = 0;
      
      private var _totalTime:Number = 0;
      
      private var _fps:Number = 0;
      
      private var _memory:Number = 0;
      
      private var _gpuMemory:Number = 0;
      
      private var _drawCount:int = 0;
      
      private var _skipCount:int = 0;
      
      public function StatsDisplay()
      {
         var _loc1_:String = null;
         var _loc4_:Number = NaN;
         super();
         _loc1_ = BitmapFont.MINI;
         var _loc2_:Number = BitmapFont.NATIVE_SIZE;
         var _loc3_:uint = 16777215;
         _loc4_ = 90;
         var _loc5_:Number = this.supportsGpuMem ? 35 : 27;
         var _loc6_:String = this.supportsGpuMem ? "\ngpu memory:" : "";
         var _loc7_:String = "frames/sec:\nstd memory:" + _loc6_ + "\ndraw calls:";
         this._labels = new TextField(_loc4_,_loc5_,_loc7_);
         this._labels.format.setTo(_loc1_,_loc2_,_loc3_,Align.LEFT);
         this._labels.batchable = true;
         this._labels.x = 2;
         this._values = new TextField(_loc4_ - 1,_loc5_,"");
         this._values.format.setTo(_loc1_,_loc2_,_loc3_,Align.RIGHT);
         this._values.batchable = true;
         this._background = new Quad(_loc4_,_loc5_,0);
         if(this._background.style.type != MeshStyle)
         {
            this._background.style = new MeshStyle();
         }
         if(this._labels.style.type != MeshStyle)
         {
            this._labels.style = new MeshStyle();
         }
         if(this._values.style.type != MeshStyle)
         {
            this._values.style = new MeshStyle();
         }
         addChild(this._background);
         addChild(this._labels);
         addChild(this._values);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage() : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._totalTime = this._frameCount = this._skipCount = 0;
         this.update();
      }
      
      private function onRemovedFromStage() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:EnterFrameEvent) : void
      {
         this._totalTime += param1.passedTime;
         ++this._frameCount;
         if(this._totalTime > UPDATE_INTERVAL)
         {
            this.update();
            this._frameCount = this._skipCount = this._totalTime = 0;
         }
      }
      
      public function update() : void
      {
         this._background.color = this._skipCount > this._frameCount / 2 ? 16128 : 0;
         this._fps = this._totalTime > 0 ? this._frameCount / this._totalTime : 0;
         this._memory = System.totalMemory * B_TO_MB;
         this._gpuMemory = this.supportsGpuMem ? Starling.context["totalGPUMemory"] * B_TO_MB : -1;
         var _loc1_:String = this._fps.toFixed(this._fps < 100 ? 1 : 0);
         var _loc2_:String = this._memory.toFixed(this._memory < 100 ? 1 : 0);
         var _loc3_:String = this._gpuMemory.toFixed(this._gpuMemory < 100 ? 1 : 0);
         var _loc4_:String = (this._totalTime > 0 ? this._drawCount - 2 : this._drawCount).toString();
         this._values.text = _loc1_ + "\n" + _loc2_ + "\n" + (this._gpuMemory >= 0 ? _loc3_ + "\n" : "") + _loc4_;
      }
      
      public function markFrameAsSkipped() : void
      {
         this._skipCount += 1;
      }
      
      override public function render(param1:Painter) : void
      {
         param1.excludeFromCache(this);
         param1.finishMeshBatch();
         super.render(param1);
      }
      
      override public function getBounds(param1:DisplayObject, param2:flash.geom.Rectangle = null) : flash.geom.Rectangle
      {
         return this._background.getBounds(param1,param2);
      }
      
      private function get supportsGpuMem() : Boolean
      {
         return "totalGPUMemory" in Starling.context;
      }
      
      public function get drawCount() : int
      {
         return this._drawCount;
      }
      
      public function set drawCount(param1:int) : void
      {
         this._drawCount = param1;
      }
      
      public function get fps() : Number
      {
         return this._fps;
      }
      
      public function set fps(param1:Number) : void
      {
         this._fps = param1;
      }
      
      public function get memory() : Number
      {
         return this._memory;
      }
      
      public function set memory(param1:Number) : void
      {
         this._memory = param1;
      }
      
      public function get gpuMemory() : Number
      {
         return this._gpuMemory;
      }
      
      public function set gpuMemory(param1:Number) : void
      {
         this._gpuMemory = param1;
      }
   }
}

