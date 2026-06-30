package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class Challenge extends GSData
   {
      
      public function Challenge(param1:Object)
      {
         super(param1);
      }
      
      public function getAccepted() : Vector.<PlayerDetail>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<PlayerDetail> = new Vector.<PlayerDetail>();
         if(data.accepted != null)
         {
            _loc2_ = data.accepted;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new PlayerDetail(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getChallengeId() : String
      {
         if(data.challengeId != null)
         {
            return data.challengeId;
         }
         return null;
      }
      
      public function getChallengeMessage() : String
      {
         if(data.challengeMessage != null)
         {
            return data.challengeMessage;
         }
         return null;
      }
      
      public function getChallengeName() : String
      {
         if(data.challengeName != null)
         {
            return data.challengeName;
         }
         return null;
      }
      
      public function getChallenged() : Vector.<PlayerDetail>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<PlayerDetail> = new Vector.<PlayerDetail>();
         if(data.challenged != null)
         {
            _loc2_ = data.challenged;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new PlayerDetail(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getChallenger() : PlayerDetail
      {
         if(data.challenger != null)
         {
            return new PlayerDetail(data.challenger);
         }
         return null;
      }
      
      public function getCurrency1Wager() : Number
      {
         if(data.currency1Wager != null)
         {
            return data.currency1Wager;
         }
         return NaN;
      }
      
      public function getCurrency2Wager() : Number
      {
         if(data.currency2Wager != null)
         {
            return data.currency2Wager;
         }
         return NaN;
      }
      
      public function getCurrency3Wager() : Number
      {
         if(data.currency3Wager != null)
         {
            return data.currency3Wager;
         }
         return NaN;
      }
      
      public function getCurrency4Wager() : Number
      {
         if(data.currency4Wager != null)
         {
            return data.currency4Wager;
         }
         return NaN;
      }
      
      public function getCurrency5Wager() : Number
      {
         if(data.currency5Wager != null)
         {
            return data.currency5Wager;
         }
         return NaN;
      }
      
      public function getCurrency6Wager() : Number
      {
         if(data.currency6Wager != null)
         {
            return data.currency6Wager;
         }
         return NaN;
      }
      
      public function getCurrencyWagers() : Object
      {
         if(data.currencyWagers != null)
         {
            return data.currencyWagers;
         }
         return null;
      }
      
      public function getDeclined() : Vector.<PlayerDetail>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<PlayerDetail> = new Vector.<PlayerDetail>();
         if(data.declined != null)
         {
            _loc2_ = data.declined;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new PlayerDetail(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
      
      public function getEndDate() : Date
      {
         if(data.endDate != null)
         {
            return RFC3339toDate(data.endDate);
         }
         return null;
      }
      
      public function getExpiryDate() : Date
      {
         if(data.expiryDate != null)
         {
            return RFC3339toDate(data.expiryDate);
         }
         return null;
      }
      
      public function getMaxTurns() : Number
      {
         if(data.maxTurns != null)
         {
            return data.maxTurns;
         }
         return NaN;
      }
      
      public function getNextPlayer() : String
      {
         if(data.nextPlayer != null)
         {
            return data.nextPlayer;
         }
         return null;
      }
      
      public function getScriptData() : Object
      {
         if(data.scriptData != null)
         {
            return data.scriptData;
         }
         return null;
      }
      
      public function getShortCode() : String
      {
         if(data.shortCode != null)
         {
            return data.shortCode;
         }
         return null;
      }
      
      public function getStartDate() : Date
      {
         if(data.startDate != null)
         {
            return RFC3339toDate(data.startDate);
         }
         return null;
      }
      
      public function getState() : String
      {
         if(data.state != null)
         {
            return data.state;
         }
         return null;
      }
      
      public function getTurnCount() : Vector.<PlayerTurnCount>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<PlayerTurnCount> = new Vector.<PlayerTurnCount>();
         if(data.turnCount != null)
         {
            _loc2_ = data.turnCount;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new PlayerTurnCount(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

