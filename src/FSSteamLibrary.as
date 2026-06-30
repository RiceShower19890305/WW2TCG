package
{
   import com.amanitadesign.steam.DownloadUGCResult;
   import com.amanitadesign.steam.FRESteamWorks;
   import com.amanitadesign.steam.FileDetailsResult;
   import com.amanitadesign.steam.FilesByUserActionResult;
   import com.amanitadesign.steam.FriendConstants;
   import com.amanitadesign.steam.ItemVoteDetailsResult;
   import com.amanitadesign.steam.LeaderboardEntry;
   import com.amanitadesign.steam.MicroTxnAuthorizationResponse;
   import com.amanitadesign.steam.SteamConstants;
   import com.amanitadesign.steam.SteamEvent;
   import com.amanitadesign.steam.SteamResults;
   import com.amanitadesign.steam.SubscribedFilesResult;
   import com.amanitadesign.steam.UploadLeaderboardScoreResult;
   import com.amanitadesign.steam.UserConstants;
   import com.amanitadesign.steam.UserFilesResult;
   import com.amanitadesign.steam.UserStatsConstants;
   import com.amanitadesign.steam.UserVoteDetails;
   import com.amanitadesign.steam.UtilsConstants;
   import com.amanitadesign.steam.WorkshopConstants;
   import com.amanitadesign.steam.WorkshopFilesResult;
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.FSDebug;
   import com.fs.tcgengine.model.rules.DeckSlotDef;
   import com.fs.tcgengine.model.rules.Def;
   import com.fs.tcgengine.model.rules.ShopBoostDef;
   import com.fs.tcgengine.utils.Utils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class FSSteamLibrary
   {
      
      private static var _appId:uint;
      
      public static var _userId:String;
      
      private static var _avatarBitmap:Bitmap;
      
      private static var id:String;
      
      private static var ugcHandle:String;
      
      private static var publishedFile:String;
      
      private static var leaderboard:String;
      
      public static var Steamworks:FRESteamWorks = new FRESteamWorks();
      
      private static var scoreDetails:int = 0;
      
      private static var authHandle:uint = 0;
      
      private static var authTicket:ByteArray = null;
      
      public static var smSessionTicket:String = "";
      
      private var overlayPosition:uint = 0;
      
      public function FSSteamLibrary()
      {
         super();
      }
      
      public static function initializeANEs(param1:int = 0) : void
      {
         var maxAttempts:int = 0;
         var attempt:int = param1;
         try
         {
            if(!Steamworks.init())
            {
               FSDebug.debugTrace("STEAMWORKS API is NOT available, turn on STEAM!");
               maxAttempts = 5;
               if(attempt < maxAttempts)
               {
                  Utils.setLogText("Could not get Steam info, retrying in 3 seconds...\n(Attempt " + (attempt + 1) + "/" + maxAttempts + ")",false,false,false);
                  setTimeout(initializeANEs,3000,attempt + 1);
               }
               else
               {
                  InstanceMng.getPopupMng().openErrorPopup("Steam app not launched or could not get a valid Steam ticket, please make sure the Steam Client is launched. \n Contact support@frozenshard.com for more info.",false);
               }
               return;
            }
            Steamworks.addEventListener(SteamEvent.STEAM_RESPONSE,onSteamResponse);
            _userId = Steamworks.getUserID();
            _appId = Steamworks.getAppID();
            FSDebug.debugTrace("STEAMWORKS API is available\n");
            FSDebug.debugTrace("User ID: " + _userId);
            FSDebug.debugTrace("App ID: " + _appId);
            FSDebug.debugTrace("Persona name: " + Steamworks.getPersonaName());
            FSDebug.debugTrace("Current game language: " + Steamworks.getCurrentGameLanguage());
            FSDebug.debugTrace("Available game languages: " + Steamworks.getAvailableGameLanguages());
            Steamworks.addOverlayWorkaround(InstanceMng.getApplication().stage,true);
            getAuthTicket();
            checkAchievements();
         }
         catch(e:Error)
         {
            FSDebug.debugTrace("*** ERROR ***");
            FSDebug.debugTrace(e.message);
            FSDebug.debugTrace(e.getStackTrace());
         }
      }
      
      public static function activateOverlayForStore() : void
      {
         activateOverlayToStore();
      }
      
      public static function checkAchievements(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("getStatInt(\'pvp_matches_won\') == " + Steamworks.getStatInt("pvp_matches_won"));
         FSDebug.debugTrace("isAchievement(\'ACH_PVP_WON_01\') == " + Steamworks.isAchievement("ACH_PVP_WON_01"));
         FSDebug.debugTrace("isAchievement(\'ACH_RANK_10\') == " + Steamworks.isAchievement("ACH_RANK_10"));
         FSDebug.debugTrace("isAchievement(\'ACH_RANK_11\') == " + Steamworks.isAchievement("ACH_RANK_11"));
         FSDebug.debugTrace("isAchievement(\'ACH_RANK_12\') == " + Steamworks.isAchievement("ACH_RANK_12"));
      }
      
      public static function checkAchievement(param1:String) : void
      {
         FSDebug.debugTrace("Is achievement " + param1 + " completed? " + Steamworks.isAchievement(param1));
      }
      
      public static function checkStat(param1:String) : void
      {
         FSDebug.debugTrace("Stat " + param1 + " progress:  " + Steamworks.getStatInt(param1));
      }
      
      public static function clearAchievement(param1:String) : void
      {
         FSDebug.debugTrace("Clearing achievement " + param1 + " - Success? " + Steamworks.clearAchievement(param1));
      }
      
      public static function resetAllStats(param1:Boolean) : void
      {
         Steamworks.resetAllStats(param1);
         Steamworks.storeStats();
      }
      
      public static function getAuthTicket(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            FSDebug.debugTrace("Steamworks not ready, retrying in 250 ms...");
            setTimeout(getAuthTicket,250,null);
            return;
         }
         authTicket = new ByteArray();
         authHandle = Steamworks.getAuthSessionTicket(authTicket);
         FSDebug.debugTrace("getAuthSessionTicket(ticket) == " + authHandle);
         logTicket(authTicket,"authTicket");
      }
      
      private static function logTicket(param1:ByteArray, param2:String = "Ticket") : void
      {
         var _loc5_:String = null;
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_].toString(16);
            _loc3_ += (_loc5_.length < 2 ? "0" : "") + _loc5_;
            _loc4_++;
         }
         FSDebug.debugTrace(param2 + ": " + param1.bytesAvailable + "//" + param1.length + "\n" + _loc3_);
         smSessionTicket = _loc3_;
      }
      
      public static function isOverlayEnabled() : Boolean
      {
         if(!Steamworks.isReady)
         {
            return false;
         }
         FSDebug.debugTrace("isOverlayEnabled() == " + Steamworks.isOverlayEnabled());
         return Steamworks.isOverlayEnabled();
      }
      
      private static function activateOverlayToStore(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.activateGameOverlayToStore(_appId,WorkshopConstants.OVERLAYSTOREFLAG_None));
         FSDebug.debugTrace("activateGameOverlayToStore(" + _appId + ", " + WorkshopConstants.OVERLAYSTOREFLAG_None + ") == " + _loc2_);
      }
      
      private static function getUserScore(param1:Event = null) : void
      {
         getScoresAroundUser(param1,0,0);
      }
      
      private static function getScoresAroundUser(param1:Event = null, param2:int = -4, param3:int = 5) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         if(!leaderboard)
         {
            FSDebug.debugTrace("No Leaderboard handle set");
            return;
         }
         FSDebug.debugTrace("downloadLeaderboardEntries(...) == " + Steamworks.downloadLeaderboardEntries(leaderboard,UserStatsConstants.DATAREQUEST_GlobalAroundUser,param2,param3));
      }
      
      private static function onSteamResponse(param1:SteamEvent) : void
      {
         var apiCall:Boolean = false;
         var i:int = 0;
         var name:String = null;
         var sortMethod:int = 0;
         var displayType:int = 0;
         var entries:Array = null;
         var sr:UploadLeaderboardScoreResult = null;
         var subRes:SubscribedFilesResult = null;
         var shared:Boolean = false;
         var userRes:UserFilesResult = null;
         var fileRes:WorkshopFilesResult = null;
         var actionRes:FilesByUserActionResult = null;
         var res:FileDetailsResult = null;
         var ugcResult:DownloadUGCResult = null;
         var voteDetails:ItemVoteDetailsResult = null;
         var userVoteDetails:UserVoteDetails = null;
         var realAuthHandle:uint = 0;
         var encryptedAppTicket:ByteArray = null;
         var license:uint = 0;
         var microTxnResponse:MicroTxnAuthorizationResponse = null;
         var newLeaderboard:String = null;
         var en:LeaderboardEntry = null;
         var d:int = 0;
         var subbedFile:String = null;
         var f:String = null;
         var progress:Array = null;
         var ba:ByteArray = null;
         var e:SteamEvent = param1;
         switch(e.req_type)
         {
            case SteamConstants.RESPONSE_OnUserStatsStored:
               FSDebug.debugTrace("RESPONSE_OnUserStatsStored: " + e.response);
               break;
            case SteamConstants.RESPONSE_OnUserStatsReceived:
               FSDebug.debugTrace("RESPONSE_OnUserStatsReceived: " + e.response);
               break;
            case SteamConstants.RESPONSE_OnAchievementStored:
               FSDebug.debugTrace("RESPONSE_OnAchievementStored: " + e.response);
               break;
            case SteamConstants.RESPONSE_OnGlobalStatsReceived:
               FSDebug.debugTrace("RESPONSE_OnGlobalStatsReceived: " + e.response);
               break;
            case SteamConstants.RESPONSE_OnFindLeaderboard:
               FSDebug.debugTrace("RESPONSE_OnFindLeaderboad: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               if(leaderboard)
               {
                  newLeaderboard = Steamworks.findLeaderboardResult();
                  FSDebug.debugTrace("findLeaderboardResult() == " + newLeaderboard);
                  if(newLeaderboard != leaderboard)
                  {
                     FSDebug.debugTrace("FAILURE: findOrCreateLeaderboard() returned different leaderboard");
                  }
                  break;
               }
               leaderboard = Steamworks.findLeaderboardResult();
               name = Steamworks.getLeaderboardName(leaderboard);
               sortMethod = int(Steamworks.getLeaderboardSortMethod(leaderboard));
               displayType = int(Steamworks.getLeaderboardDisplayType(leaderboard));
               FSDebug.debugTrace("findLeaderboardResult() == " + leaderboard);
               FSDebug.debugTrace("getLeaderboardName(...) == " + name);
               FSDebug.debugTrace("getLeaderboardEntryCount(...) == " + Steamworks.getLeaderboardEntryCount(leaderboard));
               FSDebug.debugTrace("getLeaderboardSortMethod(...) == " + sortMethod);
               FSDebug.debugTrace("getLeaderboardDisplayType(...) == " + displayType);
               FSDebug.debugTrace("findOrCreateLeaderboard(...) == " + Steamworks.findOrCreateLeaderboard(name,sortMethod,displayType));
               break;
            case SteamConstants.RESPONSE_OnDownloadLeaderboardEntries:
               FSDebug.debugTrace("RESPONSE_OnDownloadLeaderboardEntries: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               entries = Steamworks.downloadLeaderboardEntriesResult(scoreDetails);
               FSDebug.debugTrace("downloadLeaderboardEntriesResult(" + scoreDetails + ") == " + (entries ? "Array, size " + entries.length : "null"));
               i = 0;
               while(i < entries.length)
               {
                  en = entries[i];
                  FSDebug.debugTrace(i + ": " + en.userID + ", " + en.globalRank + ", " + en.score + ", " + en.numDetails + "//" + en.details.length);
                  d = 0;
                  while(d < en.details.length)
                  {
                     FSDebug.debugTrace("\tdetails[" + d + "] == " + en.details[d]);
                     d++;
                  }
                  i++;
               }
               scoreDetails = 0;
               break;
            case SteamConstants.RESPONSE_OnUploadLeaderboardScore:
               FSDebug.debugTrace("RESPONSE_OnUploadLeaderboardScore: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               sr = Steamworks.uploadLeaderboardScoreResult();
               FSDebug.debugTrace("uploadLeaderboardScoreResult() == " + sr);
               FSDebug.debugTrace("success: " + sr.success + ", score: " + sr.score + ", changed: " + sr.scoreChanged + ", rank: " + sr.previousGlobalRank + " -> " + sr.newGlobalRank);
               getUserScore(null);
               break;
            case SteamConstants.RESPONSE_OnFileShared:
               FSDebug.debugTrace("RESPONSE_OnFileShared: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               FSDebug.debugTrace("fileShareResult() == " + Steamworks.fileShareResult());
               apiCall = Boolean(Steamworks.publishWorkshopFile("test.txt","",_appId,"Test.txt","Test.txt",WorkshopConstants.VISIBILITY_Private,["TestTag"],WorkshopConstants.FILETYPE_Community));
               FSDebug.debugTrace("publishWorkshopFile(\'test.txt\' ...) == " + apiCall);
               break;
            case SteamConstants.RESPONSE_OnPublishWorkshopFile:
               FSDebug.debugTrace("RESPONSE_OnPublishWorkshopFile: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               publishedFile = Steamworks.publishWorkshopFileResult();
               FSDebug.debugTrace("File published as " + publishedFile);
               if(publishedFile == WorkshopConstants.PUBLISHEDFILEID_Invalid)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               FSDebug.debugTrace("subscribePublishedFile(...) == " + Steamworks.subscribePublishedFile(publishedFile));
               break;
            case SteamConstants.RESPONSE_OnEnumerateUserSubscribedFiles:
               FSDebug.debugTrace("RESPONSE_OnEnumerateUserSubscribedFiles: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               subRes = Steamworks.enumerateUserSubscribedFilesResult();
               FSDebug.debugTrace("User subscribed files: " + subRes.resultsReturned + "/" + subRes.totalResults);
               i = 0;
               while(i < subRes.resultsReturned)
               {
                  id = subRes.publishedFileId[i];
                  apiCall = Boolean(Steamworks.getPublishedFileDetails(subRes.publishedFileId[i]));
                  FSDebug.debugTrace(i + ": " + subRes.publishedFileId[i] + " (" + subRes.timeSubscribed[i] + ") - " + apiCall);
                  i++;
               }
               if(subRes.resultsReturned > 1)
               {
                  subbedFile = subRes.publishedFileId[1];
                  apiCall = Boolean(Steamworks.unsubscribePublishedFile(subbedFile));
                  FSDebug.debugTrace("unsubscribePublishedFile(" + subbedFile + ") == " + apiCall);
               }
               if(subRes.resultsReturned > 0)
               {
                  apiCall = Boolean(Steamworks.setUserPublishedFileAction(subRes.publishedFileId[0],WorkshopConstants.FILEACTION_Played));
                  FSDebug.debugTrace("setUserPublishedFileAction(..., Played) == " + apiCall);
               }
               break;
            case SteamConstants.RESPONSE_OnEnumerateUserSharedWorkshopFiles:
            case SteamConstants.RESPONSE_OnEnumerateUserPublishedFiles:
               shared = e.req_type == SteamConstants.RESPONSE_OnEnumerateUserSharedWorkshopFiles;
               FSDebug.debugTrace((shared ? "RESPONSE_OnEnumerateUserSharedWorkshopFile" : "RESPONSE_OnEnumerateUserPublishedFiles: ") + e.response);
               if(e.response != SteamResults.OK)
               {
                  return;
               }
               userRes = shared ? Steamworks.enumerateUserSharedWorkshopFilesResult() : Steamworks.enumerateUserPublishedFilesResult();
               FSDebug.debugTrace("User " + (shared ? "shared" : "published") + " files: " + userRes.resultsReturned + "/" + userRes.totalResults);
               i = 0;
               while(i < userRes.resultsReturned)
               {
                  FSDebug.debugTrace(i + ": " + userRes.publishedFileId[i]);
                  i++;
               }
               if(userRes.resultsReturned > 0)
               {
                  publishedFile = userRes.publishedFileId[0];
               }
               break;
            case SteamConstants.RESPONSE_OnEnumeratePublishedWorkshopFiles:
               FSDebug.debugTrace("RESPONSE_OnEnumeratePublishedWorkshopFiles: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               fileRes = Steamworks.enumeratePublishedWorkshopFilesResult();
               FSDebug.debugTrace("Workshop files: " + fileRes.resultsReturned + "/" + fileRes.totalResults);
               i = 0;
               while(i < fileRes.resultsReturned)
               {
                  FSDebug.debugTrace(i + ": " + fileRes.publishedFileId[i] + " - " + fileRes.score[i]);
                  i++;
               }
               if(fileRes.resultsReturned > 0)
               {
                  f = fileRes.publishedFileId[0];
                  apiCall = Boolean(Steamworks.updateUserPublishedItemVote(f,true));
                  FSDebug.debugTrace("updateUserPublishedItemVote(" + f + ", true) == " + apiCall);
                  apiCall = Boolean(Steamworks.getPublishedItemVoteDetails(f));
                  FSDebug.debugTrace("getPublishedItemVoteDetails(" + f + ") == " + apiCall);
                  apiCall = Boolean(Steamworks.getUserPublishedItemVoteDetails(f));
                  FSDebug.debugTrace("getUserPublishedItemVoteDetails(" + f + ") == " + apiCall);
               }
               break;
            case SteamConstants.RESPONSE_OnEnumeratePublishedFilesByUserAction:
               FSDebug.debugTrace("RESPONSE_OnEnumeratePublishedFilesByUserAction: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               actionRes = Steamworks.enumeratePublishedFilesByUserActionResult();
               FSDebug.debugTrace("Files for action " + actionRes.action + ": " + actionRes.resultsReturned + "/" + actionRes.totalResults);
               i = 0;
               while(i < actionRes.resultsReturned)
               {
                  FSDebug.debugTrace(i + ": " + actionRes.publishedFileId[i] + " - " + actionRes.timeUpdated[i]);
                  if(actionRes.action == WorkshopConstants.FILEACTION_Played)
                  {
                     FSDebug.debugTrace("setUserPublishedFileAction(..., Completed) == " + Steamworks.setUserPublishedFileAction(actionRes.publishedFileId[i],WorkshopConstants.FILEACTION_Completed));
                  }
                  i++;
               }
               break;
            case SteamConstants.RESPONSE_OnGetPublishedFileDetails:
               FSDebug.debugTrace("RESPONSE_OnGetPublishedFileDetails: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               res = Steamworks.getPublishedFileDetailsResult(id);
               FSDebug.debugTrace("Result for " + id + ": " + res);
               if(res)
               {
                  FSDebug.debugTrace("File: " + res.fileName + ", handle: " + res.fileHandle);
                  ugcHandle = res.fileHandle;
                  apiCall = Boolean(Steamworks.UGCDownload(res.fileHandle,0));
                  FSDebug.debugTrace("UGCDownload(...) == " + apiCall);
                  progress = Steamworks.getUGCDownloadProgress(res.fileHandle);
                  FSDebug.debugTrace("getUGCDownloadProgress(...) == " + progress);
                  setTimeout(function():void
                  {
                     var _loc1_:Array = Steamworks.getUGCDownloadProgress(res.fileHandle);
                     FSDebug.debugTrace("getUGCDownloadProgress(...) == " + _loc1_);
                  },1000);
               }
               break;
            case SteamConstants.RESPONSE_OnUGCDownload:
               FSDebug.debugTrace("RESPONSE_OnUGCDownload: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               ugcResult = Steamworks.getUGCDownloadResult(ugcHandle);
               FSDebug.debugTrace("Result for " + ugcHandle + ": " + ugcResult);
               if(ugcResult)
               {
                  FSDebug.debugTrace("File: " + ugcResult.fileName + ", handle: " + ugcResult.fileHandle + ", size: " + ugcResult.size);
                  ba = new ByteArray();
                  apiCall = Boolean(Steamworks.UGCRead(ugcResult.fileHandle,ugcResult.size,0,ba));
                  FSDebug.debugTrace("UGCRead(...) == " + apiCall);
                  if(apiCall)
                  {
                     FSDebug.debugTrace("Result length: " + ba.position + "//" + ba.length);
                     FSDebug.debugTrace("Result: " + ba.readUTFBytes(ugcResult.size));
                  }
               }
               break;
            case SteamConstants.RESPONSE_OnGetPublishedItemVoteDetails:
               FSDebug.debugTrace("RESPONSE_OnGetPublishedItemVoteDetails: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               voteDetails = Steamworks.getPublishedItemVoteDetailsResult();
               FSDebug.debugTrace("getPublishedItemVoteDetails() == " + (voteDetails ? voteDetails.result : "null"));
               if(!voteDetails)
               {
                  return;
               }
               FSDebug.debugTrace("votes: " + voteDetails.votesFor + "//" + voteDetails.votesAgainst + ", score: " + voteDetails.score + ", reports: " + voteDetails.reports);
               break;
            case SteamConstants.RESPONSE_OnGetUserPublishedItemVoteDetails:
               FSDebug.debugTrace("RESPONSE_OnGetUserPublishedItemVoteDetails: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               userVoteDetails = Steamworks.getUserPublishedItemVoteDetailsResult();
               FSDebug.debugTrace("getUserPublishedItemVoteDetails() == " + (userVoteDetails ? userVoteDetails.result : "null"));
               if(!userVoteDetails)
               {
                  return;
               }
               FSDebug.debugTrace("vote: " + userVoteDetails.vote);
               break;
            case SteamConstants.RESPONSE_OnGetAuthSessionTicketResponse:
               FSDebug.debugTrace("RESPONSE_OnGetAuthSessionTicketResponse: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               if(authHandle == UserConstants.AUTHTICKET_Invalid)
               {
                  FSDebug.debugTrace("Invalid authHandle (cancelled?)");
                  break;
               }
               realAuthHandle = uint(Steamworks.getAuthSessionTicketResult());
               FSDebug.debugTrace("getAuthSessionTicketResult() == " + realAuthHandle);
               FSDebug.debugTrace("equal to original handle? " + (realAuthHandle == authHandle));
               authHandle = realAuthHandle;
               break;
            case SteamConstants.RESPONSE_OnEncryptedAppTicketResponse:
               FSDebug.debugTrace("RESPONSE_OnGetEncryptedAppKeyResponse: " + e.response);
               if(e.response != SteamResults.OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               encryptedAppTicket = new ByteArray();
               Steamworks.getEncryptedAppTicket(encryptedAppTicket);
               logTicket(encryptedAppTicket,"encryptedAppTicket");
               break;
            case SteamConstants.RESPONSE_OnValidateAuthTicketResponse:
               FSDebug.debugTrace("RESPONSE_OnValidateAuthTicketResponse: " + e.response);
               if(e.response != UserConstants.SESSION_OK)
               {
                  FSDebug.debugTrace("FAILED!");
                  break;
               }
               license = uint(Steamworks.userHasLicenseForApp(_userId,_appId));
               FSDebug.debugTrace("userHasLicenseForApp(...) == " + license + "(" + (license == UserConstants.LICENSE_HasLicense) + ")");
               FSDebug.debugTrace("userHasLicenseForApp(..., 999999) == " + Steamworks.userHasLicenseForApp(_userId,999999));
               FSDebug.debugTrace("endAuthSession(" + _userId + ") == " + Steamworks.endAuthSession(_userId));
               FSDebug.debugTrace("cancelAuthTicket(" + authHandle + ") == " + Steamworks.cancelAuthTicket(authHandle));
               authHandle = UserConstants.AUTHTICKET_Invalid;
               break;
            case SteamConstants.RESPONSE_OnMicroTxnAuthorizationResponse:
               FSDebug.debugTrace("RESPONSE_OnMicroTxnAuthorizationResponse: " + e.response);
               while((microTxnResponse = Steamworks.microTxnResult()) != null)
               {
                  FSDebug.debugTrace("MicroTxnOrderIDResult() == " + microTxnResponse + "\n" + " (app: " + microTxnResponse.appID + ", order: " + microTxnResponse.orderID + ", authorized: " + microTxnResponse.authorized + ")");
                  if(microTxnResponse.authorized == true)
                  {
                     SteamInAppsManager(InstanceMng.getApplication().getInAppsManager()).purchases_updatedHandler(SteamInAppsManager.STATE_PURCHASED,microTxnResponse.orderID);
                  }
                  else
                  {
                     SteamInAppsManager(InstanceMng.getApplication().getInAppsManager()).purchases_updatedHandler(SteamInAppsManager.STATE_CANCELLED);
                  }
               }
               break;
            default:
               FSDebug.debugTrace("STEAMresponse type:" + e.req_type + " response:" + e.response);
         }
      }
      
      public static function buyProduct(param1:String) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Def = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc2_:String = param1.toLowerCase();
         if(_loc2_ != null && _loc2_ != "")
         {
            _loc3_ = true;
            _loc4_ = Utils.getShopItemByProdId(param1);
            if(_loc4_)
            {
               _loc5_ = _loc4_ is DeckSlotDef;
               _loc6_ = _loc4_ is ShopBoostDef;
               if((_loc6_) && !ShopBoostDef(_loc4_).isRepurchasable())
               {
                  _loc7_ = InstanceMng.getUserDataMng().getOwnerUserData().getBoostAmount(_loc4_.getSku());
                  if(_loc7_ > 0)
                  {
                     _loc3_ = false;
                  }
               }
               else if(_loc5_)
               {
                  _loc3_ = !InstanceMng.getUserDataMng().isDeckBought(_loc4_.getIndex());
               }
            }
            if(_loc3_)
            {
               InstanceMng.getApplication().getInAppsManager().setCurrentProdIdBeingPurchased(_loc2_);
               InstanceMng.getApplication().getInAppsManager().backendBuyProduct(_loc2_);
            }
            else
            {
               Utils.setLogText("Product already purchased",true);
               InstanceMng.getApplication().getInAppsManager().onProductPurchasedCancelled(null);
            }
         }
      }
      
      public static function requestProducts(param1:Array) : void
      {
         InstanceMng.getServerConnection().getSteamProducts(SteamInAppsManager(InstanceMng.getApplication().getInAppsManager()).onProductsReceived);
      }
      
      public static function shareGame() : void
      {
         Utils.shareGame(true);
      }
      
      public static function submitStat(param1:String, param2:int) : void
      {
         var _loc3_:int = 0;
         if(param1 == Constants.STAT_GOLD_EARNED || param1 == Constants.STAT_PACKS_UNFOLDED || param1 == Constants.STAT_CARDS_RECYCLED || param1 == Constants.STAT_QUEST_CLAIMED || param1 == Constants.STAT_CARDS_CRAFTED || param1 == Constants.STAT_RAIDS_PLAYED || param1 == Constants.STAT_CARDS_OWNED || param1 == Constants.STAT_PVP_MATCHES_PLAYED || param1 == Constants.STAT_PVP_MATCHES_WON || param1 == Constants.STAT_DUNGEONS_COMPLETED)
         {
            _loc3_ = int(Steamworks.getStatInt(param1));
         }
         Steamworks.setStatInt(param1,param2 + _loc3_);
         Steamworks.storeStats();
         FSDebug.debugTrace("Stat submitted: " + param1 + " Current value: " + Steamworks.getStatInt(param1));
      }
      
      public function writeFileToCloud(param1:String, param2:String) : Boolean
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(param2);
         return Steamworks.fileWrite(param1,_loc3_);
      }
      
      public function readFileFromCloud(param1:String) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         if(Steamworks.fileRead(param1,_loc2_))
         {
            return _loc2_.readUTFBytes(_loc2_.length);
         }
         return "";
      }
      
      private function toggleAchievement(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("setOverlayNotificationPosition(" + this.overlayPosition + ") == " + Steamworks.setOverlayNotificationPosition(this.overlayPosition));
         var _loc2_:Boolean = Boolean(Steamworks.isAchievement("ACH_WIN_ONE_GAME"));
         FSDebug.debugTrace("isAchievement(\'ACH_WIN_ONE_GAME\') == " + _loc2_);
         if(!_loc2_)
         {
            FSDebug.debugTrace("setAchievement(\'ACH_WIN_ONE_GAME\') == " + Steamworks.setAchievement("ACH_WIN_ONE_GAME"));
         }
         else
         {
            FSDebug.debugTrace("clearAchievement(\'ACH_WIN_ONE_GAME\') == " + Steamworks.clearAchievement("ACH_WIN_ONE_GAME"));
         }
         this.overlayPosition = (this.overlayPosition + 1) % (UtilsConstants.OVERLAYPOSITION_BottomRight + 1);
      }
      
      private function indicateProgress(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.indicateAchievementProgress("ACH_TRAVEL_FAR_SINGLE",1,3));
         FSDebug.debugTrace("indicateAchievementProgress(\'ACH_TRAVEL_FAR_SINGLE\', 1, 3) == " + _loc2_);
      }
      
      private function getFriendByIndex(param1:int, param2:int = 4) : String
      {
         var _loc3_:int = int(Steamworks.getFriendCount(param2));
         FSDebug.debugTrace("getFriendCount(" + param2 + ") == " + _loc3_);
         if(_loc3_ == 0)
         {
            FSDebug.debugTrace("No friends, returning own id");
            return _userId;
         }
         var _loc4_:String = Steamworks.getFriendByIndex(0,param2);
         FSDebug.debugTrace("getFriendByIndex(0, " + param2 + ") == " + _loc4_);
         FSDebug.debugTrace("getFriendPersonaName(" + _loc4_ + ") == " + Steamworks.getFriendPersonaName(_loc4_));
         return _loc4_;
      }
      
      private function checkFriends(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         this.getFriendByIndex(0);
         this.getFriendByIndex(0,FriendConstants.FRIENDFLAG_Blocked | FriendConstants.FRIENDFLAG_Ignored);
      }
      
      private function getSmallFriendAvatar(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:String = this.getFriendByIndex(0);
         var _loc3_:BitmapData = Steamworks.getSmallFriendAvatar(_loc2_);
         var _loc4_:String = _loc3_ != null ? "(" + _loc3_.width + ", " + _loc3_.height + ")" : "null";
         FSDebug.debugTrace("Steamworks.getSmallFriendAvatar(" + _loc2_ + ") result == " + _loc4_);
         this.changeAvatarBitmap(_loc3_);
      }
      
      private function getMediumFriendAvatar(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:String = this.getFriendByIndex(0);
         var _loc3_:BitmapData = Steamworks.getMediumFriendAvatar(_loc2_);
         var _loc4_:String = _loc3_ != null ? "(" + _loc3_.width + ", " + _loc3_.height + ")" : "null";
         FSDebug.debugTrace("Steamworks.getMediumFriendAvatar(" + _loc2_ + ") result == " + _loc4_);
         this.changeAvatarBitmap(_loc3_);
      }
      
      private function clearAvatarBitmap(param1:Event = null) : void
      {
         if(_avatarBitmap != null && Boolean(_avatarBitmap.parent))
         {
            _avatarBitmap.parent.removeChild(_avatarBitmap);
         }
      }
      
      private function changeAvatarBitmap(param1:BitmapData) : void
      {
      }
      
      private function toggleCloudEnabled(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.isCloudEnabledForApp());
         FSDebug.debugTrace("isCloudEnabledForApp() == " + _loc2_);
         FSDebug.debugTrace("setCloudEnabledForApp(" + !_loc2_ + ") == " + Steamworks.setCloudEnabledForApp(!_loc2_));
         FSDebug.debugTrace("isCloudEnabledForApp() == " + Steamworks.isCloudEnabledForApp());
      }
      
      private function readTestFile(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("readFileFromCloud(\'test.txt\') == " + this.readFileFromCloud("test.txt"));
      }
      
      private function toggleFile(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.fileExists("test.txt"));
         FSDebug.debugTrace("fileExists(\'test.txt\') == " + _loc2_);
         if(_loc2_)
         {
            FSDebug.debugTrace("readFileFromCloud(\'test.txt\') == " + this.readFileFromCloud("test.txt"));
            FSDebug.debugTrace("fileDelete(\'test.txt\') == " + Steamworks.fileDelete("test.txt"));
            FSDebug.debugTrace("fileDelete(\'updated_test.txt\') == " + Steamworks.fileDelete("updated_test.txt"));
         }
         else
         {
            FSDebug.debugTrace("writeFileToCloud(\'test.txt\',\'click\') == " + this.writeFileToCloud("test.txt","click"));
            FSDebug.debugTrace("writeFileToCloud(\'updated_test.txt\',...) == " + this.writeFileToCloud("updated_test.txt","updated content"));
         }
      }
      
      private function publishFile(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("fileShare(\'test.txt\') == " + Steamworks.fileShare("test.txt"));
      }
      
      private function deletePublishedFile(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         if(!publishedFile || publishedFile == WorkshopConstants.PUBLISHEDFILEID_Invalid)
         {
            FSDebug.debugTrace("No file handle set, publish or enumerate first");
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.unsubscribePublishedFile(publishedFile));
         FSDebug.debugTrace("unsubscribePublishedFile(" + publishedFile + ") == " + _loc2_);
         _loc2_ = Boolean(Steamworks.deletePublishedFile(publishedFile));
         FSDebug.debugTrace("deletePublishedFile(" + publishedFile + ") == " + _loc2_);
      }
      
      private function requestEncryptedAppTicket(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("Try to request encrypted app ticket");
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes("Example payload");
         var _loc3_:Boolean = Boolean(Steamworks.requestEncryptedAppTicket(_loc2_));
         FSDebug.debugTrace("Request encrypted app ticket result: " + _loc3_);
      }
      
      private function activateOverlay(param1:Event = null) : void
      {
         var e:Event = param1;
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("isOverlayEnabled() == " + Steamworks.isOverlayEnabled());
         FSDebug.debugTrace("activateGameOverlay(\'Friends\') == " + Steamworks.activateGameOverlay("Friends"));
         setTimeout(function():void
         {
            FSDebug.debugTrace("isOverlayEnabled() == " + Steamworks.isOverlayEnabled());
         },1000);
      }
      
      private function activateOverlayToUser(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.activateGameOverlayToUser("steamid",_userId));
         FSDebug.debugTrace("activateGameOverlay(\'steamid\', " + _userId + ") == " + _loc2_);
      }
      
      private function activateOverlayToWebpage(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.activateGameOverlayToWebPage("http://www.steamgames.com/"));
         FSDebug.debugTrace("activateGameOverlayToWebPage(...) == " + _loc2_);
      }
      
      private function activateOverlayInvite(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("activateGameOverlayInviteDiaFSDebug.debugTrace(\'0\') == " + Steamworks.activateGameOverlayInviteDialog("0"));
      }
      
      private function enumerateSubscribedFiles(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("enumerateUserSubscribedFiles(0) == " + Steamworks.enumerateUserSubscribedFiles(0));
      }
      
      private function enumerateUserPublishedFiles(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         FSDebug.debugTrace("enumerateUserPublishedFiles(0) == " + Steamworks.enumerateUserPublishedFiles(0));
      }
      
      private function enumerateSharedFiles(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:String = Steamworks.getUserID();
         var _loc3_:Boolean = Boolean(Steamworks.enumerateUserSharedWorkshopFiles(_loc2_,0,[],[]));
         FSDebug.debugTrace("enumerateSharedFiles(" + _loc2_ + ", 0, [], []) == " + _loc3_);
      }
      
      private function enumerateWorkshopFiles(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.enumeratePublishedWorkshopFiles(WorkshopConstants.ENUMTYPE_RankedByVote,0,10,0,[],[]));
         FSDebug.debugTrace("enumerateSharedFiles(...) == " + _loc2_);
      }
      
      private function enumeratePlayedFiles(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.enumeratePublishedFilesByUserAction(WorkshopConstants.FILEACTION_Played,0));
         FSDebug.debugTrace("enumeratePublishedFilesByUserAction(Played, 0) == " + _loc2_);
      }
      
      private function enumerateCompletedFiles(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.enumeratePublishedFilesByUserAction(WorkshopConstants.FILEACTION_Completed,0));
         FSDebug.debugTrace("enumeratePublishedFilesByUserAction(Completed, 0) == " + _loc2_);
      }
      
      private function updateFile(param1:Event = null) : void
      {
         if(!publishedFile || publishedFile == WorkshopConstants.PUBLISHEDFILEID_Invalid)
         {
            FSDebug.debugTrace("No file handle set, publish or enumerate first");
            return;
         }
         var _loc2_:String = Steamworks.createPublishedFileUpdateRequest(publishedFile);
         FSDebug.debugTrace("createPublishedFileUpdateRequest() == " + _loc2_);
         if(_loc2_ == WorkshopConstants.FILEUPDATEHANDLE_Invalid)
         {
            return;
         }
         var _loc3_:Boolean = Boolean(Steamworks.updatePublishedFileDescription(_loc2_,"Test updated description"));
         FSDebug.debugTrace("updatePublishedFileDescription(...) == " + _loc3_);
         if(!_loc3_)
         {
            return;
         }
         if(Steamworks.fileExists("updated_test.txt"))
         {
            _loc3_ = Boolean(Steamworks.updatePublishedFileFile(_loc2_,"updated_test.txt"));
            FSDebug.debugTrace("updatePublishedFileFile(...) == " + _loc3_);
            if(!_loc3_)
            {
               return;
            }
         }
         _loc3_ = Boolean(Steamworks.updatePublishedFileTitle(_loc2_,"Updated test title"));
         FSDebug.debugTrace("updatePublishedFileTitle(...) == " + _loc3_);
         if(!_loc3_)
         {
            return;
         }
         _loc3_ = Boolean(Steamworks.updatePublishedFileTags(_loc2_,["TestTag","Updated TestTag"]));
         FSDebug.debugTrace("updatePublishedFileTags(...) = " + _loc3_);
         if(!_loc3_)
         {
            return;
         }
         _loc3_ = Boolean(Steamworks.updatePublishedFileSetChangeDescription(_loc2_,"Test update!"));
         FSDebug.debugTrace("updatePublishedFileSetChangeDescription(...) == " + _loc3_);
         if(!_loc3_)
         {
            return;
         }
         _loc3_ = Boolean(Steamworks.updatePublishedFileVisibility(_loc2_,WorkshopConstants.VISIBILITY_Public));
         FSDebug.debugTrace("updatePublishedFileVisibility(Public) == " + _loc3_);
         if(!_loc3_)
         {
            return;
         }
         _loc3_ = Boolean(Steamworks.commitPublishedFileUpdate(_loc2_));
         FSDebug.debugTrace("commitPublishedFileUpdate(...) == " + _loc3_);
      }
      
      private function invalidCall(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(Steamworks.getPublishedFileDetails(undefined));
         FSDebug.debugTrace("getPublishedFileDetails(undefined) == " + _loc2_);
      }
      
      private function getTopScores(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         if(!leaderboard)
         {
            FSDebug.debugTrace("No Leaderboard handle set");
            return;
         }
         FSDebug.debugTrace("downloadLeaderboardEntries(...) == " + Steamworks.downloadLeaderboardEntries(leaderboard,UserStatsConstants.DATAREQUEST_Global,1,10));
      }
      
      private function getUserScoreWithData(param1:Event = null) : void
      {
         scoreDetails = 3;
         getScoresAroundUser(param1,0,0);
      }
      
      private function getFriendScores(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         if(!leaderboard)
         {
            FSDebug.debugTrace("No Leaderboard handle set");
            return;
         }
         FSDebug.debugTrace("downloadLeaderboardEntries(...) == " + Steamworks.downloadLeaderboardEntries(leaderboard,UserStatsConstants.DATAREQUEST_Friends));
      }
      
      private function uploadScore(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         if(!leaderboard)
         {
            FSDebug.debugTrace("No Leaderboard handle set");
            return;
         }
         FSDebug.debugTrace("uploadScore(...) == " + Steamworks.uploadLeaderboardScore(leaderboard,UserStatsConstants.UPLOADSCOREMETHOD_KeepBest,15));
      }
      
      private function uploadForceScore(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         if(!leaderboard)
         {
            FSDebug.debugTrace("No Leaderboard handle set");
            return;
         }
         FSDebug.debugTrace("uploadScore(...) == " + Steamworks.uploadLeaderboardScore(leaderboard,UserStatsConstants.UPLOADSCOREMETHOD_ForceUpdate,20));
      }
      
      private function uploadScoreWithData(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         if(!leaderboard)
         {
            FSDebug.debugTrace("No Leaderboard handle set");
            return;
         }
         scoreDetails = 3;
         FSDebug.debugTrace("uploadScore(...) == " + Steamworks.uploadLeaderboardScore(leaderboard,UserStatsConstants.UPLOADSCOREMETHOD_ForceUpdate,20,[1,2,3]));
      }
      
      private function invalidLeaderboardEntries(param1:Event = null) : void
      {
         if(!Steamworks.isReady)
         {
            return;
         }
         if(!leaderboard)
         {
            FSDebug.debugTrace("No Leaderboard handle set, continuing anyway");
         }
         FSDebug.debugTrace("downloadLeaderboardEntriesResult(3) == " + Steamworks.downloadLeaderboardEntriesResult(3));
      }
   }
}

