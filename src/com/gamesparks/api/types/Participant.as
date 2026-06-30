package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class Participant extends GSData
   {
      
      public function Participant(param1:Object)
      {
         super(param1);
      }
      
      public function getAchievements() : Vector.<String>
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         if(data.achievements != null)
         {
            _loc2_ = data.achievements;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(_loc2_[_loc3_]);
            }
         }
         return _loc1_;
      }
      
      public function getDisplayName() : String
      {
         if(data.displayName != null)
         {
            return data.displayName;
         }
         return null;
      }
      
      public function getExternalIds() : Object
      {
         if(data.externalIds != null)
         {
            return data.externalIds;
         }
         return null;
      }
      
      public function getId() : String
      {
         if(data.id != null)
         {
            return data.id;
         }
         return null;
      }
      
      public function getOnline() : Boolean
      {
         if(data.online != null)
         {
            return data.online;
         }
         return false;
      }
      
      public function getParticipantData() : Object
      {
         if(data.participantData != null)
         {
            return data.participantData;
         }
         return null;
      }
      
      public function getPeerId() : Number
      {
         if(data.peerId != null)
         {
            return data.peerId;
         }
         return NaN;
      }
      
      public function getScriptData() : Object
      {
         if(data.scriptData != null)
         {
            return data.scriptData;
         }
         return null;
      }
      
      public function getVirtualGoods() : Vector.<String>
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         if(data.virtualGoods != null)
         {
            _loc2_ = data.virtualGoods;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(_loc2_[_loc3_]);
            }
         }
         return _loc1_;
      }
   }
}

