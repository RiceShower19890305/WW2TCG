package com.fs.tcgengine.view.guilds
{
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.utils.Align;
   
   public class GuildScoreBatch extends GuildRankingBatch
   {
      
      public function GuildScoreBatch(param1:String, param2:Number)
      {
         super(param1,param2);
         touchable = true;
      }
      
      override protected function createScoreTextfield() : void
      {
         var _loc1_:Number = NaN;
         if(mScoreTextfield == null)
         {
            _loc1_ = !isNaN(mScore) ? mScore : 0;
            mScoreTextfield = new FSTextfield(mBG.width * 0.69,mBG.height,Utils.coolFormat(_loc1_,0));
            mScoreTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD);
            mScoreTextfield.format.horizontalAlign = Align.RIGHT;
            mScoreTextfield.x = mBG.x + mBG.width * 0.285;
            mScoreTextfield.y = mBG.y;
            addChild(mScoreTextfield);
         }
         if(_loc1_ != -1)
         {
            setTooltipText(Utils.formatNumber(_loc1_));
         }
      }
   }
}

