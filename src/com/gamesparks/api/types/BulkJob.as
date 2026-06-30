package com.gamesparks.api.types
{
   import com.gamesparks.*;
   
   public class BulkJob extends GSData
   {
      
      public function BulkJob(param1:Object)
      {
         super(param1);
      }
      
      public function getActualCount() : Number
      {
         if(data.actualCount != null)
         {
            return data.actualCount;
         }
         return NaN;
      }
      
      public function getCompleted() : Date
      {
         if(data.completed != null)
         {
            return RFC3339toDate(data.completed);
         }
         return null;
      }
      
      public function getCreated() : Date
      {
         if(data.created != null)
         {
            return RFC3339toDate(data.created);
         }
         return null;
      }
      
      public function getData() : Object
      {
         if(data.data != null)
         {
            return data.data;
         }
         return null;
      }
      
      public function getDoneCount() : Number
      {
         if(data.doneCount != null)
         {
            return data.doneCount;
         }
         return NaN;
      }
      
      public function getErrorCount() : Number
      {
         if(data.errorCount != null)
         {
            return data.errorCount;
         }
         return NaN;
      }
      
      public function getEstimatedCount() : Number
      {
         if(data.estimatedCount != null)
         {
            return data.estimatedCount;
         }
         return NaN;
      }
      
      public function getId() : String
      {
         if(data.id != null)
         {
            return data.id;
         }
         return null;
      }
      
      public function getModuleShortCode() : String
      {
         if(data.moduleShortCode != null)
         {
            return data.moduleShortCode;
         }
         return null;
      }
      
      public function getPlayerQuery() : Object
      {
         if(data.playerQuery != null)
         {
            return data.playerQuery;
         }
         return null;
      }
      
      public function getScheduledTime() : Date
      {
         if(data.scheduledTime != null)
         {
            return RFC3339toDate(data.scheduledTime);
         }
         return null;
      }
      
      public function getScript() : String
      {
         if(data.script != null)
         {
            return data.script;
         }
         return null;
      }
      
      public function getStarted() : Date
      {
         if(data.started != null)
         {
            return RFC3339toDate(data.started);
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
   }
}

