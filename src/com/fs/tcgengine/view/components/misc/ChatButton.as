package com.fs.tcgengine.view.components.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.controller.ServerConnection;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.userdata.UserBattleInfoPvP;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.TimerUtil;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.battle.FSBattlefieldUserPortrait;
   import com.fs.tcgengine.view.components.buttons.FSButton;
   import com.greensock.TweenMax;
   import flash.utils.setTimeout;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class ChatButton extends Component
   {
      
      public static const CHAT_GOOD_LUCK:int = 0;
      
      public static const CHAT_WELL_PLAYED:int = 1;
      
      public static const CHAT_THANKS:int = 2;
      
      public static const CHAT_GOOD_GAME:int = 3;
      
      public static const CHAT_MY_BAD:int = 4;
      
      public static const CHAT_WOW:int = 5;
      
      public static const CHATS_AMOUNT:int = 6;
      
      private var mChatIcon:FSButton;
      
      private var mMuteChatIcon:FSButton;
      
      private var mChatCarrousselShown:Boolean = false;
      
      private var mPremadeChats:Vector.<FSButton>;
      
      private var mLastMessageSentTimestamp:Number = -1;
      
      public function ChatButton()
      {
         super();
         this.createUI();
         Utils.alignComponentAndFixPosition(this);
      }
      
      private function createUI() : void
      {
         this.createChatIcon();
         this.createMuteChatIcon();
      }
      
      private function createChatIcon() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         if(this.mChatIcon == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsChatOn();
            _loc2_ = _loc1_ ? "chat_icon" : "chat_icon_silenced";
            this.mChatIcon = new FSButton(Root.assets.getTexture(_loc2_));
            this.mChatIcon.addEventListener(Event.TRIGGERED,this.onChatIconTriggered);
            this.mChatIcon.x += this.mChatIcon.width / 2;
            addChild(this.mChatIcon);
         }
      }
      
      private function createMuteChatIcon() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         if(this.mMuteChatIcon == null)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsChatOn();
            _loc2_ = _loc1_ ? "chat_icon_muted" : "chat_icon";
            this.mMuteChatIcon = new FSButton(Root.assets.getTexture(_loc2_));
            this.mMuteChatIcon.visible = false;
            this.mMuteChatIcon.addEventListener(Event.TRIGGERED,this.onMuteChatIconTriggered);
            this.mMuteChatIcon.x = this.mChatIcon.x;
            this.mMuteChatIcon.y = this.mChatIcon.y - this.mChatIcon.height;
            addChild(this.mMuteChatIcon);
         }
      }
      
      private function onMuteChatIconTriggered() : void
      {
         var _loc2_:String = null;
         var _loc1_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().flagsChatOn();
         InstanceMng.getUserDataMng().getOwnerUserData().setChat(!_loc1_);
         InstanceMng.getUserDataMng().updateFlags();
         _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsChatOn();
         this.mMuteChatIcon.visible = false;
         if(this.mChatIcon)
         {
            _loc2_ = _loc1_ ? "chat_icon" : "chat_icon_silenced";
            this.mChatIcon.upState = Root.assets.getTexture(_loc2_);
            this.mChatIcon.downState = Root.assets.getTexture(_loc2_);
         }
         if(!_loc1_)
         {
            this.hideChatCarroussel();
         }
         else
         {
            this.onChatActivatedPerformOps();
         }
      }
      
      private function onChatIconTriggered() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.mChatCarrousselShown = !this.mChatCarrousselShown;
         if(this.mChatCarrousselShown)
         {
            _loc1_ = InstanceMng.getUserDataMng().getOwnerUserData().flagsChatOn();
            if(this.mMuteChatIcon)
            {
               _loc2_ = _loc1_ ? "chat_icon_muted" : "chat_icon_unmuted";
               this.mMuteChatIcon.upState = Root.assets.getTexture(_loc2_);
               this.mMuteChatIcon.downState = Root.assets.getTexture(_loc2_);
               if(!Utils.isMobile())
               {
                  _loc3_ = _loc1_ ? TextManager.getText("TID_CHAT_MUTE") : TextManager.getText("TID_CHAT_UNMUTE");
                  this.mMuteChatIcon.setTooltipText(_loc3_);
               }
               TweenMax.killTweensOf(this.mMuteChatIcon);
               this.mMuteChatIcon.visible = true;
               this.mMuteChatIcon.alpha = 0.999;
               addChild(this.mMuteChatIcon);
            }
            if(_loc1_)
            {
               this.onChatActivatedPerformOps();
            }
            if(parent != null)
            {
               parent.addChild(this);
            }
         }
         else
         {
            if(this.mMuteChatIcon)
            {
               this.mMuteChatIcon.visible = false;
            }
            this.hideChatCarroussel();
         }
      }
      
      private function onChatActivatedPerformOps() : void
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:FSBattlefieldUserPortrait = null;
         var _loc3_:Texture = null;
         var _loc4_:String = null;
         var _loc5_:Function = null;
         var _loc6_:int = 0;
         var _loc7_:FSButton = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         _loc1_ = new FSCoordinate();
         if(this.mPremadeChats == null)
         {
            _loc2_ = this.getUserBattlePortrait();
            if(_loc2_)
            {
               _loc3_ = Root.assets.getTexture("chat_bubble");
               _loc4_ = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_DESC);
               this.mPremadeChats = new Vector.<FSButton>();
               _loc5_ = null;
               _loc6_ = 0;
               while(_loc6_ < CHATS_AMOUNT)
               {
                  _loc7_ = new FSButton(_loc3_,_loc2_.getChatTextByIndex(_loc6_));
                  Utils.setupButton9Scale(_loc7_,6,4,2,2,106.5,19.5);
                  _loc7_.fontSize = FSResourceMng.FONT_STD_DEFAULT_SIZE;
                  _loc7_.fontName = _loc4_;
                  _loc7_.fontColor = 0;
                  _loc7_.alpha = 0;
                  switch(_loc6_)
                  {
                     case CHAT_GOOD_LUCK:
                        _loc5_ = this.onGLButtonTriggered;
                        break;
                     case CHAT_WELL_PLAYED:
                        _loc5_ = this.onWPButtonTriggered;
                        break;
                     case CHAT_THANKS:
                        _loc5_ = this.onThanksButtonTriggered;
                        break;
                     case CHAT_GOOD_GAME:
                        _loc5_ = this.onGGButtonTriggered;
                        break;
                     case CHAT_MY_BAD:
                        _loc5_ = this.onMyBadButtonTriggered;
                        break;
                     case CHAT_WOW:
                        _loc5_ = this.onWowButtonTriggered;
                  }
                  _loc7_.addEventListener(Event.TRIGGERED,_loc5_);
                  this.mPremadeChats.push(_loc7_);
                  addChild(_loc7_);
                  _loc6_++;
               }
               this.mPremadeChats.reverse();
            }
         }
         if(this.mPremadeChats)
         {
            _loc8_ = 0.02;
            _loc9_ = 0.15;
            _loc10_ = 0;
            while(_loc10_ < this.mPremadeChats.length)
            {
               this.mPremadeChats[_loc10_].visible = true;
               this.mPremadeChats[_loc10_].alpha = 0;
               this.mPremadeChats[_loc10_].x = this.mPremadeChats[_loc10_].width;
               this.mPremadeChats[_loc10_].y = this.mPremadeChats[_loc10_].height * 2 - _loc10_ * this.mPremadeChats[_loc10_].height;
               _loc1_.setX(-this.mPremadeChats[_loc10_].width * 0.75);
               _loc1_.setY(this.mPremadeChats[_loc10_].y);
               SpecialFX.createTransition(this.mPremadeChats[_loc10_],_loc1_,_loc9_,_loc8_ * _loc10_);
               SpecialFX.tweenToAlpha(this.mPremadeChats[_loc10_],1,_loc9_,0,null,null,_loc8_ * _loc10_);
               _loc10_++;
            }
         }
      }
      
      private function onGLButtonTriggered(param1:Event) : void
      {
         this.sendChat(0);
      }
      
      private function onWPButtonTriggered(param1:Event) : void
      {
         this.sendChat(1);
      }
      
      private function onThanksButtonTriggered(param1:Event) : void
      {
         this.sendChat(2);
      }
      
      private function onGGButtonTriggered(param1:Event) : void
      {
         this.sendChat(3);
      }
      
      private function onMyBadButtonTriggered(param1:Event) : void
      {
         this.sendChat(4);
      }
      
      private function onWowButtonTriggered(param1:Event) : void
      {
         this.sendChat(5);
      }
      
      private function hideChatCarroussel() : void
      {
         var _loc1_:int = 0;
         this.mChatCarrousselShown = false;
         if(this.mPremadeChats)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mPremadeChats.length)
            {
               if(this.mPremadeChats[_loc1_])
               {
                  this.mPremadeChats[_loc1_].visible = false;
               }
               _loc1_++;
            }
         }
      }
      
      private function removeChatButtonFromParent(param1:FSButton) : void
      {
         if(param1)
         {
            param1.removeFromParent();
         }
      }
      
      private function sendChat(param1:int) : void
      {
         var _loc4_:BattleEngine = null;
         var _loc5_:UserBattleInfoPvP = null;
         var _loc6_:UserData = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:FSBattlefieldUserPortrait = null;
         var _loc2_:int = 3;
         var _loc3_:Number = ServerConnection.smServerTimeMS;
         if(this.mLastMessageSentTimestamp == -1 || _loc3_ > this.mLastMessageSentTimestamp + TimerUtil.secondToMs(_loc2_))
         {
            this.mLastMessageSentTimestamp = _loc3_;
            _loc4_ = InstanceMng.getBattleEngine();
            if(_loc4_)
            {
               _loc5_ = UserBattleInfoPvP(_loc4_.getOpponentBattleInfo());
               _loc6_ = _loc5_ ? _loc5_.getUserData() : null;
               _loc7_ = _loc6_ ? _loc6_.getAccountId() : "";
               _loc8_ = _loc6_ ? _loc6_.getName() : "";
               _loc9_ = this.getUserBattlePortrait();
               if(_loc7_ != "" && _loc7_ != null && _loc8_ != "" && _loc8_ != null)
               {
                  InstanceMng.getServerConnection().pvpSendBattleEmote(_loc7_,param1);
                  if(_loc9_)
                  {
                     _loc9_.showMessageBubble(param1);
                  }
                  this.enablePremadeChats(false);
                  setTimeout(this.enablePremadeChats,_loc2_ * 1000,true);
               }
            }
            this.hideChatCarroussel();
            if(this.mMuteChatIcon)
            {
               this.mMuteChatIcon.visible = false;
            }
         }
         else
         {
            FSDebug.debugTrace("NEGATIVE!");
         }
      }
      
      public function onCancel() : void
      {
         this.hideChatCarroussel();
         if(this.mMuteChatIcon)
         {
            this.mMuteChatIcon.visible = false;
         }
      }
      
      private function getUserBattlePortrait() : FSBattlefieldUserPortrait
      {
         var _loc1_:BattleEngine = InstanceMng.getBattleEngine();
         if(_loc1_)
         {
            if(Boolean(_loc1_.getOwnerBattleInfo()) && Boolean(_loc1_.getOwnerBattleInfo().getUserBattlePortrait()))
            {
               return _loc1_.getOwnerBattleInfo().getUserBattlePortrait();
            }
         }
         return null;
      }
      
      private function enablePremadeChats(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(this.mPremadeChats)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mPremadeChats.length)
            {
               if(this.mPremadeChats[_loc2_])
               {
                  this.mPremadeChats[_loc2_].setEnabled(param1);
               }
               _loc2_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mChatIcon)
         {
            this.mChatIcon.removeEventListener(Event.TRIGGERED,this.onChatIconTriggered);
            this.mChatIcon.removeFromParent();
            this.mChatIcon.destroy();
            this.mChatIcon = null;
         }
         if(this.mMuteChatIcon)
         {
            this.mMuteChatIcon.removeEventListener(Event.TRIGGERED,this.onMuteChatIconTriggered);
            this.mMuteChatIcon.removeFromParent();
            this.mMuteChatIcon.destroy();
            this.mMuteChatIcon = null;
         }
         super.dispose();
      }
      
      public function isMessageCarrousselShown() : Boolean
      {
         return this.mChatCarrousselShown;
      }
   }
}

