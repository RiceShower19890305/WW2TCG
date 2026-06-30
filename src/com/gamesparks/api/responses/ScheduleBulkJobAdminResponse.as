package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ScheduleBulkJobAdminResponse extends GSResponse
   {
      
      public function ScheduleBulkJobAdminResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getEstimatedCount() : Number
      {
         if(data.estimatedCount != null)
         {
            return data.estimatedCount;
         }
         return NaN;
      }
      
      public function getJobId() : String
      {
         if(data.jobId != null)
         {
            return data.jobId;
         }
         return null;
      }
   }
}

