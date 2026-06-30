package com.fs.tcgengine.view.misc
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TargetMng;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import starling.display.Image;
   import starling.text.TextFieldAutoSize;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class FSObjectiveTick extends FSTick
   {
      
      private var mAmountRequested:int;
      
      private var mCurrentAmount:int;
      
      private var mAmountTextfield:FSTextfield;
      
      protected var mIsInGameObjective:Boolean;
      
      private var mBG:FSImage;
      
      private var mBGText:FSImage;
      
      private var mObjType:int;
      
      private var mObjObject:Object;
      
      public function FSObjectiveTick(param1:String, param2:Boolean, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:int = -1, param7:Object = null)
      {
         this.mIsInGameObjective = param5;
         this.mObjType = param6;
         this.mObjObject = param7;
         super(param1,param2,param3,param4);
         alignPivot();
         x += width / 2;
         y += height / 2;
      }
      
      override protected function createBG() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         if(this.mIsInGameObjective)
         {
            if(this.mBG == null)
            {
               _loc1_ = mHasSimpleUI ? "objective_panel" : this.getObjectiveImageName();
               this.mBG = new FSImage(Root.assets.getTexture(_loc1_));
               _loc2_ = !Config.getConfig().battleHasSimpleUI() ? 0.85 : 1.35;
               this.mBG.scaleX = _loc2_;
               this.mBG.scaleY = _loc2_;
               addChild(this.mBG);
            }
            if(this.mBGText == null && !mHasSimpleUI)
            {
               this.mBGText = new FSImage(Root.assets.getTexture("bf_objective_layer"));
               this.mBGText.x = this.mBG.x + this.mBG.width / 2;
               this.mBGText.y = this.mBG.y;
               addChild(this.mBGText);
               addChild(this.mBG);
            }
         }
      }
      
      private function getObjectiveImageName() : String
      {
         var _loc1_:String = "objective_";
         switch(this.mObjType)
         {
            case TargetMng.MAIN_SUBOBJECTIVE:
               if(InstanceMng.getTargetMng().isSurvivalMode())
               {
                  _loc1_ += "survive";
               }
               else
               {
                  _loc1_ += "defeat";
               }
               break;
            case TargetMng.PLAY_SUBCATEGORY_SUBOBJECTIVE:
               _loc1_ += "play_" + this.mObjObject.sku;
               break;
            case TargetMng.KILL_CATEGORY_SUBOBJECTIVE:
            case TargetMng.KILL_SUBCATEGORY_SUBOBJECTIVE:
            case TargetMng.KILL_CARD_SUBOBJECTIVE:
               _loc1_ += "kill_" + this.mObjObject.sku;
         }
         return _loc1_;
      }
      
      override protected function createTickImage(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(this.mIsInGameObjective && this.mObjType != TargetMng.MAIN_SUBOBJECTIVE)
         {
            if(mTickImage == null)
            {
               _loc2_ = !mHasSimpleUI ? "bf_objective_info" : "objective_completed";
               mTickImage = new FSImage(Root.assets.getTexture(_loc2_));
            }
            mTickImage.x = !mHasSimpleUI ? this.mBG.x + this.mBG.width - mTickImage.width / 2 : (this.mBG.width - mTickImage.width) / 2;
            mTickImage.y = !mHasSimpleUI ? this.mBG.y - mTickImage.height / 2 : (this.mBG.height - mTickImage.height) / 2;
            addChild(mTickImage);
            mTickImage.visible = !mHasSimpleUI;
         }
      }
      
      override public function setChecked(param1:Boolean, param2:Boolean = true) : void
      {
         if(this.mIsInGameObjective)
         {
            if(mTickImage)
            {
               if(!mHasSimpleUI)
               {
                  mTickImage.texture = param1 ? Root.assets.getTexture("objective_completed") : Root.assets.getTexture("bf_objective_info");
               }
               else
               {
                  mTickImage.visible = param1;
               }
            }
         }
         else
         {
            super.setChecked(param1,param2);
         }
      }
      
      private function createAmountTextfield() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Image = mHasSimpleUI ? this.mBG : this.mBGText;
         if(this.mAmountTextfield == null)
         {
            this.mAmountTextfield = new FSTextfield(_loc1_.width,_loc1_.height / 4);
            this.mAmountTextfield.fontSize = FSResourceMng.FONT_STD_SEMI_SMALL_SIZE;
            this.mAmountTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_NUM_WHITE);
            this.mAmountTextfield.x = (_loc1_.width - this.mAmountTextfield.width) / 2;
            this.mAmountTextfield.y = _loc1_.height - this.mAmountTextfield.height * 1.15;
            this.mAmountTextfield.format.horizontalAlign = Align.CENTER;
            this.mAmountTextfield.format.verticalAlign = Align.CENTER;
            addChild(this.mAmountTextfield);
         }
         if(!mHasSimpleUI)
         {
            _loc2_ = this.mBG.width * 1.25;
            if(mLabelTextfield != null)
            {
               mLabelTextfield.width = this.mAmountTextfield ? this.mBGText.width - this.mBG.width / 2 - _loc2_ * 1.05 : this.mBGText.width - this.mBG.width / 2;
               mLabelTextfield.height = this.mBGText.height * 0.9;
               mLabelTextfield.x = this.mBGText.x + this.mBG.width / 2;
               mLabelTextfield.y = this.mBGText.y + (this.mBGText.height - mLabelTextfield.height) / 2;
            }
            if(this.mAmountTextfield)
            {
               this.mAmountTextfield.width = _loc2_;
               this.mAmountTextfield.height = mLabelTextfield.height;
               this.mAmountTextfield.x = mLabelTextfield.x + mLabelTextfield.width;
               this.mAmountTextfield.y = mLabelTextfield.y;
            }
         }
      }
      
      override protected function createLabel(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Image = mHasSimpleUI ? this.mBG : this.mBGText;
         if(!this.mIsInGameObjective)
         {
            super.createLabel(param1);
            return;
         }
         if(this.mIsInGameObjective)
         {
            switch(this.mObjType)
            {
               case TargetMng.MAIN_SUBOBJECTIVE:
                  break;
               case TargetMng.PLAY_SUBCATEGORY_SUBOBJECTIVE:
                  param1 = TextManager.getText("TID_GAMEMODE_BF_PLAY");
                  break;
               case TargetMng.KILL_CATEGORY_SUBOBJECTIVE:
               case TargetMng.KILL_SUBCATEGORY_SUBOBJECTIVE:
               case TargetMng.KILL_CARD_SUBOBJECTIVE:
                  param1 = TextManager.getText("TID_GAMEMODE_BF_KILL");
            }
         }
         if(mLabelTextfield == null && param1 != "")
         {
            _loc3_ = this.mObjType == TargetMng.MAIN_SUBOBJECTIVE ? int(this.mBG.height / 1.5) : int(this.mBG.height / 4);
            _loc3_ = Config.getConfig().battleSubobjectiveTextfieldFullSize() ? int(this.mBG.height * 0.95) : _loc3_;
            _loc4_ = !mHasSimpleUI ? int(this.mBGText.width - this.mBG.width / 2) : int(this.mBG.width * 0.9);
            _loc3_ = !mHasSimpleUI ? int(this.mBGText.height * 0.9) : _loc3_;
            mLabelTextfield = new FSTextfield(_loc4_,_loc3_,param1,16777215,FSResourceMng.FONT_STD_SMALL_SIZE);
            mLabelTextfield.fontName = FSResourceMng.getFontByType();
         }
         if(mLabelTextfield)
         {
            mLabelTextfield.x = !mHasSimpleUI ? this.mBGText.x + this.mBG.width / 2 : (this.mBG.width - mLabelTextfield.width) / 2;
            mLabelTextfield.y = !mHasSimpleUI ? this.mBGText.y + (this.mBGText.height - mLabelTextfield.height) / 2 : (this.mBG.height - mLabelTextfield.height) / 2;
            addChild(mLabelTextfield);
            if(Config.getConfig().showBigIconOnPlayLevelPopup())
            {
               if(!this.mIsInGameObjective)
               {
                  mLabelTextfield.autoSize = FSResourceMng.isOriental() ? TextFieldAutoSize.NONE : TextFieldAutoSize.NONE;
                  mLabelTextfield.fontSize = FSResourceMng.FONT_STD_SUBTITLE_SIZE;
                  mLabelTextfield.width = Root.assets.getTexture(Constants.ACCEPT_BUTTON_DOWN_NAME).width * 1.95;
                  mLabelTextfield.height = FSResourceMng.FONT_STD_SUBTITLE_SIZE * 1.5;
                  mLabelTextfield.fontName = FSResourceMng.getFontByType();
                  mLabelTextfield.y = mTickImage ? mTickImage.y - (mLabelTextfield.height - mTickImage.height) / 2 : -mLabelTextfield.height / 2;
               }
            }
         }
      }
      
      private function updateAmountsProgress() : void
      {
         if(this.mIsInGameObjective)
         {
            this.createAmountTextfield();
            if(this.mAmountTextfield != null)
            {
               this.mAmountTextfield.text = " (" + this.mCurrentAmount + "/" + this.mAmountRequested + ")";
            }
         }
         if(this.mCurrentAmount >= this.mAmountRequested)
         {
            this.setChecked(true);
            if(this.mAmountTextfield)
            {
               this.mAmountTextfield.color = 65280;
            }
         }
         else
         {
            this.setChecked(false);
            if(this.mAmountTextfield)
            {
               this.mAmountTextfield.color = 16711680;
            }
         }
      }
      
      public function getAmountRequested() : int
      {
         return this.mAmountRequested;
      }
      
      public function setAmountRequested(param1:int) : void
      {
         this.mAmountRequested = param1;
         this.updateAmountsProgress();
      }
      
      public function getCurrentAmount() : int
      {
         return this.mCurrentAmount;
      }
      
      public function setCurrentAmount(param1:int) : void
      {
         if(param1 != this.mCurrentAmount)
         {
            this.mCurrentAmount = param1;
            this.updateAmountsProgress();
         }
      }
      
      override public function dispose() : void
      {
         if(this.mAmountTextfield)
         {
            this.mAmountTextfield.removeFromParent(true);
            this.mAmountTextfield = null;
         }
         if(this.mBG)
         {
            this.mBG.removeFromParent(true);
            this.mBG = null;
         }
         if(this.mBGText)
         {
            this.mBGText.removeFromParent(true);
            this.mBGText = null;
         }
         this.mObjObject = null;
         super.dispose();
      }
   }
}

