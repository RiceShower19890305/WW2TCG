package com.fs.tcgengine.view.popups.dungeons
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.popups.FSPopupMng;
   import com.fs.tcgengine.model.rules.DungeonRewardsDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.view.dungeons.FSDungeonMedalSlot;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.pvp.PopupPvPRewardsInfo;
   import starling.utils.Align;
   
   public class PopupDungeonRewardsInfo extends PopupPvPRewardsInfo
   {
      
      public function PopupDungeonRewardsInfo(param1:Boolean = true)
      {
         super(param1);
      }
      
      override protected function isOkToOpen() : Boolean
      {
         return InstanceMng.getCurrentScreen().isFullyLoaded() && InstanceMng.getCurrentScreen() is FSDungeonsScreen;
      }
      
      override protected function getButtonRewardName() : String
      {
         return "league_reward_button";
      }
      
      override protected function getInfoButtonName() : String
      {
         return "dungeon_info_button";
      }
      
      override protected function getRewardChestName() : String
      {
         return "league_reward_large_chest";
      }
      
      override protected function getRewards() : void
      {
         var _loc1_:PortraitDef = null;
         var _loc2_:HeroCharacterDef = null;
         mRewardsDefsArr = InstanceMng.getDungeonRewardsDefMng().getDungeonRewards();
         if(Boolean(mRewardsDefsArr) && Config.smServerConfig != null)
         {
            InstanceMng.getCurrentScreen().showLoadingIcon(true,true,Align.CENTER,Align.CENTER,1,null,this);
            if(Config.getConfig().hasPortraits() && !Config.smPortraitFramesInAtlas)
            {
               _loc1_ = InstanceMng.getPortraitsDefMng().getDungeonExclusiveRewardBySeason(Config.smServerConfig["dungeons_season"]);
               if(_loc1_)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc1_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               }
            }
            else if(Config.getConfig().hasSkins())
            {
               _loc2_ = InstanceMng.getHeroCharactersDefMng().getDungeonExclusiveRewardBySeason(Config.smServerConfig["dungeons_season"]);
               if(_loc2_)
               {
                  InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc2_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
               }
            }
            InstanceMng.getResourcesMng().loadAssets(onItemsLoaded);
         }
      }
      
      override protected function createMedalRanking() : void
      {
         var _loc1_:int = 0;
         var _loc2_:DungeonRewardsDef = null;
         var _loc3_:FSDungeonMedalSlot = null;
         for each(_loc2_ in mRewardsDefsArr)
         {
            _loc3_ = new FSDungeonMedalSlot(_loc2_,this);
            if(_loc3_)
            {
               addToMedalRankingScrollContainer(_loc3_);
            }
         }
      }
      
      override protected function removeFromStage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:PortraitDef = null;
         if(Config.getConfig() != null && Config.getConfig().hasPortraits())
         {
            _loc1_ = Config.smServerConfig != null && Config.smServerConfig.hasOwnProperty("dungeons_season") ? int(Config.smServerConfig["dungeons_season"]) : -1;
            _loc2_ = _loc1_ != -1 && Boolean(InstanceMng.getPortraitsDefMng()) ? InstanceMng.getPortraitsDefMng().getDungeonExclusiveRewardBySeason(_loc1_) : null;
            if(_loc2_ != null)
            {
               Root.assets.removeTexture(_loc2_.getBGXLImageName(),true);
            }
         }
         super.removeFromStage();
         if(InstanceMng.getPopupMng())
         {
            InstanceMng.getPopupMng().removePopup(FSPopupMng.DUNGEON_REWARD_POPUP_NAME);
         }
      }
      
      override protected function getTIDToolTipInfoButton() : String
      {
         return TextManager.getText("TID_DUNGEON_MONTHLY_TOURNAMENT");
      }
      
      override protected function getTIDMonthlyTournament() : String
      {
         return TextManager.getText("TID_DUNGEON_MONTHLY_TOURNAMENT");
      }
      
      override protected function getTIDRewardExclusive() : String
      {
         var _loc1_:String = null;
         if(mVictoriesLeftInThisSeason <= 0)
         {
            _loc1_ = TextManager.getText("TID_REWARD_EXCLUSIVE_COMPLETED");
         }
         else
         {
            _loc1_ = TextManager.replaceParameters(TextManager.getText("TID_DUNGEON_REWARD_EXCLUSIVE"),[mVictoriesLeftInThisSeason]);
         }
         return _loc1_;
      }
      
      override protected function getTIDLevelReward() : String
      {
         return TextManager.getText("TID_GEN_LEVEL_REWARDS");
      }
      
      override protected function getTIDSeason() : String
      {
         var _loc1_:String = Boolean(Config.smServerConfig) && Config.smServerConfig.hasOwnProperty("dungeons_season") ? Config.smServerConfig["dungeons_season"] : "";
         return TextManager.getText("TID_DUNGEON_LEAGUE") + " " + _loc1_;
      }
      
      override protected function getTIDSeasonButton() : String
      {
         return TextManager.getText("TID_DUNGEON_LEAGUE");
      }
      
      override protected function getTIDNoRewards() : String
      {
         return InstanceMng.getCurrentScreen() is FSDungeonsScreen ? TextManager.getText("TID_RAID_REWARDS_EMPTY") + " " + FSDungeonsScreen(InstanceMng.getCurrentScreen()).getSeasonEndTime() : "";
      }
      
      override protected function setLeftVictories() : void
      {
         var _loc1_:Number = Config.getConfig().getSeasonDungeonVictories();
         var _loc2_:Number = InstanceMng.getUserDataMng().getOwnerUserData().getDungeonsWon();
         mVictoriesLeftInThisSeason = _loc1_ - _loc2_;
      }
      
      override protected function createImg() : void
      {
         var _loc1_:PortraitDef = null;
         var _loc2_:HeroCharacterDef = null;
         if(mExclusiveRewardImgName != "")
         {
            super.createImg();
            return;
         }
         if(Boolean(mCharacterSkinBG) && mExclusiveRewardImg == null)
         {
            if(Config.getConfig().hasPortraits())
            {
               _loc1_ = InstanceMng.getPortraitsDefMng().getDungeonExclusiveRewardBySeason(Config.smServerConfig["dungeons_season"]);
               if(_loc1_)
               {
                  mExclusiveRewardImg = new FSImage(Root.assets.getTexture(_loc1_.getBGImageName()));
               }
            }
            else
            {
               _loc2_ = InstanceMng.getHeroCharactersDefMng().getDungeonExclusiveRewardBySeason(Config.smServerConfig["dungeons_season"]);
               if(_loc2_)
               {
                  mExclusiveRewardImg = new FSImage(Root.assets.getTexture(_loc2_.getBGImageName()));
                  mExclusiveRewardImg.scaleX *= 0.5;
                  mExclusiveRewardImg.scaleY *= 0.5;
               }
            }
            if(mExclusiveRewardImg)
            {
               mExclusiveRewardImg.alignPivot();
               mExclusiveRewardImg.x = mCharacterSkinBG.x + mCharacterSkinBG.width / 2;
               mExclusiveRewardImg.y = mCharacterSkinBG.y + mCharacterSkinBG.height / 2;
               addChild(mExclusiveRewardImg);
            }
         }
      }
      
      override protected function loadImage(param1:Boolean = true) : void
      {
         super.loadImage(false);
      }
   }
}

