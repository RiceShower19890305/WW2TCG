package com.fs.tcgengine.particles
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.model.FSModelUnloadableInterface;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import starling.text.TextFieldAutoSize;
   import starling.textures.Texture;
   import starling.utils.Align;
   
   public class TextParticleWithBG extends Component implements FSModelUnloadableInterface
   {
      
      private var mBG:*;
      
      private var mTextfield:FSTextfield;
      
      private var mBGName:String;
      
      private var mCustomWidth:int;
      
      private var mTextPos:String;
      
      public function TextParticleWithBG(param1:String = "", param2:int = -1)
      {
         super();
         this.mBGName = param1 != "" ? param1 : "damage_icon";
         this.mCustomWidth = param2;
         this.createUI();
         alignPivot();
      }
      
      private function createUI() : void
      {
         if(this.mBGName == "damage_icon")
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.mBGName));
         }
         else
         {
            this.mBG = Utils.createCustomBox(this.mBGName,this.mCustomWidth);
         }
         this.mTextfield = new FSTextfield(this.mBG.width * 0.95,this.mBG.height * 0.9);
         if(!Config.getConfig().battleHasSimpleUI())
         {
            this.mTextfield.fontSize = !Utils.isDesktop() ? FSResourceMng.FONT_STD_SUBTITLE_SIZE : FSResourceMng.FONT_STD_SMALL_SIZE;
         }
         addChild(this.mBG);
         addChild(this.mTextfield);
         this.alignPivots();
      }
      
      public function setText(param1:String, param2:String = "center") : void
      {
         if(this.mTextfield)
         {
            this.mTextfield.text = param1;
         }
         this.mTextPos = param2;
         this.alignPivots();
      }
      
      public function setBG(param1:String, param2:String = "center", param3:String = "std", param4:uint = 16777215, param5:Boolean = false) : void
      {
         var _loc6_:Texture = null;
         if(this.mBG)
         {
            this.mBGName = param1;
            _loc6_ = Root.assets.getTexture(param1);
            if(this.mBG is FSImage)
            {
               FSImage(this.mBG).texture = _loc6_;
               FSImage(this.mBG).readjustSize();
            }
            this.mTextfield.fontName = FSResourceMng.getFontByType(param3);
            this.mTextfield.format.color = param4;
            this.mTextfield.height = this.mBG.height * 0.9;
            if(param5)
            {
               this.mTextfield.autoScale = true;
               this.mTextfield.width = this.mBG.width * 0.95;
            }
            else
            {
               this.mTextfield.autoScale = false;
               this.mTextfield.height = this.mBG.height * 0.9;
               this.mTextfield.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
            }
            this.mTextPos = param2;
         }
         this.alignPivots();
      }
      
      private function alignPivots() : void
      {
         switch(this.mTextPos)
         {
            case Align.CENTER:
               this.mTextfield.format.horizontalAlign = Align.CENTER;
               this.mTextfield.x = this.mBG.x;
               break;
            case Align.RIGHT:
               this.mTextfield.format.horizontalAlign = Align.LEFT;
               this.mTextfield.x = this.mBG.x + this.mTextfield.width / 2 + this.mBG.width / 2;
         }
         if(this.mBG)
         {
            this.mBG.alignPivot();
         }
         if(this.mTextfield)
         {
            this.mTextfield.alignPivot();
         }
      }
      
      override public function dispose() : void
      {
         this.destroy();
         super.dispose();
      }
      
      public function destroy() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG = null;
         }
         if(this.mTextfield)
         {
            this.mTextfield.removeFromParent(true);
            this.mTextfield = null;
         }
      }
   }
}

