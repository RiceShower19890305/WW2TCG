package com.fs.tcgengine.utils
{
   import com.fs.tcgengine.Constants;
   import com.fs.tcgengine.InstanceMng;
   import com.fs.tcgengine.config.Config;
   import com.fs.tcgengine.controller.SoundManager;
   import com.fs.tcgengine.model.rules.ComicStripDef;
   import com.fs.tcgengine.particles.FSPDParticleSystem;
   import com.fs.tcgengine.screens.FSBattleScreen;
   import com.fs.tcgengine.screens.FSBattleScreenPvP;
   import com.fs.tcgengine.screens.FSMapScreen;
   import com.fs.tcgengine.screens.Screen;
   import com.fs.tcgengine.view.board.BattleIntroCharacter;
   import com.fs.tcgengine.view.cards.FSCard;
   import com.fs.tcgengine.view.cards.FSCardShadow;
   import com.fs.tcgengine.view.cards.FSCardXL;
   import com.fs.tcgengine.view.cards.FSEvent;
   import com.fs.tcgengine.view.cards.FSUnit;
   import com.fs.tcgengine.view.components.Component;
   import com.fs.tcgengine.view.components.FSSprite3D;
   import com.fs.tcgengine.view.components.battle.PlayerHPViewer;
   import com.fs.tcgengine.view.components.map.ComicStrip;
   import com.fs.tcgengine.view.components.misc.FSGaugeProgressBar;
   import com.fs.tcgengine.view.components.misc.FSProgressBar;
   import com.fs.tcgengine.view.map.MapPlane;
   import com.fs.tcgengine.view.meshes.LevelItemContainer;
   import com.fs.tcgengine.view.misc.FSLogPanel;
   import com.fs.tcgengine.view.popups.purchases.PopupProductDetail;
   import com.fs.tcgengine.view.socket.FSCardSocket;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Ease;
   import com.greensock.easing.Linear;
   import com.greensock.easing.Quad;
   import com.greensock.easing.Sine;
   import flash.geom.Point;
   import flash.media.Sound;
   import starling.animation.Transitions;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.display.Sprite3D;
   import starling.events.Touch;
   import starling.text.TextField;
   import starling.utils.deg2rad;
   
   public class SpecialFX
   {
      
      public static const ZOOM_IN_SCALE_FACTOR:int = 2;
      
      public static const EFFECT_MODE_IN:int = 0;
      
      public static const EFFECT_MODE_OUT:int = 1;
      
      public function SpecialFX()
      {
         super();
      }
      
      public static function zoomIn(param1:FSCard) : void
      {
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc2_ = param1.isInfoCard();
            if(!param1.isZoomedIn() && !_loc2_)
            {
               param1.setZoomedIn(true);
            }
            Utils.playSound(Constants.SOUND_CARD_ZOOM_IN,SoundManager.TYPE_SFX);
            Utils.removeLog();
            InstanceMng.getCurrentScreen().createTranslucentBG(true,0.8,0,true);
            InstanceMng.getCardsMng().createZoomedCard(param1);
         }
      }
      
      public static function setCardVisibilityOnScreen(param1:FSCard, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:Screen = null;
         if(param1 != null)
         {
            _loc4_ = InstanceMng.getCurrentScreen();
            if(param2 && Boolean(_loc4_))
            {
               if(!_loc4_.contains(param1))
               {
                  _loc4_.addChild(param1);
               }
            }
            else
            {
               if(param1 is FSCardXL)
               {
                  DictionaryUtils.disposeCardXL(FSCardXL(param1));
                  FSCardXL(param1).mParentCard.setTempCardXL(null);
                  FSCardXL(param1).mParentCard = null;
               }
               param1.removeFromParent();
               param1.destroy();
               param1 = null;
            }
         }
      }
      
      public static function zoomOut(param1:FSCard, param2:Number = -1, param3:Boolean = true) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:FSCardXL = null;
         var _loc7_:FSCardSocket = null;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         if(param1)
         {
            param2 = param2 != -1 ? param2 : Config.getConfig().getDefaultZoomOutTime();
            _loc4_ = param1.isInfoCard();
            _loc5_ = param1.isZoomedIn();
            if((_loc5_) && !_loc4_)
            {
               param1.setZoomedIn(false);
               param1.setIsMoving(true);
            }
            param1.setDisableIntersections(true);
            _loc6_ = InstanceMng.getCurrentScreen().getZoomedCardXL();
            setCardVisibilityOnScreen(_loc6_,false);
            InstanceMng.getCurrentScreen().setZoomedCardXL(null);
            if(InstanceMng.getPopupMng().getPopupShown() == null)
            {
               InstanceMng.getCurrentScreen().createTranslucentBG(false,0.0001,0,true);
            }
            else
            {
               InstanceMng.getCurrentScreen().hideTouchableImage();
               InstanceMng.getCurrentScreen().hideTouchableBG();
               if(Boolean(InstanceMng.getPopupMng().getPopupShown()) && (InstanceMng.getPopupMng().getPopupInBackground() == null || InstanceMng.getPopupMng().getPopupShown() is PopupProductDetail))
               {
                  InstanceMng.getCurrentScreen().createTranslucentBG(true,0.6,0);
               }
            }
            if(!_loc4_)
            {
               if(_loc6_ is FSUnit)
               {
                  setCardVisibilityOnScreen(param1,true);
               }
               if(!_loc5_ && (_loc6_ is FSUnit || _loc6_ == null))
               {
                  _loc7_ = param1.getAttachedToSocket();
                  if(_loc7_ != null)
                  {
                     if(param1)
                     {
                        param1.setIsZoomingOut(true);
                        _loc8_ = param1.getRotationTimeToDefaultPos(param2);
                        TweenMax.to(param1,_loc8_,{
                           "rotationX":0,
                           "rotationY":0
                        });
                        _loc9_ = param1.x != _loc7_.x || param1.y != _loc7_.y || param1.getShadow() != null && param1.getShadow().visible;
                        TweenMax.to(param1,param2,{
                           "delay":_loc8_,
                           "alpha":1,
                           "x":_loc7_.x,
                           "y":_loc7_.y,
                           "width":_loc7_.width,
                           "height":_loc7_.height,
                           "rotation":_loc7_.rotation,
                           "onComplete":param1.cardTweeningOver,
                           "onCompleteParams":[param3,_loc9_],
                           "ease":Back.easeIn
                        });
                        TweenMax.delayedCall(_loc8_,createShadowZoomTransition,[param1,param2,false,_loc7_.x,_loc7_.y,true,Back.easeIn,_loc7_.rotation]);
                     }
                  }
               }
               else
               {
                  param1.cardTweeningOver(true,false);
               }
            }
            _loc6_ = null;
         }
      }
      
      public static function tweenToColor(param1:DisplayObject, param2:Number = 1, param3:uint = 16777215, param4:int = -1) : TweenMax
      {
         if(param1)
         {
            TweenMax.killTweensOf(param1);
            return new TweenMax(param1,param2,{
               "hexColors":{"color":param3},
               "yoyo":true,
               "repeat":param4
            });
         }
         return null;
      }
      
      public static function createYoYoTransition(param1:DisplayObject, param2:FSCoordinate, param3:Number = 1, param4:int = 1, param5:Function = null, param6:Ease = null) : TweenMax
      {
         if(Boolean(param1) && param3 > 0)
         {
            param6 = param6 == null ? Quad.easeOut : param6;
            return new TweenMax(param1,param3,{
               "x":param2.getX(),
               "y":param2.getY(),
               "yoyo":true,
               "repeat":param4,
               "onComplete":param5,
               "ease":param6
            });
         }
         return null;
      }
      
      public static function createYoYoZoomTransition(param1:DisplayObject, param2:Number = 1.3, param3:Number = 1, param4:int = 1, param5:Function = null, param6:Array = null, param7:Boolean = true, param8:Ease = null) : TweenMax
      {
         if(param1)
         {
            param1.alignPivot();
            param8 = param8 == null ? Quad.easeOut : param8;
            if(param7)
            {
               param1.x += param1.width / 2;
               param1.y += param1.height / 2;
            }
            return new TweenMax(param1,param3,{
               "scaleX":param2,
               "scaleY":param2,
               "yoyo":true,
               "repeat":param4,
               "onComplete":param5,
               "onCompleteParams":param6,
               "ease":param8
            });
         }
         return null;
      }
      
      public static function create3DYoYoTransition(param1:Sprite3D, param2:Number, param3:Object, param4:Function = null, param5:Array = null, param6:Ease = null) : void
      {
         var _loc7_:Object = null;
         var _loc8_:String = null;
         if(param1)
         {
            _loc7_ = new Object();
            _loc7_.yoyo = true;
            _loc7_.ease = param6 ? param6 : Back.easeInOut;
            _loc7_.onComplete = param4;
            _loc7_.onCompleteParams = param5;
            if(param3 != null)
            {
               for(_loc8_ in param3)
               {
                  _loc7_[_loc8_] = param3[_loc8_];
               }
            }
            TweenMax.to(param1,param2,_loc7_);
         }
      }
      
      public static function create3DTransition(param1:FSSprite3D, param2:Number, param3:Number, param4:Number = 0.25, param5:Function = null) : void
      {
         var obj:Object = null;
         var onUpdate:Function = null;
         var s:FSSprite3D = param1;
         var posX:Number = param2;
         var dY:Number = param3;
         var transTime:Number = param4;
         var onSuccessFunction:Function = param5;
         onUpdate = function():void
         {
            if(MapPlane(s).isMovable(obj.num))
            {
               InstanceMng.getCurrentScreen().dispatchEventWith(FSMapScreen.MAP_DRAGGED,true,{
                  "d":obj.num,
                  "isTween":true
               });
            }
         };
         obj = new Object();
         obj.num = dY;
         TweenMax.to(obj,transTime,{
            "num":0,
            "onUpdate":onUpdate,
            "ease":Sine.easeOut,
            "onComplete":onSuccessFunction
         });
      }
      
      public static function createYoYoAlphaTransition(param1:DisplayObject, param2:Number = 0.5, param3:Number = 2) : TweenMax
      {
         if(param1)
         {
            return new TweenMax(param1,param3,{
               "alpha":param2,
               "yoyo":true,
               "repeat":-1
            });
         }
         return null;
      }
      
      public static function createProgressBarTransition(param1:DisplayObject, param2:int, param3:Number, param4:Function = null) : void
      {
         if(param1 != null)
         {
            TweenMax.to(param1,param3,{
               "value":param2,
               "onComplete":param4
            });
         }
      }
      
      public static function createTextfieldAmountTransition(param1:TextField, param2:int, param3:Number, param4:Boolean, param5:Function = null, param6:Array = null, param7:Ease = null, param8:String = "", param9:PlayerHPViewer = null) : void
      {
         var updateTextfieldText:Function = null;
         var onTextTweenComplete:Function = null;
         var origScaleX:Number = NaN;
         var origScaleY:Number = NaN;
         var obj:Object = null;
         var mc:TextField = param1;
         var value:int = param2;
         var time:Number = param3;
         var scaleAnimOn:Boolean = param4;
         var onCompleteFunction:Function = param5;
         var onCompleteParams:Array = param6;
         var easeFunction:Ease = param7;
         var suffix:String = param8;
         var parentPlayerHPViewer:PlayerHPViewer = param9;
         updateTextfieldText = function(param1:String = ""):void
         {
            if(mc)
            {
               mc.text = String(int(obj.num)) + param1;
            }
            if(parentPlayerHPViewer)
            {
               parentPlayerHPViewer.updateHP(obj.num);
            }
         };
         onTextTweenComplete = function():void
         {
            if(mc)
            {
               mc.visible = true;
               mc.alpha = 0.999;
            }
            if(onCompleteFunction != null)
            {
               if(onCompleteParams != null)
               {
                  onCompleteFunction.apply(null,onCompleteParams);
               }
               else
               {
                  onCompleteFunction();
               }
            }
         };
         if(mc != null)
         {
            origScaleX = mc.scaleX;
            origScaleY = mc.scaleY;
            obj = new Object();
            obj.num = suffix != "" ? int(mc.text.substr(0,mc.text.indexOf(suffix))) : int(mc.text);
            TweenMax.fromTo(mc,time,{"alpha":0},{"alpha":1});
            if(obj)
            {
               if(easeFunction == null)
               {
                  easeFunction = Linear.easeNone;
               }
               TweenMax.to(obj,time + 0.1,{
                  "num":value,
                  "onUpdate":updateTextfieldText,
                  "onUpdateParams":[suffix],
                  "onComplete":onTextTweenComplete,
                  "ease":easeFunction
               });
            }
         }
      }
      
      public static function createComplexTextfieldAmountTransition(param1:TextField, param2:int, param3:int, param4:int, param5:int, param6:Number, param7:Boolean, param8:Function = null, param9:Array = null, param10:Ease = null, param11:String = "") : void
      {
         var updateTextfieldText:Function = null;
         var onTextTweenComplete:Function = null;
         var origScaleX:Number = NaN;
         var origScaleY:Number = NaN;
         var obj:Object = null;
         var mc:TextField = param1;
         var fromPrefix:int = param2;
         var toPrefix:int = param3;
         var fromSuffix:int = param4;
         var toSuffix:int = param5;
         var time:Number = param6;
         var scaleAnimOn:Boolean = param7;
         var onCompleteFunction:Function = param8;
         var onCompleteParams:Array = param9;
         var easeFunction:Ease = param10;
         var suffix:String = param11;
         updateTextfieldText = function():void
         {
            if(mc)
            {
               mc.text = String(obj.prefixValue) + "/" + String(obj.suffixValue);
            }
         };
         onTextTweenComplete = function():void
         {
            if(mc)
            {
               mc.visible = true;
               mc.alpha = 0.999;
            }
            if(onCompleteFunction != null)
            {
               if(onCompleteParams != null)
               {
                  onCompleteFunction(onCompleteParams);
               }
               else
               {
                  onCompleteFunction();
               }
            }
         };
         if(mc != null)
         {
            origScaleX = mc.scaleX;
            origScaleY = mc.scaleY;
            obj = new Object();
            obj.prefixValue = fromPrefix;
            obj.suffixValue = fromSuffix;
            TweenMax.fromTo(mc,time,{"alpha":0},{"alpha":1});
            if(obj)
            {
               if(easeFunction == null)
               {
                  easeFunction = Linear.easeNone;
               }
               if(fromPrefix != toPrefix && fromSuffix != toSuffix)
               {
                  TweenMax.to(obj,time + 0.1,{
                     "prefixValue":toPrefix,
                     "suffixValue":toSuffix,
                     "roundProps":["prefixValue","suffixValue"],
                     "onUpdate":updateTextfieldText,
                     "onComplete":onTextTweenComplete,
                     "ease":easeFunction
                  });
               }
               else if(fromPrefix != toPrefix)
               {
                  obj.suffixValue = toSuffix;
                  TweenMax.to(obj,time + 0.1,{
                     "prefixValue":toPrefix,
                     "roundProps":["prefixValue"],
                     "onUpdate":updateTextfieldText,
                     "onComplete":onTextTweenComplete,
                     "ease":easeFunction
                  });
               }
               else if(fromSuffix != toSuffix)
               {
                  obj.prefixValue = toPrefix;
                  TweenMax.to(obj,time + 0.1,{
                     "suffixValue":toSuffix,
                     "roundProps":["suffixValue"],
                     "onUpdate":updateTextfieldText,
                     "onComplete":onTextTweenComplete,
                     "ease":easeFunction
                  });
               }
            }
         }
      }
      
      public static function createFSGaugeProgressBarTransition(param1:FSGaugeProgressBar, param2:Number, param3:Number, param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null, param8:Ease = null) : void
      {
         if(param1 != null)
         {
            param7 = Boolean(param6) && Boolean(param7 != null) && param7.length > 1 ? [param1,param6,param7[0],param7[1]] : [param1];
            TweenMax.to(param1,param3,{
               "mRatio":param2,
               "onUpdate":onFSGaugeProgressBarUpdate,
               "onUpdateParams":param7,
               "onComplete":param4,
               "onCompleteParams":param5,
               "ease":param8
            });
         }
      }
      
      private static function onFSGaugeProgressBarUpdate(param1:FSGaugeProgressBar, param2:Function = null, param3:Number = -1, param4:int = -1) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         if(param1)
         {
            param1.setRatio(param1.mRatio);
            if(param2 != null)
            {
               _loc5_ = param1.mRatio == param3 / param4;
               _loc6_ = _loc5_ ? 1 : param1.mRatio;
               param2(Number(param3 * _loc6_).toFixed(2));
            }
         }
      }
      
      public static function createFSProgressBarTransition(param1:FSProgressBar, param2:int, param3:Number, param4:Function = null, param5:Function = null) : void
      {
         if(param1 != null)
         {
            TweenMax.to(param1,param3,{
               "mCurrentRealValue":param2,
               "onUpdate":onFSProgressBarUpdate,
               "onUpdateParams":[param1,param5],
               "onComplete":param4
            });
         }
      }
      
      private static function onFSProgressBarUpdate(param1:FSProgressBar, param2:Function = null) : void
      {
         if(param1)
         {
            param1.setValue(param1.mCurrentRealValue);
            if(param2 != null)
            {
               param2(param1.mCurrentRealValue);
            }
         }
      }
      
      public static function tweenHighlightSocketToAlpha(param1:FSPDParticleSystem, param2:Number, param3:Number = 3, param4:Function = null, param5:Object = null) : void
      {
         var _loc6_:TweenMax = null;
         if(param1)
         {
            if(Config.getConfig().getShowSpecialFX())
            {
               _loc6_ = new TweenMax(param1,param3,{
                  "alpha":param2,
                  "onComplete":param4,
                  "onCompleteParams":param5
               });
            }
            else
            {
               param1.alpha = param2;
            }
         }
      }
      
      public static function tweenToAlpha(param1:DisplayObject, param2:Number, param3:Number = 3, param4:int = -1, param5:Function = null, param6:Object = null, param7:Number = 0) : void
      {
         var _loc8_:TweenMax = null;
         if(param1)
         {
            if(Config.getConfig().getShowSpecialFX())
            {
               _loc8_ = new TweenMax(param1,param3,{
                  "alpha":param2,
                  "repeat":param4,
                  "onComplete":param5,
                  "onCompleteParams":param6,
                  "delay":param7
               });
            }
            else
            {
               param1.alpha = param2;
            }
         }
      }
      
      public static function tweenLogToAlpha(param1:FSLogPanel, param2:Number, param3:Number = 3, param4:int = -1, param5:Function = null, param6:Object = null) : void
      {
         var _loc7_:TweenMax = null;
         if(param1)
         {
            if(Config.getConfig().getShowSpecialFX())
            {
               _loc7_ = new TweenMax(param1,param3,{
                  "alpha":param2,
                  "repeat":param4,
                  "onComplete":param5,
                  "onCompleteParams":param6
               });
            }
            else
            {
               param1.alpha = param2;
            }
         }
      }
      
      public static function tweenRotate(param1:DisplayObject, param2:Number = 3, param3:int = -1, param4:Ease = null, param5:Number = 360) : void
      {
         if(param1)
         {
            if(Config.getConfig().getShowSpecialFX())
            {
               if(param4 == null)
               {
                  param4 = Linear.easeNone;
               }
               if(param1)
               {
                  TweenMax.to(param1,param2,{
                     "rotation":deg2rad(param5),
                     "repeat":param3,
                     "ease":param4
                  });
               }
            }
         }
      }
      
      public static function popupZoom(param1:int, param2:Sprite, param3:Function = null) : Tween
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc4_:Tween = null;
         if(param2)
         {
            _loc5_ = null;
            _loc6_ = null;
            _loc7_ = 0;
            if(param1 == EFFECT_MODE_IN)
            {
               param2.scaleX = 0;
               param2.scaleY = 0;
               param2.alpha = 0.2;
               _loc7_ = 0.35;
               _loc8_ = 1;
               _loc9_ = 1;
               _loc6_ = Transitions.EASE_IN_OUT;
            }
            else
            {
               _loc7_ = 0.2;
               _loc8_ = 0;
               _loc9_ = 0.2;
               _loc6_ = {};
            }
            _loc4_ = new Tween(param2,_loc7_,_loc6_);
            _loc4_.scaleTo(_loc8_);
            _loc4_.fadeTo(_loc9_);
            _loc4_.onComplete = param3;
            Starling.juggler.add(_loc4_);
         }
         return _loc4_;
      }
      
      public static function createRotation(param1:DisplayObject, param2:Number = 90, param3:Number = 1, param4:Number = 0, param5:Function = null, param6:Object = null, param7:Ease = null, param8:int = 1) : TweenMax
      {
         var _loc10_:Ease = null;
         var _loc9_:TweenMax = null;
         if(Config.getConfig().getShowSpecialFX() && Boolean(param1))
         {
            _loc10_ = param7 != null ? param7 : Quad.easeOut;
            param2 = deg2rad(param2);
            _loc9_ = TweenMax.to(param1,param3,{
               "rotation":param2,
               "delay":param4,
               "onComplete":param5,
               "onCompleteParams":param6,
               "ease":_loc10_,
               "repeat":param8
            });
         }
         return _loc9_;
      }
      
      public static function createTransition(param1:DisplayObject, param2:FSCoordinate, param3:Number = 1, param4:Number = 0, param5:Function = null, param6:Object = null, param7:Ease = null, param8:Boolean = false, param9:Function = null, param10:Array = null) : TweenMax
      {
         var _loc12_:Ease = null;
         var _loc11_:TweenMax = null;
         if(param1)
         {
            if(Config.getConfig().getShowSpecialFX())
            {
               _loc12_ = param7 != null ? param7 : Quad.easeOut;
               if(param1 is FSCard && Config.getConfig().getCardShadowsEnabled())
               {
                  TweenMax.delayedCall(param4,createShadowZoomTransition,[param1,param3,false,param2.getX(),param2.getY(),true,_loc12_,0]);
               }
               if(param8 && param1.parent != null)
               {
                  param1.parent.addChild(param1);
               }
               _loc11_ = TweenMax.to(param1,param3,{
                  "x":param2.getX(),
                  "y":param2.getY(),
                  "delay":param4,
                  "onComplete":param5,
                  "onCompleteParams":param6,
                  "ease":_loc12_,
                  "onUpdate":param9,
                  "onUpdateParams":param10
               });
            }
            else
            {
               param1.x = param2.getX();
               param1.y = param2.getY();
               if(param5 != null)
               {
                  param5();
               }
            }
         }
         return _loc11_;
      }
      
      public static function create3DRotation(param1:DisplayObject, param2:Number = 1, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Function = null, param8:Object = null, param9:Ease = null) : void
      {
         if(param1)
         {
            TweenMax.to(param1,param2,{
               "rotationX":deg2rad(param3),
               "rotationY":deg2rad(param4),
               "rotationZ":deg2rad(param5),
               "delay":param6,
               "onComplete":param7,
               "onCompleteParams":param8,
               "ease":param9
            });
         }
      }
      
      public static function createPositionAndScaleTransition(param1:DisplayObject, param2:FSCoordinate, param3:Number = 1, param4:Number = 1, param5:Number = 0, param6:Function = null, param7:Object = null, param8:Ease = null) : TweenMax
      {
         var _loc9_:TweenMax = null;
         if(param1)
         {
            createYoYoZoomTransition(param1,param3,param4 / 3,1,null,null,false);
            TweenMax.delayedCall(param4,createTransition,[param1,param2,param4,0.25,null,null,param8]);
         }
         return _loc9_;
      }
      
      public static function createCardZoomTransition(param1:FSCard, param2:Number = 1.3, param3:Number = 1, param4:Boolean = true, param5:Boolean = true) : TweenMax
      {
         var _loc6_:Ease = null;
         if(param1)
         {
            _loc6_ = Linear.easeIn;
            if(param4)
            {
               _loc6_ = Back.easeOut;
            }
            if(Config.getConfig().getCardShadowsEnabled() && param5)
            {
               createShadowZoomTransition(param1,param3,true,0,0,param4,null,0);
            }
            return new TweenMax(param1,param3,{
               "scaleX":param2,
               "scaleY":param2,
               "ease":_loc6_,
               "onUpdate":param1.onCardZoomTransitionUpdate
            });
         }
         return null;
      }
      
      public static function createShadowZoomTransition(param1:FSCard, param2:Number = 1, param3:Boolean = true, param4:Number = 0, param5:Number = 0, param6:Boolean = true, param7:Ease = null, param8:int = 0) : void
      {
         var _loc9_:FSCardShadow = null;
         var _loc10_:int = 0;
         var _loc11_:FSCoordinate = null;
         var _loc12_:Number = NaN;
         var _loc13_:TweenMax = null;
         var _loc14_:Ease = null;
         var _loc15_:TweenMax = null;
         if(Config.getConfig().getCardShadowsEnabled())
         {
            if(param1 != null && InstanceMng.getCurrentScreen() is FSBattleScreen || InstanceMng.getCurrentScreen() is FSBattleScreenPvP)
            {
               _loc9_ = param1.getShadow();
               if(_loc9_ == null && param1.getBFId() != -1)
               {
                  _loc9_ = param1.createShadow();
               }
               if(_loc9_ != null)
               {
                  if(param1 is FSEvent || param1.getParentUserBattleInfo() != null && !param1.getParentUserBattleInfo().isOwnerBattleInfo())
                  {
                     if(!param3 && _loc9_.visible == false)
                     {
                        return;
                     }
                     _loc9_.visible = true;
                     param1.setUpdateShadow(true);
                     _loc9_.alpha = 0.45;
                     if(param1.parent != null)
                     {
                        _loc10_ = param1.parent.getChildIndex(param1);
                        if(_loc10_ != -1)
                        {
                           param1.parent.addChildAt(_loc9_,_loc10_ - 1);
                        }
                     }
                     return;
                  }
                  param1.setUpdateShadow(false);
                  if(param3)
                  {
                     _loc9_.setOnDefaultPos();
                     _loc9_.visible = true;
                     if(param1.parent != null)
                     {
                        _loc10_ = param1.parent.getChildIndex(param1);
                        if(_loc10_ != -1)
                        {
                           param1.parent.addChildAt(_loc9_,_loc10_ - 1);
                        }
                     }
                  }
                  _loc11_ = new FSCoordinate();
                  _loc11_.mX = param3 ? _loc9_.getDefaultXPos() - _loc9_.getOffsetToMoveX() : param4;
                  _loc11_.mY = param3 ? _loc9_.getDefaultYPos() + _loc9_.getOffsetToMoveY() : param5;
                  if(param1.isZoomedIn())
                  {
                     _loc12_ = param3 ? 0.2 : 1;
                  }
                  else
                  {
                     _loc12_ = param3 ? 0.6 : 1;
                  }
                  _loc13_ = param1.getShadowTween();
                  if(_loc13_ != null)
                  {
                     _loc13_.kill();
                  }
                  if(param7 != null)
                  {
                     _loc14_ = param7;
                  }
                  else
                  {
                     _loc14_ = Linear.easeNone;
                     if(param6)
                     {
                        _loc14_ = Back.easeOut;
                     }
                     if(!param3)
                     {
                        _loc14_ = Back.easeIn;
                     }
                  }
                  _loc15_ = new TweenMax(_loc9_,param2,{
                     "x":_loc11_.getX(),
                     "y":_loc11_.getY(),
                     "rotation":param8,
                     "alpha":_loc12_,
                     "startAt":{"onComplete":param1.onShadowTweeningInit},
                     "onUpdate":param1.onShadowTweeningUpdate,
                     "onComplete":param1.onShadowTweeningOver,
                     "onCompleteParams":[param3],
                     "ease":_loc14_
                  });
                  param1.setShadowTween(_loc15_);
               }
            }
         }
      }
      
      public static function createComicStripZoomTransition(param1:ComicStrip, param2:Component, param3:Number = 2, param4:Number = 1, param5:Number = 0.999, param6:Function = null, param7:Object = null) : TweenMax
      {
         var _loc8_:FSCoordinate = null;
         var _loc9_:ComicStripDef = null;
         var _loc10_:Ease = null;
         var _loc11_:String = null;
         var _loc12_:Number = NaN;
         if(Boolean(param1) && Boolean(param2))
         {
            _loc8_ = new FSCoordinate();
            _loc9_ = param1.getComicStripDef();
            if(!_loc9_ || _loc9_ == null)
            {
               return null;
            }
            if(_loc9_.getIsBG())
            {
               _loc8_.mX = param1.x;
               _loc8_.mY = param1.y;
            }
            else
            {
               _loc8_.mX = param3 == 1 ? param2.width * _loc9_.getPosX() / 100 : (param2.width - param1.width * param3) / 2;
               _loc8_.mY = param3 == 1 ? param2.height * _loc9_.getPosY() / 100 : (param2.height - param1.height * param3) / 2;
            }
            _loc10_ = Sine.easeOut;
            _loc11_ = _loc9_.getFXTransition();
            if(_loc11_ != "" && _loc11_ != null)
            {
               _loc12_ = _loc9_.getFadeTime();
               switch(_loc11_)
               {
                  case "rotate":
                     _loc10_ = Quad.easeOut;
                     tweenRotate(param1,_loc12_,0,_loc10_);
                     _loc8_.mX = param1.x;
                     _loc8_.mY = param1.y;
                     param4 *= _loc12_;
               }
            }
            else
            {
               param4 = 0.5;
            }
            tweenToAlpha(param1,param5,param4,0);
            return new TweenMax(param1,param4,{
               "x":_loc8_.getX(),
               "y":_loc8_.getY(),
               "scaleX":param3,
               "scaleY":param3,
               "onComplete":param6,
               "onCompleteParams":param7,
               "ease":_loc10_
            });
         }
         return null;
      }
      
      public static function createZoomTransition(param1:DisplayObject, param2:Number = 1.3, param3:Number = 1, param4:Function = null, param5:Object = null, param6:Ease = null) : TweenMax
      {
         if(param1)
         {
            param6 = param6 == null ? Linear.easeIn : param6;
            return new TweenMax(param1,param3,{
               "scaleX":param2,
               "scaleY":param2,
               "onComplete":param4,
               "onCompleteParams":param5,
               "ease":param6
            });
         }
         return null;
      }
      
      public static function createZoomAlphaTween(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Ease = null, param8:Function = null, param9:Array = null, param10:Boolean = true) : void
      {
         var onUpdateDo:Function = null;
         var mc:DisplayObject = param1;
         var speed:Number = param2;
         var fromAlpha:Number = param3;
         var toAlpha:Number = param4;
         var fromScale:Number = param5;
         var toScale:Number = param6;
         var easeFunction:Ease = param7;
         var onCompleteFunction:Function = param8;
         var onCompleteParams:Array = param9;
         var alwaysOnTop:Boolean = param10;
         onUpdateDo = function(param1:DisplayObject):void
         {
            if(Boolean(param1) && Boolean(param1.parent))
            {
               param1.parent.addChild(param1);
            }
         };
         if(mc)
         {
            easeFunction = easeFunction == null ? Linear.easeIn : easeFunction;
            mc.alpha = fromAlpha;
            mc.scaleX = fromScale;
            mc.scaleY = fromScale;
            if(alwaysOnTop)
            {
               TweenMax.to(mc,speed,{
                  "alpha":toAlpha,
                  "scaleX":toScale,
                  "scaleY":toScale,
                  "ease":easeFunction,
                  "onUpdate":onUpdateDo,
                  "onUpdateParams":[mc],
                  "onComplete":onCompleteFunction,
                  "onCompleteParams":onCompleteParams
               });
            }
            else
            {
               TweenMax.to(mc,speed,{
                  "alpha":toAlpha,
                  "scaleX":toScale,
                  "scaleY":toScale,
                  "ease":easeFunction,
                  "onComplete":onCompleteFunction,
                  "onCompleteParams":onCompleteParams
               });
            }
         }
      }
      
      public static function createVolumeTweenTransition(param1:Sound, param2:Number, param3:Number = 0.5) : void
      {
         if(param1)
         {
            TweenMax.to(param1,param3,{"volume":param2});
         }
      }
      
      public static function typeWriterEffect(param1:TextField, param2:String, param3:Number = 0.03, param4:Function = null, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(param1 != null && param2 != null && param2 != "")
         {
            if(param5)
            {
               Utils.playSound(Constants.SOUND_TYPEWRITER,SoundManager.TYPE_SFX);
            }
            _loc6_ = 0;
            param1.text = "";
            TweenMax.killDelayedCallsTo(appendChar);
            TweenMax.killDelayedCallsTo(typeWriterEffect);
            _loc7_ = param2 ? param2.charAt(_loc6_) : "";
            TweenMax.delayedCall(param3,appendChar,[param1,param2,_loc7_,_loc6_,param3,param4]);
         }
      }
      
      public static function appendChar(param1:TextField, param2:String, param3:String, param4:int, param5:Number = 0.03, param6:Function = null) : void
      {
         if(Boolean(param1) && param2 != null)
         {
            param1.text += param3 ? param3 : "";
            param4++;
            if(param2)
            {
               if(param4 == param2.length)
               {
                  TweenMax.killDelayedCallsTo(appendChar);
                  if(param6 != null)
                  {
                     Utils.stopSound(Constants.SOUND_TYPEWRITER);
                     param6();
                  }
               }
               else
               {
                  param3 = param2.charAt(param4);
                  TweenMax.delayedCall(param5,appendChar,[param1,param2,param3,param4,param5,param6]);
               }
               if(param1.parent != null && param1.parent is FSLogPanel && FSLogPanel(param1.parent).parent != null)
               {
                  FSLogPanel(param1.parent).parent.addChild(FSLogPanel(param1.parent));
               }
            }
         }
      }
      
      public static function zoomInLevelItem(param1:LevelItemContainer, param2:Number = 0.3) : void
      {
         if(param1 != null)
         {
            TweenMax.to(param1,param2,{
               "scaleX":1,
               "scaleY":1,
               "scaleZ":1
            });
         }
      }
      
      public static function zoomOutLevelItem(param1:LevelItemContainer, param2:Function, param3:Array, param4:Number = 0.3) : void
      {
         if(param1 != null)
         {
            TweenMax.to(param1,param4,{
               "scaleX":0,
               "scaleY":0,
               "scaleZ":0,
               "onComplete":param2,
               "onCompleteParams":param3
            });
         }
      }
      
      public static function createBezierCurvesBetweenTwoPoints(param1:*, param2:FSCoordinate, param3:FSCoordinate, param4:Number, param5:int = 1, param6:int = 150, param7:Boolean = true, param8:Function = null, param9:Array = null) : void
      {
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc15_:Boolean = false;
         var _loc16_:Number = NaN;
         var _loc17_:* = undefined;
         var _loc18_:TweenMax = null;
         var _loc19_:Object = null;
         if(param1)
         {
            _loc10_ = new Array();
            _loc12_ = param1 is FSPDParticleSystem ? "emitterX" : "x";
            _loc13_ = param1 is FSPDParticleSystem ? "emitterY" : "y";
            param1[_loc12_] = param2.getX();
            param1[_loc13_] = param2.getY();
            _loc15_ = (Utils.isAndroidOrDesktop() || Utils.isBrowser()) && param1 is FSPDParticleSystem;
            _loc11_ = 1;
            while(_loc11_ <= param5)
            {
               _loc19_ = new Object();
               if(_loc11_ == 1)
               {
                  _loc19_[_loc12_] = param2.getX();
                  _loc19_[_loc13_] = param2.getY();
                  if(_loc15_)
                  {
                     _loc19_[_loc12_] *= Starling.current.contentScaleFactor;
                     _loc19_[_loc13_] *= Starling.current.contentScaleFactor;
                  }
                  _loc10_.push(_loc19_);
               }
               if(param5 > 1)
               {
                  _loc19_ = new Object();
                  _loc14_ = _loc11_ / param5;
                  _loc19_[_loc12_] = param2.getX() + _loc14_ * (param3.getX() - param2.getX());
                  _loc19_[_loc13_] = param2.getY() + _loc14_ * (param3.getY() - param2.getY());
                  if(param7)
                  {
                     _loc19_[_loc13_] += _loc11_ % 2 == 0 ? -param6 * (1 - _loc14_) : param6 * (1 - _loc14_);
                  }
                  else
                  {
                     _loc19_[_loc12_] += _loc11_ % 2 == 0 ? -param6 * (1 - _loc14_) : param6 * (1 - _loc14_);
                  }
                  if(_loc15_)
                  {
                     _loc19_[_loc12_] *= Starling.current.contentScaleFactor;
                     _loc19_[_loc13_] *= Starling.current.contentScaleFactor;
                  }
                  _loc10_.push(_loc19_);
               }
               if(_loc11_ == param5)
               {
                  _loc19_ = new Object();
                  _loc19_[_loc12_] = param3.getX();
                  _loc19_[_loc13_] = param3.getY();
                  if(_loc15_)
                  {
                     _loc19_[_loc12_] *= Starling.current.contentScaleFactor;
                     _loc19_[_loc13_] *= Starling.current.contentScaleFactor;
                  }
                  _loc10_.push(_loc19_);
               }
               _loc11_++;
            }
            _loc16_ = param3.mY < param2.mY ? 90 * Math.PI / 180 : -90 * Math.PI / 180;
            _loc17_ = param1 is FSPDParticleSystem ? false : ["x","y","rotation",_loc16_,true];
            _loc18_ = new TweenMax(param1,param4,{
               "bezier":{
                  "type":"soft",
                  "values":_loc10_,
                  "autoRotate":_loc17_
               },
               "ease":Linear.easeOut,
               "onComplete":param8,
               "onCompleteParams":param9
            });
         }
      }
      
      public static function createIntroPlayer(param1:BattleIntroCharacter, param2:Number, param3:FSCoordinate, param4:FSCoordinate, param5:FSCoordinate, param6:Function = null) : void
      {
         var introPlayerPhase2:Function = null;
         var playerIntro:BattleIntroCharacter = param1;
         var transTime:Number = param2;
         var coord1:FSCoordinate = param3;
         var coord2:FSCoordinate = param4;
         var coord3:FSCoordinate = param5;
         var onCompleteFunction:Function = param6;
         introPlayerPhase2 = function():void
         {
            Utils.playSound("unfold_card",SoundManager.TYPE_SFX);
            createZoomTransition(playerIntro,1,0.25,onCompleteFunction,null,Sine.easeInOut);
         };
         if(playerIntro != null)
         {
            playerIntro.x = coord1.mX;
            playerIntro.y = coord1.mY;
            TweenMax.to(playerIntro,transTime,{
               "bezier":{"values":[{
                  "x":coord1.mX,
                  "y":coord1.mY
               },{
                  "x":coord2.mX,
                  "y":coord2.mY
               },{
                  "x":coord3.mX,
                  "y":coord3.mY
               }]},
               "ease":Quad.easeOut,
               "scaleX":1.25,
               "scaleY":1.25,
               "onComplete":introPlayerPhase2
            });
         }
      }
      
      public static function createIntroPlayerPhase3(param1:BattleIntroCharacter, param2:Number, param3:FSCoordinate, param4:FSCoordinate, param5:Function) : void
      {
         var onPhase3Completed:Function = null;
         var playerIntro:BattleIntroCharacter = param1;
         var transTime:Number = param2;
         var coord1:FSCoordinate = param3;
         var coord2:FSCoordinate = param4;
         var onCompleteFunction:Function = param5;
         onPhase3Completed = function():void
         {
            tweenToAlpha(playerIntro,0,0.25,0,onCompleteFunction);
         };
         if(playerIntro != null)
         {
            TweenMax.to(playerIntro,transTime,{
               "bezier":{
                  "type":"soft",
                  "values":[{
                     "x":coord1.mX,
                     "y":coord1.mY
                  },{
                     "x":coord2.mX,
                     "y":coord2.mY
                  }]
               },
               "ease":Sine.easeInOut,
               "onComplete":onPhase3Completed
            });
         }
      }
      
      public static function handle3DEffect(param1:FSCard, param2:Touch, param3:Point, param4:Number = 3.5) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         param3 = param2.getLocation(param1,param3);
         param3.x = -1 + param3.x / (param1.width / 2);
         param3.y = -1 + param3.y / (param1.height / 2);
         param3.x = param3.x < -1 ? -1 : param3.x;
         param3.x = param3.x > 1 ? 1 : param3.x;
         param3.y = param3.y < -1 ? -1 : param3.y;
         param3.y = param3.y > 1 ? 1 : param3.y;
         _loc5_ = param3.y / param4 * -1;
         _loc6_ = param3.x / param4;
         TweenMax.to(param1,0.25,{
            "rotationX":_loc5_,
            "rotationY":_loc6_,
            "ease":Sine.easeOut
         });
      }
   }
}

