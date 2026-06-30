package com.fs.tcgengine.view.raids
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.misc.FSPlayerConnectivityVisor;
   import starling.core.Starling;
   
   public class FSUserPlayedRaidSlot extends Component
   {
      
      private var mRaidBattleInfo:Object;
      
      private var mPlayerRanking:int;
      
      private var mRaidSku:String;
      
      private var mDifficulty:int;
      
      private var mBG:CustomComponent;
      
      private var mRaidImage:FSImage;
      
      private var mNameTextfield:FSTextfield;
      
      private var mRaidPointsTextfield:FSTextfield;
      
      private var mDamageDoneTextfield:FSTextfield;
      
      private var mUserData:UserData;
      
      private var mIsRaidComplete:Boolean;
      
      private var mPlayerConnectivityVisor:FSPlayerConnectivityVisor;
      
      private var mIsPlayerLeftGuild:Boolean;
      
      private var mPositionTextfield:FSTextfield;
      
      private var mDamage:int = this.mRaidBattleInfo.damage;
      
      public function FSUserPlayedRaidSlot(param1:Object, param2:int, param3:String, param4:int, param5:UserData, param6:Boolean = false, param7:Boolean = false)
      {
         this.mRaidBattleInfo = param1;
         this.mPlayerRanking = param2;
         this.mRaidSku = param3;
         this.mDifficulty = param4;
         this.mUserData = param5;
         this.mIsRaidComplete = param6;
         this.mIsPlayerLeftGuild = param7;
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this.createBG();
         this.createRaidImage();
         this.createRaidPosition();
         this.createNameTextfield();
         this.createDamageDoneTextfield();
         if(this.mIsRaidComplete)
         {
            this.setNameTextfieldNewPosition();
            this.setDamageDoneTextfieldNewPosition();
            this.createRaidPointsTextfield();
         }
      }
      
      private function createRaidPosition() : void
      {
         if(Boolean(this.mRaidImage) && this.mPositionTextfield == null)
         {
            this.mPositionTextfield = new FSTextfield(this.mRaidImage.width * 0.85,this.mRaidImage.height * 0.85,this.mPlayerRanking.toString());
            this.mPositionTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mPositionTextfield.alignPivot();
            this.mPositionTextfield.x = this.mRaidImage.x;
            this.mPositionTextfield.y = this.mRaidImage.y;
            addChild(this.mPositionTextfield);
         }
      }
      
      private function setDamageDoneTextfieldNewPosition() : void
      {
         if(this.mDamageDoneTextfield)
         {
            this.mDamageDoneTextfield.x = this.mBG.width / 4 * 2 + this.mDamageDoneTextfield.width / 4;
         }
      }
      
      private function setNameTextfieldNewPosition() : void
      {
         if(this.mNameTextfield)
         {
            this.mNameTextfield.x = this.mBG.width / 4;
         }
      }
      
      private function createDamageDoneTextfield() : void
      {
         if(Boolean(this.mRaidImage) && Boolean(this.mNameTextfield) && this.mDamageDoneTextfield == null)
         {
            this.mDamageDoneTextfield = new FSTextfield(Starling.current.stage.stageWidth * 0.1,Starling.current.stage.stageHeight * 0.1,this.mDamage.toString());
            this.mDamageDoneTextfield.x = this.mBG.width / 3 * 2 + this.mDamageDoneTextfield.width / 4;
            this.mDamageDoneTextfield.y = this.mRaidImage.y - this.mNameTextfield.height * 0.5;
            addChild(this.mDamageDoneTextfield);
         }
      }
      
      private function createRaidPointsTextfield() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mRaidImage) && Boolean(this.mNameTextfield) && this.mRaidPointsTextfield == null)
         {
            _loc1_ = InstanceMng.getRaidsMng().getRaidPointsByPlayerRanking(this.mRaidSku,this.mDifficulty,this.mPlayerRanking);
            this.mRaidPointsTextfield = new FSTextfield(Starling.current.stage.stageWidth * 0.07,Starling.current.stage.stageHeight * 0.1,_loc1_.toString());
            this.mRaidPointsTextfield.x = this.mBG.width / 4 * 3 + this.mRaidPointsTextfield.width / 2;
            this.mRaidPointsTextfield.y = this.mRaidImage.y - this.mDamageDoneTextfield.height * 0.5;
            addChild(this.mRaidPointsTextfield);
         }
      }
      
      private function createNameTextfield() : void
      {
         var _loc1_:String = null;
         if(this.mNameTextfield == null)
         {
            if(Boolean(this.mUserData) && this.mUserData.getAccountId() == InstanceMng.getServerConnection().getUserId())
            {
               _loc1_ = TextManager.getText("TID_SOCIAL_ME");
            }
            else if(this.mIsPlayerLeftGuild)
            {
               _loc1_ = this.mRaidBattleInfo.currentNick;
            }
            else if(this.mUserData)
            {
               _loc1_ = this.mUserData.getName();
            }
            this.mNameTextfield = new FSTextfield(Starling.current.stage.stageWidth * 0.1,Starling.current.stage.stageHeight * 0.1,_loc1_);
            this.mNameTextfield.x = this.mBG.width / 3;
            this.mNameTextfield.y = this.mRaidImage.y - this.mNameTextfield.height * 0.5;
            addChild(this.mNameTextfield);
         }
      }
      
      private function createRaidImage() : void
      {
         if(this.mRaidImage == null)
         {
            if(this.mPlayerRanking < 4 && this.mPlayerRanking > 0)
            {
               this.mRaidImage = new FSImage(Root.assets.getTexture("raid_ranking_" + this.mPlayerRanking.toString()));
            }
            else
            {
               this.mRaidImage = new FSImage(Root.assets.getTexture("raid_ranking_4"));
            }
            this.mRaidImage.alignPivot();
            this.mRaidImage.x = this.mBG.x + this.mRaidImage.width * 0.5;
            this.mRaidImage.y = this.mBG.y + this.mRaidImage.height * 0.6;
            addChild(this.mRaidImage);
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null)
         {
            _loc1_ = Boolean(this.mUserData) && this.mUserData.getAccountId() == InstanceMng.getServerConnection().getUserId() ? "dungeon_layer_ranking_me" : "dungeon_layer_1";
            this.mBG = Utils.createCustomBox(_loc1_,1070);
            addChild(this.mBG);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mRaidImage)
         {
            this.mRaidImage.removeFromParent(true);
            this.mRaidImage = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mRaidPointsTextfield)
         {
            this.mRaidPointsTextfield.removeFromParent(true);
            this.mRaidPointsTextfield = null;
         }
         if(this.mPlayerConnectivityVisor)
         {
            this.mPlayerConnectivityVisor.removeFromParent(true);
            this.mPlayerConnectivityVisor = null;
         }
         if(this.mDamageDoneTextfield)
         {
            this.mDamageDoneTextfield.removeFromParent(true);
            this.mDamageDoneTextfield = null;
         }
         if(this.mPositionTextfield)
         {
            this.mPositionTextfield.removeFromParent(true);
            this.mPositionTextfield = null;
         }
         this.mRaidBattleInfo = null;
         this.mUserData = null;
      }
      
      public function getUserData() : UserData
      {
         return this.mUserData;
      }
      
      public function updateDamage(param1:int) : void
      {
         if(this.mDamageDoneTextfield)
         {
            if(this.mDamageDoneTextfield.text != param1.toString())
            {
               SpecialFX.createTextfieldAmountTransition(this.mDamageDoneTextfield,param1,1,true);
            }
         }
      }
      
      public function increaseDamage(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.mDamageDoneTextfield)
         {
            this.mDamage += param1;
            _loc2_ = int(this.mDamageDoneTextfield.text) + param1;
            SpecialFX.createTextfieldAmountTransition(this.mDamageDoneTextfield,_loc2_,1,true);
         }
      }
      
      public function getName() : String
      {
         return this.mNameTextfield.text;
      }
      
      public function getDamage() : int
      {
         return this.mDamage;
      }
      
      public function updateRankPosition(param1:int) : void
      {
         if(Boolean(this.mPositionTextfield) && Boolean(this.mRaidImage))
         {
            this.mPositionTextfield.text = (param1 + 1).toString();
            if(param1 + 1 < 4)
            {
               this.mRaidImage.texture = Root.assets.getTexture("raid_ranking_" + (param1 + 1).toString());
            }
            else
            {
               this.mRaidImage.texture = Root.assets.getTexture("raid_ranking_4");
            }
         }
      }
   }
}

