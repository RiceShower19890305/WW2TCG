package com.fs.tcgengine.controller
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.model.battle.BattleEngine;
   import com.fs.tcgengine.model.rules.ConversationDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.battle.ConversationBlock;
   import com.greensock.TweenMax;
   import flash.utils.setTimeout;
   import starling.events.Event;
   
   public class ConversationsMng
   {
      
      private var mConversationDefs:Array;
      
      private var mConversationDefsRequested:Boolean;
      
      private var mConversationBlocksBeingShown:Vector.<ConversationBlock>;
      
      public function ConversationsMng()
      {
         super();
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ConversationDef = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         if(InstanceMng.getCurrentScreen() == null || !(InstanceMng.getCurrentScreen() is FSBattleScreen) || InstanceMng.getBattleEngine() == null)
         {
            return;
         }
         if(!this.mConversationDefsRequested)
         {
            if(InstanceMng.getBattleEngine().getLevelDef() != null)
            {
               _loc2_ = InstanceMng.getBattleEngine().getLevelDef().getSku();
               this.mConversationDefs = InstanceMng.getConversationsDefMng().getConversationsDefsByLevelSku(_loc2_);
               this.mConversationDefsRequested = true;
            }
         }
         if(this.mConversationDefs != null && this.mConversationDefsRequested)
         {
            _loc3_ = InstanceMng.getBattleEngine().getCurrentTurnId();
            _loc5_ = int(this.mConversationDefs.length);
            _loc7_ = InstanceMng.getBattleEngine().getPlayersStateId();
            _loc8_ = false;
            _loc9_ = true;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = this.mConversationDefs[_loc4_];
               if(_loc6_ != null)
               {
                  _loc8_ = _loc7_ == BattleEngine.STATE_OWNER_MOVING_CARDS || _loc7_ == BattleEngine.STATE_OPPONENT_MOVING_CARDS;
                  if(_loc6_.getTurn() == _loc3_ && _loc8_)
                  {
                     _loc10_ = this.getConversationsAmountByTurn(_loc3_);
                     this.mConversationDefs.splice(_loc4_,1);
                     if(this.mConversationDefs.length == 0)
                     {
                        this.mConversationDefs = null;
                     }
                     if(!_loc6_.isEnemy())
                     {
                        if(InstanceMng.getCurrentScreen() is FSBattleScreen)
                        {
                           FSBattleScreen(InstanceMng.getCurrentScreen()).lockUI(true);
                        }
                     }
                     _loc9_ = _loc4_ == _loc10_ - 1;
                     this.onConversationTriggerStepOps(_loc6_,_loc4_,_loc9_);
                  }
               }
               _loc4_++;
            }
         }
      }
      
      public function checkIfCustomConversation() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:UserData = null;
         var _loc5_:int = 0;
         var _loc6_:ConversationDef = null;
         if(InstanceMng.getBattleEngine().getLevelDef() != null && InstanceMng.getBattleEngine().getCurrentTurnId() == 1)
         {
            _loc1_ = InstanceMng.getBattleEngine().getLevelDef().getSku();
            _loc2_ = false;
            if(this.mConversationDefs != null)
            {
               _loc3_ = 0;
               while(_loc3_ < this.mConversationDefs.length)
               {
                  if(ConversationDef(this.mConversationDefs[_loc3_]).getTurn() == 1)
                  {
                     _loc2_ = true;
                  }
                  _loc3_++;
               }
            }
            if(!_loc2_)
            {
               _loc4_ = Utils.getOwnerUserData();
               if(_loc4_)
               {
                  _loc5_ = _loc4_.getLevelsFailedInfoByLevelSku(_loc1_);
                  if(_loc5_ > 0 && _loc5_ % 3 == 0)
                  {
                     _loc6_ = InstanceMng.getConversationsDefMng().getConversationDefByCallKey("custom");
                     if(_loc6_)
                     {
                        _loc6_.setLevelSku(_loc1_);
                        _loc6_.setTurn(1);
                        _loc6_.setIsEnemy(false);
                        setTimeout(this.openConversationChat,250,_loc6_,false);
                     }
                  }
               }
            }
         }
      }
      
      private function getConversationsAmountByTurn(param1:int) : int
      {
         var _loc3_:ConversationDef = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         if(this.mConversationDefs != null)
         {
            _loc4_ = int(this.mConversationDefs.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = this.mConversationDefs[_loc5_];
               if(_loc3_ != null)
               {
                  if(_loc3_.getTurn() == param1)
                  {
                     _loc2_++;
                  }
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      private function onConversationTriggerStepOps(param1:ConversationDef, param2:int, param3:Boolean) : void
      {
         var _loc4_:Number = param1.getStartTime();
         TweenMax.delayedCall(_loc4_,this.openConversationChat,[param1,param3]);
      }
      
      public function openConversationChat(param1:ConversationDef, param2:Boolean) : void
      {
         var _loc3_:ConversationBlock = new ConversationBlock();
         _loc3_.init(param1,param2);
         this.addConversationBlockBeingShown(_loc3_);
      }
      
      private function addConversationBlockBeingShown(param1:ConversationBlock) : void
      {
         if(this.mConversationBlocksBeingShown == null)
         {
            this.mConversationBlocksBeingShown = new Vector.<ConversationBlock>();
         }
         this.mConversationBlocksBeingShown.push(param1);
      }
      
      public function removeConversationBlockBeingShown(param1:ConversationBlock) : void
      {
         var _loc2_:int = 0;
         if(this.mConversationBlocksBeingShown != null)
         {
            _loc2_ = this.mConversationBlocksBeingShown.indexOf(param1);
            if(_loc2_ != -1)
            {
               this.mConversationBlocksBeingShown.splice(_loc2_,1);
            }
         }
      }
      
      private function closeAllConversationBlocksShown() : void
      {
         var _loc1_:ConversationBlock = null;
         var _loc2_:int = 0;
         if(this.mConversationBlocksBeingShown)
         {
            while(this.mConversationBlocksBeingShown.length > 0)
            {
               _loc1_ = this.mConversationBlocksBeingShown.pop();
               _loc1_.removeConversationChat(false);
               _loc1_ = null;
            }
            this.mConversationBlocksBeingShown = null;
         }
      }
      
      public function unload() : void
      {
         var _loc1_:int = 0;
         this.closeAllConversationBlocksShown();
         if(this.mConversationDefs != null)
         {
            _loc1_ = 0;
            _loc1_ = 0;
            while(_loc1_ < this.mConversationDefs.length)
            {
               this.mConversationDefs[_loc1_] = null;
               _loc1_++;
            }
            this.mConversationDefs.length = 0;
            this.mConversationDefs = null;
         }
         this.mConversationDefsRequested = false;
      }
      
      public function unloadCustomConversation(param1:ConversationDef) : void
      {
         var _loc2_:int = 0;
         if(this.mConversationDefs != null)
         {
            _loc2_ = 0;
            _loc2_ = 0;
            while(_loc2_ < this.mConversationDefs.length)
            {
               if(this.mConversationDefs[_loc2_] == param1)
               {
                  this.mConversationDefs.splice(_loc2_,1);
                  return;
               }
               _loc2_++;
            }
         }
      }
   }
}

