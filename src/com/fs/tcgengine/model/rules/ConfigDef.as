package com.fs.tcgengine.model.rules
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSNumber;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import flash.utils.Dictionary;
   
   public class ConfigDef extends Def
   {
      
      private var mFactionsAmount:int;
      
      private var mDeckCardsAmount:int;
      
      private var mDeckDefaultRows:int;
      
      private var mDeckDefaultColumns:int;
      
      private var mShowSpecialFX:Boolean;
      
      private var mAllowFilters:Boolean;
      
      private var mMaxBoostsOnScreen:int;
      
      private var mModeOnline:Boolean;
      
      private var mMaxDecksAmount:int;
      
      private var mMaxDeckNameChars:int;
      
      private var mMaxPlayerNameChars:int;
      
      private var mDefaultLives:int;
      
      private var mLifeRegenTime:Number;
      
      private var mShopMaxCardsPerPack:int;
      
      private var mDeckBuilderMinCardsAmountForRecycling:int;
      
      private var mDefaultAvailableDecksAmount:int;
      
      private var mDefaultWeeklyOffersAmount:int;
      
      private var mDefaultHourlyOffersAmount:Number;
      
      private var mDefaultTextsUpperCase:Boolean;
      
      private var mDefaultZoomOutTime:Number;
      
      private var mDefaultAbilityAnimDuration:Number;
      
      private var mDefaultAttachmentAddedAnimDuration:Number;
      
      private var mDefaultActionAnimDuration:Number;
      
      private var mDefaultMoveToBFAnimDuration:Number;
      
      private var mDefaultAttackAnimDuration:Number;
      
      private var mDefaultAttackPortraitAnimDuration:Number;
      
      private var mDefaultHighlightDeactivationAnimDuration:Number;
      
      private var mDefaultTriggerOnAttachedAbilitiesDuration:Number;
      
      private var mDefaultTriggerAttachmentFadeOffDuration:Number;
      
      private var mDefaultGeneralSpeedFactor:Number;
      
      private var mDefaultGeneralSpeedFactorTutorial:Number;
      
      private var mDefaultDeathAnimationDuration:Number;
      
      private var mDefaultActionMoveToCenterAnimDuration:Number;
      
      private var mDefaultDelayPromoteRemoveTierFrameAnimDuration:Number;
      
      private var mDefaultDelayPromoteFadeTextfieldsAnimDuration:Number;
      
      private var mDefaultDelayPromoteAttachNewFrameAnimDuration:Number;
      
      private var mDefaultPromoteAnimDuration:Number;
      
      private var mPvPMinCardsAmountForPvP:int;
      
      private var mTutorialON:Boolean;
      
      private var mShowShiningFX:Boolean;
      
      private var mPvPGoldGainedPerPvPMatchWon:int;
      
      private var mPvPGoldGainedPerPvPMatchDraw:int;
      
      private var mCardShadowsEnabled:Boolean;
      
      private var mMapLevelItemNormEnabled:Boolean;
      
      private var mMapLevelItemSpecEnabled:Boolean;
      
      private var mCardShowAbilitiesAnimations:Boolean;
      
      private var mMapHideLevelItemsWhenScrolling:Boolean;
      
      private var mMapSaveMapsSWFsInCache:Boolean;
      
      private var mDailyRewardTimeBetweenRewards:Number;
      
      private var mShopInfoCardFactor:Number;
      
      private var mDeckBuilderCreateDeckMinGold:Number;
      
      private var mHasPortraits:Boolean;
      
      private var mHasSkins:Boolean;
      
      private var mLevelToUnlockSacrifice:int;
      
      private var mLevelToUnlockPower:int;
      
      private var mSacrificeCost:int;
      
      private var mFanPageURL:String;
      
      private var mDiscordURL:String;
      
      private var mLanguagesSupported:Dictionary;
      
      private var mActionPointsShowMode:int;
      
      private var mPVPActionPointsLessFor1Player:int;
      
      private var mActivateSuggestPlayable:Boolean;
      
      private var mShowSummonCost:Boolean;
      
      private var mCreditsDevs:String;
      
      private var mCreditsThanks:String;
      
      private var mCreditsHasKickstarter:Boolean;
      
      private var mCreditsGameName:String;
      
      private var mCreditsGameURL:String;
      
      private var mCardsHaveCustomAuras:Boolean;
      
      private var mSocialMaxAmountFriendsSocialPopups:int;
      
      private var mSocialExcludedExtIdsTime:int;
      
      private var mSocialUnlockMapFriendsAmountNeeded:int;
      
      private var miOSAppID:String;
      
      private var mShowFireworksOnLevelComplete:Boolean;
      
      private var mBattleUseDeckBG:Boolean;
      
      private var mBattlePerformAttackLogicOnTargetReached:Boolean;
      
      private var mDefaultReachTargetTransitionTime:Number;
      
      private var mShowAttackButtonTransitionOnTutorial:Boolean;
      
      private var mSacrificeDuration:Number;
      
      private var mCardPlaySoundOnZoomIn:Boolean;
      
      private var mCardPlaySoundOnPromote:Boolean;
      
      private var mCardShowsOnlyMainAbility:Boolean;
      
      private var mShowRankNameInStatsBar:Boolean;
      
      private var mGameHasDungeons:Boolean;
      
      private var mGameShopCardsShowFilter:Boolean;
      
      private var mGameShareRareCards:Boolean;
      
      private var mNoXLTexturesFactor:Number;
      
      private var mCardsBGReducedTexturesFactor:Number;
      
      private var mPortraitGuildEmblemFactor:Number;
      
      private var mUnlockGuildsLevel:int;
      
      private var mUnlockBadgesLevel:int;
      
      private var mUnlockDungeonsLevel:int;
      
      private var mUnlockQuestsLevel:int;
      
      private var mUnlockBattlePassLevel:int;
      
      private var mUnlockRaidsLevel:int;
      
      private var mUnlockAuctionsLevel:int;
      
      private var mGameHasQuests:Boolean;
      
      private var mGameHasBattlePass:Boolean;
      
      private var mXLViewUsesParticles:Boolean;
      
      private var mXLViewUsesXLTextures:Boolean;
      
      private var mXLViewHasPromoteButton:Boolean;
      
      private var mXLViewShowsAbIconsOnCard:Boolean;
      
      private var mXLViewShowsCardBack:Boolean;
      
      private var mXLViewShowsFrames:Boolean;
      
      private var mXLDescriptionAreStats:Boolean;
      
      private var mCardPlaySoundOnDefeat:Boolean;
      
      private var mBattleAttackMovementMode:int;
      
      private var mCardBGType:String;
      
      private var mDeckBuilderUseThumbnails:Boolean;
      
      private var mDeckBuilderSharesCategoriesBG:Boolean;
      
      private var mDeckBuilderUsesSCategoryButtonsAsFactionButtons:Boolean;
      
      private var mDeckBuilderShowsFactionButtons:Boolean;
      
      private var mDeckBuilderShowsSCategoriesButtons:Boolean;
      
      private var mDeckBuilderSortByCategory:Boolean;
      
      private var mDeckBuilderSortByFaction:Boolean;
      
      private var mDeckBuilderSlotInfoAbilityScale:Number;
      
      private var mDeckBuilderCraftMode:Boolean;
      
      private var mCardBGChangesOnPromote:Boolean;
      
      private var mCardBGOverlapsFrame:Boolean;
      
      private var mCardFrameOverlapsBG:Boolean;
      
      private var mMapShowClouds:Boolean;
      
      private var mMapTopButtonsColor:uint;
      
      private var mMapShowLoreOnPlayPopup:Boolean;
      
      private var mCardUseSilhouetteCardShadow:Boolean;
      
      private var mBattleAttackButtonHasBG:Boolean;
      
      private var mBattleAttackButtonHasText:Boolean;
      
      private var mMapUnlockedEffectTitleColor:uint;
      
      private var mLogPanelExtraFontSize:int;
      
      private var mShowBigIconOnPlayLevel:Boolean;
      
      private var mBattleSocketMorphParticles:Boolean;
      
      private var mBattleSocketPvPScale:Number;
      
      private var mBattleSocketScale:Number;
      
      private var mBattleShowAbilitiesPanelOnActionUsed:Boolean;
      
      private var mBattleHasAffinities:Boolean;
      
      private var mFirstFBLoginPackSku:String;
      
      private var mGameHasComic:Boolean;
      
      private var mGameHasTierFrames:Boolean;
      
      private var mGameHasSacrifice:Boolean;
      
      private var mGameHasBadges:Boolean;
      
      private var mGameHasAttachments:Boolean;
      
      private var mGameShowsMovingLogoOnMenuScreen:Boolean;
      
      private var mBattleShowsDamageSplashBG:Boolean;
      
      private var mXLViewHasCustomBG:Boolean;
      
      private var mMapShowsLastMapLevelVisible:Boolean;
      
      private var mMapPlayPopupDeckSelectorVerticalOffset:Number;
      
      private var mMapPlayPopupScoreHorizontalOffset:Number;
      
      private var mMapPlayPopupHorizontalPosFactorNewLevel:Number;
      
      private var mMapPlayPopupHorizontalPosFactorOldLevel:Number;
      
      private var mAppNameSpace:String;
      
      private var mGameBGLoadingNumber:int;
      
      private var mGameLoadingSpinnerHPos:String;
      
      private var mGameLoadingSpinnerVPos:String;
      
      private var mGameLoadingTipHPos:String;
      
      private var mGameLoadingTipVPos:String;
      
      private var mGameLoadingTextShow:Boolean;
      
      private var mGameLoadingFullSize:Boolean;
      
      private var mGameShowAds:Boolean;
      
      private var mGameHasRanks:Boolean;
      
      private var mGameObjectivesShowText:Boolean;
      
      private var mGameObjectivesSmall:Boolean;
      
      private var mMap3DTopOffset:int;
      
      private var mMap3DTopOffsetAndroid:int;
      
      private var mMap3DTopOffsetBrowser:int;
      
      private var mBattleShowRedPanelWhenNoAPLeft:Boolean;
      
      private var mGamePowersActive:Boolean;
      
      private var mBattleNamePanelHasBG:Boolean;
      
      private var mBattleSubobjectiveTextfieldFullSize:Boolean;
      
      private var mBattleHPViewerVibrateOnHit:Boolean;
      
      private var mGameHasActionPointAnimation:Boolean;
      
      private var mGameHasTurnPanelAnimation:Boolean;
      
      private var mBattleAPViewerAnimateTextfield:Boolean;
      
      private var mDeckBuilderStatusWidthPercent:Number;
      
      private var mDeckBuilderStatusHeightPercent:Number;
      
      private var mGraveyardCardCooldown:int;
      
      private var mGameHasGraveyard:Boolean;
      
      private var mBattleLoopEndOfLevelMusic:Boolean;
      
      private var mBattleEnemyPortraitSpecial:Boolean;
      
      private var mGameFadeInTracks:Boolean;
      
      private var mGameHasRaids:Boolean;
      
      private var mRaidTicketsSinglePlayer:FSNumber;
      
      private var mRaidTicketsMultiPlayer:FSNumber;
      
      private var mGuildSeparatorColor:uint;
      
      private var mGuildSeparatorWidthPercentage:Number;
      
      private var mRewardTextfieldColor:uint;
      
      private var mGameHasBuildingBadges:Boolean;
      
      private var mGameVipOfferGold:Boolean;
      
      private var mGameShareImageExtension:String;
      
      private var mShopColorTxtTimeOffer:uint;
      
      private var mShopColorTimeTimeOffer:uint;
      
      private var mPopupTutorialFontName:String;
      
      private var mGameActionsDescShowCost:Boolean;
      
      private var mAuctionTimeFirstRound:FSNumber;
      
      private var mAuctionTimeSecondRound:FSNumber;
      
      private var mAuctionTimeThirdAndMoreRound:FSNumber;
      
      private var mGameHasAuctions:Boolean;
      
      private var mGameCommonColor:uint;
      
      private var mGameUnCommonColor:uint;
      
      private var mGameRareColor:uint;
      
      private var mGameEpicColor:uint;
      
      private var mGameLegendaryColor:uint;
      
      private var mGameMegaLegendaryColor:uint;
      
      private var mGameUltraLegendaryColor:uint;
      
      private var mGameUberLegendaryColor:uint;
      
      private var mBattleHasSimpleUI:Boolean;
      
      private var mBattleTurnsCounterRotates:Boolean;
      
      private var mBattleTurnsCounterSplitIn2:Boolean;
      
      private var mSeasonPvPVictories:FSNumber;
      
      private var mSeasonDungeonVictories:FSNumber;
      
      private var mPvPSeasonRewardsActive:Boolean;
      
      private var mDungeonSeasonRewardsActive:Boolean;
      
      private var mRaidPlayersRecommendedEasy:int;
      
      private var mRaidPlayersRecommendedMedium:int;
      
      private var mRaidPlayersRecommendedHard:int;
      
      private var mRaidPlayersRecommendedExpert:int;
      
      private var mChangeNickGold:FSNumber;
      
      private var mGameHasPassive:Boolean;
      
      private var mFBAppIdProd:String;
      
      private var mFBAppIdDev:String;
      
      private var mFBNamespace:String;
      
      private var mStorageNamespace:String;
      
      private var mKongAPIKey:String;
      
      private var mGameHasAnimatedMenuScreen:Boolean;
      
      private var mGameHasParticlesOnMenuScreen:Boolean;
      
      private var mGameHasSnowParticlesOnMenuScreen:Boolean;
      
      private var mBattleHasOwnMusic:Boolean;
      
      private var mDefaultPopupTitlePercent:Number;
      
      private var mAdMobApiKeyiOS:String;
      
      private var mAdMobApiKeyAndroid:String;
      
      private var mDistriqtApiKeyiOS:String;
      
      private var mDistriqtApiKeyAndroid:String;
      
      private var mCDNKong:String;
      
      private var mGameHasEmblems:Boolean;
      
      private var mShopItemScale:Number;
      
      private var mUnlockMediumDifficulty:int;
      
      private var mUnlockHardDifficulty:int;
      
      private var mGameHasDifficultyLevels:Boolean;
      
      private var mTimeToCheckAuctionInfo:int;
      
      private var mInitialAmountTokens:FSNumber;
      
      private var mMaxAuctionTimerTime:Number;
      
      private var mGameHasClassSystem:Boolean;
      
      private var mDeckBuilderShowRaidVisor:Boolean;
      
      private var mGameHasFusionCards:Boolean;
      
      private var mAndroidAPIKey:String;
      
      private var mCardStatSizeFactor:Number;
      
      private var mCardHasDropShadow:Boolean;
      
      private var mBattlePVPDeckExtraYFactor:Number;
      
      private var mBattleActivateSFXAttackValue:Number;
      
      private var mGameHasFramesByCategory:Boolean;
      
      private var mCardShowSummonCostOnActions:Boolean;
      
      private var mCardPowersSummonCostPosition:String;
      
      private var mMovieclipAnimScaleFactor:Number;
      
      private var mMapShowDifficultyBarLevel:Number;
      
      private var mBattleVoiceOnError:Boolean;
      
      private var mBattleLockDeckWhenNoMana:Boolean;
      
      private var mMapDeckSelectorDisplayAtLevel:int;
      
      private var mBattleIntroShowGlowBG:Boolean;
      
      private var mBattleIntroRotate:Boolean;
      
      private var mBattleIntroLevitate:Boolean;
      
      private var mBattleHasHighlights:Boolean;
      
      private var mCardAttachedAnimOverSocket:Boolean;
      
      private var mGameConfirmationPopupFontName:String;
      
      private var mGameGoldGiftKongRate:int;
      
      private var mMaxCardsByDeckFamilyId:int;
      
      private var mGameHasWorlds:Boolean;
      
      private var mLevelToUnlockReshuffle:int;
      
      private var mGameHasCustomPopups:Boolean;
      
      private var mRewardedVideoCurrency:String;
      
      private var mBattleUnloadFXFolder:Boolean;
      
      private var mCardsMaxAbsIconsPerCol:int;
      
      private var mComicTextColor:uint;
      
      private var mShareHashtag:String;
      
      private var mBattleTurnsUIFactorX:Number;
      
      private var mBattleTurnsUIFactorY:Number;
      
      private var mBattleTurnsUIRotation:Number;
      
      private var mBattleMaxAddition:int;
      
      private var mSteamAppId:int;
      
      private var mCardsReplacements:String;
      
      private var mAbScaleFactor:Number = 0.4;
      
      private var mPvPDeckAreaSocketsUseColors:Boolean;
      
      private var mGameTurnsSimple:Boolean;
      
      private var mGameHasBackgroundsOptions:Boolean;
      
      private var mGameHasRealisticFlamethrower:Boolean;
      
      private var mGameShowsPhysicalCardsDeck:Boolean;
      
      private var mKochavaiOSId:String;
      
      private var mKochavaAndroidId:String;
      
      public function ConfigDef()
      {
         super();
      }
      
      override protected function doFromJSON(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc3_:RegExp = /\r/gi;
         var _loc4_:RegExp = /\n/gi;
         if("defaultLives" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultLives);
            this.mDefaultLives = int(_loc2_);
         }
         if("factionsAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.factionsAmount);
            this.mFactionsAmount = int(_loc2_);
         }
         if("deckCardsAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckCardsAmount);
            this.mDeckCardsAmount = int(_loc2_);
         }
         if("deckDefaultRows" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckDefaultRows);
            this.mDeckDefaultRows = int(_loc2_);
         }
         if("deckDefaultColumns" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckDefaultColumns);
            this.mDeckDefaultColumns = int(_loc2_);
         }
         if("showSpecialFX" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showSpecialFX);
            this.mShowSpecialFX = Utils.stringToBoolean(String(_loc2_));
         }
         if("allowFilters" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.allowFilters);
            this.mAllowFilters = Utils.stringToBoolean(String(_loc2_));
         }
         if("maxBoostsOnScreen" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxBoostsOnScreen);
            this.mMaxBoostsOnScreen = int(_loc2_);
         }
         if("modeOnline" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.modeOnline);
            this.mModeOnline = Utils.stringToBoolean(String(_loc2_));
         }
         if("maxDecksAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxDecksAmount);
            this.mMaxDecksAmount = int(_loc2_);
         }
         if("maxDeckNameChars" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxDeckNameChars);
            this.mMaxDeckNameChars = int(_loc2_);
         }
         if("maxPlayerNameChars" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxPlayerNameChars);
            this.mMaxPlayerNameChars = int(_loc2_);
         }
         if("lifeRegenTime" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.lifeRegenTime);
            this.mLifeRegenTime = Number(_loc2_);
         }
         if("shopMaxCardsPerPack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.shopMaxCardsPerPack);
            this.mShopMaxCardsPerPack = int(_loc2_);
         }
         if("deckBuilderMinCardsAmountForRecycling" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderMinCardsAmountForRecycling);
            this.mDeckBuilderMinCardsAmountForRecycling = int(_loc2_);
         }
         if("defaultAvailableDecksAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultAvailableDecksAmount);
            this.mDefaultAvailableDecksAmount = int(_loc2_);
         }
         if("defaultWeeklyOffersAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultWeeklyOffersAmount);
            this.mDefaultWeeklyOffersAmount = int(_loc2_);
         }
         if("defaultHourlyOffersAmount" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultHourlyOffersAmount);
            this.mDefaultHourlyOffersAmount = int(_loc2_);
         }
         if("defaultTextsUpperCase" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultTextsUpperCase);
            this.mDefaultTextsUpperCase = Utils.stringToBoolean(String(_loc2_));
         }
         if("defaultZoomOutTime" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultZoomOutTime);
            this.mDefaultZoomOutTime = Number(_loc2_);
         }
         if("defaultGeneralSpeedFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultGeneralSpeedFactor);
            this.mDefaultGeneralSpeedFactor = Number(_loc2_);
         }
         if("defaultGeneralSpeedFactorTutorial" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultGeneralSpeedFactorTutorial);
            this.mDefaultGeneralSpeedFactorTutorial = Number(_loc2_);
         }
         if("defaultAbilityAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultAbilityAnimDuration);
            this.mDefaultAbilityAnimDuration = Number(_loc2_);
         }
         if("defaultAttachmentAddedAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultAttachmentAddedAnimDuration);
            this.mDefaultAttachmentAddedAnimDuration = Number(_loc2_);
         }
         if("defaultActionAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultActionAnimDuration);
            this.mDefaultActionAnimDuration = Number(_loc2_);
         }
         if("defaultMoveToBFAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultMoveToBFAnimDuration);
            this.mDefaultMoveToBFAnimDuration = Number(_loc2_);
         }
         if("defaultAttackAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultAttackAnimDuration);
            this.mDefaultAttackAnimDuration = Number(_loc2_);
         }
         if("defaultAttackPortraitAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultAttackPortraitAnimDuration);
            this.mDefaultAttackPortraitAnimDuration = Number(_loc2_);
         }
         if("defaultHighlightDeactivationAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultHighlightDeactivationAnimDuration);
            this.mDefaultHighlightDeactivationAnimDuration = Number(_loc2_);
         }
         if("defaultTriggerOnAttachedAbilitiesDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultTriggerOnAttachedAbilitiesDuration);
            this.mDefaultTriggerOnAttachedAbilitiesDuration = Number(_loc2_);
         }
         if("defaultTriggerAttachmentFadeOffDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultTriggerAttachmentFadeOffDuration);
            this.mDefaultTriggerAttachmentFadeOffDuration = Number(_loc2_);
         }
         if("defaultDeathAnimationDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultDeathAnimationDuration);
            this.mDefaultDeathAnimationDuration = Number(_loc2_);
         }
         if("defaultActionMoveToCenterAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultActionMoveToCenterAnimDuration);
            this.mDefaultActionMoveToCenterAnimDuration = Number(_loc2_);
         }
         if("defaultDelayPromoteRemoveTierFrameAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultDelayPromoteRemoveTierFrameAnimDuration);
            this.mDefaultDelayPromoteRemoveTierFrameAnimDuration = Number(_loc2_);
         }
         if("defaultDelayPromoteFadeTextfieldsAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultDelayPromoteFadeTextfieldsAnimDuration);
            this.mDefaultDelayPromoteFadeTextfieldsAnimDuration = Number(_loc2_);
         }
         if("defaultDelayPromoteAttachNewFrameAnimDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultDelayPromoteAttachNewFrameAnimDuration);
            this.mDefaultDelayPromoteAttachNewFrameAnimDuration = Number(_loc2_);
         }
         if("PvPMinCardsAmountForPvP" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.PvPMinCardsAmountForPvP);
            this.mPvPMinCardsAmountForPvP = int(_loc2_);
         }
         if("tutorialON" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.tutorialON);
            this.mTutorialON = Utils.stringToBoolean(String(_loc2_));
         }
         if("showShinningFX" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showShinningFX);
            this.mShowShiningFX = Utils.stringToBoolean(String(_loc2_));
         }
         if("PvPGoldGainedPerPvPMatchWon" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.PvPGoldGainedPerPvPMatchWon);
            this.mPvPGoldGainedPerPvPMatchWon = int(_loc2_);
         }
         if("PvPGoldGainedPerPvPMatchDraw" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.PvPGoldGainedPerPvPMatchDraw);
            this.mPvPGoldGainedPerPvPMatchDraw = int(_loc2_);
         }
         if("cardShadowsEnabled" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardShadowsEnabled);
            this.mCardShadowsEnabled = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapLevelItemNormEnabled" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapLevelItemNormEnabled);
            this.mMapLevelItemNormEnabled = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapLevelItemSpecEnabled" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapLevelItemSpecEnabled);
            this.mMapLevelItemSpecEnabled = Utils.stringToBoolean(String(_loc2_));
         }
         if("cardShowAbilitiesAnimations" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardShowAbilitiesAnimations);
            this.mCardShowAbilitiesAnimations = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapHideLevelItemsWhenScrolling" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapHideLevelItemsWhenScrolling);
            this.mMapHideLevelItemsWhenScrolling = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapSaveMapsSWFsInCache" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapSaveMapsSWFsInCache);
            this.mMapSaveMapsSWFsInCache = Utils.stringToBoolean(String(_loc2_));
         }
         if("dailyRewardTimeBetweenRewards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.dailyRewardTimeBetweenRewards);
            this.mDailyRewardTimeBetweenRewards = Number(_loc2_);
         }
         if("SocialMaxAmountFriendsSocialPopups" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.SocialMaxAmountFriendsSocialPopups);
            this.mSocialMaxAmountFriendsSocialPopups = int(_loc2_);
         }
         if("socialExcludedExtIdsTime" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.socialExcludedExtIdsTime);
            this.mSocialExcludedExtIdsTime = int(_loc2_);
         }
         if("socialUnlockMapFriendsAmountNeeded" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.socialUnlockMapFriendsAmountNeeded);
            this.mSocialUnlockMapFriendsAmountNeeded = int(_loc2_);
         }
         if("shopCardScaleFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.shopCardScaleFactor);
            this.mShopInfoCardFactor = Number(_loc2_);
         }
         if("deckBuilderCreateDeckMinGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderCreateDeckMinGold);
            this.mDeckBuilderCreateDeckMinGold = Number(_loc2_);
         }
         if("gameHasPortraits" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasPortraits);
            this.mHasPortraits = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasSkins" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasSkins);
            this.mHasSkins = Utils.stringToBoolean(String(_loc2_));
         }
         if("levelToUnlockSacrifice" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.levelToUnlockSacrifice);
            this.mLevelToUnlockSacrifice = int(_loc2_);
         }
         if("levelToUnlockReshuffle" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.levelToUnlockReshuffle);
            this.mLevelToUnlockReshuffle = int(_loc2_);
         }
         if("levelToUnlockPower" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.levelToUnlockPower);
            this.mLevelToUnlockPower = int(_loc2_);
         }
         if("sacrificeCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.sacrificeCost);
            this.mSacrificeCost = int(_loc2_);
         }
         if("showFireworksOnLevelComplete" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showFireworksOnLevelComplete);
            this.mShowFireworksOnLevelComplete = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleUseDeckBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleUseDeckBG);
            this.mBattleUseDeckBG = Utils.stringToBoolean(String(_loc2_));
         }
         if("battlePerformAttackLogicOnTargetReached" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePerformAttackLogicOnTargetReached);
            this.mBattlePerformAttackLogicOnTargetReached = Utils.stringToBoolean(String(_loc2_));
         }
         if("defaultReachTargetTransitionTime" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultReachTargetTransitionTime);
            this.mDefaultReachTargetTransitionTime = Number(_loc2_);
         }
         if("showAttackButtonTransitionOnTutorial" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showAttackButtonTransitionOnTutorial);
            this.mShowAttackButtonTransitionOnTutorial = Utils.stringToBoolean(String(_loc2_));
         }
         if("sacrificeDuration" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.sacrificeDuration);
            this.mSacrificeDuration = Number(_loc2_);
         }
         if("cardPlaySoundOnZoomIn" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardPlaySoundOnZoomIn);
            this.mCardPlaySoundOnZoomIn = Utils.stringToBoolean(String(_loc2_));
         }
         if("cardPlaySoundOnPromote" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardPlaySoundOnPromote);
            this.mCardPlaySoundOnPromote = Utils.stringToBoolean(String(_loc2_));
         }
         if("cardShowsOnlyMainAbility" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardShowsOnlyMainAbility);
            this.mCardShowsOnlyMainAbility = Utils.stringToBoolean(String(_loc2_));
         }
         if("showRankInStatsBar" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showRankInStatsBar);
            this.mShowRankNameInStatsBar = Utils.stringToBoolean(String(_loc2_));
         }
         if("iosAppID" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.iosAppID);
            this.miOSAppID = String(_loc2_);
         }
         if("fanPageURL" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fanPageURL);
            this.mFanPageURL = String(_loc2_);
         }
         if("discordURL" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.discordURL);
            this.mDiscordURL = String(_loc2_);
         }
         if("languages" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.languages);
            _loc5_ = String(_loc2_).split(" ");
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               if(this.mLanguagesSupported == null)
               {
                  this.mLanguagesSupported = new Dictionary(true);
               }
               _loc7_ = 0;
               while(_loc7_ < _loc5_.length)
               {
                  this.mLanguagesSupported[String(_loc5_[_loc7_]).toUpperCase()] = 1;
                  _loc7_++;
               }
            }
         }
         if("gameHasDungeons" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasDungeons);
            this.mGameHasDungeons = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameShopCardsShowFilter" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameShopCardsShowFilter);
            this.mGameShopCardsShowFilter = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameShareRareCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameShareRareCards);
            this.mGameShareRareCards = Utils.stringToBoolean(String(_loc2_));
         }
         if("noXLTexturesFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.noXLTexturesFactor);
            this.mNoXLTexturesFactor = Number(_loc2_);
         }
         if("cardBGTexturesReducedFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardBGTexturesReducedFactor);
            this.mCardsBGReducedTexturesFactor = Number(_loc2_);
         }
         if("portraitGuildEmblemFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.portraitGuildEmblemFactor);
            this.mPortraitGuildEmblemFactor = Number(_loc2_);
         }
         if("unlockGuildsLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockGuildsLevel);
            this.mUnlockGuildsLevel = int(_loc2_);
         }
         if("unlockBadgesLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockBadgesLevel);
            this.mUnlockBadgesLevel = int(_loc2_);
         }
         if("unlockDungeonsLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockDungeonsLevel);
            this.mUnlockDungeonsLevel = int(_loc2_);
         }
         if("unlockQuestsLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockQuestsLevel);
            this.mUnlockQuestsLevel = int(_loc2_);
         }
         if("unlockBattlePassLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockBattlePassLevel);
            this.mUnlockBattlePassLevel = int(_loc2_);
         }
         if("unlockRaidsLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockRaidsLevel);
            this.mUnlockRaidsLevel = int(_loc2_);
         }
         if("unlockAuctionsLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockAuctionsLevel);
            this.mUnlockAuctionsLevel = int(_loc2_);
         }
         if("gameHasQuests" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasQuests);
            this.mGameHasQuests = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasBattlePass" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasBattlePass);
            this.mGameHasBattlePass = Utils.stringToBoolean(String(_loc2_));
         }
         if("actionPointsShowMode" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.actionPointsShowMode);
            this.mActionPointsShowMode = int(String(_loc2_));
         }
         if("PVPActionPointsLessFor1Player" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.PVPActionPointsLessFor1Player);
            this.mPVPActionPointsLessFor1Player = int(String(_loc2_));
         }
         if("XLViewHasParticles" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.XLViewHasParticles);
            this.mXLViewUsesParticles = Utils.stringToBoolean(String(_loc2_));
         }
         if("XLViewUsesXLTextures" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.XLViewUsesXLTextures);
            this.mXLViewUsesXLTextures = Utils.stringToBoolean(String(_loc2_));
         }
         if("XLViewHasPromoteButton" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.XLViewHasPromoteButton);
            this.mXLViewHasPromoteButton = Utils.stringToBoolean(String(_loc2_));
         }
         if("XLViewShowsAbsIcosnOnCard" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.XLViewShowsAbsIcosnOnCard);
            this.mXLViewShowsAbIconsOnCard = Utils.stringToBoolean(String(_loc2_));
         }
         if("XLViewShowsCardsBack" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.XLViewShowsCardsBack);
            this.mXLViewShowsCardBack = Utils.stringToBoolean(String(_loc2_));
         }
         if("XLViewShowsFrames" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.XLViewShowsFrames);
            this.mXLViewShowsFrames = Utils.stringToBoolean(String(_loc2_));
         }
         if("XLDescriptionAreStats" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.XLDescriptionAreStats);
            this.mXLDescriptionAreStats = Utils.stringToBoolean(String(_loc2_));
         }
         if("cardPlaySoundOnDefeat" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardPlaySoundOnDefeat);
            this.mCardPlaySoundOnDefeat = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleAttackMovementMode" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleAttackMovementMode);
            this.mBattleAttackMovementMode = int(String(_loc2_));
         }
         if("cardBGType" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardBGType);
            this.mCardBGType = String(_loc2_);
         }
         if("deckBuilderUseThumbnails" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderUseThumbnails);
            this.mDeckBuilderUseThumbnails = Utils.stringToBoolean(String(_loc2_));
         }
         if("deckBuilderSharesCategoriesBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderSharesCategoriesBG);
            this.mDeckBuilderSharesCategoriesBG = Utils.stringToBoolean(String(_loc2_));
         }
         if("deckBuilderUsesSCategoryButtonsAsFactionButtons" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderUsesSCategoryButtonsAsFactionButtons);
            this.mDeckBuilderUsesSCategoryButtonsAsFactionButtons = Utils.stringToBoolean(String(_loc2_));
         }
         if("deckBuilderShowsFactionButtons" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderShowsFactionButtons);
            this.mDeckBuilderShowsFactionButtons = Utils.stringToBoolean(String(_loc2_));
         }
         if("deckBuilderShowsScategoriesButtons" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderShowsScategoriesButtons);
            this.mDeckBuilderShowsSCategoriesButtons = Utils.stringToBoolean(String(_loc2_));
         }
         if("deckBuilderSortByCategory" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderSortByCategory);
            this.mDeckBuilderSortByCategory = Utils.stringToBoolean(String(_loc2_));
         }
         if("deckBuilderSortByFaction" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderSortByFaction);
            this.mDeckBuilderSortByFaction = Utils.stringToBoolean(String(_loc2_));
         }
         if("deckBuilderSlotInfoAbilityScale" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderSlotInfoAbilityScale);
            this.mDeckBuilderSlotInfoAbilityScale = Number(_loc2_);
         }
         if("cardBGChangesOnPromote" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardBGChangesOnPromote);
            this.mCardBGChangesOnPromote = Utils.stringToBoolean(String(_loc2_));
         }
         if("cardBGOverlapsFrame" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardBGOverlapsFrame);
            this.mCardBGOverlapsFrame = Utils.stringToBoolean(String(_loc2_));
         }
         if("cardFrameOverlapsBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardFrameOverlapsBG);
            this.mCardFrameOverlapsBG = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapShowClouds" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapShowClouds);
            this.mMapShowClouds = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapTopButtonsColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapTopButtonsColor);
            this.mMapTopButtonsColor = uint(_loc2_);
         }
         if("mapShowLoreOnPlayPopup" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapShowLoreOnPlayPopup);
            this.mMapShowLoreOnPlayPopup = Utils.stringToBoolean(String(_loc2_));
         }
         if("activateSuggestPlayable" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.activateSuggestPlayable);
            this.mActivateSuggestPlayable = Utils.stringToBoolean(String(_loc2_));
         }
         if("cardUseSilhouetteCardShadow" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardUseSilhouetteCardShadow);
            this.mCardUseSilhouetteCardShadow = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleAttackButtonHasBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleAttackButtonHasBG);
            this.mBattleAttackButtonHasBG = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleAttackButtonHasText" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleAttackButtonHasText);
            this.mBattleAttackButtonHasText = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapUnlockedEffectTitleColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapUnlockedEffectTitleColor);
            this.mMapUnlockedEffectTitleColor = uint(_loc2_);
         }
         if("logPanelExtraFontSize" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.logPanelExtraFontSize);
            this.mLogPanelExtraFontSize = uint(_loc2_);
         }
         if("showBigIconOnPlayLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showBigIconOnPlayLevel);
            this.mShowBigIconOnPlayLevel = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleSocketMorphParticles" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleSocketMorphParticles);
            this.mBattleSocketMorphParticles = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleSocketPvPScale" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleSocketPvPScale);
            this.mBattleSocketPvPScale = Number(_loc2_);
         }
         if("battleSocketScale" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleSocketScale);
            this.mBattleSocketScale = Number(_loc2_);
         }
         if("battleShowAbilitiesPanelOnActionUsed" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleShowAbilitiesPanelOnActionUsed);
            this.mBattleShowAbilitiesPanelOnActionUsed = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleHasAffinities" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleHasAffinities);
            this.mBattleHasAffinities = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasComic" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasComic);
            this.mGameHasComic = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasTierFrames" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasTierFrames);
            this.mGameHasTierFrames = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasSacrifice" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasSacrifice);
            this.mGameHasSacrifice = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasBadges" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasBadges);
            this.mGameHasBadges = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasAttachments" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasAttachments);
            this.mGameHasAttachments = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameShowsMovingLogoOnMenuScreen" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameShowsMovingLogoOnMenuScreen);
            this.mGameShowsMovingLogoOnMenuScreen = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleShowsDamageSplashBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleShowsDamageSplashBG);
            this.mBattleShowsDamageSplashBG = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleShowRedPanelWhenNoAPLeft" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleShowRedPanelWhenNoAPLeft);
            this.mBattleShowRedPanelWhenNoAPLeft = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleNamePanelHasBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleNamePanelHasBG);
            this.mBattleNamePanelHasBG = Utils.stringToBoolean(String(_loc2_));
         }
         if("XLViewHasCustomBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.XLViewHasCustomBG);
            this.mXLViewHasCustomBG = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapShowsLastMapLevelVisible" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapShowsLastMapLevelVisible);
            this.mMapShowsLastMapLevelVisible = Utils.stringToBoolean(String(_loc2_));
         }
         if("mapPlayPopupDeckSelectorVerticalOffset" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapPlayPopupDeckSelectorVerticalOffset);
            this.mMapPlayPopupDeckSelectorVerticalOffset = Number(_loc2_);
         }
         if("mapPlayPopupScoreHorizontalOffset" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapPlayPopupScoreHorizontalOffset);
            this.mMapPlayPopupScoreHorizontalOffset = Number(_loc2_);
         }
         if("mapPlayPopupLevelHorizontalPosFactorNewLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapPlayPopupLevelHorizontalPosFactorNewLevel);
            this.mMapPlayPopupHorizontalPosFactorNewLevel = Number(_loc2_);
         }
         if("mapPlayPopupLevelHorizontalPosFactorOldLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapPlayPopupLevelHorizontalPosFactorOldLevel);
            this.mMapPlayPopupHorizontalPosFactorOldLevel = Number(_loc2_);
         }
         if("appNameSpace" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.appNameSpace);
            this.mAppNameSpace = String(_loc2_);
         }
         if("firstFBLoginPackSku" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.firstFBLoginPackSku);
            this.mFirstFBLoginPackSku = String(_loc2_);
         }
         if("gameBGLoadingNumber" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameBGLoadingNumber);
            this.mGameBGLoadingNumber = int(_loc2_);
         }
         if("gameShowAds" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameShowAds);
            this.mGameShowAds = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasRanks" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasRanks);
            this.mGameHasRanks = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameObjectivesShowText" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameObjectivesShowText);
            this.mGameObjectivesShowText = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameObjectivesSmall" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameObjectivesSmall);
            this.mGameObjectivesSmall = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameLoadingSpinnerHPos" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameLoadingSpinnerHPos);
            this.mGameLoadingSpinnerHPos = String(_loc2_);
         }
         if("gameLoadingSpinnerVPos" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameLoadingSpinnerVPos);
            this.mGameLoadingSpinnerVPos = String(_loc2_);
         }
         if("gameLoadingTipHPos" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameLoadingTipHPos);
            this.mGameLoadingTipHPos = String(_loc2_);
         }
         if("gameLoadingTipVPos" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameLoadingTipVPos);
            this.mGameLoadingTipVPos = String(_loc2_);
         }
         if("gameLoadingTextShow" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameLoadingTextShow);
            this.mGameLoadingTextShow = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameLoadingTextFullSize" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameLoadingTextFullSize);
            this.mGameLoadingFullSize = Utils.stringToBoolean(String(_loc2_));
         }
         if("showSummonCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.showSummonCost);
            this.mShowSummonCost = Utils.stringToBoolean(String(_loc2_));
         }
         if("map3DTopOffsetAndroid" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.map3DTopOffsetAndroid);
            this.mMap3DTopOffsetAndroid = int(_loc2_);
         }
         if("map3DTopOffsetBrowser" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.map3DTopOffsetBrowser);
            this.mMap3DTopOffsetBrowser = int(_loc2_);
         }
         if("map3DTopOffset" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.map3DTopOffset);
            this.mMap3DTopOffset = int(_loc2_);
         }
         if("deckBuilderCraftMode" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderCraftMode);
            this.mDeckBuilderCraftMode = Utils.stringToBoolean(_loc2_);
         }
         if("gamePowersActive" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gamePowersActive);
            this.mGamePowersActive = Utils.stringToBoolean(_loc2_);
         }
         if("battleSubojectiveTextfieldFullSize" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleSubojectiveTextfieldFullSize);
            this.mBattleSubobjectiveTextfieldFullSize = Utils.stringToBoolean(_loc2_);
         }
         if("battleHPViewerVibrateOnHit" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleHPViewerVibrateOnHit);
            this.mBattleHPViewerVibrateOnHit = Utils.stringToBoolean(_loc2_);
         }
         if("gameHasActionPointAnimation" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasActionPointAnimation);
            this.mGameHasActionPointAnimation = Utils.stringToBoolean(_loc2_);
         }
         if("gameHasTurnPanelAnimation" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasTurnPanelAnimation);
            this.mGameHasTurnPanelAnimation = Utils.stringToBoolean(_loc2_);
         }
         if("battleAPViewerAnimateTextfield" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleAPViewerAnimateTextfield);
            this.mBattleAPViewerAnimateTextfield = Utils.stringToBoolean(_loc2_);
         }
         if("deckBuilderStatusWidthPercent" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderStatusWidthPercent);
            this.mDeckBuilderStatusWidthPercent = Number(_loc2_);
         }
         if("deckBuilderStatusHeightPercent" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderStatusHeightPercent);
            this.mDeckBuilderStatusHeightPercent = Number(_loc2_);
         }
         if("defaultGraveyardCardCooldown" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultGraveyardCardCooldown);
            this.mGraveyardCardCooldown = int(_loc2_);
         }
         if("gameHasGraveyard" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasGraveyard);
            this.mGameHasGraveyard = Utils.stringToBoolean(_loc2_);
         }
         if("battleLoopEndOfLevelMusic" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleLoopEndOfLevelMusic);
            this.mBattleLoopEndOfLevelMusic = Utils.stringToBoolean(_loc2_);
         }
         if("battleEnemyPortraitSpecial" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleEnemyPortraitSpecial);
            this.mBattleEnemyPortraitSpecial = Utils.stringToBoolean(_loc2_);
         }
         if("gameFadeInTracks" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameFadeInTracks);
            this.mGameFadeInTracks = Utils.stringToBoolean(_loc2_);
         }
         if("gameHasRaids" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasRaids);
            this.mGameHasRaids = Utils.stringToBoolean(_loc2_);
         }
         if("raidTicketsSinglePlayer" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidTicketsSinglePlayer);
            if(this.mRaidTicketsSinglePlayer == null)
            {
               this.mRaidTicketsSinglePlayer = new FSNumber();
            }
            this.mRaidTicketsSinglePlayer.value = Number(_loc2_);
         }
         if("raidTicketsMultiPlayer" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidTicketsMultiPlayer);
            if(this.mRaidTicketsMultiPlayer == null)
            {
               this.mRaidTicketsMultiPlayer = new FSNumber();
            }
            this.mRaidTicketsMultiPlayer.value = Number(_loc2_);
         }
         if("guildSeparatorColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.guildSeparatorColor);
            this.mGuildSeparatorColor = uint(_loc2_);
         }
         if("guildSeparatorWidthPercentage" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.guildSeparatorWidthPercentage);
            this.mGuildSeparatorWidthPercentage = Number(_loc2_);
         }
         if("gameRewardTextfieldColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameRewardTextfieldColor);
            this.mRewardTextfieldColor = uint(_loc2_);
         }
         if("gameHasBuildingBadges" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasBuildingBadges);
            this.mGameHasBuildingBadges = Utils.stringToBoolean(_loc2_);
         }
         if("gameVipOfferGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameVipOfferGold);
            this.mGameVipOfferGold = Utils.stringToBoolean(_loc2_);
         }
         if("gameShareImageExtension" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameShareImageExtension);
            this.mGameShareImageExtension = _loc2_;
         }
         if("shopColorTxtTimeOffer" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.shopColorTxtTimeOffer);
            this.mShopColorTxtTimeOffer = uint(_loc2_);
         }
         if("shopColorTimeTimeOffer" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.shopColorTimeTimeOffer);
            this.mShopColorTimeTimeOffer = uint(_loc2_);
         }
         if("gameHowToPlayFontName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHowToPlayFontName);
            this.mPopupTutorialFontName = _loc2_;
         }
         if("gameActionsDescShowCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameActionsDescShowCost);
            this.mGameActionsDescShowCost = Utils.stringToBoolean(_loc2_);
         }
         if("auctionTimeFirstRound" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionTimeFirstRound);
            if(this.mAuctionTimeFirstRound == null)
            {
               this.mAuctionTimeFirstRound = new FSNumber();
            }
            this.mAuctionTimeFirstRound.value = Number(_loc2_);
         }
         if("auctionTimeSecondRound" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionTimeSecondRound);
            if(this.mAuctionTimeSecondRound == null)
            {
               this.mAuctionTimeSecondRound = new FSNumber();
            }
            this.mAuctionTimeSecondRound.value = Number(_loc2_);
         }
         if("auctionTimeThirdAndMoreRound" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.auctionTimeThirdAndMoreRound);
            if(this.mAuctionTimeThirdAndMoreRound == null)
            {
               this.mAuctionTimeThirdAndMoreRound = new FSNumber();
            }
            this.mAuctionTimeThirdAndMoreRound.value = Number(_loc2_);
         }
         if("gameHasAuctions" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasAuctions);
            this.mGameHasAuctions = Utils.stringToBoolean(_loc2_);
         }
         if("gameCommonColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameCommonColor);
            this.mGameCommonColor = uint(_loc2_);
         }
         if("gameUnCommonColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameUnCommonColor);
            this.mGameUnCommonColor = uint(_loc2_);
         }
         if("gameRareColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameRareColor);
            this.mGameRareColor = uint(_loc2_);
         }
         if("gameEpicColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameEpicColor);
            this.mGameEpicColor = uint(_loc2_);
         }
         if("gameLegendaryColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameLegendaryColor);
            this.mGameLegendaryColor = uint(_loc2_);
         }
         if("gameMegaLegendaryColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameMegaLegendaryColor);
            this.mGameMegaLegendaryColor = uint(_loc2_);
         }
         if("gameUltraLegendaryColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameUltraLegendaryColor);
            this.mGameUltraLegendaryColor = uint(_loc2_);
         }
         if("gameUberLegendaryColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameUberLegendaryColor);
            this.mGameUberLegendaryColor = uint(_loc2_);
         }
         if("battleHasSimpleUI" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleHasSimpleUI);
            this.mBattleHasSimpleUI = Utils.stringToBoolean(_loc2_);
         }
         if("battleTurnsCounterRotates" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleTurnsCounterRotates);
            this.mBattleTurnsCounterRotates = Utils.stringToBoolean(_loc2_);
         }
         if("battleTurnsSplitIn2Images" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleTurnsSplitIn2Images);
            this.mBattleTurnsCounterSplitIn2 = Utils.stringToBoolean(_loc2_);
         }
         if("seasonPVPVictories" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.seasonPVPVictories);
            if(this.mSeasonPvPVictories == null)
            {
               this.mSeasonPvPVictories = new FSNumber();
            }
            this.mSeasonPvPVictories.value = Number(_loc2_);
         }
         if("seasonDungeonVictories" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.seasonDungeonVictories);
            if(this.mSeasonDungeonVictories == null)
            {
               this.mSeasonDungeonVictories = new FSNumber();
            }
            this.mSeasonDungeonVictories.value = Number(_loc2_);
         }
         if("pvpSeasonRewardsActive" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pvpSeasonRewardsActive);
            this.mPvPSeasonRewardsActive = Utils.stringToBoolean(_loc2_);
         }
         if("dungeonSeasonRewardsActive" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.dungeonSeasonRewardsActive);
            this.mDungeonSeasonRewardsActive = Utils.stringToBoolean(_loc2_);
         }
         if("raidPlayersRecommendedEasy" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidPlayersRecommendedEasy);
            this.mRaidPlayersRecommendedEasy = int(_loc2_);
         }
         if("raidPlayersRecommendedMedium" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidPlayersRecommendedMedium);
            this.mRaidPlayersRecommendedMedium = int(_loc2_);
         }
         if("raidPlayersRecommendedHard" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidPlayersRecommendedHard);
            this.mRaidPlayersRecommendedHard = int(_loc2_);
         }
         if("raidPlayersRecommendedExpert" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.raidPlayersRecommendedExpert);
            this.mRaidPlayersRecommendedExpert = int(_loc2_);
         }
         if("changeNickGold" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.changeNickGold);
            this.setChangeNickGold(int(_loc2_));
         }
         if("gameHasPassive" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasPassive);
            this.mGameHasPassive = Utils.stringToBoolean(_loc2_);
         }
         if("creditsDevs" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.creditsDevs);
            _loc2_ = _loc2_.replace(_loc3_,"");
            _loc2_ = _loc2_.replace(_loc4_,"\n");
            this.mCreditsDevs = _loc2_;
         }
         if("creditsThanks" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.creditsThanks);
            _loc2_ = _loc2_.replace(_loc3_,"");
            _loc2_ = _loc2_.replace(_loc4_,"\n");
            this.mCreditsThanks = _loc2_;
         }
         if("creditsHasKickstarter" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.creditsHasKickstarter);
            this.mCreditsHasKickstarter = Utils.stringToBoolean(_loc2_);
         }
         if("creditsGameName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.creditsGameName);
            this.mCreditsGameName = _loc2_;
         }
         if("creditsGameURL" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.creditsGameURL);
            this.mCreditsGameURL = _loc2_;
         }
         if("fbAppIdDev" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fbAppIdDev);
            this.mFBAppIdDev = _loc2_;
         }
         if("fbAppIdProd" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fbAppIdProd);
            this.mFBAppIdProd = _loc2_;
         }
         if("fbNamespace" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.fbNamespace);
            this.mFBNamespace = _loc2_;
         }
         if("storageNamespace" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.storageNamespace);
            this.mStorageNamespace = _loc2_;
         }
         if("kongApiKey" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.kongApiKey);
            this.mKongAPIKey = _loc2_;
         }
         if("gameHasAnimatedMenuScreen" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasAnimatedMenuScreen);
            this.mGameHasAnimatedMenuScreen = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasParticlesOnMenuScreen" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasParticlesOnMenuScreen);
            this.mGameHasParticlesOnMenuScreen = Utils.stringToBoolean(String(_loc2_));
         }
         if("gameHasSnowParticlesOnMenuScreen" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasSnowParticlesOnMenuScreen);
            this.mGameHasSnowParticlesOnMenuScreen = Utils.stringToBoolean(String(_loc2_));
         }
         if("battleHasOwnMusic" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleHasOwnMusic);
            this.mBattleHasOwnMusic = Utils.stringToBoolean(String(_loc2_));
         }
         if("defaultPopupTitlePercent" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.defaultPopupTitlePercent);
            this.mDefaultPopupTitlePercent = Number(_loc2_);
         }
         if("adMobApiKeyiOS" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.adMobApiKeyiOS);
            this.mAdMobApiKeyiOS = _loc2_;
         }
         if("adMobApiKeyAndroid" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.adMobApiKeyAndroid);
            this.mAdMobApiKeyAndroid = _loc2_;
         }
         if("distriqtApiKeyiOS" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.distriqtApiKeyiOS);
            this.mDistriqtApiKeyiOS = _loc2_;
         }
         if("distriqtApiKeyAndroid" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.distriqtApiKeyAndroid);
            this.mDistriqtApiKeyAndroid = _loc2_;
         }
         if("gameHasEmblems" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasEmblems);
            this.mGameHasEmblems = Utils.stringToBoolean(_loc2_);
         }
         if("shopItemScale" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.shopItemScale);
            this.mShopItemScale = Number(_loc2_);
         }
         if("unlockMediumDifficulty" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockMediumDifficulty);
            this.mUnlockMediumDifficulty = int(_loc2_);
         }
         if("unlockHardDifficulty" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.unlockHardDifficulty);
            this.mUnlockHardDifficulty = int(_loc2_);
         }
         if("gameHasDifficultyLevels" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasDifficultyLevels);
            this.mGameHasDifficultyLevels = Utils.stringToBoolean(String(_loc2_));
         }
         if("timeToCheckAuctionInfo" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.timeToCheckAuctionInfo);
            this.mTimeToCheckAuctionInfo = int(_loc2_);
         }
         if("initialAmountTokens" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.initialAmountTokens);
            this.setInitialAmountTokens(int(_loc2_));
         }
         if("maxAuctionTimerTime" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxAuctionTimerTime);
            this.mMaxAuctionTimerTime = Number(_loc2_);
         }
         if("gameHasClassSystem" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasClassSystem);
            this.mGameHasClassSystem = Utils.stringToBoolean(_loc2_);
         }
         if("deckBuilderShowRaidVisor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.deckBuilderShowRaidVisor);
            this.mDeckBuilderShowRaidVisor = Utils.stringToBoolean(_loc2_);
         }
         if("gameHasFusionCards" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasFusionCards);
            this.mGameHasFusionCards = Utils.stringToBoolean(_loc2_);
         }
         if("androidAPIKey" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.androidAPIKey);
            this.mAndroidAPIKey = _loc2_;
         }
         if("cardStatsSizeFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardStatsSizeFactor);
            this.mCardStatSizeFactor = Number(_loc2_);
         }
         if("cardHasDropshadow" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardHasDropshadow);
            this.mCardHasDropShadow = Utils.stringToBoolean(_loc2_);
         }
         if("battlePVPDeckExtraYFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battlePVPDeckExtraYFactor);
            this.mBattlePVPDeckExtraYFactor = Number(_loc2_);
         }
         if("battleActivateSFXAttackValue" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleActivateSFXAttackValue);
            this.mBattleActivateSFXAttackValue = Number(_loc2_);
         }
         if("gameHasFramesByCategory" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasFramesByCategory);
            this.mGameHasFramesByCategory = Utils.stringToBoolean(_loc2_);
         }
         if("cardActionsShowSummonCost" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardActionsShowSummonCost);
            this.mCardShowSummonCostOnActions = Utils.stringToBoolean(_loc2_);
         }
         if("cardPowersSummonCostPosition" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardPowersSummonCostPosition);
            this.mCardPowersSummonCostPosition = _loc2_;
         }
         if("gameMovieclipAnimScaleFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameMovieclipAnimScaleFactor);
            this.mMovieclipAnimScaleFactor = Number(_loc2_);
         }
         if("mapShowDifficultyBarLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapShowDifficultyBarLevel);
            this.mMapShowDifficultyBarLevel = Number(_loc2_);
         }
         if("battleVoiceOnError" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleVoiceOnError);
            this.mBattleVoiceOnError = Utils.stringToBoolean(_loc2_);
         }
         if("battleLockDeckWhenNoMana" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleLockDeckWhenNoMana);
            this.mBattleLockDeckWhenNoMana = Utils.stringToBoolean(_loc2_);
         }
         if("mapDeckSelectorDisplayAtLevel" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.mapDeckSelectorDisplayAtLevel);
            this.mMapDeckSelectorDisplayAtLevel = int(_loc2_);
         }
         if("battleIntroShowGlowBG" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleIntroShowGlowBG);
            this.mBattleIntroShowGlowBG = Utils.stringToBoolean(_loc2_);
         }
         if("battleIntroRotate" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleIntroRotate);
            this.mBattleIntroRotate = Utils.stringToBoolean(_loc2_);
         }
         if("battleIntroLevitate" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleIntroLevitate);
            this.mBattleIntroLevitate = Utils.stringToBoolean(_loc2_);
         }
         if("battleShowBGHighlights" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleShowBGHighlights);
            this.mBattleHasHighlights = Utils.stringToBoolean(_loc2_);
         }
         if("cardAtachedAnimOverSocket" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardAtachedAnimOverSocket);
            this.mCardAttachedAnimOverSocket = Utils.stringToBoolean(_loc2_);
         }
         if("gameConfirmationPopupFontName" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameConfirmationPopupFontName);
            this.mGameConfirmationPopupFontName = _loc2_;
         }
         if("gameGoldGiftKongRate" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameGoldGiftKongRate);
            this.mGameGoldGiftKongRate = int(_loc2_);
         }
         if("maxCardsByDeckFamilyId" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.maxCardsByDeckFamilyId);
            this.mMaxCardsByDeckFamilyId = int(_loc2_);
         }
         if("gameHasWorlds" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasWorlds);
            this.mGameHasWorlds = Utils.stringToBoolean(_loc2_);
         }
         if("gameHasCustomPopups" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasCustomPopups);
            this.mGameHasCustomPopups = Utils.stringToBoolean(_loc2_);
         }
         if("gameRewardedVideoCurrency" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameRewardedVideoCurrency);
            this.mRewardedVideoCurrency = String(_loc2_);
         }
         if("battleUnloadFXFolder" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleUnloadFXFolder);
            this.mBattleUnloadFXFolder = Utils.stringToBoolean(_loc2_);
         }
         if("pvpDeckAreaSocketsUseColors" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.pvpDeckAreaSocketsUseColors);
            this.mPvPDeckAreaSocketsUseColors = Utils.stringToBoolean(_loc2_);
         }
         if("gameTurnsSimple" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameTurnsSimple);
            this.mGameTurnsSimple = Utils.stringToBoolean(_loc2_);
         }
         if("gameHasBackgroundsOptions" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasBackgroundsOptions);
            this.mGameHasBackgroundsOptions = Utils.stringToBoolean(_loc2_);
         }
         if("gameHasRealisticFlamethrower" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameHasRealisticFlamethrower);
            this.mGameHasRealisticFlamethrower = Utils.stringToBoolean(_loc2_);
         }
         if("gameShowsPhysicalCardsDeck" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.gameShowsPhysicalCardsDeck);
            this.mGameShowsPhysicalCardsDeck = Utils.stringToBoolean(_loc2_);
         }
         if("cardsMaxAbsIconsPerCol" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardsMaxAbsIconsPerCol);
            this.mCardsMaxAbsIconsPerCol = int(_loc2_);
         }
         if("comicTextColor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.comicTextColor);
            this.mComicTextColor = uint(_loc2_);
         }
         if("shareHashtag" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.shareHashtag);
            this.mShareHashtag = _loc2_;
         }
         if("battleTurnsUIFactorX" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleTurnsUIFactorX);
            this.mBattleTurnsUIFactorX = Number(_loc2_);
         }
         if("battleTurnsUIFactorY" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleTurnsUIFactorY);
            this.mBattleTurnsUIFactorY = Number(_loc2_);
         }
         if("battleTurnsUIRotation" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleTurnsUIRotation);
            this.mBattleTurnsUIRotation = Number(_loc2_);
         }
         if("battleMaxAddition" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.battleMaxAddition);
            this.mBattleMaxAddition = int(_loc2_);
         }
         if("cardHasCustomAuras" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardHasCustomAuras);
            this.mCardsHaveCustomAuras = Utils.stringToBoolean(_loc2_);
         }
         if("steamAppId" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.steamAppId);
            this.mSteamAppId = int(_loc2_);
         }
         if("cardsReplacements" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.cardsReplacements);
            this.manageCardsReplacements(_loc2_);
         }
         if("abScaleFactor" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.abScaleFactor);
            this.mAbScaleFactor = Number(_loc2_);
         }
         if("kochavaiOS" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.kochavaiOS);
            this.mKochavaiOSId = _loc2_;
         }
         if("kochavaAndroid" in param1)
         {
            _loc2_ = Utils.cleanMasterString(param1.kochavaAndroid);
            this.mKochavaAndroidId = _loc2_;
         }
      }
      
      private function manageCardsReplacements(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1 != "" && param1 != null)
         {
            _loc2_ = param1.split("-");
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc2_.length)
               {
                  _loc3_ = String(_loc2_[_loc6_]).split(":")[0];
                  _loc4_ = String(_loc2_[_loc6_]).split(":")[1];
                  _loc5_ = _loc3_ != null && _loc3_.length > 0 ? _loc3_.split(",") : null;
                  if((Boolean(_loc5_)) && _loc5_.length > 0)
                  {
                     _loc7_ = 0;
                     while(_loc7_ < _loc5_.length)
                     {
                        if(FSResourceMng.smCardsReplacements == null)
                        {
                           FSResourceMng.smCardsReplacements = new Dictionary(true);
                        }
                        FSResourceMng.smCardsReplacements[_loc5_[_loc7_]] = _loc4_;
                        _loc7_++;
                     }
                  }
                  _loc6_++;
               }
            }
         }
      }
      
      private function setChangeNickGold(param1:int) : void
      {
         if(this.mChangeNickGold == null)
         {
            this.mChangeNickGold = new FSNumber();
         }
         this.mChangeNickGold.value = param1;
      }
      
      private function setInitialAmountTokens(param1:int) : void
      {
         if(this.mInitialAmountTokens == null)
         {
            this.mInitialAmountTokens = new FSNumber();
         }
         this.mInitialAmountTokens.value = param1;
      }
      
      public function getFactionsAmount() : int
      {
         return this.mFactionsAmount;
      }
      
      public function getDeckCardsAmount() : int
      {
         return this.mDeckCardsAmount;
      }
      
      public function setDeckCardsAmount(param1:int) : void
      {
         this.mDeckCardsAmount = param1;
      }
      
      public function getDeckDefaultRows() : int
      {
         return this.mDeckDefaultRows;
      }
      
      public function getDeckDefaultColumns() : int
      {
         return this.mDeckDefaultColumns;
      }
      
      public function getShowSpecialFX() : Boolean
      {
         return this.mShowSpecialFX;
      }
      
      public function getAllowFilters() : Boolean
      {
         return this.mAllowFilters;
      }
      
      public function getMaxBoostsOnScreen() : int
      {
         return this.mMaxBoostsOnScreen;
      }
      
      public function getModeOnline() : Boolean
      {
         return this.mModeOnline;
      }
      
      public function getMaxDecksAmount() : int
      {
         return this.mMaxDecksAmount;
      }
      
      public function getMaxDeckNameChars() : int
      {
         return this.mMaxDeckNameChars;
      }
      
      public function getMaxPlayerNameChars() : int
      {
         return this.mMaxPlayerNameChars;
      }
      
      public function getDefaultLives() : int
      {
         return this.mDefaultLives;
      }
      
      public function getLifeRegenTime() : Number
      {
         return this.mLifeRegenTime;
      }
      
      public function getShopMaxCardsPerPack() : int
      {
         return this.mShopMaxCardsPerPack;
      }
      
      public function getMinCardsAmountForRecycling() : int
      {
         return this.mDeckBuilderMinCardsAmountForRecycling;
      }
      
      public function getDefaultAvailableDecksAmount() : int
      {
         return this.mDefaultAvailableDecksAmount;
      }
      
      public function getDefaultWeeklyOffersAmount() : int
      {
         return this.mDefaultWeeklyOffersAmount;
      }
      
      public function getDefaultHourlyOffersAmount() : int
      {
         return this.mDefaultHourlyOffersAmount;
      }
      
      public function getDefaultTextsUpperCase() : Boolean
      {
         return this.mDefaultTextsUpperCase;
      }
      
      public function getDefaultZoomOutTime() : Number
      {
         return this.mDefaultZoomOutTime * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultAbilityAnimDuration() : Number
      {
         return this.mDefaultAbilityAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultAttachmentAddedAnimDuration() : Number
      {
         return this.mDefaultAttachmentAddedAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultActionAnimDuration() : Number
      {
         return this.mDefaultActionAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultMoveToBFAnimDuration() : Number
      {
         return this.mDefaultMoveToBFAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultAttackAnimDuration() : Number
      {
         return this.mDefaultAttackAnimDuration * this.getDefaultGeneralSpeedFactor() + this.getDefaultReachTargetTransitionTime();
      }
      
      public function getDefaultAttackPortraitAnimDuration() : Number
      {
         return this.mDefaultAttackPortraitAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultHighlightDeactivationAnimDuration() : Number
      {
         return this.mDefaultHighlightDeactivationAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultTriggerOnAttachedAbilitiesDuration() : Number
      {
         return this.mDefaultTriggerOnAttachedAbilitiesDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultTriggerAttachmentFadeOffDuration() : Number
      {
         return this.mDefaultTriggerAttachmentFadeOffDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultGeneralSpeedFactor() : Number
      {
         var _loc7_:int = 0;
         var _loc1_:LevelDef = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().getLevelDef() : null;
         var _loc2_:Boolean = false;
         var _loc3_:UserData = Utils.getOwnerUserData();
         if(_loc1_)
         {
            _loc7_ = _loc3_ ? _loc3_.getCurrentDifficulty() : UserDataMng.DIFFICULTY_EASY;
            _loc2_ = _loc7_ == UserDataMng.DIFFICULTY_EASY && _loc1_ && _loc1_.isTutorialLevel() && !(_loc1_ is DungeonLevelDef);
         }
         Config.smGameSpeedMultiplier = _loc3_ ? _loc3_.flagsGetGameSpeed() : 1;
         var _loc4_:Boolean = InstanceMng.getBattleEngine() ? InstanceMng.getBattleEngine().isOnlineMatch() : false;
         var _loc5_:Number = 1;
         var _loc6_:Number = 0.75;
         if(_loc4_)
         {
            _loc5_ = 2 * _loc6_;
         }
         else
         {
            _loc5_ = Config.smGameSpeedMultiplier == 1 ? 1.25 : Config.smGameSpeedMultiplier * _loc6_;
         }
         return !_loc2_ ? this.mDefaultGeneralSpeedFactor / _loc5_ : this.mDefaultGeneralSpeedFactorTutorial / _loc5_;
      }
      
      public function getDefaultDeathAnimDuration() : Number
      {
         return this.mDefaultDeathAnimationDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultActionMoveToCenterAnimDuration() : Number
      {
         return this.mDefaultActionMoveToCenterAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultDelayPromoteRemoveTierFrameAnimDuration() : Number
      {
         return this.mDefaultDelayPromoteRemoveTierFrameAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultDelayPromoteFadeTextfieldsAnimDuration() : Number
      {
         return this.mDefaultDelayPromoteFadeTextfieldsAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultDelayPromoteAttachNewFrameAnimDuration() : Number
      {
         return this.mDefaultDelayPromoteAttachNewFrameAnimDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function getDefaultPromoteAnimDuration() : Number
      {
         return this.getDefaultDelayPromoteFadeTextfieldsAnimDuration() + this.getDefaultDelayPromoteAttachNewFrameAnimDuration() + this.getDefaultDelayPromoteRemoveTierFrameAnimDuration();
      }
      
      public function getMinCardsAmountForPvP() : int
      {
         return this.mPvPMinCardsAmountForPvP;
      }
      
      public function getTutorialON() : Boolean
      {
         return this.mTutorialON;
      }
      
      public function getShowShinningFX() : Boolean
      {
         return this.mShowShiningFX;
      }
      
      public function getGoldGainedPerPvPMatchWon() : int
      {
         return this.mPvPGoldGainedPerPvPMatchWon;
      }
      
      public function getGoldGainedPerPvPMatchDraw() : int
      {
         return this.mPvPGoldGainedPerPvPMatchDraw;
      }
      
      public function getCardShadowsEnabled() : Boolean
      {
         return this.mCardShadowsEnabled;
      }
      
      public function getLevelItemNormEnabled() : Boolean
      {
         return this.mMapLevelItemNormEnabled;
      }
      
      public function getLevelItemSpecEnabled() : Boolean
      {
         return this.mMapLevelItemSpecEnabled;
      }
      
      public function getShowAbilitiesAnimations() : Boolean
      {
         return this.mCardShowAbilitiesAnimations;
      }
      
      public function getHideLevelItemsWhenScrolling() : Boolean
      {
         return this.mMapHideLevelItemsWhenScrolling;
      }
      
      public function getSaveMapsSWFsInCache() : Boolean
      {
         return this.mMapSaveMapsSWFsInCache;
      }
      
      public function getDailyRewardTimeBetweenRewards() : Number
      {
         return TimerUtil.hourToMs(this.mDailyRewardTimeBetweenRewards);
      }
      
      public function getMaxAmountFriendsSocialPopups() : Number
      {
         return this.mSocialMaxAmountFriendsSocialPopups;
      }
      
      public function getExcludedExtIdsTime() : Number
      {
         return this.mSocialExcludedExtIdsTime;
      }
      
      public function getUnlockMapFriendsAmountNeeded() : Number
      {
         return this.mSocialUnlockMapFriendsAmountNeeded;
      }
      
      public function getShopInfoCardFactor() : Number
      {
         return this.mShopInfoCardFactor;
      }
      
      public function getCreateFirstDeckMinGoldAmount() : Number
      {
         return this.mDeckBuilderCreateDeckMinGold;
      }
      
      public function hasPortraits() : Boolean
      {
         return this.mHasPortraits;
      }
      
      public function hasSkins() : Boolean
      {
         return this.mHasSkins;
      }
      
      public function getLevelToUnlockSacrifice() : int
      {
         return this.mLevelToUnlockSacrifice;
      }
      
      public function getLevelToUnlockReshuffle() : int
      {
         return this.mLevelToUnlockReshuffle;
      }
      
      public function getLevelToUnlockPower() : int
      {
         return this.mLevelToUnlockPower;
      }
      
      public function getSacrificeCost() : int
      {
         return this.mSacrificeCost;
      }
      
      public function showFireworksOnVictoryAnimation() : Boolean
      {
         return this.mShowFireworksOnLevelComplete;
      }
      
      public function battleUseDeckBG() : Boolean
      {
         return this.mBattleUseDeckBG;
      }
      
      public function getiOSAppID() : String
      {
         return this.miOSAppID;
      }
      
      public function battlePerformAttackLogicOnTargetReached() : Boolean
      {
         return this.mBattlePerformAttackLogicOnTargetReached;
      }
      
      public function getDefaultReachTargetTransitionTime() : Number
      {
         return this.mDefaultReachTargetTransitionTime * this.getDefaultGeneralSpeedFactor();
      }
      
      public function hasToShowAttackButtonTransitionOnTutorial() : Boolean
      {
         return this.mShowAttackButtonTransitionOnTutorial;
      }
      
      public function getSacrificeDuration() : Number
      {
         return this.mSacrificeDuration * this.getDefaultGeneralSpeedFactor();
      }
      
      public function playSoundOnZoomIn() : Boolean
      {
         return this.mCardPlaySoundOnZoomIn;
      }
      
      public function playSoundOnPromote() : Boolean
      {
         return this.mCardPlaySoundOnPromote;
      }
      
      public function cardShowsOnlyMainAbility() : Boolean
      {
         return this.mCardShowsOnlyMainAbility;
      }
      
      public function hasToShowRankNameInStatsBar() : Boolean
      {
         return this.mShowRankNameInStatsBar;
      }
      
      public function getFanPageURL() : String
      {
         var _loc1_:String = "";
         if(Utils.isIOS())
         {
            _loc1_ = "https://m.facebook.com/" + this.mFanPageURL.split("https://www.facebook.com/")[1];
         }
         else
         {
            _loc1_ = this.mFanPageURL;
         }
         return _loc1_;
      }
      
      public function getDiscordURL() : String
      {
         return this.mDiscordURL;
      }
      
      public function getLanguagesSupported() : Dictionary
      {
         return this.mLanguagesSupported;
      }
      
      public function usesDungeons() : Boolean
      {
         return this.mGameHasDungeons;
      }
      
      public function shopCardsShowsFilter() : Boolean
      {
         return this.mGameShopCardsShowFilter;
      }
      
      public function shareRareCards() : Boolean
      {
         return this.mGameShareRareCards;
      }
      
      public function usesRaids() : Boolean
      {
         return this.mGameHasRaids;
      }
      
      public function getNoXLTexturesFactor() : Number
      {
         return this.mCardBGType == "png" && Main.smScaleFactor == 4 ? 1 : this.mNoXLTexturesFactor;
      }
      
      public function getCardsBGReducedTexturesFactor() : Number
      {
         return this.mCardsBGReducedTexturesFactor;
      }
      
      public function getPortraitGuildEmblemFactor() : Number
      {
         return this.mPortraitGuildEmblemFactor;
      }
      
      public function getUnlockGuildsLevel() : int
      {
         return this.mUnlockGuildsLevel;
      }
      
      public function getUnlockBadgesLevel() : int
      {
         return this.mUnlockBadgesLevel;
      }
      
      public function getUnlockDungeonsLevel() : int
      {
         return this.mUnlockDungeonsLevel;
      }
      
      public function getUnlockQuestsLevel() : int
      {
         return this.mUnlockQuestsLevel;
      }
      
      public function getUnlockBattlePassLevel() : int
      {
         return this.mUnlockBattlePassLevel;
      }
      
      public function getUnlockRaidsLevel() : int
      {
         return this.mUnlockRaidsLevel;
      }
      
      public function getUnlockAuctionsLevel() : int
      {
         return this.mUnlockAuctionsLevel;
      }
      
      public function hasQuests() : Boolean
      {
         return this.mGameHasQuests;
      }
      
      public function hasBattlePass() : Boolean
      {
         return this.mGameHasBattlePass;
      }
      
      public function getActionPointsShowMode() : int
      {
         return this.mActionPointsShowMode;
      }
      
      public function getPVPActionPointsLessFor1Player() : int
      {
         return this.mPVPActionPointsLessFor1Player;
      }
      
      public function XLViewUsesParticles() : Boolean
      {
         return this.mXLViewUsesParticles;
      }
      
      public function XLViewUsesXLTextures() : Boolean
      {
         return this.mXLViewUsesXLTextures;
      }
      
      public function XLViewHasPromoteButton() : Boolean
      {
         return this.mXLViewHasPromoteButton;
      }
      
      public function XLViewShowsAbsIconsOnCard() : Boolean
      {
         return this.mXLViewShowsAbIconsOnCard;
      }
      
      public function XLViewShowsCardBack() : Boolean
      {
         return this.mXLViewShowsCardBack;
      }
      
      public function XLViewShowsFrames() : Boolean
      {
         return this.mXLViewShowsFrames;
      }
      
      public function XLDescriptionAreStats() : Boolean
      {
         return this.mXLDescriptionAreStats;
      }
      
      public function playSoundOnDefeat() : Boolean
      {
         return this.mCardPlaySoundOnDefeat;
      }
      
      public function getAttackMovementMode() : int
      {
         return this.mBattleAttackMovementMode;
      }
      
      public function getCardBGType() : String
      {
         return this.mCardBGType;
      }
      
      public function useDeckBuilderThumbnails() : Boolean
      {
         return this.mDeckBuilderUseThumbnails;
      }
      
      public function deckBuilderSharesCategoriesBG() : Boolean
      {
         return this.mDeckBuilderSharesCategoriesBG;
      }
      
      public function deckBuilderUsesSCategoryButtonsAsFactionButtons() : Boolean
      {
         return this.mDeckBuilderUsesSCategoryButtonsAsFactionButtons;
      }
      
      public function deckBuilderShowsFactionButtons() : Boolean
      {
         return this.mDeckBuilderShowsFactionButtons;
      }
      
      public function deckBuilderShowsSCategoriesButtons() : Boolean
      {
         return this.mDeckBuilderShowsSCategoriesButtons;
      }
      
      public function deckBuilderSortByCategory() : Boolean
      {
         return this.mDeckBuilderSortByCategory;
      }
      
      public function deckBuilderSortByFaction() : Boolean
      {
         return this.mDeckBuilderSortByFaction;
      }
      
      public function deckBuilderSlotInfoAbilityScale() : Number
      {
         return this.mDeckBuilderSlotInfoAbilityScale;
      }
      
      public function cardBGChangesOnPromote() : Boolean
      {
         return this.mCardBGChangesOnPromote;
      }
      
      public function cardBGOverlapsFrame() : Boolean
      {
         return this.mCardBGOverlapsFrame;
      }
      
      public function cardFrameOverlapsBG() : Boolean
      {
         return this.mCardFrameOverlapsBG;
      }
      
      public function mapShowClouds() : Boolean
      {
         return this.mMapShowClouds;
      }
      
      public function mapTopButtonsColor() : uint
      {
         return this.mMapTopButtonsColor;
      }
      
      public function mapShowLoreOnPlayPopup() : Boolean
      {
         return this.mMapShowLoreOnPlayPopup;
      }
      
      public function getActivateSuggestPlayable() : Boolean
      {
         return this.mActivateSuggestPlayable;
      }
      
      public function useSilhouetteCardShadow() : Boolean
      {
         return this.mCardUseSilhouetteCardShadow;
      }
      
      public function attackButtonHasBG() : Boolean
      {
         return this.mBattleAttackButtonHasBG;
      }
      
      public function attackButtonHasText() : Boolean
      {
         return this.mBattleAttackButtonHasText;
      }
      
      public function getMapUnlockedEffectTitleColor() : uint
      {
         return this.mMapUnlockedEffectTitleColor;
      }
      
      public function getLogPanelExtraFontSize() : int
      {
         return this.mLogPanelExtraFontSize;
      }
      
      public function showBigIconOnPlayLevelPopup() : Boolean
      {
         return this.mShowBigIconOnPlayLevel;
      }
      
      public function battleSocketMorphParticles() : Boolean
      {
         return this.mBattleSocketMorphParticles;
      }
      
      public function battleSocketPvPScale() : Number
      {
         return this.mBattleSocketPvPScale;
      }
      
      public function battleSocketScale() : Number
      {
         return this.mBattleSocketScale;
      }
      
      public function battleShowAbilitiesPanelOnActionUsed() : Boolean
      {
         return this.mBattleShowAbilitiesPanelOnActionUsed;
      }
      
      public function battleHasAffinities() : Boolean
      {
         return this.mBattleHasAffinities;
      }
      
      public function gameHasComic() : Boolean
      {
         return this.mGameHasComic;
      }
      
      public function gameHasTierFrames() : Boolean
      {
         return this.mGameHasTierFrames;
      }
      
      public function gameHasSacrifice() : Boolean
      {
         return this.mGameHasSacrifice;
      }
      
      public function gameHasBadges() : Boolean
      {
         return this.mGameHasBadges;
      }
      
      public function gameHasAttachments() : Boolean
      {
         return this.mGameHasAttachments;
      }
      
      public function gameShowsMovingLogoOnMenuScreen() : Boolean
      {
         return this.mGameShowsMovingLogoOnMenuScreen;
      }
      
      public function battleShowsDamageSplashBG() : Boolean
      {
         return this.mBattleShowsDamageSplashBG;
      }
      
      public function battleShowRedPanelWhenNoAPLeft() : Boolean
      {
         return this.mBattleShowRedPanelWhenNoAPLeft;
      }
      
      public function battleNamePanelHasBG() : Boolean
      {
         return this.mBattleNamePanelHasBG;
      }
      
      public function XLViewHasCustomBG() : Boolean
      {
         return this.mXLViewHasCustomBG;
      }
      
      public function mapShowsLastMapLevelVisible() : Boolean
      {
         return this.mMapShowsLastMapLevelVisible;
      }
      
      public function mapPlayLevelDeckSelectorVerticalOffset() : Number
      {
         return this.mMapPlayPopupDeckSelectorVerticalOffset;
      }
      
      public function mapPlayLevelScoreHorizontalOffset() : Number
      {
         return this.mMapPlayPopupScoreHorizontalOffset;
      }
      
      public function mapPlayLevelHorizontalPosFactorNewLevel() : Number
      {
         return this.mMapPlayPopupHorizontalPosFactorNewLevel;
      }
      
      public function mapPlayLevelHorizontalPosFactorOldLevel() : Number
      {
         return this.mMapPlayPopupHorizontalPosFactorOldLevel;
      }
      
      public function getAppNameSpace() : String
      {
         return this.mAppNameSpace;
      }
      
      public function getFirstFBLoginPackSku() : String
      {
         return this.mFirstFBLoginPackSku;
      }
      
      public function getGameBGLoadingNumber() : int
      {
         return this.mGameBGLoadingNumber;
      }
      
      public function getGameShowsAds() : Boolean
      {
         return this.mGameShowAds;
      }
      
      public function getGameLoadingSpinnerHPos() : String
      {
         return this.mGameLoadingSpinnerHPos;
      }
      
      public function getGameLoadingTipVPos() : String
      {
         return this.mGameLoadingTipVPos;
      }
      
      public function getGameLoadingTipHPos() : String
      {
         return this.mGameLoadingTipHPos;
      }
      
      public function getGameLoadingSpinnerVPos() : String
      {
         return this.mGameLoadingSpinnerVPos;
      }
      
      public function getGameLoadingTextShow() : Boolean
      {
         return this.mGameLoadingTextShow;
      }
      
      public function gameLoadingFullSize() : Boolean
      {
         return this.mGameLoadingFullSize;
      }
      
      public function getShowSummonCost() : Boolean
      {
         return this.mShowSummonCost;
      }
      
      public function getMap3DTopOffsetPos() : int
      {
         return this.mMap3DTopOffset;
      }
      
      public function getMap3DTopOffsetAndroid() : int
      {
         return this.mMap3DTopOffsetAndroid;
      }
      
      public function getMap3DTopOffsetBrowser() : int
      {
         return this.mMap3DTopOffsetBrowser;
      }
      
      public function getDeckBuilderCraftMode() : Boolean
      {
         return this.mDeckBuilderCraftMode;
      }
      
      public function gameHasRanks() : Boolean
      {
         return this.mGameHasRanks;
      }
      
      public function gameObjectivesShowText() : Boolean
      {
         return this.mGameObjectivesShowText;
      }
      
      public function gameObjectivesSmall() : Boolean
      {
         return this.mGameObjectivesSmall;
      }
      
      public function gameHasPowers() : Boolean
      {
         return this.mGamePowersActive;
      }
      
      public function battleSubobjectiveTextfieldFullSize() : Boolean
      {
         return this.mBattleSubobjectiveTextfieldFullSize;
      }
      
      public function battleHPViewerVibrateOnHit() : Boolean
      {
         return this.mBattleHPViewerVibrateOnHit;
      }
      
      public function gameHasActionPointAnimation() : Boolean
      {
         return this.mGameHasActionPointAnimation;
      }
      
      public function gameHasTurnPanelAnimation() : Boolean
      {
         return this.mGameHasTurnPanelAnimation;
      }
      
      public function battleAPViewerAnimateTextfield() : Boolean
      {
         return this.mBattleAPViewerAnimateTextfield;
      }
      
      public function deckBuilderStatusWidthPercent() : Number
      {
         return this.mDeckBuilderStatusWidthPercent;
      }
      
      public function deckBuilderStatusHeightPercent() : Number
      {
         return this.mDeckBuilderStatusHeightPercent;
      }
      
      public function getGraveyardCardCooldown() : int
      {
         return this.mGraveyardCardCooldown;
      }
      
      public function gameHasGraveyard() : Boolean
      {
         return this.mGameHasGraveyard;
      }
      
      public function battleLoopEndOfLevelMusic() : Boolean
      {
         return this.mBattleLoopEndOfLevelMusic;
      }
      
      public function battleEnemyPortraitSpecial() : Boolean
      {
         return this.mBattleEnemyPortraitSpecial;
      }
      
      public function gameFadeInTracks() : Boolean
      {
         return this.mGameFadeInTracks;
      }
      
      public function getRaidTicketsSinglePlayer() : FSNumber
      {
         return this.mRaidTicketsSinglePlayer;
      }
      
      public function getRaidTicketsMultiPlayer() : FSNumber
      {
         return this.mRaidTicketsMultiPlayer;
      }
      
      public function getGuildSeparatorColor() : uint
      {
         return this.mGuildSeparatorColor;
      }
      
      public function getGuildSeparatorWidthPercentage() : Number
      {
         return this.mGuildSeparatorWidthPercentage;
      }
      
      public function gameRewardTextfieldColor() : uint
      {
         return this.mRewardTextfieldColor;
      }
      
      public function gameHasBuildingBadges() : Boolean
      {
         return this.mGameHasBuildingBadges;
      }
      
      public function getGameVipOfferGold() : Boolean
      {
         return this.mGameVipOfferGold;
      }
      
      public function getGameShareImageExtension() : String
      {
         return this.mGameShareImageExtension;
      }
      
      public function getShopColorTxtTimeOffer() : uint
      {
         return this.mShopColorTxtTimeOffer;
      }
      
      public function getShopColorTimeTimeOffer() : uint
      {
         return this.mShopColorTimeTimeOffer;
      }
      
      public function getTutorialPopupFontName() : String
      {
         return this.mPopupTutorialFontName;
      }
      
      public function gameActionsDescShowCost() : Boolean
      {
         return this.mGameActionsDescShowCost;
      }
      
      public function getAuctionTimeFirstRound() : Number
      {
         return this.mAuctionTimeFirstRound.value;
      }
      
      public function gameHasAuctions() : Boolean
      {
         return this.mGameHasAuctions;
      }
      
      public function getAuctionTimeByRound(param1:int) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 == 1)
         {
            _loc2_ = TimerUtil.minToMs(this.mAuctionTimeFirstRound.value);
         }
         else if(param1 == 2)
         {
            _loc2_ = TimerUtil.minToMs(this.mAuctionTimeSecondRound.value);
         }
         else
         {
            _loc2_ = TimerUtil.minToMs(this.mAuctionTimeThirdAndMoreRound.value);
         }
         return _loc2_;
      }
      
      public function battleHasSimpleUI() : Boolean
      {
         return this.mBattleHasSimpleUI;
      }
      
      public function battleTurnsCounterRotate() : Boolean
      {
         return this.mBattleTurnsCounterRotates;
      }
      
      public function battleTurnsCounterSplitIn2() : Boolean
      {
         return this.mBattleTurnsCounterSplitIn2;
      }
      
      public function getSeasonPvPVictories() : Number
      {
         return this.mSeasonPvPVictories ? this.mSeasonPvPVictories.value : 0;
      }
      
      public function getSeasonDungeonVictories() : Number
      {
         return this.mSeasonDungeonVictories ? this.mSeasonDungeonVictories.value : 0;
      }
      
      public function getPvPSeasonRewardsActive() : Boolean
      {
         return this.mPvPSeasonRewardsActive;
      }
      
      public function getDungeonSeasonRewardsActive() : Boolean
      {
         return this.mDungeonSeasonRewardsActive;
      }
      
      public function gameGetCommonColor() : uint
      {
         return this.mGameCommonColor;
      }
      
      public function gameGetUnCommonColor() : uint
      {
         return this.mGameUnCommonColor;
      }
      
      public function gameGetRareColor() : uint
      {
         return this.mGameRareColor;
      }
      
      public function gameGetEpicColor() : uint
      {
         return this.mGameEpicColor;
      }
      
      public function gameGetLegendaryColor() : uint
      {
         return this.mGameLegendaryColor;
      }
      
      public function gameGetMegaLegendaryColor() : uint
      {
         return this.mGameMegaLegendaryColor;
      }
      
      public function gameGetUltraLegendaryColor() : uint
      {
         return this.mGameUltraLegendaryColor;
      }
      
      public function gameGetUberLegendaryColor() : uint
      {
         return this.mGameUberLegendaryColor;
      }
      
      public function gameCreditsDevs() : String
      {
         return this.mCreditsDevs;
      }
      
      public function gameCreditsThanks() : String
      {
         return this.mCreditsThanks;
      }
      
      public function gameCreditsHasKickstarter() : Boolean
      {
         return this.mCreditsHasKickstarter;
      }
      
      public function gameCreditsGameName() : String
      {
         return this.mCreditsGameName;
      }
      
      public function gameCreditsGameURL() : String
      {
         return this.mCreditsGameURL;
      }
      
      public function fbGetAppId(param1:Boolean) : String
      {
         return param1 ? this.mFBAppIdDev : this.mFBAppIdProd;
      }
      
      public function fbGetNameSpace() : String
      {
         return this.mFBNamespace;
      }
      
      public function getStorageNamespace() : String
      {
         return this.mStorageNamespace;
      }
      
      public function kongGetAPIKey() : String
      {
         return this.mKongAPIKey;
      }
      
      public function getPlayersRecommendedByDifficulty(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 0:
               _loc2_ = this.mRaidPlayersRecommendedEasy.toString();
               break;
            case 1:
               _loc2_ = this.mRaidPlayersRecommendedMedium.toString();
               break;
            case 2:
               _loc2_ = this.mRaidPlayersRecommendedHard.toString();
               break;
            case 3:
               _loc2_ = this.mRaidPlayersRecommendedExpert.toString();
         }
         return _loc2_;
      }
      
      public function getChangeNickGold() : int
      {
         return this.mChangeNickGold ? int(this.mChangeNickGold.value) : 0;
      }
      
      public function gameHasPassive() : Boolean
      {
         return this.mGameHasPassive;
      }
      
      public function gameHasAnimatedMenuScreen() : Boolean
      {
         return this.mGameHasAnimatedMenuScreen;
      }
      
      public function gameHasParticlesOnMenuScreen() : Boolean
      {
         return this.mGameHasParticlesOnMenuScreen;
      }
      
      public function gameHasSnowParticlesOnMenuScreen() : Boolean
      {
         return this.mGameHasSnowParticlesOnMenuScreen;
      }
      
      public function battleHasOwnMusic() : Boolean
      {
         return this.mBattleHasOwnMusic;
      }
      
      public function getDefaultPopupTitlePercent() : Number
      {
         return this.mDefaultPopupTitlePercent;
      }
      
      public function getAdMobApiKeyiOS() : String
      {
         return this.mAdMobApiKeyiOS;
      }
      
      public function getAdMobApiKeyAndroid() : String
      {
         return this.mAdMobApiKeyAndroid;
      }
      
      public function getDistriqtApiKeyiOS() : String
      {
         return this.mDistriqtApiKeyiOS;
      }
      
      public function getDistriqtApiKeyAndroid() : String
      {
         return this.mDistriqtApiKeyAndroid;
      }
      
      public function gameHasEmblems() : Boolean
      {
         return this.mGameHasEmblems;
      }
      
      public function getShopItemScale() : Number
      {
         return this.mShopItemScale;
      }
      
      public function getUnlockMediumDifficulty() : int
      {
         return this.mUnlockMediumDifficulty;
      }
      
      public function getUnlockHardDifficulty() : int
      {
         return this.mUnlockHardDifficulty;
      }
      
      public function gameHasDifficultyLevels() : Boolean
      {
         return this.mGameHasDifficultyLevels;
      }
      
      public function getTimeToCheckAuctionInfo() : Number
      {
         return this.mTimeToCheckAuctionInfo;
      }
      
      public function getInitialAmountTokens() : int
      {
         return this.mInitialAmountTokens ? int(this.mInitialAmountTokens.value) : 0;
      }
      
      public function getMaxAuctionTimerTime() : Number
      {
         return this.mMaxAuctionTimerTime;
      }
      
      public function gameHasClassSystem() : Boolean
      {
         return this.mGameHasClassSystem;
      }
      
      public function getDeckBuilderShowRaidVisor() : Boolean
      {
         return this.mDeckBuilderShowRaidVisor;
      }
      
      public function gameHasFusionCards() : Boolean
      {
         return this.mGameHasFusionCards;
      }
      
      public function getAndroidAPIKey() : String
      {
         return this.mAndroidAPIKey;
      }
      
      public function getCardStatsSizeFactor() : Number
      {
         return this.mCardStatSizeFactor;
      }
      
      public function getCardHasDropShadow() : Boolean
      {
         return this.mCardHasDropShadow;
      }
      
      public function battleGetPvPDeckExtraYFactor() : Number
      {
         return this.mBattlePVPDeckExtraYFactor;
      }
      
      public function battleGetActivateSFXAttackValue() : Number
      {
         return this.mBattleActivateSFXAttackValue;
      }
      
      public function gameHasFramesBySubcategory() : Boolean
      {
         return this.mGameHasFramesByCategory;
      }
      
      public function cardShowSummonCostOnActions() : Boolean
      {
         return this.mCardShowSummonCostOnActions;
      }
      
      public function cardPowerSummonCostPosition() : String
      {
         return this.mCardPowersSummonCostPosition;
      }
      
      public function gameGetMovieclipAnimScaleFactor() : Number
      {
         return this.mMovieclipAnimScaleFactor;
      }
      
      public function getMapShowDifficultyBarLevel() : Number
      {
         return this.mMapShowDifficultyBarLevel;
      }
      
      public function battleGetVoiceOnError() : Boolean
      {
         return this.mBattleVoiceOnError;
      }
      
      public function battleGetLockDeckWhenNoMana() : Boolean
      {
         return this.mBattleLockDeckWhenNoMana;
      }
      
      public function mapGetDeckSelectorDisplayAtLevel() : int
      {
         return this.mMapDeckSelectorDisplayAtLevel;
      }
      
      public function battleIntroShowGlowBG() : Boolean
      {
         return this.mBattleIntroShowGlowBG;
      }
      
      public function battleIntroRotate() : Boolean
      {
         return this.mBattleIntroRotate;
      }
      
      public function battleIntroLevitate() : Boolean
      {
         return this.mBattleIntroLevitate;
      }
      
      public function battleShowBGHighlights() : Boolean
      {
         return this.mBattleHasHighlights;
      }
      
      public function getCardAttachedAnimOverSocket() : Boolean
      {
         return this.mCardAttachedAnimOverSocket;
      }
      
      public function gameGetConfirmationPopupFontName() : String
      {
         return this.mGameConfirmationPopupFontName;
      }
      
      public function gameGetGoldGiftKongRate() : int
      {
         return this.mGameGoldGiftKongRate;
      }
      
      public function getMaxCardsByDeckFamilyId() : int
      {
         return this.mMaxCardsByDeckFamilyId;
      }
      
      public function gameHasWorlds() : Boolean
      {
         return this.mGameHasWorlds;
      }
      
      public function gameHasCustomPopups() : Boolean
      {
         return this.mGameHasCustomPopups;
      }
      
      public function gameRewardedVideoCurrency() : String
      {
         return this.mRewardedVideoCurrency;
      }
      
      public function battleUnloadFXFolder() : Boolean
      {
         return this.mBattleUnloadFXFolder;
      }
      
      public function PvPDeckAreaSocketsUseColors() : Boolean
      {
         return this.mPvPDeckAreaSocketsUseColors;
      }
      
      public function gameTurnsSimple() : Boolean
      {
         return this.mGameTurnsSimple;
      }
      
      public function gameHasBackgroundsOptions() : Boolean
      {
         return this.mGameHasBackgroundsOptions;
      }
      
      public function gameHasRealisticFlamethrower() : Boolean
      {
         return this.mGameHasRealisticFlamethrower;
      }
      
      public function gameShowsPhysicalCardsDeck() : Boolean
      {
         return this.mGameShowsPhysicalCardsDeck;
      }
      
      public function cardsGetMaxAbsIconsPerCol() : int
      {
         return this.mCardsMaxAbsIconsPerCol;
      }
      
      public function getComicTextColor() : uint
      {
         return this.mComicTextColor;
      }
      
      public function getShareHashtag() : String
      {
         return this.mShareHashtag;
      }
      
      public function battleGetTurnsUIFactorX() : Number
      {
         return this.mBattleTurnsUIFactorX;
      }
      
      public function battleGetTurnsUIFactorY() : Number
      {
         return this.mBattleTurnsUIFactorY;
      }
      
      public function battleGetTurnsUIRotation() : Number
      {
         return this.mBattleTurnsUIRotation;
      }
      
      public function battleGetMaxAddition() : int
      {
         return this.mBattleMaxAddition;
      }
      
      public function cardsHaveCustomAuras() : Boolean
      {
         return this.mCardsHaveCustomAuras;
      }
      
      public function getSteamAppId() : int
      {
         return this.mSteamAppId;
      }
      
      public function getAbScaleFactor() : Number
      {
         return this.mAbScaleFactor;
      }
      
      public function getKochavaiOSId() : String
      {
         return this.mKochavaiOSId;
      }
      
      public function getKochavaAndroidId() : String
      {
         return this.mKochavaAndroidId;
      }
   }
}

