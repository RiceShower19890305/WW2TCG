package feathers.media
{
   import feathers.controls.Slider;
   import feathers.events.MediaPlayerEventType;
   import feathers.skins.IStyleProvider;
   import flash.media.SoundTransform;
   import starling.events.Event;
   
   public class VolumeSlider extends Slider implements IMediaPlayerControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-volume-slider-minimum-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-volume-slider-maximum-track";
      
      public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-volume-slider-thumb";
      
      protected var _ignoreChanges:Boolean = false;
      
      protected var _mediaPlayer:IAudioPlayer;
      
      public function VolumeSlider()
      {
         super();
         this.thumbStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB;
         this.minimumTrackStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK;
         this.maximumTrackStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK;
         this.minimum = 0;
         this.maximum = 1;
         this.addEventListener(Event.CHANGE,this.volumeSlider_changeHandler);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return VolumeSlider.globalStyleProvider;
      }
      
      public function get mediaPlayer() : IMediaPlayer
      {
         return this._mediaPlayer;
      }
      
      public function set mediaPlayer(param1:IMediaPlayer) : void
      {
         if(this._mediaPlayer == param1)
         {
            return;
         }
         this._mediaPlayer = param1 as IAudioPlayer;
         this.refreshVolumeFromMediaPlayer();
         if(this._mediaPlayer)
         {
            this._mediaPlayer.addEventListener(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE,this.mediaPlayer_soundTransformChangeHandler);
         }
         this.invalidate(INVALIDATION_FLAG_DATA);
      }
      
      protected function refreshVolumeFromMediaPlayer() : void
      {
         var _loc1_:Boolean = this._ignoreChanges;
         this._ignoreChanges = true;
         if(this._mediaPlayer)
         {
            this.value = this._mediaPlayer.soundTransform.volume;
         }
         else
         {
            this.value = 0;
         }
         this._ignoreChanges = _loc1_;
      }
      
      protected function mediaPlayer_soundTransformChangeHandler(param1:Event) : void
      {
         this.refreshVolumeFromMediaPlayer();
      }
      
      protected function volumeSlider_changeHandler(param1:Event) : void
      {
         if(!this._mediaPlayer || this._ignoreChanges)
         {
            return;
         }
         var _loc2_:SoundTransform = this._mediaPlayer.soundTransform;
         _loc2_.volume = this._value;
         this._mediaPlayer.soundTransform = _loc2_;
      }
   }
}

