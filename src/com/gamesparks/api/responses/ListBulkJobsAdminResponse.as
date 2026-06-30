package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListBulkJobsAdminResponse extends GSResponse
   {
      
      public function ListBulkJobsAdminResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getBulkJobs() : Vector.<BulkJob>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<BulkJob> = new Vector.<BulkJob>();
         if(data.bulkJobs != null)
         {
            _loc2_ = data.bulkJobs;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new BulkJob(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

