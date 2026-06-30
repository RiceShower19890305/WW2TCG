package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.textures.Texture;
   
   public class GuildEmblem extends Component implements FSModelUnloadableInterface
   {
      
      private var mBG:FSImage;
      
      private var mFG:FSImage;
      
      private var mSocket:FSImage;
      
      private var mBGName:String;
      
      private var mFGName:String;
      
      private var mSocketName:String;
      
      public function GuildEmblem(param1:String, param2:String, param3:String = "")
      {
         super();
         this.mBGName = param1;
         this.mFGName = param2;
         this.mSocketName = param3;
         this.createUI();
      }
      
      private function createUI() : void
      {
         if(this.mBG == null && this.mBGName != "")
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.mBGName));
            this.mBG.alignPivot();
            addChild(this.mBG);
         }
         if(this.mFG == null && this.mFGName != "")
         {
            this.mFG = new FSImage(Root.assets.getTexture(this.mFGName));
            this.mFG.alignPivot();
            addChild(this.mFG);
         }
         if(this.mSocketName != "")
         {
            if(this.mSocket == null)
            {
               this.mSocket = new FSImage(Root.assets.getTexture(this.mSocketName));
               if(this.mSocketName == "mini_square_socket_highlight" || this.mSocketName == "mini_square_socket")
               {
                  Utils.setupImage9Scale(this.mSocket,9,9,1,1,57.25,57.25);
               }
               this.mSocket.alignPivot();
               addChild(this.mSocket);
            }
         }
         var _loc1_:int = this.mBG ? int(this.mBG.width) : 0;
         var _loc2_:int = this.mFG ? int(this.mFG.width) : 0;
         var _loc3_:int = this.mSocket ? int(this.mSocket.width) : 0;
         var _loc4_:int = Math.max(_loc1_,_loc2_);
         _loc4_ = Math.max(_loc4_,_loc3_);
         if(this.mBG)
         {
            this.mBG.x = _loc4_ / 2;
            this.mBG.y = _loc4_ / 2;
         }
         if(this.mFG)
         {
            this.mFG.x = _loc4_ / 2;
            this.mFG.y = _loc4_ / 2;
         }
         if(this.mSocket)
         {
            this.mSocket.x = _loc4_ / 2;
            this.mSocket.y = _loc4_ / 2;
         }
      }
      
      public function changeSocketTexture(param1:Texture) : void
      {
         if(Boolean(this.mSocket) && Boolean(param1))
         {
            this.mSocket.texture = param1;
         }
      }
      
      public function changeBGTexture(param1:Texture) : void
      {
         if(Boolean(this.mBG) && Boolean(param1))
         {
            this.mBG.texture = param1;
         }
      }
      
      public function changeFGTexture(param1:Texture) : void
      {
         if(Boolean(this.mFG) && Boolean(param1))
         {
            this.mFG.texture = param1;
         }
      }
      
      public function getBGTexture() : Texture
      {
         return this.mBG ? this.mBG.texture : null;
      }
      
      public function getFGTexture() : Texture
      {
         return this.mFG ? this.mFG.texture : null;
      }
      
      public function getSocketTexture() : Texture
      {
         return this.mSocket ? this.mSocket.texture : null;
      }
      
      public function getBGName() : String
      {
         return this.mBGName;
      }
      
      public function getFGName() : String
      {
         return this.mFGName;
      }
      
      override public function dispose() : void
      {
         this.destroy();
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
         if(this.mFG)
         {
            this.mFG.removeFromParent();
            this.mFG.destroy();
            this.mFG = null;
         }
         if(this.mSocket)
         {
            this.mSocket.removeFromParent();
            this.mSocket.destroy();
            this.mSocket = null;
         }
      }
   }
}

