package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   
   public class BadgeSlot extends Component
   {
      
      private const BADGESLOT_BG:String = "quest_completed_panel";
      
      private const CITY_ICON_BG:String = "city_icon";
      
      private var mBG:FSImage;
      
      private var mCityImage:FSImage;
      
      private var mBadgeDescriptionTextfield:FSTextfield;
      
      private var mBadgeCityNameTextfield:FSTextfield;
      
      private var mRankDef:RankDef;
      
      private var mVillageName:String;
      
      public function BadgeSlot(param1:RankDef, param2:String)
      {
         this.mRankDef = param1;
         this.mVillageName = param2;
         super();
         this.createBG();
         this.createCityImage();
         this.createBadgeDescription();
         this.createCityName();
         Utils.playSound(Constants.SOUND_BUILD_TOWN,SoundManager.TYPE_SFX);
      }
      
      private function createCityName() : void
      {
         var _loc1_:String = null;
         if(this.mBadgeCityNameTextfield == null)
         {
            _loc1_ = "";
            if(this.mVillageName != null && this.mVillageName != "")
            {
               _loc1_ = this.mVillageName.toUpperCase();
            }
            this.mBadgeCityNameTextfield = new FSTextfield(this.mBG.width * 0.6,this.mBG.height * 0.3,_loc1_);
            this.mBadgeCityNameTextfield.fontSize = FSResourceMng.FONT_STD_TITLE_SIZE;
            this.mBadgeCityNameTextfield.alignPivot();
            this.mBadgeCityNameTextfield.x = this.mBadgeDescriptionTextfield.x;
            this.mBadgeCityNameTextfield.y = this.mBadgeDescriptionTextfield.y + this.mBadgeDescriptionTextfield.height * 0.7;
            addChild(this.mBadgeCityNameTextfield);
         }
      }
      
      private function createBadgeDescription() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.mBadgeDescriptionTextfield == null)
         {
            if(this.mRankDef)
            {
               _loc2_ = this.mRankDef.getComplementaryName() != null && TextManager.getText(this.mRankDef.getComplementaryName()) != null ? TextManager.getText(this.mRankDef.getComplementaryName()) : "";
               _loc3_ = this.mRankDef.getName() != null ? this.mRankDef.getName() : "";
               _loc1_ = TextManager.replaceParameters(_loc2_,[_loc3_]);
            }
            this.mBadgeDescriptionTextfield = new FSTextfield(this.mBG.width * 0.7,this.mBG.height * 0.5,_loc1_);
            this.mBadgeDescriptionTextfield.fontSize = FSResourceMng.FONT_STD_BIG_TITLE_SIZE;
            this.mBadgeDescriptionTextfield.alignPivot();
            this.mBadgeDescriptionTextfield.x = this.mCityImage.x + this.mCityImage.width * 2.4;
            this.mBadgeDescriptionTextfield.y = this.mCityImage.y - this.mBadgeDescriptionTextfield.height * 0.3;
         }
         addChild(this.mBadgeDescriptionTextfield);
      }
      
      private function createCityImage() : void
      {
         if(this.mCityImage == null)
         {
            this.mCityImage = new FSImage(Root.assets.getTexture(this.CITY_ICON_BG));
            this.mCityImage.alignPivot();
            this.mCityImage.x = this.mBG.x + this.mBG.width * 0.1;
            this.mCityImage.y = this.mBG.y + this.mCityImage.height / 2;
         }
         addChild(this.mCityImage);
      }
      
      private function createBG() : void
      {
         var _loc1_:String = null;
         if(this.mBG == null)
         {
            _loc1_ = this.BADGESLOT_BG;
            this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
         }
         addChild(this.mBG);
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mCityImage)
         {
            this.mCityImage.removeFromParent(true);
            this.mCityImage = null;
         }
         if(this.mBadgeDescriptionTextfield)
         {
            this.mBadgeDescriptionTextfield.removeFromParent(true);
            this.mBadgeDescriptionTextfield = null;
         }
         if(this.mBadgeCityNameTextfield)
         {
            this.mBadgeCityNameTextfield.removeFromParent(true);
            this.mBadgeCityNameTextfield = null;
         }
         this.mRankDef = null;
         super.dispose();
      }
   }
}

