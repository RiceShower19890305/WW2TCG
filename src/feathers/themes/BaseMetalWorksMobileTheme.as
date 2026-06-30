package feathers.themes
{
   import feathers.controls.Alert;
   import feathers.controls.AutoComplete;
   import feathers.controls.AutoSizeMode;
   import feathers.controls.Button;
   import feathers.controls.ButtonGroup;
   import feathers.controls.ButtonState;
   import feathers.controls.Callout;
   import feathers.controls.Check;
   import feathers.controls.DataGrid;
   import feathers.controls.DateTimeSpinner;
   import feathers.controls.Drawers;
   import feathers.controls.GroupedList;
   import feathers.controls.Header;
   import feathers.controls.ImageLoader;
   import feathers.controls.ItemRendererLayoutOrder;
   import feathers.controls.Label;
   import feathers.controls.LayoutGroup;
   import feathers.controls.List;
   import feathers.controls.NumericStepper;
   import feathers.controls.PageIndicator;
   import feathers.controls.Panel;
   import feathers.controls.PanelScreen;
   import feathers.controls.PickerList;
   import feathers.controls.ProgressBar;
   import feathers.controls.Radio;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollScreen;
   import feathers.controls.ScrollText;
   import feathers.controls.Scroller;
   import feathers.controls.SimpleScrollBar;
   import feathers.controls.Slider;
   import feathers.controls.SpinnerList;
   import feathers.controls.StepperButtonLayoutMode;
   import feathers.controls.TabBar;
   import feathers.controls.TextArea;
   import feathers.controls.TextCallout;
   import feathers.controls.TextInput;
   import feathers.controls.TextInputState;
   import feathers.controls.Toast;
   import feathers.controls.ToggleButton;
   import feathers.controls.ToggleSwitch;
   import feathers.controls.TrackLayoutMode;
   import feathers.controls.Tree;
   import feathers.controls.popups.BottomDrawerPopUpContentManager;
   import feathers.controls.popups.CalloutPopUpContentManager;
   import feathers.controls.renderers.BaseDefaultItemRenderer;
   import feathers.controls.renderers.DefaultDataGridCellRenderer;
   import feathers.controls.renderers.DefaultDataGridHeaderRenderer;
   import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
   import feathers.controls.renderers.DefaultGroupedListItemRenderer;
   import feathers.controls.renderers.DefaultListItemRenderer;
   import feathers.controls.renderers.DefaultTreeItemRenderer;
   import feathers.controls.text.ITextEditorViewPort;
   import feathers.controls.text.StageTextTextEditor;
   import feathers.controls.text.TextBlockTextEditor;
   import feathers.controls.text.TextBlockTextRenderer;
   import feathers.controls.text.TextFieldTextEditorViewPort;
   import feathers.core.FeathersControl;
   import feathers.core.FocusManager;
   import feathers.core.ITextEditor;
   import feathers.core.ITextRenderer;
   import feathers.core.PopUpManager;
   import feathers.layout.Direction;
   import feathers.layout.HorizontalAlign;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.RelativePosition;
   import feathers.layout.VerticalAlign;
   import feathers.layout.VerticalLayout;
   import feathers.media.FullScreenToggleButton;
   import feathers.media.MuteToggleButton;
   import feathers.media.PlayPauseToggleButton;
   import feathers.media.SeekSlider;
   import feathers.media.VolumeSlider;
   import feathers.skins.ImageSkin;
   import feathers.system.DeviceCapabilities;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Stage;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class BaseMetalWorksMobileTheme extends StyleNameFunctionTheme
   {
      
      protected static const SOURCE_SANS_PRO_REGULAR:Class = BaseMetalWorksMobileTheme_SOURCE_SANS_PRO_REGULAR;
      
      protected static const SOURCE_SANS_PRO_SEMIBOLD:Class = BaseMetalWorksMobileTheme_SOURCE_SANS_PRO_SEMIBOLD;
      
      public static const FONT_NAME:String = "SourceSansPro";
      
      public static const FONT_NAME_STACK:String = "Source Sans Pro,Helvetica,_sans";
      
      protected static const PRIMARY_BACKGROUND_COLOR:uint = 4866359;
      
      protected static const LIGHT_TEXT_COLOR:uint = 15066597;
      
      protected static const DARK_TEXT_COLOR:uint = 1710102;
      
      protected static const SELECTED_TEXT_COLOR:uint = 16750848;
      
      protected static const LIGHT_DISABLED_TEXT_COLOR:uint = 9079434;
      
      protected static const DARK_DISABLED_TEXT_COLOR:uint = 3683376;
      
      protected static const LIST_BACKGROUND_COLOR:uint = 3683376;
      
      protected static const GROUPED_LIST_HEADER_BACKGROUND_COLOR:uint = 3025446;
      
      protected static const GROUPED_LIST_FOOTER_BACKGROUND_COLOR:uint = 3025446;
      
      protected static const MODAL_OVERLAY_COLOR:uint = 2696222;
      
      protected static const MODAL_OVERLAY_ALPHA:Number = 0.8;
      
      protected static const DRAWER_OVERLAY_COLOR:uint = 2696222;
      
      protected static const DRAWER_OVERLAY_ALPHA:Number = 0.4;
      
      protected static const VIDEO_OVERLAY_COLOR:uint = 1710102;
      
      protected static const VIDEO_OVERLAY_ALPHA:Number = 0.2;
      
      protected static const DATA_GRID_COLUMN_OVERLAY_COLOR:uint = 3683376;
      
      protected static const DATA_GRID_COLUMN_OVERLAY_ALPHA:Number = 0.4;
      
      protected static const DEFAULT_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(4,4,1,1);
      
      protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(4,4,1,20);
      
      protected static const SMALL_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(2,2,1,1);
      
      protected static const BACK_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(13,0,1,28);
      
      protected static const FORWARD_BUTTON_SCALE9_GRID:Rectangle = new Rectangle(3,0,1,28);
      
      protected static const ITEM_RENDERER_SCALE9_GRID:Rectangle = new Rectangle(1,1,1,42);
      
      protected static const INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID:Rectangle = new Rectangle(2,2,1,40);
      
      protected static const INSET_ITEM_RENDERER_FIRST_SCALE9_GRID:Rectangle = new Rectangle(7,7,1,35);
      
      protected static const INSET_ITEM_RENDERER_LAST_SCALE9_GRID:Rectangle = new Rectangle(7,2,1,35);
      
      protected static const INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID:Rectangle = new Rectangle(7,7,1,30);
      
      protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(11,11,1,22);
      
      protected static const SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID:Rectangle = new Rectangle(2,6,1,32);
      
      protected static const HORIZONTAL_SCROLL_BAR_THUMB_SCALE9_GRID:Rectangle = new Rectangle(4,0,4,5);
      
      protected static const VERTICAL_SCROLL_BAR_THUMB_SCALE9_GRID:Rectangle = new Rectangle(0,4,5,4);
      
      protected static const FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5,5,1,1);
      
      protected static const DATA_GRID_HEADER_DIVIDER_SCALE_9_GRID:Rectangle = new Rectangle(0,1,2,4);
      
      protected static const DATA_GRID_VERTICAL_DIVIDER_SCALE_9_GRID:Rectangle = new Rectangle(0,1,1,4);
      
      protected static const DATA_GRID_COLUMN_RESIZE_SCALE_9_GRID:Rectangle = new Rectangle(0,1,3,28);
      
      protected static const DATA_GRID_COLUMN_DROP_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(0,1,3,28);
      
      protected static const HEADER_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1,1,128,64);
      
      protected static const TAB_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1,0,22,44);
      
      protected static const THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER:String = "metal-works-mobile-spinner-list-item-renderer";
      
      protected static const THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER:String = "metal-works-mobile-tablet-picker-list-item-renderer";
      
      protected static const THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON:String = "metal-works-mobile-alert-button-group-button";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "metal-works-mobile-horizontal-simple-scroll-bar-thumb";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "metal-works-mobile-vertical-simple-scroll-bar-thumb";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "metal-works-mobile-horizontal-slider-minimum-track";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK:String = "metal-works-mobile-horizontal-slider-maximum-track";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "metal-works-mobile-vertical-slider-minimum-track";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK:String = "metal-works-mobile-vertical-slider-maximum-track";
      
      protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "metal-works-mobile-date-time-spinner-list-item-renderer";
      
      protected static const THEME_STYLE_NAME_TOAST_ACTIONS_BUTTON:String = "metal-works-mobile-toast-actions-button";
      
      protected var smallFontSize:int = 10;
      
      protected var regularFontSize:int = 12;
      
      protected var largeFontSize:int = 14;
      
      protected var extraLargeFontSize:int = 18;
      
      protected var gridSize:int = 44;
      
      protected var gutterSize:int = 12;
      
      protected var smallGutterSize:int = 8;
      
      protected var smallControlGutterSize:int = 6;
      
      protected var wideControlSize:int = 156;
      
      protected var controlSize:int = 28;
      
      protected var smallControlSize:int = 12;
      
      protected var borderSize:int = 1;
      
      protected var popUpFillSize:int = 276;
      
      protected var calloutBackgroundMinSize:int = 12;
      
      protected var calloutArrowOverlapGap:int = -2;
      
      protected var scrollBarGutterSize:int = 2;
      
      protected var focusPaddingSize:int = -1;
      
      protected var tabFocusPaddingSize:int = 4;
      
      protected var lightFontStyles:TextFormat;
      
      protected var darkFontStyles:TextFormat;
      
      protected var selectedFontStyles:TextFormat;
      
      protected var lightDisabledFontStyles:TextFormat;
      
      protected var smallLightFontStyles:TextFormat;
      
      protected var smallLightDisabledFontStyles:TextFormat;
      
      protected var largeLightFontStyles:TextFormat;
      
      protected var largeDarkFontStyles:TextFormat;
      
      protected var largeLightDisabledFontStyles:TextFormat;
      
      protected var lightUIFontStyles:TextFormat;
      
      protected var darkUIFontStyles:TextFormat;
      
      protected var selectedUIFontStyles:TextFormat;
      
      protected var lightCenteredUIFontStyles:TextFormat;
      
      protected var lightCenteredDisabledUIFontStyles:TextFormat;
      
      protected var lightDisabledUIFontStyles:TextFormat;
      
      protected var darkDisabledUIFontStyles:TextFormat;
      
      protected var largeLightUIFontStyles:TextFormat;
      
      protected var largeDarkUIFontStyles:TextFormat;
      
      protected var largeSelectedUIFontStyles:TextFormat;
      
      protected var largeLightUIDisabledFontStyles:TextFormat;
      
      protected var largeDarkUIDisabledFontStyles:TextFormat;
      
      protected var xlargeLightUIFontStyles:TextFormat;
      
      protected var xlargeLightUIDisabledFontStyles:TextFormat;
      
      protected var lightInputFontStyles:TextFormat;
      
      protected var lightDisabledInputFontStyles:TextFormat;
      
      protected var lightScrollTextFontStyles:TextFormat;
      
      protected var lightDisabledScrollTextFontStyles:TextFormat;
      
      protected var atlas:TextureAtlas;
      
      protected var focusIndicatorSkinTexture:Texture;
      
      protected var headerBackgroundSkinTexture:Texture;
      
      protected var popUpHeaderBackgroundSkinTexture:Texture;
      
      protected var backgroundSkinTexture:Texture;
      
      protected var backgroundDisabledSkinTexture:Texture;
      
      protected var backgroundInsetSkinTexture:Texture;
      
      protected var backgroundInsetDisabledSkinTexture:Texture;
      
      protected var backgroundInsetFocusedSkinTexture:Texture;
      
      protected var backgroundInsetDangerSkinTexture:Texture;
      
      protected var backgroundLightBorderSkinTexture:Texture;
      
      protected var backgroundDarkBorderSkinTexture:Texture;
      
      protected var backgroundDangerBorderSkinTexture:Texture;
      
      protected var buttonUpSkinTexture:Texture;
      
      protected var buttonDownSkinTexture:Texture;
      
      protected var buttonDisabledSkinTexture:Texture;
      
      protected var buttonSelectedUpSkinTexture:Texture;
      
      protected var buttonSelectedDisabledSkinTexture:Texture;
      
      protected var buttonCallToActionUpSkinTexture:Texture;
      
      protected var buttonCallToActionDownSkinTexture:Texture;
      
      protected var buttonDangerUpSkinTexture:Texture;
      
      protected var buttonDangerDownSkinTexture:Texture;
      
      protected var buttonBackUpSkinTexture:Texture;
      
      protected var buttonBackDownSkinTexture:Texture;
      
      protected var buttonBackDisabledSkinTexture:Texture;
      
      protected var buttonForwardUpSkinTexture:Texture;
      
      protected var buttonForwardDownSkinTexture:Texture;
      
      protected var buttonForwardDisabledSkinTexture:Texture;
      
      protected var pickerListButtonIconTexture:Texture;
      
      protected var pickerListButtonSelectedIconTexture:Texture;
      
      protected var pickerListButtonIconDisabledTexture:Texture;
      
      protected var tabUpSkinTexture:Texture;
      
      protected var tabDownSkinTexture:Texture;
      
      protected var tabDisabledSkinTexture:Texture;
      
      protected var tabSelectedUpSkinTexture:Texture;
      
      protected var tabSelectedDisabledSkinTexture:Texture;
      
      protected var pickerListItemSelectedIconTexture:Texture;
      
      protected var spinnerListSelectionOverlaySkinTexture:Texture;
      
      protected var radioUpIconTexture:Texture;
      
      protected var radioDownIconTexture:Texture;
      
      protected var radioDisabledIconTexture:Texture;
      
      protected var radioSelectedUpIconTexture:Texture;
      
      protected var radioSelectedDownIconTexture:Texture;
      
      protected var radioSelectedDisabledIconTexture:Texture;
      
      protected var checkUpIconTexture:Texture;
      
      protected var checkDownIconTexture:Texture;
      
      protected var checkDisabledIconTexture:Texture;
      
      protected var checkSelectedUpIconTexture:Texture;
      
      protected var checkSelectedDownIconTexture:Texture;
      
      protected var checkSelectedDisabledIconTexture:Texture;
      
      protected var pageIndicatorNormalSkinTexture:Texture;
      
      protected var pageIndicatorSelectedSkinTexture:Texture;
      
      protected var itemRendererUpSkinTexture:Texture;
      
      protected var itemRendererSelectedSkinTexture:Texture;
      
      protected var insetItemRendererUpSkinTexture:Texture;
      
      protected var insetItemRendererSelectedSkinTexture:Texture;
      
      protected var insetItemRendererFirstUpSkinTexture:Texture;
      
      protected var insetItemRendererFirstSelectedSkinTexture:Texture;
      
      protected var insetItemRendererLastUpSkinTexture:Texture;
      
      protected var insetItemRendererLastSelectedSkinTexture:Texture;
      
      protected var insetItemRendererSingleUpSkinTexture:Texture;
      
      protected var insetItemRendererSingleSelectedSkinTexture:Texture;
      
      protected var calloutTopArrowSkinTexture:Texture;
      
      protected var calloutRightArrowSkinTexture:Texture;
      
      protected var calloutBottomArrowSkinTexture:Texture;
      
      protected var calloutLeftArrowSkinTexture:Texture;
      
      protected var dangerCalloutTopArrowSkinTexture:Texture;
      
      protected var dangerCalloutRightArrowSkinTexture:Texture;
      
      protected var dangerCalloutBottomArrowSkinTexture:Texture;
      
      protected var dangerCalloutLeftArrowSkinTexture:Texture;
      
      protected var verticalScrollBarThumbSkinTexture:Texture;
      
      protected var horizontalScrollBarThumbSkinTexture:Texture;
      
      protected var searchIconTexture:Texture;
      
      protected var searchIconDisabledTexture:Texture;
      
      protected var listDrillDownAccessoryTexture:Texture;
      
      protected var listDrillDownAccessorySelectedTexture:Texture;
      
      protected var treeDisclosureOpenIconTexture:Texture;
      
      protected var treeDisclosureOpenSelectedIconTexture:Texture;
      
      protected var treeDisclosureClosedIconTexture:Texture;
      
      protected var treeDisclosureClosedSelectedIconTexture:Texture;
      
      protected var dataGridHeaderSortAscendingIconTexture:Texture;
      
      protected var dataGridHeaderSortDescendingIconTexture:Texture;
      
      protected var dataGridHeaderDividerSkinTexture:Texture;
      
      protected var dataGridVerticalDividerSkinTexture:Texture;
      
      protected var dataGridColumnResizeSkinTexture:Texture;
      
      protected var dataGridColumnDropIndicatorSkinTexture:Texture;
      
      protected var dragHandleIcon:Texture;
      
      protected var playPauseButtonPlayUpIconTexture:Texture;
      
      protected var playPauseButtonPlayDownIconTexture:Texture;
      
      protected var playPauseButtonPauseUpIconTexture:Texture;
      
      protected var playPauseButtonPauseDownIconTexture:Texture;
      
      protected var overlayPlayPauseButtonPlayUpIconTexture:Texture;
      
      protected var overlayPlayPauseButtonPlayDownIconTexture:Texture;
      
      protected var fullScreenToggleButtonEnterUpIconTexture:Texture;
      
      protected var fullScreenToggleButtonEnterDownIconTexture:Texture;
      
      protected var fullScreenToggleButtonExitUpIconTexture:Texture;
      
      protected var fullScreenToggleButtonExitDownIconTexture:Texture;
      
      protected var muteToggleButtonLoudUpIconTexture:Texture;
      
      protected var muteToggleButtonLoudDownIconTexture:Texture;
      
      protected var muteToggleButtonMutedUpIconTexture:Texture;
      
      protected var muteToggleButtonMutedDownIconTexture:Texture;
      
      protected var volumeSliderMinimumTrackSkinTexture:Texture;
      
      protected var volumeSliderMaximumTrackSkinTexture:Texture;
      
      protected var seekSliderProgressSkinTexture:Texture;
      
      public function BaseMetalWorksMobileTheme()
      {
         super();
      }
      
      protected static function textRendererFactory() : ITextRenderer
      {
         return new TextBlockTextRenderer();
      }
      
      protected static function textEditorFactory() : ITextEditor
      {
         return new StageTextTextEditor();
      }
      
      protected static function textAreaTextEditorFactory() : ITextEditorViewPort
      {
         return new TextFieldTextEditorViewPort();
      }
      
      protected static function stepperTextEditorFactory() : TextBlockTextEditor
      {
         return new TextBlockTextEditor();
      }
      
      protected static function pickerListSpinnerListFactory() : SpinnerList
      {
         return new SpinnerList();
      }
      
      protected static function scrollBarFactory() : SimpleScrollBar
      {
         return new SimpleScrollBar();
      }
      
      protected static function popUpOverlayFactory() : DisplayObject
      {
         var _loc1_:Quad = new Quad(100,100,MODAL_OVERLAY_COLOR);
         _loc1_.alpha = MODAL_OVERLAY_ALPHA;
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         if(this.atlas)
         {
            this.atlas.texture.root.onRestore = null;
            this.atlas.dispose();
            this.atlas = null;
         }
         super.dispose();
      }
      
      protected function initialize() : void
      {
         this.initializeFonts();
         this.initializeTextures();
         this.initializeGlobals();
         this.initializeStage();
         this.initializeStyleProviders();
      }
      
      protected function initializeStage() : void
      {
         this.starling.stage.color = PRIMARY_BACKGROUND_COLOR;
         this.starling.nativeStage.color = PRIMARY_BACKGROUND_COLOR;
      }
      
      protected function initializeGlobals() : void
      {
         FeathersControl.defaultTextRendererFactory = textRendererFactory;
         FeathersControl.defaultTextEditorFactory = textEditorFactory;
         PopUpManager.overlayFactory = popUpOverlayFactory;
         Callout.stagePadding = this.smallGutterSize;
         Toast.containerFactory = this.toastContainerFactory;
         var _loc1_:Stage = this.starling.stage;
         FocusManager.setEnabledForStage(_loc1_,true);
      }
      
      protected function initializeFonts() : void
      {
         this.lightFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.darkFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,DARK_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.lightDisabledFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,LIGHT_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.selectedFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,SELECTED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.smallLightFontStyles = new TextFormat(FONT_NAME,this.smallFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.smallLightDisabledFontStyles = new TextFormat(FONT_NAME,this.smallFontSize,LIGHT_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.largeLightFontStyles = new TextFormat(FONT_NAME,this.largeFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.largeDarkFontStyles = new TextFormat(FONT_NAME,this.largeFontSize,DARK_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.largeLightDisabledFontStyles = new TextFormat(FONT_NAME,this.largeFontSize,LIGHT_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.lightUIFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.lightUIFontStyles.bold = true;
         this.darkUIFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,DARK_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.darkUIFontStyles.bold = true;
         this.selectedUIFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,SELECTED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.selectedUIFontStyles.bold = true;
         this.lightDisabledUIFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,LIGHT_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.lightDisabledUIFontStyles.bold = true;
         this.darkDisabledUIFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,DARK_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.darkDisabledUIFontStyles.bold = true;
         this.lightCenteredUIFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.CENTER,VerticalAlign.TOP);
         this.lightCenteredUIFontStyles.bold = true;
         this.lightCenteredDisabledUIFontStyles = new TextFormat(FONT_NAME,this.regularFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.CENTER,VerticalAlign.TOP);
         this.lightCenteredDisabledUIFontStyles.bold = true;
         this.largeLightUIFontStyles = new TextFormat(FONT_NAME,this.largeFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.largeLightUIFontStyles.bold = true;
         this.largeDarkUIFontStyles = new TextFormat(FONT_NAME,this.largeFontSize,DARK_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.largeDarkUIFontStyles.bold = true;
         this.largeSelectedUIFontStyles = new TextFormat(FONT_NAME,this.largeFontSize,SELECTED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.largeSelectedUIFontStyles.bold = true;
         this.largeLightUIDisabledFontStyles = new TextFormat(FONT_NAME,this.largeFontSize,LIGHT_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.largeLightUIDisabledFontStyles.bold = true;
         this.largeDarkUIDisabledFontStyles = new TextFormat(FONT_NAME,this.largeFontSize,DARK_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.largeDarkUIDisabledFontStyles.bold = true;
         this.xlargeLightUIFontStyles = new TextFormat(FONT_NAME,this.extraLargeFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.xlargeLightUIFontStyles.bold = true;
         this.xlargeLightUIDisabledFontStyles = new TextFormat(FONT_NAME,this.extraLargeFontSize,LIGHT_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.xlargeLightUIDisabledFontStyles.bold = true;
         this.lightInputFontStyles = new TextFormat(FONT_NAME_STACK,this.regularFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.lightDisabledInputFontStyles = new TextFormat(FONT_NAME_STACK,this.regularFontSize,LIGHT_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.lightScrollTextFontStyles = new TextFormat(FONT_NAME_STACK,this.regularFontSize,LIGHT_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
         this.lightDisabledScrollTextFontStyles = new TextFormat(FONT_NAME_STACK,this.regularFontSize,LIGHT_DISABLED_TEXT_COLOR,HorizontalAlign.LEFT,VerticalAlign.TOP);
      }
      
      protected function initializeTextures() : void
      {
         this.focusIndicatorSkinTexture = this.atlas.getTexture("focus-indicator-skin0000");
         this.backgroundSkinTexture = this.atlas.getTexture("background-skin0000");
         this.backgroundDisabledSkinTexture = this.atlas.getTexture("background-disabled-skin0000");
         this.backgroundInsetSkinTexture = this.atlas.getTexture("background-inset-skin0000");
         this.backgroundInsetDisabledSkinTexture = this.atlas.getTexture("background-inset-disabled-skin0000");
         this.backgroundInsetFocusedSkinTexture = this.atlas.getTexture("background-focused-skin0000");
         this.backgroundInsetDangerSkinTexture = this.atlas.getTexture("background-inset-danger-skin0000");
         this.backgroundLightBorderSkinTexture = this.atlas.getTexture("background-light-border-skin0000");
         this.backgroundDarkBorderSkinTexture = this.atlas.getTexture("background-dark-border-skin0000");
         this.backgroundDangerBorderSkinTexture = this.atlas.getTexture("background-danger-border-skin0000");
         this.buttonUpSkinTexture = this.atlas.getTexture("button-up-skin0000");
         this.buttonDownSkinTexture = this.atlas.getTexture("button-down-skin0000");
         this.buttonDisabledSkinTexture = this.atlas.getTexture("button-disabled-skin0000");
         this.buttonSelectedUpSkinTexture = this.atlas.getTexture("toggle-button-selected-up-skin0000");
         this.buttonSelectedDisabledSkinTexture = this.atlas.getTexture("toggle-button-selected-disabled-skin0000");
         this.buttonCallToActionUpSkinTexture = this.atlas.getTexture("call-to-action-button-up-skin0000");
         this.buttonCallToActionDownSkinTexture = this.atlas.getTexture("call-to-action-button-down-skin0000");
         this.buttonDangerUpSkinTexture = this.atlas.getTexture("danger-button-up-skin0000");
         this.buttonDangerDownSkinTexture = this.atlas.getTexture("danger-button-down-skin0000");
         this.buttonBackUpSkinTexture = this.atlas.getTexture("back-button-up-skin0000");
         this.buttonBackDownSkinTexture = this.atlas.getTexture("back-button-down-skin0000");
         this.buttonBackDisabledSkinTexture = this.atlas.getTexture("back-button-disabled-skin0000");
         this.buttonForwardUpSkinTexture = this.atlas.getTexture("forward-button-up-skin0000");
         this.buttonForwardDownSkinTexture = this.atlas.getTexture("forward-button-down-skin0000");
         this.buttonForwardDisabledSkinTexture = this.atlas.getTexture("forward-button-disabled-skin0000");
         this.tabUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-up-skin0000"),TAB_SKIN_TEXTURE_REGION);
         this.tabDownSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-down-skin0000"),TAB_SKIN_TEXTURE_REGION);
         this.tabDisabledSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-disabled-skin0000"),TAB_SKIN_TEXTURE_REGION);
         this.tabSelectedUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-selected-up-skin0000"),TAB_SKIN_TEXTURE_REGION);
         this.tabSelectedDisabledSkinTexture = Texture.fromTexture(this.atlas.getTexture("tab-selected-disabled-skin0000"),TAB_SKIN_TEXTURE_REGION);
         this.pickerListButtonIconTexture = this.atlas.getTexture("picker-list-button-icon0000");
         this.pickerListButtonSelectedIconTexture = this.atlas.getTexture("picker-list-button-selected-icon0000");
         this.pickerListButtonIconDisabledTexture = this.atlas.getTexture("picker-list-button-disabled-icon0000");
         this.pickerListItemSelectedIconTexture = this.atlas.getTexture("picker-list-item-renderer-selected-icon0000");
         this.spinnerListSelectionOverlaySkinTexture = this.atlas.getTexture("spinner-list-selection-overlay-skin0000");
         this.checkUpIconTexture = this.atlas.getTexture("check-up-icon0000");
         this.checkDownIconTexture = this.atlas.getTexture("check-down-icon0000");
         this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon0000");
         this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
         this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon0000");
         this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");
         this.radioUpIconTexture = this.checkUpIconTexture;
         this.radioDownIconTexture = this.checkDownIconTexture;
         this.radioDisabledIconTexture = this.checkDisabledIconTexture;
         this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
         this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon0000");
         this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");
         this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-symbol0000");
         this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-symbol0000");
         this.searchIconTexture = this.atlas.getTexture("search-icon0000");
         this.searchIconDisabledTexture = this.atlas.getTexture("search-disabled-icon0000");
         this.itemRendererUpSkinTexture = this.atlas.getTexture("item-renderer-up-skin0000");
         this.itemRendererSelectedSkinTexture = this.atlas.getTexture("item-renderer-selected-up-skin0000");
         this.insetItemRendererUpSkinTexture = this.atlas.getTexture("inset-item-renderer-up-skin0000");
         this.insetItemRendererSelectedSkinTexture = this.atlas.getTexture("inset-item-renderer-selected-up-skin0000");
         this.insetItemRendererFirstUpSkinTexture = this.atlas.getTexture("first-inset-item-renderer-up-skin0000");
         this.insetItemRendererFirstSelectedSkinTexture = this.atlas.getTexture("first-inset-item-renderer-selected-up-skin0000");
         this.insetItemRendererLastUpSkinTexture = this.atlas.getTexture("last-inset-item-renderer-up-skin0000");
         this.insetItemRendererLastSelectedSkinTexture = this.atlas.getTexture("last-inset-item-renderer-selected-up-skin0000");
         this.insetItemRendererSingleUpSkinTexture = this.atlas.getTexture("single-inset-item-renderer-up-skin0000");
         this.insetItemRendererSingleSelectedSkinTexture = this.atlas.getTexture("single-inset-item-renderer-selected-up-skin0000");
         this.dragHandleIcon = this.atlas.getTexture("drag-handle-icon0000");
         var _loc1_:Texture = this.atlas.getTexture("header-background-skin0000");
         var _loc2_:Texture = this.atlas.getTexture("header-popup-background-skin0000");
         this.headerBackgroundSkinTexture = Texture.fromTexture(_loc1_,HEADER_SKIN_TEXTURE_REGION);
         this.popUpHeaderBackgroundSkinTexture = Texture.fromTexture(_loc2_,HEADER_SKIN_TEXTURE_REGION);
         this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top-skin0000");
         this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right-skin0000");
         this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom-skin0000");
         this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left-skin0000");
         this.dangerCalloutTopArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-top-skin0000");
         this.dangerCalloutRightArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-right-skin0000");
         this.dangerCalloutBottomArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-bottom-skin0000");
         this.dangerCalloutLeftArrowSkinTexture = this.atlas.getTexture("danger-callout-arrow-left-skin0000");
         this.horizontalScrollBarThumbSkinTexture = this.atlas.getTexture("horizontal-simple-scroll-bar-thumb-skin0000");
         this.verticalScrollBarThumbSkinTexture = this.atlas.getTexture("vertical-simple-scroll-bar-thumb-skin0000");
         this.listDrillDownAccessoryTexture = this.atlas.getTexture("item-renderer-drill-down-accessory-icon0000");
         this.listDrillDownAccessorySelectedTexture = this.atlas.getTexture("item-renderer-drill-down-accessory-selected-icon0000");
         this.treeDisclosureOpenIconTexture = this.atlas.getTexture("tree-disclosure-open-icon0000");
         this.treeDisclosureOpenSelectedIconTexture = this.atlas.getTexture("tree-disclosure-open-selected-icon0000");
         this.treeDisclosureClosedIconTexture = this.atlas.getTexture("tree-disclosure-closed-icon0000");
         this.treeDisclosureClosedSelectedIconTexture = this.atlas.getTexture("tree-disclosure-closed-selected-icon0000");
         this.dataGridHeaderSortAscendingIconTexture = this.atlas.getTexture("data-grid-header-sort-ascending-icon0000");
         this.dataGridHeaderSortDescendingIconTexture = this.atlas.getTexture("data-grid-header-sort-descending-icon0000");
         this.dataGridHeaderDividerSkinTexture = this.atlas.getTexture("data-grid-header-divider-skin0000");
         this.dataGridVerticalDividerSkinTexture = this.atlas.getTexture("data-grid-vertical-divider-skin0000");
         this.dataGridColumnResizeSkinTexture = this.atlas.getTexture("data-grid-column-resize-skin0000");
         this.dataGridColumnDropIndicatorSkinTexture = this.atlas.getTexture("data-grid-column-drop-indicator-skin0000");
         this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon0000");
         this.playPauseButtonPlayDownIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-down-icon0000");
         this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon0000");
         this.playPauseButtonPauseDownIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-down-icon0000");
         this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon0000");
         this.overlayPlayPauseButtonPlayDownIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-down-icon0000");
         this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon0000");
         this.fullScreenToggleButtonEnterDownIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-down-icon0000");
         this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon0000");
         this.fullScreenToggleButtonExitDownIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-down-icon0000");
         this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon0000");
         this.muteToggleButtonMutedDownIconTexture = this.atlas.getTexture("mute-toggle-button-muted-down-icon0000");
         this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon0000");
         this.muteToggleButtonLoudDownIconTexture = this.atlas.getTexture("mute-toggle-button-loud-down-icon0000");
         this.volumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("volume-slider-minimum-track-skin0000");
         this.volumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("volume-slider-maximum-track-skin0000");
         this.seekSliderProgressSkinTexture = this.atlas.getTexture("seek-slider-progress-skin0000");
      }
      
      protected function initializeStyleProviders() : void
      {
         this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
         this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP,this.setAlertButtonGroupStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON,this.setAlertButtonGroupButtonStyles);
         this.getStyleProviderForClass(Header).setFunctionForStyleName(Alert.DEFAULT_CHILD_STYLE_NAME_HEADER,this.setPopUpHeaderStyles);
         this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
         this.getStyleProviderForClass(List).setFunctionForStyleName(AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST,this.setDropDownListStyles);
         this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON,this.setCallToActionButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON,this.setQuietButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON,this.setDangerButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON,this.setBackButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON,this.setForwardButtonStyles);
         this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON,this.setButtonGroupButtonStyles);
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON,this.setButtonGroupButtonStyles);
         this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;
         this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;
         this.getStyleProviderForClass(DataGrid).defaultStyleFunction = this.setDataGridStyles;
         this.getStyleProviderForClass(DefaultDataGridCellRenderer).defaultStyleFunction = this.setDataGridCellRendererStyles;
         this.getStyleProviderForClass(DefaultDataGridHeaderRenderer).defaultStyleFunction = this.setDataGridHeaderStyles;
         this.getStyleProviderForClass(DateTimeSpinner).defaultStyleFunction = this.setDateTimeSpinnerStyles;
         this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER,this.setDateTimeSpinnerListItemRendererStyles);
         this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;
         this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
         this.getStyleProviderForClass(GroupedList).setFunctionForStyleName(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST,this.setInsetGroupedListStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER,this.setInsetGroupedListMiddleItemRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER,this.setInsetGroupedListFirstItemRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER,this.setInsetGroupedListLastItemRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER,this.setInsetGroupedListSingleItemRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN,this.setDrillDownItemRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName(DefaultGroupedListItemRenderer.ALTERNATE_STYLE_NAME_CHECK,this.setCheckItemRendererStyles);
         this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
         this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderRendererStyles;
         this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER,this.setGroupedListFooterRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER,this.setInsetGroupedListHeaderRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName(GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER,this.setInsetGroupedListFooterRendererStyles);
         this.getStyleProviderForClass(Label).defaultStyleFunction = this.setLabelStyles;
         this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_HEADING,this.setHeadingLabelStyles);
         this.getStyleProviderForClass(Label).setFunctionForStyleName(Label.ALTERNATE_STYLE_NAME_DETAIL,this.setDetailLabelStyles);
         this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR,this.setToolbarLayoutGroupStyles);
         this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
         this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setListItemRendererStyles;
         this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN,this.setDrillDownItemRendererStyles);
         this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_CHECK,this.setCheckItemRendererStyles);
         this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
         this.getStyleProviderForClass(TextInput).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_TEXT_INPUT,this.setNumericStepperTextInputStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON,this.setNumericStepperButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(NumericStepper.DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON,this.setNumericStepperButtonStyles);
         this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;
         this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
         this.getStyleProviderForClass(Header).setFunctionForStyleName(Panel.DEFAULT_CHILD_STYLE_NAME_HEADER,this.setPopUpHeaderStyles);
         this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
         this.getStyleProviderForClass(Header).setFunctionForStyleName(PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER,this.setPanelScreenHeaderStyles);
         this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
         this.getStyleProviderForClass(List).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_LIST,this.setPickerListPopUpListStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON,this.setPickerListButtonStyles);
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON,this.setPickerListButtonStyles);
         this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER,this.setPickerListItemRendererStyles);
         this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;
         this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;
         this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
         this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName(ScrollContainer.ALTERNATE_STYLE_NAME_TOOLBAR,this.setToolbarScrollContainerStyles);
         this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;
         this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;
         this.getStyleProviderForClass(SimpleScrollBar).defaultStyleFunction = this.setSimpleScrollBarStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB,this.setHorizontalSimpleScrollBarThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB,this.setVerticalSimpleScrollBarThumbStyles);
         this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_STYLE_NAME_THUMB,this.setSimpleButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK,this.setHorizontalSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK,this.setHorizontalSliderMaximumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK,this.setVerticalSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK,this.setVerticalSliderMaximumTrackStyles);
         this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;
         this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName(THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER,this.setSpinnerListItemRendererStyles);
         this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(TabBar.DEFAULT_CHILD_STYLE_NAME_TAB,this.setTabStyles);
         this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
         this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT,this.setSearchTextInputStyles);
         this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextInput.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT,this.setTextInputErrorCalloutStyles);
         this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;
         this.getStyleProviderForClass(TextCallout).setFunctionForStyleName(TextArea.DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT,this.setTextAreaErrorCalloutStyles);
         this.getStyleProviderForClass(TextCallout).defaultStyleFunction = this.setTextCalloutStyles;
         this.getStyleProviderForClass(Toast).defaultStyleFunction = this.setToastStyles;
         this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName(Toast.DEFAULT_CHILD_STYLE_NAME_ACTIONS,this.setToastActionsStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_STYLE_NAME_TOAST_ACTIONS_BUTTON,this.setToastActionsButtonStyles);
         this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON,this.setQuietButtonStyles);
         this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB,this.setSimpleButtonStyles);
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB,this.setSimpleButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK,this.setToggleSwitchTrackStyles);
         this.getStyleProviderForClass(Tree).defaultStyleFunction = this.setTreeStyles;
         this.getStyleProviderForClass(DefaultTreeItemRenderer).defaultStyleFunction = this.setTreeItemRendererStyles;
         this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
         this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName(PlayPauseToggleButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON,this.setOverlayPlayPauseToggleButtonStyles);
         this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;
         this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;
         this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB,this.setSeekSliderThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK,this.setSeekSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(SeekSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK,this.setSeekSliderMaximumTrackStyles);
         this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB,this.setVolumeSliderThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK,this.setVolumeSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName(VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK,this.setVolumeSliderMaximumTrackStyles);
      }
      
      protected function pageIndicatorNormalSymbolFactory() : DisplayObject
      {
         var _loc1_:ImageLoader = new ImageLoader();
         _loc1_.source = this.pageIndicatorNormalSkinTexture;
         return _loc1_;
      }
      
      protected function pageIndicatorSelectedSymbolFactory() : DisplayObject
      {
         var _loc1_:ImageLoader = new ImageLoader();
         _loc1_.source = this.pageIndicatorSelectedSkinTexture;
         return _loc1_;
      }
      
      protected function dataGridHeaderDividerFactory() : DisplayObject
      {
         var _loc1_:ImageSkin = new ImageSkin(this.dataGridHeaderDividerSkinTexture);
         _loc1_.scale9Grid = DATA_GRID_HEADER_DIVIDER_SCALE_9_GRID;
         _loc1_.minTouchWidth = this.controlSize;
         return _loc1_;
      }
      
      protected function dataGridVerticalDividerFactory() : DisplayObject
      {
         var _loc1_:ImageSkin = new ImageSkin(this.dataGridVerticalDividerSkinTexture);
         _loc1_.scale9Grid = DATA_GRID_VERTICAL_DIVIDER_SCALE_9_GRID;
         return _loc1_;
      }
      
      protected function toastContainerFactory() : DisplayObjectContainer
      {
         var _loc1_:LayoutGroup = new LayoutGroup();
         _loc1_.autoSizeMode = AutoSizeMode.STAGE;
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.verticalAlign = VerticalAlign.BOTTOM;
         if(DeviceCapabilities.isPhone())
         {
            _loc2_.horizontalAlign = HorizontalAlign.JUSTIFY;
            _loc2_.padding = this.smallGutterSize;
            _loc2_.gap = this.smallGutterSize;
         }
         else
         {
            _loc2_.horizontalAlign = HorizontalAlign.LEFT;
            _loc2_.padding = this.gutterSize;
            _loc2_.gap = this.gutterSize;
         }
         _loc1_.layout = _loc2_;
         return _loc1_;
      }
      
      protected function setScrollerStyles(param1:Scroller) : void
      {
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = 0;
         param1.horizontalScrollBarFactory = scrollBarFactory;
         param1.verticalScrollBarFactory = scrollBarFactory;
      }
      
      protected function setSimpleButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.buttonDownSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED,this.buttonDisabledSkinTexture);
         _loc2_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setDropDownListStyles(param1:List) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
         _loc2_.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.backgroundSkin = _loc2_;
         var _loc3_:VerticalLayout = new VerticalLayout();
         _loc3_.horizontalAlign = HorizontalAlign.JUSTIFY;
         _loc3_.maxRowCount = 4;
         param1.layout = _loc3_;
      }
      
      protected function setAlertStyles(param1:Alert) : void
      {
         this.setScrollerStyles(param1);
         var _loc2_:Image = new Image(this.backgroundLightBorderSkinTexture);
         _loc2_.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.fontStyles = this.lightFontStyles.clone();
         param1.paddingTop = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.outerPadding = this.borderSize;
         param1.gap = this.smallGutterSize;
         param1.maxWidth = this.popUpFillSize;
         param1.maxHeight = this.popUpFillSize;
      }
      
      protected function setAlertButtonGroupStyles(param1:ButtonGroup) : void
      {
         param1.direction = Direction.HORIZONTAL;
         param1.horizontalAlign = HorizontalAlign.CENTER;
         param1.verticalAlign = VerticalAlign.JUSTIFY;
         param1.distributeButtonSizes = false;
         param1.gap = this.smallGutterSize;
         param1.padding = this.smallGutterSize;
         param1.customButtonStyleName = THEME_STYLE_NAME_ALERT_BUTTON_GROUP_BUTTON;
      }
      
      protected function setAlertButtonGroupButtonStyles(param1:Button) : void
      {
         this.setButtonStyles(param1);
         var _loc2_:ImageSkin = ImageSkin(param1.defaultSkin);
         _loc2_.minWidth = 2 * this.controlSize;
      }
      
      protected function setBaseButtonStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = this.focusPaddingSize;
         param1.paddingTop = this.smallControlGutterSize;
         param1.paddingBottom = this.smallControlGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = this.smallControlGutterSize;
         param1.minGap = this.smallControlGutterSize;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.buttonDownSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED,this.buttonDisabledSkinTexture);
         if(param1 is ToggleButton)
         {
            _loc2_.selectedTexture = this.buttonSelectedUpSkinTexture;
            _loc2_.setTextureForState(ButtonState.DISABLED_AND_SELECTED,this.buttonSelectedDisabledSkinTexture);
         }
         _loc2_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.defaultSkin = _loc2_;
         var _loc3_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc3_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc3_;
         param1.focusPadding = this.focusPaddingSize;
         param1.fontStyles = this.darkUIFontStyles.clone();
         param1.disabledFontStyles = this.darkDisabledUIFontStyles.clone();
         this.setBaseButtonStyles(param1);
      }
      
      protected function setCallToActionButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.buttonCallToActionUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.buttonCallToActionDownSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED,this.buttonDisabledSkinTexture);
         _loc2_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.defaultSkin = _loc2_;
         param1.fontStyles = this.darkUIFontStyles.clone();
         param1.disabledFontStyles = this.darkDisabledUIFontStyles.clone();
         this.setBaseButtonStyles(param1);
      }
      
      protected function setQuietButtonStyles(param1:Button) : void
      {
         var _loc5_:ToggleButton = null;
         var _loc2_:Quad = new Quad(this.controlSize,this.controlSize,16711935);
         _loc2_.alpha = 0;
         param1.defaultSkin = _loc2_;
         var _loc3_:ImageSkin = new ImageSkin(null);
         _loc3_.setTextureForState(ButtonState.DOWN,this.buttonDownSkinTexture);
         _loc3_.setTextureForState(ButtonState.DISABLED,this.buttonDisabledSkinTexture);
         param1.downSkin = _loc3_;
         param1.disabledSkin = _loc3_;
         if(param1 is ToggleButton)
         {
            _loc5_ = ToggleButton(param1);
            _loc3_.selectedTexture = this.buttonSelectedUpSkinTexture;
            _loc5_.defaultSelectedSkin = _loc3_;
         }
         _loc3_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc3_.width = this.controlSize;
         _loc3_.height = this.controlSize;
         _loc3_.minWidth = this.controlSize;
         _loc3_.minHeight = this.controlSize;
         param1.fontStyles = this.lightUIFontStyles.clone();
         param1.setFontStylesForState(ButtonState.DOWN,this.darkUIFontStyles.clone());
         param1.setFontStylesForState(ButtonState.DISABLED,this.lightDisabledUIFontStyles.clone());
         if(param1 is ToggleButton)
         {
            _loc5_.selectedFontStyles = this.darkUIFontStyles.clone();
            _loc5_.setFontStylesForState(ButtonState.DISABLED_AND_SELECTED,this.darkDisabledUIFontStyles.clone());
         }
         param1.paddingTop = this.smallControlGutterSize;
         param1.paddingBottom = this.smallControlGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.gap = this.smallControlGutterSize;
         param1.minGap = this.smallControlGutterSize;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
         var _loc4_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc4_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc4_;
         param1.focusPadding = this.focusPaddingSize;
      }
      
      protected function setDangerButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.buttonDangerUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.buttonDangerDownSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED,this.buttonDisabledSkinTexture);
         _loc2_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.defaultSkin = _loc2_;
         param1.fontStyles = this.darkUIFontStyles.clone();
         param1.disabledFontStyles = this.darkDisabledUIFontStyles.clone();
         this.setBaseButtonStyles(param1);
      }
      
      protected function setBackButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.buttonBackUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.buttonBackDownSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED,this.buttonBackDisabledSkinTexture);
         _loc2_.scale9Grid = BACK_BUTTON_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.defaultSkin = _loc2_;
         param1.fontStyles = this.darkUIFontStyles.clone();
         param1.disabledFontStyles = this.darkDisabledUIFontStyles.clone();
         this.setBaseButtonStyles(param1);
         param1.paddingLeft = this.gutterSize + this.smallGutterSize;
      }
      
      protected function setForwardButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.buttonForwardUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.buttonForwardDownSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED,this.buttonForwardDisabledSkinTexture);
         _loc2_.scale9Grid = FORWARD_BUTTON_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.defaultSkin = _loc2_;
         param1.fontStyles = this.darkUIFontStyles.clone();
         param1.disabledFontStyles = this.darkDisabledUIFontStyles.clone();
         this.setBaseButtonStyles(param1);
         param1.paddingRight = this.gutterSize + this.smallGutterSize;
      }
      
      protected function setButtonGroupStyles(param1:ButtonGroup) : void
      {
         param1.gap = this.smallGutterSize;
      }
      
      protected function setButtonGroupButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.buttonDownSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED,this.buttonDisabledSkinTexture);
         if(param1 is ToggleButton)
         {
            _loc2_.selectedTexture = this.buttonSelectedUpSkinTexture;
            _loc2_.setTextureForState(ButtonState.DISABLED_AND_SELECTED,this.buttonSelectedDisabledSkinTexture);
         }
         _loc2_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc2_.width = this.popUpFillSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.defaultSkin = _loc2_;
         var _loc3_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc3_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc3_;
         param1.focusPadding = this.focusPaddingSize;
         param1.fontStyles = this.largeDarkUIFontStyles.clone();
         param1.disabledFontStyles = this.largeDarkUIDisabledFontStyles.clone();
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = this.smallGutterSize;
         param1.minGap = this.smallGutterSize;
         param1.horizontalAlign = HorizontalAlign.CENTER;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setCalloutStyles(param1:Callout) : void
      {
         var _loc2_:Image = new Image(this.backgroundLightBorderSkinTexture);
         _loc2_.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.calloutBackgroundMinSize;
         _loc2_.height = this.calloutBackgroundMinSize;
         param1.backgroundSkin = _loc2_;
         var _loc3_:Image = new Image(this.calloutTopArrowSkinTexture);
         param1.topArrowSkin = _loc3_;
         param1.topArrowGap = this.calloutArrowOverlapGap;
         var _loc4_:Image = new Image(this.calloutRightArrowSkinTexture);
         param1.rightArrowSkin = _loc4_;
         param1.rightArrowGap = this.calloutArrowOverlapGap;
         var _loc5_:Image = new Image(this.calloutBottomArrowSkinTexture);
         param1.bottomArrowSkin = _loc5_;
         param1.bottomArrowGap = this.calloutArrowOverlapGap;
         var _loc6_:Image = new Image(this.calloutLeftArrowSkinTexture);
         param1.leftArrowSkin = _loc6_;
         param1.leftArrowGap = this.calloutArrowOverlapGap;
         param1.padding = this.smallGutterSize;
      }
      
      protected function setDangerCalloutStyles(param1:Callout) : void
      {
         var _loc2_:Image = new Image(this.backgroundDangerBorderSkinTexture);
         _loc2_.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.calloutBackgroundMinSize;
         _loc2_.height = this.calloutBackgroundMinSize;
         param1.backgroundSkin = _loc2_;
         var _loc3_:Image = new Image(this.dangerCalloutTopArrowSkinTexture);
         param1.topArrowSkin = _loc3_;
         param1.topArrowGap = this.calloutArrowOverlapGap;
         var _loc4_:Image = new Image(this.dangerCalloutRightArrowSkinTexture);
         param1.rightArrowSkin = _loc4_;
         param1.rightArrowGap = this.calloutArrowOverlapGap;
         var _loc5_:Image = new Image(this.dangerCalloutBottomArrowSkinTexture);
         param1.bottomArrowSkin = _loc5_;
         param1.bottomArrowGap = this.calloutArrowOverlapGap;
         var _loc6_:Image = new Image(this.dangerCalloutLeftArrowSkinTexture);
         param1.leftArrowSkin = _loc6_;
         param1.leftArrowGap = this.calloutArrowOverlapGap;
         param1.padding = this.smallGutterSize;
      }
      
      protected function setCheckStyles(param1:Check) : void
      {
         var _loc2_:Quad = new Quad(this.controlSize,this.controlSize);
         _loc2_.alpha = 0;
         param1.defaultSkin = _loc2_;
         var _loc3_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc3_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc3_;
         param1.focusPadding = this.focusPaddingSize;
         var _loc4_:ImageSkin = new ImageSkin(this.checkUpIconTexture);
         _loc4_.selectedTexture = this.checkSelectedUpIconTexture;
         _loc4_.setTextureForState(ButtonState.DOWN,this.checkDownIconTexture);
         _loc4_.setTextureForState(ButtonState.DISABLED,this.checkDisabledIconTexture);
         _loc4_.setTextureForState(ButtonState.DOWN_AND_SELECTED,this.checkSelectedDownIconTexture);
         _loc4_.setTextureForState(ButtonState.DISABLED_AND_SELECTED,this.checkSelectedDisabledIconTexture);
         param1.defaultIcon = _loc4_;
         param1.fontStyles = this.lightUIFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledUIFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.gap = this.smallControlGutterSize;
         param1.minGap = this.smallControlGutterSize;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setDataGridStyles(param1:DataGrid) : void
      {
         this.setScrollerStyles(param1);
         var _loc2_:Quad = new Quad(this.gridSize,this.gridSize,LIST_BACKGROUND_COLOR);
         param1.backgroundSkin = _loc2_;
         var _loc3_:ImageSkin = new ImageSkin(this.dataGridColumnResizeSkinTexture);
         _loc3_.scale9Grid = DATA_GRID_COLUMN_RESIZE_SCALE_9_GRID;
         param1.columnResizeSkin = _loc3_;
         var _loc4_:ImageSkin = new ImageSkin(this.dataGridColumnDropIndicatorSkinTexture);
         _loc4_.scale9Grid = DATA_GRID_COLUMN_DROP_INDICATOR_SCALE_9_GRID;
         param1.columnDropIndicatorSkin = _loc4_;
         param1.extendedColumnDropIndicator = true;
         var _loc5_:Quad = new Quad(1,1,DATA_GRID_COLUMN_OVERLAY_COLOR);
         _loc5_.alpha = DATA_GRID_COLUMN_OVERLAY_ALPHA;
         param1.columnDragOverlaySkin = _loc5_;
         param1.headerDividerFactory = this.dataGridHeaderDividerFactory;
         param1.verticalDividerFactory = this.dataGridVerticalDividerFactory;
      }
      
      protected function setDataGridHeaderStyles(param1:DefaultDataGridHeaderRenderer) : void
      {
         param1.backgroundSkin = new Quad(1,1,GROUPED_LIST_HEADER_BACKGROUND_COLOR);
         param1.sortAscendingIcon = new ImageSkin(this.dataGridHeaderSortAscendingIconTexture);
         param1.sortDescendingIcon = new ImageSkin(this.dataGridHeaderSortDescendingIconTexture);
         param1.fontStyles = this.lightUIFontStyles;
         param1.disabledFontStyles = this.lightDisabledUIFontStyles;
         param1.padding = this.smallGutterSize;
      }
      
      protected function setDataGridCellRendererStyles(param1:DefaultDataGridCellRenderer) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
         _loc2_.selectedTexture = this.itemRendererSelectedSkinTexture;
         _loc2_.setTextureForState(ButtonState.DOWN,this.itemRendererSelectedSkinTexture);
         _loc2_.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.defaultSkin = _loc2_;
         param1.fontStyles = this.largeLightFontStyles.clone();
         param1.disabledFontStyles = this.largeLightDisabledFontStyles.clone();
         param1.selectedFontStyles = this.largeDarkFontStyles.clone();
         param1.setFontStylesForState(ButtonState.DOWN,this.largeDarkFontStyles.clone());
         param1.iconLabelFontStyles = this.lightFontStyles.clone();
         param1.iconLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.iconLabelSelectedFontStyles = this.darkFontStyles.clone();
         param1.setIconLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.accessoryLabelFontStyles = this.lightFontStyles.clone();
         param1.accessoryLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.accessoryLabelSelectedFontStyles = this.darkFontStyles.clone();
         param1.setAccessoryLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = this.gutterSize;
         param1.minGap = this.gutterSize;
         param1.iconPosition = RelativePosition.LEFT;
         param1.accessoryGap = Number.POSITIVE_INFINITY;
         param1.minAccessoryGap = this.gutterSize;
         param1.accessoryPosition = RelativePosition.RIGHT;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setDateTimeSpinnerStyles(param1:DateTimeSpinner) : void
      {
         param1.customItemRendererStyleName = THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER;
      }
      
      protected function setDateTimeSpinnerListItemRendererStyles(param1:DefaultListItemRenderer) : void
      {
         this.setSpinnerListItemRendererStyles(param1);
         param1.accessoryPosition = RelativePosition.LEFT;
         param1.gap = this.smallGutterSize;
         param1.minGap = this.smallGutterSize;
         param1.accessoryGap = this.smallGutterSize;
         param1.minAccessoryGap = this.smallGutterSize;
      }
      
      protected function setDrawersStyles(param1:Drawers) : void
      {
         var _loc2_:Quad = new Quad(10,10,DRAWER_OVERLAY_COLOR);
         _loc2_.alpha = DRAWER_OVERLAY_ALPHA;
         param1.overlaySkin = _loc2_;
         var _loc3_:Quad = new Quad(this.borderSize,this.borderSize,DRAWER_OVERLAY_COLOR);
         param1.topDrawerDivider = _loc3_;
         var _loc4_:Quad = new Quad(this.borderSize,this.borderSize,DRAWER_OVERLAY_COLOR);
         param1.rightDrawerDivider = _loc4_;
         var _loc5_:Quad = new Quad(this.borderSize,this.borderSize,DRAWER_OVERLAY_COLOR);
         param1.bottomDrawerDivider = _loc5_;
         var _loc6_:Quad = new Quad(this.borderSize,this.borderSize,DRAWER_OVERLAY_COLOR);
         param1.leftDrawerDivider = _loc6_;
      }
      
      protected function setGroupedListStyles(param1:GroupedList) : void
      {
         this.setScrollerStyles(param1);
         var _loc2_:Quad = new Quad(this.gridSize,this.gridSize,LIST_BACKGROUND_COLOR);
         param1.backgroundSkin = _loc2_;
      }
      
      protected function setGroupedListHeaderRendererStyles(param1:DefaultGroupedListHeaderOrFooterRenderer) : void
      {
         param1.backgroundSkin = new Quad(1,1,GROUPED_LIST_HEADER_BACKGROUND_COLOR);
         param1.fontStyles = this.lightUIFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledUIFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.smallGutterSize + this.gutterSize;
         param1.paddingRight = this.gutterSize;
      }
      
      protected function setGroupedListFooterRendererStyles(param1:DefaultGroupedListHeaderOrFooterRenderer) : void
      {
         param1.backgroundSkin = new Quad(1,1,GROUPED_LIST_FOOTER_BACKGROUND_COLOR);
         param1.fontStyles = this.lightFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.CENTER;
         param1.paddingTop = param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.smallGutterSize + this.gutterSize;
         param1.paddingRight = this.gutterSize;
      }
      
      protected function setInsetGroupedListStyles(param1:GroupedList) : void
      {
         param1.customItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER;
         param1.customFirstItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER;
         param1.customLastItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER;
         param1.customSingleItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER;
         param1.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;
         param1.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.useVirtualLayout = true;
         _loc2_.padding = this.smallGutterSize;
         _loc2_.gap = 0;
         _loc2_.horizontalAlign = HorizontalAlign.JUSTIFY;
         _loc2_.verticalAlign = VerticalAlign.TOP;
         param1.layout = _loc2_;
      }
      
      protected function setInsetGroupedListItemRendererStyles(param1:DefaultGroupedListItemRenderer, param2:Texture, param3:Texture, param4:Rectangle) : void
      {
         var _loc5_:ImageSkin = new ImageSkin(param2);
         _loc5_.selectedTexture = param3;
         _loc5_.setTextureForState(ButtonState.DOWN,param3);
         _loc5_.scale9Grid = param4;
         _loc5_.width = this.gridSize;
         _loc5_.height = this.gridSize;
         _loc5_.minWidth = this.gridSize;
         _loc5_.minHeight = this.gridSize;
         param1.defaultSkin = _loc5_;
         param1.fontStyles = this.largeLightFontStyles.clone();
         param1.disabledFontStyles = this.largeLightDisabledFontStyles.clone();
         param1.selectedFontStyles = this.largeDarkFontStyles.clone();
         param1.setFontStylesForState(ButtonState.DOWN,this.largeDarkFontStyles.clone());
         param1.iconLabelFontStyles = this.lightFontStyles.clone();
         param1.iconLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.iconLabelSelectedFontStyles = this.darkFontStyles.clone();
         param1.setIconLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.accessoryLabelFontStyles = this.lightFontStyles.clone();
         param1.accessoryLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.accessoryLabelSelectedFontStyles = this.darkFontStyles.clone();
         param1.setAccessoryLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize + this.smallGutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = this.gutterSize;
         param1.minGap = this.gutterSize;
         param1.iconPosition = RelativePosition.LEFT;
         param1.accessoryGap = Number.POSITIVE_INFINITY;
         param1.minAccessoryGap = this.gutterSize;
         param1.accessoryPosition = RelativePosition.RIGHT;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setInsetGroupedListMiddleItemRendererStyles(param1:DefaultGroupedListItemRenderer) : void
      {
         this.setInsetGroupedListItemRendererStyles(param1,this.insetItemRendererUpSkinTexture,this.insetItemRendererSelectedSkinTexture,INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID);
      }
      
      protected function setInsetGroupedListFirstItemRendererStyles(param1:DefaultGroupedListItemRenderer) : void
      {
         this.setInsetGroupedListItemRendererStyles(param1,this.insetItemRendererFirstUpSkinTexture,this.insetItemRendererFirstSelectedSkinTexture,INSET_ITEM_RENDERER_FIRST_SCALE9_GRID);
      }
      
      protected function setInsetGroupedListLastItemRendererStyles(param1:DefaultGroupedListItemRenderer) : void
      {
         this.setInsetGroupedListItemRendererStyles(param1,this.insetItemRendererLastUpSkinTexture,this.insetItemRendererLastSelectedSkinTexture,INSET_ITEM_RENDERER_LAST_SCALE9_GRID);
      }
      
      protected function setInsetGroupedListSingleItemRendererStyles(param1:DefaultGroupedListItemRenderer) : void
      {
         this.setInsetGroupedListItemRendererStyles(param1,this.insetItemRendererSingleUpSkinTexture,this.insetItemRendererSingleSelectedSkinTexture,INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID);
      }
      
      protected function setInsetGroupedListHeaderRendererStyles(param1:DefaultGroupedListHeaderOrFooterRenderer) : void
      {
         var _loc2_:Quad = new Quad(this.controlSize,this.controlSize,16711935);
         _loc2_.alpha = 0;
         param1.backgroundSkin = _loc2_;
         param1.fontStyles = this.lightUIFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledUIFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize + this.smallGutterSize;
         param1.paddingRight = this.gutterSize;
      }
      
      protected function setInsetGroupedListFooterRendererStyles(param1:DefaultGroupedListHeaderOrFooterRenderer) : void
      {
         var _loc2_:Quad = new Quad(this.controlSize,this.controlSize,16711935);
         _loc2_.alpha = 0;
         param1.backgroundSkin = _loc2_;
         param1.fontStyles = this.lightFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.CENTER;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize + this.smallGutterSize;
         param1.paddingRight = this.gutterSize;
      }
      
      protected function setHeaderStyles(param1:Header) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.headerBackgroundSkinTexture);
         _loc2_.tileGrid = new Rectangle();
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.backgroundSkin = _loc2_;
         param1.fontStyles = this.xlargeLightUIFontStyles.clone();
         param1.disabledFontStyles = this.xlargeLightUIDisabledFontStyles.clone();
         param1.padding = this.smallGutterSize;
         param1.gap = this.smallGutterSize;
         param1.titleGap = this.smallGutterSize;
      }
      
      protected function setLabelStyles(param1:Label) : void
      {
         param1.fontStyles = this.lightFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledFontStyles.clone();
      }
      
      protected function setHeadingLabelStyles(param1:Label) : void
      {
         param1.fontStyles = this.largeLightFontStyles.clone();
         param1.disabledFontStyles = this.largeLightDisabledFontStyles.clone();
      }
      
      protected function setDetailLabelStyles(param1:Label) : void
      {
         param1.fontStyles = this.smallLightFontStyles.clone();
         param1.disabledFontStyles = this.smallLightDisabledFontStyles.clone();
      }
      
      protected function setToolbarLayoutGroupStyles(param1:LayoutGroup) : void
      {
         var _loc3_:HorizontalLayout = null;
         if(!param1.layout)
         {
            _loc3_ = new HorizontalLayout();
            _loc3_.padding = this.smallGutterSize;
            _loc3_.gap = this.smallGutterSize;
            _loc3_.verticalAlign = VerticalAlign.MIDDLE;
            param1.layout = _loc3_;
         }
         var _loc2_:ImageSkin = new ImageSkin(this.headerBackgroundSkinTexture);
         _loc2_.tileGrid = new Rectangle();
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.backgroundSkin = _loc2_;
      }
      
      protected function setListStyles(param1:List) : void
      {
         this.setScrollerStyles(param1);
         var _loc2_:Quad = new Quad(this.gridSize,this.gridSize,LIST_BACKGROUND_COLOR);
         param1.backgroundSkin = _loc2_;
         var _loc3_:Quad = new Quad(this.borderSize,this.borderSize,LIGHT_TEXT_COLOR);
         param1.dropIndicatorSkin = _loc3_;
      }
      
      protected function setListItemRendererStyles(param1:DefaultListItemRenderer) : void
      {
         this.setItemRendererStyles(param1);
         var _loc2_:ImageSkin = new ImageSkin(this.dragHandleIcon);
         _loc2_.minTouchWidth = this.gridSize;
         _loc2_.minTouchHeight = this.gridSize;
         param1.dragIcon = _loc2_;
      }
      
      protected function setItemRendererStyles(param1:BaseDefaultItemRenderer) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
         _loc2_.selectedTexture = this.itemRendererSelectedSkinTexture;
         _loc2_.setTextureForState(ButtonState.DOWN,this.itemRendererSelectedSkinTexture);
         _loc2_.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.defaultSkin = _loc2_;
         param1.fontStyles = this.largeLightFontStyles.clone();
         param1.disabledFontStyles = this.largeLightDisabledFontStyles.clone();
         param1.selectedFontStyles = this.largeDarkFontStyles.clone();
         param1.setFontStylesForState(ButtonState.DOWN,this.largeDarkFontStyles.clone());
         param1.iconLabelFontStyles = this.lightFontStyles.clone();
         param1.iconLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.iconLabelSelectedFontStyles = this.darkFontStyles.clone();
         param1.setIconLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.accessoryLabelFontStyles = this.lightFontStyles.clone();
         param1.accessoryLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.accessoryLabelSelectedFontStyles = this.darkFontStyles.clone();
         param1.setAccessoryLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = this.gutterSize;
         param1.minGap = this.gutterSize;
         param1.iconPosition = RelativePosition.LEFT;
         param1.accessoryGap = Number.POSITIVE_INFINITY;
         param1.minAccessoryGap = this.gutterSize;
         param1.accessoryPosition = RelativePosition.RIGHT;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setDrillDownItemRendererStyles(param1:DefaultListItemRenderer) : void
      {
         this.setItemRendererStyles(param1);
         param1.itemHasAccessory = false;
         var _loc2_:ImageSkin = new ImageSkin(this.listDrillDownAccessoryTexture);
         _loc2_.selectedTexture = this.listDrillDownAccessorySelectedTexture;
         _loc2_.setTextureForState(ButtonState.DOWN,this.listDrillDownAccessorySelectedTexture);
         param1.defaultAccessory = _loc2_;
      }
      
      protected function setCheckItemRendererStyles(param1:BaseDefaultItemRenderer) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.itemRendererSelectedSkinTexture);
         _loc2_.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.defaultSkin = _loc2_;
         var _loc3_:ImageLoader = new ImageLoader();
         _loc3_.source = this.pickerListItemSelectedIconTexture;
         param1.defaultSelectedIcon = _loc3_;
         _loc3_.validate();
         var _loc4_:Quad = new Quad(_loc3_.width,_loc3_.height,16711935);
         _loc4_.alpha = 0;
         param1.defaultIcon = _loc4_;
         param1.fontStyles = this.largeLightFontStyles.clone();
         param1.disabledFontStyles = this.largeLightDisabledFontStyles.clone();
         param1.setFontStylesForState(ButtonState.DOWN,this.largeDarkFontStyles.clone());
         param1.iconLabelFontStyles = this.lightFontStyles.clone();
         param1.iconLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.setIconLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.accessoryLabelFontStyles = this.lightFontStyles.clone();
         param1.accessoryLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.setAccessoryLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.itemHasIcon = false;
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = Number.POSITIVE_INFINITY;
         param1.minGap = this.gutterSize;
         param1.iconPosition = RelativePosition.RIGHT;
         param1.accessoryGap = this.smallGutterSize;
         param1.minAccessoryGap = this.smallGutterSize;
         param1.accessoryPosition = RelativePosition.BOTTOM;
         param1.layoutOrder = ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setNumericStepperStyles(param1:NumericStepper) : void
      {
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = this.focusPaddingSize;
         param1.useLeftAndRightKeys = true;
         param1.buttonLayoutMode = StepperButtonLayoutMode.SPLIT_HORIZONTAL;
         param1.incrementButtonLabel = "+";
         param1.decrementButtonLabel = "-";
      }
      
      protected function setNumericStepperTextInputStyles(param1:TextInput) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
         _loc2_.setTextureForState(TextInputState.DISABLED,this.backgroundDisabledSkinTexture);
         _loc2_.setTextureForState(TextInputState.FOCUSED,this.backgroundInsetFocusedSkinTexture);
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.backgroundSkin = _loc2_;
         param1.textEditorFactory = stepperTextEditorFactory;
         param1.fontStyles = this.lightCenteredUIFontStyles.clone();
         param1.disabledFontStyles = this.lightCenteredDisabledUIFontStyles.clone();
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
         param1.gap = this.smallControlGutterSize;
         param1.paddingTop = this.smallControlGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingBottom = this.smallControlGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.isEditable = false;
         param1.isSelectable = false;
      }
      
      protected function setNumericStepperButtonStyles(param1:Button) : void
      {
         this.setButtonStyles(param1);
         param1.keepDownStateOnRollOut = true;
      }
      
      protected function setPageIndicatorStyles(param1:PageIndicator) : void
      {
         param1.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
         param1.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
         param1.gap = this.smallGutterSize;
         param1.padding = this.smallGutterSize;
         param1.minTouchWidth = this.smallControlSize * 2;
         param1.minTouchHeight = this.smallControlSize * 2;
      }
      
      protected function setPanelStyles(param1:Panel) : void
      {
         this.setScrollerStyles(param1);
         var _loc2_:Image = new Image(this.backgroundLightBorderSkinTexture);
         _loc2_.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.padding = this.smallGutterSize;
         param1.outerPadding = this.borderSize;
      }
      
      protected function setPopUpHeaderStyles(param1:Header) : void
      {
         param1.padding = this.smallGutterSize;
         param1.gap = this.smallGutterSize;
         param1.titleGap = this.smallGutterSize;
         param1.fontStyles = this.xlargeLightUIFontStyles.clone();
         param1.disabledFontStyles = this.xlargeLightUIDisabledFontStyles.clone();
         var _loc2_:ImageSkin = new ImageSkin(this.popUpHeaderBackgroundSkinTexture);
         _loc2_.tileGrid = new Rectangle();
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.backgroundSkin = _loc2_;
      }
      
      protected function setPanelScreenStyles(param1:PanelScreen) : void
      {
         this.setScrollerStyles(param1);
      }
      
      protected function setPanelScreenHeaderStyles(param1:Header) : void
      {
         this.setHeaderStyles(param1);
         param1.useExtraPaddingForOSStatusBar = true;
      }
      
      protected function setPickerListStyles(param1:PickerList) : void
      {
         if(DeviceCapabilities.isPhone(this.starling.nativeStage))
         {
            param1.listFactory = pickerListSpinnerListFactory;
            param1.popUpContentManager = new BottomDrawerPopUpContentManager();
         }
         else
         {
            param1.popUpContentManager = new CalloutPopUpContentManager();
            param1.customItemRendererStyleName = THEME_STYLE_NAME_TABLET_PICKER_LIST_ITEM_RENDERER;
         }
      }
      
      protected function setPickerListPopUpListStyles(param1:List) : void
      {
         this.setDropDownListStyles(param1);
      }
      
      protected function setPickerListItemRendererStyles(param1:BaseDefaultItemRenderer) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.itemRendererSelectedSkinTexture);
         _loc2_.scale9Grid = ITEM_RENDERER_SCALE9_GRID;
         _loc2_.width = this.popUpFillSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.popUpFillSize;
         _loc2_.minHeight = this.gridSize;
         param1.defaultSkin = _loc2_;
         var _loc3_:ImageLoader = new ImageLoader();
         _loc3_.source = this.pickerListItemSelectedIconTexture;
         param1.defaultSelectedIcon = _loc3_;
         _loc3_.validate();
         var _loc4_:Quad = new Quad(_loc3_.width,_loc3_.height,16711935);
         _loc4_.alpha = 0;
         param1.defaultIcon = _loc4_;
         param1.fontStyles = this.largeLightFontStyles.clone();
         param1.disabledFontStyles = this.largeLightDisabledFontStyles.clone();
         param1.setFontStylesForState(ButtonState.DOWN,this.largeDarkFontStyles.clone());
         param1.iconLabelFontStyles = this.lightFontStyles.clone();
         param1.iconLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.setIconLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.accessoryLabelFontStyles = this.lightFontStyles.clone();
         param1.accessoryLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.setAccessoryLabelFontStylesForState(ButtonState.DOWN,this.darkFontStyles.clone());
         param1.itemHasIcon = false;
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = Number.POSITIVE_INFINITY;
         param1.minGap = this.gutterSize;
         param1.iconPosition = RelativePosition.RIGHT;
         param1.accessoryGap = this.smallGutterSize;
         param1.minAccessoryGap = this.smallGutterSize;
         param1.accessoryPosition = RelativePosition.BOTTOM;
         param1.layoutOrder = ItemRendererLayoutOrder.LABEL_ACCESSORY_ICON;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setPickerListButtonStyles(param1:Button) : void
      {
         this.setButtonStyles(param1);
         var _loc2_:ImageSkin = new ImageSkin(this.pickerListButtonIconTexture);
         _loc2_.selectedTexture = this.pickerListButtonSelectedIconTexture;
         _loc2_.setTextureForState(ButtonState.DISABLED,this.pickerListButtonIconDisabledTexture);
         param1.defaultIcon = _loc2_;
         param1.gap = Number.POSITIVE_INFINITY;
         param1.minGap = this.gutterSize;
         param1.iconPosition = RelativePosition.RIGHT;
      }
      
      protected function setProgressBarStyles(param1:ProgressBar) : void
      {
         var _loc2_:Image = new Image(this.backgroundSkinTexture);
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         if(param1.direction == Direction.VERTICAL)
         {
            _loc2_.width = this.smallControlSize;
            _loc2_.height = this.wideControlSize;
         }
         else
         {
            _loc2_.width = this.wideControlSize;
            _loc2_.height = this.smallControlSize;
         }
         param1.backgroundSkin = _loc2_;
         var _loc3_:Image = new Image(this.backgroundDisabledSkinTexture);
         _loc3_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         if(param1.direction == Direction.VERTICAL)
         {
            _loc3_.width = this.smallControlSize;
            _loc3_.height = this.wideControlSize;
         }
         else
         {
            _loc3_.width = this.wideControlSize;
            _loc3_.height = this.smallControlSize;
         }
         param1.backgroundDisabledSkin = _loc3_;
         var _loc4_:Image = new Image(this.buttonUpSkinTexture);
         _loc4_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc4_.width = this.smallControlSize;
         _loc4_.height = this.smallControlSize;
         param1.fillSkin = _loc4_;
         var _loc5_:Image = new Image(this.buttonDisabledSkinTexture);
         _loc5_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc5_.width = this.smallControlSize;
         _loc5_.height = this.smallControlSize;
         param1.fillDisabledSkin = _loc5_;
      }
      
      protected function setRadioStyles(param1:Radio) : void
      {
         var _loc2_:Quad = new Quad(this.controlSize,this.controlSize);
         _loc2_.alpha = 0;
         param1.defaultSkin = _loc2_;
         var _loc3_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc3_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc3_;
         param1.focusPadding = this.focusPaddingSize;
         var _loc4_:ImageSkin = new ImageSkin(this.radioUpIconTexture);
         _loc4_.selectedTexture = this.radioSelectedUpIconTexture;
         _loc4_.setTextureForState(ButtonState.DOWN,this.radioDownIconTexture);
         _loc4_.setTextureForState(ButtonState.DISABLED,this.radioDisabledIconTexture);
         _loc4_.setTextureForState(ButtonState.DOWN_AND_SELECTED,this.radioSelectedDownIconTexture);
         _loc4_.setTextureForState(ButtonState.DISABLED_AND_SELECTED,this.radioSelectedDisabledIconTexture);
         param1.defaultIcon = _loc4_;
         param1.fontStyles = this.lightUIFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledUIFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.gap = this.smallControlGutterSize;
         param1.minGap = this.smallControlGutterSize;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setScrollContainerStyles(param1:ScrollContainer) : void
      {
         this.setScrollerStyles(param1);
      }
      
      protected function setToolbarScrollContainerStyles(param1:ScrollContainer) : void
      {
         var _loc3_:HorizontalLayout = null;
         this.setScrollerStyles(param1);
         if(!param1.layout)
         {
            _loc3_ = new HorizontalLayout();
            _loc3_.padding = this.smallGutterSize;
            _loc3_.gap = this.smallGutterSize;
            _loc3_.verticalAlign = VerticalAlign.MIDDLE;
            param1.layout = _loc3_;
         }
         var _loc2_:ImageSkin = new ImageSkin(this.headerBackgroundSkinTexture);
         _loc2_.tileGrid = new Rectangle();
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.backgroundSkin = _loc2_;
      }
      
      protected function setScrollScreenStyles(param1:ScrollScreen) : void
      {
         this.setScrollerStyles(param1);
      }
      
      protected function setScrollTextStyles(param1:ScrollText) : void
      {
         this.setScrollerStyles(param1);
         param1.fontStyles = this.lightScrollTextFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledScrollTextFontStyles.clone();
         param1.padding = this.gutterSize;
         param1.paddingRight = this.gutterSize + this.smallGutterSize;
      }
      
      protected function setSimpleScrollBarStyles(param1:SimpleScrollBar) : void
      {
         if(param1.direction == Direction.HORIZONTAL)
         {
            param1.paddingRight = this.scrollBarGutterSize;
            param1.paddingBottom = this.scrollBarGutterSize;
            param1.paddingLeft = this.scrollBarGutterSize;
            param1.customThumbStyleName = THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB;
         }
         else
         {
            param1.paddingTop = this.scrollBarGutterSize;
            param1.paddingRight = this.scrollBarGutterSize;
            param1.paddingBottom = this.scrollBarGutterSize;
            param1.customThumbStyleName = THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB;
         }
      }
      
      protected function setHorizontalSimpleScrollBarThumbStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.horizontalScrollBarThumbSkinTexture);
         _loc2_.scale9Grid = HORIZONTAL_SCROLL_BAR_THUMB_SCALE9_GRID;
         _loc2_.width = this.gutterSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalSimpleScrollBarThumbStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.verticalScrollBarThumbSkinTexture);
         _loc2_.scale9Grid = VERTICAL_SCROLL_BAR_THUMB_SCALE9_GRID;
         _loc2_.height = this.gutterSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setSliderStyles(param1:Slider) : void
      {
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = this.focusPaddingSize;
         param1.trackLayoutMode = TrackLayoutMode.SPLIT;
         if(param1.direction == Direction.VERTICAL)
         {
            param1.customMinimumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK;
            param1.customMaximumTrackStyleName = THEME_STYLE_NAME_VERTICAL_SLIDER_MAXIMUM_TRACK;
         }
         else
         {
            param1.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
            param1.customMaximumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MAXIMUM_TRACK;
         }
      }
      
      protected function setHorizontalSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
         _loc2_.disabledTexture = this.backgroundDisabledSkinTexture;
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.wideControlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.wideControlSize;
         _loc2_.minHeight = this.controlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setHorizontalSliderMaximumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
         _loc2_.disabledTexture = this.backgroundDisabledSkinTexture;
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.wideControlSize;
         _loc2_.minWidth = this.wideControlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
         _loc2_.disabledTexture = this.backgroundDisabledSkinTexture;
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.wideControlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.wideControlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalSliderMaximumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.backgroundSkinTexture);
         _loc2_.disabledTexture = this.backgroundDisabledSkinTexture;
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.wideControlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.wideControlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setSpinnerListStyles(param1:SpinnerList) : void
      {
         this.setScrollerStyles(param1);
         var _loc2_:Image = new Image(this.backgroundDarkBorderSkinTexture);
         _loc2_.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
         param1.backgroundSkin = _loc2_;
         var _loc3_:Image = new Image(this.spinnerListSelectionOverlaySkinTexture);
         _loc3_.scale9Grid = SPINNER_LIST_SELECTION_OVERLAY_SCALE9_GRID;
         param1.selectionOverlaySkin = _loc3_;
         param1.customItemRendererStyleName = THEME_STYLE_NAME_SPINNER_LIST_ITEM_RENDERER;
         param1.paddingTop = this.borderSize;
         param1.paddingBottom = this.borderSize;
      }
      
      protected function setSpinnerListItemRendererStyles(param1:DefaultListItemRenderer) : void
      {
         var _loc2_:Quad = new Quad(this.gridSize,this.gridSize,16711935);
         _loc2_.alpha = 0;
         param1.defaultSkin = _loc2_;
         param1.fontStyles = this.largeLightFontStyles.clone();
         param1.disabledFontStyles = this.largeLightDisabledFontStyles.clone();
         param1.iconLabelFontStyles = this.lightFontStyles.clone();
         param1.iconLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.accessoryLabelFontStyles = this.lightFontStyles.clone();
         param1.accessoryLabelDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = this.gutterSize;
         param1.minGap = this.gutterSize;
         param1.iconPosition = RelativePosition.LEFT;
         param1.accessoryGap = Number.POSITIVE_INFINITY;
         param1.minAccessoryGap = this.gutterSize;
         param1.accessoryPosition = RelativePosition.RIGHT;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setTabBarStyles(param1:TabBar) : void
      {
         param1.distributeTabSizes = true;
      }
      
      protected function setTabStyles(param1:ToggleButton) : void
      {
         var _loc2_:ImageSkin = null;
         var _loc3_:Image = null;
         _loc2_ = new ImageSkin(this.tabUpSkinTexture);
         _loc2_.selectedTexture = this.tabSelectedUpSkinTexture;
         _loc2_.setTextureForState(ButtonState.DOWN,this.tabDownSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED,this.tabDisabledSkinTexture);
         _loc2_.setTextureForState(ButtonState.DISABLED_AND_SELECTED,this.tabSelectedDisabledSkinTexture);
         _loc2_.scale9Grid = TAB_SCALE9_GRID;
         _loc2_.width = this.gridSize;
         _loc2_.height = this.gridSize;
         _loc2_.minWidth = this.gridSize;
         _loc2_.minHeight = this.gridSize;
         param1.defaultSkin = _loc2_;
         _loc3_ = new Image(this.focusIndicatorSkinTexture);
         _loc3_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc3_;
         param1.focusPadding = this.tabFocusPaddingSize;
         param1.fontStyles = this.lightUIFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledUIFontStyles.clone();
         param1.selectedFontStyles = this.darkUIFontStyles.clone();
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = this.smallGutterSize;
         param1.minGap = this.smallGutterSize;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setTextAreaStyles(param1:TextArea) : void
      {
         var _loc2_:ImageSkin = null;
         this.setScrollerStyles(param1);
         _loc2_ = new ImageSkin(this.backgroundInsetSkinTexture);
         _loc2_.setTextureForState(TextInputState.DISABLED,this.backgroundDisabledSkinTexture);
         _loc2_.setTextureForState(TextInputState.FOCUSED,this.backgroundInsetFocusedSkinTexture);
         _loc2_.setTextureForState(TextInputState.ERROR,this.backgroundInsetDangerSkinTexture);
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.wideControlSize;
         _loc2_.height = this.wideControlSize;
         param1.backgroundSkin = _loc2_;
         param1.fontStyles = this.lightInputFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledInputFontStyles.clone();
         param1.promptFontStyles = this.lightFontStyles.clone();
         param1.promptDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.textEditorFactory = textAreaTextEditorFactory;
         param1.innerPadding = this.smallGutterSize;
      }
      
      protected function setTextAreaErrorCalloutStyles(param1:TextCallout) : void
      {
         this.setDangerCalloutStyles(param1);
         param1.fontStyles = this.lightFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.verticalAlign = VerticalAlign.TOP;
      }
      
      protected function setTextCalloutStyles(param1:TextCallout) : void
      {
         this.setCalloutStyles(param1);
         param1.fontStyles = this.lightFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledFontStyles.clone();
      }
      
      protected function setToastStyles(param1:Toast) : void
      {
         var _loc2_:Image = null;
         _loc2_ = new Image(this.backgroundLightBorderSkinTexture);
         _loc2_.scale9Grid = SMALL_BACKGROUND_SCALE9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.fontStyles = this.lightFontStyles.clone();
         param1.width = this.popUpFillSize;
         param1.paddingTop = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.paddingBottom = this.gutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.gap = Number.POSITIVE_INFINITY;
         param1.minGap = this.smallGutterSize;
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.verticalAlign = VerticalAlign.MIDDLE;
      }
      
      protected function setToastActionsStyles(param1:ButtonGroup) : void
      {
         param1.direction = Direction.HORIZONTAL;
         param1.gap = this.smallGutterSize;
         param1.customButtonStyleName = THEME_STYLE_NAME_TOAST_ACTIONS_BUTTON;
      }
      
      protected function setToastActionsButtonStyles(param1:Button) : void
      {
         param1.fontStyles = this.selectedUIFontStyles.clone();
         param1.setFontStylesForState(ButtonState.DOWN,this.lightUIFontStyles);
      }
      
      protected function setBaseTextInputStyles(param1:TextInput) : void
      {
         var _loc2_:ImageSkin = null;
         _loc2_ = new ImageSkin(this.backgroundInsetSkinTexture);
         _loc2_.setTextureForState(TextInputState.DISABLED,this.backgroundInsetDisabledSkinTexture);
         _loc2_.setTextureForState(TextInputState.FOCUSED,this.backgroundInsetFocusedSkinTexture);
         _loc2_.setTextureForState(TextInputState.ERROR,this.backgroundInsetDangerSkinTexture);
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.wideControlSize;
         _loc2_.height = this.controlSize;
         _loc2_.minWidth = this.controlSize;
         _loc2_.minHeight = this.controlSize;
         param1.backgroundSkin = _loc2_;
         param1.fontStyles = this.lightInputFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledInputFontStyles.clone();
         param1.promptFontStyles = this.lightFontStyles.clone();
         param1.promptDisabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
         param1.gap = this.smallControlGutterSize;
         param1.paddingTop = this.smallControlGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingBottom = this.smallControlGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.verticalAlign = VerticalAlign.MIDDLE;
      }
      
      protected function setTextInputStyles(param1:TextInput) : void
      {
         this.setBaseTextInputStyles(param1);
      }
      
      protected function setTextInputErrorCalloutStyles(param1:TextCallout) : void
      {
         this.setDangerCalloutStyles(param1);
         param1.fontStyles = this.lightFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledFontStyles.clone();
         param1.horizontalAlign = HorizontalAlign.LEFT;
         param1.verticalAlign = VerticalAlign.TOP;
      }
      
      protected function setSearchTextInputStyles(param1:TextInput) : void
      {
         var _loc2_:ImageSkin = null;
         this.setBaseTextInputStyles(param1);
         param1.fontStyles = this.lightInputFontStyles.clone();
         param1.disabledFontStyles = this.lightDisabledInputFontStyles.clone();
         param1.promptFontStyles = this.lightFontStyles.clone();
         param1.promptDisabledFontStyles = this.lightDisabledFontStyles.clone();
         _loc2_ = new ImageSkin(this.searchIconTexture);
         _loc2_.setTextureForState(TextInputState.DISABLED,this.searchIconDisabledTexture);
         param1.defaultIcon = _loc2_;
      }
      
      protected function setToggleSwitchStyles(param1:ToggleSwitch) : void
      {
         var _loc2_:Image = null;
         _loc2_ = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = this.focusPaddingSize;
         param1.trackLayoutMode = TrackLayoutMode.SINGLE;
         param1.offLabelFontStyles = this.lightUIFontStyles.clone();
         param1.offLabelDisabledFontStyles = this.lightDisabledUIFontStyles.clone();
         param1.onLabelFontStyles = this.selectedUIFontStyles.clone();
         param1.onLabelDisabledFontStyles = this.lightDisabledUIFontStyles.clone();
      }
      
      protected function setToggleSwitchTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = null;
         _loc2_ = new ImageSkin(this.backgroundSkinTexture);
         _loc2_.disabledTexture = this.backgroundDisabledSkinTexture;
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = Math.round(this.controlSize * 2.5);
         _loc2_.height = this.controlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setTreeStyles(param1:Tree) : void
      {
         var _loc2_:Quad = null;
         this.setScrollerStyles(param1);
         _loc2_ = new Quad(this.gridSize,this.gridSize,LIST_BACKGROUND_COLOR);
         param1.backgroundSkin = _loc2_;
      }
      
      protected function setTreeItemRendererStyles(param1:DefaultTreeItemRenderer) : void
      {
         var _loc2_:ImageSkin = null;
         var _loc3_:ImageSkin = null;
         this.setItemRendererStyles(param1);
         param1.indentation = this.treeDisclosureOpenIconTexture.width;
         _loc2_ = new ImageSkin(this.treeDisclosureOpenIconTexture);
         _loc2_.selectedTexture = this.treeDisclosureOpenSelectedIconTexture;
         _loc2_.minTouchWidth = this.gridSize;
         _loc2_.minTouchHeight = this.gridSize;
         param1.disclosureOpenIcon = _loc2_;
         _loc3_ = new ImageSkin(this.treeDisclosureClosedIconTexture);
         _loc3_.selectedTexture = this.treeDisclosureClosedSelectedIconTexture;
         _loc3_.minTouchWidth = this.gridSize;
         _loc3_.minTouchHeight = this.gridSize;
         param1.disclosureClosedIcon = _loc3_;
      }
      
      protected function setPlayPauseToggleButtonStyles(param1:PlayPauseToggleButton) : void
      {
         var _loc2_:Quad = null;
         var _loc3_:ImageSkin = null;
         _loc2_ = new Quad(this.controlSize,this.controlSize);
         _loc2_.alpha = 0;
         param1.defaultSkin = _loc2_;
         _loc3_ = new ImageSkin(this.playPauseButtonPlayUpIconTexture);
         _loc3_.selectedTexture = this.playPauseButtonPauseUpIconTexture;
         _loc3_.setTextureForState(ButtonState.DOWN,this.playPauseButtonPlayDownIconTexture);
         _loc3_.setTextureForState(ButtonState.DOWN_AND_SELECTED,this.playPauseButtonPauseDownIconTexture);
         param1.defaultIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setOverlayPlayPauseToggleButtonStyles(param1:PlayPauseToggleButton) : void
      {
         var _loc2_:ImageSkin = null;
         var _loc3_:Quad = null;
         _loc2_ = new ImageSkin(null);
         _loc2_.setTextureForState(ButtonState.UP,this.overlayPlayPauseButtonPlayUpIconTexture);
         _loc2_.setTextureForState(ButtonState.HOVER,this.overlayPlayPauseButtonPlayUpIconTexture);
         _loc2_.setTextureForState(ButtonState.DOWN,this.overlayPlayPauseButtonPlayDownIconTexture);
         param1.defaultIcon = _loc2_;
         param1.hasLabelTextRenderer = false;
         _loc3_ = new Quad(1,1,VIDEO_OVERLAY_COLOR);
         _loc3_.alpha = VIDEO_OVERLAY_ALPHA;
         param1.upSkin = _loc3_;
         param1.hoverSkin = _loc3_;
      }
      
      protected function setFullScreenToggleButtonStyles(param1:FullScreenToggleButton) : void
      {
         var _loc2_:Quad = null;
         var _loc3_:ImageSkin = null;
         _loc2_ = new Quad(this.controlSize,this.controlSize);
         _loc2_.alpha = 0;
         param1.defaultSkin = _loc2_;
         _loc3_ = new ImageSkin(this.fullScreenToggleButtonEnterUpIconTexture);
         _loc3_.selectedTexture = this.fullScreenToggleButtonExitUpIconTexture;
         _loc3_.setTextureForState(ButtonState.DOWN,this.fullScreenToggleButtonEnterDownIconTexture);
         _loc3_.setTextureForState(ButtonState.DOWN_AND_SELECTED,this.fullScreenToggleButtonExitDownIconTexture);
         param1.defaultIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setMuteToggleButtonStyles(param1:MuteToggleButton) : void
      {
         var _loc2_:Quad = null;
         var _loc3_:ImageSkin = null;
         _loc2_ = new Quad(this.controlSize,this.controlSize);
         _loc2_.alpha = 0;
         param1.defaultSkin = _loc2_;
         _loc3_ = new ImageSkin(this.muteToggleButtonLoudUpIconTexture);
         _loc3_.selectedTexture = this.muteToggleButtonMutedUpIconTexture;
         _loc3_.setTextureForState(ButtonState.DOWN,this.muteToggleButtonLoudDownIconTexture);
         _loc3_.setTextureForState(ButtonState.DOWN_AND_SELECTED,this.muteToggleButtonMutedDownIconTexture);
         param1.defaultIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
         param1.showVolumeSliderOnHover = false;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setSeekSliderStyles(param1:SeekSlider) : void
      {
         var _loc2_:Image = null;
         param1.trackLayoutMode = TrackLayoutMode.SPLIT;
         param1.showThumb = false;
         _loc2_ = new Image(this.seekSliderProgressSkinTexture);
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.smallControlSize;
         _loc2_.height = this.smallControlSize;
         param1.progressSkin = _loc2_;
      }
      
      protected function setSeekSliderThumbStyles(param1:Button) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = 6;
         param1.defaultSkin = new Quad(_loc2_,_loc2_);
         param1.hasLabelTextRenderer = false;
         param1.minTouchWidth = this.gridSize;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setSeekSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = null;
         _loc2_ = new ImageSkin(this.buttonUpSkinTexture);
         _loc2_.scale9Grid = BUTTON_SCALE9_GRID;
         _loc2_.width = this.wideControlSize;
         _loc2_.height = this.smallControlSize;
         _loc2_.minWidth = this.wideControlSize;
         _loc2_.minHeight = this.smallControlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setSeekSliderMaximumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = null;
         _loc2_ = new ImageSkin(this.backgroundSkinTexture);
         _loc2_.scale9Grid = DEFAULT_BACKGROUND_SCALE9_GRID;
         _loc2_.width = this.wideControlSize;
         _loc2_.height = this.smallControlSize;
         _loc2_.minHeight = this.smallControlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setVolumeSliderStyles(param1:VolumeSlider) : void
      {
         param1.direction = Direction.HORIZONTAL;
         param1.trackLayoutMode = TrackLayoutMode.SPLIT;
         param1.showThumb = false;
      }
      
      protected function setVolumeSliderThumbStyles(param1:Button) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Quad = null;
         _loc2_ = 6;
         _loc3_ = new Quad(_loc2_,_loc2_);
         _loc3_.width = 0;
         _loc3_.height = 0;
         param1.defaultSkin = _loc3_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVolumeSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageLoader = null;
         _loc2_ = new ImageLoader();
         _loc2_.scaleContent = false;
         _loc2_.source = this.volumeSliderMinimumTrackSkinTexture;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
         param1.minTouchHeight = this.gridSize;
      }
      
      protected function setVolumeSliderMaximumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageLoader = null;
         _loc2_ = new ImageLoader();
         _loc2_.scaleContent = false;
         _loc2_.horizontalAlign = HorizontalAlign.RIGHT;
         _loc2_.source = this.volumeSliderMaximumTrackSkinTexture;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
         param1.minTouchHeight = this.gridSize;
      }
   }
}

