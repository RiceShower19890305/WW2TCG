package com.fs.tcgengine.view.map
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.FSFacebookPlugin;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.FSSprite3D;
   import com.fs.tcgengine.view.components.popups.player.PlayerPortrait;
   import com.fs.tcgengine.view.misc.FSImage;
   import flash.geom.Vector3D;
   import starling.textures.Texture;
   
   public class MapPlayerPortrait extends FSSprite3D
   {
      
      public static const FACEBOOK_SAMPLE_PIC:String = FSFacebookPlugin.FACEBOOK_GRAPH_PREFIX + "sample" + PlayerPortrait.FACEBOOK_PIC_SUFFIX;
      
      public static const PROFILE_PIC_FRAME_NAME:String = "portrait_frame_map";
      
      public static const PROFILE_OWNER_PIC_FRAME_NAME:String = "portrait_frame_map_owner";
      
      private var mURLPic:String;
      
      private var mPicMesh:FSImage;
      
      private var mPicFrameMesh:FSImage;
      
      private var mExtId:String;
      
      private var mIsOwner:Boolean;
      
      private var mIsDefaultImg:Boolean;
      
      public function MapPlayerPortrait(param1:String = "", param2:String = "", param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this.mIsDefaultImg = param4;
         if(Boolean(InstanceMng.getFacebookPlugin()) && Boolean(!InstanceMng.getApplication().isKongregateVersion()) && !Utils.isDesktop())
         {
            this.mURLPic = param1 != "" ? param1 : FACEBOOK_SAMPLE_PIC;
         }
         else
         {
            this.mURLPic = param1 != "" ? param1 : "";
         }
         this.mExtId = param2;
         this.mIsOwner = param3;
         this.init();
         alignPivot();
         touchable = false;
         rotate(new Vector3D(1,0,0),15);
      }
      
      private function init() : void
      {
         var _loc1_:String = this.mIsOwner ? PROFILE_OWNER_PIC_FRAME_NAME : PROFILE_PIC_FRAME_NAME;
         this.mPicFrameMesh = new FSImage(Root.assets.getTexture(_loc1_));
         var _loc2_:UserDataMng = InstanceMng.getUserDataMng();
         var _loc3_:UserData = this.mIsOwner ? _loc2_.getOwnerUserData() : _loc2_.getFriendUserDataByExtId(this.mExtId);
         if(_loc3_ != null && _loc3_.getPhotoTexture() != null)
         {
            this.createProfilePic(_loc3_.getPhotoTexture());
         }
         else
         {
            Utils.loadProfilePicture(this.mExtId,this.onProfilePicLoaded);
         }
      }
      
      private function onProfilePicLoaded(param1:Texture) : void
      {
         var _loc2_:UserDataMng = InstanceMng.getUserDataMng();
         var _loc3_:UserData = this.mIsOwner ? _loc2_.getOwnerUserData() : _loc2_.getFriendUserDataByExtId(this.mExtId);
         if(_loc3_)
         {
            _loc3_.setPhotoTexture(param1);
         }
         this.createProfilePic(param1);
      }
      
      private function createProfilePic(param1:Texture) : void
      {
         this.mPicMesh = new FSImage(param1);
         addChild(this.mPicMesh);
         if(this.mPicFrameMesh)
         {
            addChild(this.mPicFrameMesh);
            this.mPicMesh.width = this.mPicFrameMesh.width * 0.915;
            this.mPicMesh.height = this.mPicFrameMesh.height * 0.915;
            this.mPicMesh.x = (this.mPicFrameMesh.width - this.mPicMesh.width) / 2;
            this.mPicMesh.y = (this.mPicFrameMesh.height - this.mPicMesh.height) / 2;
         }
         if(parent)
         {
            parent.addChild(this);
         }
      }
      
      public function getPicFrameMesh() : FSImage
      {
         return this.mPicFrameMesh;
      }
      
      override public function dispose() : void
      {
         if(this.mPicMesh)
         {
            this.mPicMesh.removeFromParent();
            this.mPicMesh = null;
         }
         if(this.mPicFrameMesh)
         {
            this.mPicFrameMesh.removeFromParent(true);
            this.mPicFrameMesh = null;
         }
         super.dispose();
      }
   }
}

