package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class ListVirtualGoodsResponse extends GSResponse
   {
      
      public function ListVirtualGoodsResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getVirtualGoods() : Vector.<VirtualGood>
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<VirtualGood> = new Vector.<VirtualGood>();
         if(data.virtualGoods != null)
         {
            _loc2_ = data.virtualGoods;
            for(_loc3_ in _loc2_)
            {
               _loc1_.push(new VirtualGood(_loc2_[_loc3_]));
            }
         }
         return _loc1_;
      }
   }
}

