package starling.display
{
   import flash.errors.IllegalOperationError;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import starling.animation.IAnimatable;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class MovieClip extends Image implements IAnimatable
   {
      
      private var _frames:Vector.<MovieClipFrame>;
      
      private var _defaultFrameDuration:Number;
      
      private var _currentTime:Number;
      
      private var _currentFrameID:int;
      
      private var _loop:Boolean;
      
      private var _playing:Boolean;
      
      private var _muted:Boolean;
      
      private var _wasStopped:Boolean;
      
      private var _soundTransform:SoundTransform;
      
      public function MovieClip(param1:Vector.<Texture>, param2:Number = 12)
      {
         if(param1.length > 0)
         {
            super(param1[0]);
            this.init(param1,param2);
            return;
         }
         throw new ArgumentError("Empty texture array");
      }
      
      private function init(param1:Vector.<Texture>, param2:Number) : void
      {
         if(param2 <= 0)
         {
            throw new ArgumentError("Invalid fps: " + param2);
         }
         var _loc3_:int = int(param1.length);
         this._defaultFrameDuration = 1 / param2;
         this._loop = true;
         this._playing = true;
         this._currentTime = 0;
         this._currentFrameID = 0;
         this._wasStopped = true;
         this._frames = new Vector.<MovieClipFrame>(0);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._frames[_loc4_] = new MovieClipFrame(param1[_loc4_],this._defaultFrameDuration,this._defaultFrameDuration * _loc4_);
            _loc4_++;
         }
      }
      
      public function addFrame(param1:Texture, param2:Sound = null, param3:Number = -1) : void
      {
         this.addFrameAt(this.numFrames,param1,param2,param3);
      }
      
      public function addFrameAt(param1:int, param2:Texture, param3:Sound = null, param4:Number = -1) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(param1 < 0 || param1 > this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         if(param4 < 0)
         {
            param4 = this._defaultFrameDuration;
         }
         var _loc5_:MovieClipFrame = new MovieClipFrame(param2,param4);
         _loc5_.sound = param3;
         this._frames.insertAt(param1,_loc5_);
         if(param1 == this.numFrames)
         {
            _loc6_ = param1 > 0 ? this._frames[param1 - 1].startTime : 0;
            _loc7_ = param1 > 0 ? this._frames[param1 - 1].duration : 0;
            _loc5_.startTime = _loc6_ + _loc7_;
         }
         else
         {
            this.updateStartTimes();
         }
      }
      
      public function removeFrameAt(param1:int) : void
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         if(this.numFrames == 1)
         {
            throw new IllegalOperationError("Movie clip must not be empty");
         }
         this._frames.removeAt(param1);
         if(param1 != this.numFrames)
         {
            this.updateStartTimes();
         }
      }
      
      public function getFrameTexture(param1:int) : Texture
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return this._frames[param1].texture;
      }
      
      public function setFrameTexture(param1:int, param2:Texture) : void
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         this._frames[param1].texture = param2;
      }
      
      public function getFrameSound(param1:int) : Sound
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return this._frames[param1].sound;
      }
      
      public function setFrameSound(param1:int, param2:Sound) : void
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         this._frames[param1].sound = param2;
      }
      
      public function getFrameAction(param1:int) : Function
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return this._frames[param1].action;
      }
      
      public function setFrameAction(param1:int, param2:Function) : void
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         this._frames[param1].action = param2;
      }
      
      public function getFrameDuration(param1:int) : Number
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return this._frames[param1].duration;
      }
      
      public function setFrameDuration(param1:int, param2:Number) : void
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         this._frames[param1].duration = param2;
         this.updateStartTimes();
      }
      
      public function reverseFrames() : void
      {
         this._frames.reverse();
         this._currentTime = this.totalTime - this._currentTime;
         this._currentFrameID = this.numFrames - this._currentFrameID - 1;
         this.updateStartTimes();
      }
      
      public function play() : void
      {
         this._playing = true;
      }
      
      public function pause() : void
      {
         this._playing = false;
      }
      
      public function stop() : void
      {
         this._playing = false;
         this._wasStopped = true;
         this.currentFrame = 0;
      }
      
      private function updateStartTimes() : void
      {
         var _loc1_:int = this.numFrames;
         var _loc2_:MovieClipFrame = this._frames[0];
         _loc2_.startTime = 0;
         var _loc3_:int = 1;
         while(_loc3_ < _loc1_)
         {
            this._frames[_loc3_].startTime = _loc2_.startTime + _loc2_.duration;
            _loc2_ = this._frames[_loc3_];
            _loc3_++;
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         if(!this._playing)
         {
            return;
         }
         var _loc2_:MovieClipFrame = this._frames[this._currentFrameID];
         if(this._wasStopped)
         {
            this._wasStopped = false;
            _loc2_.playSound(this._soundTransform);
            if(_loc2_.action != null)
            {
               _loc2_.executeAction(this,this._currentFrameID);
               this.advanceTime(param1);
               return;
            }
         }
         if(this._currentTime == this.totalTime)
         {
            if(!this._loop)
            {
               return;
            }
            this._currentTime = 0;
            this._currentFrameID = 0;
            _loc2_ = this._frames[0];
            _loc2_.playSound(this._soundTransform);
            texture = _loc2_.texture;
            if(_loc2_.action != null)
            {
               _loc2_.executeAction(this,this._currentFrameID);
               this.advanceTime(param1);
               return;
            }
         }
         var _loc3_:int = this._frames.length - 1;
         var _loc4_:Boolean = false;
         var _loc5_:Function = null;
         var _loc6_:int = this._currentFrameID;
         while(this._currentTime + param1 >= _loc2_.endTime)
         {
            _loc8_ = false;
            _loc7_ = _loc2_.duration - this._currentTime + _loc2_.startTime;
            param1 -= _loc7_;
            this._currentTime = _loc2_.startTime + _loc2_.duration;
            if(this._currentFrameID == _loc3_)
            {
               if(hasEventListener(Event.COMPLETE))
               {
                  _loc4_ = true;
               }
               else
               {
                  if(!this._loop)
                  {
                     return;
                  }
                  this._currentTime = 0;
                  this._currentFrameID = 0;
                  _loc8_ = true;
               }
            }
            else
            {
               this._currentFrameID += 1;
               _loc8_ = true;
            }
            _loc2_ = this._frames[this._currentFrameID];
            _loc5_ = _loc2_.action;
            if(_loc8_)
            {
               _loc2_.playSound(this._soundTransform);
            }
            if(_loc4_)
            {
               texture = _loc2_.texture;
               dispatchEventWith(Event.COMPLETE);
               this.advanceTime(param1);
               return;
            }
            if(_loc5_ != null)
            {
               texture = _loc2_.texture;
               _loc2_.executeAction(this,this._currentFrameID);
               this.advanceTime(param1);
               return;
            }
         }
         if(_loc6_ != this._currentFrameID)
         {
            texture = this._frames[this._currentFrameID].texture;
         }
         this._currentTime += param1;
      }
      
      public function get numFrames() : int
      {
         return this._frames.length;
      }
      
      public function get totalTime() : Number
      {
         var _loc1_:MovieClipFrame = this._frames[this._frames.length - 1];
         return _loc1_.startTime + _loc1_.duration;
      }
      
      public function get currentTime() : Number
      {
         return this._currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         if(param1 < 0 || param1 > this.totalTime)
         {
            throw new ArgumentError("Invalid time: " + param1);
         }
         var _loc2_:int = this._frames.length - 1;
         this._currentTime = param1;
         this._currentFrameID = 0;
         while(this._currentFrameID < _loc2_ && this._frames[this._currentFrameID + 1].startTime <= param1)
         {
            ++this._currentFrameID;
         }
         var _loc3_:MovieClipFrame = this._frames[this._currentFrameID];
         texture = _loc3_.texture;
      }
      
      public function get loop() : Boolean
      {
         return this._loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         this._loop = param1;
      }
      
      public function get muted() : Boolean
      {
         return this._muted;
      }
      
      public function set muted(param1:Boolean) : void
      {
         this._muted = param1;
      }
      
      public function get soundTransform() : SoundTransform
      {
         return this._soundTransform;
      }
      
      public function set soundTransform(param1:SoundTransform) : void
      {
         this._soundTransform = param1;
      }
      
      public function get currentFrame() : int
      {
         return this._currentFrameID;
      }
      
      public function set currentFrame(param1:int) : void
      {
         if(param1 < 0 || param1 >= this.numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         this.currentTime = this._frames[param1].startTime;
      }
      
      public function get fps() : Number
      {
         return 1 / this._defaultFrameDuration;
      }
      
      public function set fps(param1:Number) : void
      {
         if(param1 <= 0)
         {
            throw new ArgumentError("Invalid fps: " + param1);
         }
         var _loc2_:Number = 1 / param1;
         var _loc3_:Number = _loc2_ / this._defaultFrameDuration;
         this._currentTime *= _loc3_;
         this._defaultFrameDuration = _loc2_;
         var _loc4_:int = 0;
         while(_loc4_ < this.numFrames)
         {
            this._frames[_loc4_].duration *= _loc3_;
            _loc4_++;
         }
         this.updateStartTimes();
      }
      
      public function get isPlaying() : Boolean
      {
         if(this._playing)
         {
            return this._loop || this._currentTime < this.totalTime;
         }
         return false;
      }
      
      public function get isComplete() : Boolean
      {
         return !this._loop && this._currentTime >= this.totalTime;
      }
   }
}

import flash.media.Sound;
import flash.media.SoundTransform;
import starling.textures.Texture;

class MovieClipFrame
{
   
   public var texture:Texture;
   
   public var sound:Sound;
   
   public var duration:Number;
   
   public var startTime:Number;
   
   public var action:Function;
   
   public function MovieClipFrame(param1:Texture, param2:Number = 0.1, param3:Number = 0)
   {
      super();
      this.texture = param1;
      this.duration = param2;
      this.startTime = param3;
   }
   
   public function playSound(param1:SoundTransform) : void
   {
      if(this.sound)
      {
         this.sound.play(0,0,param1);
      }
   }
   
   public function executeAction(param1:MovieClip, param2:int) : void
   {
      var _loc3_:int = 0;
      if(this.action != null)
      {
         _loc3_ = int(this.action.length);
         if(_loc3_ == 0)
         {
            this.action();
         }
         else if(_loc3_ == 1)
         {
            this.action(param1);
         }
         else
         {
            if(_loc3_ != 2)
            {
               throw new Error("Frame actions support zero, one or two parameters: " + "movie:MovieClip, frameID:int");
            }
            this.action(param1,param2);
         }
      }
   }
   
   public function get endTime() : Number
   {
      return this.startTime + this.duration;
   }
}
