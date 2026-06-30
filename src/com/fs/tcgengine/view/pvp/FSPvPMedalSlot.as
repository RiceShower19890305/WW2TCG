package com.fs.tcgengine.view.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.DungeonRewardsDef;
   import com.fs.tcgengine.model.rules.PackDef;
   import com.fs.tcgengine.model.rules.PvPRewardsDef;
   import com.fs.tcgengine.view.anims.misc.PackAnimation;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import starling.display.Quad;
   
   public class FSPvPMedalSlot extends Component
   {
      
      private var mRewardDef:Def;
      
      private var mMedalBG:Quad;
      
      private var mBox:Quad;
      
      private var mMedalImg:FSImage;
      
      private var mMedalPositionTextfield:FSTextfield;
      
      private var mMedalPackImage:PackAnimation;
      
      private var mMedalGoldImage:FSImage;
      
      private var mMedalGoldTextfield:FSTextfield;
      
      private var mParentPopup:Popup;
      
      public function FSPvPMedalSlot(param1:Def, param2:Popup)
      {
         this.mRewardDef = param1;
         this.mParentPopup = param2;
         super();
         this.createBox();
         this.createMedal();
      }
      
      private function createBox() : void
      {
         if(this.mBox == null)
         {
            this.mBox = new Quad(this.mParentPopup.width / 10,this.mParentPopup.height / 2.2,0);
            this.mBox.alpha = 0.01;
            addChild(this.mBox);
         }
      }
      
      private function createMedal() : void
      {
         this.createMedalBG();
         this.createMedalImg();
         this.createMedalPositionTextfield();
         this.createPackImage();
         this.createGoldImage();
         this.createGoldTextfield();
      }
      
      private function createGoldTextfield() : void
      {
         if(Boolean(this.mMedalGoldImage) && this.mMedalGoldTextfield == null)
         {
            this.mMedalGoldTextfield = new FSTextfield(this.mMedalGoldImage.width * 0.8,this.mMedalGoldImage.height * 0.8,this.getRewardGold().toString());
            this.mMedalGoldTextfield.alignPivot();
            this.mMedalGoldTextfield.x = this.mMedalGoldImage.x;
            this.mMedalGoldTextfield.y = this.mMedalGoldImage.y;
            addChild(this.mMedalGoldTextfield);
         }
      }
      
      private function createGoldImage() : void
      {
         if(Boolean(this.mMedalBG) && Boolean(this.mMedalPackImage) && this.mMedalGoldImage == null)
         {
            this.mMedalGoldImage = new FSImage(Root.assets.getTexture("gold_icon"));
            this.mMedalGoldImage.scaleX *= 0.7;
            this.mMedalGoldImage.scaleY *= 0.7;
            this.mMedalGoldImage.alignPivot();
            this.mMedalGoldImage.x = this.mMedalPackImage.x;
            this.mMedalGoldImage.y = this.mMedalPackImage.y + this.mMedalPackImage.height * 1.1;
            addChild(this.mMedalGoldImage);
         }
      }
      
      private function createPackImage() : void
      {
         var _loc1_:PackDef = null;
         if(Boolean(this.mMedalBG) && Boolean(this.mMedalImg) && this.mMedalPackImage == null)
         {
            _loc1_ = PackDef(InstanceMng.getPacksDefMng().getDefBySku(this.getRewardPackSku()));
            this.mMedalPackImage = new PackAnimation(_loc1_.getAnimBG());
            this.mMedalPackImage.scaleX *= 0.25;
            this.mMedalPackImage.scaleY *= 0.25;
            this.mMedalPackImage.alignPivot();
            this.mMedalPackImage.x = this.mMedalBG.width / 2;
            this.mMedalPackImage.y = this.mMedalImg.height * 1.4;
            addChild(this.mMedalPackImage);
         }
      }
      
      private function createMedalPositionTextfield() : void
      {
         if(Boolean(this.mMedalBG) && Boolean(this.mMedalImg) && this.mMedalPositionTextfield == null)
         {
            this.mMedalPositionTextfield = new FSTextfield(this.mMedalImg.width * 0.75,this.mMedalImg.height * 0.5,this.getTextPosition());
            this.mMedalPositionTextfield.alignPivot();
            this.mMedalPositionTextfield.x = this.mMedalImg.x;
            this.mMedalPositionTextfield.y = this.mMedalImg.y;
            addChild(this.mMedalPositionTextfield);
         }
      }
      
      private function getTextPosition() : String
      {
         var _loc1_:String = null;
         if(this.getRankingStartPosition() >= 4)
         {
            _loc1_ = this.getRankingStartPosition().toString() + "-" + this.getRankingEndPosition().toString();
         }
         else
         {
            _loc1_ = this.getRankingStartPosition().toString();
         }
         return _loc1_;
      }
      
      private function createMedalImg() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.mMedalBG) && this.mMedalImg == null)
         {
            if(this.getRankingStartPosition() > 4)
            {
               _loc1_ = 4;
            }
            else
            {
               _loc1_ = this.getRankingStartPosition();
            }
            this.mMedalImg = new FSImage(Root.assets.getTexture(this.getRankingAssetName() + _loc1_));
            this.mMedalImg.alignPivot();
            this.mMedalImg.x = this.mMedalBG.width / 2;
            this.mMedalImg.y = this.mMedalImg.height / 2;
            addChild(this.mMedalImg);
         }
      }
      
      private function createMedalBG() : void
      {
         if(Boolean(this.mBox) && this.mMedalBG == null)
         {
            this.mMedalBG = new Quad(this.mBox.width * 0.9,this.mBox.height * 0.9,0);
            this.mMedalBG.alpha = 0.5;
            this.mMedalBG.y = this.mBox.height - this.mMedalBG.height;
            addChild(this.mMedalBG);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBox)
         {
            this.mBox.removeFromParent(true);
            this.mBox = null;
         }
         if(this.mMedalBG)
         {
            this.mMedalBG.removeFromParent(true);
            this.mMedalBG = null;
         }
         if(this.mMedalImg)
         {
            this.mMedalImg.removeFromParent(true);
            this.mMedalImg = null;
         }
         if(this.mMedalPositionTextfield)
         {
            this.mMedalPositionTextfield.removeFromParent(true);
            this.mMedalPositionTextfield = null;
         }
         if(this.mMedalPackImage)
         {
            this.mMedalPackImage.removeFromParent(true);
            this.mMedalPackImage = null;
         }
         if(this.mMedalGoldImage)
         {
            this.mMedalGoldImage.removeFromParent(true);
            this.mMedalGoldImage = null;
         }
         if(this.mMedalGoldTextfield)
         {
            this.mMedalGoldTextfield.removeFromParent(true);
            this.mMedalGoldTextfield = null;
         }
         this.mParentPopup = null;
         super.dispose();
      }
      
      protected function getRankingAssetName() : String
      {
         return "medal_ranking_";
      }
      
      protected function getRankingStartPosition() : int
      {
         var _loc1_:int = -1;
         if(this.mRewardDef is PvPRewardsDef)
         {
            _loc1_ = PvPRewardsDef(this.mRewardDef).getStartPosition();
         }
         else if(this.mRewardDef is DungeonRewardsDef)
         {
            _loc1_ = DungeonRewardsDef(this.mRewardDef).getStartPosition();
         }
         return _loc1_;
      }
      
      protected function getRankingEndPosition() : int
      {
         var _loc1_:int = -1;
         if(this.mRewardDef is PvPRewardsDef)
         {
            _loc1_ = PvPRewardsDef(this.mRewardDef).getEndPosition();
         }
         else if(this.mRewardDef is DungeonRewardsDef)
         {
            _loc1_ = DungeonRewardsDef(this.mRewardDef).getEndPosition();
         }
         return _loc1_;
      }
      
      protected function getRewardGold() : int
      {
         var _loc1_:int = -1;
         if(this.mRewardDef is PvPRewardsDef)
         {
            _loc1_ = PvPRewardsDef(this.mRewardDef).getGold();
         }
         else if(this.mRewardDef is DungeonRewardsDef)
         {
            _loc1_ = DungeonRewardsDef(this.mRewardDef).getGold();
         }
         return _loc1_;
      }
      
      protected function getRewardPackSku() : String
      {
         var _loc1_:String = null;
         if(this.mRewardDef is PvPRewardsDef)
         {
            _loc1_ = PvPRewardsDef(this.mRewardDef).getPackSku();
         }
         else if(this.mRewardDef is DungeonRewardsDef)
         {
            _loc1_ = DungeonRewardsDef(this.mRewardDef).getPackSku();
         }
         return _loc1_;
      }
   }
}

