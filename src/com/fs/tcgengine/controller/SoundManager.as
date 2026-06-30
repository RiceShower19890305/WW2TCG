package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.greensock.TweenMax;
   import flash.events.Event;
   import flash.media.AudioPlaybackMode;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class SoundManager
   {
      
      private static var mInstance:SoundManager;
      
      private static var mAllowInstance:Boolean;
      
      public static const SOUND_INITIAL_VOLUME:Number = 0.5;
      
      public static const TYPE_MUSIC:int = 0;
      
      public static const TYPE_SFX:int = 1;
      
      private static const MAX_SOUNDS_COUNT:int = !Utils.isAndroid() ? 30 : 15;
      
      private var mMusicOn:Boolean;
      
      private var mSfxOn:Boolean;
      
      private var mSoundsDictionary:Dictionary;
      
      private var mSounds:Array;
      
      private var mLastMusic:String;
      
      private var mSoundsCount:int;
      
      private var mGeneralVolume:Number;
      
      private var mMusicVolume:Number;
      
      private var mSfxVolume:Number;
      
      private var mTrackList:Vector.<String>;
      
      private var mTrackListCurrIndex:int = -1;
      
      private var mAndroidEndlessSound:Sound;
      
      private var mAndroidEndlessSoundChannel:SoundChannel;
      
      public function SoundManager()
      {
         super();
         if(!SoundManager.mAllowInstance)
         {
            throw new Error("ERROR: SoundManager Error: Instantiation failed: Use SoundManager.getInstance() instead of new.");
         }
         this.mMusicOn = true;
         this.mSfxOn = true;
         this.mSoundsDictionary = new Dictionary(true);
         this.mSounds = new Array();
         this.mLastMusic = "";
         this.mSoundsCount = 0;
         this.mGeneralVolume = SOUND_INITIAL_VOLUME;
         this.mMusicVolume = SOUND_INITIAL_VOLUME * 0.35;
         this.mSfxVolume = SOUND_INITIAL_VOLUME * 1.25;
         if(Utils.isMobile())
         {
            SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
         }
         if(Utils.isAndroid() && Config.ANDROID_LOOP_ENDLESS_SOUND)
         {
            this.playAndroidEndlessSound();
         }
      }
      
      public static function getInstance() : SoundManager
      {
         if(SoundManager.mInstance == null)
         {
            SoundManager.mAllowInstance = true;
            SoundManager.mInstance = new SoundManager();
            SoundManager.mAllowInstance = false;
         }
         return SoundManager.mInstance;
      }
      
      private function playAndroidEndlessSound() : void
      {
         var playSound:Function = function():void
         {
            mAndroidEndlessSoundChannel = mAndroidEndlessSound.play(0,int.MAX_VALUE,new SoundTransform(0));
         };
         if(Root.smRootInitialized && Boolean(Root.assets))
         {
            if(this.mAndroidEndlessSound == null)
            {
               if(!Root.assets.getSound(Constants.SOUND_HELP))
               {
                  setTimeout(this.playAndroidEndlessSound,1000);
                  return;
               }
               this.mAndroidEndlessSound = Sound(Root.assets.getSound(Constants.SOUND_HELP));
            }
            playSound();
         }
         else
         {
            setTimeout(this.playAndroidEndlessSound,1000);
         }
      }
      
      private function notifyAssetsLoaded() : void
      {
         if(this.mLastMusic != "" && this.mLastMusic != this.mTrackList[this.mTrackListCurrIndex])
         {
            this.removeSound(this.mLastMusic);
         }
         this.playSound(this.mTrackList[this.mTrackListCurrIndex],TYPE_MUSIC);
      }
      
      public function addTrackList(param1:Vector.<String>) : void
      {
         this.mTrackList = param1;
         this.mTrackListCurrIndex = -1;
      }
      
      public function loadNextTrack(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         if(Boolean(this.mTrackList) && this.mMusicOn)
         {
            if(!param1)
            {
               this.mTrackListCurrIndex = this.mTrackListCurrIndex + 1 < this.mTrackList.length ? int(this.mTrackListCurrIndex + 1) : 0;
            }
            if(Boolean(!Root.assets.isLoading && InstanceMng.getCurrentScreen()) && Boolean(InstanceMng.getCurrentScreen().isFullyLoaded()) && this.mTrackList.length > 0)
            {
               _loc2_ = this.mTrackList[this.mTrackListCurrIndex];
               if(Root.assets.getSound(_loc2_) == null)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("soundtrack/" + _loc2_,FSResourceMng.TYPE_AUDIO);
                  InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
               }
               else
               {
                  this.notifyAssetsLoaded();
               }
            }
            else
            {
               TweenMax.delayedCall(3,this.loadNextTrack,[true]);
            }
         }
      }
      
      private function addExternalSound(param1:String, param2:int) : Boolean
      {
         if(this.soundExists(param1))
         {
            return false;
         }
         var _loc3_:Sound = Root.assets.getSound(param1);
         this.createSound(_loc3_,param1,param2);
         return true;
      }
      
      private function createSound(param1:Sound, param2:String, param3:int) : void
      {
         var _loc4_:Object = new Object();
         _loc4_.name = param2;
         _loc4_.sound = param1;
         _loc4_.channel = new SoundChannel();
         _loc4_.position = 0;
         _loc4_.paused = false;
         _loc4_.stopped = true;
         _loc4_.volume = SOUND_INITIAL_VOLUME;
         _loc4_.type = param3;
         _loc4_.length = 0;
         _loc4_.isTracklist = param3 == TYPE_MUSIC;
         this.mSoundsDictionary[param2] = _loc4_;
         this.mSounds.push(_loc4_);
         this.printSounds();
      }
      
      private function soundCompleteHandler(param1:Event) : void
      {
         var object:Object = null;
         var channel:SoundChannel = null;
         var targetChannel:SoundChannel = null;
         var event:Event = param1;
         for each(object in this.mSoundsDictionary)
         {
            channel = object.channel as SoundChannel;
            targetChannel = event.target as SoundChannel;
            if(targetChannel == channel)
            {
               FSDebug.debugTrace("[soundCompleteHandler] - name: " + object.name);
               targetChannel.removeEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
               try
               {
                  object.channel = object.sound.play(object.position,object.loops,new SoundTransform(this.calcOutputVolume(object.volume,object.type)));
               }
               catch(e:Error)
               {
                  FSDebug.debugTrace("[soundCompleteHandler] - error: " + event.toString());
               }
               object.length = object.sound.length;
               if(object.channel != null)
               {
                  object.channel.addEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
               }
            }
         }
      }
      
      public function getTrackList() : Vector.<String>
      {
         return this.mTrackList;
      }
      
      private function onTracklistSoundCompleteHandler(param1:Event) : void
      {
         var object:Object = null;
         var channel:SoundChannel = null;
         var targetChannel:SoundChannel = null;
         var event:Event = param1;
         for each(object in this.mSoundsDictionary)
         {
            channel = object.channel as SoundChannel;
            targetChannel = event.target as SoundChannel;
            if(targetChannel == channel)
            {
               targetChannel.removeEventListener(Event.SOUND_COMPLETE,this.onTracklistSoundCompleteHandler);
               this.stopSound(object.name);
               try
               {
                  this.loadNextTrack();
               }
               catch(e:Error)
               {
                  FSDebug.debugTrace("[soundCompleteHandler] - error: " + event.toString());
               }
            }
         }
      }
      
      public function soundExists(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mSounds.length)
         {
            if(this.mSounds[_loc2_].name == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function removeSound(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mSounds.length)
         {
            if(this.mSounds[_loc2_].name == param1)
            {
               this.mSounds[_loc2_] = null;
               this.mSounds.splice(_loc2_,1);
            }
            _loc2_++;
         }
         delete this.mSoundsDictionary[param1];
         Root.assets.removeSound(param1);
         if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
         {
            InstanceMng.getResourcesMng().unloadAndroidSound(param1);
         }
      }
      
      public function removeAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.mSounds.length)
         {
            this.mSounds[_loc1_] = null;
            _loc1_++;
         }
         this.mSounds = new Array();
         this.mSoundsDictionary = new Dictionary(true);
      }
      
      public function playSound(param1:String, param2:int) : void
      {
         var soundObject:Object = null;
         var volToGoTo:Number = NaN;
         var soundT:SoundTransform = null;
         var name:String = param1;
         var type:int = param2;
         try
         {
            if(Utils.isAndroid() && type == TYPE_SFX && this.isSfxOn() && !Root.smRootDeactivated && Config.STORE_AUDIO_PATHS)
            {
               InstanceMng.getResourcesMng().playAndroidSound(name);
               return;
            }
            if(name == null || this.mSoundsDictionary == null)
            {
               return;
            }
            soundObject = this.mSoundsDictionary[name];
            if(soundObject == null)
            {
               if(this.addExternalSound(name,type))
               {
                  this.playSound(name,type);
               }
               return;
            }
            volToGoTo = this.calcOutputVolume(soundObject.volume,soundObject.type);
            soundT = new SoundTransform(volToGoTo);
            if(soundObject.type == TYPE_MUSIC)
            {
               if(!this.isMusicOn())
               {
                  soundObject.stopped = false;
                  soundObject.paused = true;
               }
               this.mLastMusic = name;
               if(soundObject.stopped)
               {
                  soundObject.channel = Sound(soundObject.sound).play(0,0,soundT);
                  soundObject.stopped = false;
               }
               if(soundObject.isTracklist == true)
               {
                  soundObject.channel.addEventListener(Event.SOUND_COMPLETE,this.onTracklistSoundCompleteHandler);
               }
            }
            else if(soundObject.type == TYPE_SFX)
            {
               if(!this.isSfxOn())
               {
                  return;
               }
               if(!soundObject.stopped)
               {
                  if(this.mSoundsCount > MAX_SOUNDS_COUNT)
                  {
                     FSDebug.debugTrace("[SoundManager] Amount of sounds exceeded the max (" + MAX_SOUNDS_COUNT + "), skipping.");
                     return;
                  }
                  ++this.mSoundsCount;
               }
               soundObject.channel = soundObject.sound.play(0,0,soundT);
               soundObject.stopped = false;
            }
            if(soundObject.channel != null)
            {
               if(soundObject.isTracklist)
               {
                  soundObject.channel.addEventListener(Event.SOUND_COMPLETE,this.onTracklistSoundCompleteHandler);
               }
               else if(soundObject.type == TYPE_SFX)
               {
                  soundObject.channel.addEventListener(Event.SOUND_COMPLETE,this.checkSoundEnd);
               }
            }
         }
         catch(error:Error)
         {
            FSDebug.debugTrace("SoundManager.playSound(): Error trying to play file " + name + " - Error: " + error.toString());
         }
      }
      
      public function resumeSound(param1:String, param2:Number = 0.5, param3:Number = 0, param4:int = 0) : void
      {
         var soundObject:Object = null;
         var name:String = param1;
         var volume:Number = param2;
         var startTime:Number = param3;
         var loops:int = param4;
         try
         {
            if(name == null || this.mSoundsDictionary == null)
            {
               return;
            }
            soundObject = this.mSoundsDictionary[name];
            if(soundObject == null)
            {
               return;
            }
            if(soundObject.type == TYPE_MUSIC)
            {
               if(!this.isMusicOn() || (Boolean(this.mLastMusic == name && !soundObject.paused) || Boolean(soundObject.stopped)))
               {
                  return;
               }
               this.mLastMusic = name;
            }
            if(soundObject.paused)
            {
               soundObject.channel = soundObject.sound.play(soundObject.position,soundObject.loops,new SoundTransform(this.calcOutputVolume(soundObject.volume,soundObject.type)));
               soundObject.paused = false;
               if(soundObject.isTracklist == true)
               {
                  soundObject.channel.addEventListener(Event.SOUND_COMPLETE,this.onTracklistSoundCompleteHandler);
               }
            }
         }
         catch(error:Error)
         {
            FSDebug.debugTrace("SoundManager.playSound(): Error trying to play file " + name);
         }
      }
      
      public function stopSound(param1:String) : void
      {
         var soundObject:Object = null;
         var name:String = param1;
         try
         {
            if(name == null || this.mSoundsDictionary == null || this.mSoundsDictionary[name] == null)
            {
               return;
            }
            soundObject = this.mSoundsDictionary[name];
            if(soundObject == null || soundObject.channel == null)
            {
               return;
            }
            if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
            {
               InstanceMng.getResourcesMng().stopAndroidSound(name);
               return;
            }
            soundObject.stopped = true;
            soundObject.channel.stop();
            if(soundObject.type == TYPE_SFX)
            {
               if(soundObject.channel != null)
               {
                  soundObject.channel.removeEventListener(Event.SOUND_COMPLETE,this.checkSoundEnd);
               }
               --this.mSoundsCount;
               if(this.mSoundsCount < 0)
               {
                  this.mSoundsCount = 0;
               }
            }
            else if(soundObject.channel != null)
            {
               soundObject.channel.removeEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
               soundObject.channel.removeEventListener(Event.SOUND_COMPLETE,this.onTracklistSoundCompleteHandler);
            }
            if(soundObject.channel != null)
            {
               soundObject.position = soundObject.channel.position;
            }
         }
         catch(e:Error)
         {
            FSDebug.debugTrace("CopyofSoundManager.stopSound(): Error trying to stop file " + name);
         }
      }
      
      public function pauseSound(param1:String) : void
      {
         var soundObject:Object = null;
         var name:String = param1;
         try
         {
            soundObject = this.mSoundsDictionary[name];
            if(soundObject != null && !soundObject.stopped)
            {
               soundObject.paused = true;
               soundObject.position = soundObject.channel.position;
               soundObject.channel.stop();
            }
            if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
            {
               InstanceMng.getResourcesMng().stopAndroidSound(name);
               return;
            }
         }
         catch(e:Error)
         {
            FSDebug.debugTrace("Error pausing sound: " + e.message);
         }
      }
      
      public function stopAll(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         if(this.mSounds != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mSounds.length)
            {
               if(!(param1 && this.mSounds[_loc3_].type == TYPE_SFX))
               {
                  if(!(param2 && this.mSounds[_loc3_].type == TYPE_MUSIC))
                  {
                     if(this.mSounds[_loc3_] != null)
                     {
                        this.stopSound(this.mSounds[_loc3_].name);
                     }
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function onVolumeChanged() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:SoundTransform = null;
         var _loc3_:int = 0;
         if(this.mSounds != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mSounds.length)
            {
               if(Boolean(this.mSounds[_loc3_] != null && this.mSounds[_loc3_].hasOwnProperty("type")) && Boolean(this.mSounds[_loc3_]["type"] != null) && Boolean(this.mSounds[_loc3_].hasOwnProperty("volume")))
               {
                  _loc1_ = this.calcOutputVolume(SOUND_INITIAL_VOLUME,this.mSounds[_loc3_]["type"]);
                  this.mSounds[_loc3_]["volume"] = _loc1_;
                  if(Boolean(this.mSounds[_loc3_].hasOwnProperty("channel") && this.mSounds[_loc3_]["channel"] != null && this.mSounds[_loc3_]["channel"].hasOwnProperty("soundTransform")) && Boolean(this.mSounds[_loc3_]["channel"]["soundTransform"] != null) && Boolean(this.mSounds[_loc3_]["channel"]["soundTransform"].hasOwnProperty("volume")))
                  {
                     this.mSounds[_loc3_]["channel"]["soundTransform"]["volume"] = _loc1_;
                     _loc2_ = SoundTransform(this.mSounds[_loc3_]["channel"]["soundTransform"]);
                     if(_loc2_ != null && _loc2_.hasOwnProperty("volume"))
                     {
                        _loc2_["volume"] = _loc1_;
                        this.mSounds[_loc3_]["channel"]["soundTransform"] = _loc2_;
                     }
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function playAll(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         if(this.mSounds != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mSounds.length)
            {
               if(!(param1 && this.mSounds[_loc3_].type == TYPE_SFX))
               {
                  if(!(param2 && this.mSounds[_loc3_].type == TYPE_MUSIC))
                  {
                     this.playSound(this.mSounds[_loc3_].name,this.mSounds[_loc3_].type);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function resumeAll() : void
      {
         var _loc1_:int = 0;
         if(this.mSounds != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mSounds.length)
            {
               if(this.mSounds[_loc1_].type == TYPE_MUSIC)
               {
                  this.resumeSound(this.mSounds[_loc1_].name);
               }
               _loc1_++;
            }
         }
      }
      
      public function pauseAll() : void
      {
         var _loc1_:int = 0;
         if(this.mSounds != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mSounds.length)
            {
               if(this.mSounds[_loc1_].type == TYPE_MUSIC)
               {
                  this.pauseSound(this.mSounds[_loc1_].name);
               }
               _loc1_++;
            }
         }
      }
      
      public function isMusicOn() : Boolean
      {
         if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
         {
            return false;
         }
         return this.mMusicOn;
      }
      
      public function isSfxOn() : Boolean
      {
         return this.mSfxOn;
      }
      
      public function setMusicOn(param1:Boolean) : void
      {
         if(Utils.isAndroid() && Config.STORE_AUDIO_PATHS)
         {
            param1 = false;
         }
         if(this.mMusicOn != param1)
         {
            this.mMusicOn = param1;
            if(!this.mMusicOn)
            {
               FSDebug.debugTrace("Setting music OFF");
               this.pauseAll();
            }
            else
            {
               FSDebug.debugTrace("Setting music ON");
               if(Config.smTracklistModeOn && this.mTrackListCurrIndex == -1 && this.mTrackList == null)
               {
                  this.addTrackList(InstanceMng.getResourcesMng().getSoundTrack());
                  this.loadNextTrack();
               }
               this.resumeAll();
            }
         }
      }
      
      public function setSfxOn(param1:Boolean) : void
      {
         if(this.mSfxOn != param1)
         {
            this.mSfxOn = param1;
            if(!this.mSfxOn)
            {
               FSDebug.debugTrace("Setting SFX OFF");
               this.stopAll(false,true);
            }
            else
            {
               FSDebug.debugTrace("Setting SFX ON");
            }
         }
      }
      
      public function getLastMusic() : String
      {
         return this.mLastMusic;
      }
      
      public function checkSoundEnd(param1:Event) : void
      {
         var _loc2_:Object = param1.target;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.SOUND_COMPLETE,this.checkSoundEnd);
         }
         --this.mSoundsCount;
         if(this.mSoundsCount < 0)
         {
            this.mSoundsCount = 0;
         }
         this.printSounds();
      }
      
      private function printSounds() : void
      {
      }
      
      public function calcOutputVolume(param1:Number, param2:int) : Number
      {
         var _loc3_:Number = param1 * this.mGeneralVolume;
         var _loc4_:UserData = Utils.getOwnerUserData();
         var _loc5_:Number = _loc4_ ? _loc4_.flagsGetMusicVolume() : -1;
         var _loc6_:Number = _loc4_ ? _loc4_.flagsGetSoundVolume() : -1;
         switch(param2)
         {
            case TYPE_MUSIC:
               _loc3_ = _loc3_ == 0 ? 0 : this.mMusicVolume;
               _loc3_ *= _loc5_ != -1 ? _loc5_ : 1;
               break;
            case TYPE_SFX:
               _loc3_ *= this.mSfxVolume;
               _loc3_ *= _loc6_ != -1 ? _loc6_ : 1;
         }
         return _loc3_;
      }
   }
}

