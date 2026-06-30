package com.fs.tcgengine.view.board
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.JobDef;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.model.userdata.UserBattleInfo;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.components.popups.player.PortraitViewer;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.easing.Sine;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class BattleIntroCharacter extends Component implements FSModelUnloadableInterface
   {
      
      private var mIsOwner:Boolean;
      
      private var mName:String;
      
      private var mNameTextfield:FSTextfield;
      
      private var mBG:FSImage;
      
      private var mChar:FSImage;
      
      private var mPortrait:PortraitViewer;
      
      private var mCharTextureRef:Texture;
      
      private var mExtraInfoComponent:Component;
      
      private var mJobDef:JobDef;
      
      private var mExtraTextfield:FSTextfield;
      
      private var mExtraImage:FSImage;
      
      private var mBGAnimBar1:FSImage;
      
      protected var mBGAnimBar3:FSImage;
      
      public function BattleIntroCharacter(param1:Boolean, param2:String, param3:Texture = null, param4:JobDef = null)
      {
         super();
         this.mIsOwner = param1;
         this.mName = param2;
         this.mCharTextureRef = param3;
         this.mJobDef = param4;
         this.createUI();
         this.startBarAnims();
      }
      
      private function createUI() : void
      {
         this.createChar();
         this.createBG();
         this.createClassImage();
         this.createClassTextfield();
         this.createTextfield();
         this.createAnimBars();
         alignPivot();
         touchable = false;
      }
      
      private function createAnimBars() : void
      {
         var _loc1_:String = null;
         if(Config.getConfig().battleIntroShowGlowBG())
         {
            _loc1_ = this.mIsOwner ? "victory_animation" : "battle_start_red_light";
            if(this.mBGAnimBar1 == null)
            {
               this.mBGAnimBar1 = new FSImage(Root.assets.getTexture(_loc1_));
               this.mBGAnimBar1.scale = 4;
               this.mBGAnimBar1.pivotX = 0;
               this.mBGAnimBar1.pivotY = this.mBGAnimBar1.height;
               this.mBGAnimBar1.x = this.mBG.x + this.mBG.width / 2 - this.mBGAnimBar1.width;
               this.mBGAnimBar1.y = this.mNameTextfield ? this.mNameTextfield.y : 0;
            }
            if(this.mBGAnimBar3 == null)
            {
               this.mBGAnimBar3 = new FSImage(Root.assets.getTexture(_loc1_));
               this.mBGAnimBar3.scaleX = -1;
               this.mBGAnimBar3.pivotX = 0;
               this.mBGAnimBar3.pivotY = this.mBGAnimBar3.height;
               this.mBGAnimBar3.x = this.mBG.x - this.mBG.width / 2 + this.mBGAnimBar3.width;
               this.mBGAnimBar3.y = this.mBGAnimBar1.y;
            }
         }
      }
      
      private function createChar() : void
      {
         var _loc1_:* = undefined;
         if(this.mChar == null)
         {
            this.mChar = new FSImage(this.mCharTextureRef);
         }
         _loc1_ = this.mChar;
         if(Config.getConfig().battleIntroLevitate())
         {
            SpecialFX.createYoYoTransition(this.mChar,new FSCoordinate(_loc1_.x,_loc1_.y - 20),2,-1,null,Sine.easeInOut);
         }
         if(_loc1_)
         {
            _loc1_.alignPivot();
            addChild(_loc1_);
         }
      }
      
      private function getUserBattleInfo() : UserBattleInfo
      {
         return this.mIsOwner ? InstanceMng.getBattleEngine().getOwnerBattleInfo() : InstanceMng.getBattleEngine().getOpponentBattleInfo();
      }
      
      private function createBG() : void
      {
         var _loc1_:String = this.mIsOwner ? "battle_start_player_1" : "battle_start_player_2";
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
         }
         this.mBG.alignPivot();
         if(this.mChar)
         {
            this.mBG.x = this.mChar.x;
            this.mBG.y = this.mChar.y + this.mChar.height / 2;
         }
         else
         {
            this.mBG.x = this.mPortrait.x;
            this.mBG.y = this.mPortrait.y + this.mPortrait.height;
         }
         addChild(this.mBG);
      }
      
      private function getUserRankDef() : RankDef
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:HeroCharacterDef = null;
         var _loc7_:Boolean = false;
         var _loc1_:UserBattleInfo = this.getUserBattleInfo();
         var _loc2_:UserData = _loc1_.getUserBattlePortrait().getUserData();
         var _loc3_:RankDef = null;
         if(Config.getConfig().gameHasRanks() && Boolean(_loc2_))
         {
            _loc4_ = InstanceMng.getBattleEngine().getLevelDef().getMapWorldParentIndex();
            _loc5_ = InstanceMng.getUserDataMng().getOwnerUserData().getMapWorldChoice(_loc5_);
            _loc6_ = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(InstanceMng.getBattleEngine().getLevelDef().getEnemyHeroSku(_loc5_)));
            _loc7_ = Boolean(InstanceMng.getBattleEngine()) && InstanceMng.getBattleEngine().isPvPMatch();
            if(!this.mIsOwner)
            {
               if(_loc7_)
               {
                  _loc3_ = _loc2_.getRankDef();
               }
               else if(_loc6_)
               {
                  _loc3_ = RankDef(InstanceMng.getRanksDefMng().getDefBySku(_loc6_.getRankSku()));
               }
            }
            else
            {
               _loc3_ = _loc2_.getRankDef();
            }
         }
         return _loc3_;
      }
      
      private function createClassImage() : void
      {
         var _loc2_:RankDef = null;
         var _loc1_:String = "";
         if(Config.getConfig().gameHasRanks())
         {
            _loc2_ = this.getUserRankDef();
            _loc1_ = _loc2_ ? _loc2_.getBGImageName() : null;
         }
         else if(Boolean(Config.getConfig().gameHasClassSystem()) && Boolean(this.mBG) && Boolean(this.mJobDef))
         {
            _loc1_ = this.mJobDef.getBgIcon();
         }
         if(Boolean(this.mBG) && Boolean(_loc1_ != "") && _loc1_ != null)
         {
            if(this.mExtraImage == null)
            {
               this.mExtraImage = new FSImage(Root.assets.getTexture(_loc1_));
            }
            this.mExtraImage.alignPivot();
            this.mExtraImage.x = 0;
            this.mExtraImage.y = 0;
            if(this.mExtraInfoComponent == null)
            {
               this.mExtraInfoComponent = new Component();
            }
            this.mExtraInfoComponent.addChild(this.mExtraImage);
         }
      }
      
      private function createClassTextfield() : void
      {
         var _loc1_:RankDef = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(Config.getConfig().gameHasClassSystem() || Config.getConfig().gameHasRanks())
         {
            _loc1_ = this.getUserRankDef();
            if(Config.getConfig().gameHasClassSystem() && Boolean(this.mJobDef))
            {
               _loc2_ = this.mJobDef.getName();
            }
            else
            {
               _loc2_ = _loc1_ ? _loc1_.getName() : "";
            }
            if(_loc2_ != "" && _loc2_ != null)
            {
               if(this.mExtraTextfield == null)
               {
                  this.mExtraTextfield = new FSTextfield(this.mBG.width * 0.75 - this.mExtraImage.width,this.mExtraImage.height * 1.25,_loc2_,16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               }
               this.mExtraTextfield.alignPivot();
               this.mExtraTextfield.format.horizontalAlign = Align.LEFT;
               this.mExtraTextfield.x = this.mExtraImage.x + this.mExtraImage.width / 2 + this.mExtraTextfield.width / 2 + 5;
               this.mExtraTextfield.y = this.mExtraImage.y;
               this.mExtraInfoComponent.addChild(this.mExtraTextfield);
            }
            if(this.mExtraInfoComponent)
            {
               this.mExtraInfoComponent.alignPivot();
               _loc3_ = this.mIsOwner ? int(this.mBG.width / 10) : int(-this.mBG.width / 12);
               this.mExtraInfoComponent.x = this.mBG.x + _loc3_;
               this.mExtraInfoComponent.y = this.mBG.y + this.mBG.height / 2 + this.mExtraInfoComponent.height / 3;
               addChildAt(this.mExtraInfoComponent,0);
            }
         }
      }
      
      private function createTextfield() : void
      {
         if(this.mNameTextfield == null)
         {
            this.mNameTextfield = new FSTextfield(this.mBG.width * 0.65,this.mBG.height * 0.65,this.mName,16777215,FSResourceMng.FONT_STD_BIG_TITLE_SIZE);
         }
         this.mNameTextfield.alignPivot();
         var _loc1_:int = this.mIsOwner ? int(this.mBG.width / 10) : int(-this.mBG.width / 10);
         this.mNameTextfield.x = this.mBG.x + _loc1_;
         this.mNameTextfield.y = this.mBG.y;
         addChild(this.mNameTextfield);
      }
      
      private function startBarAnims() : void
      {
         var onRotationOver:Function = null;
         onRotationOver = function(param1:FSImage, param2:int, param3:int):void
         {
            if(param1)
            {
               SpecialFX.createRotation(param1,param3,param2,0,onRotationOver,[param1,param2,param3 * -1],Sine.easeInOut,0);
            }
         };
         if(this.mBGAnimBar1)
         {
            addChildAt(this.mBGAnimBar1,0);
            this.mBGAnimBar1.rotation = deg2rad(10);
            SpecialFX.createRotation(this.mBGAnimBar1,0,5,0,onRotationOver,[this.mBGAnimBar1,5,-10],null,0);
         }
         if(this.mBGAnimBar3)
         {
            addChildAt(this.mBGAnimBar3,0);
            this.mBGAnimBar3.rotation = deg2rad(-10);
            SpecialFX.createRotation(this.mBGAnimBar3,0,5,0,onRotationOver,[this.mBGAnimBar3,5,10],null,0);
         }
      }
      
      public function onMoveToPortraitPhase() : Number
      {
         var _loc1_:Number = 0.25;
         if(this.mBG)
         {
            SpecialFX.tweenToAlpha(this.mBG,0,_loc1_,0);
         }
         if(this.mNameTextfield)
         {
            SpecialFX.tweenToAlpha(this.mNameTextfield,0,_loc1_,0);
         }
         if(this.mExtraTextfield)
         {
            SpecialFX.tweenToAlpha(this.mExtraTextfield,0,_loc1_,0);
         }
         if(this.mBGAnimBar1)
         {
            SpecialFX.tweenToAlpha(this.mBGAnimBar1,0,_loc1_,0);
         }
         if(this.mBGAnimBar3)
         {
            SpecialFX.tweenToAlpha(this.mBGAnimBar3,0,_loc1_,0);
         }
         if(this.mExtraImage)
         {
            SpecialFX.tweenToAlpha(this.mExtraImage,0,_loc1_,0);
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         this.destroy();
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mChar)
         {
            this.mChar.removeFromParent();
            this.mChar = null;
         }
         if(this.mPortrait)
         {
            this.mPortrait.removeFromParent();
            this.mPortrait = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mNameTextfield)
         {
            this.mNameTextfield.removeFromParent(true);
            this.mNameTextfield = null;
         }
         if(this.mExtraImage)
         {
            this.mExtraImage.removeFromParent();
            this.mExtraImage = null;
         }
         if(this.mExtraTextfield)
         {
            this.mExtraTextfield.removeFromParent(true);
            this.mExtraTextfield = null;
         }
         if(this.mBGAnimBar1)
         {
            this.mBGAnimBar1.removeFromParent(true);
            this.mBGAnimBar1 = null;
         }
         if(this.mBGAnimBar3)
         {
            this.mBGAnimBar3.removeFromParent(true);
            this.mBGAnimBar3 = null;
         }
         this.mCharTextureRef = null;
         if(this.mExtraInfoComponent)
         {
            this.mExtraInfoComponent.removeChildren();
            this.mExtraInfoComponent.removeFromParent();
            this.mExtraInfoComponent = null;
         }
      }
   }
}

