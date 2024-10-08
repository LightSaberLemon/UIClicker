{
    Copyright (C) 2023 VCC
    creation date: Dec 2019
    initial release date: 13 Sep 2022

    author: VCC
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}


unit ClickerActionsFrame;

{$IFDEF FPC}
  //{$MODE Delphi}
{$ENDIF}

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, ExtCtrls, StdCtrls, ComCtrls, ImgList, Buttons,
  Menus, ClickerUtils, ClickerConditionEditorFrame,
  ClickerFindControlFrame, ClickerExecAppFrame, ClickerSetVarFrame,
  ClickerCallTemplateFrame, ClickerSleepFrame, ClickerPluginFrame,
  Types, InMemFileSystem, ObjectInspectorFrame,
  ClickerPrimitiveUtils, ClickerIniFiles;

type
  TVarNodeRec = record
    VarName, VarValue: string;
  end;

  PVarNodeRec = ^TVarNodeRec;

  TOnGetLoadedTemplateFileName = function: string of object;

  { TfrClickerActions }

  TfrClickerActions = class(TFrame)
    chkDecodeVariables: TCheckBox;
    chkShowDebugGrid: TCheckBox;
    imglstMatchByHistogramSettings: TImageList;
    imglstUsedMatchCriteria: TImageList;
    imgPluginFileName: TImage;
    imgDebugBmp: TImage;
    imgDebugGrid: TImage;
    imglstLoadSetVarFromFileProperties: TImageList;
    imglstSaveSetVarToFileProperties: TImageList;
    imglstMatchPrimitiveFilesProperties: TImageList;
    imgFontColorBuffer: TImage;
    imglstFontColorProperties: TImageList;
    imglstMatchBitmapTextProperties: TImageList;
    imglstMatchCriteriaProperties: TImageList;
    imglstInitialRectangleProperties: TImageList;
    imglstMatchBitmapAlgorithmSettingsProperties: TImageList;
    imglstActionProperties: TImageList;
    imglstCallTemplateLoopProperties: TImageList;
    imglstPluginProperties: TImageList;
    imglstWindowOperationsProperties: TImageList;
    imglstSleepProperties: TImageList;
    imglstExecAppProperties: TImageList;
    imglstSetTextProperties: TImageList;
    imglstFindControlProperties: TImageList;
    imglstActions16: TImageList;
    imglstClickProperties: TImageList;
    imglstCallTemplateProperties: TImageList;
    imglstSetVarProperties: TImageList;
    imgPlugin: TImage;
    lblBitmaps: TLabel;
    lblDebugBitmapXMouseOffset: TLabel;
    lblDebugBitmapYMouseOffset: TLabel;
    lblMouseOnExecDbgImgBB: TLabel;
    lblMouseOnExecDbgImgGG: TLabel;
    lblMouseOnExecDbgImgRR: TLabel;
    lblVarReplacements: TLabel;
    MenuItem_ReplaceWithSelfTemplateDir: TMenuItem;
    MenuItem_ReplaceWithTemplateDir: TMenuItem;
    MenuItem_ReplaceWithAppDir: TMenuItem;
    MenuItem_SetFromControlWidthAndHeight: TMenuItem;
    MenuItem_SetFromControlLeftAndTop: TMenuItem;
    MenuItem_AddFilesToPropertyList: TMenuItem;
    MenuItem_AddLastActionStatusEqualsSuccessful: TMenuItem;
    MenuItem_AddLastActionStatusEqualsAllowedFailed: TMenuItem;
    N6: TMenuItem;
    MenuItemColor_WindowFrame: TMenuItem;
    MenuItemColor_3DLight: TMenuItem;
    MenuItemColor_3DDkShadow: TMenuItem;
    MenuItemColor_ScrollBar: TMenuItem;
    MenuItemColor_GradientInactiveCaption: TMenuItem;
    MenuItemColor_GradientActiveCaption: TMenuItem;
    MenuItemColor_GrayText: TMenuItem;
    N5: TMenuItem;
    N4: TMenuItem;
    MenuItem_RemoveSetVar: TMenuItem;
    MenuItem_AddSetVar: TMenuItem;
    MenuItemControl_Bottom: TMenuItem;
    MenuItemControl_Right: TMenuItem;
    MenuItemControl_Top: TMenuItem;
    MenuItemControl_Left: TMenuItem;
    N3: TMenuItem;
    MenuItemPasteRefFromClipboard: TMenuItem;
    MenuItemCopyRefToClipboard: TMenuItem;
    N2: TMenuItem;
    MenuItemPasteColorFromClipboard: TMenuItem;
    MenuItemCopyColorToClipboard: TMenuItem;
    MenuItemColor_WindowText: TMenuItem;
    MenuItemColor_Window: TMenuItem;
    MenuItemColor_InactiveCaption: TMenuItem;
    MenuItemColor_ActiveCaption: TMenuItem;
    MenuItemColor_BtnFace: TMenuItem;
    MenuItemColor_Highlight: TMenuItem;
    MenuItemGreaterThanOrEqual: TMenuItem;
    MenuItemLessThanOrEqual: TMenuItem;
    MenuItemGreaterThan: TMenuItem;
    MenuItemLessThan: TMenuItem;
    MenuItemEqual: TMenuItem;
    MenuItemNotEqual: TMenuItem;
    MenuItemCopySearchAreaAllToClipboard: TMenuItem;
    MenuItemCopySearchAreaSearchBmpImgToClipboard: TMenuItem;
    MenuItemCopySearchAreaBkImgToClipboard: TMenuItem;
    MenuItemGenericLoadBmpToSearchedArea: TMenuItem;
    pnlHorizSplitterResults: TPanel;
    pnlResults: TPanel;
    pmStandardControlRefVars: TPopupMenu;
    pmStandardColorVariables: TPopupMenu;
    pnlActionConditions: TPanel;
    pmWindowOperationsEditors: TPopupMenu;
    pnlCover: TPanel;
    pnlExtra: TPanel;
    pnlHorizSplitter: TPanel;
    pnlVars: TPanel;
    pnlvstOI: TPanel;
    N10001: TMenuItem;
    N100001: TMenuItem;
    N01: TMenuItem;
    N300001: TMenuItem;
    pmPathReplacements: TPopupMenu;
    scrboxDebugBmp: TScrollBox;
    tmrEditClkVariables: TTimer;
    tmrClkVariables: TTimer;
    tmrDrawZoom: TTimer;
    tmrReloadOIContent: TTimer;
    AddCustomVarRow1: TMenuItem;
    RemoveCustomVarRow1: TMenuItem;
    MenuItemSavePreviewImage: TMenuItem;
    MenuItemCopyPreviewImage: TMenuItem;
    imglstActions: TImageList;
    pmDebugVars: TPopupMenu;
    CopyDebugValuesListToClipboard1: TMenuItem;
    PasteDebugValuesListFromClipboard1: TMenuItem;
    PasteDebugValuesListFromMainExecutionList1: TMenuItem;
    MenuItemErasePreviewImage: TMenuItem;
    PageControlActionExecution: TPageControl;
    TabSheetAction: TTabSheet;
    TabSheetCondition: TTabSheet;
    TabSheetDebugging: TTabSheet;
    imglstActionExecution: TImageList;
    spdbtnCommonTimeouts: TSpeedButton;
    prbTimeout: TProgressBar;
    pmDebugImage: TPopupMenu;
    MenuItemSaveDebugImage: TMenuItem;
    MenuItemCopyDebugImage: TMenuItem;
    MenuItemEraseDebugImage: TMenuItem;
    MenuItemRemoveExpressionPart: TMenuItem;
    MenuItemRemoveTerm: TMenuItem;
    N1: TMenuItem;
    AddVariable1: TMenuItem;
    RemoveVariable1: TMenuItem;
    vstVariables: TVirtualStringTree;
    procedure chkDecodeVariablesChange(Sender: TObject);
    procedure chkWaitForControlToGoAwayChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure lbeFindCachedControlLeftChange(Sender: TObject);
    procedure lbeFindCachedControlTopChange(Sender: TObject);
    procedure MenuItem_ReplaceWithAppDirClick(Sender: TObject);
    procedure MenuItem_ReplaceWithSelfTemplateDirClick(Sender: TObject);
    procedure MenuItem_ReplaceWithTemplateDirClick(Sender: TObject);
    procedure MenuItem_SetFromControlLeftAndTopClick(Sender: TObject);
    procedure MenuItem_SetFromControlWidthAndHeightClick(Sender: TObject);
    procedure pmStandardColorVariablesPopup(Sender: TObject);
    procedure pnlHorizSplitterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHorizSplitterMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlHorizSplitterMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHorizSplitterResultsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlHorizSplitterResultsMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHorizSplitterResultsMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure scrboxDebugBmpMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure spdbtnDisplaySearchAreaDbgImgMenuClick(Sender: TObject);
    procedure tmrClkVariablesTimer(Sender: TObject);
    procedure tmrDrawZoomTimer(Sender: TObject);
    procedure tmrEditClkVariablesTimer(Sender: TObject);
    procedure tmrReloadOIContentTimer(Sender: TObject);

    procedure CopyDebugValuesListToClipboard1Click(Sender: TObject);
    procedure PasteDebugValuesListFromClipboard1Click(Sender: TObject);
    procedure PasteDebugValuesListFromMainExecutionList1Click(Sender: TObject);

    procedure imgDebugBmpMouseEnter(Sender: TObject);
    procedure imgDebugBmpMouseLeave(Sender: TObject);
    procedure imgDebugBmpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    procedure FlblResultSelVertMouseEnter(Sender: TObject);
    procedure FlblResultSelVertMouseLeave(Sender: TObject);
    procedure FlblResultSelVertMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    procedure FlblResultSelHorizMouseEnter(Sender: TObject);
    procedure FlblResultSelHorizMouseLeave(Sender: TObject);
    procedure FlblResultSelHorizMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    procedure chkShowDebugGridClick(Sender: TObject);
    procedure MenuItemSaveDebugImageClick(Sender: TObject);
    procedure MenuItemCopyDebugImageClick(Sender: TObject);
    procedure MenuItemEraseDebugImageClick(Sender: TObject);

    procedure lbeSearchRectLeftChange(Sender: TObject);
    procedure lbeSearchRectTopChange(Sender: TObject);
    procedure lbeSearchRectRightChange(Sender: TObject);
    procedure lbeSearchRectBottomChange(Sender: TObject);
    procedure lbeSearchRectLeftOffsetChange(Sender: TObject);
    procedure lbeSearchRectTopOffsetChange(Sender: TObject);
    procedure lbeSearchRectRightOffsetChange(Sender: TObject);
    procedure lbeSearchRectBottomOffsetChange(Sender: TObject);
    procedure rdgrpSearchForControlModeClick(Sender: TObject);
    procedure vallstVariablesValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: string);
    procedure AddVariable1Click(Sender: TObject);
    procedure RemoveVariable1Click(Sender: TObject);
    procedure lbeMatchClassNameChange(Sender: TObject);
    procedure lbeMatchTextSeparatorChange(Sender: TObject);
    procedure lbeMatchClassNameSeparatorChange(Sender: TObject);

    ///////////////////////////// OI
    procedure MenuItem_SetActionTimeoutFromOI(Sender: TObject);

    procedure MenuItem_CopyTextAndClassFromPreviewWindowClick(Sender: TObject);
    procedure MenuItem_CopyTextAndClassFromWinInterpWindowClick(Sender: TObject);
    procedure MenuItem_CopyTextAndClassFromRemoteScreenWindowClick(Sender: TObject);
    procedure MenuItem_SetTextAndClassAsSystemMenuClick(Sender: TObject);

    procedure MenuItem_AddBMPFilesToPropertyListClick(Sender: TObject);
    procedure MenuItem_RemoveAllBMPFilesFromPropertyListClick(Sender: TObject);
    procedure MenuItem_BrowseBMPFileFromPropertyListClick(Sender: TObject);
    procedure MenuItem_RemoveBMPFileFromPropertyListClick(Sender: TObject);
    procedure MenuItem_MoveBMPFileUpInPropertyListClick(Sender: TObject);
    procedure MenuItem_MoveBMPFileDownInPropertyListClick(Sender: TObject);

    procedure MenuItem_AddExistingPrimitiveFilesToPropertyListClick(Sender: TObject);
    procedure MenuItem_AddNewPrimitiveFilesToPropertyListClick(Sender: TObject);
    procedure MenuItem_RemoveAllPrimitiveFilesFromPropertyListClick(Sender: TObject);
    procedure MenuItem_BrowsePrimitiveFileFromPropertyListClick(Sender: TObject);
    procedure MenuItem_RemovePrimitiveFileFromPropertyListClick(Sender: TObject);
    procedure MenuItem_MovePrimitiveFileUpInPropertyListClick(Sender: TObject);
    procedure MenuItem_MovePrimitiveFileDownInPropertyListClick(Sender: TObject);
    procedure MenuItem_SavePrimitiveFileInPropertyListClick(Sender: TObject);
    procedure MenuItem_SavePrimitiveFileAsInPropertyListClick(Sender: TObject);
    procedure MenuItem_DiscardChangesAndReloadPrimitiveFileInPropertyListClick(Sender: TObject);
    procedure SavePrimitivesFileFromMenu(AFileIndex: Integer);

    procedure MenuItem_BrowseImageSourceFromPropertyListClick(Sender: TObject);
    procedure MenuItem_NoImageSourceInInMemPropertyListClick(Sender: TObject);
    procedure MenuItem_SetFileNameFromInMemPropertyListClick(Sender: TObject);
    procedure MenuItem_BrowseFileNameFromInMemPropertyListClick(Sender: TObject);

    procedure MenuItem_AddFontProfileToPropertyListClick(Sender: TObject);
    procedure MenuItem_AddFontProfileWithAntialiasedAndClearTypeToPropertyListClick(Sender: TObject);
    procedure MenuItem_AddFontProfileWithNonAntialiasedAndAntialiasedAndClearTypeToPropertyListClick(Sender: TObject);
    procedure MenuItem_RemoveFontProfileFromPropertyListClick(Sender: TObject);
    procedure MenuItem_DuplicateFontProfileClick(Sender: TObject);
    procedure MenuItem_MoveFontProfileUpInPropertyListClick(Sender: TObject);
    procedure MenuItem_MoveFontProfileDownInPropertyListClick(Sender: TObject);

    procedure MenuItem_BrowseSetVarFileInPropertyListClick(Sender: TObject);
    procedure MenuItem_BrowsePluginFileInPropertyListClick(Sender: TObject);

    procedure MenuItemControl_EdgeRefGenericClick(Sender: TObject);
    procedure MenuItemCopyRefToClipboardClick(Sender: TObject);
    procedure MenuItemPasteRefFromClipboardClick(Sender: TObject);
    procedure vstVariablesCreateEditor(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstVariablesEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure vstVariablesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: boolean);
    procedure vstVariablesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstVariablesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstVariablesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const NewText: string);
  private
    { Private declarations }
    FBMPsDir: string;
    FEditingText: string;
    FTextEditorEditBox: TEdit;
    FHold: Boolean;
    FHitInfo: THitInfo;
    FHoldResults: Boolean;
    FSplitterMouseDownGlobalPos: TPoint;
    FSplitterMouseDownImagePos: TPoint;

    FEditingActionRec: TClkActionRec;
    FEditingAction: PClkActionRec;
    FPrevSelectedPrimitiveNode: Integer;

    FOnControlsModified: TNotifyEvent;
    FControlsModified: Boolean;
    FPredefinedVarCount: Integer; //number of predefined variables from memVariables on form
    FDebuggingInfoAvailable: Boolean;
    FFullTemplatesDir: string;
    FSetVarContent_Vars: TStringList;
    FSetVarContent_Values: TStringList;
    FSetVarContent_EvalBefore: TStringList;
    FShowDeprecatedControls: Boolean;
    FCurrentMousePosOnPreviewImg: TPoint;

    FSearchAreaScrBox: TScrollBox;
    FSearchAreaSearchedBmpDbgImg: TImage;
    FSearchAreaSearchedTextDbgImg: TImage;
    FSearchAreaDbgImgSearchedBmpMenu: TPopupMenu;

    FCurrentlyEditingActionType: Integer;  //yes integer
    FCurrentlyEditingPrimitiveFileName: string;   //this is updated by OnLoad and OnSave handlers, which have the resolved file name
    FLastClickedTVTEdit: TVTEdit;
    FLastClickedEdit: TEdit;

    FClkVariables: TStringList;

    FlblResultSelLeft: TLabel;
    FlblResultSelTop: TLabel;
    FlblResultSelRight: TLabel;
    FlblResultSelBottom: TLabel;

    FPmLocalTemplates: TPopupMenu;
    FOIFrame: TfrObjectInspector;
    FOIEditorMenu: TPopupMenu;

    FOnCopyControlTextAndClassFromMainWindow: TOnCopyControlTextAndClassFromMainWindow;
    FOnGetExtraSearchAreaDebuggingImage: TOnGetExtraSearchAreaDebuggingImage;
    FOnEditCallTemplateBreakCondition: TOnEditActionCondition;

    FOnLoadBitmap: TOnLoadBitmap;
    FOnLoadRenderedBitmap: TOnLoadRenderedBitmap;
    FOnGetListOfExternallyRenderedImages: TOnGetListOfExternallyRenderedImages;
    FOnLoadPrimitivesFile: TOnLoadPrimitivesFile;
    FOnSavePrimitivesFile: TOnSavePrimitivesFile;
    FOnFileExists: TOnFileExists;

    FOnSetOpenDialogMultiSelect: TOnSetOpenDialogMultiSelect;
    FOnSetOpenDialogInitialDir: TOnSetOpenDialogInitialDir;
    FOnOpenDialogExecute: TOnOpenDialogExecute;
    FOnGetOpenDialogFileName: TOnGetOpenDialogFileName;
    FOnSetSaveDialogInitialDir: TOnSetOpenDialogInitialDir;
    FOnSaveDialogExecute: TOnOpenDialogExecute;
    FOnGetSaveDialogFileName: TOnGetOpenDialogFileName;
    FOnSetSaveDialogFileName: TOnSetOpenDialogFileName;

    FOnSetPictureSetOpenDialogMultiSelect: TOnSetPictureSetOpenDialogMultiSelect;
    FOnSetPictureOpenDialogInitialDir: TOnSetPictureOpenDialogInitialDir;
    FOnPictureOpenDialogExecute: TOnPictureOpenDialogExecute;
    FOnGetPictureOpenDialogFileName: TOnGetPictureOpenDialogFileName;

    FOnExecuteFindSubControlAction: TOnExecuteFindSubControlAction;
    FOnAddToLog: TOnAddToLog;
    FOnGetFontFinderSettings: TOnRWFontFinderSettings;
    FOnSetFontFinderSettings: TOnRWFontFinderSettings;

    FOnGetListOfAvailableSetVarActions: TOnGetListOfAvailableSetVarActions;
    FOnGetListOfAvailableActions: TOnGetListOfAvailableActions;
    FOnModifyPluginProperty: TOnModifyPluginProperty;

    FOnPluginDbgStop: TOnPluginDbgStop;
    FOnPluginDbgContinueAll: TOnPluginDbgContinueAll;
    FOnPluginDbgStepOver: TOnPluginDbgStepOver;
    FOnPluginDbgRequestLineNumber: TOnPluginDbgRequestLineNumber;
    FOnPluginDbgSetBreakpoint: TOnPluginDbgSetBreakpoint;
    FOnTClkIniFileCreate: TOnTClkIniFileCreate;

    FOnGetSelfTemplatesDir: TOnGetFullTemplatesDir;
    FOnShowAutoComplete: TOnShowAutoComplete;
    FOnUpdateActionScrollIndex: TOnUpdateActionScrollIndex;
    FOnGetLoadedTemplateFileName: TOnGetLoadedTemplateFileName;

    //function GetListOfSetVarEntries: string;
    //procedure SetListOfSetVarEntries(Value: string);

    function GetListOfCustomVariables: string;
    procedure SetListOfCustomVariables(Value: string);

    procedure CreateRemainingUIComponents;
    procedure SetDebuggingInfoAvailable(Value: Boolean);
    procedure TriggerOnControlsModified(AExtraCondition: Boolean = True);

    function DoOnEditCallTemplateBreakCondition(var AActionCondition: string): Boolean;
    function DoOnLoadBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
    function DoOnLoadRenderedBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
    procedure DoOnGetListOfExternallyRenderedImages(AListOfExternallyRenderedImages: TStringList);
    procedure DoOnLoadPrimitivesFile(AFileName: string; var APrimitives: TPrimitiveRecArr; var AOrders: TCompositionOrderArr; var ASettings: TPrimitiveSettings);
    procedure DoOnSavePrimitivesFile(AFileName: string; var APrimitives: TPrimitiveRecArr; var AOrders: TCompositionOrderArr; var ASettings: TPrimitiveSettings);
    function DoOnFileExists(const AFileName: string): Boolean;

    procedure DoOnSetOpenDialogMultiSelect;
    procedure DoOnSetOpenDialogInitialDir(AInitialDir: string);
    function DoOnOpenDialogExecute(AFilter: string): Boolean;
    function DoOnGetOpenDialogFileName: string;
    procedure DoOnSetSaveDialogInitialDir(AInitialDir: string);
    function DoOnSaveDialogExecute(AFilter: string): Boolean;
    function DoOnGetSaveDialogFileName: string;
    procedure DoOnSetSaveDialogFileName(AFileName: string);

    procedure DoOnSetPictureSetOpenDialogMultiSelect;
    procedure DoOnSetPictureOpenDialogInitialDir(AInitialDir: string);
    function DoOnPictureOpenDialogExecute: Boolean;
    function DoOnGetPictureOpenDialogFileName: string;

    function DoOnExecuteFindSubControlAction(AErrorLevel, AErrorCount, AFastSearchErrorCount: Integer; AFontName: string; AFontSize: Integer; out AFoundArea: TRect): Boolean;
    procedure DoOnAddToLog(s: string);
    procedure DoOnGetFontFinderSettings(var AFontFinderSettings: TFontFinderSettings);
    procedure DoOnSetFontFinderSettings(var AFontFinderSettings: TFontFinderSettings);

    procedure DoOnGetListOfAvailableSetVarActions(AListOfSetVarActions: TStringList);
    procedure DoOnGetListOfAvailableActions(AListOfActions: TStringList);
    procedure DoOnModifyPluginProperty(AAction: PClkActionRec);

    procedure DoOnPluginDbgStop;
    procedure DoOnPluginDbgContinueAll;
    procedure DoOnPluginDbgStepOver;
    function DoOnPluginDbgRequestLineNumber(out ALineContent, ADbgSymFile: string): Integer;
    procedure DoOnPluginDbgSetBreakpoint(ALineIndex, ASelectedSourceFileIndex: Integer; AEnabled: Boolean);
    function DoOnTClkIniFileCreate(AFileName: string): TClkIniFile;

    function DoOnGetSelfTemplatesDir: string;
    procedure DoOnShowAutoComplete(AEdit: TEdit);
    procedure DoOnUpdateActionScrollIndex(AActionScrollIndex: string);
    function DoOnGetLoadedTemplateFileName: string;

    procedure ClkVariablesOnChange(Sender: TObject);
    procedure AddDecodedVarToNode(ANode: PVirtualNode; ARecursionLevel: Integer);
    procedure CreateSelectionLabelsForResult;
    function GetSubVarByIndex(AMainVarValue: string; ASubVarIndex: Integer): string;
    procedure GetDecodedVarDetails(AParentVarName: string; ASubVarIndex: Integer; out X, Y, W, H: Integer);
    procedure SelectAreaFromDecodedVariable(ANodeData: PVarNodeRec; ASubVarIndex: Integer);

    function GetInMemFS: TInMemFileSystem;
    procedure SetInMemFS(Value: TInMemFileSystem);
    function GetExtRenderingInMemFS: TInMemFileSystem;
    procedure SetExtRenderingInMemFS(Value: TInMemFileSystem);

    procedure SetLabelsFromMouseOverExecDbgImgPixelColor(APixelColor: TColor);

    function GetCurrentlyEditingActionType: TClkAction;
    procedure SetCurrentlyEditingActionType(Value: TClkAction);

    procedure SetGridDrawingOption(Value: TDisplayGridLineOption);
    procedure SetPreviewSelectionColors(Value: TSelectionColors);
    function GetModifiedPmtvFiles: Boolean;

    procedure LocalTemplatesClick(Sender: TObject);
    procedure AvailableSetVarClick(Sender: TObject);
    procedure AvailablePluginPropertiesClick(Sender: TObject);
    procedure BrowseTemplatesClick(Sender: TObject);
    procedure ClickerConditionEditorControlsModified;
    procedure OverlapGridImgOnDebugImg(ADebugAndGridBitmap: TBitmap);
    procedure CopyTextAndClassFromExternalProvider(AProviderName: string);
    procedure SetActionTimeoutToValue(AValue: Integer);
    function GetIndexOfFirstModifiedPmtvFile: Integer;
    function GetIndexOfCurrentlyEditingPrimitivesFile: Integer;

    function AddFontProfileToActionFromMenu(AForegroundColor, ABackgroundColor, AFontName: string; AFontSize: Integer; AFontQuality: TFontQuality): Integer;
    function GetUniqueProfileName(n: Integer): string;

    function DummyEvaluateReplacements(VarName: string; Recursive: Boolean = True): string; //returns VarName

    procedure HandleOnUpdateBitmapAlgorithmSettings;
    procedure HandleOnTriggerOnControlsModified;
    function HandleOnEvaluateReplacements(s: string): string;
    function HandleOnReverseEvaluateReplacements(s: string): string;
    procedure HandleOnCopyControlTextAndClassFromMainWindow(ACompProvider: string; out AControlText, AControlClass: string);
    function HandleOnGetExtraSearchAreaDebuggingImage(AExtraBitmap: TBitmap): Boolean;

    function HandleOnLoadBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
    function HandleOnLoadRenderedBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
    procedure HandleOnGetListOfExternallyRenderedImages(AListOfExternallyRenderedImages: TStringList);
    function HandleOnFileExists(const AFileName: string): Boolean;
    procedure HandleOnSetPictureOpenDialogInitialDir(AInitialDir: string);
    function HandleOnPictureOpenDialogExecute: Boolean;
    function HandleOnGetPictureOpenDialogFileName: string;

    procedure HandleOnUpdateSearchAreaLimitsInOIFromDraggingLines(ALimitLabelsToUpdate: TLimitLabels; var AOffsets: TSimpleRectString);
    procedure HandleOnUpdateTextCroppingLimitsInOIFromDraggingLines(ALimitLabelsToUpdate: TLimitLabels; var AOffsets: TSimpleRectString; AFontProfileIndex: Integer);
    function HandleOnGetDisplayedText: string;
    procedure HandleOnSetMatchTextAndClassToOI(AMatchText, AMatchClassName: string);
    function HandleOnGetFindControlOptions: PClkFindControlOptions;

    function HandleOnExecuteFindSubControlAction(AErrorLevel, AErrorCount, AFastSearchErrorCount: Integer; AFontName: string; AFontSize: Integer; out AFoundArea: TRect): Boolean;
    procedure HandleOnAddToLog(s: string);

    procedure HandleOnClickerExecAppFrame_OnTriggerOnControlsModified;
    procedure HandleOnClickerSetVarFrame_OnTriggerOnControlsModified;
    function HandleOnClickerSetVarFrame_OnGetFullTemplatesDir: string;
    function HandleOnClickerSetVarFrame_OnGetSelfTemplatesDir: string;
    procedure HandleOnClickerSetVarFrame_OnShowAutoComplete(AEdit: TEdit);
    procedure HandleOnClickerCallTemplateFrame_OnTriggerOnControlsModified;

    function HandleOnEvaluateReplacementsFunc(s: string; Recursive: Boolean = True): string;
    procedure HandleOnLoadPrimitivesFile(AFileName: string; var APrimitives: TPrimitiveRecArr; var AOrders: TCompositionOrderArr; var ASettings: TPrimitiveSettings);
    procedure HandleOnSavePrimitivesFile(AFileName: string; var APrimitives: TPrimitiveRecArr; var AOrders: TCompositionOrderArr; var ASettings: TPrimitiveSettings);
    procedure HandleOnPrimitivesTriggerOnControlsModified;
    procedure HandleOnSaveFromMenu(Sender: TObject);
    procedure HandleOnGetFontFinderSettings(var AFontFinderSettings: TFontFinderSettings);
    procedure HandleOnSetFontFinderSettings(var AFontFinderSettings: TFontFinderSettings);

    procedure HandleOnPluginDbgStop;
    procedure HandleOnPluginDbgContinueAll;
    procedure HandleOnPluginDbgStepOver;
    function HandleOnPluginDbgRequestLineNumber(out ALineContent, ADbgSymFile: string): Integer;
    procedure HandleOnPluginDbgSetBreakpoint(ALineIndex, ASelectedSourceFileIndex: Integer; AEnabled: Boolean);

    function HandleOnTClkIniFileCreate(AFileName: string): TClkIniFile;

    ///////////////////////////// OI
    function EditFontProperties(AItemIndexDiv: Integer; var ANewItems: string): Boolean;

    procedure FreeOIPopupMenu(Sender: TObject);
    procedure BuildFontColorIconsList;

    function HandleOnOIGetCategoryCount: Integer;
    function HandleOnOIGetCategory(AIndex: Integer): string;
    function HandleOnOIGetPropertyCount(ACategoryIndex: Integer): Integer;
    function HandleOnOIGetPropertyName(ACategoryIndex, APropertyIndex: Integer): string;
    function HandleOnOIGetPropertyValue(ACategoryIndex, APropertyIndex: Integer; var AEditorType: TOIEditorType): string;
    function HandleOnOIGetListPropertyItemCount(ACategoryIndex, APropertyIndex: Integer): Integer;
    function HandleOnOIGetListPropertyItemName(ACategoryIndex, APropertyIndex, AItemIndex: Integer): string;
    function HandleOnOIGetListPropertyItemValue(ACategoryIndex, APropertyIndex, AItemIndex: Integer; var AEditorType: TOIEditorType): string;
    function HandleOnUIGetDataTypeName(ACategoryIndex, APropertyIndex, AItemIndex: Integer): string;
    function HandleOnUIGetExtraInfo(ACategoryIndex, APropertyIndex, AItemIndex: Integer): string;

    procedure HandleOnOIGetImageIndexEx(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer; var ImageList: TCustomImageList);
    procedure HandleOnOIEditedText(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; ANewText: string);
    function HandleOnOIEditItems(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; var ANewItems: string): Boolean;

    function HandleOnOIGetColorConstsCount(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer): Integer;
    procedure HandleOnOIGetColorConst(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex, AColorItemIndex: Integer; var AColorName: string; var AColorValue: Int64);

    function HandleOnOIGetEnumConstsCount(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer): Integer;
    procedure HandleOnOIGetEnumConst(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex, AEnumItemIndex: Integer; var AEnumItemName: string);

    procedure HandleOnOIPaintText(ANodeData: TNodeDataPropertyRec; ACategoryIndex, APropertyIndex, APropertyItemIndex: Integer;
      const TargetCanvas: TCanvas; Column: TColumnIndex; var TextType: TVSTTextType);

    procedure HandleOnOIBeforeCellPaint(ANodeData: TNodeDataPropertyRec; ACategoryIndex, APropertyIndex, APropertyItemIndex: Integer;
      TargetCanvas: TCanvas; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);

    procedure HandleOnOIAfterCellPaint(ANodeData: TNodeDataPropertyRec; ACategoryIndex, APropertyIndex, APropertyItemIndex: Integer;
      TargetCanvas: TCanvas; Column: TColumnIndex; const CellRect: TRect);

    procedure HandleOnTextEditorMouseDown(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
      Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    function HandleOnTextEditorMouseMove(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
      Sender: TObject; Shift: TShiftState; X, Y: Integer): Boolean;

    procedure HandleOnOITextEditorKeyUp(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
      Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure HandleOnOITextEditorKeyDown(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
      Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure HandleOnOIEditorAssignMenuAndTooltip(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
      Sender: TObject; var APopupMenu: TPopupMenu; var AHint: string; var AShowHint: Boolean);

    procedure HandleOnOIGetFileDialogSettings(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; var AFilter, AInitDir: string);
    procedure HandleOnOIArrowEditorClick(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer);
    procedure HandleOnOIUserEditorClick(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; var ARepaintValue: Boolean);

    function HandleOnOIBrowseFile(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
      AFilter, ADialogInitDir: string; var Handled: Boolean; AReturnMultipleFiles: Boolean = False): string;

    procedure HandleOnOIAfterSpinTextEditorChanging(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; var ANewValue: string);
    procedure HandleOnOISelectedNode(NodeLevel, CategoryIndex, PropertyIndex, PropertyItemIndex, Column: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HandleOnOIFirstVisibleNode(NodeLevel, CategoryIndex, PropertyIndex, PropertyItemIndex: Integer);
  public
    { Public declarations }
    frClickerConditionEditor: TfrClickerConditionEditor;  //public, because it is accessed from outside :(
    frClickerFindControl: TfrClickerFindControl;
    frClickerExecApp: TfrClickerExecApp;
    frClickerSetVar: TfrClickerSetVar;
    frClickerCallTemplate: TfrClickerCallTemplate;
    frClickerSleep: TfrClickerSleep;
    frClickerPlugin: TfrClickerPlugin;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function EvaluateReplacements(VarName: string; Recursive: Boolean = True): string;
    function ReverseEvaluateReplacements(AValue: string): string;

    procedure LoadListOfAvailableTemplates;
    procedure LoadListOfAvailableSetVarActions;
    procedure LoadListOfAvailableActionsForPlugin(APropertyIndexToUpdate: Integer);
    procedure SetDebugVariablesFromListOfStrings(AListOfStrings: string);
    procedure UpdatePageControlActionExecutionIcons;
    procedure UpdateControlWidthHeightLabels;
    procedure UpdateUseWholeScreenLabel(AUseWholeScreen: Boolean);
    procedure RefreshActionName; //called by action list, when modifying the action name from there
    procedure ResetAllPmtvModifiedFlags; //called when users select a diffeent action from the one with modified pmtv files
    procedure ResizeFrameSectionsBySplitter(NewLeft: Integer);
    procedure ResizeFrameSectionsBySplitterResults(NewLeft: Integer);
    procedure BringOIPropertyIntoView(NodeLevel, CategoryIndex, PropertyIndex, PropertyItemIndex: Integer);

    procedure ClearControls;

    property BMPsDir: string read FBMPsDir write FBMPsDir;  /////////////////////////// to be removed
    property ControlsModified: Boolean read FControlsModified write FControlsModified;
    property OnControlsModified: TNotifyEvent read FOnControlsModified write FOnControlsModified;
    property PredefinedVarCount: Integer read FPredefinedVarCount write FPredefinedVarCount;
    property DebuggingInfoAvailable: Boolean write SetDebuggingInfoAvailable;
    property FullTemplatesDir: string read FFullTemplatesDir write FFullTemplatesDir;  //no trailing backslash
    //property ListOfSetVarEntries: string read GetListOfSetVarEntries write SetListOfSetVarEntries;

    property ListOfCustomVariables: string read GetListOfCustomVariables write SetListOfCustomVariables;
    property InMemFS: TInMemFileSystem read GetInMemFS write SetInMemFS;
    property ExtRenderingInMemFS: TInMemFileSystem read GetExtRenderingInMemFS write SetExtRenderingInMemFS;

    property CurrentlyEditingActionType: TClkAction read GetCurrentlyEditingActionType write SetCurrentlyEditingActionType;
    property EditingAction: PClkActionRec read FEditingAction; //the pointer is not writable from outside, only the content

    property GridDrawingOption: TDisplayGridLineOption write SetGridDrawingOption;
    property PreviewSelectionColors: TSelectionColors write SetPreviewSelectionColors;
    property ModifiedPmtvFiles: Boolean read GetModifiedPmtvFiles;

    property ClkVariables: TStringList read FClkVariables;

    property OnCopyControlTextAndClassFromMainWindow: TOnCopyControlTextAndClassFromMainWindow read FOnCopyControlTextAndClassFromMainWindow write FOnCopyControlTextAndClassFromMainWindow;
    property OnGetExtraSearchAreaDebuggingImage: TOnGetExtraSearchAreaDebuggingImage write FOnGetExtraSearchAreaDebuggingImage;
    property OnEditCallTemplateBreakCondition: TOnEditActionCondition write FOnEditCallTemplateBreakCondition;

    property OnLoadBitmap: TOnLoadBitmap write FOnLoadBitmap;
    property OnLoadRenderedBitmap: TOnLoadRenderedBitmap write FOnLoadRenderedBitmap;
    property OnGetListOfExternallyRenderedImages: TOnGetListOfExternallyRenderedImages write FOnGetListOfExternallyRenderedImages;
    property OnLoadPrimitivesFile: TOnLoadPrimitivesFile write FOnLoadPrimitivesFile;
    property OnSavePrimitivesFile: TOnSavePrimitivesFile write FOnSavePrimitivesFile;
    property OnFileExists: TOnFileExists write FOnFileExists;

    property OnSetOpenDialogMultiSelect: TOnSetOpenDialogMultiSelect write FOnSetOpenDialogMultiSelect;
    property OnSetOpenDialogInitialDir: TOnSetOpenDialogInitialDir write FOnSetOpenDialogInitialDir;
    property OnOpenDialogExecute: TOnOpenDialogExecute write FOnOpenDialogExecute;
    property OnGetOpenDialogFileName: TOnGetOpenDialogFileName write FOnGetOpenDialogFileName;
    property OnSetSaveDialogInitialDir: TOnSetOpenDialogInitialDir write FOnSetSaveDialogInitialDir;
    property OnSaveDialogExecute: TOnOpenDialogExecute write FOnSaveDialogExecute;
    property OnGetSaveDialogFileName: TOnGetOpenDialogFileName write FOnGetSaveDialogFileName;
    property OnSetSaveDialogFileName: TOnSetOpenDialogFileName write FOnSetSaveDialogFileName;

    property OnSetPictureSetOpenDialogMultiSelect: TOnSetPictureSetOpenDialogMultiSelect write FOnSetPictureSetOpenDialogMultiSelect;
    property OnSetPictureOpenDialogInitialDir: TOnSetPictureOpenDialogInitialDir write FOnSetPictureOpenDialogInitialDir;
    property OnPictureOpenDialogExecute: TOnPictureOpenDialogExecute write FOnPictureOpenDialogExecute;
    property OnGetPictureOpenDialogFileName: TOnGetPictureOpenDialogFileName write FOnGetPictureOpenDialogFileName;

    property OnExecuteFindSubControlAction: TOnExecuteFindSubControlAction write FOnExecuteFindSubControlAction;
    property OnAddToLog: TOnAddToLog write FOnAddToLog;
    property OnGetFontFinderSettings: TOnRWFontFinderSettings write FOnGetFontFinderSettings;
    property OnSetFontFinderSettings: TOnRWFontFinderSettings write FOnSetFontFinderSettings;

    property OnGetListOfAvailableSetVarActions: TOnGetListOfAvailableSetVarActions write FOnGetListOfAvailableSetVarActions;
    property OnGetListOfAvailableActions: TOnGetListOfAvailableActions write FOnGetListOfAvailableActions;
    property OnModifyPluginProperty: TOnModifyPluginProperty write FOnModifyPluginProperty;

    property OnPluginDbgStop: TOnPluginDbgStop write FOnPluginDbgStop;
    property OnPluginDbgContinueAll: TOnPluginDbgContinueAll write FOnPluginDbgContinueAll;
    property OnPluginDbgStepOver: TOnPluginDbgStepOver write FOnPluginDbgStepOver;
    property OnPluginDbgRequestLineNumber: TOnPluginDbgRequestLineNumber write FOnPluginDbgRequestLineNumber;
    property OnPluginDbgSetBreakpoint: TOnPluginDbgSetBreakpoint write FOnPluginDbgSetBreakpoint;
    property OnTClkIniFileCreate: TOnTClkIniFileCreate write FOnTClkIniFileCreate;

    property OnGetSelfTemplatesDir: TOnGetFullTemplatesDir write FOnGetSelfTemplatesDir;
    property OnShowAutoComplete: TOnShowAutoComplete write FOnShowAutoComplete;
    property OnUpdateActionScrollIndex: TOnUpdateActionScrollIndex write FOnUpdateActionScrollIndex;
    property OnGetLoadedTemplateFileName: TOnGetLoadedTemplateFileName write FOnGetLoadedTemplateFileName;
  end;


const
  CXClickPointReference: array[Low(TXClickPointReference)..High(TXClickPointReference)] of string = ('Control Left', 'Control Right', 'Control Width', 'Var', 'Screen Absolute X');
  CYClickPointReference: array[Low(TYClickPointReference)..High(TYClickPointReference)] of string = ('Control Top', 'Control Bottom', 'Control Height', 'Var', 'Screen Absolute Y');
  {$IFDEF FPC}
    ID_YES = IDYES;  //from Delphi
  {$ENDIF}

  COIScrollInfo_NodeLevel = 'NodeLevel';
  COIScrollInfo_CategoryIndex = 'CategoryIndex';
  COIScrollInfo_PropertyIndex = 'PropertyIndex';
  COIScrollInfo_PropertyItemIndex = 'PropertyItemIndex';


function ActionStatusStrToActionStatus(AString: string): TActionStatus;  

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.frm}
{$ENDIF}


uses
  Clipbrd, ClickerActionValues, ClickerOIUtils, ClickerZoomPreviewForm,
  ClickerActionPluginLoader, ClickerActionPlugins, InMemFileSystemBrowserForm,
  ClickerExtraUtils;


function ActionStatusStrToActionStatus(AString: string): TActionStatus;
var
  i: TActionStatus;
begin
  Result := asNotStarted;
  for i := Low(TActionStatus) to High(TActionStatus) do
    if CActionStatusStr[i] = AString then
    begin
      Result := i;
      Exit;
    end;
end;


procedure TfrClickerActions.ClickerConditionEditorControlsModified;
begin
  FEditingAction^.ActionOptions.ActionCondition := frClickerConditionEditor.GetActionCondition;
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.CreateRemainingUIComponents;
begin
  frClickerFindControl := TfrClickerFindControl.Create(Self);
  frClickerFindControl.Parent := pnlExtra;

  frClickerFindControl.Left := 3;
  frClickerFindControl.Top := 3;
  frClickerFindControl.Width := 877;
  frClickerFindControl.Height := 201;
  frClickerFindControl.Anchors := [akLeft, akTop, akBottom, akRight];
  frClickerFindControl.OnUpdateBitmapAlgorithmSettings := HandleOnUpdateBitmapAlgorithmSettings;
  frClickerFindControl.OnTriggerOnControlsModified := HandleOnTriggerOnControlsModified;
  frClickerFindControl.OnEvaluateReplacements := HandleOnEvaluateReplacements;
  frClickerFindControl.OnReverseEvaluateReplacements := HandleOnReverseEvaluateReplacements;
  frClickerFindControl.OnCopyControlTextAndClassFromMainWindow := HandleOnCopyControlTextAndClassFromMainWindow;
  frClickerFindControl.OnGetExtraSearchAreaDebuggingImage := HandleOnGetExtraSearchAreaDebuggingImage;
  frClickerFindControl.OnLoadBitmap := HandleOnLoadBitmap;
  //frClickerFindControl.OnLoadRenderedBitmap := HandleOnLoadRenderedBitmap;
  frClickerFindControl.OnFileExists := HandleOnFileExists;
  frClickerFindControl.OnSetPictureOpenDialogInitialDir := HandleOnSetPictureOpenDialogInitialDir;
  frClickerFindControl.OnPictureOpenDialogExecute := HandleOnPictureOpenDialogExecute;
  frClickerFindControl.OnGetPictureOpenDialogFileName := HandleOnGetPictureOpenDialogFileName;
  frClickerFindControl.OnUpdateSearchAreaLimitsInOIFromDraggingLines := HandleOnUpdateSearchAreaLimitsInOIFromDraggingLines;
  frClickerFindControl.OnUpdateTextCroppingLimitsInOIFromDraggingLines := HandleOnUpdateTextCroppingLimitsInOIFromDraggingLines;
  frClickerFindControl.OnGetDisplayedText := HandleOnGetDisplayedText;
  frClickerFindControl.OnSetMatchTextAndClassToOI := HandleOnSetMatchTextAndClassToOI;
  frClickerFindControl.OnGetFindControlOptions := HandleOnGetFindControlOptions;
  frClickerFindControl.OnExecuteFindSubControlAction := HandleOnExecuteFindSubControlAction;
  frClickerFindControl.OnAddToLog := HandleOnAddToLog;
  frClickerFindControl.OnGetFontFinderSettings := HandleOnGetFontFinderSettings;
  frClickerFindControl.OnSetFontFinderSettings := HandleOnSetFontFinderSettings;

  frClickerFindControl.Visible := False;

  //frClickerFindControl.AddDefaultFontProfile;

  frClickerConditionEditor := TfrClickerConditionEditor.Create(Self);
  frClickerConditionEditor.Parent := pnlActionConditions; //for some reason, using TabSheetCondition leads to a hidden frame

  frClickerConditionEditor.Left := 3;
  frClickerConditionEditor.Top := 3;
  frClickerConditionEditor.Width := pnlActionConditions.Width - 3;
  frClickerConditionEditor.Height := pnlActionConditions.Height - 12;
  frClickerConditionEditor.Anchors := [akBottom, akLeft, akRight, akTop];
  frClickerConditionEditor.OnControlsModified := ClickerConditionEditorControlsModified;
  frClickerConditionEditor.Visible := True;

  frClickerExecApp := TfrClickerExecApp.Create(Self);
  frClickerExecApp.Parent := pnlExtra;
  frClickerExecApp.OnTriggerOnControlsModified := HandleOnClickerExecAppFrame_OnTriggerOnControlsModified;
  frClickerExecApp.Left := 3;
  frClickerExecApp.Top := 3;
  frClickerExecApp.Width := pnlExtra.Width - 3;
  frClickerExecApp.Height := pnlExtra.Height - 3;
  frClickerExecApp.Visible := False;

  frClickerSetVar := TfrClickerSetVar.Create(Self);
  frClickerSetVar.Parent := pnlExtra;
  frClickerSetVar.OnTriggerOnControlsModified := HandleOnClickerSetVarFrame_OnTriggerOnControlsModified;
  frClickerSetVar.OnGetFullTemplatesDir := HandleOnClickerSetVarFrame_OnGetFullTemplatesDir;
  frClickerSetVar.OnGetSelfTemplatesDir := HandleOnClickerSetVarFrame_OnGetSelfTemplatesDir;
  frClickerSetVar.OnShowAutoComplete := HandleOnClickerSetVarFrame_OnShowAutoComplete;
  frClickerSetVar.Left := 3;
  frClickerSetVar.Top := 3;
  frClickerSetVar.Width := pnlExtra.Width - 3;
  frClickerSetVar.Height := pnlExtra.Height - 3;
  frClickerSetVar.Visible := False;

  frClickerCallTemplate := TfrClickerCallTemplate.Create(Self);
  frClickerCallTemplate.Parent := pnlExtra;
  frClickerCallTemplate.OnTriggerOnControlsModified := HandleOnClickerCallTemplateFrame_OnTriggerOnControlsModified;
  frClickerCallTemplate.Left := 3;
  frClickerCallTemplate.Top := 3;
  frClickerCallTemplate.Width := pnlExtra.Width - 3;
  frClickerCallTemplate.Height := pnlExtra.Height - 3;
  frClickerCallTemplate.Visible := False;
  frClickerCallTemplate.Anchors := [akBottom, akLeft, akRight, akTop];

  frClickerSleep := TfrClickerSleep.Create(Self);
  frClickerSleep.Parent := pnlExtra;
  frClickerSleep.Left := 3;
  frClickerSleep.Top := 3;
  frClickerSleep.Width := pnlExtra.Width - 3;
  frClickerSleep.Height := pnlExtra.Height - 3;
  frClickerSleep.Visible := False;

  frClickerPlugin := TfrClickerPlugin.Create(Self);
  frClickerPlugin.Parent := pnlExtra;
  frClickerPlugin.Left := 3;
  frClickerPlugin.Top := 3;
  frClickerPlugin.Width := pnlExtra.Width - 3;
  frClickerPlugin.Height := pnlExtra.Height - 3;
  frClickerPlugin.Anchors := [akLeft, akTop, akBottom, akRight];
  frClickerPlugin.Visible := False;
  frClickerPlugin.OnPluginDbgStop := HandleOnPluginDbgStop;
  frClickerPlugin.OnPluginDbgContinueAll := HandleOnPluginDbgContinueAll;
  frClickerPlugin.OnPluginDbgStepOver := HandleOnPluginDbgStepOver;
  frClickerPlugin.OnPluginDbgRequestLineNumber := HandleOnPluginDbgRequestLineNumber;
  frClickerPlugin.OnPluginDbgSetBreakpoint := HandleOnPluginDbgSetBreakpoint;
  frClickerPlugin.OnTClkIniFileCreate := HandleOnTClkIniFileCreate;

  FPmLocalTemplates := TPopupMenu.Create(Self);

  ////////////////////////////// OI
  FOIFrame := TfrObjectInspector.Create(Self);
  FOIFrame.Parent := pnlvstOI;
  FOIFrame.Left := 0;
  FOIFrame.Top := 0;
  FOIFrame.Width := pnlvstOI.Width;
  FOIFrame.Height := pnlvstOI.Height;
  FOIFrame.Anchors := [akBottom, akLeft, akRight, akTop];

  pnlvstOI.Anchors := [akBottom, akLeft, akRight, akTop];

  FOIFrame.OnOIGetCategoryCount := HandleOnOIGetCategoryCount;
  FOIFrame.OnOIGetCategory := HandleOnOIGetCategory;
  FOIFrame.OnOIGetPropertyCount := HandleOnOIGetPropertyCount;
  FOIFrame.OnOIGetPropertyName := HandleOnOIGetPropertyName;
  FOIFrame.OnOIGetPropertyValue := HandleOnOIGetPropertyValue;
  FOIFrame.OnOIGetListPropertyItemCount := HandleOnOIGetListPropertyItemCount;
  FOIFrame.OnOIGetListPropertyItemName := HandleOnOIGetListPropertyItemName;
  FOIFrame.OnOIGetListPropertyItemValue := HandleOnOIGetListPropertyItemValue;
  FOIFrame.OnUIGetDataTypeName := HandleOnUIGetDataTypeName;
  FOIFrame.OnUIGetExtraInfo := HandleOnUIGetExtraInfo;
  FOIFrame.OnOIGetImageIndexEx := HandleOnOIGetImageIndexEx;
  FOIFrame.OnOIEditedText := HandleOnOIEditedText;
  FOIFrame.OnOIEditItems := HandleOnOIEditItems;
  FOIFrame.OnOIGetColorConstsCount := HandleOnOIGetColorConstsCount;
  FOIFrame.OnOIGetColorConst := HandleOnOIGetColorConst;
  FOIFrame.OnOIGetEnumConstsCount := HandleOnOIGetEnumConstsCount;
  FOIFrame.OnOIGetEnumConst := HandleOnOIGetEnumConst;
  FOIFrame.OnOIPaintText := HandleOnOIPaintText;
  FOIFrame.OnOIBeforeCellPaint := HandleOnOIBeforeCellPaint;
  FOIFrame.OnOIAfterCellPaint := HandleOnOIAfterCellPaint;
  FOIFrame.OnOITextEditorMouseDown := HandleOnTextEditorMouseDown;
  FOIFrame.OnOITextEditorMouseMove := HandleOnTextEditorMouseMove;
  FOIFrame.OnOITextEditorKeyUp := HandleOnOITextEditorKeyUp;
  FOIFrame.OnOITextEditorKeyDown := HandleOnOITextEditorKeyDown;
  FOIFrame.OnOIEditorAssignMenuAndTooltip := HandleOnOIEditorAssignMenuAndTooltip;
  FOIFrame.OnOIGetFileDialogSettings := HandleOnOIGetFileDialogSettings;
  FOIFrame.OnOIArrowEditorClick := HandleOnOIArrowEditorClick;
  FOIFrame.OnOIUserEditorClick := HandleOnOIUserEditorClick;
  FOIFrame.OnOIBrowseFile := HandleOnOIBrowseFile;
  FOIFrame.OnOIAfterSpinTextEditorChanging := HandleOnOIAfterSpinTextEditorChanging;
  FOIFrame.OnOISelectedNode := HandleOnOISelectedNode;
  FOIFrame.OnOIFirstVisibleNode := HandleOnOIFirstVisibleNode;

  FOIFrame.Visible := True;

  FOIFrame.ListItemsVisible := True;
  FOIFrame.DataTypeVisible := True; //False;
  FOIFrame.ExtraInfoVisible := False;
  FOIFrame.PropertyItemHeight := 22; //50;  //this should be 50 for bitmaps

  //FOIFrame.ReloadContent;  //set by ActionType combobox
  pnlvstOI.Visible := True;
end;



constructor TfrClickerActions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateRemainingUIComponents;

  FFullTemplatesDir := 'Non-existentFolder'; //ExtractFilePath(ParamStr(0)) + 'ActionTemplates'; //init value can be overridden by external wrapper
  FHold := False;
  FHoldResults := False;
  FEditingText := '';

  FSearchAreaScrBox := nil;
  FSearchAreaSearchedBmpDbgImg := nil;
  FSearchAreaSearchedTextDbgImg := nil;
  FSetVarContent_Vars := TStringList.Create;
  FSetVarContent_Values := TStringList.Create;
  FSetVarContent_EvalBefore := TStringList.Create;
  FLastClickedTVTEdit := nil;
  FLastClickedEdit := nil;
  FOIEditorMenu := TPopupMenu.Create(Self);
  FClkVariables := TStringList.Create;
  FClkVariables.OnChange := ClkVariablesOnChange;

  FlblResultSelLeft := nil;
  FlblResultSelTop := nil;
  FlblResultSelRight := nil;
  FlblResultSelBottom := nil;

  FOnCopyControlTextAndClassFromMainWindow := nil;
  FOnGetExtraSearchAreaDebuggingImage := nil;
  FOnEditCallTemplateBreakCondition := nil;

  FOnLoadBitmap := nil;
  FOnLoadRenderedBitmap := nil;
  FOnGetListOfExternallyRenderedImages := nil;
  FOnLoadPrimitivesFile := nil;
  FOnSavePrimitivesFile := nil;
  FOnFileExists := nil;

  FOnSetOpenDialogMultiSelect := nil;
  FOnSetOpenDialogInitialDir := nil;
  FOnOpenDialogExecute := nil;
  FOnGetOpenDialogFileName := nil;
  FOnSetSaveDialogInitialDir := nil;
  FOnSaveDialogExecute := nil;
  FOnGetSaveDialogFileName := nil;
  FOnSetSaveDialogFileName := nil;

  FOnSetPictureSetOpenDialogMultiSelect := nil;
  FOnSetPictureOpenDialogInitialDir := nil;
  FOnPictureOpenDialogExecute := nil;
  FOnGetPictureOpenDialogFileName := nil;

  FOnExecuteFindSubControlAction := nil;
  FOnAddToLog := nil;
  FOnGetFontFinderSettings := nil;
  FOnSetFontFinderSettings := nil;

  FOnGetListOfAvailableSetVarActions := nil;
  FOnGetListOfAvailableActions := nil;
  FOnModifyPluginProperty := nil;

  FOnPluginDbgStop := nil;
  FOnPluginDbgContinueAll := nil;
  FOnPluginDbgStepOver := nil;
  FOnPluginDbgRequestLineNumber := nil;
  FOnPluginDbgSetBreakpoint := nil;
  FOnTClkIniFileCreate := nil;

  FOnGetSelfTemplatesDir := nil;
  FOnShowAutoComplete := nil;
  FOnUpdateActionScrollIndex := nil;
  FOnGetLoadedTemplateFileName := nil;

  FShowDeprecatedControls := False;
  FEditingAction := @FEditingActionRec;
  FCurrentlyEditingPrimitiveFileName := '';
  FPrevSelectedPrimitiveNode := -1;

  PageControlActionExecution.ActivePageIndex := 0;
  PageControlActionExecution.Caption := 'ActionExecution';
end;


destructor TfrClickerActions.Destroy;
begin
  FSetVarContent_Vars.Free;
  FSetVarContent_Values.Free;
  FSetVarContent_EvalBefore.Free;
  FOIEditorMenu.Free;
  FreeAndNil(FClkVariables);

  inherited Destroy;
end;


function TfrClickerActions.EvaluateReplacements(VarName: string; Recursive: Boolean = True): string;
begin
  Result := EvaluateAllReplacements(FClkVariables, VarName, Recursive);
end;


function TfrClickerActions.ReverseEvaluateReplacements(AValue: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to FClkVariables.Count - 1 do
    if FClkVariables.ValueFromIndex[i] = AValue then
    begin
      Result := FClkVariables.Names[i];
      Break;
    end;
end;


procedure TfrClickerActions.tmrDrawZoomTimer(Sender: TObject);
var
  tp: TPoint;
begin
  tmrDrawZoom.Enabled := false;
  GetCursorPos(tp);

  if Assigned(imgDebugBmp.Picture.Bitmap) then
    SetZoomContent(imgDebugBmp.Picture.Bitmap, FCurrentMousePosOnPreviewImg.X, FCurrentMousePosOnPreviewImg.Y, tp.X + 50, tp.Y + 50);
end;


procedure TfrClickerActions.tmrEditClkVariablesTimer(Sender: TObject);
var
  TempBounds: TRect;
begin
  tmrEditClkVariables.Enabled := False;
  if FHitInfo.HitNode = nil then
    Exit;

  vstVariables.EditNode(FHitInfo.HitNode, FHitInfo.HitColumn);

  if FHitInfo.HitColumn in [0..1] then
    if Assigned(vstVariables.EditLink) then
    begin
      TempBounds := vstVariables.EditLink.GetBounds;
      TempBounds.Left := TempBounds.Left - 2;
      TempBounds.Right := Max(TempBounds.Right, TempBounds.Left + vstVariables.Header.Columns[FHitInfo.HitColumn].MinWidth);
      vstVariables.EditLink.SetBounds(TempBounds);

      FTextEditorEditBox.Height := vstVariables.DefaultNodeHeight;
    end;
end;


procedure TfrClickerActions.imgDebugBmpMouseEnter(Sender: TObject);
var
  tp: TPoint;
begin
  imgDebugBmp.ShowHint := False;
  GetCursorPos(tp);
  ShowZoom(tp.X + 50, tp.Y + 50);
end;


procedure TfrClickerActions.imgDebugBmpMouseLeave(Sender: TObject);
begin
  imgDebugBmp.ShowHint := True;
  HideZoom;
end;


procedure TfrClickerActions.imgDebugBmpMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lblDebugBitmapXMouseOffset.Caption := 'mx: ' + IntToStr(X);
  lblDebugBitmapYMouseOffset.Caption := 'my: ' + IntToStr(Y);
  SetLabelsFromMouseOverExecDbgImgPixelColor(imgDebugBmp.Canvas.Pixels[X, Y]);

  FCurrentMousePosOnPreviewImg.X := X;
  FCurrentMousePosOnPreviewImg.Y := Y;
  tmrDrawZoom.Enabled := True;
end;


procedure TfrClickerActions.FlblResultSelVertMouseEnter(Sender: TObject);
var
  tp: TPoint;
begin
  imgDebugBmp.ShowHint := False;
  GetCursorPos(tp);
  ShowZoom(tp.X + 50, tp.Y + 50);
end;


procedure TfrClickerActions.FlblResultSelVertMouseLeave(Sender: TObject);
begin
  imgDebugBmp.ShowHint := True;
  HideZoom;
end;


procedure TfrClickerActions.FlblResultSelVertMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDebugBitmapXMouseOffset.Caption := 'mx: ' + IntToStr((Sender as TLabel).Left);
  lblDebugBitmapYMouseOffset.Caption := 'my: ' + IntToStr(Y);
  SetLabelsFromMouseOverExecDbgImgPixelColor(imgDebugBmp.Canvas.Pixels[X, Y]);

  FCurrentMousePosOnPreviewImg.X := (Sender as TLabel).Left;
  FCurrentMousePosOnPreviewImg.Y := Y;
  tmrDrawZoom.Enabled := True;
end;


procedure TfrClickerActions.FlblResultSelHorizMouseEnter(Sender: TObject);
var
  tp: TPoint;
begin
  imgDebugBmp.ShowHint := False;
  GetCursorPos(tp);
  ShowZoom(tp.X + 50, tp.Y + 50);
end;


procedure TfrClickerActions.FlblResultSelHorizMouseLeave(Sender: TObject);
begin
  imgDebugBmp.ShowHint := True;
  HideZoom;
end;


procedure TfrClickerActions.FlblResultSelHorizMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDebugBitmapXMouseOffset.Caption := 'mx: ' + IntToStr(X);
  lblDebugBitmapYMouseOffset.Caption := 'my: ' + IntToStr((Sender as TLabel).Top);
  SetLabelsFromMouseOverExecDbgImgPixelColor(imgDebugBmp.Canvas.Pixels[X, Y]);

  FCurrentMousePosOnPreviewImg.X := X;
  FCurrentMousePosOnPreviewImg.Y := (Sender as TLabel).Top;
  tmrDrawZoom.Enabled := True;
end;


procedure TfrClickerActions.rdgrpSearchForControlModeClick(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.ClkVariablesOnChange(Sender: TObject);
begin
  tmrClkVariables.Enabled := True;
end;


procedure TfrClickerActions.RemoveVariable1Click(Sender: TObject);
var
  Node: PVirtualNode;
begin
  Node := vstVariables.GetFirstSelected;
  if Node = nil then
  begin
    MessageBox(Handle, 'Please select a variable to be removed.', PChar(Application.Title), MB_ICONINFORMATION);
    Exit;
  end;

  if Integer(Node^.Index) < FPredefinedVarCount - 1 then
  begin
    MessageBox(Handle, 'Predefined variables are required.', PChar(Application.Title), MB_ICONINFORMATION);
    Exit;
  end;

  if MessageBox(Handle, PChar('Remove variable?' + #13#10 + FClkVariables.Strings[Node^.Index]), PChar(Application.Title), MB_ICONQUESTION + MB_YESNO) = IDNO then
    Exit;

  vstVariables.Enabled := False;
  try
    FClkVariables.Delete(Node^.Index);
  finally
    vstVariables.RootNodeCount := vstVariables.RootNodeCount - 1;
    vstVariables.Repaint;
    vstVariables.Enabled := True;
  end;
end;


procedure TfrClickerActions.chkShowDebugGridClick(Sender: TObject);
begin
  imgDebugGrid.Visible := chkShowDebugGrid.Checked;
end;


procedure TfrClickerActions.MenuItemEraseDebugImageClick(Sender: TObject);
begin
  if MessageBox(Handle, 'Are you sure you want to erase the current image?', PChar(Caption), MB_ICONQUESTION + MB_YESNO) = IDNO then
    Exit;

  imgDebugBmp.Canvas.Pen.Color := clWhite;
  imgDebugBmp.Canvas.Brush.Color := clWhite;
  imgDebugBmp.Canvas.Brush.Style := bsSolid;
  imgDebugBmp.Canvas.Rectangle(0, 0, imgDebugBmp.Width, imgDebugBmp.Height);
  imgDebugBmp.Repaint;

  //imgDebugGrid does not have to be cleared
end;


procedure TfrClickerActions.SetDebugVariablesFromListOfStrings(AListOfStrings: string);
var
  AStringList: TStringList;
  i: Integer;
  KeyValue, Key, Value: string;
begin
  AStringList := TStringList.Create;
  try
    AStringList.Text := AListOfStrings;
    for i := 0 to AStringList.Count - 1 do
    begin
      KeyValue := AStringList.Strings[i];
      Key := Copy(KeyValue, 1, Pos('=', KeyValue) - 1);
      Value := Copy(KeyValue, Pos('=', KeyValue) + 1, MaxInt);

      FClkVariables.Values[Key] := Value;
    end;  
  finally
    AStringList.Free;
  end;
end;


procedure TfrClickerActions.CopyDebugValuesListToClipboard1Click(
  Sender: TObject);
begin
  Clipboard.AsText := FClkVariables.Text;
end;


procedure TfrClickerActions.PasteDebugValuesListFromClipboard1Click(
  Sender: TObject);
begin
  SetDebugVariablesFromListOfStrings(Clipboard.AsText);
end;


procedure TfrClickerActions.PasteDebugValuesListFromMainExecutionList1Click(
  Sender: TObject);
begin
  // Only a placeholder here. This should be implemented where MainExecutionList is available (in children).
end;


procedure TfrClickerActions.lbeMatchTextSeparatorChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeSearchRectBottomChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeSearchRectBottomOffsetChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeSearchRectLeftChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeSearchRectLeftOffsetChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeSearchRectRightChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeSearchRectRightOffsetChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeSearchRectTopChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeSearchRectTopOffsetChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


function TfrClickerActions.GetListOfCustomVariables: string;
begin
  Result := frClickerCallTemplate.GetListOfCustomVariables;
end;


procedure TfrClickerActions.SetListOfCustomVariables(Value: string);
begin
  frClickerCallTemplate.SetListOfCustomVariables(Value);
end;


procedure TfrClickerActions.lbeMatchClassNameChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeMatchClassNameSeparatorChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.SetLabelsFromMouseOverExecDbgImgPixelColor(APixelColor: TColor);
begin
  lblMouseOnExecDbgImgRR.Caption := IntToHex(APixelColor and $FF, 2);
  lblMouseOnExecDbgImgGG.Caption := IntToHex(APixelColor shr 8 and $FF, 2);
  lblMouseOnExecDbgImgBB.Caption := IntToHex(APixelColor shr 16 and $FF, 2);
end;


procedure TfrClickerActions.chkWaitForControlToGoAwayChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.AddDecodedVarToNode(ANode: PVirtualNode; ARecursionLevel: Integer);
var
  Node: PVirtualNode;
  ChNode: PVirtualNode;
  NodeData: PVarNodeRec;
  ChNodeData: PVarNodeRec;
  i: Integer;
  SubVars: TStringList;
begin
  NodeData := vstVariables.GetNodeData(ANode);
  NodeData^.VarName := FClkVariables.Names[ANode^.Index];
  NodeData^.VarValue := FClkVariables.ValueFromIndex[ANode^.Index];

  SubVars := TStringList.Create;
  try
    SubVars.Text := FastReplace_45ToReturn(NodeData^.VarValue);
    for i := 0 to SubVars.Count - 1 do
    begin
      ChNode := vstVariables.AddChild(ANode);
      ChNodeData := vstVariables.GetNodeData(ChNode);
      ChNodeData^.VarName := NodeData^.VarName + '[' + IntToStr(i) + ']';
      ChNodeData^.VarValue := SubVars.Strings[i];
    end;
  finally
    SubVars.Free;
  end;

  if ARecursionLevel > 20 then
    Exit;

  Node := ANode.FirstChild;
  if Node = nil then
    Exit;

  repeat
    NodeData := vstVariables.GetNodeData(Node);

    if Pos(#4#5, NodeData^.VarValue) > 0 then
      AddDecodedVarToNode(Node, ARecursionLevel + 1);

    Node := Node^.NextSibling;
  until Node = nil;
end;


procedure TfrClickerActions.chkDecodeVariablesChange(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if FlblResultSelLeft <> nil then
  begin
    FlblResultSelLeft.Visible := chkDecodeVariables.Checked;
    FlblResultSelTop.Visible := chkDecodeVariables.Checked;
    FlblResultSelRight.Visible := chkDecodeVariables.Checked;
    FlblResultSelBottom.Visible := chkDecodeVariables.Checked;
  end;

  Node := vstVariables.GetFirst;
  if Node = nil then
    Exit;

  repeat
    if Node^.ChildCount > 0 then
      vstVariables.DeleteChildren(Node);

    Node := Node^.NextSibling;
  until Node = nil;

  if not chkDecodeVariables.Checked then
    Exit;

  Node := vstVariables.GetFirst;
  repeat
    if Pos(#4#5, FClkVariables.ValueFromIndex[Node^.Index]) > 0 then
      AddDecodedVarToNode(Node, 0);

    Node := Node^.NextSibling;
  until Node = nil;
end;


procedure TfrClickerActions.CreateSelectionLabelsForResult;
begin
  if FlblResultSelLeft = nil then
  begin
    FlblResultSelLeft := TLabel.Create(Self);
    FlblResultSelTop := TLabel.Create(Self);
    FlblResultSelRight := TLabel.Create(Self);
    FlblResultSelBottom := TLabel.Create(Self);

    FlblResultSelLeft.Parent := scrboxDebugBmp;
    FlblResultSelTop.Parent := scrboxDebugBmp;
    FlblResultSelRight.Parent := scrboxDebugBmp;
    FlblResultSelBottom.Parent := scrboxDebugBmp;

    FlblResultSelLeft.Transparent := False;
    FlblResultSelTop.Transparent := False;
    FlblResultSelRight.Transparent := False;
    FlblResultSelBottom.Transparent := False;

    FlblResultSelLeft.Caption := '';
    FlblResultSelTop.Caption := '';
    FlblResultSelRight.Caption := '';
    FlblResultSelBottom.Caption := '';

    FlblResultSelLeft.AutoSize := False;
    FlblResultSelTop.AutoSize := False;
    FlblResultSelRight.AutoSize := False;
    FlblResultSelBottom.AutoSize := False;

    FlblResultSelLeft.Width := 1;
    FlblResultSelTop.Width := scrboxDebugBmp.Width;
    FlblResultSelRight.Width := 1;
    FlblResultSelBottom.Width := FlblResultSelTop.Width;

    FlblResultSelLeft.Height := scrboxDebugBmp.Height;
    FlblResultSelTop.Height := 1;
    FlblResultSelRight.Height := FlblResultSelLeft.Width;
    FlblResultSelBottom.Height := 1;

    FlblResultSelLeft.Anchors := [akLeft, akTop, akBottom];
    FlblResultSelTop.Anchors := [akLeft, akTop, akRight];
    FlblResultSelRight.Anchors := [akLeft, akTop, akBottom];
    FlblResultSelBottom.Anchors := [akLeft, akTop, akRight];

    FlblResultSelLeft.Color := clGreen;
    FlblResultSelTop.Color := clGreen;
    FlblResultSelRight.Color := clMaroon;
    FlblResultSelBottom.Color := clMaroon;

    FlblResultSelLeft.Visible := True;
    FlblResultSelTop.Visible := True;
    FlblResultSelRight.Visible := True;
    FlblResultSelBottom.Visible := True;

    FlblResultSelLeft.BringToFront;
    FlblResultSelTop.BringToFront;
    FlblResultSelRight.BringToFront;
    FlblResultSelBottom.BringToFront;

    FlblResultSelLeft.OnMouseEnter := FlblResultSelVertMouseEnter;
    FlblResultSelTop.OnMouseEnter := FlblResultSelHorizMouseEnter;
    FlblResultSelRight.OnMouseEnter := FlblResultSelVertMouseEnter;
    FlblResultSelBottom.OnMouseEnter := FlblResultSelHorizMouseEnter;

    FlblResultSelLeft.OnMouseLeave := FlblResultSelVertMouseLeave;
    FlblResultSelTop.OnMouseLeave := FlblResultSelHorizMouseLeave;
    FlblResultSelRight.OnMouseLeave := FlblResultSelVertMouseLeave;
    FlblResultSelBottom.OnMouseLeave := FlblResultSelHorizMouseLeave;

    FlblResultSelLeft.OnMouseMove := FlblResultSelVertMouseMove;
    FlblResultSelTop.OnMouseMove := FlblResultSelHorizMouseMove;
    FlblResultSelRight.OnMouseMove := FlblResultSelVertMouseMove;
    FlblResultSelBottom.OnMouseMove := FlblResultSelHorizMouseMove;
  end;
end;


function TfrClickerActions.GetSubVarByIndex(AMainVarValue: string; ASubVarIndex: Integer): string;
var
  SubVars: TStringList;
begin
  SubVars := TStringList.Create;
  try
    SubVars.Text := FastReplace_45ToReturn(AMainVarValue);

    if ASubVarIndex > SubVars.Count - 1 then
    begin
      Result := '10'; //a valid value, to set the label there
      Exit;
    end;

    Result := SubVars.Strings[ASubVarIndex];
  finally
    SubVars.Free;
  end;
end;


procedure TfrClickerActions.GetDecodedVarDetails(AParentVarName: string; ASubVarIndex: Integer; out X, Y, W, H: Integer);
var
  XVarIdx, YVarIdx, WVarIdx, HVarIdx: Integer;
  XVarValue, YVarValue, WVarValue, HVarValue: string;
begin
  X := -1;
  Y := -1;
  W := -1;
  H := -1;
  XVarIdx := -1;
  YVarIdx := -1;
  WVarIdx := -1;
  HVarIdx := -1;

  if (AParentVarName = '$AllControl_XOffsets$') or
     (AParentVarName = '$AllControl_YOffsets$') or
     (AParentVarName = '$AllControl_Lefts$') or
     (AParentVarName = '$AllControl_Tops$') or
     (AParentVarName = '$AllControl_Rights$') or
     (AParentVarName = '$AllControl_Bottoms$') or
     (AParentVarName = '$AllControl_Widths$') or
     (AParentVarName = '$AllControl_Heights$') then
  begin
    XVarIdx := FClkVariables.IndexOfName('$AllControl_XOffsets$');  //use XOffsets, because the value is relative to parent control
    YVarIdx := FClkVariables.IndexOfName('$AllControl_YOffsets$');  //use YOffsets, because the value is relative to parent control
    WVarIdx := FClkVariables.IndexOfName('$AllControl_Widths$');
    HVarIdx := FClkVariables.IndexOfName('$AllControl_Heights$');
  end;

  if (AParentVarName = '$DecodedWindows_XOffset$') or
     (AParentVarName = '$DecodedWindows_YOffset$') or
     (AParentVarName = '$DecodedWindows_Control_Lefts$') or
     (AParentVarName = '$DecodedWindows_Control_Tops$') or
     (AParentVarName = '$DecodedWindows_Control_Rights$') or
     (AParentVarName = '$DecodedWindows_Control_Bottoms$') or
     (AParentVarName = '$DecodedWindows_Control_Width$') or
     (AParentVarName = '$DecodedWindows_Control_Height$') then
  begin
    XVarIdx := FClkVariables.IndexOfName('$DecodedWindows_XOffset$');  //use XOffsets, because the value is relative to parent control
    YVarIdx := FClkVariables.IndexOfName('$DecodedWindows_YOffset$');  //use YOffsets, because the value is relative to parent control
    WVarIdx := FClkVariables.IndexOfName('$DecodedWindows_Control_Width$');
    HVarIdx := FClkVariables.IndexOfName('$DecodedWindows_Control_Height$');
  end;

  if (AParentVarName = '$DecodedWindows_XOffset_WE$') or
     (AParentVarName = '$DecodedWindows_YOffset_WE$') or
     (AParentVarName = '$DecodedWindows_Control_Lefts_WE$') or
     (AParentVarName = '$DecodedWindows_Control_Tops_WE$') or
     (AParentVarName = '$DecodedWindows_Control_Rights_WE$') or
     (AParentVarName = '$DecodedWindows_Control_Bottoms_WE$') or
     (AParentVarName = '$DecodedWindows_Control_Width_WE$') or
     (AParentVarName = '$DecodedWindows_Control_Height_WE$') then
  begin
    XVarIdx := FClkVariables.IndexOfName('$DecodedWindows_XOffset_WE$');  //use XOffsets, because the value is relative to parent control
    YVarIdx := FClkVariables.IndexOfName('$DecodedWindows_YOffset_WE$');  //use YOffsets, because the value is relative to parent control
    WVarIdx := FClkVariables.IndexOfName('$DecodedWindows_Control_Width_WE$');
    HVarIdx := FClkVariables.IndexOfName('$DecodedWindows_Control_Height_WE$');
  end;

  XVarValue := '';
  YVarValue := '';
  WVarValue := '';
  HVarValue := '';

  if XVarIdx <> - 1 then
    XVarValue := GetSubVarByIndex(FClkVariables.ValueFromIndex[XVarIdx], ASubVarIndex);

  if YVarIdx <> - 1 then
    YVarValue := GetSubVarByIndex(FClkVariables.ValueFromIndex[YVarIdx], ASubVarIndex);

  if WVarIdx <> - 1 then
    WVarValue := GetSubVarByIndex(FClkVariables.ValueFromIndex[WVarIdx], ASubVarIndex);

  if HVarIdx <> - 1 then
    HVarValue := GetSubVarByIndex(FClkVariables.ValueFromIndex[HVarIdx], ASubVarIndex);

  X := StrToIntDef(XVarValue, 4);
  Y := StrToIntDef(YVarValue, 4);
  W := StrToIntDef(WVarValue, 4);
  H := StrToIntDef(HVarValue, 4);
end;


procedure TfrClickerActions.SelectAreaFromDecodedVariable(ANodeData: PVarNodeRec; ASubVarIndex: Integer);
var
  ParentVarName: string;
  X, Y, W, H: Integer;
begin
  CreateSelectionLabelsForResult;

  ParentVarName := Copy(ANodeData^.VarName, 1, Pos('$[', ANodeData^.VarName));

  GetDecodedVarDetails(ParentVarName, ASubVarIndex, X, Y, W, H);
  FlblResultSelLeft.Left := X;
  FlblResultSelTop.Top := Y;
  FlblResultSelRight.Left := X + W;
  FlblResultSelBottom.Top := Y + H;
end;


procedure TfrClickerActions.scrboxDebugBmpMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  Factor: Integer;
begin
  if ssCtrl in Shift then
    Factor := 1
  else
    Factor := 3;

  if ssShift in Shift then
    scrboxDebugBmp.HorzScrollBar.Position := scrboxDebugBmp.HorzScrollBar.Position - WheelDelta div Factor
  else
    scrboxDebugBmp.VertScrollBar.Position := scrboxDebugBmp.VertScrollBar.Position - WheelDelta div Factor;

  Handled := True;
end;


procedure TfrClickerActions.UpdateControlWidthHeightLabels;
begin
  frClickerFindControl.UpdateControlWidthHeightLabels;
end;


procedure TfrClickerActions.UpdateUseWholeScreenLabel(AUseWholeScreen: Boolean);
begin
  frClickerFindControl.UpdateUseWholeScreenLabel(AUseWholeScreen);
end;


procedure TfrClickerActions.spdbtnDisplaySearchAreaDbgImgMenuClick(Sender: TObject);
var
  tp: TPoint;
begin
  GetCursorPos(tp);
  FSearchAreaDbgImgSearchedBmpMenu.PopUp(tp.X, tp.Y);
end;


procedure TfrClickerActions.tmrClkVariablesTimer(Sender: TObject);
begin
  tmrClkVariables.Enabled := False;
  vstVariables.RootNodeCount := FClkVariables.Count;
  vstVariables.Repaint;
end;


procedure TfrClickerActions.lbeFindCachedControlLeftChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.lbeFindCachedControlTopChange(Sender: TObject);
begin
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.MenuItem_ReplaceWithAppDirClick(Sender: TObject);
var
  PathToFileName: string;
begin
  try
    if Assigned(FLastClickedTVTEdit) then
      PathToFileName := FLastClickedTVTEdit.Text
    else
      if Assigned(FLastClickedEdit) then
        PathToFileName := FLastClickedEdit.Text
      else
        PathToFileName := '';

    if ExtractFileDrive(ParamStr(0)) = ExtractFileDrive(PathToFileName) then
      PathToFileName := '$AppDir$' + PathDelim + ExtractRelativePath(ExtractFilePath(ParamStr(0)), PathToFileName);

    if Assigned(FLastClickedTVTEdit) then
    begin
      FLastClickedTVTEdit.Text := PathToFileName; //StringReplace(FLastClickedTVTEdit.Text, ExtractFileDir(ParamStr(0)), '$AppDir$', [rfReplaceAll]);
      FOIFrame.EditingText := FLastClickedTVTEdit.Text;
    end;

    if Assigned(FLastClickedEdit) then
    begin
      FLastClickedEdit.Text := PathToFileName; //StringReplace(FLastClickedEdit.Text, ExtractFileDir(ParamStr(0)), '$AppDir$', [rfReplaceAll]);
      if Assigned(FLastClickedEdit.OnChange) then
        FLastClickedEdit.OnChange(FLastClickedEdit);
    end;
  except
    on E: Exception do
      MessageBox(Handle, PChar('EditBox is not available.' + #13#10 + E.Message), PChar(Application.MainForm.Caption), MB_ICONERROR);
  end;
end;


procedure TfrClickerActions.MenuItem_ReplaceWithTemplateDirClick(Sender: TObject);
var
  PathToFileName: string;
begin
  try
    if Assigned(FLastClickedTVTEdit) then
      PathToFileName := FLastClickedTVTEdit.Text
    else
      if Assigned(FLastClickedEdit) then
        PathToFileName := FLastClickedEdit.Text
      else
        PathToFileName := '';

    PathToFileName := StringReplace(PathToFileName, FFullTemplatesDir, '$TemplateDir$', [rfReplaceAll]);

    if Assigned(FLastClickedTVTEdit) then
    begin
      FLastClickedTVTEdit.Text := PathToFileName;
      FOIFrame.EditingText := FLastClickedTVTEdit.Text;
    end;

    if Assigned(FLastClickedEdit) then
    begin
      FLastClickedEdit.Text := PathToFileName;
      if Assigned(FLastClickedEdit.OnChange) then
        FLastClickedEdit.OnChange(FLastClickedEdit);
    end;
  except
    on E: Exception do
      MessageBox(Handle, PChar('EditBox is not available.' + #13#10 + E.Message), PChar(Application.MainForm.Caption), MB_ICONERROR);
  end;
end;


procedure TfrClickerActions.MenuItem_ReplaceWithSelfTemplateDirClick(
  Sender: TObject);
var
  PathToFileName: string;
begin
  try
    if Assigned(FLastClickedTVTEdit) then
      PathToFileName := FLastClickedTVTEdit.Text
    else
      if Assigned(FLastClickedEdit) then
        PathToFileName := FLastClickedEdit.Text
      else
        PathToFileName := '';
                                                                    //path to template
    PathToFileName := StringReplace(PathToFileName, ExtractFileDir(DoOnGetLoadedTemplateFileName), '$SelfTemplateDir$', [rfReplaceAll]);

    if Assigned(FLastClickedTVTEdit) then
    begin
      FLastClickedTVTEdit.Text := PathToFileName;
      FOIFrame.EditingText := FLastClickedTVTEdit.Text;
    end;

    if Assigned(FLastClickedEdit) then
    begin
      FLastClickedEdit.Text := PathToFileName;
      if Assigned(FLastClickedEdit.OnChange) then
        FLastClickedEdit.OnChange(FLastClickedEdit);
    end;
  except
    on E: Exception do
      MessageBox(Handle, PChar('EditBox is not available.' + #13#10 + E.Message), PChar(Application.MainForm.Caption), MB_ICONERROR);
  end;
end;


procedure TfrClickerActions.MenuItem_SetFromControlLeftAndTopClick(
  Sender: TObject);
begin
  FOIFrame.CancelCurrentEditing;
  FEditingAction^.WindowOperationsOptions.NewX := EvaluateReplacements('$Control_Left$');
  FEditingAction^.WindowOperationsOptions.NewY := EvaluateReplacements('$Control_Top$');
  FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CWindowOperations_NewX_PropItemIndex, -1);
  FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CWindowOperations_NewY_PropItemIndex, -1);
end;


procedure TfrClickerActions.MenuItem_SetFromControlWidthAndHeightClick(
  Sender: TObject);
begin
  FOIFrame.CancelCurrentEditing;
  FEditingAction^.WindowOperationsOptions.NewWidth := EvaluateReplacements('$Control_Width$');
  FEditingAction^.WindowOperationsOptions.NewHeight := EvaluateReplacements('$Control_Height$');
  FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CWindowOperations_NewWidth_PropItemIndex, -1);
  FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CWindowOperations_NewHeight_PropItemIndex, -1);
end;


procedure TfrClickerActions.pmStandardColorVariablesPopup(Sender: TObject);
var
  i: Integer;
  s, evs: string;
  TextColor: TColor;
begin
  for i := 0 to pmStandardColorVariables.Items.Count - 1 do
    if Pos('$', pmStandardColorVariables.Items.Items[i].Caption) > 0 then
    begin
      if pmStandardColorVariables.Items.Items[i].Bitmap <> nil then
        pmStandardColorVariables.Items.Items[i].Bitmap.Free;

      pmStandardColorVariables.Items.Items[i].Bitmap := TBitmap.Create;
      pmStandardColorVariables.Items.Items[i].Bitmap.Width := 16;
      pmStandardColorVariables.Items.Items[i].Bitmap.Height := 16;

      s := pmStandardColorVariables.Items.Items[i].Caption;
      Delete(s, 1, 1); //remove first '$', so that Pos returns the next one
      s := '$' + Copy(s, 1, Pos('$', s));
      evs := EvaluateReplacements(s);
      TextColor := HexToInt(evs);

      pmStandardColorVariables.Items.Items[i].Caption := s + '   (' + evs + ')';

      pmStandardColorVariables.Items.Items[i].Bitmap.Canvas.Pen.Color := 1;  // > 0
      pmStandardColorVariables.Items.Items[i].Bitmap.Canvas.Brush.Color := TextColor;
      pmStandardColorVariables.Items.Items[i].Bitmap.Canvas.Rectangle(0, 0, 16, 16);
    end;
end;


procedure TfrClickerActions.FrameResize(Sender: TObject);
var
  NewLeft: Integer;
begin                                   //this method doesn't seem to be called before showing the owner window/frame
  NewLeft := pnlHorizSplitter.Left;     //that is why Width has its initial (small) value, causing NewLeft to adapt to it

  if NewLeft > Width - 260 then
    NewLeft := Width - 260;

  ResizeFrameSectionsBySplitter(NewLeft);

  NewLeft := pnlHorizSplitterResults.Left;
  if NewLeft > Width - 260 then
    NewLeft := Width - 260;

  ResizeFrameSectionsBySplitterResults(NewLeft);
end;


procedure TfrClickerActions.ResizeFrameSectionsBySplitter(NewLeft: Integer);
begin
  if NewLeft < pnlvstOI.Constraints.MinWidth then
    NewLeft := pnlvstOI.Constraints.MinWidth;

  if NewLeft > Width - 260 then
    NewLeft := Width - 260;

  pnlHorizSplitter.Left := NewLeft;

  pnlExtra.Left := pnlHorizSplitter.Left + pnlHorizSplitter.Width;
  pnlExtra.Width := TabSheetAction.Width - pnlExtra.Left;
  pnlvstOI.Width := pnlHorizSplitter.Left;
end;


procedure TfrClickerActions.ResizeFrameSectionsBySplitterResults(NewLeft: Integer);
begin
  if NewLeft < pnlVars.Constraints.MinWidth then
    NewLeft := pnlVars.Constraints.MinWidth;

  if NewLeft > Width - 260 then
    NewLeft := Width - 260;

  pnlHorizSplitterResults.Left := NewLeft;

  pnlResults.Left := pnlHorizSplitterResults.Left + pnlHorizSplitterResults.Width;
  pnlResults.Width := TabSheetDebugging.Width - pnlResults.Left;
  pnlVars.Width := pnlHorizSplitterResults.Left;
end;


procedure TfrClickerActions.BringOIPropertyIntoView(NodeLevel, CategoryIndex, PropertyIndex, PropertyItemIndex: Integer);
begin
  FOIFrame.ScrollToNode(NodeLevel, CategoryIndex, PropertyIndex, PropertyItemIndex);
end;


function TfrClickerActions.GetIndexOfFirstModifiedPmtvFile: Integer;
var
  PrimitiveFile_Modified: TStringList;
begin
  PrimitiveFile_Modified := TStringList.Create;
  try
    PrimitiveFile_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
    Result := PrimitiveFile_Modified.IndexOf('1');
  finally
    PrimitiveFile_Modified.Free;
  end;
end;


procedure TfrClickerActions.pnlHorizSplitterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Shift <> [ssLeft] then
    Exit;

  if not FHold then
  begin
    GetCursorPos(FSplitterMouseDownGlobalPos);

    FSplitterMouseDownImagePos.X := pnlHorizSplitter.Left;
    FHold := True;
  end;
end;


procedure TfrClickerActions.pnlHorizSplitterMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  tp: TPoint;
  NewLeft: Integer;
begin
  if Shift <> [ssLeft] then
    Exit;

  if not FHold then
    Exit;

  GetCursorPos(tp);
  NewLeft := FSplitterMouseDownImagePos.X + tp.X - FSplitterMouseDownGlobalPos.X;

  ResizeFrameSectionsBySplitter(NewLeft);
end;


procedure TfrClickerActions.pnlHorizSplitterMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FHold := False;
end;


procedure TfrClickerActions.pnlHorizSplitterResultsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Shift <> [ssLeft] then
    Exit;

  if not FHoldResults then
  begin
    GetCursorPos(FSplitterMouseDownGlobalPos);

    FSplitterMouseDownImagePos.X := pnlHorizSplitterResults.Left;
    FHoldResults := True;
  end;
end;


procedure TfrClickerActions.pnlHorizSplitterResultsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  tp: TPoint;
  NewLeft: Integer;
begin
  if Shift <> [ssLeft] then
    Exit;

  if not FHoldResults then
    Exit;

  GetCursorPos(tp);
  NewLeft := FSplitterMouseDownImagePos.X + tp.X - FSplitterMouseDownGlobalPos.X;

  ResizeFrameSectionsBySplitterResults(NewLeft);
end;


procedure TfrClickerActions.pnlHorizSplitterResultsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FHoldResults := False;
end;


procedure TfrClickerActions.vallstVariablesValidate(Sender: TObject; ACol,
  ARow: Integer; const KeyName, KeyValue: string);
begin
  if ACol = 0 then
  begin
    if KeyName > '' then
      if {(Length(KeyName) < 2) or} (KeyName[1] <> '$') or (KeyName[Length(KeyName)] <> '$') then
        raise Exception.Create('Variable name must be enclosed by two "$" characters. E.g. "$my_var$" (without double quotes).');

    if ARow - 1 < FPredefinedVarCount then
      raise Exception.Create('Predefined variables should not be edited. Press Esc to revert.');
  end;
end;


const
  CNoTemplatesMsg = 'No local templates available.';
  CNoSetVarActionsMsg = 'No SetVar actions available.';

procedure TfrClickerActions.LocalTemplatesClick(Sender: TObject);
var
  Fnm: string;
begin
  Fnm := StringReplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll]);

  if Fnm = CNoTemplatesMsg then
  begin
    MessageBox(Handle, 'There are no templates in the local directory, ActionTemplates.', PChar(Application.Title), MB_ICONINFORMATION);
    Exit;
  end;

  FEditingAction^.CallTemplateOptions.TemplateFileName := Fnm;
  FOIFrame.CancelCurrentEditing;
  FOIFrame.Repaint;   //ideally, RepaintNodeByLevel
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.AvailableSetVarClick(Sender: TObject);
var
  SetVarName: string;
begin
  SetVarName := StringReplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll]);

  if SetVarName = CNoSetVarActionsMsg then
  begin
    MessageBox(Handle, 'There are no available SetVar actions.', PChar(Application.Title), MB_ICONINFORMATION);
    Exit;
  end;

  if CurrentlyEditingActionType = acLoadSetVarFromFile then
    FEditingAction^.LoadSetVarFromFileOptions.SetVarActionName := SetVarName;

  if CurrentlyEditingActionType = acSaveSetVarToFile then
    FEditingAction^.SaveSetVarToFileOptions.SetVarActionName := SetVarName;

  FOIFrame.CancelCurrentEditing;
  FOIFrame.Repaint;   //ideally, RepaintNodeByLevel
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.AvailablePluginPropertiesClick(Sender: TObject);
var
  ActionName: string;
  ListOfProperties: TStringList;
  PropertyIndex: Integer;
begin
  ActionName := StringReplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll]);
  PropertyIndex := (Sender as TMenuItem).Tag;

  ListOfProperties := TStringList.Create;
  try
    ListOfProperties.Text := FEditingAction^.PluginOptions.ListOfPropertiesAndValues;

    if ActionName <> '' then  //verification required, otherwise the item is deleted from list
      ListOfProperties.ValueFromIndex[PropertyIndex] := ActionName;

    FEditingAction^.PluginOptions.ListOfPropertiesAndValues := ListOfProperties.Text;
  finally
    ListOfProperties.Free;
  end;

  FOIFrame.CancelCurrentEditing;
  FOIFrame.Repaint;   //ideally, RepaintNodeByLevel
  TriggerOnControlsModified;
end;



procedure TfrClickerActions.BrowseTemplatesClick(Sender: TObject);
begin
  DoOnSetOpenDialogInitialDir(FFullTemplatesDir);    //this is not the right dir
  if DoOnOpenDialogExecute(CTemplateDialogFilter) then
  begin
    FEditingAction^.CallTemplateOptions.TemplateFileName := DoOnGetOpenDialogFileName;
    FOIFrame.CancelCurrentEditing;
    FOIFrame.Repaint;   //ideally, RepaintNodeByLevel
    TriggerOnControlsModified;
  end;
end;


procedure TfrClickerActions.LoadListOfAvailableTemplates;
var
  AvailableTemplates: TStringList;
  ASearchRec: TSearchRec;
  SearchResult: Integer;
  Dir: string;
  TempMenuItem, BaseMenuItem: TMenuItem;
  i: Integer;
begin
  AvailableTemplates := TStringList.Create;
  try
    Dir := FFullTemplatesDir + '\*.clktmpl';

    SearchResult := FindFirst(Dir, faArchive, ASearchRec);
    try
      while SearchResult = 0 do
      begin
        AvailableTemplates.Add(ASearchRec.Name);
        SearchResult := FindNext(ASearchRec);
      end;
    finally
      FindClose(ASearchRec);
    end;

    FPmLocalTemplates.Items.Clear;

    if AvailableTemplates.Count = 0 then
      AvailableTemplates.Add(CNoTemplatesMsg);

    BaseMenuItem := TMenuItem.Create(Self);
    BaseMenuItem.Caption := 'Browse template...';
    BaseMenuItem.OnClick := BrowseTemplatesClick;
    FPmLocalTemplates.Items.Add(BaseMenuItem);

    BaseMenuItem := TMenuItem.Create(Self);
    BaseMenuItem.Caption := 'Local templates';
    BaseMenuItem.OnClick := nil;
    FPmLocalTemplates.Items.Add(BaseMenuItem);

    for i := 0 to AvailableTemplates.Count - 1 do
    begin
      TempMenuItem := TMenuItem.Create(Self);
      TempMenuItem.Caption := AvailableTemplates.Strings[i];
      TempMenuItem.OnClick := LocalTemplatesClick;
      FPmLocalTemplates.Items[1].Add(TempMenuItem);
    end;
  finally
    AvailableTemplates.Free;
  end;
end;


procedure TfrClickerActions.LoadListOfAvailableSetVarActions;
var
  AvailableSetVarActions: TStringList;
  TempMenuItem, BaseMenuItem: TMenuItem;
  i: Integer;
  Bmp: TBitmap;
begin
  AvailableSetVarActions := TStringList.Create;
  try
    DoOnGetListOfAvailableSetVarActions(AvailableSetVarActions);

    FPmLocalTemplates.Items.Clear;

    if AvailableSetVarActions.Count = 0 then
      AvailableSetVarActions.Add(CNoSetVarActionsMsg);

    BaseMenuItem := TMenuItem.Create(Self);
    BaseMenuItem.Caption := 'Available SetVar actions';
    BaseMenuItem.OnClick := nil;
    FPmLocalTemplates.Items.Add(BaseMenuItem);

    for i := 0 to AvailableSetVarActions.Count - 1 do
    begin
      TempMenuItem := TMenuItem.Create(Self);
      TempMenuItem.Caption := AvailableSetVarActions.Strings[i];
      TempMenuItem.OnClick := AvailableSetVarClick;

      Bmp := TBitmap.Create;
      Bmp.PixelFormat := pf24bit;
      Bmp.Width := 16;
      Bmp.Height := 16;
      Bmp.Canvas.Pen.Color := clWhite;
      Bmp.Canvas.Brush.Color := clWhite;
      Bmp.Canvas.Rectangle(0, 0, 16, 16);
      imglstActions16.Draw(bmp.Canvas, 0, 0, Integer(TClkAction(acSetVar)), dsNormal, itImage);
      TempMenuItem.Bitmap := Bmp;

      FPmLocalTemplates.Items[0].Add(TempMenuItem);
    end;
  finally
    AvailableSetVarActions.Free;
  end;
end;


procedure TfrClickerActions.LoadListOfAvailableActionsForPlugin(APropertyIndexToUpdate: Integer);
var
  AvailableActions: TStringList;
  TempMenuItem, BaseMenuItem: TMenuItem;
  i: Integer;
  Bmp: TBitmap;
  ActionStr: string;
  ActionType: Integer;
begin
  AvailableActions := TStringList.Create;
  try
    DoOnGetListOfAvailableActions(AvailableActions);

    FPmLocalTemplates.Items.Clear;

    if AvailableActions.Count = 0 then
      AvailableActions.Add(CNoSetVarActionsMsg);

    BaseMenuItem := TMenuItem.Create(Self);
    BaseMenuItem.Caption := 'Available actions';
    BaseMenuItem.OnClick := nil;
    FPmLocalTemplates.Items.Add(BaseMenuItem);

    for i := 0 to AvailableActions.Count - 1 do
    begin
      ActionStr := AvailableActions.Strings[i];
      ActionType := StrToIntDef(Copy(ActionStr, Pos(#4#5, ActionStr) + 2, MaxInt), 0);

      TempMenuItem := TMenuItem.Create(Self);
      TempMenuItem.Caption := Copy(ActionStr, 1, Pos(#4#5, ActionStr) - 1);
      TempMenuItem.OnClick := AvailablePluginPropertiesClick;
      TempMenuItem.Tag := APropertyIndexToUpdate;

      Bmp := TBitmap.Create;
      Bmp.PixelFormat := pf24bit;
      Bmp.Width := 16;
      Bmp.Height := 16;
      Bmp.Canvas.Pen.Color := clWhite;
      Bmp.Canvas.Brush.Color := clWhite;
      Bmp.Canvas.Rectangle(0, 0, 16, 16);
      imglstActions16.Draw(bmp.Canvas, 0, 0, ActionType, dsNormal, itImage);
      TempMenuItem.Bitmap := Bmp;

      FPmLocalTemplates.Items[0].Add(TempMenuItem);
    end;
  finally
    AvailableActions.Free;
  end;
end;


procedure TfrClickerActions.OverlapGridImgOnDebugImg(ADebugAndGridBitmap: TBitmap);
begin
  ADebugAndGridBitmap.Width := imgDebugBmp.Picture.Bitmap.Width;
  ADebugAndGridBitmap.Height := imgDebugBmp.Picture.Bitmap.Height;
  ADebugAndGridBitmap.Canvas.Draw(0, 0, imgDebugBmp.Picture.Bitmap);
  ADebugAndGridBitmap.Canvas.Draw(imgDebugGrid.Left, imgDebugGrid.Top, imgDebugGrid.Picture.Bitmap);
end;


procedure TfrClickerActions.MenuItemCopyDebugImageClick(Sender: TObject);
var
  DebugAndGridBitmap: TBitmap;
begin
  if (imgDebugBmp.Picture.Bitmap.Width = 0) and (imgDebugBmp.Picture.Bitmap.Height = 0) then
  begin
    MessageBox(Handle, 'Selected image is empty. Nothing to copy.', PChar(Caption), MB_ICONINFORMATION);
    Exit;
  end;

  if chkShowDebugGrid.Checked then
  begin
    DebugAndGridBitmap := TBitmap.Create;
    try
      OverlapGridImgOnDebugImg(DebugAndGridBitmap);
      Clipboard.Assign(DebugAndGridBitmap);
    finally
      DebugAndGridBitmap.Free;
    end;
  end
  else
    Clipboard.Assign(imgDebugBmp.Picture);
end;


procedure TfrClickerActions.MenuItemSaveDebugImageClick(Sender: TObject);
var
  ASaveDialog: TSaveDialog;
  DebugAndGridBitmap: TBitmap;
begin
  ASaveDialog := TSaveDialog.Create(nil);
  try
    ASaveDialog.Filter := 'Bitmap files (*.bmp)|*.bmp|All files (*.*)|*.*';
    ASaveDialog.InitialDir := FBMPsDir;
    if not ASaveDialog.Execute then
      Exit;

    if UpperCase(ExtractFileExt(ASaveDialog.FileName)) <> '.BMP' then
      ASaveDialog.FileName := ASaveDialog.FileName + '.bmp';

    if FileExists(ASaveDialog.FileName) then
      if MessageBox(Handle, 'File already exists. Replace?', PChar(Caption), MB_ICONWARNING + MB_YESNO) = IDNO then
        Exit;

    if chkShowDebugGrid.Checked then
    begin
      DebugAndGridBitmap := TBitmap.Create;
      try
        OverlapGridImgOnDebugImg(DebugAndGridBitmap);
        DebugAndGridBitmap.SaveToFile(ASaveDialog.FileName);
      finally
        DebugAndGridBitmap.Free;
      end;
    end
    else
      imgDebugBmp.Picture.Bitmap.SaveToFile(ASaveDialog.FileName);
          
    FBMPsDir := ExtractFileDir(ASaveDialog.FileName);
  finally
    ASaveDialog.Free;
  end;
end;


procedure TfrClickerActions.HandleOnUpdateBitmapAlgorithmSettings;
begin
  imgDebugGrid.Visible := chkShowDebugGrid.Checked;
end;


procedure TfrClickerActions.HandleOnTriggerOnControlsModified;
begin
  TriggerOnControlsModified;
  FOIFrame.RepaintOI;
end;


function TfrClickerActions.HandleOnEvaluateReplacements(s: string): string;
begin
  Result := EvaluateReplacements(s);
end;


function TfrClickerActions.HandleOnReverseEvaluateReplacements(s: string): string;
begin
  Result := ReverseEvaluateReplacements(s);
end;


procedure TfrClickerActions.AddVariable1Click(Sender: TObject);
begin
  FClkVariables.Add('');
end;


procedure TfrClickerActions.TriggerOnControlsModified(AExtraCondition: Boolean = True);
begin
  if not AExtraCondition then
    Exit;

  if Assigned(FOnControlsModified) then
  begin
    if not FControlsModified then  //to avoid calling the event every time
    begin
      FControlsModified := True;   //execute before the callback, because inside the callback, FControlsModified may be reset
      FOnControlsModified(Self);
    end;
  end;
end;


procedure TfrClickerActions.ClearControls;
begin
  frClickerConditionEditor.ClearActionConditionPreview;
  frClickerFindControl.ClearControls;

  //clear dynamically created mouse controls

  UpdatePageControlActionExecutionIcons;

  FEditingAction^.ActionOptions.Action := {%H-}TClkAction(CClkUnsetAction); //not set
  FOIFrame.ReloadContent;
end;



procedure TfrClickerActions.UpdatePageControlActionExecutionIcons;
begin
  PageControlActionExecution.Pages[0].ImageIndex := 0 + 3 * Ord(Integer(FEditingAction^.ActionOptions.Action) <> CClkUnsetAction);
  PageControlActionExecution.Pages[1].ImageIndex := 1 + 3 * Ord(frClickerConditionEditor.ConditionsAvailable);
  PageControlActionExecution.Pages[2].ImageIndex := 2 + 3 * Ord(FDebuggingInfoAvailable);
end;


procedure TfrClickerActions.SetDebuggingInfoAvailable(Value: Boolean);
begin
  if FDebuggingInfoAvailable <> Value then
  begin
    FDebuggingInfoAvailable := Value;
    UpdatePageControlActionExecutionIcons;
  end;
end;


function TfrClickerActions.GetInMemFS: TInMemFileSystem;
begin
  Result := frClickerFindControl.InMemFS;
end;


procedure TfrClickerActions.SetInMemFS(Value: TInMemFileSystem);
begin
  frClickerFindControl.InMemFS := Value;
end;


function TfrClickerActions.GetExtRenderingInMemFS: TInMemFileSystem;
begin
  Result := frClickerFindControl.ExtRenderingInMemFS;
end;


procedure TfrClickerActions.SetExtRenderingInMemFS(Value: TInMemFileSystem);
begin
  frClickerFindControl.ExtRenderingInMemFS := Value;
end;


procedure TfrClickerActions.HandleOnCopyControlTextAndClassFromMainWindow(ACompProvider: string; out AControlText, AControlClass: string);
begin
  if not Assigned(FOnCopyControlTextAndClassFromMainWindow) then
    raise Exception.Create('OnCopyControlTextAndClass not assigned for ' + Caption)
  else
    FOnCopyControlTextAndClassFromMainWindow(ACompProvider, AControlText, AControlClass);
end;


function TfrClickerActions.HandleOnGetExtraSearchAreaDebuggingImage(AExtraBitmap: TBitmap): Boolean;
begin
  if not Assigned(FOnGetExtraSearchAreaDebuggingImage) then
    Result := False
  else
    Result := FOnGetExtraSearchAreaDebuggingImage(AExtraBitmap);
end;


function TfrClickerActions.HandleOnLoadBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
begin
  Result := DoOnLoadBitmap(ABitmap, AFileName);
end;


function TfrClickerActions.HandleOnLoadRenderedBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
begin
  Result := DoOnLoadRenderedBitmap(ABitmap, AFileName);
end;


procedure TfrClickerActions.HandleOnGetListOfExternallyRenderedImages(AListOfExternallyRenderedImages: TStringList);
begin
  DoOnGetListOfExternallyRenderedImages(AListOfExternallyRenderedImages);
end;


function TfrClickerActions.HandleOnFileExists(const AFileName: string): Boolean;
begin
  Result := DoOnFileExists(AFileName);
end;


procedure TfrClickerActions.HandleOnSetPictureOpenDialogInitialDir(AInitialDir: string);
begin
  DoOnSetPictureOpenDialogInitialDir(AInitialDir);
end;


function TfrClickerActions.HandleOnPictureOpenDialogExecute: Boolean;
begin
  Result := DoOnPictureOpenDialogExecute;
end;


function TfrClickerActions.HandleOnGetPictureOpenDialogFileName: string;
begin
  Result := DoOnGetPictureOpenDialogFileName;
end;


procedure TfrClickerActions.HandleOnUpdateSearchAreaLimitsInOIFromDraggingLines(ALimitLabelsToUpdate: TLimitLabels; var AOffsets: TSimpleRectString);
begin
  if llLeft in ALimitLabelsToUpdate then
  begin
    FEditingAction^.FindControlOptions.InitialRectangle.LeftOffset := AOffsets.Left;
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_InitialRectangle_PropIndex, CFindControl_InitialRectangle_LeftOffset_PropItemIndex);
  end;

  if llTop in ALimitLabelsToUpdate then
  begin
    FEditingAction^.FindControlOptions.InitialRectangle.TopOffset := AOffsets.Top;
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_InitialRectangle_PropIndex, CFindControl_InitialRectangle_TopOffset_PropItemIndex);
  end;

  if llRight in ALimitLabelsToUpdate then
  begin
    FEditingAction^.FindControlOptions.InitialRectangle.RightOffset := AOffsets.Right;
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_InitialRectangle_PropIndex, CFindControl_InitialRectangle_RightOffset_PropItemIndex);
  end;

  if llBottom in ALimitLabelsToUpdate then
  begin
    FEditingAction^.FindControlOptions.InitialRectangle.BottomOffset := AOffsets.Bottom;
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_InitialRectangle_PropIndex, CFindControl_InitialRectangle_BottomOffset_PropItemIndex);
  end;
end;


procedure TfrClickerActions.HandleOnUpdateTextCroppingLimitsInOIFromDraggingLines(ALimitLabelsToUpdate: TLimitLabels; var AOffsets: TSimpleRectString; AFontProfileIndex: Integer);
var
  UpdatingNodeIndex: Integer;
begin
  if llLeft in ALimitLabelsToUpdate then
  begin
    UpdatingNodeIndex := AFontProfileIndex * CPropCount_FindControlMatchBitmapText + CFindControl_MatchBitmapText_CropLeft;
    FEditingAction^.FindControlOptions.MatchBitmapText[AFontProfileIndex].CropLeft := AOffsets.Left;
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_MatchBitmapText_PropIndex, UpdatingNodeIndex);
  end;

  if llTop in ALimitLabelsToUpdate then
  begin
    UpdatingNodeIndex := AFontProfileIndex * CPropCount_FindControlMatchBitmapText + CFindControl_MatchBitmapText_CropTop;
    FEditingAction^.FindControlOptions.MatchBitmapText[AFontProfileIndex].CropTop := AOffsets.Top;
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_MatchBitmapText_PropIndex, UpdatingNodeIndex);
  end;

  if llRight in ALimitLabelsToUpdate then
  begin
    UpdatingNodeIndex := AFontProfileIndex * CPropCount_FindControlMatchBitmapText + CFindControl_MatchBitmapText_CropRight;
    FEditingAction^.FindControlOptions.MatchBitmapText[AFontProfileIndex].CropRight := AOffsets.Right;
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_MatchBitmapText_PropIndex, UpdatingNodeIndex);
  end;

  if llBottom in ALimitLabelsToUpdate then
  begin
    UpdatingNodeIndex := AFontProfileIndex * CPropCount_FindControlMatchBitmapText + CFindControl_MatchBitmapText_CropBottom;
    FEditingAction^.FindControlOptions.MatchBitmapText[AFontProfileIndex].CropBottom := AOffsets.Bottom;
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_MatchBitmapText_PropIndex, UpdatingNodeIndex);
  end;
end;


function TfrClickerActions.HandleOnGetDisplayedText: string;
begin
  Result := FEditingAction^.FindControlOptions.MatchText;
end;


procedure TfrClickerActions.HandleOnSetMatchTextAndClassToOI(AMatchText, AMatchClassName: string);
begin
  TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchText <> AMatchText);
  TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchClassName <> AMatchClassName);
  FEditingAction^.FindControlOptions.MatchText := AMatchText;
  FEditingAction^.FindControlOptions.MatchClassName := AMatchClassName;

  FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CFindControl_MatchText_PropIndex, -1, True);
  FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CFindControl_MatchClassName_PropIndex, -1, True);
end;


function TfrClickerActions.HandleOnGetFindControlOptions: PClkFindControlOptions;
begin
  Result := @FEditingAction^.FindControlOptions;
end;


function TfrClickerActions.HandleOnExecuteFindSubControlAction(AErrorLevel, AErrorCount, AFastSearchErrorCount: Integer; AFontName: string; AFontSize: Integer; out AFoundArea: TRect): Boolean;
begin
  Result := DoOnExecuteFindSubControlAction(AErrorLevel, AErrorCount, AFastSearchErrorCount, AFontName, AFontSize, AFoundArea);
end;


procedure TfrClickerActions.HandleOnAddToLog(s: string);
begin
  DoOnAddToLog(s);
end;


procedure TfrClickerActions.HandleOnClickerExecAppFrame_OnTriggerOnControlsModified;
begin
  FEditingAction.ExecAppOptions.ListOfParams := frClickerExecApp.memExecAppParams.Lines.Text;
  FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CExecApp_ListOfParams_PropIndex, -1);
  TriggerOnControlsModified;
end;


procedure TfrClickerActions.HandleOnClickerSetVarFrame_OnTriggerOnControlsModified;
begin
  FEditingAction.SetVarOptions := frClickerSetVar.GetListOfSetVars;
  TriggerOnControlsModified;
end;


function TfrClickerActions.HandleOnClickerSetVarFrame_OnGetFullTemplatesDir: string;
begin
  Result := FFullTemplatesDir;
end;


function TfrClickerActions.HandleOnClickerSetVarFrame_OnGetSelfTemplatesDir: string;
begin
  Result := DoOnGetSelfTemplatesDir;
end;


procedure TfrClickerActions.HandleOnClickerSetVarFrame_OnShowAutoComplete(AEdit: TEdit);
begin
  DoOnShowAutoComplete(AEdit);
end;


procedure TfrClickerActions.HandleOnClickerCallTemplateFrame_OnTriggerOnControlsModified;
begin
  FEditingAction.CallTemplateOptions.ListOfCustomVarsAndValues := frClickerCallTemplate.GetListOfCustomVariables;
  TriggerOnControlsModified;
end;


function TfrClickerActions.HandleOnEvaluateReplacementsFunc(s: string; Recursive: Boolean = True): string;
begin
  Result := EvaluateReplacements(s, Recursive);
end;


procedure TfrClickerActions.HandleOnLoadPrimitivesFile(AFileName: string; var APrimitives: TPrimitiveRecArr; var AOrders: TCompositionOrderArr; var ASettings: TPrimitiveSettings);
begin
  FCurrentlyEditingPrimitiveFileName := AFileName;
  DoOnLoadPrimitivesFile(AFileName, APrimitives, AOrders, ASettings);
end;


procedure TfrClickerActions.HandleOnSavePrimitivesFile(AFileName: string; var APrimitives: TPrimitiveRecArr; var AOrders: TCompositionOrderArr; var ASettings: TPrimitiveSettings);
begin
  FCurrentlyEditingPrimitiveFileName := AFileName; //required on save as
  DoOnSavePrimitivesFile(AFileName, APrimitives, AOrders, ASettings);
end;


function TfrClickerActions.GetIndexOfCurrentlyEditingPrimitivesFile: Integer;  //based on FCurrentlyEditingPrimitiveFileName
var
  ListOfPrimitiveFiles: TStringList;
  UpperCaseName: string;
  ResolvedFileName: string;
  i: Integer;
begin
  Result := -1;

  ListOfPrimitiveFiles := TStringList.Create;
  try
    ListOfPrimitiveFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;

    UpperCaseName := UpperCase(FCurrentlyEditingPrimitiveFileName);

    for i := 0 to ListOfPrimitiveFiles.Count - 1 do
    begin
      ResolvedFileName := ListOfPrimitiveFiles.Strings[i];
      ResolvedFileName := StringReplace(ResolvedFileName, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]);
      ResolvedFileName := StringReplace(ResolvedFileName, '$TemplateDir$', FFullTemplatesDir, [rfReplaceAll]);
      ResolvedFileName := StringReplace(ResolvedFileName, '$SelfTemplateDir$', ExtractFileDir(DoOnGetLoadedTemplateFileName), [rfReplaceAll]);
      ResolvedFileName := EvaluateReplacements(ResolvedFileName);

      if UpperCase(ResolvedFileName) = UpperCaseName then     //this requires the list to have unique filenames
      begin
        Result := i;
        Break;
      end;
    end;
  finally
    ListOfPrimitiveFiles.Free;
  end;
end;


procedure TfrClickerActions.HandleOnPrimitivesTriggerOnControlsModified;
var
  PrimitiveFileIndex: Integer;
  ListOfPrimitiveFiles_Modified: TStringList;
begin
  PrimitiveFileIndex := GetIndexOfCurrentlyEditingPrimitivesFile;

  if PrimitiveFileIndex <> -1 then
  begin
    ListOfPrimitiveFiles_Modified := TStringList.Create;
    try
      ListOfPrimitiveFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
      ListOfPrimitiveFiles_Modified.Strings[PrimitiveFileIndex] := '1';
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfPrimitiveFiles_Modified.Text;
    finally
      ListOfPrimitiveFiles_Modified.Free;
    end;

    //repaint node
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_ActionSpecific, CFindControl_MatchPrimitiveFiles_PropIndex, PrimitiveFileIndex);
  end;
end;


procedure TfrClickerActions.HandleOnSaveFromMenu(Sender: TObject);
var
  CurrentlyEditingPrimitiveFileIndex: Integer;
begin
  CurrentlyEditingPrimitiveFileIndex := GetIndexOfCurrentlyEditingPrimitivesFile;

  if CurrentlyEditingPrimitiveFileIndex <> -1 then
  begin
    SavePrimitivesFileFromMenu(CurrentlyEditingPrimitiveFileIndex);
    FOIFrame.ReloadPropertyItems(CCategory_ActionSpecific, CFindControl_MatchPrimitiveFiles_PropIndex);
  end
  else
    MessageBox(Handle, 'Can''t get index of editing primitives filename. Please make sure the owner action is selected.', PChar(Application.Title), MB_ICONERROR);
end;


procedure TfrClickerActions.HandleOnGetFontFinderSettings(var AFontFinderSettings: TFontFinderSettings);
begin
  DoOnGetFontFinderSettings(AFontFinderSettings);
end;


procedure TfrClickerActions.HandleOnSetFontFinderSettings(var AFontFinderSettings: TFontFinderSettings);
begin
  DoOnSetFontFinderSettings(AFontFinderSettings);
end;


procedure TfrClickerActions.HandleOnPluginDbgStop;
begin
  DoOnPluginDbgStop;
end;


procedure TfrClickerActions.HandleOnPluginDbgContinueAll;
begin
  DoOnPluginDbgContinueAll;
end;


procedure TfrClickerActions.HandleOnPluginDbgStepOver;
begin
  DoOnPluginDbgStepOver;
end;


function TfrClickerActions.HandleOnPluginDbgRequestLineNumber(out ALineContent, ADbgSymFile: string): Integer;
begin
  Result := DoOnPluginDbgRequestLineNumber(ALineContent, ADbgSymFile);
end;


procedure TfrClickerActions.HandleOnPluginDbgSetBreakpoint(ALineIndex, ASelectedSourceFileIndex: Integer; AEnabled: Boolean);
begin
  DoOnPluginDbgSetBreakpoint(ALineIndex, ASelectedSourceFileIndex, AEnabled);
end;


function TfrClickerActions.HandleOnTClkIniFileCreate(AFileName: string): TClkIniFile;
begin
  Result := DoOnTClkIniFileCreate(AFileName);
end;


function TfrClickerActions.DoOnEditCallTemplateBreakCondition(var AActionCondition: string): Boolean;
begin
  if not Assigned(FOnEditCallTemplateBreakCondition) then
    raise Exception.Create('OnEditCallTemplateBreakCondition not assigned.')
  else
    Result := FOnEditCallTemplateBreakCondition(AActionCondition);
end;


function TfrClickerActions.DoOnLoadBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
begin
  if not Assigned(FOnLoadBitmap) then
    raise Exception.Create('OnLoadBitmap not assigned.')
  else
    Result := FOnLoadBitmap(ABitmap, AFileName);
end;


function TfrClickerActions.DoOnLoadRenderedBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
begin
  if not Assigned(FOnLoadRenderedBitmap) then
    raise Exception.Create('OnLoadRenderedBitmap not assigned.')
  else
    Result := FOnLoadRenderedBitmap(ABitmap, AFileName);
end;


procedure TfrClickerActions.DoOnGetListOfExternallyRenderedImages(AListOfExternallyRenderedImages: TStringList);
begin
  if not Assigned(FOnGetListOfExternallyRenderedImages) then
    raise Exception.Create('OnGetListOfExternallyRenderedImages not assigned.')
  else
    FOnGetListOfExternallyRenderedImages(AListOfExternallyRenderedImages);
end;


procedure TfrClickerActions.DoOnLoadPrimitivesFile(AFileName: string; var APrimitives: TPrimitiveRecArr; var AOrders: TCompositionOrderArr; var ASettings: TPrimitiveSettings);
begin
  if not Assigned(FOnLoadPrimitivesFile) then
    raise Exception.Create('OnLoadPrimitivesFile not assigned.')
  else
    FOnLoadPrimitivesFile(AFileName, APrimitives, AOrders, ASettings);
end;


procedure TfrClickerActions.DoOnSavePrimitivesFile(AFileName: string; var APrimitives: TPrimitiveRecArr; var AOrders: TCompositionOrderArr; var ASettings: TPrimitiveSettings);
begin
  if not Assigned(FOnSavePrimitivesFile) then
    raise Exception.Create('OnSavePrimitivesFile not assigned.')
  else
    FOnSavePrimitivesFile(AFileName, APrimitives, AOrders, ASettings);
end;


function TfrClickerActions.DoOnFileExists(const AFileName: string): Boolean;
begin
  if not Assigned(FOnFileExists) then
    raise Exception.Create('OnFileExists is not assigned.')
  else
    Result := FOnFileExists(AFileName);
end;


procedure TfrClickerActions.DoOnSetOpenDialogMultiSelect;
begin
  if not Assigned(FOnSetOpenDialogMultiSelect) then
    raise Exception.Create('OnSetOpenDialogMultiSelect is not assigned.')
  else
    FOnSetOpenDialogMultiSelect;
end;


procedure TfrClickerActions.DoOnSetOpenDialogInitialDir(AInitialDir: string);
begin
  if not Assigned(FOnSetOpenDialogInitialDir) then
    raise Exception.Create('OnSetOpenDialogInitialDir is not assigned.')
  else
    FOnSetOpenDialogInitialDir(AInitialDir);
end;


function TfrClickerActions.DoOnOpenDialogExecute(AFilter: string): Boolean;
begin
  if not Assigned(FOnOpenDialogExecute) then
    raise Exception.Create('OnOpenDialogExecute is not assigned.')
  else
    Result := FOnOpenDialogExecute(AFilter);
end;


function TfrClickerActions.DoOnGetOpenDialogFileName: string;
begin
  if not Assigned(FOnGetOpenDialogFileName) then
    raise Exception.Create('OnGetOpenDialogFileName is not assigned.')
  else
    Result := FOnGetOpenDialogFileName;
end;


procedure TfrClickerActions.DoOnSetSaveDialogInitialDir(AInitialDir: string);
begin
  if not Assigned(FOnSetSaveDialogInitialDir) then
    raise Exception.Create('OnSetSaveDialogInitialDir is not assigned.')
  else
    FOnSetSaveDialogInitialDir(AInitialDir);
end;


function TfrClickerActions.DoOnSaveDialogExecute(AFilter: string): Boolean;
begin
  if not Assigned(FOnSaveDialogExecute) then
    raise Exception.Create('OnSaveDialogExecute is not assigned.')
  else
    Result := FOnSaveDialogExecute(AFilter);
end;


function TfrClickerActions.DoOnGetSaveDialogFileName: string;
begin
  if not Assigned(FOnGetSaveDialogFileName) then
    raise Exception.Create('OnGetSaveDialogFileName is not assigned.')
  else
    Result := FOnGetSaveDialogFileName;
end;


procedure TfrClickerActions.DoOnSetSaveDialogFileName(AFileName: string);
begin
  if not Assigned(FOnSetSaveDialogFileName) then
    raise Exception.Create('OnSetSaveDialogFileName is not assigned.')
  else
    FOnSetSaveDialogFileName(AFileName);
end;


procedure TfrClickerActions.DoOnSetPictureSetOpenDialogMultiSelect;
begin
  if not Assigned(FOnSetPictureSetOpenDialogMultiSelect) then
    raise Exception.Create('OnSetPictureSetOpenDialogMultiSelect is not assigned.')
  else
    FOnSetPictureSetOpenDialogMultiSelect;
end;


procedure TfrClickerActions.DoOnSetPictureOpenDialogInitialDir(AInitialDir: string);
begin
  if not Assigned(FOnSetPictureOpenDialogInitialDir) then
    raise Exception.Create('OnSetPictureOpenDialogInitialDir not assigned.')
  else
    FOnSetPictureOpenDialogInitialDir(AInitialDir);
end;


function TfrClickerActions.DoOnPictureOpenDialogExecute: Boolean;
begin
  if not Assigned(FOnPictureOpenDialogExecute) then
    raise Exception.Create('OnPictureOpenDialogExecute not assigned.')
  else
    Result := FOnPictureOpenDialogExecute;
end;


function TfrClickerActions.DoOnGetPictureOpenDialogFileName: string;
begin
  if not Assigned(FOnGetPictureOpenDialogFileName) then
    raise Exception.Create('OnGetPictureOpenDialogFileName not assigned.')
  else
    Result := FOnGetPictureOpenDialogFileName;
end;


function TfrClickerActions.DoOnExecuteFindSubControlAction(AErrorLevel, AErrorCount, AFastSearchErrorCount: Integer; AFontName: string; AFontSize: Integer; out AFoundArea: TRect): Boolean;
begin
  if not Assigned(FOnExecuteFindSubControlAction) then
    raise Exception.Create('OnExecuteFindSubControlAction not assigned.')
  else
    Result := FOnExecuteFindSubControlAction(AErrorLevel, AErrorCount, AFastSearchErrorCount, AFontName, AFontSize, AFoundArea);
end;


procedure TfrClickerActions.DoOnAddToLog(s: string);
begin
  if not Assigned(FOnAddToLog) then
    raise Exception.Create('OnAddToLog not assigned.')
  else
    FOnAddToLog(s);
end;


procedure TfrClickerActions.DoOnGetFontFinderSettings(var AFontFinderSettings: TFontFinderSettings);
begin
  if not Assigned(FOnGetFontFinderSettings) then
    raise Exception.Create('OnGetFontFinderSettings not assigned.')
  else
    FOnGetFontFinderSettings(AFontFinderSettings);
end;


procedure TfrClickerActions.DoOnSetFontFinderSettings(var AFontFinderSettings: TFontFinderSettings);
begin
  if not Assigned(FOnSetFontFinderSettings) then
    raise Exception.Create('OnSetFontFinderSettings not assigned.')
  else
    FOnSetFontFinderSettings(AFontFinderSettings);
end;


procedure TfrClickerActions.DoOnGetListOfAvailableSetVarActions(AListOfSetVarActions: TStringList);
begin
  if not Assigned(FOnGetListOfAvailableSetVarActions) then
    raise Exception.Create('OnGetListOfAvailableSetVarActions not assigned.')
  else
    FOnGetListOfAvailableSetVarActions(AListOfSetVarActions);
end;


procedure TfrClickerActions.DoOnGetListOfAvailableActions(AListOfActions: TStringList);
begin
  if not Assigned(FOnGetListOfAvailableActions) then
    raise Exception.Create('OnGetListOfAvailableActions not assigned.')
  else
    FOnGetListOfAvailableActions(AListOfActions);
end;


procedure TfrClickerActions.DoOnModifyPluginProperty(AAction: PClkActionRec);
begin
  if not Assigned(FOnModifyPluginProperty) then
    raise Exception.Create('OnModifyPluginProperty not assigned.')
  else
    FOnModifyPluginProperty(AAction);
end;


procedure TfrClickerActions.DoOnPluginDbgStop;
begin
  if not Assigned(FOnPluginDbgStop) then
    raise Exception.Create('OnPluginDbgStop not assigned.');

  FOnPluginDbgStop();
end;


procedure TfrClickerActions.DoOnPluginDbgContinueAll;
begin
  if not Assigned(FOnPluginDbgContinueAll) then
    raise Exception.Create('OnPluginDbgContinueAll not assigned.');

  FOnPluginDbgContinueAll();
end;


procedure TfrClickerActions.DoOnPluginDbgStepOver;
begin
  if not Assigned(FOnPluginDbgStepOver) then
    raise Exception.Create('OnPluginDbgStepOver not assigned.');

  FOnPluginDbgStepOver();
end;


function TfrClickerActions.DoOnPluginDbgRequestLineNumber(out ALineContent, ADbgSymFile: string): Integer;
begin
  if not Assigned(FOnPluginDbgRequestLineNumber) then
    raise Exception.Create('OnPluginDbgRequestLineNumber not assigned.');

  Result := FOnPluginDbgRequestLineNumber(ALineContent, ADbgSymFile);
end;


procedure TfrClickerActions.DoOnPluginDbgSetBreakpoint(ALineIndex, ASelectedSourceFileIndex: Integer; AEnabled: Boolean);
begin
  if not Assigned(FOnPluginDbgSetBreakpoint) then
    raise Exception.Create('OnPluginDbgSetBreakpoint not assigned.');

  FOnPluginDbgSetBreakpoint(ALineIndex, ASelectedSourceFileIndex, AEnabled);
end;


function TfrClickerActions.DoOnTClkIniFileCreate(AFileName: string): TClkIniFile;
begin
  if not Assigned(FOnTClkIniFileCreate) then
    raise Exception.Create('OnTClkIniFileCreate not assigned.');

  Result := FOnTClkIniFileCreate(AFileName);
end;


function TfrClickerActions.DoOnGetSelfTemplatesDir: string;
begin
  if not Assigned(FOnGetSelfTemplatesDir) then
    raise Exception.Create('OnGetSelfTemplatesDir not assigned.')
  else
    Result := FOnGetSelfTemplatesDir();
end;


procedure TfrClickerActions.DoOnShowAutoComplete(AEdit: TEdit);
begin
  if not Assigned(FOnShowAutoComplete) then
    raise Exception.Create('OnShowAutoComplete not assigned.')
  else
    FOnShowAutoComplete(AEdit);
end;


procedure TfrClickerActions.DoOnUpdateActionScrollIndex(AActionScrollIndex: string);
begin
  if not Assigned(FOnUpdateActionScrollIndex) then
    raise Exception.Create('OnUpdateActionScrollIndex not assigned.')
  else
    FOnUpdateActionScrollIndex(AActionScrollIndex);
end;


function TfrClickerActions.DoOnGetLoadedTemplateFileName: string;
begin
  if not Assigned(FOnGetLoadedTemplateFileName) then
    raise Exception.Create('OnGetLoadedTemplateFileName not assigned.')
  else
    Result := FOnGetLoadedTemplateFileName();
end;


//////////////////////////// OI

function TfrClickerActions.GetCurrentlyEditingActionType: TClkAction;
begin
  Result := TClkAction(FCurrentlyEditingActionType);
end;


procedure TfrClickerActions.SetCurrentlyEditingActionType(Value: TClkAction);
begin
  FCurrentlyEditingActionType := Ord(Value);
  BuildFontColorIconsList;
  FOIFrame.ReloadContent;
  pnlvstOI.Visible := True;

  pnlCover.Hide;

  case Value of
    acExecApp:
    begin
      frClickerExecApp.Show;
      frClickerExecApp.BringToFront;
      frClickerFindControl.Hide;
      frClickerSetVar.Hide;
      frClickerCallTemplate.Hide;
      frClickerSleep.Hide;
      frClickerPlugin.Hide;
    end;

    acFindControl, acFindSubControl:
    begin
      frClickerExecApp.Hide;
      frClickerFindControl.Show;
      frClickerFindControl.BringToFront;
      frClickerSetVar.Hide;
      frClickerCallTemplate.Hide;
      frClickerSleep.Hide;
      frClickerPlugin.Hide;
    end;

    acSetVar:
    begin
      frClickerExecApp.Hide;
      frClickerFindControl.Hide;
      frClickerSetVar.Show;
      frClickerSetVar.BringToFront;
      frClickerCallTemplate.Hide;
      frClickerSleep.Hide;
      frClickerPlugin.Hide;
    end;

    acCallTemplate:
    begin
      frClickerExecApp.Hide;
      frClickerFindControl.Hide;
      frClickerSetVar.Hide;
      frClickerCallTemplate.Show;
      frClickerCallTemplate.BringToFront;
      frClickerSleep.Hide;
      frClickerPlugin.Hide;
    end;

    acSleep:
    begin
      frClickerExecApp.Hide;
      frClickerFindControl.Hide;
      frClickerSetVar.Hide;
      frClickerCallTemplate.Hide;
      frClickerSleep.Show;
      frClickerSleep.BringToFront;
      frClickerPlugin.Hide;
    end;

    acPlugin:
    begin
      frClickerExecApp.Hide;
      frClickerFindControl.Hide;
      frClickerSetVar.Hide;
      frClickerCallTemplate.Hide;
      frClickerSleep.Hide;
      frClickerPlugin.Show;
      frClickerPlugin.BringToFront;
    end;

    else
    begin
      frClickerExecApp.Hide;
      frClickerFindControl.Hide;
      frClickerSetVar.Hide;
      frClickerCallTemplate.Hide;
      frClickerSleep.Hide;
      frClickerPlugin.Hide;

      pnlCover.Left := 0;
      pnlCover.Top := 0;
      pnlCover.Width := pnlExtra.Width;
      pnlCover.Height := pnlExtra.Height;
      pnlCover.Show;
      pnlCover.BringToFront;
    end;
  end;
end;


procedure TfrClickerActions.RefreshActionName;
begin
  FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, CCategory_Common, CMain_ActionName_PropIndex, -1);
end;


procedure TfrClickerActions.ResetAllPmtvModifiedFlags;
var
  ListOfFiles_Modified: TStringList;
  i: Integer;
begin
  ListOfFiles_Modified := TStringList.Create;
  try
    ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;

    for i := 0 to ListOfFiles_Modified.Count - 1 do
      ListOfFiles_Modified.Strings[i] := '0';

    FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;
    frClickerFindControl.frClickerPrimitives.ClearContent;
  finally
    ListOfFiles_Modified.Free;
  end;
end;


procedure TfrClickerActions.SetGridDrawingOption(Value: TDisplayGridLineOption);
begin
  frClickerFindControl.GridDrawingOption := Value;
  frClickerFindControl.RefreshGrid;
end;


procedure TfrClickerActions.SetPreviewSelectionColors(Value: TSelectionColors);
begin
  frClickerFindControl.PreviewSelectionColors := Value;
end;


function TfrClickerActions.GetModifiedPmtvFiles: Boolean;
begin
  Result := GetIndexOfFirstModifiedPmtvFile > -1;
end;


procedure TfrClickerActions.tmrReloadOIContentTimer(Sender: TObject);
begin
  tmrReloadOIContent.Enabled := False;
  FOIFrame.ReloadContent;
end;


procedure TfrClickerActions.CopyTextAndClassFromExternalProvider(AProviderName: string);
var
  ControlText, ControlClass: string;
begin
  if not Assigned(FOnCopyControlTextAndClassFromMainWindow) then
    raise Exception.Create('OnCopyControlTextAndClass not assigned for ' + Caption)
  else
  begin
    FOIFrame.CancelCurrentEditing;

    FOnCopyControlTextAndClassFromMainWindow(AProviderName, ControlText, ControlClass);

    TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchText <> ControlText);
    TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchClassName <> ControlClass);

    FEditingAction^.FindControlOptions.MatchText := ControlText;
    FEditingAction^.FindControlOptions.MatchClassName := ControlClass;

    FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CFindControl_MatchText_PropIndex, -1);
    FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_ActionSpecific, CFindControl_MatchClassName_PropIndex, -1);
  end;
end;


procedure TfrClickerActions.SetActionTimeoutToValue(AValue: Integer);
begin
  FOIFrame.CancelCurrentEditing;
  FEditingAction^.ActionOptions.ActionTimeout := AValue;
  FOIFrame.RepaintNodeByLevel(CPropertyLevel, CCategory_Common, CMain_ActionTimeout_PropIndex, -1);
end;


procedure TfrClickerActions.MenuItem_SetActionTimeoutFromOI(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ValueStr: string;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ValueStr := StringReplace(MenuData^.MenuItemCaption, '&', '', [rfReplaceAll]);
    SetActionTimeoutToValue(StrToIntDef(ValueStr, 0));
    TriggerOnControlsModified;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.FreeOIPopupMenu(Sender: TObject);
var
  MenuData: POIMenuItemData;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  Dispose(MenuData);
end;


procedure TfrClickerActions.MenuItem_CopyTextAndClassFromPreviewWindowClick(Sender: TObject);
begin
  CopyTextAndClassFromExternalProvider(CExtProvPreviewWindow);
  FreeOIPopupMenu(Sender);
end;


procedure TfrClickerActions.MenuItem_CopyTextAndClassFromWinInterpWindowClick(Sender: TObject);
begin
  CopyTextAndClassFromExternalProvider(CExtProvWinInterpWindow);
  FreeOIPopupMenu(Sender);
end;


procedure TfrClickerActions.MenuItem_CopyTextAndClassFromRemoteScreenWindowClick(Sender: TObject);
begin
  CopyTextAndClassFromExternalProvider(CExtProvRemoteScreenWindow);
  FreeOIPopupMenu(Sender);
end;


procedure TfrClickerActions.MenuItem_SetTextAndClassAsSystemMenuClick(Sender: TObject);
begin
  CopyTextAndClassFromExternalProvider(CExtProvSystemMenu);
  FreeOIPopupMenu(Sender);
end;


procedure TfrClickerActions.MenuItem_AddBMPFilesToPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
begin
  DoOnSetPictureSetOpenDialogMultiSelect;
  if not DoOnPictureOpenDialogExecute then
    Exit;

  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchBitmapFiles;
      ListOfFiles.Text := ListOfFiles.Text + DoOnGetPictureOpenDialogFileName;
      FEditingAction^.FindControlOptions.MatchBitmapFiles := ListOfFiles.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_RemoveAllBMPFilesFromPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
begin
  if MessageBox(Handle, 'Are you sure you want to remove all files from this list?', PChar(Application.MainForm.Caption), MB_ICONQUESTION + MB_YESNO) = IDNO then
    Exit;

  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    FEditingAction^.FindControlOptions.MatchBitmapFiles := '';
    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
    TriggerOnControlsModified;
    frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_BrowseBMPFileFromPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    //DoOnSetPictureOpenDialogInitialDir();
    if not DoOnPictureOpenDialogExecute then
      Exit;

    ListOfFiles := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchBitmapFiles;
      ListOfFiles.Strings[MenuData^.PropertyItemIndex] := DoOnGetPictureOpenDialogFileName;
      FEditingAction^.FindControlOptions.MatchBitmapFiles := ListOfFiles.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_RemoveBMPFileFromPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
begin
  if MessageBox(Handle, 'Are you sure you want to remove this file from list?', PChar(Application.MainForm.Caption), MB_ICONQUESTION + MB_YESNO) = IDNO then
    Exit;

  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchBitmapFiles;
      ListOfFiles.Delete(MenuData^.PropertyItemIndex);
      FEditingAction^.FindControlOptions.MatchBitmapFiles := ListOfFiles.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_MoveBMPFileUpInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    try
      if MenuData^.PropertyItemIndex <= 0 then
        Exit;

      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchBitmapFiles;
      ListOfFiles.Move(MenuData^.PropertyItemIndex, MenuData^.PropertyItemIndex - 1);
      FEditingAction^.FindControlOptions.MatchBitmapFiles := ListOfFiles.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_MoveBMPFileDownInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchBitmapFiles;
      if MenuData^.PropertyItemIndex >= ListOfFiles.Count - 1 then
        Exit;

      ListOfFiles.Move(MenuData^.PropertyItemIndex, MenuData^.PropertyItemIndex + 1);
      FEditingAction^.FindControlOptions.MatchBitmapFiles := ListOfFiles.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_AddExistingPrimitiveFilesToPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
  i, OldCount: Integer;
begin
  DoOnSetOpenDialogMultiSelect;
  if not DoOnOpenDialogExecute(CPrimitivesDialogFilter) then
    Exit;

  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    ListOfFiles_Modified := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
      OldCount := ListOfFiles.Count;
      ListOfFiles.Text := ListOfFiles.Text + DoOnGetOpenDialogFileName;
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles := ListOfFiles.Text;

      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;

      for i := OldCount to ListOfFiles.Count - 1 do
        ListOfFiles_Modified.Add('0');

      FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
      ListOfFiles_Modified.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_AddNewPrimitiveFilesToPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
begin
  //DoOnSetOpenDialogMultiSelect; //do not call multiselect, as this is a single file save
  DoOnSetSaveDialogFileName('');
  if not DoOnSaveDialogExecute(CPrimitivesDialogFilter) then
    Exit;

  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    ListOfFiles_Modified := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
      ListOfFiles.Text := ListOfFiles.Text + DoOnGetSaveDialogFileName;
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles := ListOfFiles.Text;

      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
      ListOfFiles_Modified.Add('0');
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
      ListOfFiles_Modified.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_RemoveAllPrimitiveFilesFromPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
begin
  if MessageBox(Handle, 'Are you sure you want to remove all files from this list?', PChar(Application.MainForm.Caption), MB_ICONQUESTION + MB_YESNO) = IDNO then
    Exit;

  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    FEditingAction^.FindControlOptions.MatchPrimitiveFiles := '';
    FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := '';

    FPrevSelectedPrimitiveNode := -1;
    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);

    TriggerOnControlsModified;
    frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_BrowsePrimitiveFileFromPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    //DoOnSetOpenDialogMultiSelect;
    if not DoOnOpenDialogExecute(CPrimitivesDialogFilter) then
      Exit;

    ListOfFiles := TStringList.Create;
    ListOfFiles_Modified := TStringList.Create;
    try
      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;

      if ListOfFiles_Modified.Strings[MenuData^.PropertyItemIndex] = '1' then
        if MessageBox(Handle, 'The file is modified. Do you want to set this to another file and discard all changes?', PChar(Application.Title), MB_ICONQUESTION + MB_YESNO) = IDNO then
          Exit;

      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
      ListOfFiles.Strings[MenuData^.PropertyItemIndex] := DoOnGetOpenDialogFileName;
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles := ListOfFiles.Text;

      ListOfFiles_Modified.Strings[MenuData^.PropertyItemIndex] := '0';
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
      ListOfFiles_Modified.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_RemovePrimitiveFileFromPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
begin
  if MessageBox(Handle, 'Are you sure you want to remove this file from list?', PChar(Application.MainForm.Caption), MB_ICONQUESTION + MB_YESNO) = IDNO then
    Exit;

  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    ListOfFiles_Modified := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
      ListOfFiles.Delete(MenuData^.PropertyItemIndex);
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles := ListOfFiles.Text;

      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
      ListOfFiles_Modified.Delete(MenuData^.PropertyItemIndex);
      FEditingAction.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;

      FPrevSelectedPrimitiveNode := -1;
      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
      ListOfFiles_Modified.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_MovePrimitiveFileUpInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    ListOfFiles_Modified := TStringList.Create;
    try
      if MenuData^.PropertyItemIndex <= 0 then
        Exit;

      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
      ListOfFiles.Move(MenuData^.PropertyItemIndex, MenuData^.PropertyItemIndex - 1);
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles := ListOfFiles.Text;

      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
      ListOfFiles_Modified.Move(MenuData^.PropertyItemIndex, MenuData^.PropertyItemIndex - 1);
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;

      Dec(FPrevSelectedPrimitiveNode);
      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
      ListOfFiles_Modified.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_MovePrimitiveFileDownInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    ListOfFiles_Modified := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
      if MenuData^.PropertyItemIndex >= ListOfFiles.Count - 1 then
        Exit;

      ListOfFiles.Move(MenuData^.PropertyItemIndex, MenuData^.PropertyItemIndex + 1);
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles := ListOfFiles.Text;

      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
      ListOfFiles_Modified.Move(MenuData^.PropertyItemIndex, MenuData^.PropertyItemIndex + 1);
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;

      Inc(FPrevSelectedPrimitiveNode);
      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
      ListOfFiles_Modified.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.SavePrimitivesFileFromMenu(AFileIndex: Integer);
var
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
  PmtvFnm: string;
begin
  ListOfFiles := TStringList.Create;
  ListOfFiles_Modified := TStringList.Create;
  try
    ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;

    PmtvFnm := ListOfFiles.Strings[AFileIndex];
    PmtvFnm := StringReplace(PmtvFnm, '$TemplateDir$', FFullTemplatesDir, [rfReplaceAll]);
    PmtvFnm := StringReplace(PmtvFnm, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]);
    PmtvFnm := StringReplace(PmtvFnm, '$SelfTemplateDir$', ExtractFileDir(DoOnGetLoadedTemplateFileName), [rfReplaceAll]);
    PmtvFnm := EvaluateReplacements(PmtvFnm);

    DoOnAddToLog('Saving primitives file: "' + PmtvFnm + '"');

    frClickerFindControl.frClickerPrimitives.SaveFile(PmtvFnm);

    //maybe the following three lines, should be moved to the OnSave handler
    ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
    ListOfFiles_Modified.Strings[AFileIndex] := '0';
    FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;
  finally
    ListOfFiles.Free;
    ListOfFiles_Modified.Free;
  end;
end;


procedure TfrClickerActions.MenuItem_SavePrimitiveFileInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    SavePrimitivesFileFromMenu(MenuData^.PropertyItemIndex);
    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);
    //TriggerOnControlsModified;  //commented, because the template is not modified by this action
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_SavePrimitiveFileAsInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
  PmtvFnm: string;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    ListOfFiles_Modified := TStringList.Create;
    try
      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;

      PmtvFnm := ListOfFiles.Strings[MenuData^.PropertyItemIndex];
      PmtvFnm := StringReplace(PmtvFnm, '$TemplateDir$', FFullTemplatesDir, [rfReplaceAll]);
      PmtvFnm := StringReplace(PmtvFnm, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]);
      PmtvFnm := StringReplace(PmtvFnm, '$SelfTemplateDir$', ExtractFileDir(DoOnGetLoadedTemplateFileName), [rfReplaceAll]);
      PmtvFnm := EvaluateReplacements(PmtvFnm);

      DoOnSetSaveDialogInitialDir(ExtractFileDir(PmtvFnm));
      if not DoOnSaveDialogExecute(CPrimitivesDialogFilter) then
        Exit;

      ListOfFiles.Strings[MenuData^.PropertyItemIndex] := DoOnGetSaveDialogFileName;  //Let the user replace back with $AppDir$ if that's the case. The dialog doesn't know about replacements.

      frClickerFindControl.frClickerPrimitives.SaveFile(ListOfFiles.Strings[MenuData^.PropertyItemIndex]);
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles := ListOfFiles.Text;

      //maybe the following three lines, should be moved to the OnSave handler
      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
      ListOfFiles_Modified.Strings[MenuData^.PropertyItemIndex] := '0';
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);

      TriggerOnControlsModified;
      frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
    finally
      ListOfFiles.Free;
      ListOfFiles_Modified.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_DiscardChangesAndReloadPrimitiveFileInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  ListOfFiles: TStringList;
  ListOfFiles_Modified: TStringList;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    ListOfFiles := TStringList.Create;
    ListOfFiles_Modified := TStringList.Create;
    try
      if MessageBox(Handle, 'Discard changes and reload?', PChar(Application.Title), MB_ICONQUESTION + MB_YESNO) = IDNO then
        Exit;

      ListOfFiles.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
      frClickerFindControl.frClickerPrimitives.LoadFile(ListOfFiles.Strings[MenuData^.PropertyItemIndex]);

      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
      ListOfFiles_Modified.Strings[MenuData^.PropertyItemIndex] := '0';
      FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := ListOfFiles_Modified.Text;

      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);
      //TriggerOnControlsModified;  //commented, because the template is not modified by this action
    finally
      ListOfFiles.Free;
      ListOfFiles_Modified.Free;
    end;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_BrowseImageSourceFromPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    //DoOnSetPictureOpenDialogInitialDir();
    if not DoOnPictureOpenDialogExecute then
      Exit;

    FEditingAction^.FindControlOptions.SourceFileName := DoOnGetPictureOpenDialogFileName;
    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);  //this closes the editor
    TriggerOnControlsModified;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_NoImageSourceInInMemPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    MessageBox(Handle, 'No files in In-Mem file system. They are usually saved by the $RenderBmpExternally()$ function or by plugins.', PChar(Application.Title), MB_ICONINFORMATION);
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_SetFileNameFromInMemPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  Fnm: string;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    Fnm := StringReplace(MenuData.MenuItemCaption, '&', '', [rfReplaceAll]);
    Fnm := Copy(Fnm, 1, Pos(#8#7, Fnm) - 1);

    FEditingAction^.FindControlOptions.SourceFileName := Fnm;
    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);  //this closes the editor
    TriggerOnControlsModified;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_BrowseFileNameFromInMemPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  Fnm: string;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    Fnm := BrowseInMemFSFile(ExtRenderingInMemFS);
    if Fnm <> '' then
    begin
      FEditingAction^.FindControlOptions.SourceFileName := Fnm;
      FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex, True);  //this closes the editor
      TriggerOnControlsModified;
    end;
  finally
    Dispose(MenuData);
  end;
end;


function TfrClickerActions.GetUniqueProfileName(n: Integer): string;
var
  AttemptCount: Integer;
begin
  Result := 'Profile [' + IntToStr(n) + ']';

  AttemptCount := 0;
  while frClickerFindControl.GetFontProfileIndexByName(Result) <> -1 do
  begin
    Result := Result + 'A';
    Inc(AttemptCount);

    if AttemptCount > 1000 then
      raise Exception.Create('Can''t generate a new font profile name.');
  end;
end;


function TfrClickerActions.DummyEvaluateReplacements(VarName: string; Recursive: Boolean = True): string; //returns VarName
begin
  Result := VarName;
end;


//Returns the index of the new item  (i.e. the previous length of MatchBitmapText array.
function TfrClickerActions.AddFontProfileToActionFromMenu(AForegroundColor, ABackgroundColor, AFontName: string; AFontSize: Integer; AFontQuality: TFontQuality): Integer;
var
  n: Integer;
begin
  n := Length(FEditingAction^.FindControlOptions.MatchBitmapText);
  SetLength(FEditingAction^.FindControlOptions.MatchBitmapText, n + 1);

  FEditingAction^.FindControlOptions.MatchBitmapText[n].ForegroundColor := AForegroundColor;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].BackgroundColor := ABackgroundColor;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].FontName := AFontName;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].FontSize := AFontSize;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].FontQualityReplacement := '';
  FEditingAction^.FindControlOptions.MatchBitmapText[n].FontQuality := AFontQuality;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].FontQualityUsesReplacement := False;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].Bold := False;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].Italic := False;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].Underline := False;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].StrikeOut := False;
  FEditingAction^.FindControlOptions.MatchBitmapText[n].CropLeft := '0';
  FEditingAction^.FindControlOptions.MatchBitmapText[n].CropTop := '0';
  FEditingAction^.FindControlOptions.MatchBitmapText[n].CropRight := '0';
  FEditingAction^.FindControlOptions.MatchBitmapText[n].CropBottom := '0';
  FEditingAction^.FindControlOptions.MatchBitmapText[n].ProfileName := GetUniqueProfileName(n);

  frClickerFindControl.AddNewFontProfile(FEditingAction^.FindControlOptions.MatchBitmapText[n]);
  BuildFontColorIconsList;

  Result := n;
end;


procedure TfrClickerActions.MenuItem_AddFontProfileToPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  n: Integer;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    n := AddFontProfileToActionFromMenu('$Color_Window$', '$Color_Highlight$', 'Tahoma', 8, fqNonAntialiased);

    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
    TriggerOnControlsModified;

    FOIFrame.SelectNode(CPropertyItemLevel, MenuData^.CategoryIndex, MenuData^.PropertyIndex, n * CPropCount_FindControlMatchBitmapText);
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, MenuData^.CategoryIndex, MenuData^.PropertyIndex, n * CPropCount_FindControlMatchBitmapText, True, True);
    FOIFrame.FocusOI;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_AddFontProfileWithAntialiasedAndClearTypeToPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  n: Integer;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    n := AddFontProfileToActionFromMenu('$Color_WindowText$', '$Color_BtnFace$', 'Segoe UI', 9, fqAntialiased);
    n := AddFontProfileToActionFromMenu('$Color_WindowText$', '$Color_BtnFace$', 'Segoe UI', 9, fqCleartype);

    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
    TriggerOnControlsModified;

    FOIFrame.SelectNode(CPropertyItemLevel, MenuData^.CategoryIndex, MenuData^.PropertyIndex, n * CPropCount_FindControlMatchBitmapText);
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, MenuData^.CategoryIndex, MenuData^.PropertyIndex, n * CPropCount_FindControlMatchBitmapText, True, True);
    FOIFrame.FocusOI;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_AddFontProfileWithNonAntialiasedAndAntialiasedAndClearTypeToPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  n: Integer;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    n := AddFontProfileToActionFromMenu('$Color_WindowText$', '$Color_BtnFace$', 'Segoe UI', 9, fqNonAntialiased);
    n := AddFontProfileToActionFromMenu('$Color_WindowText$', '$Color_BtnFace$', 'Segoe UI', 9, fqAntialiased);
    n := AddFontProfileToActionFromMenu('$Color_WindowText$', '$Color_BtnFace$', 'Segoe UI', 9, fqCleartype);

    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
    TriggerOnControlsModified;

    FOIFrame.SelectNode(CPropertyItemLevel, MenuData^.CategoryIndex, MenuData^.PropertyIndex, n * CPropCount_FindControlMatchBitmapText);
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, MenuData^.CategoryIndex, MenuData^.PropertyIndex, n * CPropCount_FindControlMatchBitmapText, True, True);
    FOIFrame.FocusOI;
  finally
    Dispose(MenuData);
  end;
end;



procedure TfrClickerActions.MenuItem_RemoveFontProfileFromPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  n, i: Integer;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    n := Length(FEditingAction^.FindControlOptions.MatchBitmapText);

    if MessageBox(Handle,
                  PChar('Are you sure you want to remove font profile: ' + FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex].ProfileName),
                  PChar(Application.Title),
                  MB_ICONQUESTION + MB_YESNO) = IDNO then
      Exit;

    for i := MenuData^.PropertyItemIndex to n - 2 do
      FEditingAction^.FindControlOptions.MatchBitmapText[i] := FEditingAction^.FindControlOptions.MatchBitmapText[i + 1];

    SetLength(FEditingAction^.FindControlOptions.MatchBitmapText, n - 1);

    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);

    frClickerFindControl.RemoveFontProfileByIndex(MenuData^.PropertyItemIndex);
    TriggerOnControlsModified;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_DuplicateFontProfileClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  n: Integer;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    n := Length(FEditingAction^.FindControlOptions.MatchBitmapText);
    SetLength(FEditingAction^.FindControlOptions.MatchBitmapText, n + 1);

    FEditingAction^.FindControlOptions.MatchBitmapText[n] := FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex];
    FEditingAction^.FindControlOptions.MatchBitmapText[n].ProfileName := GetUniqueProfileName(n);

    frClickerFindControl.AddNewFontProfile(FEditingAction^.FindControlOptions.MatchBitmapText[n]);
    BuildFontColorIconsList;

    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
    TriggerOnControlsModified;

    FOIFrame.SelectNode(CPropertyItemLevel, MenuData^.CategoryIndex, MenuData^.PropertyIndex, n * CPropCount_FindControlMatchBitmapText);
    FOIFrame.RepaintNodeByLevel(CPropertyItemLevel, MenuData^.CategoryIndex, MenuData^.PropertyIndex, n * CPropCount_FindControlMatchBitmapText, True, True);
    FOIFrame.FocusOI;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_MoveFontProfileUpInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  TempProfile: TClkFindControlMatchBitmapText;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    if MenuData^.PropertyItemIndex <= 0 then
      Exit;

    TempProfile := FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex];
    FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex] :=
      FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex - 1];

    FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex - 1] := TempProfile;

    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
    TriggerOnControlsModified;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_MoveFontProfileDownInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  TempProfile: TClkFindControlMatchBitmapText;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    if MenuData^.PropertyItemIndex >= Length(FEditingAction^.FindControlOptions.MatchBitmapText) - 1 then
      Exit;

    TempProfile := FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex];
    FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex] :=
      FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex + 1];

    FEditingAction^.FindControlOptions.MatchBitmapText[MenuData^.PropertyItemIndex + 1] := TempProfile;

    FOIFrame.ReloadPropertyItems(MenuData^.CategoryIndex, MenuData^.PropertyIndex);
    TriggerOnControlsModified;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_BrowseSetVarFileInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  PathToFileName: string;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    if not DoOnOpenDialogExecute('*.*') then
      Exit;

    PathToFileName := DoOnGetOpenDialogFileName;

    if ExtractFileDrive(ParamStr(0)) = ExtractFileDrive(PathToFileName) then
      PathToFileName := '$AppDir$\' + ExtractRelativePath(ExtractFilePath(ParamStr(0)), PathToFileName);

    case CurrentlyEditingActionType of
      acLoadSetVarFromFile:
        FEditingAction^.LoadSetVarFromFileOptions.FileName := PathToFileName;

      acSaveSetVarToFile:
        FEditingAction^.SaveSetVarToFileOptions.FileName := PathToFileName;

      else
        ;
    end;

    FOIFrame.CancelCurrentEditing;
    FOIFrame.Repaint;   //ideally, RepaintNodeByLevel
    TriggerOnControlsModified;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItem_BrowsePluginFileInPropertyListClick(Sender: TObject);
var
  MenuData: POIMenuItemData;
  PathToFileName: string;
begin
  MenuData := {%H-}POIMenuItemData((Sender as TMenuItem).Tag);
  try
    if not DoOnOpenDialogExecute('Dll files (*.dll)|*.dll|All files (*.*)|*.*') then
      Exit;

    PathToFileName := DoOnGetOpenDialogFileName;

    if ExtractFileDrive(ParamStr(0)) = ExtractFileDrive(PathToFileName) then
      PathToFileName := '$AppDir$\' + ExtractRelativePath(ExtractFilePath(ParamStr(0)), PathToFileName);

    FEditingAction^.PluginOptions.FileName := PathToFileName;

    FOIFrame.CancelCurrentEditing;
    FOIFrame.Repaint;   //ideally, RepaintNodeByLevel
    TriggerOnControlsModified;

    DoOnModifyPluginProperty(FEditingAction);
    tmrReloadOIContent.Enabled := True;
  finally
    Dispose(MenuData);
  end;
end;


procedure TfrClickerActions.MenuItemControl_EdgeRefGenericClick(Sender: TObject);
var
  s: string;
begin
  try
    s := StringReplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll]);
    Delete(s, 1, 1); //delete first '$'
    s := '$' + Copy(s, 1, Pos('$', s));

    if Assigned(FLastClickedTVTEdit) then
    begin
      FLastClickedTVTEdit.Text := s;
      FOIFrame.EditingText := FLastClickedTVTEdit.Text;
    end;

    if Assigned(FLastClickedEdit) then
    begin
      FLastClickedEdit.Text := s;
      if Assigned(FLastClickedEdit.OnChange) then
        FLastClickedEdit.OnChange(FLastClickedEdit);
    end;
  except
    on E: Exception do
      MessageBox(Handle, PChar('EditBox is not available.' + #13#10 + E.Message), PChar(Application.MainForm.Caption), MB_ICONERROR);
  end;
end;


procedure TfrClickerActions.MenuItemCopyRefToClipboardClick(Sender: TObject);
begin
  try
    if Assigned(FLastClickedTVTEdit) then
      Clipboard.AsText := FLastClickedTVTEdit.Text;

    if Assigned(FLastClickedEdit) then
      Clipboard.AsText := FLastClickedEdit.Text;
  except
    on E: Exception do
      MessageBox(Handle, PChar('EditBox is not available.' + #13#10 + E.Message), PChar(Application.MainForm.Caption), MB_ICONERROR);
  end;
end;


procedure TfrClickerActions.MenuItemPasteRefFromClipboardClick(Sender: TObject);
begin
  try
    if Assigned(FLastClickedTVTEdit) then
    begin
      FLastClickedTVTEdit.Text := Clipboard.AsText;
      FOIFrame.EditingText := FLastClickedTVTEdit.Text;
    end;

    if Assigned(FLastClickedEdit) then
    begin
      FLastClickedEdit.Text := Clipboard.AsText;
      if Assigned(FLastClickedEdit.OnChange) then
        FLastClickedEdit.OnChange(FLastClickedEdit);
    end;
  except
    on E: Exception do
      MessageBox(Handle, PChar('EditBox is not available.' + #13#10 + E.Message), PChar(Application.MainForm.Caption), MB_ICONERROR);
  end;
end;


procedure TfrClickerActions.vstVariablesCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
var
  TempStringEditLink: TStringEditLink;
begin
  TempStringEditLink := TStringEditLink.Create;
  EditLink := TempStringEditLink;

  FTextEditorEditBox := TEdit(TCustomEdit(TempStringEditLink.Edit));
  FTextEditorEditBox.Font.Name := 'Tahoma';
  FTextEditorEditBox.Font.Size := 8;
  //FTextEditorEditBox.Height := vstVariables.DefaultNodeHeight - 3;  //set again in timer

  FTextEditorEditBox.Show;
end;


procedure TfrClickerActions.vstVariablesEdited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  case Column of
    0:
      FClkVariables.Strings[Node^.Index] := FEditingText + '=' + FClkVariables.ValueFromIndex[Node^.Index];

    1:
      FClkVariables.Strings[Node^.Index] := FClkVariables.Names[Node^.Index] + '=' + FEditingText;
      //do not use FClkVariables.ValueFromIndex[Node^.Index] := FEditingText;  because it deletes items
  end;
end;


procedure TfrClickerActions.vstVariablesEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: boolean);
begin
  Allowed := True;

  case Column of
    0:
      FEditingText := FClkVariables.Names[Node^.Index];

    1:
      FEditingText := FClkVariables.ValueFromIndex[Node^.Index];
  end;
end;


procedure TfrClickerActions.vstVariablesNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const NewText: string);
begin
  FEditingText := NewText;
end;


procedure TfrClickerActions.vstVariablesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData: PVarNodeRec;
begin
  try
    if Node^.Parent = vstVariables.RootNode then
    begin
      case Column of
        0:
          CellText := FClkVariables.Names[Node^.Index];

        1:
          CellText := FClkVariables.ValueFromIndex[Node^.Index];
      end;
    end
    else
    begin
      NodeData := vstVariables.GetNodeData(Node);
      if not Assigned(NodeData) then
      begin
        CellText := 'N/A';
        Exit;
      end;

      case Column of
        0:
          CellText := NodeData^.VarName;

        1:
          CellText := NodeData^.VarValue;
      end;
    end;
  except
    CellText := '';
    tmrClkVariables.Enabled := True; //Trigger a repaint
  end;
end;


procedure TfrClickerActions.vstVariablesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NodeData: PVarNodeRec;
begin
  vstVariables.GetHitTestInfoAt(X, Y, True, FHitInfo);

  if FHitInfo.HitColumn in [0..1] then
    if FHitInfo.HitNode^.Parent = vstVariables.RootNode then
      tmrEditClkVariables.Enabled := True
    else
    begin
      if FlblResultSelLeft = nil then
        CreateSelectionLabelsForResult;

      NodeData := vstVariables.GetNodeData(FHitInfo.HitNode);
      if NodeData = nil then
        Exit;

      SelectAreaFromDecodedVariable(NodeData, FHitInfo.HitNode^.Index);
    end;
end;


procedure TfrClickerActions.BuildFontColorIconsList;
begin
  BuildFontColorIcons(imglstFontColorProperties, FEditingAction^.FindControlOptions, EvaluateReplacements);
end;


function TfrClickerActions.HandleOnOIGetCategoryCount: Integer;
begin
  Result := CCategoryCount;
end;


function TfrClickerActions.HandleOnOIGetCategory(AIndex: Integer): string;
begin
  Result := CCategories[AIndex];
end;


function TfrClickerActions.HandleOnOIGetPropertyCount(ACategoryIndex: Integer): Integer;
var
  EditingActionType: Integer;
begin
  case ACategoryIndex of
    CCategory_Common:
      Result := CPropCount_Common;

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        Result := 0 //no action is selected
      else
        Result := CMainPropCounts[EditingActionType];

      if CurrentlyEditingActionType = acPlugin then
        Result := Result + FEditingAction.PluginOptions.CachedCount;
    end;

    else
      Result := 0;
  end;

  if Result > 500 then   //This will hide some bugs (for now). At least it will prevent crashes and memory overuse.
    Result := 500;

  if Result < 0 then
    Result := 0;
end;


function TfrClickerActions.HandleOnOIGetPropertyName(ACategoryIndex, APropertyIndex: Integer): string;
const
  CNotUsedStr = '   [Not used]';
var
  EditingActionType: Integer;
  ListOfProperties: TStringList;
begin
  case ACategoryIndex of
    CCategory_Common:
      Result := CCommonProperties[APropertyIndex].Name;

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        Result := '?'
      else
      begin
        if (CurrentlyEditingActionType = acPlugin) and (APropertyIndex > CPlugin_FileName_PropIndex) then
        begin
          ListOfProperties := TStringList.Create;
          try
            ListOfProperties.Text := FEditingAction.PluginOptions.ListOfPropertiesAndTypes;
            try
              if (APropertyIndex - 1 < ListOfProperties.Count) and (ListOfProperties.Count > 0) then
                Result := ListOfProperties.Names[APropertyIndex - 1]
              else
                Result := '[Err: Index out of bounds: ' + IntToStr(APropertyIndex - 1) + ']';
            except
              Result := 'bug on getting name';
            end;
          finally
            ListOfProperties.Free;
          end;
        end
        else
          Result := CMainProperties[EditingActionType]^[APropertyIndex].Name;
      end;

      if CurrentlyEditingActionType in [acFindControl, acFindSubControl] then
      begin
        if APropertyIndex = CFindControl_MatchBitmapText_PropIndex then
          Result := Result + ' [0..' + IntToStr(Length(FEditingAction^.FindControlOptions.MatchBitmapText) - 1) + ']';

        case APropertyIndex of
          CFindControl_MatchText_PropIndex:
            if not EditingAction^.FindControlOptions.MatchCriteria.WillMatchText and
               not EditingAction^.FindControlOptions.MatchCriteria.WillMatchBitmapText then
              Result := Result + CNotUsedStr;

          CFindControl_MatchClassName_PropIndex:
            if not EditingAction^.FindControlOptions.MatchCriteria.WillMatchClassName then
              Result := Result + CNotUsedStr;

          CFindControl_MatchBitmapText_PropIndex:
            if not EditingAction^.FindControlOptions.MatchCriteria.WillMatchBitmapText then
              Result := Result + CNotUsedStr;

          CFindControl_MatchBitmapFiles_PropIndex:
            if not EditingAction^.FindControlOptions.MatchCriteria.WillMatchBitmapFiles then
              Result := Result + CNotUsedStr;

          CFindControl_MatchPrimitiveFiles_PropIndex:
            if not EditingAction^.FindControlOptions.MatchCriteria.WillMatchPrimitiveFiles then
              Result := Result + CNotUsedStr;
        end;
      end;
    end; //action specific

    else
      Result := '???';
  end;
end;


function TfrClickerActions.HandleOnOIGetPropertyValue(ACategoryIndex, APropertyIndex: Integer; var AEditorType: TOIEditorType): string;
var
  EditingActionType: Integer;
  PropDef: TOIPropDef;
  ListOfProperties: TStringList;
  PropDetails: string;
begin
  PropDef.EditorType := etNone;
  Result := '';

  case ACategoryIndex of
    CCategory_Common:
    begin
      PropDef := CCommonProperties[APropertyIndex];
      Result := GetActionValueStr_Action(FEditingAction, APropertyIndex);
    end;

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        PropDef.Name := '?'
      else
      begin
        if (CurrentlyEditingActionType = acPlugin) and (APropertyIndex > CPlugin_FileName_PropIndex) then
        begin
          ListOfProperties := TStringList.Create;
          try
            ListOfProperties.Text := FEditingAction.PluginOptions.ListOfPropertiesAndTypes;

            if (APropertyIndex - CPropCount_Plugin < ListOfProperties.Count) and (ListOfProperties.Count > 0) then
            begin
              PropDetails := ListOfProperties.ValueFromIndex[APropertyIndex - CPropCount_Plugin];
              PropDef.EditorType := StrToTOIEditorType('et' + Copy(PropDetails, 1, Pos(#8#7, PropDetails) - 1));
            end
            else
              PropDef.EditorType := etUserEditor; //index out of bounds
          finally
            ListOfProperties.Free;
          end;
        end
        else
          PropDef := CMainProperties[EditingActionType]^[APropertyIndex];

        Result := CMainGetActionValueStrFunctions[CurrentlyEditingActionType](FEditingAction, APropertyIndex);
      end; //CClkUnsetAction
    end;  //CCategory_ActionSpecific

    else
      PropDef.Name := '???';
  end;

  AEditorType := PropDef.EditorType;
end;


function TfrClickerActions.HandleOnOIGetListPropertyItemCount(ACategoryIndex, APropertyIndex: Integer): Integer;
var
  EditingActionType: Integer;
  TempStringList: TStringList;
begin
  Result := 0;
  if ACategoryIndex = CCategory_Common then
    Exit; //no subproperties here

  EditingActionType := Integer(CurrentlyEditingActionType);
  if EditingActionType = CClkUnsetAction then
    Exit;

  case EditingActionType of
    Ord(acFindControl), Ord(acFindSubControl):
    begin
      case APropertyIndex of
        CFindControl_MatchCriteria_PropIndex:
          Result := CPropCount_FindControlMatchCriteria;

        CFindControl_MatchBitmapText_PropIndex:
          Result := CPropCount_FindControlMatchBitmapText * Length(FEditingAction^.FindControlOptions.MatchBitmapText);  //frClickerFindControl.GetBMPTextFontProfilesCount;

        CFindControl_MatchBitmapFiles_PropIndex:
        begin
          TempStringList := TStringList.Create;
          try
            TempStringList.Text := FEditingAction^.FindControlOptions.MatchBitmapFiles;
            Result := TempStringList.Count;
          finally
            TempStringList.Free;
          end;
        end;

        CFindControl_MatchBitmapAlgorithmSettings_PropIndex:
          Result := CPropCount_FindControlMatchBitmapAlgorithmSettings;

        CFindControl_InitialRectangle_PropIndex:
          Result := CPropCount_FindControlInitialRectangle;

        CFindControl_MatchPrimitiveFiles_PropIndex:
        begin
          TempStringList := TStringList.Create;
          try
            TempStringList.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
            Result := TempStringList.Count;
          finally
            TempStringList.Free;
          end;
        end;

        CFindControl_MatchByHistogramSettings_PropIndex:
          Result := CPropCount_FindControlMatchByHistogramSettings;

        else
          Result := 0;
      end;
    end;

    Ord(acCallTemplate):
    begin
      case APropertyIndex of
        CCallTemplate_CallTemplateLoop_PropIndex:
          Result := CPropCount_CallTemplateLoop;

        else
          Result := 0;
      end;
    end;
  end;   //case EditingActionType
end;


function TfrClickerActions.HandleOnOIGetListPropertyItemName(ACategoryIndex, APropertyIndex, AItemIndex: Integer): string;
var
  EditingActionType: Integer;
  ItemIndexMod, ItemIndexDiv: Integer;
  ListOfPrimitiveFiles_Modified: TStringList;
begin
  Result := '';
  if ACategoryIndex = CCategory_Common then
    Exit;

  EditingActionType := Integer(CurrentlyEditingActionType);
  if EditingActionType = CClkUnsetAction then
    Exit;

  case EditingActionType of
    Ord(acFindControl), Ord(acFindSubControl):
    begin
      case APropertyIndex of
        CFindControl_MatchCriteria_PropIndex:
          Result := CFindControl_MatchCriteriaProperties[AItemIndex].Name;

        CFindControl_MatchBitmapText_PropIndex:
        begin
          ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
          ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;
          Result := '[' + IntToStr(ItemIndexDiv) + ']  ' + CFindControl_MatchBitmapTextProperties[ItemIndexMod].Name;
        end;

        CFindControl_MatchBitmapFiles_PropIndex:
          Result := 'File[' + IntToStr(AItemIndex) + ']';

        CFindControl_MatchBitmapAlgorithmSettings_PropIndex:
          Result := CFindControl_MatchBitmapAlgorithmSettingsProperties[AItemIndex].Name;

        CFindControl_InitialRectangle_PropIndex:
          Result := CFindControl_InitialRectangleProperties[AItemIndex].Name;

        CFindControl_MatchPrimitiveFiles_PropIndex:
        begin
          Result := 'File[' + IntToStr(AItemIndex) + ']';

          ListOfPrimitiveFiles_Modified := TStringList.Create;
          try
            ListOfPrimitiveFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;
            try
              if ListOfPrimitiveFiles_Modified.Strings[AItemIndex] = '1' then
                Result := Result + '  (* Modified)';
            except
              on E: Exception do
                Result := E.Message + '  ' + IntToStr(AItemIndex) + '   ' + IntToStr(ListOfPrimitiveFiles_Modified.Count - 1);
            end;
          finally
            ListOfPrimitiveFiles_Modified.Free;
          end;
        end;  //CFindControl_MatchPrimitiveFiles_PropIndex

        CFindControl_MatchByHistogramSettings_PropIndex:
          Result := CFindControl_MatchByHistogramSettingsProperties[AItemIndex].Name;

        else
          Result := '';
      end;
    end;

    Ord(acCallTemplate):
    begin
      case APropertyIndex of
        CCallTemplate_CallTemplateLoop_PropIndex:
          Result := CCallTemplate_CallTemplateLoopProperties[AItemIndex].Name;

        else
          Result := '';
      end;
    end;

  end;   //case EditingActionType
end;


function TfrClickerActions.HandleOnOIGetListPropertyItemValue(ACategoryIndex, APropertyIndex, AItemIndex: Integer; var AEditorType: TOIEditorType): string;
var
  EditingActionType: Integer;
  PropDef: TOIPropDef;
  TempStringList: TStringList;
begin
  Result := '';
  AEditorType := etNone;

  if ACategoryIndex = CCategory_Common then
    Exit;

  EditingActionType := Integer(CurrentlyEditingActionType);
  if EditingActionType = CClkUnsetAction then
    Exit;

  case EditingActionType of
    Ord(acFindControl), Ord(acFindSubControl):
    begin
      case APropertyIndex of
        CFindControl_MatchCriteria_PropIndex:
          PropDef := CFindControl_MatchCriteriaProperties[AItemIndex];

        CFindControl_MatchBitmapText_PropIndex:
          PropDef := CFindControl_MatchBitmapTextProperties[AItemIndex mod CPropCount_FindControlMatchBitmapText];

        CFindControl_MatchBitmapFiles_PropIndex:
        begin
          TempStringList := TStringList.Create;
          try
            TempStringList.Text := FEditingAction^.FindControlOptions.MatchBitmapFiles;
            try
              Result := TempStringList.Strings[AItemIndex];
            except
              on E: Exception do
                Result := E.Message + '  ' + IntToStr(AItemIndex) + '   ' + IntToStr(TempStringList.Count - 1);
            end;
          finally
            TempStringList.Free;
          end;

          AEditorType := etTextWithArrow;
          Exit;
        end;

        CFindControl_MatchBitmapAlgorithmSettings_PropIndex:
          PropDef := CFindControl_MatchBitmapAlgorithmSettingsProperties[AItemIndex];

        CFindControl_InitialRectangle_PropIndex:
          PropDef := CFindControl_InitialRectangleProperties[AItemIndex];

        CFindControl_MatchPrimitiveFiles_PropIndex:
        begin
          TempStringList := TStringList.Create;
          try
            TempStringList.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
            try
              if AItemIndex < TempStringList.Count then
                Result := TempStringList.Strings[AItemIndex]
              else
                Result := 'The ObjectInspector might be out of sync.';
            except
              on E: Exception do
                Result := E.Message + '  ' + IntToStr(AItemIndex) + '   ' + IntToStr(TempStringList.Count - 1) + '    The ObjectInspector might be out of sync.';
            end;
          finally
            TempStringList.Free;
          end;

          AEditorType := etTextWithArrow;
          Exit;
        end;

        CFindControl_MatchByHistogramSettings_PropIndex:
          PropDef := CFindControl_MatchByHistogramSettingsProperties[AItemIndex];

        else
          ;
      end;

      Result := CFindControlGetActionValueStrFunctions[APropertyIndex](FEditingAction, AItemIndex);
    end;

    Ord(acCallTemplate):
    begin
      case APropertyIndex of
        CCallTemplate_CallTemplateLoop_PropIndex:
          PropDef := CCallTemplate_CallTemplateLoopProperties[AItemIndex];

        else
          ;
      end;

      Result := CCallTemplateGetActionValueStrFunctions[APropertyIndex](FEditingAction, AItemIndex);
    end;
  end;   //case EditingActionType

  AEditorType := PropDef.EditorType;
end;


function GetPluginPropertyAttribute(AListOfPropertiesAndTypes, AAttrName: string; APropertyIndex: Integer): string;
begin
  Result := GetPluginAdditionalPropertyAttribute(AListOfPropertiesAndTypes, AAttrName, APropertyIndex - CPropCount_Plugin);
end;


function TfrClickerActions.HandleOnUIGetDataTypeName(ACategoryIndex, APropertyIndex, AItemIndex: Integer): string;
var
  EditingActionType: Integer;
begin
  Result := '';

  case ACategoryIndex of
    CCategory_Common:
      Result := CCommonProperties[APropertyIndex].DataType;

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        Result := '?'
      else
      begin
        if AItemIndex = -1 then
        begin
          if (CurrentlyEditingActionType = acPlugin) and (APropertyIndex > CPlugin_FileName_PropIndex) then
            Result := GetPluginPropertyAttribute(FEditingAction.PluginOptions.ListOfPropertiesAndTypes, CPluginPropertyAttr_DataType, APropertyIndex)
          else
            Result := CMainProperties[EditingActionType]^[APropertyIndex].DataType
        end
        else
        begin
          case EditingActionType of
            Ord(acFindControl), Ord(acFindSubControl):
            begin
              case APropertyIndex of
                CFindControl_MatchCriteria_PropIndex:
                  Result := CFindControl_MatchCriteriaProperties[AItemIndex].DataType;

                CFindControl_MatchBitmapText_PropIndex:
                  Result := CFindControl_MatchBitmapTextProperties[AItemIndex mod CPropCount_FindControlMatchBitmapText].DataType;

                CFindControl_MatchBitmapAlgorithmSettings_PropIndex:
                  Result := CFindControl_MatchBitmapAlgorithmSettingsProperties[AItemIndex].DataType;

                CFindControl_InitialRectangle_PropIndex:
                  Result := CFindControl_InitialRectangleProperties[AItemIndex].DataType;

                CFindControl_MatchByHistogramSettings_PropIndex:
                  Result := CFindControl_MatchByHistogramSettingsProperties[AItemIndex].DataType;
              end;
            end;

            Ord(acCallTemplate):
              if APropertyIndex = CCallTemplate_CallTemplateLoop_PropIndex then
                Result := CCallTemplate_CallTemplateLoopProperties[AItemIndex].DataType;
          end;
        end; //else
      end;
    end;

    else
      Result := '???';
  end;
end;


function TfrClickerActions.HandleOnUIGetExtraInfo(ACategoryIndex, APropertyIndex, AItemIndex: Integer): string;
begin
  Result := 'extra';
end;


procedure TfrClickerActions.HandleOnOIGetImageIndexEx(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer; var ImageList: TCustomImageList);
var
  EditingActionType: Integer;
  ItemIndexMod, ItemIndexDiv: Integer;
begin
  EditingActionType := Integer(CurrentlyEditingActionType);

  case ACategoryIndex of
    CCategory_Common:
      if Column = 0 then
      begin
        ImageList := imglstActionProperties;
        ImageIndex := APropertyIndex;
      end;

    CCategory_ActionSpecific:
    begin
      if EditingActionType = CClkUnsetAction then
        Exit;

      if Column = 0 then
      begin
        case ANodeLevel of
          CCategoryLevel:
          begin
            ImageList := imglstActions16;
            ImageIndex := EditingActionType;
          end;

          CPropertyLevel:
          begin
            ImageIndex := APropertyIndex;

            case EditingActionType of
              Ord(acClick):
                ImageList := imglstClickProperties;

              Ord(acExecApp):
                ImageList := imglstExecAppProperties;

              Ord(acFindControl), Ord(acFindSubControl):
                ImageList := imglstFindControlProperties;

              Ord(acSetControlText):
                ImageList := imglstSetTextProperties;

              Ord(acCallTemplate):
                ImageList := imglstCallTemplateProperties;

              Ord(acSleep):
                ImageList := imglstSleepProperties;

              Ord(acSetVar):
                ImageList := imglstSetVarProperties;

              Ord(acWindowOperations):
                ImageList := imglstWindowOperationsProperties;

              Ord(acLoadSetVarFromFile):
                ImageList := imglstLoadSetVarFromFileProperties;

              Ord(acSaveSetVarToFile):
                ImageList := imglstSaveSetVarToFileProperties;

              Ord(acPlugin):
              begin
                ImageList := imglstPluginProperties;
                //if APropertyIndex > CPlugin_FileName_PropIndex then
                //  ImageIndex := 1;
              end;
            end;   //case
          end;

          CPropertyItemLevel:
          begin
            ImageIndex := AItemIndex;

            case EditingActionType of
              Ord(acFindControl), Ord(acFindSubControl):
              begin
                case APropertyIndex of
                  CFindControl_MatchCriteria_PropIndex:
                    ImageList := imglstMatchCriteriaProperties;

                  CFindControl_MatchBitmapText_PropIndex:
                  begin
                    ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
                    ImageIndex := ItemIndexMod;
                    ImageList := imglstMatchBitmapTextProperties;
                  end;

                  CFindControl_MatchBitmapAlgorithmSettings_PropIndex:
                    ImageList := imglstMatchBitmapAlgorithmSettingsProperties;

                  CFindControl_InitialRectangle_PropIndex:
                    ImageList := imglstInitialRectangleProperties;

                  CFindControl_MatchByHistogramSettings_PropIndex:
                    ImageList := imglstMatchByHistogramSettings;
                end;
              end;

              Ord(acCallTemplate):
                ImageList := imglstCallTemplateLoopProperties;
            end;
          end;
        end; //case
      end; // Column = 0

      if Column = 1 then
        if ANodeLevel = CPropertyItemLevel then
          if EditingActionType in [Ord(acFindControl), Ord(acFindSubControl)] then
            if APropertyIndex = CFindControl_MatchBitmapText_PropIndex then
            begin
              ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
              ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;

              if ItemIndexMod in [CFindControl_MatchBitmapText_ForegroundColor_PropItemIndex, CFindControl_MatchBitmapText_BackgroundColor_PropItemIndex] then
              begin
                ImageList := imglstFontColorProperties;
                ImageIndex := ItemIndexDiv shl 1 + ItemIndexMod;

                if ImageIndex > imglstFontColorProperties.Count - 1 then
                  BuildFontColorIconsList;
              end;
            end;
    end;
  end;
end;


procedure TfrClickerActions.HandleOnOIEditedText(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; ANewText: string);
var
  EditingActionType: Integer;
  TempStringList, ListOfFiles_Modified: TStringList;
  ItemIndexMod, ItemIndexDiv: Integer;
  FoundProfileIndex, i, ImageIndex: Integer;
  OldText: string;
begin
  case ACategoryIndex of
    CCategory_Common:
    begin
      OldText := GetActionValueStr_Action(FEditingAction, APropertyIndex);
      SetActionValueStr_Action(FEditingAction, ANewText, APropertyIndex);
      FCurrentlyEditingActionType := Ord(FEditingAction^.ActionOptions.Action);

      CurrentlyEditingActionType := FEditingAction^.ActionOptions.Action;

      TriggerOnControlsModified(ANewText <> OldText);
      tmrReloadOIContent.Enabled := True;
    end;

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        Exit;

      case EditingActionType of
        Ord(acFindControl), Ord(acFindSubControl):
        begin
          case APropertyIndex of
            CFindControl_MatchCriteria_PropIndex:
            begin
              OldText := GetActionValueStr_FindControl_MatchCriteria(FEditingAction, AItemIndex);
              SetActionValueStr_FindControl_MatchCriteria(FEditingAction, ANewText, AItemIndex);
              TriggerOnControlsModified(ANewText <> OldText);
              Exit;
            end;

            CFindControl_MatchText_PropIndex:
              frClickerFindControl.UpdateOnTextPropeties;

            CFindControl_MatchBitmapText_PropIndex:
            begin
              OldText := GetActionValueStr_FindControl_MatchBitmapText(FEditingAction, AItemIndex {no mod here});

              if ANodeLevel = CPropertyItemLevel then
              begin
                ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
                ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;

                case ItemIndexMod of
                  CFindControl_MatchBitmapText_ForegroundColor_PropItemIndex, CFindControl_MatchBitmapText_BackgroundColor_PropItemIndex:
                  begin
                    imgFontColorBuffer.Canvas.Pen.Color := 1;
                    imgFontColorBuffer.Canvas.Brush.Color := HexToInt(EvaluateReplacements(ANewText));
                    imgFontColorBuffer.Canvas.Rectangle(0, 0, imgFontColorBuffer.Width, imgFontColorBuffer.Height);

                    ImageIndex := ItemIndexDiv shl 1 + ItemIndexMod;    //shl 1 means that there are two items / pair  (FG and BG)
                    if ImageIndex > imglstFontColorProperties.Count - 1 then
                      BuildFontColorIconsList;

                    imglstFontColorProperties.ReplaceMasked(ImageIndex, imgFontColorBuffer.Picture.Bitmap, 2);
                  end;

                  CFindControl_MatchBitmapText_CropLeft:
                  begin
                    if StrToIntDef(ANewText, 0) < 0 then
                      ANewText := '0';

                    FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropLeft := ANewText;
                    frClickerFindControl.BMPTextFontProfiles[ItemIndexDiv].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv]);
                  end;

                  CFindControl_MatchBitmapText_CropTop:
                  begin
                    if StrToIntDef(ANewText, 0) < 0 then
                      ANewText := '0';

                    FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropTop := ANewText;
                    frClickerFindControl.BMPTextFontProfiles[ItemIndexDiv].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv]);
                  end;

                  CFindControl_MatchBitmapText_CropRight:
                  begin
                    if StrToIntDef(ANewText, 0) < 0 then
                      ANewText := '0';

                    FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropRight := ANewText;
                    frClickerFindControl.BMPTextFontProfiles[ItemIndexDiv].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv]);
                  end;

                  CFindControl_MatchBitmapText_CropBottom:
                  begin
                    if StrToIntDef(ANewText, 0) < 0 then
                      ANewText := '0';

                    FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropBottom := ANewText;
                    frClickerFindControl.BMPTextFontProfiles[ItemIndexDiv].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv]);
                  end;

                  CFindControl_MatchBitmapText_ProfileName_PropItemIndex:
                  begin
                    FoundProfileIndex := frClickerFindControl.GetFontProfileIndexByName(ANewText);
                    if (FoundProfileIndex > -1) and (FoundProfileIndex <> ItemIndexDiv) then
                      raise Exception.Create('Font profile name already exists. Please use a different one.');
                  end;
                end; //case  ItemIndexMod
              end;

              SetActionValueStr_FindControl_MatchBitmapText(FEditingAction, ANewText, AItemIndex {no mod here});
              frClickerFindControl.PreviewText;

              for i := 0 to Length(FEditingAction^.FindControlOptions.MatchBitmapText) - 1 do
                frClickerFindControl.BMPTextFontProfiles[i].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[i]);

              TriggerOnControlsModified(ANewText <> OldText);
              frClickerFindControl.UpdateOnTextPropeties;
              Exit;
            end;  //CFindControl_MatchBitmapText_PropIndex

            CFindControl_MatchBitmapFiles_PropIndex:
            begin
              TempStringList := TStringList.Create;
              try
                case ANodeLevel of
                  CPropertyLevel:
                  begin
                    OldText := FEditingAction^.FindControlOptions.MatchBitmapFiles;
                    FEditingAction^.FindControlOptions.MatchBitmapFiles := ANewText;
                    FOIFrame.ReloadPropertyItems(ACategoryIndex, APropertyIndex);

                    TriggerOnControlsModified(ANewText <> OldText);
                    frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
                  end;

                  CPropertyItemLevel:
                  begin
                    TempStringList.Text := FEditingAction^.FindControlOptions.MatchBitmapFiles;    //read
                    OldText := TempStringList.Strings[AItemIndex];
                    TempStringList.Strings[AItemIndex] := ANewText;                                //modify
                    FEditingAction^.FindControlOptions.MatchBitmapFiles := TempStringList.Text;    //write

                    TriggerOnControlsModified(ANewText <> OldText);
                    frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
                  end;
                end;
              finally
                TempStringList.Free;
              end;

              Exit;
            end;

            CFindControl_MatchBitmapAlgorithmSettings_PropIndex:
            begin
              OldText := GetActionValueStr_FindControl_MatchBitmapAlgorithmSettings(FEditingAction, AItemIndex);
              SetActionValueStr_FindControl_MatchBitmapAlgorithmSettings(FEditingAction, ANewText, AItemIndex);
              TriggerOnControlsModified(ANewText <> OldText);
              Exit;
            end;

            CFindControl_InitialRectangle_PropIndex:
            begin
              OldText := GetActionValueStr_FindControl_InitialRectangle(FEditingAction, AItemIndex);
              SetActionValueStr_FindControl_InitialRectangle(FEditingAction, ANewText, AItemIndex);
              TriggerOnControlsModified(ANewText <> OldText);
              Exit;
            end;

            CFindControl_UseWholeScreen_PropIndex:   //this call will have to take into account, the screen edges or vars as search area limits
            begin
              frClickerFindControl.UpdateSearchAreaLabelsFromKeysOnInitRect(FEditingAction^.FindControlOptions.InitialRectangle);
              frClickerFindControl.UpdateUseWholeScreenLabel(StrToBool(ANewText));
            end;

            CFindControl_MatchPrimitiveFiles_PropIndex:
            begin
              TempStringList := TStringList.Create;
              try
                case ANodeLevel of
                  CPropertyLevel:
                  begin
                    OldText := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
                    FEditingAction^.FindControlOptions.MatchPrimitiveFiles := ANewText;

                    FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := '';
                    ListOfFiles_Modified := TStringList.Create;
                    try
                      ListOfFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
                      for i := 0 to ListOfFiles_Modified.Count - 1 do
                        FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified + '0'#13#10;
                    finally
                      ListOfFiles_Modified.Free;
                    end;

                    FOIFrame.ReloadPropertyItems(ACategoryIndex, APropertyIndex);

                    TriggerOnControlsModified(ANewText <> OldText);
                    frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
                  end;

                  CPropertyItemLevel:
                  begin
                    TempStringList.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;    //read
                    OldText := TempStringList.Strings[AItemIndex];
                    TempStringList.Strings[AItemIndex] := ANewText;                                   //modify
                    FEditingAction^.FindControlOptions.MatchPrimitiveFiles := TempStringList.Text;    //write

                    TriggerOnControlsModified(ANewText <> OldText);
                    frClickerFindControl.UpdateListsOfSearchFiles(EditingAction^.FindControlOptions.MatchBitmapFiles, EditingAction^.FindControlOptions.MatchPrimitiveFiles);
                  end;
                end;
              finally
                TempStringList.Free;
              end;

              Exit;
            end;

            CFindControl_MatchByHistogramSettings_PropIndex:
            begin
              OldText := GetActionValueStr_FindControl_MatchByHistogramSettings(FEditingAction, AItemIndex);
              SetActionValueStr_FindControl_MatchByHistogramSettings(FEditingAction, ANewText, AItemIndex);
              TriggerOnControlsModified(ANewText <> OldText);
              Exit;
            end;

            else
              ;
          end;
        end; //FindControl  case

        Ord(acCallTemplate):
        begin
          case APropertyIndex of
            CCallTemplate_CallTemplateLoop_PropIndex:
            begin
              OldText := GetActionValueStr_CallTemplate_CallTemplateLoop(FEditingAction, AItemIndex);
              SetActionValueStr_CallTemplate_CallTemplateLoop(FEditingAction, ANewText, AItemIndex);
              TriggerOnControlsModified(ANewText <> OldText);
              Exit;
            end;

            else
              ;
          end;
        end; //CallTemplate  case
      end;   //case EditingActionType

      //default handler for main properties
      OldText := CMainGetActionValueStrFunctions[CurrentlyEditingActionType](FEditingAction, APropertyIndex);
      CMainSetActionValueStrFunctions[CurrentlyEditingActionType](FEditingAction, ANewText, APropertyIndex);
      TriggerOnControlsModified(ANewText <> OldText);

      if FEditingAction^.ActionOptions.Action = acPlugin then
        if APropertyIndex = CPlugin_FileName_PropIndex then
        begin
          DoOnModifyPluginProperty(FEditingAction);
          tmrReloadOIContent.Enabled := True;
        end;
    end; //Action specific

    else
      ;
  end;
end;


function TfrClickerActions.EditFontProperties(AItemIndexDiv: Integer; var ANewItems: string): Boolean;
var
  TempFontDialog: TFontDialog;
begin
  Result := False;

  TempFontDialog := TFontDialog.Create(nil);
  try
    TempFontDialog.Font.Name := ANewItems;
    TempFontDialog.Font.Size := FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].FontSize;

    if FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].Bold then
      TempFontDialog.Font.Style := TempFontDialog.Font.Style + [fsBold];

    if FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].Italic then
      TempFontDialog.Font.Style := TempFontDialog.Font.Style + [fsItalic];

    if FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].Underline then
      TempFontDialog.Font.Style := TempFontDialog.Font.Style + [fsUnderline];

    if FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].StrikeOut then
      TempFontDialog.Font.Style := TempFontDialog.Font.Style + [fsStrikeOut];

    if not TempFontDialog.Execute then
      Exit;

    ANewItems := TempFontDialog.Font.Name;
    Result := True;

    FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].FontName := ANewItems; //redundant, because the OI will call another handler for the property itself
    FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].FontSize := TempFontDialog.Font.Size;
    FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].Bold := fsBold in TempFontDialog.Font.Style;
    FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].Italic := fsItalic in TempFontDialog.Font.Style;
    FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].Underline := fsUnderline in TempFontDialog.Font.Style;
    FEditingAction^.FindControlOptions.MatchBitmapText[AItemIndexDiv].StrikeOut := fsStrikeOut in TempFontDialog.Font.Style;
  finally
    TempFontDialog.Free;
  end;
end;


function TfrClickerActions.HandleOnOIEditItems(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; var ANewItems: string): Boolean;
var
  EditingActionType: Integer;
  ItemIndexDiv, ItemIndexMod: Integer;
begin
  Result := False;
  if ACategoryIndex = CCategory_ActionSpecific then
  begin
    EditingActionType := Integer(CurrentlyEditingActionType);
    if EditingActionType = CClkUnsetAction then
      Exit;

    if EditingActionType in [Ord(acFindControl), Ord(acFindSubControl)] then
      if APropertyIndex = CFindControl_MatchBitmapText_PropIndex then
      begin
        ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;
        ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;

        if ItemIndexMod = CFindControl_MatchBitmapText_FontName_PropItemIndex then
        begin
          Result := EditFontProperties(ItemIndexDiv, ANewItems);

          if Result then
            TriggerOnControlsModified;
        end;
      end;
  end;
end;


function TfrClickerActions.HandleOnOIGetColorConstsCount(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer): Integer;
begin
  Result := 0;  //additional user colors
end;


procedure TfrClickerActions.HandleOnOIGetColorConst(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex, AColorItemIndex: Integer; var AColorName: string; var AColorValue: Int64);
begin
  //additional user colors
end;


function TfrClickerActions.HandleOnOIGetEnumConstsCount(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer): Integer;
var
  EditingActionType: Integer;
  ItemIndexMod: Integer;
begin
  Result := 0;

  case ACategoryIndex of
    CCategory_Common:
      Result := CActionEnumCounts[APropertyIndex];

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        Exit;

      if CurrentlyEditingActionType in [acFindControl, acFindSubControl] then
      begin
        if APropertyIndex = CFindControl_MatchCriteria_PropIndex then
        begin
          Result := CFindControl_MatchCriteriaEnumCounts[AItemIndex];
          Exit;
        end;

        if APropertyIndex = CFindControl_MatchBitmapText_PropIndex then
        begin
          ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
          Result := CFindControl_MatchBitmapTextEnumCounts[ItemIndexMod];

          if ItemIndexMod = CFindControl_MatchBitmapText_FontName_PropItemIndex then
            Result := Screen.Fonts.Count;

          Exit;
        end;
      end;

      if CurrentlyEditingActionType = acCallTemplate then
        if APropertyIndex = CCallTemplate_CallTemplateLoop_PropIndex then
        begin
          Result := CCallTemplate_CallTemplateLoopEnumCounts[AItemIndex];
          Exit;
        end;

      if (CurrentlyEditingActionType = acPlugin) and (APropertyIndex > CPlugin_FileName_PropIndex) then
      begin
        //Result := 0
        Result := StrToIntDef(GetPluginPropertyAttribute(FEditingAction.PluginOptions.ListOfPropertiesAndTypes, CPluginPropertyAttr_EnumCounts, APropertyIndex), 0);
      end
      else
        Result := CPropEnumCounts[CurrentlyEditingActionType]^[APropertyIndex];
    end;

    else
      Result := 0;
  end;
end;


procedure TfrClickerActions.HandleOnOIGetEnumConst(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex, AEnumItemIndex: Integer; var AEnumItemName: string);
var
  EditingActionType: Integer;
  ItemIndexMod: Integer;
  ListOfEnumValues: TStringList;
begin
  AEnumItemName := '';

  case ACategoryIndex of
    CCategory_Common:
      AEnumItemName := CActionEnumStrings[APropertyIndex]^[AEnumItemIndex];

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        Exit;

      if CurrentlyEditingActionType in [acFindControl, acFindSubControl] then
      begin
        if APropertyIndex = CFindControl_MatchCriteria_PropIndex then
        begin
          AEnumItemName := CFindControl_MatchCriteriaEnumStrings[AItemIndex]^[AEnumItemIndex];
          Exit;
        end;

        if APropertyIndex = CFindControl_MatchBitmapText_PropIndex then
        begin
          ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;

          if ItemIndexMod = CFindControl_MatchBitmapText_FontName_PropItemIndex then
            AEnumItemName := Screen.Fonts.Strings[AEnumItemIndex]
          else
            AEnumItemName := CFindControl_MatchBitmapTextEnumStrings[ItemIndexMod]^[AEnumItemIndex];

          Exit;
        end;
      end;

      if CurrentlyEditingActionType = acCallTemplate then
        if APropertyIndex = CCallTemplate_CallTemplateLoop_PropIndex then
        begin
          AEnumItemName := CCallTemplate_CallTemplateLoopEnumStrings[AItemIndex]^[AEnumItemIndex];
          Exit;
        end;

      if (CurrentlyEditingActionType = acPlugin) and (APropertyIndex > CPlugin_FileName_PropIndex) then
      begin
        AEnumItemName := GetPluginPropertyAttribute(FEditingAction.PluginOptions.ListOfPropertiesAndTypes, CPluginPropertyAttr_EnumStrings, APropertyIndex);
        ListOfEnumValues := TStringList.Create;
        try
          ListOfEnumValues.Text := FastReplace_45ToReturn(AEnumItemName);
          try
            AEnumItemName := ListOfEnumValues.Strings[AEnumItemIndex];
          except
            AEnumItemName := 'item out of bounds'
          end;
        finally
          ListOfEnumValues.Free;
        end;
      end
      else
        AEnumItemName := CPropEnumStrings[CurrentlyEditingActionType]^[APropertyIndex]^[AEnumItemIndex];
    end;

    else
      AEnumItemName := '';
  end;
end;


function PropertyValueReplace(s, AListOfPropertiesAndValues: string): string; //replaces all 'PropertyValue[<index>]' with the actual value
var
  TempListOfPropertiesAndValues: TStringList;
  i: Integer;
begin
  Result := s;

  TempListOfPropertiesAndValues := TStringList.Create;
  try
    TempListOfPropertiesAndValues.Text := AListOfPropertiesAndValues;

    for i := 0 to TempListOfPropertiesAndValues.Count - 1 do
      Result := StringReplace(Result, 'PropertyValue[' + IntToStr(i) + ']', TempListOfPropertiesAndValues.ValueFromIndex[i], [rfReplaceAll]);
  finally
    TempListOfPropertiesAndValues.Free;
  end;
end;


procedure TfrClickerActions.HandleOnOIPaintText(ANodeData: TNodeDataPropertyRec; ACategoryIndex, APropertyIndex, APropertyItemIndex: Integer;
  const TargetCanvas: TCanvas; Column: TColumnIndex; var TextType: TVSTTextType);
var
  ListOfPrimitiveFiles_Modified: TStringList;
  ClickTypeIsNotDrag: Boolean;
  PluginPropertyEnabled: string;
begin
  if ANodeData.Level = 0 then
  begin
    TargetCanvas.Font.Style := [fsBold];
    Exit;
  end;

  if (ACategoryIndex = CCategory_ActionSpecific) and (Column = 1) then
  begin
    if (ANodeData.Level = CPropertyLevel) and (CurrentlyEditingActionType = acClick) then
    begin
      ClickTypeIsNotDrag := FEditingAction^.ClickOptions.ClickType <> CClickType_Drag;

      if ((APropertyIndex = CClick_XClickPointVar_PropIndex) and (FEditingAction^.ClickOptions.XClickPointReference <> xrefVar)) or
         ((APropertyIndex = CClick_YClickPointVar_PropIndex) and (FEditingAction^.ClickOptions.YClickPointReference <> yrefVar)) or
         ((APropertyIndex = CClick_XClickPointReferenceDest_PropIndex) and ClickTypeIsNotDrag) or
         ((APropertyIndex = CClick_YClickPointReferenceDest_PropIndex) and ClickTypeIsNotDrag) or
         ((APropertyIndex = CClick_XClickPointVarDest_PropIndex) and ((FEditingAction^.ClickOptions.XClickPointReferenceDest <> xrefVar) or ClickTypeIsNotDrag)) or
         ((APropertyIndex = CClick_YClickPointVarDest_PropIndex) and ((FEditingAction^.ClickOptions.YClickPointReferenceDest <> yrefVar) or ClickTypeIsNotDrag)) or
         ((APropertyIndex = CClick_XOffsetDest_PropIndex) and ClickTypeIsNotDrag) or
         ((APropertyIndex = CClick_YOffsetDest_PropIndex) and ClickTypeIsNotDrag) or
         ((APropertyIndex = CClick_MouseWheelType_PropIndex) and (FEditingAction^.ClickOptions.ClickType <> CClickType_Wheel)) or
         ((APropertyIndex = CClick_MouseWheelAmount_PropIndex) and (FEditingAction^.ClickOptions.ClickType <> CClickType_Wheel)) or
         ((APropertyIndex = CClick_LeaveMouse_PropIndex) and (FEditingAction^.ClickOptions.ClickType in [CClickType_Drag, CClickType_Wheel])) or
         ((APropertyIndex in [CClick_DelayAfterMovingToDestination_PropIndex .. CClick_MoveDuration_PropIndex]) and (FEditingAction^.ClickOptions.ClickType in [CClickType_ButtonDown, CClickType_ButtonUp, CClickType_Wheel])) then
      begin
        TargetCanvas.Font.Color := clGray;
        Exit;
      end;
    end;  //acClick

    if (ANodeData.Level = CPropertyLevel) and (CurrentlyEditingActionType in [acFindControl, acFindSubControl]) then
    begin
      if (APropertyIndex in [CFindControl_MatchBitmapFiles_PropIndex, CFindControl_MatchPrimitiveFiles_PropIndex]) then
      begin
        TargetCanvas.Font.Style := [fsItalic];
        //Exit;
      end;

      if ((APropertyIndex in [CFindControl_MatchBitmapText_PropIndex .. CFindControl_MatchBitmapAlgorithmSettings_PropIndex,
                              CFindControl_ColorError_PropIndex .. CFindControl_AllowedColorErrorCount_PropIndex,
                              CFindControl_MatchPrimitiveFiles_PropIndex,
                              CFindControl_UseFastSearch_PropIndex .. CFindControl_MatchByHistogramSettings_PropIndex])
                              and (CurrentlyEditingActionType = acFindControl)) then
      begin
        TargetCanvas.Font.Color := clGray;
        Exit;
      end;

      if ((APropertyIndex in [CFindControl_SourceFileName_PropIndex, CFindControl_ImageSourceFileNameLocation_PropIndex])
         and (FEditingAction^.FindControlOptions.ImageSource = isScreenshot)
         and (CurrentlyEditingActionType = acFindSubControl)) then
      begin
        TargetCanvas.Font.Color := clGray;
        Exit;
      end;
    end;


    if (ANodeData.Level = CPropertyLevel) and (CurrentlyEditingActionType = acWindowOperations) then
      if APropertyIndex in [CWindowOperations_NewX_PropItemIndex .. CWindowOperations_NewSizeEnabled_PropItemIndex] then
        if (FEditingAction^.WindowOperationsOptions.Operation <> woMoveResize) or
          (not FEditingAction^.WindowOperationsOptions.NewPositionEnabled) and (APropertyIndex in [CWindowOperations_NewX_PropItemIndex, CWindowOperations_NewY_PropItemIndex]) or
          (not FEditingAction^.WindowOperationsOptions.NewSizeEnabled) and (APropertyIndex in [CWindowOperations_NewWidth_PropItemIndex, CWindowOperations_NewHeight_PropItemIndex]) then
        begin
          TargetCanvas.Font.Color := clGray;
          Exit;
        end;

    if (ANodeData.Level = CPropertyItemLevel) and (CurrentlyEditingActionType in [acFindControl, acFindSubControl]) then
    begin
      if APropertyIndex = CFindControl_MatchCriteria_PropIndex then
        if (CurrentlyEditingActionType = acFindControl) and (APropertyItemIndex in [CFindControl_MatchCriteria_WillMatchBitmapText_PropItemIndex, CFindControl_MatchCriteria_WillMatchBitmapFiles_PropItemIndex, CFindControl_MatchCriteria_WillMatchPrimitiveFiles_PropItemIndex]) or
           (CurrentlyEditingActionType = acFindSubControl) and (APropertyItemIndex in [CFindControl_MatchCriteria_WillMatchText_PropItemIndex, CFindControl_MatchCriteria_WillMatchClassName_PropItemIndex]) then
        begin
          TargetCanvas.Font.Color := clGray;
          Exit;;
        end;

      if APropertyIndex = CFindControl_MatchPrimitiveFiles_PropIndex then
      begin
        ListOfPrimitiveFiles_Modified := TStringList.Create;   //instead of parsing this list on every tree paint action, the "modified" flags could be stored in some array of (paths + modified)
        try
          ListOfPrimitiveFiles_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;

          try
            if APropertyItemIndex < ListOfPrimitiveFiles_Modified.Count then
            begin
              if ListOfPrimitiveFiles_Modified.Strings[APropertyItemIndex] = '1' then
                TargetCanvas.Font.Color := clRed;
            end
            else
            begin
              TargetCanvas.Font.Color := clWhite;
              TargetCanvas.Brush.Color := clRed;
            end;
          except
            TargetCanvas.Font.Color := clWhite;
            TargetCanvas.Brush.Color := clRed;
          end;

          //Exit;
        finally
          ListOfPrimitiveFiles_Modified.Free;
        end;
      end; //primitives

      if CurrentlyEditingActionType = acFindControl then
        if APropertyIndex in [CFindControl_MatchBitmapText_PropIndex .. CFindControl_MatchBitmapAlgorithmSettings_PropIndex,
                              CFindControl_MatchPrimitiveFiles_PropIndex, CFindControl_MatchByHistogramSettings_PropIndex] then     //not that many subproperties
        begin
          TargetCanvas.Font.Color := clGray;
          Exit;
        end;

      if (APropertyIndex in [CFindControl_MatchBitmapAlgorithmSettings_PropIndex]) and
         (FEditingAction^.FindControlOptions.MatchBitmapAlgorithm <> mbaXYMultipleAndOffsets) then
      begin
        TargetCanvas.Font.Color := clGray;
        Exit;
      end;

      if CurrentlyEditingActionType = acFindSubControl then
        if (APropertyIndex in [CFindControl_MatchByHistogramSettings_PropIndex]) and
           (FEditingAction^.FindControlOptions.MatchBitmapAlgorithm <> mbaRawHistogramZones) then
        begin
          TargetCanvas.Font.Color := clGray;
          Exit;
        end;
    end; //acFindControl, acFindSubControl

    if (ANodeData.Level = CPropertyLevel) and (CurrentlyEditingActionType = acPlugin) then
    begin
      PluginPropertyEnabled := GetPluginPropertyAttribute(FEditingAction.PluginOptions.ListOfPropertiesAndTypes, CPluginPropertyAttr_Enabled, APropertyIndex);
      if PluginPropertyEnabled <> '' then
      begin
        try
          PluginPropertyEnabled := PropertyValueReplace(PluginPropertyEnabled, FEditingAction.PluginOptions.ListOfPropertiesAndValues);
        except
          on E: Exception do
            DoOnAddToLog('Cannot evaluate plugin property value: ' + E.Message);
        end;
        if not ClickerUtils.EvaluateActionCondition(PluginPropertyEnabled, DummyEvaluateReplacements) then
        begin
          TargetCanvas.Font.Color := clGray;
          Exit;
        end;
      end;
    end;
  end;  //CCategory_ActionSpecific
end;


procedure TfrClickerActions.HandleOnOIBeforeCellPaint(ANodeData: TNodeDataPropertyRec; ACategoryIndex, APropertyIndex, APropertyItemIndex: Integer;
  TargetCanvas: TCanvas; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  ItemIndexDiv: Integer;
  NewColor: TColor;
begin
  if CurrentlyEditingActionType in [acFindControl, acFindSubControl] then
    if (ACategoryIndex = CCategory_ActionSpecific) and (APropertyIndex = CFindControl_MatchBitmapText_PropIndex) then
    begin
      ItemIndexDiv := APropertyItemIndex div CPropCount_FindControlMatchBitmapText;

      if ItemIndexDiv and 1 = 0 then
        NewColor := $E0FFE0   //light green
      else
        NewColor := $97E0FF;   //light orange

      if ItemIndexDiv = frClickerFindControl.SelectedBMPTextTab then
        NewColor := ModifyBrightness(NewColor, 30, boDec);

      TargetCanvas.Pen.Color := NewColor;
      TargetCanvas.Brush.Color := NewColor;
      TargetCanvas.Rectangle(CellRect);
    end;
end;


procedure TfrClickerActions.HandleOnOIAfterCellPaint(ANodeData: TNodeDataPropertyRec; ACategoryIndex, APropertyIndex, APropertyItemIndex: Integer;
  TargetCanvas: TCanvas; Column: TColumnIndex; const CellRect: TRect);
const
  CIconYOffset = 3;
var
  CurrentIconPos: Integer;
begin
  if CurrentlyEditingActionType in [acFindControl, acFindSubControl] then
    if (ACategoryIndex = CCategory_ActionSpecific) and (APropertyIndex = CFindControl_MatchCriteria_PropIndex) and (APropertyItemIndex = -1) then
      if Column = 1 then
      begin
        CurrentIconPos := CellRect.Left + 2;

        if FEditingAction^.FindControlOptions.MatchCriteria.WillMatchText then
        begin
          imglstUsedMatchCriteria.Draw(TargetCanvas, CurrentIconPos, CIconYOffset, CFindControl_MatchCriteria_WillMatchText_PropItemIndex, dsNormal, itImage);
          Inc(CurrentIconPos, 18);
        end;

        if FEditingAction^.FindControlOptions.MatchCriteria.WillMatchClassName then
        begin
          imglstUsedMatchCriteria.Draw(TargetCanvas, CurrentIconPos, CIconYOffset, CFindControl_MatchCriteria_WillMatchClassName_PropItemIndex, dsNormal, itImage);
          Inc(CurrentIconPos, 18);
        end;

        if FEditingAction^.FindControlOptions.MatchCriteria.WillMatchBitmapText then
        begin
          imglstUsedMatchCriteria.Draw(TargetCanvas, CurrentIconPos, CIconYOffset, CFindControl_MatchCriteria_WillMatchBitmapText_PropItemIndex, dsNormal, itImage);
          Inc(CurrentIconPos, 18);
        end;

        if FEditingAction^.FindControlOptions.MatchCriteria.WillMatchBitmapFiles then
        begin
          imglstUsedMatchCriteria.Draw(TargetCanvas, CurrentIconPos, CIconYOffset, CFindControl_MatchCriteria_WillMatchBitmapFiles_PropItemIndex, dsNormal, itImage);
          Inc(CurrentIconPos, 18);
        end;

        if FEditingAction^.FindControlOptions.MatchCriteria.WillMatchPrimitiveFiles then
        begin
          imglstUsedMatchCriteria.Draw(TargetCanvas, CurrentIconPos, CIconYOffset, CFindControl_MatchCriteria_WillMatchPrimitiveFiles_PropItemIndex, dsNormal, itImage);
          Inc(CurrentIconPos, 18);
        end;
      end;
end;


procedure TfrClickerActions.HandleOnTextEditorMouseDown(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ItemIndexMod, ItemIndexDiv: Integer;
begin
  if (ACategoryIndex = CCategory_ActionSpecific) and (APropertyIndex = CFindControl_InitialRectangle_PropIndex) then
  begin
    case AItemIndex of
      CFindControl_InitialRectangle_LeftOffset_PropItemIndex:
        frClickerFindControl.UpdateOnSearchRectLeftOffsetMouseDown(FEditingAction^.FindControlOptions.InitialRectangle, Sender as TVTEdit, Button, Shift, X, Y);

      CFindControl_InitialRectangle_TopOffset_PropItemIndex:
        frClickerFindControl.UpdateOnSearchRectTopOffsetMouseDown(FEditingAction^.FindControlOptions.InitialRectangle, Sender as TVTEdit, Button, Shift, X, Y);

      CFindControl_InitialRectangle_RightOffset_PropItemIndex:
        frClickerFindControl.UpdateOnSearchRectRightOffsetMouseDown(FEditingAction^.FindControlOptions.InitialRectangle, Sender as TVTEdit, Button, Shift, X, Y);

      CFindControl_InitialRectangle_BottomOffset_PropItemIndex:
        frClickerFindControl.UpdateOnSearchRectBottomOffsetMouseDown(FEditingAction^.FindControlOptions.InitialRectangle, Sender as TVTEdit, Button, Shift, X, Y);
    end;
  end;

  if (ACategoryIndex = CCategory_ActionSpecific) and (APropertyIndex = CFindControl_MatchBitmapText_PropIndex) then
  begin
    ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
    ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;

    case ItemIndexMod of
      CFindControl_MatchBitmapText_CropLeft:
        frClickerFindControl.UpdateOnTextCroppingLeftMouseDown(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv], Sender as TVTEdit, Button, Shift, X, Y);

      CFindControl_MatchBitmapText_CropTop:
        frClickerFindControl.UpdateOnTextCroppingTopMouseDown(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv], Sender as TVTEdit, Button, Shift, X, Y);

      CFindControl_MatchBitmapText_CropRight:
        frClickerFindControl.UpdateOnTextCroppingRightMouseDown(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv], Sender as TVTEdit, Button, Shift, X, Y);

      CFindControl_MatchBitmapText_CropBottom:
        frClickerFindControl.UpdateOnTextCroppingBottomMouseDown(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv], Sender as TVTEdit, Button, Shift, X, Y);
    end;
  end;
end;


function TfrClickerActions.HandleOnTextEditorMouseMove(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
  Sender: TObject; Shift: TShiftState; X, Y: Integer): Boolean;
var
  ItemIndexMod, ItemIndexDiv: Integer;
  OldValue: string;
begin
  Result := False;

  if (ACategoryIndex = CCategory_ActionSpecific) and (APropertyIndex = CFindControl_InitialRectangle_PropIndex) then
  begin
    case AItemIndex of
      CFindControl_InitialRectangle_LeftOffset_PropItemIndex:
      begin
        OldValue := FEditingAction^.FindControlOptions.InitialRectangle.LeftOffset;
        frClickerFindControl.UpdateOnSearchRectLeftOffsetMouseMove(FEditingAction^.FindControlOptions.InitialRectangle, Sender as TVTEdit, Shift, X, Y);
        TriggerOnControlsModified(FEditingAction^.FindControlOptions.InitialRectangle.LeftOffset <> OldValue);
        Result := True;
      end;

      CFindControl_InitialRectangle_TopOffset_PropItemIndex:
      begin
        OldValue := FEditingAction^.FindControlOptions.InitialRectangle.TopOffset;
        frClickerFindControl.UpdateOnSearchRectTopOffsetMouseMove(FEditingAction^.FindControlOptions.InitialRectangle, Sender as TVTEdit, Shift, X, Y);
        TriggerOnControlsModified(FEditingAction^.FindControlOptions.InitialRectangle.TopOffset <> OldValue);
        Result := True;
      end;

      CFindControl_InitialRectangle_RightOffset_PropItemIndex:
      begin
        OldValue := FEditingAction^.FindControlOptions.InitialRectangle.RightOffset;
        frClickerFindControl.UpdateOnSearchRectRightOffsetMouseMove(FEditingAction^.FindControlOptions.InitialRectangle, Sender as TVTEdit, Shift, X, Y);
        TriggerOnControlsModified(FEditingAction^.FindControlOptions.InitialRectangle.RightOffset <> OldValue);
        Result := True;
      end;

      CFindControl_InitialRectangle_BottomOffset_PropItemIndex:
      begin
        OldValue := FEditingAction^.FindControlOptions.InitialRectangle.BottomOffset;
        frClickerFindControl.UpdateOnSearchRectBottomOffsetMouseMove(FEditingAction^.FindControlOptions.InitialRectangle, Sender as TVTEdit, Shift, X, Y);
        TriggerOnControlsModified(FEditingAction^.FindControlOptions.InitialRectangle.BottomOffset <> OldValue);
        Result := True;
      end;
    end;
  end;

  if (ACategoryIndex = CCategory_ActionSpecific) and (APropertyIndex = CFindControl_MatchBitmapText_PropIndex) then
  begin
    ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
    ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;

    case ItemIndexMod of
      CFindControl_MatchBitmapText_CropLeft:
      begin
        OldValue := FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropLeft;
        frClickerFindControl.UpdateOnTextCroppingLeftMouseMove(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv], Sender as TVTEdit, Shift, X, Y, ItemIndexDiv);
        frClickerFindControl.SelectedBMPTextTab := ItemIndexDiv;
        TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropLeft <> OldValue);
        Result := True;
      end;

      CFindControl_MatchBitmapText_CropTop:
      begin
        OldValue := FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropTop;
        frClickerFindControl.UpdateOnTextCroppingTopMouseMove(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv], Sender as TVTEdit, Shift, X, Y, ItemIndexDiv);
        frClickerFindControl.SelectedBMPTextTab := ItemIndexDiv;
        TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropTop <> OldValue);
        Result := True;
      end;

      CFindControl_MatchBitmapText_CropRight:
      begin
        OldValue := FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropRight;
        frClickerFindControl.UpdateOnTextCroppingRightMouseMove(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv], Sender as TVTEdit, Shift, X, Y, ItemIndexDiv);
        frClickerFindControl.SelectedBMPTextTab := ItemIndexDiv;
        TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropRight <> OldValue);
        Result := True;
      end;

      CFindControl_MatchBitmapText_CropBottom:
      begin
        OldValue := FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropBottom;
        frClickerFindControl.UpdateOnTextCroppingBottomMouseMove(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv], Sender as TVTEdit, Shift, X, Y, ItemIndexDiv);
        frClickerFindControl.SelectedBMPTextTab := ItemIndexDiv;
        TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropBottom <> OldValue);
        Result := True;
      end;
    end;
  end;
end;


procedure TfrClickerActions.HandleOnOITextEditorKeyUp(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: Integer;
  ItemIndexMod, ItemIndexDiv: Integer;
  OldValue, NewValue: string;
begin
  if ACategoryIndex = CCategory_ActionSpecific then
  begin
    if FEditingAction^.ActionOptions.Action in [acFindControl, acFindSubControl] then
      case APropertyIndex of
        CFindControl_MatchText_PropIndex:
        begin
          TriggerOnControlsModified(FEditingAction^.FindControlOptions.MatchText <> TVTEdit(Sender).Text);
          FEditingAction^.FindControlOptions.MatchText := TVTEdit(Sender).Text;

          frClickerFindControl.PreviewText;
          for i := 0 to Length(FEditingAction^.FindControlOptions.MatchBitmapText) - 1 do
            frClickerFindControl.BMPTextFontProfiles[i].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[i]);
        end;

        CFindControl_MatchBitmapText_PropIndex:
        begin
          ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
          ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;

          if ItemIndexMod = CFindControl_MatchBitmapText_ProfileName_PropItemIndex then
          begin
            FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].ProfileName := TVTEdit(Sender).Text;
            frClickerFindControl.UpdateFontProfileName(ItemIndexDiv, TVTEdit(Sender).Text);
          end;

          frClickerFindControl.PreviewText;
        end;

        CFindControl_MatchBitmapAlgorithmSettings_PropIndex:
        begin
          OldValue := GetActionValueStr_FindControl_MatchBitmapAlgorithmSettings(FEditingAction, AItemIndex);
          NewValue := TVTEdit(Sender).Text;
          SetActionValueStr_FindControl_MatchBitmapAlgorithmSettings(FEditingAction, NewValue, AItemIndex);
          TriggerOnControlsModified(NewValue <> OldValue);

          frClickerFindControl.UpdateSearchAreaLabelsFromKeysOnInitRect(FEditingAction^.FindControlOptions.InitialRectangle); //call this, to update the grid
        end;

        CFindControl_InitialRectangle_PropIndex:
        begin
          OldValue := GetActionValueStr_FindControl_InitialRectangle(FEditingAction, AItemIndex);
          NewValue := TVTEdit(Sender).Text;
          SetActionValueStr_FindControl_InitialRectangle(FEditingAction, NewValue, AItemIndex);
          TriggerOnControlsModified(NewValue <> OldValue);

          frClickerFindControl.UpdateSearchAreaLabelsFromKeysOnInitRect(FEditingAction^.FindControlOptions.InitialRectangle);
        end; //init rect
      end; //case
  end;
end;


procedure TfrClickerActions.HandleOnOITextEditorKeyDown(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then
    if ssCtrl in Shift then
      //open a pop-up window with a list of available variables and functions;
end;


procedure TfrClickerActions.HandleOnOIEditorAssignMenuAndTooltip(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
  Sender: TObject; var APopupMenu: TPopupMenu; var AHint: string; var AShowHint: Boolean);
var
  TempValue: string;
begin
  APopupMenu := nil;
  AHint := '';
  AShowHint := True;

  if ACategoryIndex = CCategory_ActionSpecific then
  begin
    if ANodeLevel = CPropertyLevel then
    begin
      if (CurrentlyEditingActionType = acPlugin) and (APropertyIndex > CPlugin_FileName_PropIndex) then
        AHint := 'Plugin-specific property'
      else
        AHint := CGetPropertyHint_Actions[CurrentlyEditingActionType]^[APropertyIndex];
    end;

    case CurrentlyEditingActionType of
      acExecApp:
      begin
        case APropertyIndex of
          CExecApp_PathToApp_PropIndex, CExecApp_CurrentDir_PropIndex:
          begin
            FLastClickedTVTEdit := nil;
            FLastClickedEdit := nil;

            if Sender is TVTEdit then
              FLastClickedTVTEdit := Sender as TVTEdit
            else
              FLastClickedTVTEdit := nil;

            if Sender is TEdit then
              FLastClickedEdit := Sender as TEdit
            else
              FLastClickedEdit := nil;

            APopupMenu := pmPathReplacements;
            AHint := '$AppDir$ replacement is available';
          end;
        end;
      end;

      acFindControl, acFindSubControl:
      begin
        case APropertyIndex of
          CFindControl_MatchCriteria_PropIndex:
            AHint := CGetPropertyHint_FindControlMatchCriteria_Items[AItemIndex];

          CFindControl_MatchBitmapText_PropIndex:
            case AItemIndex mod CPropCount_FindControlMatchBitmapText of
              CFindControl_MatchBitmapText_ForegroundColor_PropItemIndex, CFindControl_MatchBitmapText_BackgroundColor_PropItemIndex:
              begin
                FLastClickedTVTEdit := nil;
                FLastClickedEdit := Sender as TEdit;
                APopupMenu := pmStandardColorVariables;
              end;

              CFindControl_MatchBitmapText_IgnoreBackgroundColor_PropItemIndex:
                AHint := 'When set to True, the pixels, which match the current BackgroundColor, under the configured error level, are ignored.' + #13#10 +
                         'This option is not suitable for antialiased text, if using a color, which is very different than BackgroundColor.' + #13#10 +
                         'It is better to use it for non-antialiased text.';

              else
                ;
            end;

          CFindControl_InitialRectangle_PropIndex:
          begin
            AHint := CGetPropertyHint_FindControlInitialRectangle_Items[AItemIndex];

            if AItemIndex in [CFindControl_InitialRectangle_Left_PropItemIndex .. CFindControl_InitialRectangle_Bottom_PropItemIndex] then
            begin
              case AItemIndex of
                CFindControl_InitialRectangle_Left_PropItemIndex:
                begin
                  FLastClickedTVTEdit := Sender as TVTEdit;
                  FLastClickedEdit := nil;
                  APopupMenu := pmStandardControlRefVars;
                  TempValue := FEditingAction^.FindControlOptions.InitialRectangle.Left;
                  AHint := AHint + #13#10 + TempValue + ' = ' + EvaluateReplacements(TempValue);
                end;

                CFindControl_InitialRectangle_Top_PropItemIndex:
                begin
                  FLastClickedTVTEdit := Sender as TVTEdit;
                  FLastClickedEdit := nil;
                  APopupMenu := pmStandardControlRefVars;
                  TempValue := FEditingAction^.FindControlOptions.InitialRectangle.Top;
                  AHint := AHint + #13#10 + TempValue + ' = ' + EvaluateReplacements(TempValue);
                end;

                CFindControl_InitialRectangle_Right_PropItemIndex:
                begin
                  FLastClickedTVTEdit := Sender as TVTEdit;
                  FLastClickedEdit := nil;
                  APopupMenu := pmStandardControlRefVars;
                  TempValue := FEditingAction^.FindControlOptions.InitialRectangle.Right;
                  AHint := AHint + #13#10 + TempValue + ' = ' + EvaluateReplacements(TempValue);
                end;

                CFindControl_InitialRectangle_Bottom_PropItemIndex:
                begin
                  FLastClickedTVTEdit := Sender as TVTEdit;
                  FLastClickedEdit := nil;
                  APopupMenu := pmStandardControlRefVars;
                  TempValue := FEditingAction^.FindControlOptions.InitialRectangle.Bottom;
                  AHint := AHint + #13#10 + TempValue + ' = ' + EvaluateReplacements(TempValue);
                end;
              end;
            end;
          end; //init rect

          CFindControl_MatchBitmapFiles_PropIndex, CFindControl_MatchPrimitiveFiles_PropIndex, CFindControl_SourceFileName_PropIndex:
          begin
            if Sender is TVTEdit then
              FLastClickedTVTEdit := Sender as TVTEdit
            else
              FLastClickedTVTEdit := nil;

            FLastClickedEdit := nil;
            APopupMenu := pmPathReplacements;
            AHint := '$AppDir$ replacement is available';

            if APropertyIndex = CFindControl_MatchPrimitiveFiles_PropIndex then
            begin
              AHint := AHint + #13#10;
              AHint := AHint + 'Every .pmtv file has an index in this list.' + #13#10 +
                               'It can be read using the $FileIndex$ variable, from any primitives property.' + #13#10#13#10 +
                               'For example if a primitives file requires two colors, $BorderLineColor$ and $BorderRectColor$,' + #13#10 +
                               'They can be set using a SetVar action as, e.g.:' + #13#10#13#10 +
                               '429419$#4#5$D3D3D3$#4#5$150088$#4#5$' + #13#10 +
                               '56C221$#4#5$EBEBEB$#4#5$277FFF$#4#5$' + #13#10#13#10 +
                               'Then used by the primitives file as:' + #13#10#13#10 +
                               '$GetTextItem($BorderLineColor$,$FileIndex$)$' + #13#10 +
                               '$GetTextItem($BorderRectColor$,$FileIndex$)$';
            end;
          end;

          CFindControl_MatchByHistogramSettings_PropIndex:
          begin
            AHint := CGetPropertyHint_FindControlMatchByHistogramSettings_Items[AItemIndex];
          end;
        end; //case
      end; //FindControl

      acCallTemplate:
      begin
        case APropertyIndex of
          CCallTemplate_TemplateFileName_PropIndex:
          begin
            if Sender is TVTEdit then
              FLastClickedTVTEdit := Sender as TVTEdit
            else
              FLastClickedTVTEdit := nil;

            FLastClickedEdit := nil;
            APopupMenu := pmPathReplacements;
            AHint := '$AppDir$ replacement is available';
          end;

          CCallTemplate_CallTemplateLoop_PropIndex:
            AHint := CGetPropertyHint_CallTemplateLoop_Items[AItemIndex];
        end;
      end;

      acWindowOperations:
      begin
        APopupMenu := pmWindowOperationsEditors;

        case APropertyIndex of
          CWindowOperations_NewX_PropItemIndex, CWindowOperations_NewY_PropItemIndex:
          begin
            MenuItem_SetFromControlLeftAndTop.Enabled := True;
            MenuItem_SetFromControlWidthAndHeight.Enabled := False;
          end;

          CWindowOperations_NewWidth_PropItemIndex, CWindowOperations_NewHeight_PropItemIndex:
          begin
            MenuItem_SetFromControlLeftAndTop.Enabled := False;
            MenuItem_SetFromControlWidthAndHeight.Enabled := True;
          end;

          else
          begin
            MenuItem_SetFromControlLeftAndTop.Enabled := False;
            MenuItem_SetFromControlWidthAndHeight.Enabled := False;
          end;
        end;
      end;

      acPlugin:
        if APropertyIndex > CPlugin_FileName_PropIndex then
          AHint := FastReplace_45ToReturn(GetPluginPropertyAttribute(FEditingAction.PluginOptions.ListOfPropertiesAndTypes, CPluginPropertyAttr_Hint, APropertyIndex));

      else
        ;
    end;  //case CurrentlyEditingActionType
  end;
end;


procedure TfrClickerActions.HandleOnOIGetFileDialogSettings(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; var AFilter, AInitDir: string);
var
  EditingActionType: Integer;
begin
  AFilter := '';
  AInitDir := '';

  if ACategoryIndex <> CCategory_ActionSpecific then
    Exit;

  EditingActionType := Integer(CurrentlyEditingActionType);
  if EditingActionType = CClkUnsetAction then
    Exit;

  case CurrentlyEditingActionType of
    acExecApp:
      if APropertyIndex = CExecApp_PathToApp_PropIndex then
      begin
        AFilter := 'Executable files (*.exe)|*.exe|All files (*.*)|*.*';
        AInitDir := ExtractFileDir(ParamStr(0));
      end;

    acFindControl, acFindSubControl:
    begin
      case APropertyIndex of
        CFindControl_MatchBitmapFiles_PropIndex:
        begin
          AFilter := 'Bitmap files (*.bmp)|*.bmp|All files (*.*)|*.*';
          AInitDir := FBMPsDir;
        end;

        CFindControl_MatchPrimitiveFiles_PropIndex:
        begin
          AFilter := 'Primitives files (*.pmtv)|*.pmtv|All files (*.*)|*.*';
          AInitDir := FBMPsDir;
        end;
      end;
    end;

    acCallTemplate:
      if APropertyIndex = CCallTemplate_TemplateFileName_PropIndex then
      begin
        AFilter := 'Clicker template files (*.clktmpl)|*.clktmpl|All files (*.*)|*.*';
        AInitDir := ExtractFilePath(ParamStr(0)) + '\ActionTemplates';
      end;

    else
      Exit;
  end;
end;


procedure TfrClickerActions.HandleOnOIArrowEditorClick(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer);
var
  tp: TPoint;
  i: Integer;
  s: string;
  BMPTxt: TClkFindControlMatchBitmapText;
  ItemIndexMod, ItemIndexDiv: Integer;
  TempListOfExternallyRenderedImages: TStringList;
begin
  case ACategoryIndex of
    CCategory_Common:
      case APropertyIndex of
        CMain_ActionTimeout_PropIndex:
        begin
          FOIEditorMenu.Items.Clear;

          AddMenuItemToPopupMenu(FOIEditorMenu, '0', MenuItem_SetActionTimeoutFromOI, ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
          AddMenuItemToPopupMenu(FOIEditorMenu, '1000', MenuItem_SetActionTimeoutFromOI, ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
          AddMenuItemToPopupMenu(FOIEditorMenu, '10000', MenuItem_SetActionTimeoutFromOI, ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
          AddMenuItemToPopupMenu(FOIEditorMenu, '30000', MenuItem_SetActionTimeoutFromOI, ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

          GetCursorPos(tp);
          FOIEditorMenu.PopUp(tp.X, tp.Y);
        end
        else
          ;
      end;

    CCategory_ActionSpecific:
    begin
      if CurrentlyEditingActionType in [acFindControl, acFindSubControl] then
        case APropertyIndex of
          CFindControl_MatchText_PropIndex, CFindControl_MatchClassName_PropIndex:
          begin
            FOIEditorMenu.Items.Clear;

            AddMenuItemToPopupMenu(FOIEditorMenu, 'Copy values from preview window', MenuItem_CopyTextAndClassFromPreviewWindowClick,
              ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

            AddMenuItemToPopupMenu(FOIEditorMenu, 'Copy values from window interpreter', MenuItem_CopyTextAndClassFromWinInterpWindowClick,
              ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

            AddMenuItemToPopupMenu(FOIEditorMenu, 'Copy values from remote screen', MenuItem_CopyTextAndClassFromRemoteScreenWindowClick,
              ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

            AddMenuItemToPopupMenu(FOIEditorMenu, 'Set to system menu', MenuItem_SetTextAndClassAsSystemMenuClick,
              ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

            GetCursorPos(tp);
            FOIEditorMenu.PopUp(tp.X, tp.Y);
          end;

          CFindControl_MatchBitmapText_PropIndex:
            case ANodeLevel of
              CPropertyLevel:
              begin
                FOIEditorMenu.Items.Clear;

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Add default font profile', MenuItem_AddFontProfileToPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Add two commonly used font profiles (with Antialiased and ClearType)', MenuItem_AddFontProfileWithAntialiasedAndClearTypeToPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Add three commonly used font profiles (with NonAntialiased, Antialiased and ClearType)', MenuItem_AddFontProfileWithNonAntialiasedAndAntialiasedAndClearTypeToPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                if Length(FEditingAction^.FindControlOptions.MatchBitmapText) > 0 then
                  AddMenuItemToPopupMenu(FOIEditorMenu, '-', nil, ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                for i := 0 to Length(FEditingAction^.FindControlOptions.MatchBitmapText) - 1 do
                begin
                  BMPTxt := FEditingAction^.FindControlOptions.MatchBitmapText[i];
                  s := '  Name: ' + BMPTxt.ProfileName + '  (' + BMPTxt.FontName + ', ' + IntToStr(BMPTxt.FontSize) + ', ' + BMPTxt.ForegroundColor + ', ' + BMPTxt.BackgroundColor + ')';
                  AddMenuItemToPopupMenu(FOIEditorMenu, 'Remove font profile[' + IntToStr(i) + ']  ' + s, MenuItem_RemoveFontProfileFromPropertyListClick,
                    ANodeLevel, ACategoryIndex, APropertyIndex, i);  //ItemIndex is not the real one. It points to the profile index.
                end;

                if Length(FEditingAction^.FindControlOptions.MatchBitmapText) > 0 then
                  AddMenuItemToPopupMenu(FOIEditorMenu, '-', nil, ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                for i := 0 to Length(FEditingAction^.FindControlOptions.MatchBitmapText) - 1 do
                begin
                  BMPTxt := FEditingAction^.FindControlOptions.MatchBitmapText[i];
                  s := '  Name: ' + BMPTxt.ProfileName + '  (' + BMPTxt.FontName + ', ' + IntToStr(BMPTxt.FontSize) + ', ' + BMPTxt.ForegroundColor + ', ' + BMPTxt.BackgroundColor + ')';
                  AddMenuItemToPopupMenu(FOIEditorMenu, 'Duplicate font profile[' + IntToStr(i) + ']  ' + s, MenuItem_DuplicateFontProfileClick,
                    ANodeLevel, ACategoryIndex, APropertyIndex, i);  //ItemIndex is not the real one. It points to the profile index.
                end;

                GetCursorPos(tp);
                FOIEditorMenu.PopUp(tp.X, tp.Y);
              end;

              CPropertyItemLevel:
              begin
                ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
                ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;

                if ItemIndexMod = CFindControl_MatchBitmapText_ProfileName_PropItemIndex then
                  if Length(FEditingAction^.FindControlOptions.MatchBitmapText) > 1 then  //add only if there are at least two profiles
                  begin
                    FOIEditorMenu.Items.Clear;

                    AddMenuItemToPopupMenu(FOIEditorMenu, 'Move font profile up', MenuItem_MoveFontProfileUpInPropertyListClick,
                      ANodeLevel, ACategoryIndex, APropertyIndex, ItemIndexDiv); //sending the profile index through item index arg

                    AddMenuItemToPopupMenu(FOIEditorMenu, 'Move font profile down', MenuItem_MoveFontProfileDownInPropertyListClick,
                      ANodeLevel, ACategoryIndex, APropertyIndex, ItemIndexDiv); //sending the profile index through item index arg

                    GetCursorPos(tp);
                    FOIEditorMenu.PopUp(tp.X, tp.Y);
                  end;
              end;
            end; //case

          CFindControl_MatchBitmapFiles_PropIndex:
          begin
            case ANodeLevel of
              CPropertyLevel:
              begin
                FOIEditorMenu.Items.Clear;

                /////////////////////////////////// To add to menu item handlers
                /////////////////////////////////// Add also to browse buttons

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Add file(s) to this list...', MenuItem_AddBMPFilesToPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Remove all files from this list...', MenuItem_RemoveAllBMPFilesFromPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                GetCursorPos(tp);
                FOIEditorMenu.PopUp(tp.X, tp.Y);
              end;

              CPropertyItemLevel:
              begin
                FOIEditorMenu.Items.Clear;

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Browse...', MenuItem_BrowseBMPFileFromPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 0);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Remove file from list...', MenuItem_RemoveBMPFileFromPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 1);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Move file up (one position)', MenuItem_MoveBMPFileUpInPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 2);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Move file down (one position)', MenuItem_MoveBMPFileDownInPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 3);

                GetCursorPos(tp);
                FOIEditorMenu.PopUp(tp.X, tp.Y);
              end;

              else
                ;
            end;
          end;

          CFindControl_MatchPrimitiveFiles_PropIndex:
          begin
            case ANodeLevel of
              CPropertyLevel:
              begin
                FOIEditorMenu.Items.Clear;

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Add existing file(s) to this list...', MenuItem_AddExistingPrimitiveFilesToPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Add new file to this list...', MenuItem_AddNewPrimitiveFilesToPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Remove all files from this list...', MenuItem_RemoveAllPrimitiveFilesFromPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                GetCursorPos(tp);
                FOIEditorMenu.PopUp(tp.X, tp.Y);
              end;

              CPropertyItemLevel:
              begin
                FOIEditorMenu.Items.Clear;

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Browse...', MenuItem_BrowsePrimitiveFileFromPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 0);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Remove file from list...', MenuItem_RemovePrimitiveFileFromPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 1);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Move file up (one position)', MenuItem_MovePrimitiveFileUpInPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 2);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Move file down (one position)', MenuItem_MovePrimitiveFileDownInPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 3);

                AddMenuItemToPopupMenu(FOIEditorMenu, '-', nil,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Save file', MenuItem_SavePrimitiveFileInPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 4);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Save file as...', MenuItem_SavePrimitiveFileAsInPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 5);

                AddMenuItemToPopupMenu(FOIEditorMenu, '-', nil,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                AddMenuItemToPopupMenu(FOIEditorMenu, 'Discard changes and reload file...', MenuItem_DiscardChangesAndReloadPrimitiveFileInPropertyListClick,
                  ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 6);

                GetCursorPos(tp);
                FOIEditorMenu.PopUp(tp.X, tp.Y);
              end;

              else
                ;
            end;
          end;  //CFindControl_MatchPrimitiveFiles_PropIndex

          CFindControl_SourceFileName_PropIndex:
          begin
            if ANodeLevel = CPropertyLevel then
            begin
              FOIEditorMenu.Items.Clear;

              case FEditingAction^.FindControlOptions.ImageSourceFileNameLocation of
                isflDisk:
                begin
                  AddMenuItemToPopupMenu(FOIEditorMenu, 'Browse...', MenuItem_BrowseImageSourceFromPropertyListClick,
                    ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                  FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 0);
                end;

                isflMem:
                begin
                  TempListOfExternallyRenderedImages := TStringList.Create;
                  try
                    DoOnGetListOfExternallyRenderedImages(TempListOfExternallyRenderedImages);

                    if TempListOfExternallyRenderedImages.Count = 0 then
                    begin
                      AddMenuItemToPopupMenu(FOIEditorMenu, 'No files in externally rendered In-Mem file system', MenuItem_NoImageSourceInInMemPropertyListClick, ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                      FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstFindControlProperties, CFindControl_ImageSourceFileNameLocation_PropIndex);
                    end
                    else
                    begin
                      AddMenuItemToPopupMenu(FOIEditorMenu, 'Browse with preview...', MenuItem_BrowseFileNameFromInMemPropertyListClick,
                        ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                      FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstMatchPrimitiveFilesProperties, 0);

                      AddMenuItemToPopupMenu(FOIEditorMenu, '-', nil, ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

                      for i := 0 to TempListOfExternallyRenderedImages.Count - 1 do
                      begin
                        AddMenuItemToPopupMenu(FOIEditorMenu, TempListOfExternallyRenderedImages.Strings[i], MenuItem_SetFileNameFromInMemPropertyListClick,
                          ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);
                        FOIEditorMenu.Items.Items[FOIEditorMenu.Items.Count - 1].Bitmap := CreateBitmapForMenu(imglstFindControlProperties, CFindControl_ImageSourceFileNameLocation_PropIndex);
                      end;
                    end;
                  finally
                    TempListOfExternallyRenderedImages.Free;
                  end;
                end;
              end;

              GetCursorPos(tp);
              FOIEditorMenu.PopUp(tp.X, tp.Y);
            end;
          end;
        end; //case APropertyIndex

      if CurrentlyEditingActionType = acCallTemplate then
        case APropertyIndex of
          CCallTemplate_TemplateFileName_PropIndex:
          begin
            if CurrentlyEditingActionType = acCallTemplate then
            begin
              LoadListOfAvailableTemplates;
              GetCursorPos(tp);
              FPmLocalTemplates.PopUp(tp.X, tp.Y);
            end;
          end;
        end;

      if CurrentlyEditingActionType in [acLoadSetVarFromFile, acSaveSetVarToFile] then
        case APropertyIndex of
          CLoadSetVarFromFile_FileName_PropIndex:
          begin
            FOIEditorMenu.Items.Clear;
            AddMenuItemToPopupMenu(FOIEditorMenu, 'Browse...', MenuItem_BrowseSetVarFileInPropertyListClick,
                ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

            FOIEditorMenu.PopUp;
          end;

          CLoadSetVarFromFile_SetVarActionName_PropIndex:
          begin
            LoadListOfAvailableSetVarActions;
            FPmLocalTemplates.PopUp;
          end;
        end; //case APropertyIndex

      if CurrentlyEditingActionType = acPlugin then
      begin
        case APropertyIndex of
          CPlugin_FileName_PropIndex:
          begin
            FOIEditorMenu.Items.Clear;
            AddMenuItemToPopupMenu(FOIEditorMenu, 'Browse...', MenuItem_BrowsePluginFileInPropertyListClick,
                ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex);

            FOIEditorMenu.PopUp;
          end;

          else
          begin
            LoadListOfAvailableActionsForPlugin(APropertyIndex - CPropCount_Plugin);
            FPmLocalTemplates.PopUp;
          end;
        end; //case APropertyIndex
      end; //plugin
    end; //CCategory_ActionSpecific
  end;
end;


procedure TfrClickerActions.HandleOnOIUserEditorClick(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; var ARepaintValue: Boolean);
var
  EditingActionType: Integer;
  Condition: string;
begin
  case ACategoryIndex of
    CCategory_Common:
    begin
      if APropertyIndex = CMain_ActionCondition_PropIndex then
      begin
        Condition := FEditingAction^.ActionOptions.ActionCondition;
        if DoOnEditCallTemplateBreakCondition(Condition) then
        begin
          TriggerOnControlsModified(FEditingAction^.ActionOptions.ActionCondition <> Condition);
          FEditingAction^.ActionOptions.ActionCondition := Condition;
        end;
      end;
    end;

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        Exit;

      case CurrentlyEditingActionType of
        acExecApp:
          if APropertyIndex = CExecApp_ListOfParams_PropIndex then
          begin
            frClickerExecApp.BringToFront;  //MessageBox(Handle, 'Param list editor', 'Files', MB_ICONINFORMATION);
          end;

        acFindControl, acFindSubControl:
          if APropertyIndex in [CFindControl_MatchBitmapFiles_PropIndex, CFindControl_MatchPrimitiveFiles_PropIndex] then
          begin
            //MessageBox(Handle, 'File list editor', 'Files', MB_ICONINFORMATION);
            TriggerOnControlsModified;
          end;

        acCallTemplate:
        begin
          case APropertyIndex of
            CCallTemplate_ListOfCustomVarsAndValues_PropIndex:
            begin
              frClickerCallTemplate.SetListOfCustomVariables(FEditingAction^.CallTemplateOptions.ListOfCustomVarsAndValues);
              //TriggerOnControlsModified;
            end;

            CCallTemplate_CallTemplateLoop_PropIndex:
              if AItemIndex = CCallTemplate_CallTemplateLoopProperties_BreakCondition_PropItemIndex then
              begin
                Condition := FEditingAction^.CallTemplateOptions.CallTemplateLoop.BreakCondition;
                if DoOnEditCallTemplateBreakCondition(Condition) then
                begin
                  TriggerOnControlsModified(FEditingAction^.CallTemplateOptions.CallTemplateLoop.BreakCondition <> Condition);
                  FEditingAction^.CallTemplateOptions.CallTemplateLoop.BreakCondition := Condition;
                end;
              end;
          end;
        end;

        acSetVar:
          if APropertyIndex = CSetVar_ListOfVarNamesValuesAndEvalBefore_PropItemIndex then
          begin
            frClickerSetVar.SetListOfSetVars(FEditingAction^.SetVarOptions);
            frClickerSetVar.BringToFront;
            //MessageBox(Handle, 'SetVar editor', 'Files', MB_ICONINFORMATION);
          end;

        else
          ;
      end;   //case
    end; //CCategory_ActionSpecific
  end; //case
end;


function TfrClickerActions.HandleOnOIBrowseFile(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer;
  AFilter, ADialogInitDir: string; var Handled: Boolean; AReturnMultipleFiles: Boolean = False): string;
var
  EditingActionType: Integer;
  AOpenDialog: TOpenDialog;
begin
  Result := '';

  case ACategoryIndex of
    CCategory_Common:
      ;

    CCategory_ActionSpecific:
    begin
      EditingActionType := Integer(CurrentlyEditingActionType);
      if EditingActionType = CClkUnsetAction then
        Exit;

      case CurrentlyEditingActionType of
        acExecApp:
          if APropertyIndex = CExecApp_PathToApp_PropIndex then
          begin
            AOpenDialog := TOpenDialog.Create(nil);
            try
              AOpenDialog.InitialDir := ExtractFileDir(ParamStr(0));
              AOpenDialog.Filter := AFilter;

              if AOpenDialog.Execute then
                Result := AOpenDialog.FileName;

              Handled := True;
            finally
              AOpenDialog.Free;
            end;
          end;

        acFindControl, acFindSubControl:
        begin
          if APropertyIndex = CFindControl_MatchBitmapText_PropIndex then
            Handled := True; //do nothing, this is not a file path

          if APropertyIndex = CFindControl_MatchBitmapFiles_PropIndex then
          begin
            DoOnSetPictureOpenDialogInitialDir(ADialogInitDir);
            DoOnSetPictureSetOpenDialogMultiSelect;

            if DoOnPictureOpenDialogExecute then
              Result := DoOnGetPictureOpenDialogFileName;

            Handled := True;
          end;

          if APropertyIndex = CFindControl_MatchPrimitiveFiles_PropIndex then
          begin
            DoOnSetOpenDialogInitialDir(ADialogInitDir);
            DoOnSetOpenDialogMultiSelect;

            if DoOnOpenDialogExecute(CPrimitivesDialogFilter) then
              Result := DoOnGetOpenDialogFileName;

            Handled := True;
          end;
        end;

        acCallTemplate:
        begin
          case APropertyIndex of
            CCallTemplate_TemplateFileName_PropIndex:
            begin
              DoOnSetOpenDialogInitialDir(ADialogInitDir);
              if DoOnOpenDialogExecute(CTemplateDialogFilter) then
                Result := DoOnGetOpenDialogFileName;

              Handled := True;
            end;

            else
              ;
          end;
        end;

        else
          ;
      end;   //case
    end; //CCategory_ActionSpecific
  end; //case
end;


procedure TfrClickerActions.HandleOnOIAfterSpinTextEditorChanging(ANodeLevel, ACategoryIndex, APropertyIndex, AItemIndex: Integer; var ANewValue: string);
var
  ItemIndexMod, ItemIndexDiv: Integer;
  OldValue: string;
begin
  if (CurrentlyEditingActionType in [acFindControl, acFindSubControl]) and
     (ACategoryIndex = CCategory_ActionSpecific) then
  begin
    case APropertyIndex of
      CFindControl_InitialRectangle_PropIndex:
        if AItemIndex in [CFindControl_InitialRectangle_LeftOffset_PropItemIndex .. CFindControl_InitialRectangle_BottomOffset_PropItemIndex] then
        begin
          OldValue := GetActionValueStr_FindControl_InitialRectangle(FEditingAction, AItemIndex);
          SetActionValueStr_FindControl_InitialRectangle(FEditingAction, ANewValue, AItemIndex);
          TriggerOnControlsModified(ANewValue <> OldValue);

          frClickerFindControl.UpdateSearchAreaLabelsFromKeysOnInitRect(FEditingAction^.FindControlOptions.InitialRectangle);
        end;

      CFindControl_MatchBitmapText_PropIndex:
      begin
        ItemIndexMod := AItemIndex mod CPropCount_FindControlMatchBitmapText;
        ItemIndexDiv := AItemIndex div CPropCount_FindControlMatchBitmapText;

        case ItemIndexMod of
          CFindControl_MatchBitmapText_CropLeft:
          begin
            OldValue := FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropLeft;
            FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropLeft := ANewValue;
            if StrToIntDef(ANewValue, 0) < 0 then
              ANewValue := '0';

            frClickerFindControl.BMPTextFontProfiles[ItemIndexDiv].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv]);
            TriggerOnControlsModified(ANewValue <> OldValue);
          end;

          CFindControl_MatchBitmapText_CropTop:
          begin
            OldValue := FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropTop;
            FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropTop := ANewValue;
            if StrToIntDef(ANewValue, 0) < 0 then
              ANewValue := '0';

            frClickerFindControl.BMPTextFontProfiles[ItemIndexDiv].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv]);
            TriggerOnControlsModified(ANewValue <> OldValue);
          end;

          CFindControl_MatchBitmapText_CropRight:
          begin
            OldValue := FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropRight;
            FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropRight := ANewValue;
            if StrToIntDef(ANewValue, 0) < 0 then
              ANewValue := '0';

            frClickerFindControl.BMPTextFontProfiles[ItemIndexDiv].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv]);
            TriggerOnControlsModified(ANewValue <> OldValue);
          end;

          CFindControl_MatchBitmapText_CropBottom:
          begin
            OldValue := FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropBottom;
            FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv].CropBottom := ANewValue;
            if StrToIntDef(ANewValue, 0) < 0 then
              ANewValue := '0';

            frClickerFindControl.BMPTextFontProfiles[ItemIndexDiv].UpdateSelectionLabelsFromCropInfo(FEditingAction^.FindControlOptions.MatchBitmapText[ItemIndexDiv]);
            TriggerOnControlsModified(ANewValue <> OldValue);
          end;
        end;
      end; //MatchBitmapText

      CFindControl_MatchBitmapAlgorithmSettings_PropIndex:
      begin
        OldValue := GetActionValueStr_FindControl_MatchBitmapAlgorithmSettings(FEditingAction, AItemIndex);
        SetActionValueStr_FindControl_MatchBitmapAlgorithmSettings(FEditingAction, ANewValue, AItemIndex);
        TriggerOnControlsModified(ANewValue <> OldValue);

        frClickerFindControl.UpdateSearchAreaLabelsFromKeysOnInitRect(FEditingAction^.FindControlOptions.InitialRectangle); //call this, to update the grid
      end;

      CFindControl_MatchByHistogramSettings_PropIndex:
        if AItemIndex in [CFindControl_MatchByHistogramSettings_MinPercentColorMatch_PropItemIndex .. CFindControl_MatchByHistogramSettings_MostSignificantColorCountInBackgroundBmp_PropItemIndex] then
        begin
          OldValue := GetActionValueStr_FindControl_MatchByHistogramSettings(FEditingAction, AItemIndex);
          SetActionValueStr_FindControl_MatchByHistogramSettings(FEditingAction, ANewValue, AItemIndex);
          TriggerOnControlsModified(ANewValue <> OldValue);
        end;
    end; //case
  end;
end;


procedure TfrClickerActions.HandleOnOISelectedNode(NodeLevel, CategoryIndex, PropertyIndex, PropertyItemIndex, Column: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  PrimitiveFileNames: TStringList;
  PrimitiveFile_Modified: TStringList;
  IndexOfModifiedPmtv: Integer;
  PmtvFnm: string;
begin
  //load primitives frame
  if (CurrentlyEditingActionType in [acFindControl, acFindSubControl]) and
     (CategoryIndex = CCategory_ActionSpecific) then
    if (NodeLevel = CPropertyItemLevel) and (PropertyIndex = CFindControl_MatchPrimitiveFiles_PropIndex) then
    begin
      PrimitiveFileNames := TStringList.Create;
      PrimitiveFile_Modified := TStringList.Create;
      try
        PrimitiveFileNames.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles;
        PrimitiveFile_Modified.Text := FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified;

        IndexOfModifiedPmtv := PrimitiveFile_Modified.IndexOf('1');
        if IndexOfModifiedPmtv > -1 then
        begin
          if IndexOfModifiedPmtv <> PropertyItemIndex then   //found a modified file, which is not this one
          begin
            if MessageBox(Handle, 'The current primitives file is modified. If you select another one, the changes will be lost. Continue?', PChar(Application.Title), MB_ICONWARNING + MB_YESNO) = IDNO then
            begin  //no, go back to the modified file
              FOIFrame.SelectNode(NodeLevel, CategoryIndex, PropertyIndex, FPrevSelectedPrimitiveNode);
              Exit;
            end
            else
            begin //yes, select the new file and reset the flag on the old one
              PrimitiveFile_Modified.Strings[FPrevSelectedPrimitiveNode] := '0'; //reset modified flag
              FEditingAction^.FindControlOptions.MatchPrimitiveFiles_Modified := PrimitiveFile_Modified.Text;
              FOIFrame.RepaintNodeByLevel(NodeLevel, CategoryIndex, PropertyIndex, FPrevSelectedPrimitiveNode);
            end;
          end
          else
            Exit; //the same (maodified) file is selected, nothing to do here
        end;

        FPrevSelectedPrimitiveNode := PropertyItemIndex;

        frClickerFindControl.CreateClickerPrimitivesFrame;
        frClickerFindControl.frClickerPrimitives.FileIndex := PropertyItemIndex;
        frClickerFindControl.frClickerPrimitives.OnEvaluateReplacementsFunc := HandleOnEvaluateReplacementsFunc;
        frClickerFindControl.frClickerPrimitives.OnLoadBitmap := HandleOnLoadBitmap;
        frClickerFindControl.frClickerPrimitives.OnLoadRenderedBitmap := HandleOnLoadRenderedBitmap;
        frClickerFindControl.frClickerPrimitives.OnGetListOfExternallyRenderedImages := HandleOnGetListOfExternallyRenderedImages;
        frClickerFindControl.frClickerPrimitives.OnLoadPrimitivesFile := HandleOnLoadPrimitivesFile;
        frClickerFindControl.frClickerPrimitives.OnSavePrimitivesFile := HandleOnSavePrimitivesFile;
        frClickerFindControl.frClickerPrimitives.OnTriggerOnControlsModified := HandleOnPrimitivesTriggerOnControlsModified;
        frClickerFindControl.frClickerPrimitives.OnSaveFromMenu := HandleOnSaveFromMenu;
        frClickerFindControl.frClickerPrimitives.OnPictureOpenDialogExecute := HandleOnPictureOpenDialogExecute;
        frClickerFindControl.frClickerPrimitives.OnGetPictureOpenDialogFileName := HandleOnGetPictureOpenDialogFileName;

        PmtvFnm := PrimitiveFileNames.Strings[PropertyItemIndex];
        PmtvFnm := StringReplace(PmtvFnm, '$TemplateDir$', FFullTemplatesDir, [rfReplaceAll]);
        PmtvFnm := StringReplace(PmtvFnm, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]);
        PmtvFnm := StringReplace(PmtvFnm, '$SelfTemplateDir$', ExtractFileDir(DoOnGetLoadedTemplateFileName), [rfReplaceAll]);
        PmtvFnm := EvaluateReplacements(PmtvFnm);

        DoOnAddToLog('Loading primitives file: "' + ExpandFileName(PmtvFnm) + '".');

        frClickerFindControl.frClickerPrimitives.LoadFile(PmtvFnm);
      finally
        PrimitiveFileNames.Free;
        PrimitiveFile_Modified.Free;
      end;
    end;
end;


procedure TfrClickerActions.HandleOnOIFirstVisibleNode(NodeLevel, CategoryIndex, PropertyIndex, PropertyItemIndex: Integer);
begin
  FEditingAction^.ScrollIndex := COIScrollInfo_NodeLevel + '=' + IntToStr(NodeLevel) + #13#10 +
                                 COIScrollInfo_CategoryIndex + '=' + IntToStr(CategoryIndex) + #13#10 +
                                 COIScrollInfo_PropertyIndex + '=' + IntToStr(PropertyIndex) + #13#10 +
                                 COIScrollInfo_PropertyItemIndex + '=' + IntToStr(PropertyItemIndex);

  DoOnUpdateActionScrollIndex(FEditingAction^.ScrollIndex);
end;

end.

