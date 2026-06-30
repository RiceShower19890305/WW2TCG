package com.fs.tcgengine.view.components.popups.player
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.events.TouchEvent;
   import starling.textures.Texture;
   
   public class PortraitViewer extends Component implements FSModelUnloadableInterface
   {
      
      private var mBG:FSImage;
      
      private var mPortraitFrame:FSImage;
      
      private var mPortraitDef:PortraitDef;
      
      private var mCustomPortraitFrameName:String;
      
      private var mCustomBGName:String;
      
      private var mOnTouchTriggerFunction:Function;
      
      private var mAvailable:Boolean;
      
      private var mUserImage:FSImage;
      
      private var mShowUserPic:Boolean = false;
      
      private var mCustomHeroDef:HeroCharacterDef;
      
      private var mIsOwnerPortrait:Boolean;
      
      private var mCustomBGScale:Number;
      
      public function PortraitViewer(param1:PortraitDef, param2:String = null, param3:String = null, param4:Function = null, param5:Boolean = false, param6:HeroCharacterDef = null, param7:Boolean = true, param8:Number = 1)
      {
         this.mPortraitDef = param1;
         this.mCustomPortraitFrameName = param2;
         this.mCustomBGName = param3;
         this.mOnTouchTriggerFunction = param4;
         this.mShowUserPic = param5;
         this.mCustomHeroDef = param6;
         this.mIsOwnerPortrait = param7;
         this.mCustomBGScale = param8;
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createPortraitFrame();
         if(this.mShowUserPic)
         {
            this.createUserPortrait();
         }
         if(this.mOnTouchTriggerFunction != null)
         {
            addEventListener(TouchEvent.TOUCH,this.mOnTouchTriggerFunction);
         }
      }
      
      public function getPortraitDef() : PortraitDef
      {
         return this.mPortraitDef;
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null)
         {
            _loc1_ = this.mCustomBGName ? this.mCustomBGName : "mini_square_socket";
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
            if(_loc1_ == "mini_square_socket")
            {
               Utils.setupImage9Scale(this.mBG,9,9,1,1,57.25,57.25);
            }
            else
            {
               this.mBG.scale = this.mCustomBGScale;
            }
            addChild(this.mBG);
         }
      }
      
      private function createPortraitFrame() : void
      {
         var _loc1_:String = Config.getConfig().hasPortraits() && Boolean(this.mPortraitDef) ? this.mPortraitDef.getBGImageName() : FSBattlefieldUserPortrait.FRAME_BG_NAME;
         _loc1_ = this.mCustomPortraitFrameName != null ? this.mCustomPortraitFrameName : _loc1_;
         if(this.mPortraitFrame == null)
         {
            this.mPortraitFrame = new FSImage(Root.assets.getTexture(_loc1_));
         }
         else
         {
            this.mPortraitFrame.texture = Root.assets.getTexture(_loc1_);
         }
         this.mPortraitFrame.alignPivot();
         this.mPortraitFrame.scale = 0.935;
         this.mPortraitFrame.x = this.mBG.width / 2;
         this.mPortraitFrame.y = this.mBG.height / 2;
         addChild(this.mPortraitFrame);
      }
      
      public function getPortraitFrame() : FSImage
      {
         return this.mPortraitFrame;
      }
      
      public function updatePortraitDef(param1:PortraitDef) : void
      {
         this.mPortraitDef = param1;
         this.createPortraitFrame();
      }
      
      public function createUserPortrait() : void
      {
         var _loc1_:UserData = null;
         var _loc2_:String = null;
         if(this.mCustomHeroDef == null)
         {
            _loc1_ = this.mIsOwnerPortrait ? InstanceMng.getUserDataMng().getOwnerUserData() : InstanceMng.getBattleEngine().getOpponentBattleInfo().getUserData();
            if(_loc1_ != null)
            {
               this.mUserImage = _loc1_.getPhoto();
               _loc2_ = _loc1_ ? _loc1_.getExtId() : "sample";
               if(_loc1_.getPhotoTexture() == null)
               {
                  Utils.loadProfilePicture(_loc2_,this.onProfilePicLoaded);
               }
               else if(this.mUserImage)
               {
                  this.mUserImage.texture = _loc1_.getPhotoTexture();
               }
            }
         }
         else
         {
            this.mUserImage = new FSImage(Root.assets.getTexture(this.mCustomHeroDef.getBGImageName()));
         }
         if(this.mUserImage != null)
         {
            this.mUserImage.alignPivot();
            this.mUserImage.x = this.mPortraitFrame.x;
            this.mUserImage.y = this.mPortraitFrame.y;
            addChildAt(this.mUserImage,0);
         }
      }
      
      private function onProfilePicLoaded(param1:Texture) : void
      {
         if(this.mUserImage)
         {
            this.mUserImage.removeFromParent();
            this.mUserImage.texture = param1;
            addChild(this.mUserImage);
         }
      }
      
      public function setAvailable(param1:Boolean) : void
      {
         this.mAvailable = param1;
         alpha = this.mAvailable ? 1 : 0.2;
      }
      
      public function isAvailable() : Boolean
      {
         return this.mAvailable;
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mPortraitFrame)
         {
            this.mPortraitFrame.removeFromParent();
            this.mPortraitFrame.destroy();
            this.mPortraitFrame = null;
         }
         if(this.mUserImage)
         {
            this.mUserImage.removeFromParent();
            this.mUserImage = null;
         }
         this.mPortraitDef = null;
         this.mCustomHeroDef = null;
         this.mOnTouchTriggerFunction = null;
         removeEventListener(TouchEvent.TOUCH,this.mOnTouchTriggerFunction);
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mPortraitFrame)
         {
            this.mPortraitFrame.removeFromParent();
            this.mPortraitFrame.destroy();
            this.mPortraitFrame = null;
         }
         if(this.mUserImage)
         {
            this.mUserImage.removeFromParent();
            this.mUserImage.destroy();
            this.mUserImage = null;
         }
         removeEventListener(TouchEvent.TOUCH,this.mOnTouchTriggerFunction);
      }
   }
}

