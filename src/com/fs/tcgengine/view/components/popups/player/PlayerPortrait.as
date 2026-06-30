package com.fs.tcgengine.view.components.popups.player
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSLoadingComponentMini;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.textures.Texture;
   
   public class PlayerPortrait extends Component
   {
      
      public static const SOCIAL_FRAME_IMAGE_NAME:String = "portrait_frame";
      
      public static const SOCIAL_FRAME_OWNER_IMAGE_NAME:String = "portrait_frame_self";
      
      public static const FACEBOOK_PIC_SUFFIX:String = "/picture?width=64&height=64";
      
      public static const FACEBOOK_SAMPLE_PIC:String = "fb_sample";
      
      protected var mExtId:String;
      
      protected var mProfilePic:FSImage;
      
      protected var mProfileFramePic:FSImage;
      
      protected var mIsOwner:Boolean;
      
      private var mLoadingAnim:FSLoadingComponentMini;
      
      public function PlayerPortrait(param1:String = "", param2:Boolean = false)
      {
         this.mIsOwner = param2;
         this.updateExtId(param1);
         super();
         this.init();
         touchable = false;
      }
      
      private function updateExtId(param1:String) : void
      {
         this.mExtId = param1;
      }
      
      private function init() : void
      {
         this.createFrame();
         var _loc1_:UserDataMng = InstanceMng.getUserDataMng();
         var _loc2_:UserData = this.mIsOwner ? _loc1_.getOwnerUserData() : _loc1_.getFriendUserDataByExtId(this.mExtId);
         if(_loc2_ != null && _loc2_.getPhotoTexture() != null)
         {
            this.createProfilePic(_loc2_.getPhotoTexture());
         }
         else
         {
            this.createDefaultProfilePic();
         }
      }
      
      public function updateInfo(param1:String) : void
      {
         this.updateExtId(param1);
         this.loadProfilePicture();
      }
      
      private function showLoadingPicAnim(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.mLoadingAnim == null)
            {
               this.mLoadingAnim = new FSLoadingComponentMini();
               this.mLoadingAnim.x = width / 2;
               this.mLoadingAnim.y = height / 2;
               addChild(this.mLoadingAnim);
            }
            else
            {
               this.mLoadingAnim.x = width / 2;
               this.mLoadingAnim.y = height / 2;
               addChild(this.mLoadingAnim);
            }
         }
         else if(this.mLoadingAnim)
         {
            this.mLoadingAnim.removeFromParent();
            this.mLoadingAnim = null;
         }
      }
      
      public function loadProfilePicture() : void
      {
         var _loc1_:UserDataMng = InstanceMng.getUserDataMng();
         var _loc2_:UserData = this.mIsOwner ? _loc1_.getOwnerUserData() : _loc1_.getFriendUserDataByExtId(this.mExtId);
         if(_loc2_ == null || _loc2_ != null && _loc2_.getPhotoTexture() == null && _loc2_.getExtId() != "sample" && _loc2_.getExtId() != null)
         {
            this.showLoadingPicAnim(true);
            Utils.loadProfilePicture(this.mExtId,this.onProfilePicLoaded);
         }
         else if(_loc2_ != null && _loc2_.getPhotoTexture() != null)
         {
            this.createProfilePic(_loc2_.getPhotoTexture());
         }
      }
      
      private function onProfilePicLoaded(param1:Texture) : void
      {
         var _loc2_:UserDataMng = InstanceMng.getUserDataMng();
         var _loc3_:UserData = this.mIsOwner ? _loc2_.getOwnerUserData() : _loc2_.getFriendUserDataByExtId(this.mExtId);
         if(Boolean(_loc3_) && !_loc3_.flagsShowDefaultAvatar())
         {
            _loc3_.setPhotoTexture(param1);
         }
         this.createProfilePic(param1);
         this.showLoadingPicAnim(false);
      }
      
      protected function createDefaultProfilePic() : void
      {
         if(this.mProfilePic == null)
         {
            this.mProfilePic = new FSImage(Root.assets.getTexture(FACEBOOK_SAMPLE_PIC));
            this.mProfilePic.width = this.mProfileFramePic.width * 0.8;
            this.mProfilePic.height = this.mProfileFramePic.height * 0.8;
            this.mProfilePic.x = (this.mProfileFramePic.width - this.mProfilePic.width) / 2;
            this.mProfilePic.y = (this.mProfileFramePic.height - this.mProfilePic.height) / 2;
            addChildAt(this.mProfilePic,0);
         }
      }
      
      protected function createFrame() : void
      {
         var _loc1_:String = null;
         if(this.mProfileFramePic == null)
         {
            _loc1_ = this.mIsOwner ? SOCIAL_FRAME_OWNER_IMAGE_NAME : SOCIAL_FRAME_IMAGE_NAME;
            this.mProfileFramePic = new FSImage(Root.assets.getTexture(_loc1_));
            addChild(this.mProfileFramePic);
         }
      }
      
      protected function createProfilePic(param1:Texture) : void
      {
         var _loc2_:int = 0;
         if(param1 != null && this.mProfilePic == null && this.mProfileFramePic != null)
         {
            this.mProfilePic = new FSImage(param1);
            this.mProfilePic.width = this.mProfileFramePic.width * 0.8;
            this.mProfilePic.height = this.mProfileFramePic.height * 0.8;
            this.mProfilePic.x = (this.mProfileFramePic.width - this.mProfilePic.width) / 2;
            this.mProfilePic.y = (this.mProfileFramePic.height - this.mProfilePic.height) / 2;
         }
         else if(this.mProfilePic)
         {
            this.mProfilePic.texture = param1;
         }
         if(this.mProfilePic)
         {
            _loc2_ = this.mProfileFramePic != null ? getChildIndex(this.mProfileFramePic) : 0;
            _loc2_ = _loc2_ > 0 ? int(_loc2_ - 1) : 0;
            addChildAt(this.mProfilePic,_loc2_);
         }
      }
      
      public function getExtIdAssociated() : String
      {
         return this.mExtId;
      }
      
      override public function dispose() : void
      {
         if(this.mProfilePic)
         {
            this.mProfilePic.removeFromParent();
            this.mProfilePic = null;
         }
         if(this.mProfileFramePic)
         {
            this.mProfileFramePic.removeFromParent(true);
            this.mProfileFramePic = null;
         }
         super.dispose();
      }
   }
}

