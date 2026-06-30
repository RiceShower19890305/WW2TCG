package com.gamesparks.api.requests
{
   import com.gamesparks.GS;
   
   public class GSRequestBuilder
   {
      
      private var gs:GS;
      
      public function GSRequestBuilder(param1:GS)
      {
         super();
         this.gs = param1;
      }
      
      public function createAcceptChallengeRequest() : AcceptChallengeRequest
      {
         return new AcceptChallengeRequest(this.gs);
      }
      
      public function createAccountDetailsRequest() : AccountDetailsRequest
      {
         return new AccountDetailsRequest(this.gs);
      }
      
      public function createAmazonBuyGoodsRequest() : AmazonBuyGoodsRequest
      {
         return new AmazonBuyGoodsRequest(this.gs);
      }
      
      public function createAmazonConnectRequest() : AmazonConnectRequest
      {
         return new AmazonConnectRequest(this.gs);
      }
      
      public function createAnalyticsRequest() : AnalyticsRequest
      {
         return new AnalyticsRequest(this.gs);
      }
      
      public function createAroundMeLeaderboardRequest() : AroundMeLeaderboardRequest
      {
         return new AroundMeLeaderboardRequest(this.gs);
      }
      
      public function createAuthenticationRequest() : AuthenticationRequest
      {
         return new AuthenticationRequest(this.gs);
      }
      
      public function createBatchAdminRequest() : BatchAdminRequest
      {
         return new BatchAdminRequest(this.gs);
      }
      
      public function createBuyVirtualGoodsRequest() : BuyVirtualGoodsRequest
      {
         return new BuyVirtualGoodsRequest(this.gs);
      }
      
      public function createCancelBulkJobAdminRequest() : CancelBulkJobAdminRequest
      {
         return new CancelBulkJobAdminRequest(this.gs);
      }
      
      public function createChangeUserDetailsRequest() : ChangeUserDetailsRequest
      {
         return new ChangeUserDetailsRequest(this.gs);
      }
      
      public function createChatOnChallengeRequest() : ChatOnChallengeRequest
      {
         return new ChatOnChallengeRequest(this.gs);
      }
      
      public function createConsumeVirtualGoodRequest() : ConsumeVirtualGoodRequest
      {
         return new ConsumeVirtualGoodRequest(this.gs);
      }
      
      public function createCreateChallengeRequest() : CreateChallengeRequest
      {
         return new CreateChallengeRequest(this.gs);
      }
      
      public function createCreateTeamRequest() : CreateTeamRequest
      {
         return new CreateTeamRequest(this.gs);
      }
      
      public function createDeclineChallengeRequest() : DeclineChallengeRequest
      {
         return new DeclineChallengeRequest(this.gs);
      }
      
      public function createDeviceAuthenticationRequest() : DeviceAuthenticationRequest
      {
         return new DeviceAuthenticationRequest(this.gs);
      }
      
      public function createDismissMessageRequest() : DismissMessageRequest
      {
         return new DismissMessageRequest(this.gs);
      }
      
      public function createDismissMultipleMessagesRequest() : DismissMultipleMessagesRequest
      {
         return new DismissMultipleMessagesRequest(this.gs);
      }
      
      public function createDropTeamRequest() : DropTeamRequest
      {
         return new DropTeamRequest(this.gs);
      }
      
      public function createEndSessionRequest() : EndSessionRequest
      {
         return new EndSessionRequest(this.gs);
      }
      
      public function createFacebookConnectRequest() : FacebookConnectRequest
      {
         return new FacebookConnectRequest(this.gs);
      }
      
      public function createFindChallengeRequest() : FindChallengeRequest
      {
         return new FindChallengeRequest(this.gs);
      }
      
      public function createFindMatchRequest() : FindMatchRequest
      {
         return new FindMatchRequest(this.gs);
      }
      
      public function createFindPendingMatchesRequest() : FindPendingMatchesRequest
      {
         return new FindPendingMatchesRequest(this.gs);
      }
      
      public function createGameCenterConnectRequest() : GameCenterConnectRequest
      {
         return new GameCenterConnectRequest(this.gs);
      }
      
      public function createGetChallengeRequest() : GetChallengeRequest
      {
         return new GetChallengeRequest(this.gs);
      }
      
      public function createGetDownloadableRequest() : GetDownloadableRequest
      {
         return new GetDownloadableRequest(this.gs);
      }
      
      public function createGetLeaderboardEntriesRequest() : GetLeaderboardEntriesRequest
      {
         return new GetLeaderboardEntriesRequest(this.gs);
      }
      
      public function createGetMessageRequest() : GetMessageRequest
      {
         return new GetMessageRequest(this.gs);
      }
      
      public function createGetMyTeamsRequest() : GetMyTeamsRequest
      {
         return new GetMyTeamsRequest(this.gs);
      }
      
      public function createGetPropertyRequest() : GetPropertyRequest
      {
         return new GetPropertyRequest(this.gs);
      }
      
      public function createGetPropertySetRequest() : GetPropertySetRequest
      {
         return new GetPropertySetRequest(this.gs);
      }
      
      public function createGetTeamRequest() : GetTeamRequest
      {
         return new GetTeamRequest(this.gs);
      }
      
      public function createGetUploadUrlRequest() : GetUploadUrlRequest
      {
         return new GetUploadUrlRequest(this.gs);
      }
      
      public function createGetUploadedRequest() : GetUploadedRequest
      {
         return new GetUploadedRequest(this.gs);
      }
      
      public function createGooglePlayBuyGoodsRequest() : GooglePlayBuyGoodsRequest
      {
         return new GooglePlayBuyGoodsRequest(this.gs);
      }
      
      public function createGooglePlayConnectRequest() : GooglePlayConnectRequest
      {
         return new GooglePlayConnectRequest(this.gs);
      }
      
      public function createGooglePlusConnectRequest() : GooglePlusConnectRequest
      {
         return new GooglePlusConnectRequest(this.gs);
      }
      
      public function createIOSBuyGoodsRequest() : IOSBuyGoodsRequest
      {
         return new IOSBuyGoodsRequest(this.gs);
      }
      
      public function createJoinChallengeRequest() : JoinChallengeRequest
      {
         return new JoinChallengeRequest(this.gs);
      }
      
      public function createJoinPendingMatchRequest() : JoinPendingMatchRequest
      {
         return new JoinPendingMatchRequest(this.gs);
      }
      
      public function createJoinTeamRequest() : JoinTeamRequest
      {
         return new JoinTeamRequest(this.gs);
      }
      
      public function createKongregateConnectRequest() : KongregateConnectRequest
      {
         return new KongregateConnectRequest(this.gs);
      }
      
      public function createAppleConnectRequest() : AppleConnectRequest
      {
         return new AppleConnectRequest(this.gs);
      }
      
      public function createLeaderboardDataRequest() : LeaderboardDataRequest
      {
         return new LeaderboardDataRequest(this.gs);
      }
      
      public function createLeaderboardsEntriesRequest() : LeaderboardsEntriesRequest
      {
         return new LeaderboardsEntriesRequest(this.gs);
      }
      
      public function createLeaveTeamRequest() : LeaveTeamRequest
      {
         return new LeaveTeamRequest(this.gs);
      }
      
      public function createListAchievementsRequest() : ListAchievementsRequest
      {
         return new ListAchievementsRequest(this.gs);
      }
      
      public function createListBulkJobsAdminRequest() : ListBulkJobsAdminRequest
      {
         return new ListBulkJobsAdminRequest(this.gs);
      }
      
      public function createListChallengeRequest() : ListChallengeRequest
      {
         return new ListChallengeRequest(this.gs);
      }
      
      public function createListChallengeTypeRequest() : ListChallengeTypeRequest
      {
         return new ListChallengeTypeRequest(this.gs);
      }
      
      public function createListGameFriendsRequest() : ListGameFriendsRequest
      {
         return new ListGameFriendsRequest(this.gs);
      }
      
      public function createListInviteFriendsRequest() : ListInviteFriendsRequest
      {
         return new ListInviteFriendsRequest(this.gs);
      }
      
      public function createListLeaderboardsRequest() : ListLeaderboardsRequest
      {
         return new ListLeaderboardsRequest(this.gs);
      }
      
      public function createListMessageDetailRequest() : ListMessageDetailRequest
      {
         return new ListMessageDetailRequest(this.gs);
      }
      
      public function createListMessageRequest() : ListMessageRequest
      {
         return new ListMessageRequest(this.gs);
      }
      
      public function createListMessageSummaryRequest() : ListMessageSummaryRequest
      {
         return new ListMessageSummaryRequest(this.gs);
      }
      
      public function createListTeamChatRequest() : ListTeamChatRequest
      {
         return new ListTeamChatRequest(this.gs);
      }
      
      public function createListTeamsRequest() : ListTeamsRequest
      {
         return new ListTeamsRequest(this.gs);
      }
      
      public function createListTransactionsRequest() : ListTransactionsRequest
      {
         return new ListTransactionsRequest(this.gs);
      }
      
      public function createListVirtualGoodsRequest() : ListVirtualGoodsRequest
      {
         return new ListVirtualGoodsRequest(this.gs);
      }
      
      public function createLogChallengeEventRequest() : LogChallengeEventRequest
      {
         return new LogChallengeEventRequest(this.gs);
      }
      
      public function createLogEventRequest() : LogEventRequest
      {
         return new LogEventRequest(this.gs);
      }
      
      public function createMatchDetailsRequest() : MatchDetailsRequest
      {
         return new MatchDetailsRequest(this.gs);
      }
      
      public function createMatchmakingRequest() : MatchmakingRequest
      {
         return new MatchmakingRequest(this.gs);
      }
      
      public function createNXConnectRequest() : NXConnectRequest
      {
         return new NXConnectRequest(this.gs);
      }
      
      public function createPSNConnectRequest() : PSNConnectRequest
      {
         return new PSNConnectRequest(this.gs);
      }
      
      public function createPsnBuyGoodsRequest() : PsnBuyGoodsRequest
      {
         return new PsnBuyGoodsRequest(this.gs);
      }
      
      public function createPushRegistrationRequest() : PushRegistrationRequest
      {
         return new PushRegistrationRequest(this.gs);
      }
      
      public function createQQConnectRequest() : QQConnectRequest
      {
         return new QQConnectRequest(this.gs);
      }
      
      public function createRegistrationRequest() : RegistrationRequest
      {
         return new RegistrationRequest(this.gs);
      }
      
      public function createRevokePurchaseGoodsRequest() : RevokePurchaseGoodsRequest
      {
         return new RevokePurchaseGoodsRequest(this.gs);
      }
      
      public function createScheduleBulkJobAdminRequest() : ScheduleBulkJobAdminRequest
      {
         return new ScheduleBulkJobAdminRequest(this.gs);
      }
      
      public function createSendFriendMessageRequest() : SendFriendMessageRequest
      {
         return new SendFriendMessageRequest(this.gs);
      }
      
      public function createSendTeamChatMessageRequest() : SendTeamChatMessageRequest
      {
         return new SendTeamChatMessageRequest(this.gs);
      }
      
      public function createSocialDisconnectRequest() : SocialDisconnectRequest
      {
         return new SocialDisconnectRequest(this.gs);
      }
      
      public function createSocialLeaderboardDataRequest() : SocialLeaderboardDataRequest
      {
         return new SocialLeaderboardDataRequest(this.gs);
      }
      
      public function createSocialStatusRequest() : SocialStatusRequest
      {
         return new SocialStatusRequest(this.gs);
      }
      
      public function createSteamBuyGoodsRequest() : SteamBuyGoodsRequest
      {
         return new SteamBuyGoodsRequest(this.gs);
      }
      
      public function createSteamConnectRequest() : SteamConnectRequest
      {
         return new SteamConnectRequest(this.gs);
      }
      
      public function createTwitchConnectRequest() : TwitchConnectRequest
      {
         return new TwitchConnectRequest(this.gs);
      }
      
      public function createTwitterConnectRequest() : TwitterConnectRequest
      {
         return new TwitterConnectRequest(this.gs);
      }
      
      public function createUpdateMessageRequest() : UpdateMessageRequest
      {
         return new UpdateMessageRequest(this.gs);
      }
      
      public function createViberConnectRequest() : ViberConnectRequest
      {
         return new ViberConnectRequest(this.gs);
      }
      
      public function createWeChatConnectRequest() : WeChatConnectRequest
      {
         return new WeChatConnectRequest(this.gs);
      }
      
      public function createWindowsBuyGoodsRequest() : WindowsBuyGoodsRequest
      {
         return new WindowsBuyGoodsRequest(this.gs);
      }
      
      public function createWithdrawChallengeRequest() : WithdrawChallengeRequest
      {
         return new WithdrawChallengeRequest(this.gs);
      }
      
      public function createXBOXLiveConnectRequest() : XBOXLiveConnectRequest
      {
         return new XBOXLiveConnectRequest(this.gs);
      }
      
      public function createXboxOneConnectRequest() : XboxOneConnectRequest
      {
         return new XboxOneConnectRequest(this.gs);
      }
   }
}

