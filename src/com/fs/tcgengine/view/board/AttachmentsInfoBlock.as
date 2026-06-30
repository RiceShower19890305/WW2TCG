package com.fs.tcgengine.view.board
{
   import com.fs.tcgengine.Root;
   import com.fs.tcgengine.controller.TextManager;
   import com.fs.tcgengine.resources.FSResourceMng;
   import com.fs.tcgengine.utils.DictionaryUtils;
   import com.fs.tcgengine.utils.FSCoordinate;
   import com.fs.tcgengine.utils.Utils;
   import com.fs.tcgengine.view.cards.FSAttachment;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.misc.FSTextfield;
   import com.fs.tcgengine.view.misc.FSImage;
   import com.fs.tcgengine.view.socket.AttachmentSocket;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import flash.utils.Dictionary;
   
   public class AttachmentsInfoBlock extends Component
   {
      
      private const BG_NAME:String = "items_panel";
      
      private var mBG:FSImage;
      
      private var mTitleTextfield:FSTextfield;
      
      private var mTitle:String;
      
      private var mReferenceCard:FSUnit;
      
      private var mSocketsVector:Vector.<AttachmentSocket>;
      
      private var mCurrentTier:int;
      
      private var mUnitAttachments:Vector.<FSAttachment>;
      
      private var mSocketAttachmentCatalog:Dictionary;
      
      public function AttachmentsInfoBlock(param1:FSUnit)
      {
         super();
         this.mReferenceCard = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.mTitle = TextManager.getText("TID_GEN_ITEMS");
         this.createBG();
         this.createTitle();
         this.createSockets();
      }
      
      private function createBG() : void
      {
         if(this.mBG == null)
         {
            this.mBG = new FSImage(Root.assets.getTexture(this.BG_NAME));
            addChild(this.mBG);
         }
      }
      
      private function createTitle() : void
      {
         if(this.mBG)
         {
            if(this.mTitleTextfield == null)
            {
               this.mTitleTextfield = new FSTextfield(this.mBG.width,FSResourceMng.FONT_STD_TITLE_SIZE,"",16777215,FSResourceMng.FONT_STD_SUBTITLE_SIZE);
               this.mTitleTextfield.fontName = FSResourceMng.getFontByType(FSResourceMng.FONT_TYPE_STD_GOLD);
               this.mTitleTextfield.text = this.mTitle.toUpperCase();
            }
            this.mTitleTextfield.x = 0;
            this.mTitleTextfield.y = 5;
            addChild(this.mTitleTextfield);
         }
      }
      
      private function createSockets() : void
      {
         var _loc1_:AttachmentSocket = null;
         var _loc3_:FSCoordinate = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         if(this.mBG != null && this.mReferenceCard != null && this.mReferenceCard.getTempCardXL() != null && this.mReferenceCard.getTempCardXL().getFrameBG() != null && this.mTitleTextfield != null)
         {
            _loc4_ = this.mBG.width;
            _loc5_ = this.mReferenceCard.getTempCardXL().getFrameBG().height * (FSCardXL.ATTACHMENTS_BLOCK_HEIGHT_PERCENTAGE / 100) - this.mTitleTextfield.height;
            _loc2_ = 0;
            while(_loc2_ < FSAttachment.MAX_ATTACHMENTS_AMOUNT)
            {
               _loc1_ = new AttachmentSocket();
               _loc1_.setupSocket(false,false,0,_loc2_,1,_loc2_);
               _loc3_ = Utils.getXYPositionInContainer(_loc2_,_loc1_.width,_loc1_.height,_loc4_,_loc5_,FSAttachment.MAX_ATTACHMENTS_AMOUNT,1,true);
               _loc1_.x = _loc3_.getX() + _loc1_.width / 2;
               _loc1_.y = this.mTitleTextfield.height * 1.75 + _loc3_.getY() + _loc1_.height / 2;
               addChild(_loc1_);
               this.addSocketToCatalog(_loc1_);
               _loc2_++;
            }
         }
      }
      
      private function addSocketToCatalog(param1:FSCardSocket) : void
      {
         if(this.mSocketsVector == null)
         {
            this.mSocketsVector = new Vector.<AttachmentSocket>();
         }
         this.mSocketsVector.push(param1);
      }
      
      public function updateCardsThumbnails() : void
      {
         var _loc1_:FSAttachment = null;
         var _loc2_:FSAttachment = null;
         var _loc3_:String = null;
         var _loc6_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = DictionaryUtils.getDictionaryLength(this.mSocketAttachmentCatalog);
         if(this.mSocketAttachmentCatalog == null || this.mUnitAttachments == null || _loc5_ < this.mUnitAttachments.length)
         {
            this.createCardsThumbnails();
         }
         if(this.mSocketAttachmentCatalog != null)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc1_ = null;
               _loc2_ = this.mSocketAttachmentCatalog[_loc6_];
               this.removeAttachment(_loc2_.getCardDef().getSku());
               _loc4_ = true;
               _loc6_++;
            }
         }
         if(_loc4_)
         {
            this.createCardsThumbnails();
         }
      }
      
      private function createCardsThumbnails() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:FSCoordinate = null;
         var _loc4_:FSAttachment = null;
         var _loc5_:Boolean = false;
         if(this.mReferenceCard)
         {
            this.mUnitAttachments = this.mReferenceCard.getAttachments();
            _loc1_ = this.mUnitAttachments != null ? int(this.mUnitAttachments.length) : 0;
            if(_loc1_ > 0)
            {
               _loc5_ = false;
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  _loc5_ = false;
                  _loc4_ = this.mUnitAttachments.length >= _loc2_ ? this.mUnitAttachments[_loc2_] : null;
                  if(_loc4_)
                  {
                     _loc4_.touchable = true;
                     _loc4_.addEventListeners();
                     if(this.mSocketAttachmentCatalog != null)
                     {
                        if(this.mSocketAttachmentCatalog[_loc2_] == _loc4_)
                        {
                           _loc5_ = true;
                        }
                     }
                     if(!_loc5_ && Boolean(this.mSocketsVector))
                     {
                        _loc4_.x = this.mSocketsVector[_loc2_].x;
                        _loc4_.y = this.mSocketsVector[_loc2_].y;
                        _loc4_.alpha = 0.999;
                        _loc4_.width = this.mSocketsVector[_loc2_].width;
                        _loc4_.height = this.mSocketsVector[_loc2_].height;
                        addChild(_loc4_);
                        this.addAttachmentToCatalog(_loc4_,_loc2_);
                     }
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      private function addAttachmentToCatalog(param1:FSAttachment, param2:int) : void
      {
         if(this.mSocketAttachmentCatalog == null)
         {
            this.mSocketAttachmentCatalog = new Dictionary(true);
         }
         this.mSocketAttachmentCatalog[param2] = param1;
      }
      
      private function removeAttachment(param1:String) : void
      {
         var _loc2_:FSAttachment = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         if(this.mSocketAttachmentCatalog != null)
         {
            _loc5_ = DictionaryUtils.getKeys(this.mSocketAttachmentCatalog);
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc2_ = this.mSocketAttachmentCatalog[_loc4_];
               if(_loc2_ != null)
               {
                  _loc3_ = _loc2_.getCardDef().getSku();
                  if(_loc3_ == param1)
                  {
                     _loc2_.removeFromParent();
                     _loc2_.destroy();
                     delete this.mSocketAttachmentCatalog[_loc5_[_loc4_]];
                  }
               }
               _loc4_++;
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.mBG)
         {
            this.mBG.removeFromParent();
            this.mBG.destroy();
            this.mBG = null;
         }
         if(this.mTitleTextfield)
         {
            this.mTitleTextfield.removeFromParent(true);
            this.mTitleTextfield = null;
         }
         this.mReferenceCard = null;
         var _loc1_:int = 0;
         if(this.mSocketsVector)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mSocketsVector.length)
            {
               this.mSocketsVector[_loc1_].removeFromParent();
               this.mSocketsVector[_loc1_].destroy();
               _loc1_++;
            }
            Utils.destroyArray(this.mSocketsVector);
            this.mSocketsVector = null;
         }
         if(this.mUnitAttachments)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mUnitAttachments.length)
            {
               this.mUnitAttachments[_loc1_].removeFromParent();
               this.mUnitAttachments[_loc1_].destroy();
               _loc1_++;
            }
            Utils.destroyArray(this.mUnitAttachments);
            this.mUnitAttachments = null;
         }
         DictionaryUtils.clearDictionary(this.mSocketAttachmentCatalog);
         this.mSocketAttachmentCatalog = null;
         super.dispose();
      }
   }
}

