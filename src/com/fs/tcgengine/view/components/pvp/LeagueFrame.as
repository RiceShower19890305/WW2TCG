package com.fs.tcgengine.view.components.pvp
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.PvPConnectionMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.utils.RadialProgressBar;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.TweenMax;
   import starling.utils.Align;
   
   public class LeagueFrame extends Component
   {
      
      private var mFrame:FSImage;
      
      private var mPromotionAuraFrame:FSImage;
      
      private var mProgressImage:RadialProgressBar;
      
      private var mRatingTitleTextfield:FSTextfield;
      
      private var mRatingTextfield:FSTextfield;
      
      private var mGamesTitleTextfield:FSTextfield;
      
      private var mGamesTextfield:FSTextfield;
      
      private var mVictoriesTitleTextfield:FSTextfield;
      
      private var mVictoriesTextfield:FSTextfield;
      
      private var mRankTitleTextfield:FSTextfield;
      
      private var mRankTextfield:FSTextfield;
      
      private var mLeaguePromotionTextfield:FSTextfield;
      
      private var mLeaguePromotionDescTextfield:FSTextfield;
      
      private var mLeaguePromotionImage:FSImage;
      
      private var mSpecialEffect:FSImage;
      
      private var mCloseToPromotion:Boolean = false;
      
      private var mCloseToDemotion:Boolean = false;
      
      private var mIsEndOfBattleInfo:Boolean = false;
      
      public function LeagueFrame(param1:Boolean = false)
      {
         super();
         this.mIsEndOfBattleInfo = param1 && !PvPConnectionMng.smPlayingFriendlyMatch;
         this.createUI();
         alignPivot();
      }
      
      private function createUI(param1:Function = null) : void
      {
         this.mCloseToPromotion = this.isAboutToPromote();
         this.mCloseToDemotion = this.isAboutToDemote();
         this.createFrame(param1);
         this.createRating();
         this.createGames();
         this.createRank();
         this.createVictories();
         this.createPromotionTextfield();
         scale = this.willShowBigPromotionWarning() && Utils.isMobile() ? 0.8 : 1;
         alignPivot();
      }
      
      public function updateUI(param1:Function = null, param2:Boolean = false) : void
      {
         if(param2)
         {
            this.mIsEndOfBattleInfo = false;
         }
         this.createUI(param1);
      }
      
      private function createFrame(param1:Function = null) : void
      {
         var _loc2_:UserData = Utils.getOwnerUserData();
         var _loc3_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smLeagueBeforeStartingMatch : _loc2_.getPvPCurrentLeague();
         var _loc4_:String = "pvp_league_frame_" + _loc3_;
         if(this.mFrame == null)
         {
            this.mFrame = new FSImage(Root.assets.getTexture(_loc4_));
            this.mFrame.alignPivot();
            addChild(this.mFrame);
         }
         else if(Root.assets.getTexture(_loc4_) != this.mFrame.texture)
         {
            this.performHighlightFX();
            this.mFrame.texture = Root.assets.getTexture(_loc4_);
         }
         this.handleProgress(param1);
         this.handlePromotion();
      }
      
      private function createSpecialFX() : void
      {
         if(this.mSpecialEffect == null)
         {
            this.mSpecialEffect = new FSImage(Root.assets.getTexture("job_effect_1"));
            this.mSpecialEffect.alignPivot();
            this.mSpecialEffect.x = this.mFrame.x;
            this.mSpecialEffect.y = this.mFrame.y;
         }
         this.mSpecialEffect.visible = false;
      }
      
      private function performHighlightFX() : void
      {
         var _loc1_:Number = NaN;
         this.createSpecialFX();
         if(this.mSpecialEffect)
         {
            this.mSpecialEffect.width = this.mFrame.width * 0.5;
            this.mSpecialEffect.height = this.mFrame.height * 0.5;
            this.mSpecialEffect.visible = true;
            _loc1_ = this.mSpecialEffect.scale;
            this.mSpecialEffect.scale = 0.1;
            addChild(this.mSpecialEffect);
            SpecialFX.createZoomAlphaTween(this.mSpecialEffect,1,0.999,0.001,0.1,_loc1_ * 4,null,this.onTransitionEnd);
            SpecialFX.createRotation(this.mSpecialEffect,360);
         }
      }
      
      private function onTransitionEnd() : void
      {
         if(this.mSpecialEffect)
         {
            this.mSpecialEffect.removeFromParent();
         }
      }
      
      private function handleProgress(param1:Function = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:UserData = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         if(this.mCloseToPromotion)
         {
            _loc2_ = "pvp_league_circle_promotion";
         }
         else if(this.mCloseToDemotion)
         {
            _loc2_ = "pvp_league_circle_demotion";
         }
         else
         {
            _loc2_ = "pvp_league_circle_progress";
         }
         if(this.mProgressImage == null)
         {
            this.mProgressImage = new RadialProgressBar();
            this.mProgressImage.progressTexture = Root.assets.getTexture(_loc2_);
            this.mProgressImage.validate();
            this.mProgressImage.alignPivot();
            addChildAt(this.mProgressImage,getChildIndex(this.mFrame));
            if(this.mCloseToDemotion || this.mCloseToPromotion)
            {
               SpecialFX.createYoYoAlphaTransition(this.mProgressImage,0.5,0.5);
            }
         }
         else
         {
            this.mProgressImage.progressTexture = Root.assets.getTexture(_loc2_);
         }
         if((this.mCloseToDemotion || this.mCloseToPromotion) && !PvPConnectionMng.smPlayingFriendlyMatch)
         {
            this.mProgressImage.tweenTo(1,1,param1);
         }
         else
         {
            _loc3_ = Utils.getOwnerUserData();
            _loc4_ = this.mIsEndOfBattleInfo ? PvPConnectionMng.smLeagueBeforeStartingMatch : _loc3_.getPvPCurrentLeague();
            _loc5_ = this.mIsEndOfBattleInfo ? PvPConnectionMng.smEloBeforeStartingMatch : _loc3_.getElo();
            _loc6_ = PvPConnectionMng.getRatingPercentForNextLeague(true);
            _loc6_ = _loc6_ > 1 ? 1 : _loc6_;
            TweenMax.killTweensOf(this.mProgressImage);
            this.mProgressImage.tweenTo(_loc6_,1,param1);
            this.mProgressImage.validate();
            this.mProgressImage.alignPivot();
         }
      }
      
      private function isAboutToPromote() : Boolean
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smLeagueBeforeStartingMatch : _loc1_.getPvPCurrentLeague();
         var _loc3_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smEloBeforeStartingMatch : _loc1_.getElo();
         var _loc4_:Boolean = PvPConnectionMng.isPlayerCloseToSwitchLeague(true,_loc3_,_loc2_);
         var _loc5_:Boolean = PvPConnectionMng.isPlayerCloseToSwitchLeague(false,_loc3_,_loc2_);
         return _loc4_ || !_loc5_ && _loc2_ == 1;
      }
      
      private function isAboutToDemote() : Boolean
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smLeagueBeforeStartingMatch : _loc1_.getPvPCurrentLeague();
         var _loc3_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smEloBeforeStartingMatch : _loc1_.getElo();
         var _loc4_:Boolean = PvPConnectionMng.isPlayerCloseToSwitchLeague(false,_loc3_,_loc2_);
         return (_loc4_) || !_loc4_ && _loc3_ < 850;
      }
      
      private function handlePromotion() : void
      {
         var _loc1_:String = null;
         if(this.mCloseToPromotion || this.mCloseToDemotion)
         {
            _loc1_ = this.mCloseToPromotion ? "pvp_aura_blue" : "pvp_aura_red";
            if(this.mPromotionAuraFrame == null)
            {
               this.mPromotionAuraFrame = new FSImage(Root.assets.getTexture(_loc1_));
               this.mPromotionAuraFrame.scale = 2.5;
               this.mPromotionAuraFrame.alignPivot();
               SpecialFX.createYoYoAlphaTransition(this.mPromotionAuraFrame,0.5,2);
            }
            else
            {
               this.mPromotionAuraFrame.texture = Root.assets.getTexture(_loc1_);
            }
            addChildAt(this.mPromotionAuraFrame,getChildIndex(this.mProgressImage));
         }
         else if(this.mPromotionAuraFrame)
         {
            this.mPromotionAuraFrame.removeFromParent();
         }
      }
      
      private function createRating() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smEloBeforeStartingMatch : _loc1_.getElo();
         if(this.mRatingTitleTextfield == null)
         {
            this.mRatingTitleTextfield = new FSTextfield(this.mFrame.width / 3,this.mFrame.height / 5,TextManager.getText("TID_PVP_RATING"),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mRatingTitleTextfield.alignPivot();
            this.mRatingTitleTextfield.x = this.mFrame.x;
            this.mRatingTitleTextfield.y = this.mFrame.y - this.mRatingTitleTextfield.height;
            addChild(this.mRatingTitleTextfield);
         }
         if(this.mRatingTextfield == null)
         {
            this.mRatingTextfield = new FSTextfield(this.mFrame.width / 2,this.mFrame.height / 3,_loc2_.toString(),16777215,FSResourceMng.FONT_STD_BIG_XL_TITLE_SIZE);
            this.mRatingTextfield.alignPivot();
            this.mRatingTextfield.x = this.mRatingTitleTextfield.x;
            this.mRatingTextfield.y = this.mRatingTitleTextfield.y + this.mRatingTitleTextfield.height;
            addChild(this.mRatingTextfield);
         }
         SpecialFX.createTextfieldAmountTransition(this.mRatingTextfield,_loc2_,1,true);
      }
      
      private function createGames() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = _loc1_.getMatchesPlayed();
         if(this.mGamesTitleTextfield == null)
         {
            this.mGamesTitleTextfield = new FSTextfield(this.mFrame.width / 2,this.mFrame.height / 5,TextManager.getText("TID_PVP_GAMES"),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mGamesTitleTextfield.format.verticalAlign = Align.BOTTOM;
            this.mGamesTitleTextfield.alignPivot();
            this.mGamesTitleTextfield.x = this.mFrame.x - this.mFrame.width / 2;
            this.mGamesTitleTextfield.y = this.mFrame.y + this.mFrame.height / 2;
            addChild(this.mGamesTitleTextfield);
         }
         if(this.mGamesTextfield == null)
         {
            this.mGamesTextfield = new FSTextfield(this.mFrame.width / 2,this.mFrame.height / 3.5,_loc2_.toString(),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mGamesTextfield.alignPivot();
            this.mGamesTextfield.x = this.mGamesTitleTextfield.x;
            this.mGamesTextfield.y = this.mGamesTitleTextfield.y + this.mGamesTitleTextfield.height;
            addChild(this.mGamesTextfield);
         }
         this.mGamesTextfield.text = _loc2_.toString();
      }
      
      private function createRank() : void
      {
         if(InstanceMng.getCurrentScreen() is FSBattleScreenPvP)
         {
            return;
         }
         var _loc1_:int = -1;
         if(InstanceMng.getCurrentScreen() is FSPvPScreen)
         {
            _loc1_ = FSPvPScreen.smLeaderboardOwnerRank;
         }
         var _loc2_:String = _loc1_ > 0 ? _loc1_.toString() : "???";
         if(this.mRankTitleTextfield == null)
         {
            this.mRankTitleTextfield = new FSTextfield(this.mGamesTitleTextfield.width,this.mGamesTitleTextfield.height,TextManager.getText("TID_PVP_POSITION"),16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
            this.mRankTitleTextfield.format.verticalAlign = Align.BOTTOM;
            this.mRankTitleTextfield.alignPivot();
            this.mRankTitleTextfield.x = this.mFrame.x;
            this.mRankTitleTextfield.y = this.mGamesTitleTextfield.y;
            addChild(this.mRankTitleTextfield);
         }
         if(this.mRankTextfield == null)
         {
            this.mRankTextfield = new FSTextfield(this.mGamesTextfield.width,this.mGamesTextfield.height,_loc2_,16777215,FSResourceMng.FONT_STD_BIG_XL_TITLE_SIZE);
            this.mRankTextfield.alignPivot();
            this.mRankTextfield.x = this.mRankTitleTextfield.x;
            this.mRankTextfield.y = this.mRankTitleTextfield.y + this.mRankTitleTextfield.height;
            addChild(this.mRankTextfield);
         }
         this.mRankTextfield.text = _loc2_;
      }
      
      public function updateRank(param1:int) : void
      {
         if(Boolean(this.mRankTextfield) && param1 > 0)
         {
            this.mRankTextfield.text = param1.toString();
         }
      }
      
      private function createVictories() : void
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = _loc1_.getMatchesWon();
         if(this.mVictoriesTitleTextfield == null)
         {
            this.mVictoriesTitleTextfield = new FSTextfield(this.mGamesTitleTextfield.width,this.mGamesTitleTextfield.height,TextManager.getText("TID_PVP_VICTORIES"),16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mVictoriesTitleTextfield.format.verticalAlign = Align.BOTTOM;
            this.mVictoriesTitleTextfield.alignPivot();
            this.mVictoriesTitleTextfield.x = this.mFrame.x + this.mFrame.width / 2;
            this.mVictoriesTitleTextfield.y = this.mGamesTitleTextfield.y;
            addChild(this.mVictoriesTitleTextfield);
         }
         if(this.mVictoriesTextfield == null)
         {
            this.mVictoriesTextfield = new FSTextfield(this.mGamesTextfield.width,this.mGamesTextfield.height,_loc2_.toString(),16777215,FSResourceMng.FONT_STD_TITLE_SIZE);
            this.mVictoriesTextfield.alignPivot();
            this.mVictoriesTextfield.x = this.mVictoriesTitleTextfield.x;
            this.mVictoriesTextfield.y = this.mVictoriesTitleTextfield.y + this.mVictoriesTitleTextfield.height;
            addChild(this.mVictoriesTextfield);
         }
         this.mVictoriesTextfield.text = _loc2_.toString();
      }
      
      private function willShowBigPromotionWarning() : Boolean
      {
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smEloBeforeStartingMatch : _loc1_.getElo();
         var _loc3_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smLeagueBeforeStartingMatch : _loc1_.getPvPCurrentLeague();
         var _loc4_:Boolean = _loc3_ + 1 <= 3;
         var _loc5_:Boolean = _loc3_ - 1 >= 1;
         return this.mCloseToPromotion && _loc5_ || this.mCloseToDemotion && _loc4_;
      }
      
      private function createPromotionTextfield() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         if(InstanceMng.getCurrentScreen() is FSBattleScreenPvP)
         {
            return;
         }
         var _loc1_:UserData = Utils.getOwnerUserData();
         var _loc2_:int = this.mIsEndOfBattleInfo ? PvPConnectionMng.smLeagueBeforeStartingMatch : _loc1_.getPvPCurrentLeague();
         var _loc3_:Boolean = this.willShowBigPromotionWarning();
         if(_loc3_)
         {
            _loc9_ = this.mCloseToPromotion ? TextManager.getText("TID_PVP_PROMOTION") : TextManager.getText("TID_PVP_DEMOTION");
            _loc10_ = this.mCloseToPromotion ? 65280 : 16711680;
            if(this.mLeaguePromotionTextfield == null)
            {
               this.mLeaguePromotionTextfield = new FSTextfield(this.mFrame.width,this.mGamesTitleTextfield.height * 0.75,_loc9_,_loc10_,FSResourceMng.FONT_STD_TITLE_SIZE);
               this.mLeaguePromotionTextfield.alignPivot();
               this.mLeaguePromotionTextfield.x = this.mFrame.x;
               this.mLeaguePromotionTextfield.y = this.mGamesTextfield.y + this.mGamesTextfield.height / 2 + this.mLeaguePromotionTextfield.height / 2;
            }
            addChild(this.mLeaguePromotionTextfield);
            this.mLeaguePromotionTextfield.text = _loc9_;
            this.mLeaguePromotionTextfield.color = _loc10_;
            _loc11_ = this.mCloseToPromotion ? "pvp_text_icon_promotion" : "pvp_text_icon_demotion";
            if(this.mLeaguePromotionImage == null)
            {
               this.mLeaguePromotionImage = new FSImage(Root.assets.getTexture(_loc11_));
               this.mLeaguePromotionImage.alignPivot();
               this.mLeaguePromotionImage.height = this.mLeaguePromotionTextfield.height;
               this.mLeaguePromotionImage.scaleX = this.mLeaguePromotionImage.scaleY;
               this.mLeaguePromotionImage.x = this.mLeaguePromotionTextfield.x - this.mLeaguePromotionTextfield.width / 2 - this.mLeaguePromotionImage.width / 2;
               this.mLeaguePromotionImage.y = this.mLeaguePromotionTextfield.y;
            }
            else
            {
               this.mLeaguePromotionImage.texture = Root.assets.getTexture(_loc11_);
               this.mLeaguePromotionImage.height = this.mLeaguePromotionTextfield.height;
            }
            addChild(this.mLeaguePromotionImage);
         }
         else
         {
            if(this.mLeaguePromotionTextfield)
            {
               this.mLeaguePromotionTextfield.removeFromParent();
            }
            if(this.mLeaguePromotionDescTextfield)
            {
               this.mLeaguePromotionDescTextfield.removeFromParent();
            }
            if(this.mLeaguePromotionImage)
            {
               this.mLeaguePromotionImage.removeFromParent();
            }
         }
         if(this.mCloseToDemotion && _loc2_ == 3 || this.mCloseToPromotion && _loc2_ == 1)
         {
            return;
         }
         var _loc6_:Boolean = false;
         if(this.mCloseToDemotion || this.mCloseToPromotion)
         {
            _loc4_ = this.mCloseToDemotion ? PvPConnectionMng.getRatingForNextPromotion(false) : PvPConnectionMng.getRatingForNextPromotion(true);
            _loc5_ = this.mCloseToDemotion ? int(_loc2_ + 1) : int(_loc2_ - 1);
            _loc7_ = TextManager.getText("TID_PVP_LEAGUE_" + _loc5_,true);
            _loc8_ = this.mCloseToDemotion ? TextManager.replaceParameters(TextManager.getText("TID_PVP_DEMOTION_INFO",true),[_loc4_,_loc7_]) : TextManager.replaceParameters(TextManager.getText("TID_PVP_PROMOTION_INFO",true),[_loc4_,_loc7_]);
         }
         else
         {
            _loc12_ = PvPConnectionMng.getRatingForNextPromotion(false);
            _loc4_ = PvPConnectionMng.getRatingForNextPromotion(true);
            if(_loc12_ < _loc4_ && _loc12_ >= 150 || _loc4_ < _loc12_ && _loc4_ >= 150)
            {
               return;
            }
            _loc5_ = _loc12_ < _loc4_ ? int(_loc2_ + 1) : int(_loc2_ - 1);
            _loc7_ = TextManager.getText("TID_PVP_LEAGUE_" + _loc5_,true);
            _loc8_ = _loc12_ < _loc4_ ? TextManager.replaceParameters(TextManager.getText("TID_PVP_DEMOTION_INFO",true),[_loc12_,_loc7_]) : TextManager.replaceParameters(TextManager.getText("TID_PVP_PROMOTION_INFO",true),[_loc4_,_loc7_]);
         }
         if(this.mLeaguePromotionDescTextfield == null)
         {
            this.mLeaguePromotionDescTextfield = new FSTextfield(width,this.mGamesTitleTextfield.height * 0.85,_loc8_,16777215,FSResourceMng.FONT_STD_DEFAULT_SIZE);
            this.mLeaguePromotionDescTextfield.alignPivot();
         }
         this.mLeaguePromotionDescTextfield.x = this.mFrame.x;
         this.mLeaguePromotionDescTextfield.y = Boolean(this.mLeaguePromotionTextfield) && this.mLeaguePromotionTextfield.parent != null ? this.mLeaguePromotionTextfield.y + this.mLeaguePromotionTextfield.height / 2 + this.mLeaguePromotionDescTextfield.height / 2 : this.mGamesTextfield.y + this.mGamesTextfield.height / 2 + this.mLeaguePromotionDescTextfield.height / 2;
         this.mLeaguePromotionDescTextfield.text = _loc8_;
         addChild(this.mLeaguePromotionDescTextfield);
      }
      
      override public function dispose() : void
      {
         if(this.mFrame)
         {
            this.mFrame.removeFromParent(true);
            this.mFrame = null;
         }
         if(this.mPromotionAuraFrame)
         {
            this.mPromotionAuraFrame.removeFromParent(true);
            this.mPromotionAuraFrame = null;
         }
         if(this.mProgressImage)
         {
            this.mProgressImage.removeFromParent(true);
            this.mProgressImage = null;
         }
         if(this.mRatingTitleTextfield)
         {
            this.mRatingTitleTextfield.removeFromParent(true);
            this.mRatingTitleTextfield = null;
         }
         if(this.mRatingTextfield)
         {
            this.mRatingTextfield.removeFromParent(true);
            this.mRatingTextfield = null;
         }
         if(this.mGamesTitleTextfield)
         {
            this.mGamesTitleTextfield.removeFromParent(true);
            this.mGamesTitleTextfield = null;
         }
         if(this.mGamesTextfield)
         {
            this.mGamesTextfield.removeFromParent(true);
            this.mGamesTextfield = null;
         }
         if(this.mVictoriesTitleTextfield)
         {
            this.mVictoriesTitleTextfield.removeFromParent(true);
            this.mVictoriesTitleTextfield = null;
         }
         if(this.mVictoriesTextfield)
         {
            this.mVictoriesTextfield.removeFromParent(true);
            this.mVictoriesTextfield = null;
         }
         if(this.mRankTitleTextfield)
         {
            this.mRankTitleTextfield.removeFromParent(true);
            this.mRankTitleTextfield = null;
         }
         if(this.mRankTextfield)
         {
            this.mRankTextfield.removeFromParent(true);
            this.mRankTextfield = null;
         }
         if(this.mLeaguePromotionTextfield)
         {
            this.mLeaguePromotionTextfield.removeFromParent(true);
            this.mLeaguePromotionTextfield = null;
         }
         if(this.mLeaguePromotionDescTextfield)
         {
            this.mLeaguePromotionDescTextfield.removeFromParent(true);
            this.mLeaguePromotionDescTextfield = null;
         }
         if(this.mLeaguePromotionImage)
         {
            this.mLeaguePromotionImage.removeFromParent(true);
            this.mLeaguePromotionImage = null;
         }
         if(this.mSpecialEffect)
         {
            this.mSpecialEffect.removeFromParent(true);
            this.mSpecialEffect = null;
         }
         super.dispose();
      }
   }
}

