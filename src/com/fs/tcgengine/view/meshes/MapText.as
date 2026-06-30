package com.fs.tcgengine.view.meshes
{
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.FSSprite3D;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.map.MapPlane;
   import starling.utils.Align;
   
   public class MapText extends FSSprite3D
   {
      
      public static const STD_WIDTH:int = 100;
      
      public static const STD_HEIGHT:int = 100;
      
      private var mPositionsJSON:Object;
      
      protected var mParentMapPlane:MapPlane;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mSubTitleTextfield:FSTextfield;
      
      public function MapText(param1:MapPlane, param2:Object)
      {
         super();
         alignPivot();
         this.mParentMapPlane = param1;
         this.mPositionsJSON = param2;
         this.createTextfields(this.mParentMapPlane.getMapDef().calculateMapName(),this.mParentMapPlane.getMapDef().calculateMapDesc());
         this.init();
      }
      
      protected function createTextfields(param1:String, param2:String) : void
      {
         var _loc3_:int = Utils.isDesktop() ? 25 : 40;
         var _loc4_:int = Utils.isDesktop() ? 18 : 28;
         if(param1)
         {
            this.mTitleTextfield = new FSTextfield(this.mParentMapPlane.getMapPlane().width / 4,this.mParentMapPlane.getMapPlane().width / 10,param1,this.getTitleColor(),_loc3_);
         }
         if(param2)
         {
            this.mSubTitleTextfield = new FSTextfield(this.mParentMapPlane.getMapPlane().width / 4,this.mParentMapPlane.getMapPlane().width / 8,param2,this.getSubTitleColor(),_loc4_);
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.format.verticalAlign = Align.BOTTOM;
         }
         if(this.mSubTitleTextfield)
         {
            this.mSubTitleTextfield.format.verticalAlign = Align.TOP;
         }
         if(Boolean(this.mTitleTextfield) && Boolean(this.mSubTitleTextfield))
         {
            this.mSubTitleTextfield.y = this.mTitleTextfield.y + this.mTitleTextfield.height;
         }
         if(this.mTitleTextfield)
         {
            addChild(this.mTitleTextfield);
         }
         if(this.mSubTitleTextfield)
         {
            addChild(this.mSubTitleTextfield);
         }
      }
      
      protected function init() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:FSCoordinate = null;
         alignPivot();
         if(this.mPositionsJSON)
         {
            _loc1_ = Number(this.mPositionsJSON[this.mParentMapPlane.getMapDef().getIndex()].title.x);
            _loc2_ = Number(this.mPositionsJSON[this.mParentMapPlane.getMapDef().getIndex()].title.y);
            _loc3_ = Utils.getSWFCoordinates(_loc1_,_loc2_);
            moveTo(_loc3_.mX - this.mParentMapPlane.getMapPlane().width / 2,_loc3_.mY - this.mParentMapPlane.getMapPlane().height / 2 - this.height / 3,-10);
         }
         touchable = false;
      }
      
      protected function getTitleColor() : uint
      {
         return 16777215;
      }
      
      protected function getSubTitleColor() : uint
      {
         return 33023;
      }
      
      override public function dispose() : void
      {
         this.mPositionsJSON = null;
         this.mParentMapPlane = null;
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         if(this.mSubTitleTextfield)
         {
            this.mSubTitleTextfield.removeFromParent(true);
            this.mSubTitleTextfield = null;
         }
         super.dispose();
      }
   }
}

