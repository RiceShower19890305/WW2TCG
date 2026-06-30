package com.gamesparks.api.messages
{
   import com.gamesparks.api.requests.*;
   import flash.utils.Dictionary;
   
   public class GSMessageHandler
   {
      
      private var callbacks:Dictionary = new Dictionary();
      
      public function GSMessageHandler()
      {
         super();
      }
      
      public function setAchievementEarnedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".AchievementEarnedMessage"] = param1;
         return this;
      }
      
      public function setChallengeAcceptedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeAcceptedMessage"] = param1;
         return this;
      }
      
      public function setChallengeChangedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeChangedMessage"] = param1;
         return this;
      }
      
      public function setChallengeChatMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeChatMessage"] = param1;
         return this;
      }
      
      public function setChallengeDeclinedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeDeclinedMessage"] = param1;
         return this;
      }
      
      public function setChallengeDrawnMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeDrawnMessage"] = param1;
         return this;
      }
      
      public function setChallengeExpiredMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeExpiredMessage"] = param1;
         return this;
      }
      
      public function setChallengeIssuedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeIssuedMessage"] = param1;
         return this;
      }
      
      public function setChallengeJoinedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeJoinedMessage"] = param1;
         return this;
      }
      
      public function setChallengeLapsedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeLapsedMessage"] = param1;
         return this;
      }
      
      public function setChallengeLostMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeLostMessage"] = param1;
         return this;
      }
      
      public function setChallengeStartedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeStartedMessage"] = param1;
         return this;
      }
      
      public function setChallengeTurnTakenMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeTurnTakenMessage"] = param1;
         return this;
      }
      
      public function setChallengeWaitingMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeWaitingMessage"] = param1;
         return this;
      }
      
      public function setChallengeWithdrawnMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeWithdrawnMessage"] = param1;
         return this;
      }
      
      public function setChallengeWonMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ChallengeWonMessage"] = param1;
         return this;
      }
      
      public function setFriendMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".FriendMessage"] = param1;
         return this;
      }
      
      public function setGlobalRankChangedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".GlobalRankChangedMessage"] = param1;
         return this;
      }
      
      public function setMatchFoundMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".MatchFoundMessage"] = param1;
         return this;
      }
      
      public function setMatchNotFoundMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".MatchNotFoundMessage"] = param1;
         return this;
      }
      
      public function setMatchUpdatedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".MatchUpdatedMessage"] = param1;
         return this;
      }
      
      public function setNewHighScoreMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".NewHighScoreMessage"] = param1;
         return this;
      }
      
      public function setNewTeamScoreMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".NewTeamScoreMessage"] = param1;
         return this;
      }
      
      public function setScriptMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".ScriptMessage"] = param1;
         return this;
      }
      
      public function setSessionTerminatedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".SessionTerminatedMessage"] = param1;
         return this;
      }
      
      public function setSocialRankChangedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".SocialRankChangedMessage"] = param1;
         return this;
      }
      
      public function setTeamChatMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".TeamChatMessage"] = param1;
         return this;
      }
      
      public function setTeamRankChangedMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".TeamRankChangedMessage"] = param1;
         return this;
      }
      
      public function setUploadCompleteMessageHandler(param1:Function) : GSMessageHandler
      {
         this.callbacks[".UploadCompleteMessage"] = param1;
         return this;
      }
      
      public function setHandler(param1:String, param2:Function) : GSMessageHandler
      {
         this.callbacks[param1] = param2;
         return this;
      }
      
      public function handle(param1:Object) : void
      {
         var _loc2_:String = param1["@class"];
         if(_loc2_ == null || this.callbacks[_loc2_] == null)
         {
            return;
         }
         switch(_loc2_)
         {
            case ".AchievementEarnedMessage":
               this.callbacks[_loc2_](new AchievementEarnedMessage(param1));
               break;
            case ".ChallengeAcceptedMessage":
               this.callbacks[_loc2_](new ChallengeAcceptedMessage(param1));
               break;
            case ".ChallengeChangedMessage":
               this.callbacks[_loc2_](new ChallengeChangedMessage(param1));
               break;
            case ".ChallengeChatMessage":
               this.callbacks[_loc2_](new ChallengeChatMessage(param1));
               break;
            case ".ChallengeDeclinedMessage":
               this.callbacks[_loc2_](new ChallengeDeclinedMessage(param1));
               break;
            case ".ChallengeDrawnMessage":
               this.callbacks[_loc2_](new ChallengeDrawnMessage(param1));
               break;
            case ".ChallengeExpiredMessage":
               this.callbacks[_loc2_](new ChallengeExpiredMessage(param1));
               break;
            case ".ChallengeIssuedMessage":
               this.callbacks[_loc2_](new ChallengeIssuedMessage(param1));
               break;
            case ".ChallengeJoinedMessage":
               this.callbacks[_loc2_](new ChallengeJoinedMessage(param1));
               break;
            case ".ChallengeLapsedMessage":
               this.callbacks[_loc2_](new ChallengeLapsedMessage(param1));
               break;
            case ".ChallengeLostMessage":
               this.callbacks[_loc2_](new ChallengeLostMessage(param1));
               break;
            case ".ChallengeStartedMessage":
               this.callbacks[_loc2_](new ChallengeStartedMessage(param1));
               break;
            case ".ChallengeTurnTakenMessage":
               this.callbacks[_loc2_](new ChallengeTurnTakenMessage(param1));
               break;
            case ".ChallengeWaitingMessage":
               this.callbacks[_loc2_](new ChallengeWaitingMessage(param1));
               break;
            case ".ChallengeWithdrawnMessage":
               this.callbacks[_loc2_](new ChallengeWithdrawnMessage(param1));
               break;
            case ".ChallengeWonMessage":
               this.callbacks[_loc2_](new ChallengeWonMessage(param1));
               break;
            case ".FriendMessage":
               this.callbacks[_loc2_](new FriendMessage(param1));
               break;
            case ".GlobalRankChangedMessage":
               this.callbacks[_loc2_](new GlobalRankChangedMessage(param1));
               break;
            case ".MatchFoundMessage":
               this.callbacks[_loc2_](new MatchFoundMessage(param1));
               break;
            case ".MatchNotFoundMessage":
               this.callbacks[_loc2_](new MatchNotFoundMessage(param1));
               break;
            case ".MatchUpdatedMessage":
               this.callbacks[_loc2_](new MatchUpdatedMessage(param1));
               break;
            case ".NewHighScoreMessage":
               this.callbacks[_loc2_](new NewHighScoreMessage(param1));
               break;
            case ".NewTeamScoreMessage":
               this.callbacks[_loc2_](new NewTeamScoreMessage(param1));
               break;
            case ".ScriptMessage":
               this.callbacks[_loc2_](new ScriptMessage(param1));
               break;
            case ".SessionTerminatedMessage":
               this.callbacks[_loc2_](new SessionTerminatedMessage(param1));
               break;
            case ".SocialRankChangedMessage":
               this.callbacks[_loc2_](new SocialRankChangedMessage(param1));
               break;
            case ".TeamChatMessage":
               this.callbacks[_loc2_](new TeamChatMessage(param1));
               break;
            case ".TeamRankChangedMessage":
               this.callbacks[_loc2_](new TeamRankChangedMessage(param1));
               break;
            case ".UploadCompleteMessage":
               this.callbacks[_loc2_](new UploadCompleteMessage(param1));
         }
      }
   }
}

