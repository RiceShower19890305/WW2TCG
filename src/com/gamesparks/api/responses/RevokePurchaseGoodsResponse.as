package com.gamesparks.api.responses
{
   import com.gamesparks.*;
   import com.gamesparks.api.types.*;
   
   public class RevokePurchaseGoodsResponse extends GSResponse
   {
      
      public function RevokePurchaseGoodsResponse(param1:Object)
      {
         super(param1);
      }
      
      public function getRevokedGoods() : Object
      {
         if(data.revokedGoods != null)
         {
            return data.revokedGoods;
         }
         return null;
      }
   }
}

