package com.fs.tcgengine.view.components.pvp
{
   import com.fs.tcgengine.view.components.Component;
   
   public class PvPRewardSlot extends Component
   {
      
      private var mRewardL1:PVPRewardInfo;
      
      private var mRewardL2:PVPRewardInfo;
      
      private var mRewardL3:PVPRewardInfo;
      
      public function PvPRewardSlot(param1:Object, param2:Object, param3:Object)
      {
         super();
         this.createUI(param1,param2,param3);
      }
      
      private function createUI(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:Object = new Object();
         if(this.mRewardL1 == null)
         {
            this.mRewardL1 = new PVPRewardInfo(param1);
            addChild(this.mRewardL1);
         }
         if(this.mRewardL2 == null)
         {
            this.mRewardL2 = new PVPRewardInfo(param2);
            this.mRewardL2.x = this.mRewardL1.x + this.mRewardL1.width * 1.125;
            addChild(this.mRewardL2);
         }
         if(this.mRewardL3 == null)
         {
            this.mRewardL3 = new PVPRewardInfo(param3);
            this.mRewardL3.x = this.mRewardL2.x + this.mRewardL2.width * 1.125;
            addChild(this.mRewardL3);
         }
      }
      
      override public function dispose() : void
      {
         if(this.mRewardL1)
         {
            this.mRewardL1.removeFromParent(true);
            this.mRewardL1 = null;
         }
         if(this.mRewardL2)
         {
            this.mRewardL2.removeFromParent(true);
            this.mRewardL2 = null;
         }
         if(this.mRewardL3)
         {
            this.mRewardL3.removeFromParent(true);
            this.mRewardL3 = null;
         }
         super.dispose();
      }
   }
}

