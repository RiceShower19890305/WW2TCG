package com.fs.tcgengine.view.components.popups.misc
{
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.controller.rules.HeroCharacterDefMng;
   import com.fs.tcgengine.model.rules.HeroCharacterDef;
   import com.fs.tcgengine.model.rules.RarityDef;
   import com.fs.tcgengine.model.userdata.UserData;
   import com.fs.tcgengine.model.userdata.UserDataMng;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.resources.AssetsParticles;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.SpecialFX;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.popups.Popup;
   import com.fs.tcgengine.view.popups.misc.PopupEditProfile;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   
   public class FSSkinSlot extends Component
   {
      
      private var mSkinDef:HeroCharacterDef;
      
      private var mParentPopup:Popup;
      
      private var mSelected:Boolean;
      
      private var mSkinQuadBG1:Quad;
      
      private var mSkinNameBG:Quad;
      
      private var mSkinImage:FSImage;
      
      private var mSkinNameTextfield:FSTextfield;
      
      private var mSelectedTextfield:FSTextfield;
      
      private var mLockedImage:FSImage;
      
      private var mIsLocked:Boolean;
      
      private var mLockedTextfield:FSTextfield;
      
      private var mSkinQuadBG2:Quad;
      
      protected var mParticleFX:FSPDParticleSystem;
      
      private var mIsShopItem:Boolean = false;
      
      private var mSkinOwnedImage:FSImage;
      
      private var mSkinRarityImage:FSImage;
      
      public function FSSkinSlot(param1:HeroCharacterDef, param2:Boolean, param3:Popup, param4:Boolean = false)
      {
         super();
         this.mSkinDef = param1;
         this.mSelected = param2;
         this.mParentPopup = param3;
         this.mIsLocked = this.getSkinIsLocked();
         this.mIsShopItem = param4;
         this.createUI();
      }
      
      private function getSkinIsLocked() : Boolean
      {
         return !InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(this.mSkinDef.getSku());
      }
      
      private function createUI() : void
      {
         this.createSkinBG();
         this.createSkinImage();
         this.setupParticleFX();
         this.createSkinNameBG();
         this.createSkinNameTextfield();
         this.createSkinRarity();
         if(this.mSelected)
         {
            this.createSelectedTextfield();
         }
         if(this.mIsLocked && !this.mIsShopItem)
         {
            this.createLockedImage();
            this.createLockedTextfield();
         }
         var _loc1_:Boolean = InstanceMng.getUserDataMng().getOwnerUserData().isSkinAvailable(this.getSkinDef().getSku());
         if(_loc1_ && this.mIsShopItem)
         {
            this.createOwnedImage();
         }
      }
      
      private function createSkinRarity() : void
      {
         if(this.mSkinDef.getSkinRarityIndex() == 4)
         {
            if(Boolean(this.mSkinImage) && this.mSkinRarityImage == null)
            {
               this.mSkinRarityImage = new FSImage(Root.assets.getTexture("skin_rarity_05"));
               if(!this.mIsShopItem)
               {
                  this.mSkinRarityImage.scaleX *= 0.5;
                  this.mSkinRarityImage.scaleY *= 0.5;
               }
               this.mSkinRarityImage.x = -this.mSkinRarityImage.width / 6;
               this.mSkinRarityImage.y = -this.mSkinRarityImage.height / 6;
               addChild(this.mSkinRarityImage);
            }
         }
      }
      
      private function createLockedTextfield() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mLockedImage) && this.mLockedTextfield == null)
         {
            _loc1_ = this.getTextLocked();
            this.mLockedTextfield = new FSTextfield(this.mLockedImage.width * 0.7,this.mLockedImage.height,_loc1_);
            this.mLockedTextfield.x = this.mLockedImage.x + this.mLockedImage.width * 0.3;
            this.mLockedTextfield.y = this.mLockedImage.y;
            addChild(this.mLockedTextfield);
         }
      }
      
      private function getTextLocked() : String
      {
         var _loc1_:String = null;
         switch(this.mSkinDef.getUnlockType())
         {
            case HeroCharacterDefMng.UNLOCK_BY_DUNGEON:
               _loc1_ = TextManager.getText("TID_DUNGEON_NAME");
               break;
            case HeroCharacterDefMng.UNLOCK_BY_LEVEL:
               _loc1_ = TextManager.getText("TID_ACHIEVEMENT_LEVEL");
               break;
            case HeroCharacterDefMng.UNLOCK_BY_PVP:
               _loc1_ = TextManager.getText("TID_GEN_MENU_PVP");
               break;
            case HeroCharacterDefMng.UNLOCK_BY_QUEST:
               _loc1_ = TextManager.getText("TID_BUTTON_QUEST");
               break;
            case HeroCharacterDefMng.UNLOCK_BY_RAID:
               _loc1_ = TextManager.getText("TID_RAID");
               break;
            case HeroCharacterDefMng.UNLOCK_BY_SHOP:
               _loc1_ = TextManager.getText("TID_GEN_MENU_SHOP");
         }
         return _loc1_;
      }
      
      private function createLockedImage() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.mSkinQuadBG1) && Boolean(this.mSkinImage) && this.mLockedImage == null)
         {
            _loc1_ = this.getLockImageName();
            if(Boolean(_loc1_) && _loc1_ != "")
            {
               this.mLockedImage = new FSImage(Root.assets.getTexture(_loc1_));
               this.mLockedImage.width = this.mSkinQuadBG1.width;
               this.mLockedImage.x = this.mSkinQuadBG1.x;
               this.mLockedImage.y = this.mSkinQuadBG1.y + this.mSkinQuadBG1.height - this.mLockedImage.height;
               addChild(this.mLockedImage);
            }
         }
      }
      
      private function getLockImageName() : String
      {
         var _loc1_:String = null;
         switch(this.mSkinDef.getUnlockType())
         {
            case HeroCharacterDefMng.UNLOCK_BY_DUNGEON:
               _loc1_ = "skin_locked_dungeon";
               break;
            case HeroCharacterDefMng.UNLOCK_BY_LEVEL:
               _loc1_ = "skin_locked_level";
               break;
            case HeroCharacterDefMng.UNLOCK_BY_PVP:
               _loc1_ = "skin_locked_pvp";
               break;
            case HeroCharacterDefMng.UNLOCK_BY_QUEST:
               _loc1_ = "skin_locked_quest";
               break;
            case HeroCharacterDefMng.UNLOCK_BY_RAID:
               _loc1_ = "skin_locked_raid";
               break;
            case HeroCharacterDefMng.UNLOCK_BY_SHOP:
               _loc1_ = "skin_locked_shop";
         }
         return _loc1_;
      }
      
      private function createSelectedTextfield() : void
      {
         if(!Config.getConfig().gameHasClassSystem())
         {
            if(Boolean(this.mSkinQuadBG1) && Boolean(this.mSkinImage) && this.mSelectedTextfield == null)
            {
               this.mSelectedTextfield = new FSTextfield(this.mSkinQuadBG1.width,this.mSkinQuadBG1.height / 4,TextManager.getText("TID_GEN_SELECTED"));
               this.mSelectedTextfield.x = this.mSkinQuadBG1.x;
               this.mSelectedTextfield.y = this.mSkinQuadBG1.height / 2;
               this.mSelectedTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GREEN);
               addChild(this.mSelectedTextfield);
            }
         }
      }
      
      private function createSkinNameTextfield() : void
      {
         if(Boolean(this.mSkinNameBG) && this.mSkinNameTextfield == null)
         {
            this.mSkinNameTextfield = new FSTextfield(this.mSkinNameBG.width,this.mSkinNameBG.height,this.mSkinDef.getName());
            this.mSkinNameTextfield.x = this.mSkinNameBG.x;
            this.mSkinNameTextfield.y = this.mSkinNameBG.y;
            addChild(this.mSkinNameTextfield);
         }
      }
      
      private function createSkinNameBG() : void
      {
         if(Boolean(this.mSkinQuadBG1) && this.mSkinNameBG == null)
         {
            this.mSkinNameBG = new Quad(this.mSkinQuadBG1.width,this.mParentPopup.height / 22,0);
            this.mSkinNameBG.alpha = 0.5;
            this.mSkinNameBG.y = this.mSkinQuadBG1.height * 1.01;
            addChild(this.mSkinNameBG);
         }
      }
      
      private function createSkinImage() : void
      {
         if(Boolean(this.mSkinQuadBG1) && this.mSkinImage == null)
         {
            this.mSkinImage = new FSImage(Root.assets.getTexture(this.mSkinDef.getBGImageName()));
            this.mSkinImage.width = this.mParentPopup.width * 0.25;
            this.mSkinImage.height = this.mParentPopup.height * 0.3;
            this.resizeAllComponents();
            if(!this.mIsShopItem)
            {
               this.mSkinImage.addEventListener(TouchEvent.TOUCH,this.onSkinTouch);
            }
            addChild(this.mSkinImage);
         }
      }
      
      private function resizeAllComponents() : void
      {
         if(this.mSkinQuadBG1)
         {
            if(this.mSkinImage)
            {
               this.mSkinQuadBG1.width = this.mSkinImage.width;
               this.mSkinQuadBG1.height = this.mSkinImage.height;
            }
            this.createSkinBorder();
            if(this.mSkinImage)
            {
               this.mSkinImage.x = this.mSkinQuadBG1.x;
               this.mSkinImage.y = this.mSkinQuadBG1.y;
            }
            if(this.mSkinNameBG)
            {
               this.mSkinNameTextfield.width = this.mSkinNameBG.width = this.mSkinQuadBG1.width;
            }
         }
      }
      
      private function createSkinBG() : void
      {
         var _loc1_:RarityDef = null;
         var _loc2_:Array = null;
         if(this.mSkinQuadBG1 == null)
         {
            this.mSkinQuadBG1 = new Quad(1,1,0);
            if(!this.mIsShopItem)
            {
               this.mSkinQuadBG1.addEventListener(TouchEvent.TOUCH,this.onSkinTouch);
            }
            _loc1_ = InstanceMng.getRaritiesDefMng().getRarityDefByIndex(this.mSkinDef.getSkinRarityIndex());
            if(_loc1_.getIndex() >= 3)
            {
               this.mSkinQuadBG1.alpha = 0.15;
               SpecialFX.createYoYoAlphaTransition(this.mSkinQuadBG1,1,0.75);
            }
            _loc2_ = _loc1_.getSkinBGColors();
            this.mSkinQuadBG1.setVertexColor(0,_loc2_[0]);
            this.mSkinQuadBG1.setVertexColor(1,_loc2_[1]);
            this.mSkinQuadBG1.setVertexColor(2,_loc2_[2]);
            this.mSkinQuadBG1.setVertexColor(3,_loc2_[2]);
            addChild(this.mSkinQuadBG1);
            this.createSkinBorder();
         }
      }
      
      private function createSkinBorder() : void
      {
         var _loc2_:RarityDef = null;
         var _loc3_:Array = null;
         var _loc1_:Number = 1.06;
         if(this.mSkinQuadBG2 == null)
         {
            this.mSkinQuadBG2 = new Quad(this.mSkinQuadBG1.width * _loc1_,this.mSkinQuadBG1.height * _loc1_,16777215);
            this.mSkinQuadBG2.alpha = 1;
            _loc2_ = InstanceMng.getRaritiesDefMng().getRarityDefByIndex(this.mSkinDef.getSkinRarityIndex());
            _loc3_ = _loc2_.getSkinFrameColors();
            this.mSkinQuadBG2.setVertexColor(0,_loc3_[2]);
            this.mSkinQuadBG2.setVertexColor(1,_loc3_[1]);
            this.mSkinQuadBG2.setVertexColor(2,_loc3_[0]);
            this.mSkinQuadBG2.setVertexColor(3,_loc3_[0]);
            this.mSkinQuadBG2.x = this.mSkinQuadBG1.x - (this.mSkinQuadBG2.width - this.mSkinQuadBG1.width) / 2;
            this.mSkinQuadBG2.y -= (this.mSkinQuadBG2.height - this.mSkinQuadBG1.height) / 2;
            addChildAt(this.mSkinQuadBG2,getChildIndex(this.mSkinQuadBG1));
         }
         else
         {
            this.mSkinQuadBG2.width = this.mSkinQuadBG1.width * _loc1_;
            this.mSkinQuadBG2.height = this.mSkinQuadBG1.height * _loc1_;
            this.mSkinQuadBG2.x = this.mSkinQuadBG1.x - (this.mSkinQuadBG2.width - this.mSkinQuadBG1.width) / 2;
            this.mSkinQuadBG2.y -= (this.mSkinQuadBG2.height - this.mSkinQuadBG1.height) / 2;
         }
      }
      
      private function onSkinTouch(param1:TouchEvent) : void
      {
         var _loc3_:UserDataMng = null;
         var _loc4_:UserData = null;
         var _loc5_:String = null;
         var _loc2_:Touch = param1.getTouch(this,TouchPhase.ENDED);
         if(_loc2_)
         {
            if(Config.getConfig().gameHasClassSystem())
            {
               Utils.setLogText(TextManager.getText("TID_SKIN_CHANGE_DECK"),false,false,false);
            }
            else if(!this.mIsLocked)
            {
               _loc3_ = InstanceMng.getUserDataMng();
               if(_loc3_)
               {
                  _loc4_ = _loc3_.getOwnerUserData();
                  if(_loc4_)
                  {
                     _loc5_ = _loc4_.getCurrentSkinSku();
                     if(Boolean(this.mSkinDef) && _loc5_ != this.mSkinDef.getSku())
                     {
                        _loc4_.setCurrentSkinSku(this.mSkinDef.getSku());
                        _loc3_.updateCurrentSkinSku();
                        PopupEditProfile(this.mParentPopup).removeSelectedText();
                        this.mSelected = true;
                        this.createSelectedTextfield();
                        Utils.setLogText(TextManager.getText("TID_DATA_SAVED"));
                     }
                  }
               }
            }
            else
            {
               Utils.setLogText(TextManager.getText("TID_SKIN_BLOCKED"),true);
            }
         }
      }
      
      private function setupParticleFX() : void
      {
         var _loc1_:String = this.mSkinDef.getSkinParticlesSku();
         if(Config.getConfig().getShowSpecialFX() && _loc1_ != "" && _loc1_ != null)
         {
            this.mParticleFX = AssetsParticles.requestParticleSystem(_loc1_);
            if(this.mParticleFX != null)
            {
               addChildAt(this.mParticleFX,getChildIndex(this.mSkinQuadBG1) + 1);
               Starling.juggler.add(this.mParticleFX);
               this.mParticleFX.start();
            }
            this.mParticleFX.scaleX = this.mSkinImage.scaleX * 1.35 / Main.smScaleFactor;
            this.mParticleFX.scaleY = this.mSkinImage.scaleY * 1.35 / Main.smScaleFactor;
            this.mParticleFX.x = this.mSkinQuadBG1.x + this.mSkinQuadBG1.width / 2;
            this.mParticleFX.y = this.mSkinQuadBG1.y + this.mSkinQuadBG1.height * 0.95;
         }
      }
      
      override public function dispose() : void
      {
         if(this.mSkinQuadBG1)
         {
            this.mSkinQuadBG1.removeFromParent(true);
            this.mSkinQuadBG1 = null;
         }
         if(this.mSkinQuadBG2)
         {
            this.mSkinQuadBG2.removeFromParent(true);
            this.mSkinQuadBG2 = null;
         }
         if(this.mSkinNameBG)
         {
            this.mSkinNameBG.removeFromParent(true);
            this.mSkinNameBG = null;
         }
         if(this.mLockedImage)
         {
            this.mLockedImage.removeFromParent(true);
            this.mLockedImage = null;
         }
         if(this.mSkinRarityImage)
         {
            this.mSkinRarityImage.removeFromParent(true);
            this.mSkinRarityImage = null;
         }
         if(this.mSkinImage)
         {
            this.mSkinImage.removeFromParent(true);
            this.mSkinImage = null;
         }
         if(this.mSkinNameTextfield)
         {
            this.mSkinNameTextfield.removeFromParent(true);
            this.mSkinNameTextfield = null;
         }
         if(this.mSelectedTextfield)
         {
            this.mSelectedTextfield.removeFromParent(true);
            this.mSelectedTextfield = null;
         }
         if(this.mLockedTextfield)
         {
            this.mLockedTextfield.removeFromParent(true);
            this.mLockedTextfield = null;
         }
         if(this.mParticleFX)
         {
            this.mParticleFX.removeFromParent();
            Starling.juggler.remove(this.mParticleFX);
            this.mParticleFX = null;
         }
         if(this.mSkinOwnedImage)
         {
            this.mSkinOwnedImage.removeFromParent(true);
            this.mSkinOwnedImage = null;
         }
         this.mSkinDef = null;
         this.mParentPopup = null;
      }
      
      public function removeSelectedText() : void
      {
         this.mSelected = false;
         if(this.mSelectedTextfield)
         {
            this.mSelectedTextfield.removeFromParent();
            this.mSelectedTextfield = null;
         }
      }
      
      public function getSkinDef() : HeroCharacterDef
      {
         return this.mSkinDef;
      }
      
      public function getSkinNameBG() : Quad
      {
         return this.mSkinNameBG;
      }
      
      public function getSkinImage() : Quad
      {
         return this.mSkinImage;
      }
      
      public function createOwnedImage() : void
      {
         if(Boolean(this.getSkinImage()) && this.mSkinOwnedImage == null)
         {
            this.mSkinOwnedImage = new FSImage(Root.assets.getTexture("skin_owned"));
            this.mSkinOwnedImage.x = this.getSkinImage().x + this.getSkinImage().width - this.mSkinOwnedImage.width;
            this.mSkinOwnedImage.y = this.getSkinImage().y;
            addChild(this.mSkinOwnedImage);
         }
      }
   }
}

