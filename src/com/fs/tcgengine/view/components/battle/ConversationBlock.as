package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.TutorialMng;
   import com.fs.tcgengine.model.rules.ConversationDef;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.PortraitDef;
   import com.fs.tcgengine.model.rules.RankDef;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.CustomComponent;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class ConversationBlock extends Component
   {
      
      private const LOAD_ON_DEMAND:Boolean = false;
      
      private var mBG:CustomComponent;
      
      private var mLoreTextfield:FSTextfield;
      
      private var mConversationDef:ConversationDef;
      
      private var mHeroCharacterDef:HeroCharacterDef;
      
      private var mResourcesLoaded:Boolean = false;
      
      private var mLoadResources:Boolean;
      
      private var mBFUserPortrait:FSBattlefieldUserPortrait;
      
      public function ConversationBlock()
      {
         super();
      }
      
      public function init(param1:ConversationDef, param2:Boolean) : void
      {
         this.mConversationDef = param1;
         this.mLoadResources = param2;
         this.mHeroCharacterDef = HeroCharacterDef(InstanceMng.getHeroCharactersDefMng().getDefBySku(this.mConversationDef.getHeroSku()));
         if(this.mResourcesLoaded || !this.LOAD_ON_DEMAND)
         {
            this.createUI();
            this.show();
         }
         else
         {
            this.setResourcesToLoad();
         }
      }
      
      private function show() : void
      {
         var _loc1_:FSCoordinate = null;
         addEventListener(TouchEvent.TOUCH,this.onTouch);
         if(Utils.isMobile())
         {
            scale = Utils.isTablet() ? 1.5 : 2;
         }
         _loc1_ = new FSCoordinate();
         if(this.mHeroCharacterDef.isEnemy())
         {
            x = Starling.current.stage.stageWidth;
            y = height * 0.2;
            _loc1_.setX(Starling.current.stage.stageWidth - width * 1.1);
            _loc1_.setY(y);
         }
         else
         {
            x = -width;
            y = Starling.current.stage.stageHeight - height * 1.2;
            _loc1_.setX(Starling.current.stage.stageWidth * 0.1);
            _loc1_.setY(y);
         }
         InstanceMng.getCurrentScreen().addChild(this);
         Utils.playSound(Constants.SOUND_CONVERSATION_RECEIVED,SoundManager.TYPE_SFX);
         SpecialFX.createTransition(this,_loc1_,0.5,0,null,null,Expo.easeOut);
         var _loc2_:Number = this.mConversationDef ? this.mConversationDef.getFadeTime() : 2;
         TweenMax.delayedCall(_loc2_,this.removeConversationChat);
      }
      
      public function removeConversationChat(param1:Boolean = true) : void
      {
         Utils.stopSound(Constants.SOUND_CONVERSATION_RECEIVED);
         TweenMax.killDelayedCallsTo(this.removeConversationChat);
         SpecialFX.tweenToAlpha(this,0.001,0.4,0,this.onConversationFaded);
         if(InstanceMng.getCurrentScreen() is FSBattleScreen)
         {
            FSBattleScreen(InstanceMng.getCurrentScreen()).lockUI(false);
         }
         if(param1)
         {
            if(InstanceMng.getConversationsMng())
            {
               InstanceMng.getConversationsMng().removeConversationBlockBeingShown(this);
               if(this.mConversationDef != null && this.mConversationDef.getCallKey() == "custom")
               {
                  InstanceMng.getConversationsMng().unloadCustomConversation(this.mConversationDef);
               }
            }
         }
      }
      
      private function onConversationFaded() : void
      {
         this.removeFromDisplayList(false);
      }
      
      private function setResourcesToLoad() : void
      {
         var _loc1_:RankDef = RankDef(InstanceMng.getRanksDefMng().getDefBySku(this.mHeroCharacterDef.getRankSku()));
         var _loc2_:String = this.mHeroCharacterDef.getPortraitSku();
         var _loc3_:PortraitDef = PortraitDef(InstanceMng.getPortraitsDefMng().getDefBySku(_loc2_));
         var _loc4_:String = _loc3_.getRankFrameBG();
         if(!Config.smPortraitFramesInAtlas)
         {
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc4_,FSResourceMng.TYPE_TEXTURE_PNG);
            InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + _loc1_.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
         }
         InstanceMng.getResourcesMng().addResourceToLoad("portraits/" + this.mHeroCharacterDef.getBGImageName(),FSResourceMng.TYPE_TEXTURE_PNG);
         if(!Root.assets.isLoading)
         {
            InstanceMng.getResourcesMng().loadAssets(this.notifyAssetsLoaded);
         }
         else
         {
            setTimeout(this.setResourcesToLoad,1000);
         }
      }
      
      public function notifyAssetsLoaded() : void
      {
         this.mResourcesLoaded = true;
         this.createUI();
         this.show();
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            this.removeConversationChat();
         }
      }
      
      private function createUI() : void
      {
         this.createBFPortrait();
         this.createBG();
         this.fillConversationText();
      }
      
      private function createBFPortrait() : void
      {
         if(this.mBFUserPortrait == null)
         {
            this.mBFUserPortrait = InstanceMng.getResourcesMng().createUserBattlefieldPortrait(false,"",this.mHeroCharacterDef.getSku(),true);
            addChild(this.mBFUserPortrait);
         }
      }
      
      private function createBG() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mBG == null)
         {
            this.mBG = Utils.createCustomBox(TutorialMng.TUTORIAL_PANEL_CONVERSATION_BG_NAME,768);
            _loc1_ = this.mBFUserPortrait.getFrameContainer() ? int(this.mBFUserPortrait.getFrameContainer().height) : 0;
            _loc2_ = this.mBFUserPortrait.getFrameContainer() ? int(this.mBFUserPortrait.getFrameContainer().width) : 0;
            this.mBG.y = this.mBFUserPortrait.getNameFrame() ? this.mBFUserPortrait.y + this.mBFUserPortrait.getNameFrame().height * 1.4 : this.mBFUserPortrait.y - (this.mBG.height - _loc1_) / 2;
            if(this.mBFUserPortrait)
            {
               this.mBFUserPortrait.x = this.mHeroCharacterDef.isEnemy() ? this.mBG.width - _loc2_ : 0;
            }
            addChildAt(this.mBG,0);
         }
      }
      
      private function fillConversationText() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         if(this.mLoreTextfield == null)
         {
            _loc1_ = Config.getConfig().getTutorialPopupFontName();
            this.mLoreTextfield = new FSTextfield(1,this.mBG.height * 0.75,TextManager.getText(this.mConversationDef.getText()),0);
            this.mLoreTextfield.fontName = FSResourceMng.getFontByType(_loc1_);
            this.mLoreTextfield.format.bold = !FSResourceMng.isOriental();
            if(Utils.isDesktop())
            {
               this.mLoreTextfield.fontSize = FSResourceMng.FONT_STD_SMALL_SIZE;
            }
            if(!this.mHeroCharacterDef.isEnemy())
            {
               _loc2_ = this.mBFUserPortrait.x + this.mBFUserPortrait.getFrameContainer().x + this.mBFUserPortrait.getFrameContainer().width;
               this.mLoreTextfield.width = this.mBG.width * 0.93 - _loc2_;
               this.mLoreTextfield.x = _loc2_;
            }
            else
            {
               this.mLoreTextfield.width = this.mBG.width * 0.98 - this.mBFUserPortrait.getUsefulWidth();
               this.mLoreTextfield.x = 10;
            }
            this.mLoreTextfield.y = this.mBG.y + (this.mBG.height - this.mLoreTextfield.height) / 2;
            addChild(this.mLoreTextfield);
         }
      }
      
      public function removeFromDisplayList(param1:Boolean = false) : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(param1);
            this.mBG = null;
         }
         if(this.mLoreTextfield)
         {
            this.mLoreTextfield.removeFromParent(param1);
            this.mLoreTextfield = null;
         }
         this.mConversationDef = null;
         this.mHeroCharacterDef = null;
         if(this.mBFUserPortrait)
         {
            this.mBFUserPortrait.removeFromParent(param1);
            this.mBFUserPortrait = null;
         }
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         this.removeFromDisplayList(true);
         removeEventListener(TouchEvent.TOUCH,this.onTouch);
         super.dispose();
      }
   }
}

