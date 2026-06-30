package com.fs.tcgengine.view.components.battle
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.greensock.easing.Back;
   import starling.core.Starling;
   
   public class TurnPanel extends Component
   {
      
      private const TURN_PANEL_IMG_NAME:String = "turn_panel";
      
      private const TURN_PANEL_LEFT_IMG_NAME:String = "turn_panel_left";
      
      private const TURN_PANEL_RIGHT_IMG_NAME:String = "turn_panel_right";
      
      private var mBG:FSImage;
      
      private var mBGLeft:FSImage;
      
      private var mBGRight:FSImage;
      
      private var mTextfield:FSTextfield;
      
      private var mIsShown:Boolean = false;
      
      public function TurnPanel()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         visible = false;
         this.createBG();
         this.createTextfield();
         alignPivot();
         touchable = false;
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.TURN_PANEL_IMG_NAME));
            if(Config.getConfig().gameHasTurnPanelAnimation())
            {
               if(InstanceMng.getBattleEngine().isPvPMatch())
               {
                  this.mBG.x = Starling.current.stage.stageWidth / 2;
               }
               else
               {
                  this.mBG.x = Starling.current.stage.stageWidth / 2 - this.mBG.width / 2;
               }
            }
            this.mBG.touchable = false;
            addChild(this.mBG);
         }
         if(Config.getConfig().gameHasTurnPanelAnimation())
         {
            if(this.mBGLeft == null)
            {
               this.mBGLeft = new FSImage(Root.assets.getTexture(this.TURN_PANEL_LEFT_IMG_NAME));
               this.mBGLeft.x = this.mBG.x + this.mBGLeft.width * 0.3;
               this.mBGLeft.touchable = false;
               addChild(this.mBGLeft);
            }
            if(this.mBGRight == null)
            {
               this.mBGRight = new FSImage(Root.assets.getTexture(this.TURN_PANEL_RIGHT_IMG_NAME));
               this.mBGRight.x = this.mBG.x + this.mBG.width - this.mBGRight.width * 1.3;
               this.mBGRight.touchable = false;
               addChild(this.mBGRight);
            }
         }
      }
      
      private function createTextfield() : void
      {
         if(this.mTextfield == null)
         {
            this.mTextfield = new FSTextfield(this.mBG.width * 0.8,this.mBG.height * 0.9,"");
            this.mTextfield.touchable = false;
            if(Config.getConfig().gameHasTurnPanelAnimation())
            {
               this.mTextfield.x = this.mBG.x + this.mBG.width * 0.1;
            }
            else
            {
               this.mTextfield.x = (this.mBG.width - this.mTextfield.width) / 2;
            }
            this.mTextfield.y = this.mBG.height - this.mTextfield.height;
            addChild(this.mTextfield);
         }
      }
      
      public function performFadeIn(param1:String) : void
      {
         this.mIsShown = true;
         if(this.mTextfield != null)
         {
            this.mTextfield.text = param1;
         }
         scaleX = 0;
         scaleY = 0;
         visible = true;
         SpecialFX.createZoomAlphaTween(this,0.5,0,1,0,1,Back.easeIn);
         if(Config.getConfig().gameHasTurnPanelAnimation())
         {
            this.resetPositionLateralsBG();
            this.createLateralsTransition();
         }
      }
      
      private function createLateralsTransition() : void
      {
         var _loc1_:FSCoordinate = null;
         var _loc2_:FSCoordinate = null;
         if(this.mBGLeft)
         {
            _loc1_ = new FSCoordinate(this.mBGLeft.x - this.mBGLeft.width * 0.3,this.mBGLeft.y);
            SpecialFX.createTransition(this.mBGLeft,_loc1_);
         }
         if(this.mBGRight)
         {
            _loc2_ = new FSCoordinate(this.mBGRight.x + this.mBGRight.width * 0.3,this.mBGRight.y);
            SpecialFX.createTransition(this.mBGRight,_loc2_);
         }
      }
      
      private function resetPositionLateralsBG() : void
      {
         if(this.mBGLeft)
         {
            this.mBGLeft.x = this.mBG.x + this.mBGLeft.width * 0.3;
         }
         if(this.mBGRight)
         {
            this.mBGRight.x = this.mBG.x + this.mBG.width - this.mBGRight.width * 1.3;
         }
      }
      
      public function performFadeOut(param1:Number = 0.5) : void
      {
         this.mIsShown = false;
         SpecialFX.createZoomAlphaTween(this,param1,1,0,1,0,Back.easeOut,this.unload);
      }
      
      public function unload() : void
      {
         visible = false;
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGLeft)
         {
            this.mBGLeft.removeFromParent(true);
            this.mBGLeft = null;
         }
         if(this.mBGRight)
         {
            this.mBGRight.removeFromParent(true);
            this.mBGRight = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
         super.dispose();
      }
      
      public function isShown() : Boolean
      {
         return this.mIsShown;
      }
   }
}

