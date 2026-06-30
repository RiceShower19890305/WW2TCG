package com.fs.tcgengine.view.cards
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.FSSoundFXMng;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.model.rules.CardDef;
   import com.fs.tcgengine.model.rules.FactionDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.rules.UnitDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSDungeonsScreen;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.FSPvPScreen;
   import com.fs.tcgengine.screens.FSRaidsScreen;
   import com.fs.tcgengine.screens.FSShopScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.buttons.FSMenuButton;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.greensock.easing.Quad;
   import com.greensock.easing.Sine;
   import flash.geom.Point;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.textures.Texture;
   import starling.utils.Align;
   import starling.utils.deg2rad;
   
   public class FSShopInfoCard extends InfoCard implements FSModelUnloadableInterface
   {
      
      public static const FADE_COVER_TRANS_TIME:Number = 1;
      
      private var mCoverFaded:Boolean;
      
      private var mCardHovered:Boolean;
      
      private var mHypeTransitionDone:Boolean;
      
      private var mEffectsDone:Boolean;
      
      private var mShowCover:Boolean;
      
      private var mBackCard:FSImage;
      
      private var mCardSoundNameOnShown:Vector.<String>;
      
      private var mRelativePoint:Point;
      
      public function FSShopInfoCard(param1:FSCard, param2:int, param3:Boolean = true, param4:Boolean = true, param5:Boolean = false)
      {
         super(param1,param2,param3,true);
         touchable = true;
         if(param5)
         {
            this.createCardBack();
         }
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.mShowCover = param4;
         if(this.mShowCover)
         {
            mCard.rotationY = deg2rad(-180);
            mCard.updateCardBackVisibility();
         }
         this.createIdleAnimation();
      }
      
      public function onEnterFrame() : void
      {
         if(this.mCoverFaded && !this.mCardHovered)
         {
            TweenMax.to(mCard,0.5,{
               "rotationX":0,
               "rotationY":0,
               "ease":Sine.easeOut
            });
         }
      }
      
      private function startCoverRotation(param1:Function, param2:Array) : void
      {
         var _loc3_:Number = NaN;
         if(!this.mCoverFaded)
         {
            _loc3_ = 2;
            TweenMax.delayedCall(_loc3_ / 3,param1,param2);
            TweenMax.to(mCard,_loc3_,{
               "rotationX":0,
               "rotationY":0,
               "ease":Elastic.easeOut.config(1,0.5),
               "onComplete":param1,
               "onCompleteParams":param2
            });
         }
      }
      
      public function fadeOffCover(param1:Number, param2:Boolean, param3:Function = null) : void
      {
         var _loc4_:RarityDef = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         if(Boolean(!this.mCoverFaded) && Boolean(mCard) && Boolean(mCard.getCardDef()))
         {
            TweenMax.delayedCall(param1,this.playSound,[Constants.SOUND_UNFOLD_CARD,SoundManager.TYPE_SFX]);
            _loc4_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(mCard.getCardDef().getCardRarity()));
            if(_loc4_ != null && _loc4_.getIndex() > 1)
            {
               _loc5_ = this.getColorByRarity(_loc4_.getIndex());
               _loc6_ = this.getFontNameByRarity(_loc4_.getIndex());
               _loc8_ = _loc4_.getName();
               switch(_loc4_.getIndex())
               {
                  case 3:
                  case 4:
                  case 5:
                  case 6:
                  case 7:
                     _loc7_ = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
                     _loc7_ = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
                     _loc8_ += "!";
                     break;
                  default:
                     _loc7_ = FSResourceMng.FONT_STD_DEFAULT_SIZE;
               }
               TweenMax.delayedCall(param1,this.showParticleText,[_loc8_,_loc5_,mCard,FSResourceMng.FONT_STD_DEFAULT_SIZE,Align.CENTER,Align.TOP,_loc6_]);
               this.onFadeOffCoverCheckHypeTransition(_loc4_,param1,FADE_COVER_TRANS_TIME / 1.5,param3,param2);
            }
            else
            {
               TweenMax.delayedCall(param1,this.startCoverRotation,[this.onCoverFaded,[param2,param3]]);
            }
         }
         else
         {
            TweenMax.killDelayedCallsTo(this.playSound);
            this.playSound(Constants.SOUND_UNFOLD_CARD,SoundManager.TYPE_SFX);
            TweenMax.killDelayedCallsTo(InstanceMng.getTextParticlesMng().showStandardTextParticle);
            this.showParticleText(_loc8_,_loc5_,mCard,FSResourceMng.FONT_STD_DEFAULT_SIZE,Align.CENTER,Align.TOP,_loc6_);
            TweenMax.killDelayedCallsTo(this.performHypeTransition);
            this.onFadeOffCoverCheckHypeTransition(_loc4_,0,FADE_COVER_TRANS_TIME / 1.5,param3,param2);
         }
      }
      
      private function showParticleText(param1:String, param2:uint, param3:*, param4:int = -1, param5:String = "center", param6:String = "center", param7:String = "") : void
      {
         if(!this.mEffectsDone)
         {
            this.mEffectsDone = true;
            if(mCard)
            {
               InstanceMng.getTextParticlesMng().showStandardTextParticle(param1,param2,mCard,FSResourceMng.FONT_STD_DEFAULT_SIZE,Align.CENTER,Align.TOP,param7);
            }
         }
      }
      
      private function playSound(param1:String, param2:int) : void
      {
         if(!this.mEffectsDone)
         {
            Utils.playSound(param1,param2);
         }
      }
      
      protected function getColorByRarity(param1:int) : uint
      {
         var _loc2_:uint = 16777215;
         switch(param1)
         {
            case 3:
               _loc2_ = Config.getConfig().gameGetEpicColor();
               break;
            case 4:
               _loc2_ = Config.getConfig().gameGetLegendaryColor();
               break;
            case 5:
               _loc2_ = Config.getConfig().gameGetMegaLegendaryColor();
               break;
            case 6:
               _loc2_ = Config.getConfig().gameGetUltraLegendaryColor();
               break;
            case 7:
               _loc2_ = Config.getConfig().gameGetUberLegendaryColor();
         }
         return _loc2_;
      }
      
      protected function getFontNameByRarity(param1:int) : String
      {
         var _loc2_:String = FSResourceMng.getFontByType();
         switch(param1)
         {
            case 3:
               _loc2_ = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_BLUE);
               break;
            case 4:
            case 5:
            case 6:
            case 7:
               _loc2_ = FSResourceMng.getFontByType();
         }
         return _loc2_;
      }
      
      protected function onFadeOffCoverCheckHypeTransition(param1:RarityDef, param2:Number, param3:Number, param4:Function = null, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         if(!this.mCoverFaded)
         {
            if(param1 != null)
            {
               _loc6_ = param1.getIndex();
               if(_loc6_ > 2)
               {
                  TweenMax.delayedCall(param2,this.startCoverRotation,[this.onCoverFaded,[param5,null]]);
                  TweenMax.delayedCall(param2,this.performHypeTransition,[param1,param3,param4]);
               }
               else
               {
                  TweenMax.delayedCall(param2,this.startCoverRotation,[this.onCoverFaded,[param5,param4]]);
               }
            }
         }
      }
      
      private function performHypeTransition(param1:RarityDef, param2:Number, param3:Function = null) : void
      {
         var _loc4_:Number = NaN;
         if(!this.mHypeTransitionDone)
         {
            this.mHypeTransitionDone = true;
            this.mEffectsDone = true;
            if(param1)
            {
               _loc4_ = param1.getIndex() == 3 ? 1.3 : 1.6;
               SpecialFX.createYoYoZoomTransition(mCard,_loc4_,param2,1,param3,null,false);
            }
         }
      }
      
      public function onCoverFaded(param1:Boolean, param2:Function = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:RarityDef = null;
         var _loc6_:String = null;
         this.mCoverFaded = true;
         if(InstanceMng.getRaritiesDefMng() != null && mCard != null && mCard.getCardDef() != null)
         {
            _loc3_ = "";
            _loc4_ = "";
            _loc5_ = RarityDef(InstanceMng.getRaritiesDefMng().getDefBySku(mCard.getCardDef().getCardRarity()));
            if(_loc5_ != null)
            {
               _loc3_ = this.getRarityCardSound(_loc5_);
            }
            if(_loc3_ != "")
            {
               Utils.playSound(_loc3_,SoundManager.TYPE_SFX);
            }
            if(_loc5_.getIndex() >= 3)
            {
               TweenMax.delayedCall(0.25,Utils.requestScreenShake,[0.5,3]);
            }
            _loc4_ = InstanceMng.getSoundFXMng().playCardSound(mCard,FSSoundFXMng.CARD_MOVED_TO_BF);
            this.mCardSoundNameOnShown = Utils.addStringToStringsVector(this.mCardSoundNameOnShown,_loc4_);
            _loc6_ = mCard is FSUnit ? UnitDef(mCard.getCardDef()).getOnPlaySound() : "";
            if(_loc6_ != null && _loc6_ != "" && _loc6_ != _loc4_)
            {
               InstanceMng.getSoundFXMng().playCardSound(mCard,FSSoundFXMng.PROMOTE);
            }
            this.mCardSoundNameOnShown = Utils.addStringToStringsVector(this.mCardSoundNameOnShown,_loc6_);
            mCard.touchable = true;
            this.manageShareButton(_loc5_);
            if(param2 != null)
            {
               param2();
            }
         }
      }
      
      protected function getRarityCardSound(param1:RarityDef) : String
      {
         var _loc2_:String = "";
         switch(param1.getIndex())
         {
            case 3:
               _loc2_ = Constants.SOUND_UNFOLD_RARE_CARD;
               break;
            case 4:
            case 5:
            case 6:
            case 7:
               _loc2_ = Constants.SOUND_UNFOLD_EPIC_CARD;
         }
         return _loc2_;
      }
      
      protected function manageShareButton(param1:RarityDef) : void
      {
         var _loc2_:Boolean = false;
         switch(param1.getIndex())
         {
            case 2:
               if(Config.getConfig().shareRareCards())
               {
                  _loc2_ = true;
                  InstanceMng.getCardAnimsMng().requestRareCardUnfolded(this);
               }
               break;
            case 3:
               _loc2_ = true;
               InstanceMng.getCardAnimsMng().requestEpicCardUnfolded(this);
               break;
            case 4:
            case 5:
            case 6:
            case 7:
               _loc2_ = true;
               InstanceMng.getCardAnimsMng().requestOrangeCardUnfolded(this);
         }
         if(_loc2_)
         {
            if(Config.HAS_GUILDS)
            {
               InstanceMng.getGuildsMng().notifyCardReceivedToGuild(mCard.getCardDef());
            }
            TweenMax.delayedCall(0.5,this.showShareButton);
         }
      }
      
      protected function showShareButton() : void
      {
         var _loc1_:FSMenuButton = null;
         if(!Utils.isDesktop())
         {
            if(mCard)
            {
               _loc1_ = new FSMenuButton(Constants.SOCIAL_SHARE_BUTTON_XS,"",this.onShareButtonTriggered);
               _loc1_.setFontProperties(FSResourceMng.getFontByType(),FSResourceMng.FONT_STD_SMALL_SIZE);
               _loc1_.x = mCard.x - mCard.width / 2 + _loc1_.width / 2;
               _loc1_.y = mCard.y - mCard.height / 2 + _loc1_.height / 2;
               addChild(_loc1_);
            }
         }
      }
      
      private function onShareButtonTriggered(param1:Event) : void
      {
         if(InstanceMng.getFacebookPlugin() != null && InstanceMng.getFacebookPlugin().isSessionOpen() || InstanceMng.getApplication().isKongregateVersion())
         {
            this.shareCardReceived();
         }
         else if(InstanceMng.getFacebookPlugin() != null && !InstanceMng.getApplication().isKongregateVersion())
         {
            InstanceMng.getFacebookPlugin().login(this.shareCardReceived);
         }
      }
      
      private function shareCardReceived() : void
      {
         if(InstanceMng.getFacebookPlugin() != null && InstanceMng.getFacebookPlugin().isSessionOpen() && mCard != null)
         {
            InstanceMng.getFacebookPlugin().shareCardReceived(mCard.getCardDef(),750);
         }
         else if(mCard != null && InstanceMng.getApplication().isKongregateVersion())
         {
            InstanceMng.getApplication().kongShareCardReceived(mCard.getCardDef());
         }
      }
      
      override protected function onTouch(param1:TouchEvent) : void
      {
         var _loc4_:Popup = null;
         var _loc5_:Screen = null;
         var _loc2_:Popup = InstanceMng.getPopupMng().getPopupShown();
         var _loc3_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(!Root.assets.isLoading && Boolean(_loc3_))
         {
            if(!this.mShowCover || this.mShowCover && this.mCoverFaded)
            {
               _loc4_ = InstanceMng.getPopupMng().getPopupShown();
               if(_loc4_ != null)
               {
                  _loc4_.visible = false;
               }
               _loc5_ = InstanceMng.getCurrentScreen();
               if(_loc5_ is FSShopScreen || _loc5_ is FSBattleScreen || _loc5_ is FSMapScreen || _loc5_ is FSRaidsScreen || _loc5_ is FSPvPScreen || _loc5_ is FSDungeonsScreen)
               {
                  _loc5_.setSelectedCard(mCard);
               }
               SpecialFX.zoomIn(mCard);
               _loc3_ = param1.getTouch(this,TouchPhase.HOVER);
               alpha = _loc3_ ? 0.95 : 1;
            }
            else
            {
               this.fadeOffCover(0,false);
            }
         }
         _loc3_ = param1.getTouch(mCard,TouchPhase.HOVER);
         if(Boolean(_loc3_) && this.mCoverFaded)
         {
            SpecialFX.handle3DEffect(mCard,_loc3_,this.mRelativePoint);
         }
         this.mCardHovered = _loc3_ != null;
         if(_loc3_)
         {
            checkIfNewCardGlowNeedsToBeRemoved();
         }
      }
      
      public function createCardBack() : void
      {
         var _loc1_:CardDef = null;
         var _loc2_:FactionDef = null;
         var _loc3_:String = null;
         var _loc4_:Texture = null;
         if(mCard)
         {
            _loc1_ = mCard.getCardDef();
            if(_loc1_)
            {
               _loc2_ = FactionDef(InstanceMng.getFactionsDefMng().getDefBySku(_loc1_.getFactionSku()));
               _loc3_ = _loc2_ ? _loc2_.getBackBGName() : "";
               _loc4_ = _loc3_ != "" ? Root.assets.getTexture(_loc3_) : null;
               if(_loc4_)
               {
                  if(this.mBackCard == null)
                  {
                     this.mBackCard = new FSImage(_loc4_);
                     this.mBackCard.alignPivot();
                     this.mBackCard.x = mCard.getFrameBG() ? mCard.getFrameBG().x + mCard.getFrameBG().width / 2 : x + width / 2;
                     this.mBackCard.y = mCard.getFrameBG() ? mCard.getFrameBG().y + mCard.getFrameBG().height / 2 : y + height / 2;
                     addChildAt(this.mBackCard,0);
                     this.startCardBackFX();
                  }
               }
            }
         }
      }
      
      public function showCardsBack() : Boolean
      {
         return Config.getConfig().XLViewShowsCardBack();
      }
      
      private function startCardBackFX() : void
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:int = 0;
         if(Boolean(this.mBackCard) && Boolean(mCard.getFrameBG()))
         {
            _loc1_ = new FSCoordinate(mCard.getFrameBG().x + mCard.getFrameBG().width / 2.75,mCard.getFrameBG().y + mCard.getFrameBG().height / 1.75);
            _loc2_ = -10;
            SpecialFX.tweenRotate(this.mBackCard,1,0,Sine.easeOut,-10);
            SpecialFX.createTransition(this.mBackCard,_loc1_,1,0,null,null,Sine.easeOut);
         }
      }
      
      override public function dispose() : void
      {
         this.destroy();
         super.dispose();
      }
      
      public function destroy() : void
      {
         TweenMax.killTweensOf(this);
         if(this.mBackCard)
         {
            this.mBackCard.removeFromParent();
            this.mBackCard.destroy();
            this.mBackCard = null;
         }
         this.mRelativePoint = null;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function createIdleAnimation() : void
      {
         var _loc1_:FSCoordinate = new FSCoordinate(mCard.x,mCard.y + 6);
         var _loc2_:Number = Utils.randomNumber(0,1.5);
         TweenMax.delayedCall(_loc2_,SpecialFX.createYoYoTransition,[mCard,_loc1_,3,-1,null,Quad.easeInOut]);
      }
      
      public function getSoundsUsed() : Vector.<String>
      {
         return this.mCardSoundNameOnShown;
      }
   }
}

