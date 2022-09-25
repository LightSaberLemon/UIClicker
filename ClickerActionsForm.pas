{
    Copyright (C) 2022 VCC
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


unit ClickerActionsForm;

{$H+}
{$IFDEF FPC}
  //{$MODE Delphi}
{$ENDIF}


interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, Menus, ClickerActionsArrFrame, InMemFileSystem,
  IdHTTPServer, IdSchedulerOfThreadPool, IdCustomHTTPServer, IdContext, IdSync, IdGlobal,
  PollingFIFO, ClickerFileProviderClient, IniFiles, ClickerUtils, ClickerActionExecution,
  ClickerIniFiles;

type
  TLoggingSyncObj = class(TIdSync)
  private
    FMsg: string;
  protected
    procedure DoSynchronize; override;
  end;

  TSyncHTTPCmd = class(TIdSync)
  private
    FCmd: string;
    FParams: TStrings;
    FResult: string;
    FErrCode: Integer;
    FFrame: TfrClickerActionsArr;
    FBmp: TBitmap;
    FGPStream: TMemoryStream;
  protected
    procedure DoSynchronize; override;
  public
    constructor Create; override;
  end;

  TOnRecordComponent = procedure(ACompHandle: THandle; ATreeContentStream: TMemoryStream) of object;
  TOnGetCurrentlyRecordedScreenShotImage = procedure(ABmp: TBitmap) of object;

  { TfrmClickerActions }

  TfrmClickerActions = class(TForm)
    btnBrowseActionTemplatesDir: TButton;
    btnTestConnection: TButton;
    chkDisplayActivity: TCheckBox;
    chkKeepAlive: TCheckBox;
    chkSetExperimentsToClientMode: TCheckBox;
    chkServerActive: TCheckBox;
    chkStayOnTop: TCheckBox;
    cmbExecMode: TComboBox;
    cmbFilesExistence: TComboBox;
    grpMissingFilesMonitoring: TGroupBox;
    grpAllowedFileExtensionsForServer: TGroupBox;
    grpAllowedFileDirsForServer: TGroupBox;
    grpVariables: TGroupBox;
    IdHTTPServer1: TIdHTTPServer;
    IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool;
    imglstCalledTemplates: TImageList;
    imglstMainPage: TImageList;
    lblClientMode: TLabel;
    lbeConnectTimeout: TLabeledEdit;
    lblServerMode: TLabel;
    lblFileMonitoringThreadInfo: TLabel;
    lblFilesExistence: TLabel;
    lblAdminStatus: TLabel;
    lblExp1: TLabel;
    lblExp2: TLabel;
    lblLocalModeInfo: TLabel;
    lblServerInfo: TLabel;
    lbeServerModePort: TLabeledEdit;
    lbeClientModeServerAddress: TLabeledEdit;
    lbePathToTemplates: TLabeledEdit;
    lblExecMode: TLabel;
    memAllowedFileExtensionsForServer: TMemo;
    memAllowedFileDirsForServer: TMemo;
    memVariables: TMemo;
    PageControlExecMode: TPageControl;
    PageControlMain: TPageControl;
    PageControlPlayer: TPageControl;
    pnlMissingFilesRequest: TPanel;
    scrboxMain: TScrollBox;
    TabSheetLocalMode: TTabSheet;
    TabSheetClientMode: TTabSheet;
    TabSheetServerMode: TTabSheet;
    TabSheetSettings: TTabSheet;
    TabSheetTemplateExec: TTabSheet;
    TabSheetExecMainPlayer: TTabSheet;
    TabSheetExperiments1: TTabSheet;
    TabSheetExperiments2: TTabSheet;
    tmrDisplayMissingFilesRequests: TTimer;
    tmrStartup: TTimer;
    procedure btnBrowseActionTemplatesDirClick(Sender: TObject);
    procedure btnTestConnectionClick(Sender: TObject);
    procedure chkDisplayActivityChange(Sender: TObject);
    procedure chkServerActiveChange(Sender: TObject);
    procedure chkStayOnTopClick(Sender: TObject);
    procedure cmbExecModeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure IdHTTPServer1CommandOther(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure IdHTTPServer1Connect(AContext: TIdContext);
    procedure IdHTTPServer1Exception(AContext: TIdContext; AException: Exception
      );
    procedure tmrDisplayMissingFilesRequestsTimer(Sender: TObject);
    procedure tmrStartupTimer(Sender: TObject);
  private
    FStopAllActionsOnDemand: Boolean;
    FFullTemplatesDir: string;
    FBMPsDir: string;
    FInMemFileSystem: TInMemFileSystem;
    FFileAvailabilityFIFO: TPollingFIFO;
    FPollForMissingServerFiles: TPollForMissingServerFiles;
    FProcessingMissingFilesRequestByClient: Boolean; //for activity info
    FProcessingMissingFilesRequestByServer: Boolean; //for activity info

    FTerminateWaitForFileAvailability: Boolean;
    FTerminateWaitForMultipleFilesAvailability: Boolean;

    FOnCopyControlTextAndClassFromMainWindow: TOnCopyControlTextAndClassFromMainWindow;
    FOnRecordComponent: TOnRecordComponent;
    FOnGetCurrentlyRecordedScreenShotImage: TOnGetCurrentlyRecordedScreenShotImage;
    FOnLoadBitmap: TOnLoadBitmap;

    FOnFileExists: TOnFileExists;
    FOnTClkIniReadonlyFileCreate: TOnTClkIniReadonlyFileCreate;
    FOnSaveTemplateToFile: TOnSaveTemplateToFile;
    FOnSetTemplateOpenDialogInitialDir: TOnSetTemplateOpenDialogInitialDir;
    FOnTemplateOpenDialogExecute: TOnTemplateOpenDialogExecute;
    FOnGetTemplateOpenDialogFileName: TOnGetTemplateOpenDialogFileName;
    FOnSetTemplateSaveDialogInitialDir: TOnSetTemplateOpenDialogInitialDir;
    FOnTemplateSaveDialogExecute: TOnTemplateOpenDialogExecute;
    FOnGetTemplateSaveDialogFileName: TOnGetTemplateOpenDialogFileName;
    FOnSetTemplateSaveDialogFileName: TOnSetTemplateOpenDialogFileName;
    FOnSetPictureOpenDialogInitialDir: TOnSetPictureOpenDialogInitialDir;
    FOnPictureOpenDialogExecute: TOnPictureOpenDialogExecute;
    FOnGetPictureOpenDialogFileName: TOnGetPictureOpenDialogFileName;

    //frClickerActionsArrMain: TfrClickerActionsArr;    //eventually, these fields should be made private again, and accessed through methods
    //frClickerActionsArrExperiment1: TfrClickerActionsArr;
    //frClickerActionsArrExperiment2: TfrClickerActionsArr;

    FControlPlayerPopup: TPopupMenu;

    procedure SetFullTemplatesDir(Value: string);
    function GetShowDeprecatedControls: Boolean;
    procedure SetShowDeprecatedControls(Value: Boolean);

    function GetBMPsDir: string;
    procedure SetBMPsDir(Value: string);

    function GetConfiguredRemoteAddress: string;
    function GetActionExecution: TActionExecution;

    procedure DoOnRecordComponent(ACompHandle: THandle; ATreeContentStream: TMemoryStream);
    procedure DoOnGetCurrentlyRecordedScreenShotImage(ABmp: TBitmap);

    function DoLoadBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
    function DoOnFileExists(const AFileName: string): Boolean;

    function DoOnTClkIniReadonlyFileCreate(AFileName: string): TClkIniReadonlyFile;
    procedure DoOnSaveTemplateToFile(AStringList: TStringList; const AFileName: string);
    procedure DoOnSetTemplateOpenDialogInitialDir(AInitialDir: string);
    function DoOnTemplateOpenDialogExecute: Boolean;
    function DoOnGetTemplateOpenDialogFileName: string;
    procedure DoOnSetTemplateSaveDialogInitialDir(AInitialDir: string);
    function DoOnTemplateSaveDialogExecute: Boolean;
    function DoOnGetTemplateSaveDialogFileName: string;
    procedure DoOnSetTemplateSaveDialogFileName(AFileName: string);
    procedure DoOnSetPictureOpenDialogInitialDir(AInitialDir: string);
    function DoOnPictureOpenDialogExecute: Boolean;
    function DoOnGetPictureOpenDialogFileName: string;

    procedure MenuItemOpenTemplateAsExp1Click(Sender: TObject);
    procedure MenuItemOpenTemplateAsExp2Click(Sender: TObject);
    procedure frClickerActionsArrExperiment1PasteDebugValuesListFromMainExecutionList1Click(Sender: TObject);
    procedure frClickerActionsArrExperiment2PasteDebugValuesListFromMainExecutionList1Click(Sender: TObject);

    function GetListOfWaitingFiles: string;
    function GetCompAtPoint(AParams: TStrings): string;

    procedure HandleNewFrameRefreshButton(Sender: TObject);
    function frClickerActionsArrOnCallTemplate(Sender: TObject; AFileNameToCall: string; ListOfVariables: TStrings; DebugBitmap: TBitmap; DebugGridImage: TImage; IsDebugging: Boolean; AStackLevel: Integer; AExecutesRemotely: Boolean): Boolean;
    procedure HandleOnCopyControlTextAndClassFromMainWindow(ACompProvider: string; out AControlText, AControlClass: string);
    function HandleOnGetExtraSearchAreaDebuggingImageWithStackLevel(AExtraBitmap: TBitmap; AStackLevel: Integer): Boolean;

    procedure HandleOnWaitForFileAvailability(AFileName: string); //ClickerActionsArrFrame instances call this, to add a filename to FIFO
    procedure HandleOnWaitForMultipleFilesAvailability(AListOfFiles: TStringList); //ClickerActionsArrFrame instances call this, to add multiple filenames to FIFO
    procedure HandleOnWaitForBitmapsAvailability(AListOfBitmapFiles: TStringList);  //ClickerActionsArrFrame instances call this, to add multiple bmps to FIFO, if not found

    function HandleOnLoadBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
    function HandleOnFileExists(const FileName: string): Boolean;

    procedure HandleOnBeforeRequestingListOfMissingFiles;  //client thread calls this, without UI sync
    procedure HandleOnAfterRequestingListOfMissingFiles;   //client thread calls this, without UI sync

    function HandleOnComputeInMemFileHash(AFileContent: Pointer; AFileSize: Int64): string;

    function HandleOnTClkIniReadonlyFileCreate(AFileName: string): TClkIniReadonlyFile;
    procedure HandleOnSaveTemplateToFile(AStringList: TStringList; const FileName: string);
    procedure HandleOnSetTemplateOpenDialogInitialDir(AInitialDir: string);
    function HandleOnTemplateOpenDialogExecute: Boolean;
    function HandleOnGetTemplateOpenDialogFileName: string;
    procedure HandleOnSetTemplateSaveDialogInitialDir(AInitialDir: string);
    function HandleOnTemplateSaveDialogExecute: Boolean;
    function HandleOnGetTemplateSaveDialogFileName: string;
    procedure HandleOnSetTemplateSaveDialogFileName(AFileName: string);
    procedure HandleOnSetPictureOpenDialogInitialDir(AInitialDir: string);
    function HandleOnPictureOpenDialogExecute: Boolean;
    function HandleOnGetPictureOpenDialogFileName: string;

    procedure CreateRemainingUIComponents;
    function GetClickerActionsArrFrameByStackLevel(AStackLevel: Integer): TfrClickerActionsArr;

    procedure AddToLog(s: string);
    function ProcessServerCmd(ASyncObj: TSyncHTTPCmd): string; //used in server mode

    property BMPsDir: string read GetBMPsDir write SetBMPsDir;
  public
    frClickerActionsArrMain: TfrClickerActionsArr;           //to be removed from public
    frClickerActionsArrExperiment1: TfrClickerActionsArr;
    frClickerActionsArrExperiment2: TfrClickerActionsArr;

    procedure LoadSettings(AIni: TMemIniFile);
    procedure SaveSettings(AIni: TMemIniFile);

    //public properties (because of creating new instances)
    property FullTemplatesDir: string read FFullTemplatesDir write SetFullTemplatesDir;  //no trailing backslash
    property ShowDeprecatedControls: Boolean read GetShowDeprecatedControls write SetShowDeprecatedControls;
    property ConfiguredRemoteAddress: string read GetConfiguredRemoteAddress;
    property ActionExecution: TActionExecution read GetActionExecution;
    property StopAllActionsOnDemand: Boolean read FStopAllActionsOnDemand write FStopAllActionsOnDemand;

    property OnCopyControlTextAndClassFromMainWindow: TOnCopyControlTextAndClassFromMainWindow read FOnCopyControlTextAndClassFromMainWindow write FOnCopyControlTextAndClassFromMainWindow;
    property OnRecordComponent: TOnRecordComponent read FOnRecordComponent write FOnRecordComponent;
    property OnGetCurrentlyRecordedScreenShotImage: TOnGetCurrentlyRecordedScreenShotImage read FOnGetCurrentlyRecordedScreenShotImage write FOnGetCurrentlyRecordedScreenShotImage;
    property OnLoadBitmap: TOnLoadBitmap read FOnLoadBitmap write FOnLoadBitmap;

    property OnFileExists: TOnFileExists write FOnFileExists;
    property OnTClkIniReadonlyFileCreate: TOnTClkIniReadonlyFileCreate write FOnTClkIniReadonlyFileCreate;
    property OnSaveTemplateToFile: TOnSaveTemplateToFile write FOnSaveTemplateToFile;
    property OnSetTemplateOpenDialogInitialDir: TOnSetTemplateOpenDialogInitialDir write FOnSetTemplateOpenDialogInitialDir;
    property OnTemplateOpenDialogExecute: TOnTemplateOpenDialogExecute write FOnTemplateOpenDialogExecute;
    property OnGetTemplateOpenDialogFileName: TOnGetTemplateOpenDialogFileName write FOnGetTemplateOpenDialogFileName;
    property OnSetTemplateSaveDialogInitialDir: TOnSetTemplateOpenDialogInitialDir write FOnSetTemplateSaveDialogInitialDir;
    property OnTemplateSaveDialogExecute: TOnTemplateOpenDialogExecute write FOnTemplateSaveDialogExecute;
    property OnGetTemplateSaveDialogFileName: TOnGetTemplateOpenDialogFileName write FOnGetTemplateSaveDialogFileName;
    property OnSetTemplateSaveDialogFileName: TOnSetTemplateOpenDialogFileName write FOnSetTemplateSaveDialogFileName;
    property OnSetPictureOpenDialogInitialDir: TOnSetPictureOpenDialogInitialDir write FOnSetPictureOpenDialogInitialDir;
    property OnPictureOpenDialogExecute: TOnPictureOpenDialogExecute write FOnPictureOpenDialogExecute;
    property OnGetPictureOpenDialogFileName: TOnGetPictureOpenDialogFileName write FOnGetPictureOpenDialogFileName;
  end;


var
  frmClickerActions: TfrmClickerActions;

implementation

{$R *.frm}


uses
  BitmapProcessing, ClickerActionsClient, ControlInteraction, MouseStuff;


const
  CExpectedFileLocation: array[Boolean] of TFileLocation = (flDisk, flMem {flDiskThenMem}); //eventually, convert this into a function and read app settings


procedure TLoggingSyncObj.DoSynchronize;
begin
  frmClickerActions.AddToLog(FMsg);
end;


procedure AddToLogFromThread(s: string);
var
  SyncObj: TLoggingSyncObj;
begin
  SyncObj := TLoggingSyncObj.Create;
  try
    SyncObj.FMsg := s;
    SyncObj.Synchronize;
  finally
    SyncObj.Free;
  end;
end;


procedure LoadBmpFromInMemFileSystem(AFileName: string; ABmp: TBitmap; AInMemFileSystem: TInMemFileSystem);
var
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  try
    AInMemFileSystem.LoadFileFromMemToStream(AFileName, MemStream);
    MemStream.Position := 0;
    ABmp.LoadFromStream(MemStream, MemStream.Size);
  finally
    MemStream.Free;
  end;
end;


procedure TfrmClickerActions.LoadSettings(AIni: TMemIniFile);
var
  i, n: Integer;
begin
  Left := AIni.ReadInteger('ActionsWindow', 'Left', Left);
  Top := AIni.ReadInteger('ActionsWindow', 'Top', Top);
  Width := AIni.ReadInteger('ActionsWindow', 'Width', Width);
  Height := AIni.ReadInteger('ActionsWindow', 'Height', Height);
  chkStayOnTop.Checked := AIni.ReadBool('ActionsWindow', 'StayOnTop', chkStayOnTop.Checked);
  ShowDeprecatedControls := AIni.ReadBool('ActionsWindow', 'ShowDeprecatedControls', False);
  PageControlMain.ActivePageIndex := AIni.ReadInteger('ActionsWindow', 'ActivePageIndex', PageControlMain.ActivePageIndex);
  frClickerActionsArrMain.chkSwitchEditorOnActionSelect.Checked := AIni.ReadBool('ActionsWindow', 'SwitchEditorOnActionSelect.Main', True);
  frClickerActionsArrExperiment1.chkSwitchEditorOnActionSelect.Checked := AIni.ReadBool('ActionsWindow', 'SwitchEditorOnActionSelect.Exp1', True);
  frClickerActionsArrExperiment2.chkSwitchEditorOnActionSelect.Checked := AIni.ReadBool('ActionsWindow', 'SwitchEditorOnActionSelect.Exp2', True);

  frClickerActionsArrMain.frClickerActions.frClickerFindControl.chkDisplayCroppingLines.Checked := AIni.ReadBool('ActionsWindow', 'DisplayCroppingLines.Main', True);
  frClickerActionsArrExperiment1.frClickerActions.frClickerFindControl.chkDisplayCroppingLines.Checked := AIni.ReadBool('ActionsWindow', 'DisplayCroppingLines.Exp1', True);
  frClickerActionsArrExperiment2.frClickerActions.frClickerFindControl.chkDisplayCroppingLines.Checked := AIni.ReadBool('ActionsWindow', 'DisplayCroppingLines.Exp2', True);

  chkDisplayActivity.Checked := AIni.ReadBool('ActionsWindow', 'DisplayActivity', chkDisplayActivity.Checked);
  lbeClientModeServerAddress.Text := AIni.ReadString('ActionsWindow', 'ClientModeServerAddress', lbeClientModeServerAddress.Text);
  lbeConnectTimeout.Text := AIni.ReadString('ActionsWindow', 'ConnectTimeout', lbeConnectTimeout.Text);
  chkSetExperimentsToClientMode.Checked := AIni.ReadBool('ActionsWindow', 'SetExperimentsToClientMode', chkSetExperimentsToClientMode.Checked);

  lbeServerModePort.Text := AIni.ReadString('ActionsWindow', 'ServerModePort', lbeServerModePort.Text);
  chkKeepAlive.Checked := AIni.ReadBool('ActionsWindow', 'KeepAlive', chkKeepAlive.Checked);
  cmbFilesExistence.ItemIndex := AIni.ReadInteger('ActionsWindow', 'FilesExistenceMode', cmbFilesExistence.ItemIndex);

  n := AIni.ReadInteger('ActionsWindow', 'AllowedFileExtensionsForServer.Count', 0);
  if n > 0 then
  begin
    memAllowedFileExtensionsForServer.Clear;
    for i := 0 to n - 1 do
      memAllowedFileExtensionsForServer.Lines.Add(AIni.ReadString('ActionsWindow', 'AllowedFileExtensionsForServer_' + IntToStr(i), '.bmp'));
  end;

  n := AIni.ReadInteger('ActionsWindow', 'AllowedFileDirsForServer.Count', 0);
  if n > 0 then
  begin
    memAllowedFileDirsForServer.Clear;
    for i := 0 to n - 1 do
      memAllowedFileDirsForServer.Lines.Add(AIni.ReadString('ActionsWindow', 'AllowedFileDirsForServer_' + IntToStr(i), ''));
  end
  else
    memAllowedFileDirsForServer.Lines.Add(ExtractFilePath(ParamStr(0)) + 'ActionTemplates');

  FullTemplatesDir := AIni.ReadString('Dirs', 'FullTemplatesDir', '$AppDir$\ActionTemplates');
  BMPsDir := AIni.ReadString('Dirs', 'BMPsDir', '');

  lbePathToTemplates.Text := StringReplace(FullTemplatesDir, ExtractFileDir(ParamStr(0)), '$AppDir$', [rfReplaceAll]);
end;


procedure TfrmClickerActions.SaveSettings(AIni: TMemIniFile);
var
  i, n: Integer;
begin
  AIni.WriteInteger('ActionsWindow', 'Left', Left);
  AIni.WriteInteger('ActionsWindow', 'Top', Top);
  AIni.WriteInteger('ActionsWindow', 'Width', Width);
  AIni.WriteInteger('ActionsWindow', 'Height', Height);
  AIni.WriteBool('ActionsWindow', 'StayOnTop', chkStayOnTop.Checked);
  AIni.WriteBool('ActionsWindow', 'ShowDeprecatedControls', ShowDeprecatedControls);
  AIni.WriteInteger('ActionsWindow', 'ActivePageIndex', PageControlMain.ActivePageIndex);

  AIni.WriteBool('ActionsWindow', 'SwitchEditorOnActionSelect.Main', frClickerActionsArrMain.chkSwitchEditorOnActionSelect.Checked);
  AIni.WriteBool('ActionsWindow', 'SwitchEditorOnActionSelect.Exp1', frClickerActionsArrExperiment1.chkSwitchEditorOnActionSelect.Checked);
  AIni.WriteBool('ActionsWindow', 'SwitchEditorOnActionSelect.Exp2', frClickerActionsArrExperiment2.chkSwitchEditorOnActionSelect.Checked);

  AIni.WriteBool('ActionsWindow', 'DisplayCroppingLines.Main', frClickerActionsArrMain.frClickerActions.frClickerFindControl.chkDisplayCroppingLines.Checked);
  AIni.WriteBool('ActionsWindow', 'DisplayCroppingLines.Exp1', frClickerActionsArrExperiment1.frClickerActions.frClickerFindControl.chkDisplayCroppingLines.Checked);
  AIni.WriteBool('ActionsWindow', 'DisplayCroppingLines.Exp2', frClickerActionsArrExperiment2.frClickerActions.frClickerFindControl.chkDisplayCroppingLines.Checked);

  AIni.WriteBool('ActionsWindow', 'DisplayActivity', chkDisplayActivity.Checked);
  AIni.WriteString('ActionsWindow', 'ClientModeServerAddress', lbeClientModeServerAddress.Text);
  AIni.WriteString('ActionsWindow', 'ConnectTimeout', lbeConnectTimeout.Text);
  AIni.WriteBool('ActionsWindow', 'SetExperimentsToClientMode', chkSetExperimentsToClientMode.Checked);

  AIni.WriteString('ActionsWindow', 'ServerModePort', lbeServerModePort.Text);
  AIni.WriteBool('ActionsWindow', 'KeepAlive', chkKeepAlive.Checked);
  AIni.WriteInteger('ActionsWindow', 'FilesExistenceMode', cmbFilesExistence.ItemIndex);

  n := memAllowedFileExtensionsForServer.Lines.Count;
  AIni.WriteInteger('ActionsWindow', 'AllowedFileExtensionsForServer.Count', n);

  for i := 0 to n - 1 do
    AIni.WriteString('ActionsWindow', 'AllowedFileExtensionsForServer_' + IntToStr(i), memAllowedFileExtensionsForServer.Lines.Strings[i]);

  n := memAllowedFileDirsForServer.Lines.Count;
  AIni.WriteInteger('ActionsWindow', 'AllowedFileDirsForServer.Count', n);

  for i := 0 to n - 1 do
    AIni.WriteString('ActionsWindow', 'AllowedFileDirsForServer_' + IntToStr(i), memAllowedFileDirsForServer.Lines.Strings[i]);

  AIni.WriteString('Dirs', 'BMPsDir', BMPsDir);
  AIni.WriteString('Dirs', 'FullTemplatesDir', StringReplace(FullTemplatesDir, ExtractFileDir(ParamStr(0)), '$AppDir$', [rfReplaceAll]));
end;


procedure TfrmClickerActions.AddToLog(s: string);
begin
  frClickerActionsArrMain.memLogErr.Lines.Add(DateTimeToStr(Now) + '  ' + s);
end;


procedure TfrmClickerActions.CreateRemainingUIComponents;
var
  MenuItem: TMenuItem;
begin
  frClickerActionsArrExperiment1 := TfrClickerActionsArr.Create(Self);
  frClickerActionsArrExperiment1.Name := 'frClickerActionsArrExp1';
  frClickerActionsArrExperiment1.Parent := TabSheetExperiments1;
  frClickerActionsArrExperiment1.Left := 4;
  frClickerActionsArrExperiment1.Top := 12;
  frClickerActionsArrExperiment1.Width := TabSheetExperiments1.Width - 8;
  frClickerActionsArrExperiment1.Height := TabSheetExperiments1.Height - 10;
  frClickerActionsArrExperiment1.TabOrder := 0;
  frClickerActionsArrExperiment1.TabStop := True;
  frClickerActionsArrExperiment1.StackLevel := 0;

  frClickerActionsArrExperiment2 := TfrClickerActionsArr.Create(Self);
  frClickerActionsArrExperiment2.Name := 'frClickerActionsArrExp2';
  frClickerActionsArrExperiment2.Parent := TabSheetExperiments2;
  frClickerActionsArrExperiment2.Left := 4;
  frClickerActionsArrExperiment2.Top := 12;
  frClickerActionsArrExperiment2.Width := frClickerActionsArrExperiment1.Width;
  frClickerActionsArrExperiment2.Height := frClickerActionsArrExperiment1.Height;
  frClickerActionsArrExperiment2.TabOrder := 0;
  frClickerActionsArrExperiment2.TabStop := True;
  frClickerActionsArrExperiment2.StackLevel := 0;

  lblExp1.Free;
  lblExp2.Free;

  FControlPlayerPopup := TPopupMenu.Create(Self);

  MenuItem := TMenuItem.Create(FControlPlayerPopup);
  MenuItem.Caption := 'Open current template as experiment 1';
  MenuItem.Name := 'MenuItemOpenTemplateAsExp1';
  MenuItem.OnClick := MenuItemOpenTemplateAsExp1Click;
  FControlPlayerPopup.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(FControlPlayerPopup);
  MenuItem.Caption := 'Open current template as experiment 2';
  MenuItem.Name := 'MenuItemOpenTemplateAsExp2';
  MenuItem.OnClick := MenuItemOpenTemplateAsExp2Click;
  FControlPlayerPopup.Items.Add(MenuItem);

  PageControlPlayer.PopupMenu := FControlPlayerPopup;

  FControlPlayerPopup := TPopupMenu.Create(Self); //dummy menu, to prevent displaying the above menu all over the frame
  TabSheetExecMainPlayer.PopupMenu := FControlPlayerPopup;
end;


procedure TfrmClickerActions.FormCreate(Sender: TObject);
var
  OSVerNumber, OSVerStr: string;
  hmod: THandle;
  AdminStatus: string;
begin
  CreateRemainingUIComponents;

  AdminStatus := GetIsUserAnAdmin;
  Caption := Caption + AdminStatus;
  lblAdminStatus.Caption := AdminStatus;
  lblAdminStatus.Show;

  FBMPsDir := '';
  FFullTemplatesDir := 'not set'; //'$AppDir$\ActionTemplates';

  FInMemFileSystem := TInMemFileSystem.Create;
  FInMemFileSystem.OnComputeInMemFileHash := HandleOnComputeInMemFileHash;
  FFileAvailabilityFIFO := TPollingFIFO.Create;

  FOnCopyControlTextAndClassFromMainWindow := nil;
  FOnRecordComponent := nil;
  FOnGetCurrentlyRecordedScreenShotImage := nil;
  FOnLoadBitmap := nil;

  FOnFileExists := nil;
  FOnTClkIniReadonlyFileCreate := nil;
  FOnSaveTemplateToFile := nil;
  FOnSetTemplateOpenDialogInitialDir := nil;
  FOnTemplateOpenDialogExecute := nil;
  FOnGetTemplateOpenDialogFileName := nil;
  FOnSetTemplateSaveDialogInitialDir := nil;
  FOnTemplateSaveDialogExecute := nil;
  FOnGetTemplateSaveDialogFileName := nil;
  FOnSetTemplateSaveDialogFileName := nil;
  FOnSetPictureOpenDialogInitialDir := nil;
  FOnPictureOpenDialogExecute := nil;
  FOnGetPictureOpenDialogFileName := nil;

  FStopAllActionsOnDemand := False;
  PageControlMain.ActivePageIndex := 0;
  PageControlExecMode.ActivePageIndex := 0;

  frClickerActionsArrMain := TfrClickerActionsArr.Create(Self);
  frClickerActionsArrMain.Parent := scrboxMain;
  scrboxMain.Tag := PtrInt(frClickerActionsArrMain);
  frClickerActionsArrMain.Left := 0;
  frClickerActionsArrMain.Top := 0;
  frClickerActionsArrMain.Width := scrboxMain.Width - 4;
  frClickerActionsArrMain.Height := scrboxMain.Height;
  frClickerActionsArrMain.Constraints.MinWidth := frClickerActionsArrMain.Width;
  frClickerActionsArrMain.Constraints.MinHeight := frClickerActionsArrMain.Height;
  frClickerActionsArrMain.Anchors := [akLeft, akTop, akRight, akBottom];
  frClickerActionsArrMain.StackLevel := 0;

  frClickerActionsArrMain.PopupMenu := nil;
  frClickerActionsArrExperiment1.PopupMenu := nil;
  frClickerActionsArrExperiment2.PopupMenu := nil;

  frClickerActionsArrExperiment1.InitFrame;
  frClickerActionsArrExperiment2.InitFrame;
  frClickerActionsArrMain.InitFrame;

  memVariables.Lines.Add('$Screen_Width$=' + IntToStr(Screen.Width));
  memVariables.Lines.Add('$Screen_Height$=' + IntToStr(Screen.Height));
  memVariables.Lines.Add('$Desktop_Width$=' + IntToStr(Screen.DesktopWidth));
  memVariables.Lines.Add('$Desktop_Height$=' + IntToStr(Screen.DesktopHeight));

  memVariables.Lines.Add('$Color_Highlight$=' + IntToHex(GetSysColor(COLOR_HIGHLIGHT), 6));
  memVariables.Lines.Add('$Color_BtnFace$=' + IntToHex(GetSysColor(COLOR_BTNFACE), 6));
  memVariables.Lines.Add('$Color_ActiveCaption$=' + IntToHex(GetSysColor(COLOR_ACTIVECAPTION), 6));
  memVariables.Lines.Add('$Color_InactiveCaption$=' + IntToHex(GetSysColor(COLOR_INACTIVECAPTION), 6));
  memVariables.Lines.Add('$Color_Window$=' + IntToHex(GetSysColor(COLOR_WINDOW), 6));
  memVariables.Lines.Add('$Color_WindowText$=' + IntToHex(GetSysColor(COLOR_WINDOWTEXT), 6));
  memVariables.Lines.Add('$Color_GrayText$=' + IntToHex(GetSysColor(COLOR_GRAYTEXT), 6));
  memVariables.Lines.Add('$Color_GradientActiveCaption$=' + IntToHex(GetSysColor(COLOR_GRADIENTACTIVECAPTION), 6));
  memVariables.Lines.Add('$Color_GradientInactiveCaption$=' + IntToHex(GetSysColor(COLOR_GRADIENTINACTIVECAPTION), 6));
  memVariables.Lines.Add('$Color_ScrollBar$=' + IntToHex(GetSysColor(COLOR_SCROLLBAR), 6));
  memVariables.Lines.Add('$Color_3DDkShadow$=' + IntToHex(GetSysColor(COLOR_3DDKSHADOW), 6));
  memVariables.Lines.Add('$Color_3DLight$=' + IntToHex(GetSysColor(COLOR_3DLIGHT), 6));
  memVariables.Lines.Add('$Color_WindowFrame$=' + IntToHex(GetSysColor(COLOR_WINDOWFRAME), 6));

  //See MS docs for how to read Win32MajorVersion. It's not very reliable.
  OSVerNumber := IntToStr(Win32MajorVersion) + '.' + IntToStr(Win32MinorVersion) + '.' + IntToStr(Win32BuildNumber);
  OSVerStr := 'Unknown';

  hmod := LoadLibraryEx(PChar(ParamStr(0)), 0, LOAD_LIBRARY_AS_DATAFILE);
  try
    if (hmod <> 0) and (FindResource(hmod, MakeIntResource(1), RT_MANIFEST) > 0) then
    begin
      //has manifest
      if (Win32MajorVersion = 6) and (Win32MinorVersion = 3) then
        OSVerStr := 'Win8.1';

      if (Win32MajorVersion = 6) and (Win32MinorVersion = 2) then
        OSVerStr := 'Win8';

      if (Win32MajorVersion = 10) {and (Win32MinorVersion = 2)} then
        OSVerStr := 'Win11';

      if (Win32MajorVersion = 10) {and (Win32MinorVersion = 2)} then
        OSVerStr := 'Win10';
    end
    else
    begin
      if (Win32MajorVersion = 6) and (Win32MinorVersion = 2) then
        OSVerStr := 'Win8.1';  //or Win8 or 10  //returning Win8.1 as it may be found more often
    end;

    if (Win32MajorVersion = 6) and (Win32MinorVersion = 1) then
      OSVerStr := 'Win7';

    if (Win32MajorVersion = 6) and (Win32MinorVersion = 0) then
      OSVerStr := 'WinVista';

    if (Win32MajorVersion = 5) and ((Win32MinorVersion = 1) or (Win32MinorVersion = 2)) then
      OSVerStr := 'WinXP';
  finally
    FreeLibrary(hmod);
  end;

  memVariables.Lines.Add('$OSVerNumber$=' + OSVerNumber);
  memVariables.Lines.Add('$OSVer$=' + OSVerStr);

  frClickerActionsArrExperiment1.SetVariables(memVariables.Lines);
  frClickerActionsArrExperiment2.SetVariables(memVariables.Lines);
  frClickerActionsArrMain.SetVariables(memVariables.Lines);

  frClickerActionsArrExperiment1.OnCallTemplate := nil;
  frClickerActionsArrExperiment2.OnCallTemplate := nil;
  frClickerActionsArrMain.OnCallTemplate := frClickerActionsArrOnCallTemplate;

  frClickerActionsArrExperiment1.InMemFS := FInMemFileSystem;
  frClickerActionsArrExperiment2.InMemFS := FInMemFileSystem;
  frClickerActionsArrMain.InMemFS := FInMemFileSystem;

  frClickerActionsArrExperiment1.OnExecuteRemoteActionAtIndex := nil;
  frClickerActionsArrExperiment2.OnExecuteRemoteActionAtIndex := nil;
  //frClickerActionsArrMain.OnExecuteRemoteActionAtIndex := frClickerActionsArrOnExecuteRemoteActionAtIndex;

  frClickerActionsArrExperiment1.frClickerActions.PredefinedVarCount := memVariables.Lines.Count;
  frClickerActionsArrExperiment2.frClickerActions.PredefinedVarCount := memVariables.Lines.Count;
  frClickerActionsArrMain.frClickerActions.PredefinedVarCount := memVariables.Lines.Count;

  frClickerActionsArrExperiment1.frClickerActions.PasteDebugValuesListFromMainExecutionList1.Enabled := True;
  frClickerActionsArrExperiment2.frClickerActions.PasteDebugValuesListFromMainExecutionList1.Enabled := True;

  frClickerActionsArrExperiment1.StopAllActionsOnDemandFromParent := nil;
  frClickerActionsArrExperiment2.StopAllActionsOnDemandFromParent := nil;
  frClickerActionsArrMain.StopAllActionsOnDemandFromParent := @FStopAllActionsOnDemand;

  frClickerActionsArrMain.OnCopyControlTextAndClassFromMainWindow := HandleOnCopyControlTextAndClassFromMainWindow;
  frClickerActionsArrMain.OnGetExtraSearchAreaDebuggingImageWithStackLevel := HandleOnGetExtraSearchAreaDebuggingImageWithStackLevel;
  frClickerActionsArrMain.OnWaitForFileAvailability := HandleOnWaitForFileAvailability;
  frClickerActionsArrMain.OnWaitForMultipleFilesAvailability := HandleOnWaitForMultipleFilesAvailability;
  frClickerActionsArrMain.OnWaitForBitmapsAvailability := HandleOnWaitForBitmapsAvailability;
  frClickerActionsArrMain.OnLoadBitmap := HandleOnLoadBitmap;
  frClickerActionsArrMain.OnFileExists := HandleOnFileExists;
  frClickerActionsArrMain.OnTClkIniReadonlyFileCreate := HandleOnTClkIniReadonlyFileCreate;
  frClickerActionsArrMain.OnSaveTemplateToFile := HandleOnSaveTemplateToFile;
  frClickerActionsArrMain.OnSetTemplateOpenDialogInitialDir := HandleOnSetTemplateOpenDialogInitialDir;
  frClickerActionsArrMain.OnTemplateOpenDialogExecute := HandleOnTemplateOpenDialogExecute;
  frClickerActionsArrMain.OnGetTemplateOpenDialogFileName := HandleOnGetTemplateOpenDialogFileName;
  frClickerActionsArrMain.OnSetTemplateSaveDialogInitialDir := HandleOnSetTemplateSaveDialogInitialDir;
  frClickerActionsArrMain.OnTemplateSaveDialogExecute := HandleOnTemplateSaveDialogExecute;
  frClickerActionsArrMain.OnGetTemplateSaveDialogFileName := HandleOnGetTemplateSaveDialogFileName;
  frClickerActionsArrMain.OnSetTemplateSaveDialogFileName := HandleOnSetTemplateSaveDialogFileName;
  frClickerActionsArrMain.OnSetPictureOpenDialogInitialDir := HandleOnSetPictureOpenDialogInitialDir;
  frClickerActionsArrMain.OnPictureOpenDialogExecute := HandleOnPictureOpenDialogExecute;
  frClickerActionsArrMain.OnGetPictureOpenDialogFileName := HandleOnGetPictureOpenDialogFileName;

  frClickerActionsArrExperiment1.frClickerActions.frClickerFindControl.lbeColorError.Hint := StringReplace(frClickerActionsArrExperiment1.frClickerActions.frClickerFindControl.lbeColorError.Hint, '. ', '.'#13#10, [rfReplaceAll]);
  frClickerActionsArrExperiment2.frClickerActions.frClickerFindControl.lbeColorError.Hint := StringReplace(frClickerActionsArrExperiment2.frClickerActions.frClickerFindControl.lbeColorError.Hint, '. ', '.'#13#10, [rfReplaceAll]);
  frClickerActionsArrExperiment1.frClickerActions.frClickerFindControl.lbeAllowedColorErrorCount.Hint := StringReplace(frClickerActionsArrExperiment1.frClickerActions.frClickerFindControl.lbeAllowedColorErrorCount.Hint, '. ', '.'#13#10, [rfReplaceAll]);
  frClickerActionsArrExperiment2.frClickerActions.frClickerFindControl.lbeAllowedColorErrorCount.Hint := StringReplace(frClickerActionsArrExperiment2.frClickerActions.frClickerFindControl.lbeAllowedColorErrorCount.Hint, '. ', '.'#13#10, [rfReplaceAll]);
  frClickerActionsArrMain.frClickerActions.frClickerFindControl.lbeColorError.Hint := StringReplace(frClickerActionsArrMain.frClickerActions.frClickerFindControl.lbeColorError.Hint, '. ', '.'#13#10, [rfReplaceAll]);
  frClickerActionsArrMain.frClickerActions.frClickerFindControl.lbeAllowedColorErrorCount.Hint := StringReplace(frClickerActionsArrMain.frClickerActions.frClickerFindControl.lbeAllowedColorErrorCount.Hint, '. ', '.'#13#10, [rfReplaceAll]);

  frClickerActionsArrExperiment1.frClickerActions.PasteDebugValuesListFromMainExecutionList1.OnClick := frClickerActionsArrExperiment1PasteDebugValuesListFromMainExecutionList1Click;
  frClickerActionsArrExperiment2.frClickerActions.PasteDebugValuesListFromMainExecutionList1.OnClick := frClickerActionsArrExperiment2PasteDebugValuesListFromMainExecutionList1Click;
  frClickerActionsArrExperiment1.OnCopyControlTextAndClassFromMainWindow := HandleOnCopyControlTextAndClassFromMainWindow;
  frClickerActionsArrExperiment2.OnCopyControlTextAndClassFromMainWindow := HandleOnCopyControlTextAndClassFromMainWindow;
  frClickerActionsArrExperiment1.OnGetExtraSearchAreaDebuggingImageWithStackLevel := HandleOnGetExtraSearchAreaDebuggingImageWithStackLevel;
  frClickerActionsArrExperiment2.OnGetExtraSearchAreaDebuggingImageWithStackLevel := HandleOnGetExtraSearchAreaDebuggingImageWithStackLevel;

  frClickerActionsArrExperiment1.OnWaitForFileAvailability := HandleOnWaitForFileAvailability;
  frClickerActionsArrExperiment2.OnWaitForFileAvailability := HandleOnWaitForFileAvailability;
  frClickerActionsArrExperiment1.OnWaitForMultipleFilesAvailability := HandleOnWaitForMultipleFilesAvailability;
  frClickerActionsArrExperiment2.OnWaitForMultipleFilesAvailability := HandleOnWaitForMultipleFilesAvailability;
  frClickerActionsArrExperiment1.OnWaitForBitmapsAvailability := HandleOnWaitForBitmapsAvailability;
  frClickerActionsArrExperiment2.OnWaitForBitmapsAvailability := HandleOnWaitForBitmapsAvailability;
  frClickerActionsArrExperiment1.OnLoadBitmap := HandleOnLoadBitmap;
  frClickerActionsArrExperiment2.OnLoadBitmap := HandleOnLoadBitmap;
  frClickerActionsArrExperiment1.OnFileExists := HandleOnFileExists;
  frClickerActionsArrExperiment2.OnFileExists := HandleOnFileExists;
  frClickerActionsArrExperiment1.OnTClkIniReadonlyFileCreate := HandleOnTClkIniReadonlyFileCreate;
  frClickerActionsArrExperiment2.OnTClkIniReadonlyFileCreate := HandleOnTClkIniReadonlyFileCreate;
  frClickerActionsArrExperiment1.OnSaveTemplateToFile := HandleOnSaveTemplateToFile;
  frClickerActionsArrExperiment2.OnSaveTemplateToFile := HandleOnSaveTemplateToFile;
  frClickerActionsArrExperiment1.OnSetTemplateOpenDialogInitialDir := HandleOnSetTemplateOpenDialogInitialDir;
  frClickerActionsArrExperiment2.OnSetTemplateOpenDialogInitialDir := HandleOnSetTemplateOpenDialogInitialDir;
  frClickerActionsArrExperiment1.OnTemplateOpenDialogExecute := HandleOnTemplateOpenDialogExecute;
  frClickerActionsArrExperiment2.OnTemplateOpenDialogExecute := HandleOnTemplateOpenDialogExecute;
  frClickerActionsArrExperiment1.OnGetTemplateOpenDialogFileName := HandleOnGetTemplateOpenDialogFileName;
  frClickerActionsArrExperiment2.OnGetTemplateOpenDialogFileName := HandleOnGetTemplateOpenDialogFileName;
  frClickerActionsArrExperiment1.OnSetTemplateSaveDialogInitialDir := HandleOnSetTemplateSaveDialogInitialDir;
  frClickerActionsArrExperiment2.OnSetTemplateSaveDialogInitialDir := HandleOnSetTemplateSaveDialogInitialDir;
  frClickerActionsArrExperiment1.OnTemplateSaveDialogExecute := HandleOnTemplateSaveDialogExecute;
  frClickerActionsArrExperiment2.OnTemplateSaveDialogExecute := HandleOnTemplateSaveDialogExecute;
  frClickerActionsArrExperiment1.OnGetTemplateSaveDialogFileName := HandleOnGetTemplateSaveDialogFileName;
  frClickerActionsArrExperiment2.OnGetTemplateSaveDialogFileName := HandleOnGetTemplateSaveDialogFileName;
  frClickerActionsArrExperiment1.OnSetTemplateSaveDialogFileName := HandleOnSetTemplateSaveDialogFileName;
  frClickerActionsArrExperiment2.OnSetTemplateSaveDialogFileName := HandleOnSetTemplateSaveDialogFileName;
  frClickerActionsArrExperiment1.OnSetPictureOpenDialogInitialDir := HandleOnSetPictureOpenDialogInitialDir;
  frClickerActionsArrExperiment2.OnSetPictureOpenDialogInitialDir := HandleOnSetPictureOpenDialogInitialDir;
  frClickerActionsArrExperiment1.OnPictureOpenDialogExecute := HandleOnPictureOpenDialogExecute;
  frClickerActionsArrExperiment2.OnPictureOpenDialogExecute := HandleOnPictureOpenDialogExecute;
  frClickerActionsArrExperiment1.OnGetPictureOpenDialogFileName := HandleOnGetPictureOpenDialogFileName;
  frClickerActionsArrExperiment2.OnGetPictureOpenDialogFileName := HandleOnGetPictureOpenDialogFileName;

  tmrStartup.Enabled := True;
end;


procedure TfrmClickerActions.FormDestroy(Sender: TObject);
var
  tk: QWord;
begin
  GeneralClosingApp := True;  //prevent waiting for response loops to keep going

  try
    if IdHTTPServer1.Active then
    begin
      IdHTTPServer1.Active := False;

      tk := GetTickCount64;
      repeat
        Application.ProcessMessages;
        Sleep(1);
      until GetTickCount64 - tk > 1000;
    end;
  except
  end;

  try
    if FPollForMissingServerFiles <> nil then
    begin
      FPollForMissingServerFiles.Terminate;
      tk := GetTickCount64;
      repeat
        if FPollForMissingServerFiles.Done then    //client mode
          Break;

        Application.ProcessMessages;
        Sleep(1);
      until GetTickCount64 - tk > 2000;

      FPollForMissingServerFiles.Free;
    end;
  except
  end;

  FreeAndNil(FFileAvailabilityFIFO); //destroy the FIFO before the in-mem filesystem
  FreeAndNil(FInMemFileSystem);

  try
    frClickerActionsArrMain.frClickerActions.frClickerConditionEditor.ClearActionConditionPreview;
    frClickerActionsArrExperiment1.frClickerActions.frClickerConditionEditor.ClearActionConditionPreview;
    frClickerActionsArrExperiment2.frClickerActions.frClickerConditionEditor.ClearActionConditionPreview;
  finally
    FreeAndNil(frClickerActionsArrMain);
  end;
end;


procedure TfrmClickerActions.DoOnRecordComponent(ACompHandle: THandle; ATreeContentStream: TMemoryStream);
begin
  if Assigned(FOnRecordComponent) then
    FOnRecordComponent(ACompHandle, ATreeContentStream)
  else
    raise Exception.Create('OnRecordComponent not assigned.');
end;


procedure TfrmClickerActions.DoOnGetCurrentlyRecordedScreenShotImage(ABmp: TBitmap);
begin
  if Assigned(FOnGetCurrentlyRecordedScreenShotImage) then
    FOnGetCurrentlyRecordedScreenShotImage(ABmp)
  else
    raise Exception.Create('OnGetCurrentlyRecordedScreenShotImage not assigned.');
end;


function TfrmClickerActions.DoLoadBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
begin
  if Assigned(FOnLoadBitmap) then
    Result := FOnLoadBitmap(ABitmap, AFileName)
  else
    Result := False;
end;


function TfrmClickerActions.DoOnFileExists(const AFileName: string): Boolean;
begin
  if not Assigned(FOnFileExists) then
    raise Exception.Create('OnFileExists is not assigned.')
  else
    Result := FOnFileExists(AFileName);
end;


function TfrmClickerActions.DoOnTClkIniReadonlyFileCreate(AFileName: string): TClkIniReadonlyFile;
begin
  if not Assigned(FOnTClkIniReadonlyFileCreate) then
    raise Exception.Create('OnTClkIniReadonlyFileCreate is not assigned.')
  else
    Result := FOnTClkIniReadonlyFileCreate(AFileName);
end;


procedure TfrmClickerActions.DoOnSaveTemplateToFile(AStringList: TStringList; const AFileName: string);
begin
  if not Assigned(FOnSaveTemplateToFile) then
    raise Exception.Create('OnSaveTemplateToFile is not assigned.')
  else
    FOnSaveTemplateToFile(AStringList, AFileName);
end;


procedure TfrmClickerActions.DoOnSetTemplateOpenDialogInitialDir(AInitialDir: string);
begin
  if not Assigned(FOnSetTemplateOpenDialogInitialDir) then
    raise Exception.Create('OnSetTemplateOpenDialogInitialDir is not assigned.')
  else
    FOnSetTemplateOpenDialogInitialDir(AInitialDir);
end;


function TfrmClickerActions.DoOnTemplateOpenDialogExecute: Boolean;
begin
  if not Assigned(FOnTemplateOpenDialogExecute) then
    raise Exception.Create('OnTemplateOpenDialogExecute is not assigned.')
  else
    Result := FOnTemplateOpenDialogExecute;
end;


function TfrmClickerActions.DoOnGetTemplateOpenDialogFileName: string;
begin
  if not Assigned(FOnGetTemplateOpenDialogFileName) then
    raise Exception.Create('OnGetTemplateOpenDialogFileName is not assigned.')
  else
    Result := FOnGetTemplateOpenDialogFileName;
end;


procedure TfrmClickerActions.DoOnSetTemplateSaveDialogInitialDir(AInitialDir: string);
begin
  if not Assigned(FOnSetTemplateSaveDialogInitialDir) then
    raise Exception.Create('OnSetTemplateSaveDialogInitialDir is not assigned.')
  else
    FOnSetTemplateSaveDialogInitialDir(AInitialDir);
end;


function TfrmClickerActions.DoOnTemplateSaveDialogExecute: Boolean;
begin
  if not Assigned(FOnTemplateSaveDialogExecute) then
    raise Exception.Create('OnTemplateSaveDialogExecute is not assigned.')
  else
    Result := FOnTemplateSaveDialogExecute;
end;


function TfrmClickerActions.DoOnGetTemplateSaveDialogFileName: string;
begin
  if not Assigned(FOnGetTemplateSaveDialogFileName) then
    raise Exception.Create('OnGetTemplateSaveDialogFileName is not assigned.')
  else
    Result := FOnGetTemplateSaveDialogFileName;
end;


procedure TfrmClickerActions.DoOnSetTemplateSaveDialogFileName(AFileName: string);
begin
  if not Assigned(FOnSetTemplateSaveDialogFileName) then
    raise Exception.Create('OnSetTemplateSaveDialogFileName is not assigned.')
  else
    FOnSetTemplateSaveDialogFileName(AFileName);
end;


procedure TfrmClickerActions.DoOnSetPictureOpenDialogInitialDir(AInitialDir: string);
begin
  if not Assigned(FOnSetPictureOpenDialogInitialDir) then
    raise Exception.Create('OnSetPictureOpenDialogInitialDir not assigned.')
  else
    FOnSetPictureOpenDialogInitialDir(AInitialDir);
end;


function TfrmClickerActions.DoOnPictureOpenDialogExecute: Boolean;
begin
  if not Assigned(FOnPictureOpenDialogExecute) then
    raise Exception.Create('OnPictureOpenDialogExecute not assigned.')
  else
    Result := FOnPictureOpenDialogExecute;
end;


function TfrmClickerActions.DoOnGetPictureOpenDialogFileName: string;
begin
  if not Assigned(FOnGetPictureOpenDialogFileName) then
    raise Exception.Create('OnGetPictureOpenDialogFileName not assigned.')
  else
    Result := FOnGetPictureOpenDialogFileName;
end;


function TfrmClickerActions.GetClickerActionsArrFrameByStackLevel(AStackLevel: Integer): TfrClickerActionsArr;
var
  i: Integer;
  ATab: TTabSheet;
  AScr: TScrollBox;
begin
  Result := nil;

  if AStackLevel = 0 then
  begin
    Result := frClickerActionsArrMain; //from scrboxMain
    Exit;
  end;

  ATab := PageControlPlayer.Pages[AStackLevel];

  AScr := nil;
  for i := 0 to ATab.ComponentCount - 1 do
    if ATab.Components[i] is TScrollBox then
    begin
      AScr := ATab.Components[i] as TScrollBox;
      Result := TfrClickerActionsArr(AScr.Tag);
      Break;
    end;
end;


procedure TfrmClickerActions.MenuItemOpenTemplateAsExp1Click(Sender: TObject);
var
  TemplatePath: string;
  TempStream: TMemoryStream;
  CurrentFrame: TfrClickerActionsArr;
begin
  if frClickerActionsArrMain.FileName = '' then
  begin
    MessageBox(Handle, 'No template is loaded.', PChar(Caption), MB_ICONINFORMATION);
    Exit;
  end;

  if frClickerActionsArrExperiment1.FileName <> '' then
    if MessageBox(Handle, 'There is a template already loaded. Continue?', PChar(Caption), MB_ICONQUESTION + MB_YESNO) = IDNO then
      Exit;

  TemplatePath := StringReplace(lbePathToTemplates.Text, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]) + '\';

  if PageControlPlayer.ActivePageIndex = 0 then
  begin
    if ExtractFileName(frClickerActionsArrMain.FileName) = frClickerActionsArrMain.FileName then
      frClickerActionsArrExperiment1.LoadTemplate(TemplatePath + frClickerActionsArrMain.FileName)
    else
      frClickerActionsArrExperiment1.LoadTemplate(frClickerActionsArrMain.FileName);
  end
  else
  begin
    CurrentFrame := GetClickerActionsArrFrameByStackLevel(PageControlPlayer.ActivePageIndex);
    if CurrentFrame <> nil then
      frClickerActionsArrExperiment1.LoadTemplate(CurrentFrame.FileName);
  end;

  PageControlMain.ActivePageIndex := 2;

  TempStream := TMemoryStream.Create;
  try
    frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.SaveToStream(TempStream);
    TempStream.Position := 0;
    frClickerActionsArrExperiment1.frClickerActions.vallstVariables.Strings.LoadFromStream(TempStream);
  finally
    TempStream.Free;
  end;
end;


procedure TfrmClickerActions.MenuItemOpenTemplateAsExp2Click(Sender: TObject);
var
  TemplatePath: string;
  TempStream: TMemoryStream;
  CurrentFrame: TfrClickerActionsArr;
begin
  if frClickerActionsArrMain.FileName = '' then
  begin
    MessageBox(Handle, 'No template is loaded.', PChar(Caption), MB_ICONINFORMATION);
    Exit;
  end;

  if frClickerActionsArrExperiment2.FileName <> '' then
    if MessageBox(Handle, 'There is a template already loaded. Continue?', PChar(Caption), MB_ICONQUESTION + MB_YESNO) = IDNO then
      Exit;

  TemplatePath := StringReplace(lbePathToTemplates.Text, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]) + '\';

  if PageControlPlayer.ActivePageIndex = 0 then
    begin
    if ExtractFileName(frClickerActionsArrMain.FileName) = frClickerActionsArrMain.FileName then
      frClickerActionsArrExperiment2.LoadTemplate(TemplatePath + frClickerActionsArrMain.FileName)
    else
      frClickerActionsArrExperiment2.LoadTemplate(frClickerActionsArrMain.FileName);
  end
  else
  begin
    CurrentFrame := GetClickerActionsArrFrameByStackLevel(PageControlPlayer.ActivePageIndex);
    if CurrentFrame <> nil then
      frClickerActionsArrExperiment2.LoadTemplate(CurrentFrame.FileName);
  end;

  PageControlMain.ActivePageIndex := 3;

  TempStream := TMemoryStream.Create;
  try
    frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.SaveToStream(TempStream);
    TempStream.Position := 0;
    frClickerActionsArrExperiment2.frClickerActions.vallstVariables.Strings.LoadFromStream(TempStream);
  finally
    TempStream.Free;
  end;
end;


procedure TfrmClickerActions.HandleNewFrameRefreshButton(Sender: TObject);
var
  NewFrame: TfrClickerActionsArr;
begin
  NewFrame := TfrClickerActionsArr((Sender as TButton).Tag);
  NewFrame.Repaint;
end;


function TfrmClickerActions.frClickerActionsArrOnCallTemplate(Sender: TObject; AFileNameToCall: string; ListOfVariables: TStrings; DebugBitmap: TBitmap; DebugGridImage: TImage; IsDebugging: Boolean; AStackLevel: Integer; AExecutesRemotely: Boolean): Boolean;
var
  NewTabSheet: TTabSheet;
  NewFrame: TfrClickerActionsArr;
  ScrBox: TScrollBox;
  ABtn: TButton;
  FileLoc: TFileLocation;
begin
  NewTabSheet := TTabSheet.Create(PageControlPlayer);
  try
    NewTabSheet.Caption := ExtractFileName(AFileNameToCall);
    NewTabSheet.PageControl := PageControlPlayer;
    NewTabSheet.PageIndex := PageControlPlayer.PageCount - 1;
    NewTabSheet.ImageIndex := 0;

    ABtn := TButton.Create(NewTabSheet);
    ABtn.Parent := NewTabSheet;
    ABtn.Left := 80;
    ABtn.Top := 80;
    ABtn.Width := 50;
    ABtn.Height := 60;
    ABtn.Caption := 'Refresh';
    ABtn.OnClick := HandleNewFrameRefreshButton;
    ABtn.Show;

    ScrBox := TScrollBox.Create(NewTabSheet {Self}); //using NewTabSheet, to allow finding the scrollbox
    try
      ScrBox.Parent := NewTabSheet;
      ScrBox.Left := 0;
      ScrBox.Top := 0;
      ScrBox.Width := NewTabSheet.Width;
      ScrBox.Height := NewTabSheet.Height;

      ScrBox.HorzScrollBar.Smooth := True;
      ScrBox.HorzScrollBar.Tracking := True;
      ScrBox.VertScrollBar.Smooth := True;
      ScrBox.VertScrollBar.Tracking := True;

      ScrBox.Anchors := [akLeft, akTop, akRight, akBottom];

      NewFrame := TfrClickerActionsArr.Create(nil);
      try
        ScrBox.Tag := PtrInt(NewFrame);
        NewFrame.Parent := ScrBox;
        NewFrame.Left := 0;
        NewFrame.Top := 0;
        NewFrame.Width := frClickerActionsArrMain.Width;
        NewFrame.Height := frClickerActionsArrMain.Height;

        ABtn.Tag := PtrInt(NewFrame);

        //NewFrame.frClickerActions.vallstVariables.FixedCols := 1;
        NewFrame.frClickerActions.vallstVariables.ColWidths[1] := 130;
        //NewFrame.frClickerActions.vallstVariables.ColWidths[0] := 120;

        NewFrame.StackLevel := AStackLevel + 1;
        NewFrame.ExecutesRemotely := AExecutesRemotely; //a client executes remotely
        NewFrame.ExecutingActionFromRemote := frClickerActionsArrMain.ExecutingActionFromRemote; //should be true in server mode
        NewFrame.FileLocationOfDepsIsMem := frClickerActionsArrMain.FileLocationOfDepsIsMem;
        NewFrame.FullTemplatesDir := FFullTemplatesDir;
        NewFrame.ShowDeprecatedControls := frClickerActionsArrMain.ShowDeprecatedControls;
        NewFrame.RemoteAddress := frClickerActionsArrMain.RemoteAddress;
        NewFrame.InMemFS := FInMemFileSystem;

        NewFrame.OnCallTemplate := frClickerActionsArrOnCallTemplate;
        NewFrame.OnCopyControlTextAndClassFromMainWindow := HandleOnCopyControlTextAndClassFromMainWindow;
        NewFrame.OnGetExtraSearchAreaDebuggingImageWithStackLevel := HandleOnGetExtraSearchAreaDebuggingImageWithStackLevel;

        NewFrame.OnWaitForFileAvailability := HandleOnWaitForFileAvailability;
        NewFrame.OnWaitForMultipleFilesAvailability := HandleOnWaitForMultipleFilesAvailability;
        NewFrame.OnWaitForBitmapsAvailability := HandleOnWaitForBitmapsAvailability;

        NewFrame.OnLoadBitmap := HandleOnLoadBitmap;
        NewFrame.OnFileExists := HandleOnFileExists;

        NewFrame.OnTClkIniReadonlyFileCreate := HandleOnTClkIniReadonlyFileCreate;
        NewFrame.OnSaveTemplateToFile := HandleOnSaveTemplateToFile;
        NewFrame.OnSetTemplateOpenDialogInitialDir := HandleOnSetTemplateOpenDialogInitialDir;
        NewFrame.OnTemplateOpenDialogExecute := HandleOnTemplateOpenDialogExecute;
        NewFrame.OnGetTemplateOpenDialogFileName := HandleOnGetTemplateOpenDialogFileName;
        NewFrame.OnSetTemplateSaveDialogInitialDir := HandleOnSetTemplateSaveDialogInitialDir;
        NewFrame.OnTemplateSaveDialogExecute := HandleOnTemplateSaveDialogExecute;
        NewFrame.OnGetTemplateSaveDialogFileName := HandleOnGetTemplateSaveDialogFileName;
        NewFrame.OnSetTemplateSaveDialogFileName := HandleOnSetTemplateSaveDialogFileName;
        NewFrame.OnSetPictureOpenDialogInitialDir := HandleOnSetPictureOpenDialogInitialDir;
        NewFrame.OnPictureOpenDialogExecute := HandleOnPictureOpenDialogExecute;
        NewFrame.OnGetPictureOpenDialogFileName := HandleOnGetPictureOpenDialogFileName;

        PageControlPlayer.ActivePageIndex := PageControlPlayer.PageCount - 1;
        NewFrame.Show;

        FileLoc := CExpectedFileLocation[NewFrame.FileLocationOfDepsIsMem];

        if not NewFrame.ExecutingActionFromRemote then  //this is client or local mode
        begin
          if NewFrame.ExecutesRemotely then  //this is client mode
          begin
            frmClickerActions.AddToLog('[client] Detected client mode when calling template, level=' + IntToStr(AStackLevel));

            if ExtractFileName(AFileNameToCall) = AFileNameToCall then  //AFileNameToCall does not contain a path
              NewFrame.LoadTemplate(FFullTemplatesDir + '\' + AFileNameToCall{, FileLoc, FInMemFileSystem})
            else
              NewFrame.LoadTemplate(AFileNameToCall{, FileLoc, FInMemFileSystem});

            if GetServerFileExpectancy(NewFrame.RemoteAddress) = CREResp_FileExpectancy_ValueFromClient then
            begin
              frmClickerActions.AddToLog('[client] file expectancy is to send files when calling template, level=' + IntToStr(AStackLevel));

              //setting name is required, because NewFrame.LoadTemplate is not supposed to set the filename
              if ExtractFileName(AFileNameToCall) = AFileNameToCall then
                NewFrame.FileName := FFullTemplatesDir + '\' + AFileNameToCall
              else
                NewFrame.FileName := AFileNameToCall;

              NewFrame.FileName := StringReplace(NewFrame.FileName, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]);

              frmClickerActions.AddToLog('[client] Sending template (" ' + NewFrame.FileName + ' ") and other missing files to server..');
              frmClickerActions.AddToLog('[client] ' + NewFrame.SetCurrentClientTemplateInServer(True));
              frmClickerActions.AddToLog('[client] ' + NewFrame.SendMissingFilesToServer);
            end;
          end
          else
          begin  //local mode
            if ExtractFileName(AFileNameToCall) = AFileNameToCall then  //AFileNameToCall does not contain a path
            begin
              frmClickerActions.AddToLog('[local] Loading template: "' + FFullTemplatesDir + '\' + AFileNameToCall + '"  FileLoc = ' + IntToStr(Ord(FileLoc)) + '   [using default template dir]');
              NewFrame.LoadTemplate(FFullTemplatesDir + '\' + AFileNameToCall{, FileLoc, FInMemFileSystem});
            end
            else
            begin
              frmClickerActions.AddToLog('[local] Loading template: "' + AFileNameToCall + '"  FileLoc = ' + IntToStr(Ord(FileLoc)));
              NewFrame.LoadTemplate(AFileNameToCall{, FileLoc, FInMemFileSystem});
            end;
          end;
        end
        else
        begin   //server mode
          frmClickerActions.AddToLog('[server] Detected server mode when calling template, level=' + IntToStr(AStackLevel));

          //the current implementation does not allow using files from disk in server mode
          if (ExtractFileName(AFileNameToCall) = AFileNameToCall) and (FileLoc <> flMem) then  //AFileNameToCall does not contain a path
          begin
            frmClickerActions.AddToLog('[server] Loading template: "' + FFullTemplatesDir + '\' + AFileNameToCall + '"  FileLoc = ' + IntToStr(Ord(FileLoc)) + '   [using default template dir]');
            NewFrame.LoadTemplate(FFullTemplatesDir + '\' + AFileNameToCall, FileLoc, FInMemFileSystem);
          end
          else
          begin
            frmClickerActions.AddToLog('[server] Loading template: "' + AFileNameToCall + '"  FileLoc = ' + IntToStr(Ord(FileLoc)));
            NewFrame.LoadTemplate(AFileNameToCall, FileLoc, FInMemFileSystem);
          end;
        end;

        NewFrame.InitFrame; //after "LoadTemplate", before "FileName :="

        NewFrame.FileName := AFileNameToCall;   //set to AFileNameToCall, after calling InitFrame
        NewFrame.Modified := True; //trigger updating label
        NewFrame.Modified := False;
        NewFrame.StopAllActionsOnDemandFromParent := @FStopAllActionsOnDemand;

        NewFrame.spdbtnPlaySelectedAction.Enabled := False;
        NewFrame.spdbtnPlayAllActions.Enabled := False;
        NewFrame.spdbtnStopPlaying.Enabled := True;
        NewFrame.frClickerActions.PredefinedVarCount := memVariables.Lines.Count;

        if TfrClickerActionsArr(Sender).chkEnableDebuggerKeys.Checked then
          NewFrame.chkEnableDebuggerKeys.Checked := True;

        NewFrame.Repaint;
        try
          if FStopAllActionsOnDemand then
          begin
            Result := False;
            Exit;
          end;

          Result := NewFrame.PlayAllActions(AFileNameToCall, ListOfVariables, IsDebugging);
        finally
          DebugBitmap.Width := NewFrame.frClickerActions.imgDebugBmp.Picture.Bitmap.Width;
          DebugBitmap.Height := NewFrame.frClickerActions.imgDebugBmp.Picture.Bitmap.Height;

          //clear debug image first, to fix transparency
          DebugBitmap.Transparent := False;
          DebugBitmap.Canvas.Pen.Color := clWhite;
          DebugBitmap.Canvas.Brush.Color := clWhite;
          DebugBitmap.Canvas.Rectangle(0, 0, NewFrame.frClickerActions.imgDebugBmp.Width, NewFrame.frClickerActions.imgDebugBmp.Height);

          DebugBitmap.Assign(NewFrame.frClickerActions.imgDebugBmp.Picture.Bitmap); // DebugBitmap.Canvas.Draw(0, 0, NewFrame.frClickerActions.imgDebugBmp.Picture.Bitmap);    better load bmp, than drawing on it

          DebugGridImage.Left := NewFrame.frClickerActions.imgDebugGrid.Left;
          DebugGridImage.Top := NewFrame.frClickerActions.imgDebugGrid.Top;
          DebugGridImage.Width := NewFrame.frClickerActions.imgDebugGrid.Width;
          DebugGridImage.Height := NewFrame.frClickerActions.imgDebugGrid.Height;
          DebugGridImage.Picture.Bitmap.Width := DebugGridImage.Width;
          DebugGridImage.Picture.Bitmap.Height := DebugGridImage.Height;

          DebugGridImage.Canvas.Brush.Style := bsSolid;
          DebugGridImage.Canvas.Brush.Color := clWhite;
          DebugGridImage.Canvas.Pen.Color := clWhite;
          DebugGridImage.Canvas.Rectangle(0, 0, DebugGridImage.Width, DebugGridImage.Height);
          DebugGridImage.Canvas.Draw(0, 0, NewFrame.frClickerActions.imgDebugGrid.Picture.Bitmap);
          MakeImageContentTransparent(DebugGridImage);

          NewFrame.spdbtnPlaySelectedAction.Enabled := True;
          NewFrame.spdbtnPlayAllActions.Enabled := True;
          NewFrame.spdbtnStopPlaying.Enabled := False;
        end;

        NewFrame.frClickerActions.frClickerConditionEditor.ClearActionConditionPreview; //destroy string lists and set array length to 0
      finally
        NewFrame.Free;
      end;
    finally
      ScrBox.Free;
    end;
  finally
    NewTabSheet.Free;
  end;

  PageControlPlayer.ActivePageIndex := PageControlPlayer.PageCount - 1;
end;


procedure TfrmClickerActions.frClickerActionsArrExperiment1PasteDebugValuesListFromMainExecutionList1Click(
  Sender: TObject);
begin
  frClickerActionsArrExperiment1.frClickerActions.SetDebugVariablesFromListOfStrings(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
end;


procedure TfrmClickerActions.frClickerActionsArrExperiment2PasteDebugValuesListFromMainExecutionList1Click(
  Sender: TObject);
begin
  frClickerActionsArrExperiment2.frClickerActions.SetDebugVariablesFromListOfStrings(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
end;


procedure TfrmClickerActions.HandleOnCopyControlTextAndClassFromMainWindow(ACompProvider: string; out AControlText, AControlClass: string);
begin
  if not Assigned(FOnCopyControlTextAndClassFromMainWindow) then
    raise Exception.Create('OnCopyControlTextAndClass not assigned for ' + Caption)
  else
    FOnCopyControlTextAndClassFromMainWindow(ACompProvider, AControlText, AControlClass);
end;


function TfrmClickerActions.HandleOnGetExtraSearchAreaDebuggingImageWithStackLevel(AExtraBitmap: TBitmap; AStackLevel: Integer): Boolean;
var
  Response: string;
  NewSize: TSize;
begin
  if frClickerActionsArrMain.ExecutesRemotely then
  begin
    Response := GetSearchAreaDebugImageFromServer(lbeClientModeServerAddress.Text, AStackLevel, AExtraBitmap);

    if Response = '' then
    begin
      Result := True;
      frClickerActionsArrMain.memLogErr.Lines.Add('Received SearchArea bitmap: ' + IntToStr(AExtraBitmap.Width) + ':' + IntToStr(AExtraBitmap.Height));
    end
    else
    begin
      AExtraBitmap.Canvas.Font.Color := clMaroon;
      AExtraBitmap.Canvas.Brush.Color := clWhite;

      NewSize := AExtraBitmap.Canvas.TextExtent(Response);
      AExtraBitmap.Width := NewSize.Width + 10;
      AExtraBitmap.Height := NewSize.Height;
      AExtraBitmap.Canvas.TextOut(5, 0, Response);
    end;
  end
  else
    Result := False;
end;


procedure TfrmClickerActions.HandleOnWaitForFileAvailability(AFileName: string); //ClickerActionsArrFrame instances call this, to add a filename to FIFO
var
  tk: QWord;
begin
  FFileAvailabilityFIFO.Put(AFileName);

  FTerminateWaitForFileAvailability := False;
  tk := GetTickCount64;
  repeat
    if FInMemFileSystem.FileExistsInMem(AFileName) then
      Exit;

    Application.ProcessMessages;
    Sleep(5);

    if GeneralClosingApp then
      Exit;

    if FTerminateWaitForFileAvailability then
    begin
      FTerminateWaitForFileAvailability := False;
      Exit;
    end;
  until GetTickCount64 - tk > 300000; //if file is not received from client in 5min, simply exit and let the action fail
end;


procedure TfrmClickerActions.HandleOnWaitForMultipleFilesAvailability(AListOfFiles: TStringList);
var
  tk: QWord;
  TempListOfFiles: TStringList;
  i: Integer;
  AllExist: Boolean;
begin
  FFileAvailabilityFIFO.PutMultiple(AListOfFiles);

  TempListOfFiles := TStringList.Create;
  try
    TempListOfFiles.AddStrings(AListOfFiles);

    FTerminateWaitForMultipleFilesAvailability := False;
    tk := GetTickCount64;
    repeat
      AllExist := True;
      for i := TempListOfFiles.Count - 1 downto 0 do
        if not FInMemFileSystem.FileExistsInMem(TempListOfFiles.Strings[i]) then
          AllExist := False
        else
          TempListOfFiles.Delete(i); //remove existent files from being verified again

      if AllExist then
        Exit;

      Application.ProcessMessages;
      Sleep(5);

      if GeneralClosingApp then
        Exit;

      if FTerminateWaitForMultipleFilesAvailability then
      begin
        FTerminateWaitForMultipleFilesAvailability := False;
        Exit;
      end;
    until GetTickCount64 - tk > 60000 * TempListOfFiles.Count; //if file is not received from client in 1min, simply exit and let the action fail
  finally
    TempListOfFiles.Free;
  end;
end;


procedure TfrmClickerActions.HandleOnWaitForBitmapsAvailability(AListOfBitmapFiles: TStringList);
var
  ListOfNonExistentBmps: TStringList;
begin
  ListOfNonExistentBmps := TStringList.Create;
  try
    ExtractNonExistentFiles(AListOfBitmapFiles, ListOfNonExistentBmps, flMem {flDiskThenMem}, FInMemFileSystem);
    if ListOfNonExistentBmps.Count > 0 then
    begin
      AddToLogFromThread('Waiting for the following bitmaps to exist: ' + #13#10 + AListOfBitmapFiles.Text);
      HandleOnWaitForMultipleFilesAvailability(ListOfNonExistentBmps);
    end;
  finally
    ListOfNonExistentBmps.Free;
  end;
end;


function TfrmClickerActions.HandleOnLoadBitmap(ABitmap: TBitmap; AFileName: string): Boolean;
begin
  Result := False;
  if CExpectedFileLocation[frClickerActionsArrMain.FileLocationOfDepsIsMem] = flMem then
  begin
    if not FInMemFileSystem.FileExistsInMem(AFileName) then
      Exit;
  end
  else
    if CExpectedFileLocation[frClickerActionsArrMain.FileLocationOfDepsIsMem] = flDisk then
    begin
      if not DoOnFileExists(AFileName) then
        Exit;
    end;

  //replaced FileExistsInDiskOrMemWithPriority with the above logic, because of disk handlers
  //if not FileExistsInDiskOrMemWithPriority(AFileName, FInMemFileSystem, CExpectedFileLocation[frClickerActionsArrMain.FileLocationOfDepsIsMem]) then
  //  Exit;

  if frClickerActionsArrMain.FileLocationOfDepsIsMem then
  begin
    LoadBmpFromInMemFileSystem(AFileName, ABitmap, FInMemFileSystem);
    Result := True;
  end
  else
    Result := DoLoadBitmap(ABitmap, AFileName);
end;


function TfrmClickerActions.GetListOfWaitingFiles: string;
begin
  Result := FastReplace_ReturnTo87(FFileAvailabilityFIFO.PopAllAsString);
end;


function TfrmClickerActions.GetCompAtPoint(AParams: TStrings): string;
var
  tp: TPoint;
  Comp: TCompRec;
  ResultLst: TStringList;
begin
  tp.X := StrToIntDef(AParams.Values[CREParam_X], -1);
  tp.Y := StrToIntDef(AParams.Values[CREParam_Y], -1);

  if (tp.X = -1) or (tp.Y = -1) then
  begin
    Result := CREResp_ErrParam + '=X or Y are invalid';
    Exit;
  end;

  Comp := GetWindowClassRec(tp);

  ResultLst := TStringList.Create;
  try
    ResultLst.Add(CREResp_ErrParam + '=' + CREResp_ErrResponseOK);
    ResultLst.Add(CREResp_HandleParam + '=' + IntToStr(Comp.Handle));
    ResultLst.Add(CREResp_TextParam + '=' + Comp.Text);
    ResultLst.Add(CREResp_ClassParam + '=' + Comp.ClassName);
    ResultLst.Add(CREResp_ScreenWidth + '=' + IntToStr(Screen.Width));
    ResultLst.Add(CREResp_ScreenHeight + '=' + IntToStr(Screen.Height));
    ResultLst.Add(CREResp_CompLeft + '=' + IntToStr(Comp.ComponentRectangle.Left));
    ResultLst.Add(CREResp_CompTop + '=' + IntToStr(Comp.ComponentRectangle.Top));
    ResultLst.Add(CREResp_CompWidth + '=' + IntToStr(Comp.ComponentRectangle.Width));
    ResultLst.Add(CREResp_CompHeight + '=' + IntToStr(Comp.ComponentRectangle.Height));

    Result := FastReplace_ReturnTo87(ResultLst.Text);
  finally
    ResultLst.Free;
  end;
end;


procedure TfrmClickerActions.SetFullTemplatesDir(Value: string);
begin
  if FFullTemplatesDir <> Value then
  begin
    Value := StringReplace(Value, '$AppDir$', ExtractFileDir(ParamStr(0)), [rfReplaceAll]);
    FFullTemplatesDir := Value;
    frClickerActionsArrMain.FullTemplatesDir := Value;
    frClickerActionsArrExperiment1.FullTemplatesDir := Value;
    frClickerActionsArrExperiment2.FullTemplatesDir := Value;
  end;
end;


function TfrmClickerActions.GetShowDeprecatedControls: Boolean;
begin
  Result := frClickerActionsArrMain.ShowDeprecatedControls;
end;


procedure TfrmClickerActions.SetShowDeprecatedControls(Value: Boolean);
begin
  frClickerActionsArrMain.ShowDeprecatedControls := Value;

  if frClickerActionsArrExperiment1 <> nil then
    frClickerActionsArrExperiment1.ShowDeprecatedControls := Value;

  if frClickerActionsArrExperiment2 <> nil then
    frClickerActionsArrExperiment2.ShowDeprecatedControls := Value;
end;


function TfrmClickerActions.GetBMPsDir: string;
begin
  try
    Result := frClickerActionsArrMain.frClickerActions.BMPsDir;  //frClickerActionsArrMain may not be created when GetBMPsProjectsDir is called
  except
    Result := '';
  end;

  if Result = '' then
    Result := frClickerActionsArrExperiment1.frClickerActions.BMPsDir;

  if Result = '' then
    Result := frClickerActionsArrExperiment2.frClickerActions.BMPsDir;
end;


procedure TfrmClickerActions.SetBMPsDir(Value: string);
begin
  if Value <> FBMPsDir then
  begin
    FBMPsDir := Value;
    frClickerActionsArrExperiment1.frClickerActions.BMPsDir := FBMPsDir;
    frClickerActionsArrExperiment2.frClickerActions.BMPsDir := FBMPsDir;
    frClickerActionsArrMain.frClickerActions.BMPsDir := FBMPsDir;
  end;
end;


function TfrmClickerActions.GetConfiguredRemoteAddress: string;
begin
  Result := lbeClientModeServerAddress.Text;
end;


function TfrmClickerActions.GetActionExecution: TActionExecution;
begin
  Result := frClickerActionsArrMain.ActionExecution;
end;

//Remote execution stuff

//called in server mode
function TfrmClickerActions.ProcessServerCmd(ASyncObj: TSyncHTTPCmd): string;
var
  TabIdx: Integer;
  IsDebuggingFromClient: Boolean;
  ErrMsg: string;
  Fnm: string;
  RemoteState: Boolean;
  TempStr: string;
begin
  Result := 'ok';  //default if not setting any result, as in CRECmd_ExecuteCommandAtIndex

  AddToLog('Request: ' + ASyncObj.FCmd + '  ' + FastReplace_ReturnToCSV(ASyncObj.FParams.Text));

  if ASyncObj.FFrame = nil then
  begin
    TabIdx := StrToInt64Def(ASyncObj.FParams.Values[CREParam_StackLevel], -1);

    if TabIdx = -1 then
    begin
      Result := '[Server error] Stack level not specified.';
      ASyncObj.FErrCode := 1;
      Exit;
    end;
                                           //make sure this executes only for requests which actually use TabIdx
    if (TabIdx < 0) or (TabIdx > PageControlPlayer.PageCount - 1) then    //accessing PageControlPlayer should be done only from here, the UI thread
    begin
      Result := '[Server error] Stack level out of bounds: ' + IntToStr(TabIdx) + '. This happens when there is no template loaded in a new tab (with the requested stack level), as a result of "call template" action. It is also possible that the template is loaded, then exited before being executed.';
      ASyncObj.FErrCode := 1;
      Exit;
    end;

    ASyncObj.FFrame := GetClickerActionsArrFrameByStackLevel(TabIdx);

    if ASyncObj.FFrame = nil then
    begin
      Result := '[Server error] Can''t get frame at index: ' + IntToStr(TabIdx);
      ASyncObj.FErrCode := 1;
      Exit;
    end;
  end;


  if ASyncObj.FCmd = '/' + CRECmd_ExecuteCommandAtIndex then
  begin
    IsDebuggingFromClient := ASyncObj.FParams.Values[CREParam_IsDebugging] = '1';

    ASyncObj.FFrame.RemoteExActionIndex := StrToInt64Def(ASyncObj.FParams.Values[CREParam_ActionIdx], -1);
    ASyncObj.FFrame.ExecuteActionFromClient(IsDebuggingFromClient);

    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_GetExecuteCommandAtIndexResult then  //Not always called by client. It is usually called as a local request from ProcessServerCommand.
  begin
    Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(ASyncObj.FFrame.RemoteExCmdResult));
    Result := Result + #8#7 + FastReplace_ReturnTo87(ASyncObj.FFrame.frClickerActions.vallstVariables.Strings.Text);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExitTemplate then
  begin
    ASyncObj.FFrame.ExitTemplateFromRemote;
    frClickerActionsArrMain.memLogErr.Lines.Add('Closing template at stack level ' + IntToStr(ASyncObj.FFrame.StackLevel));
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_GetAllReplacementVars then
  begin   //similar to CRECmd_GetExecuteCommandAtIndexResult, but return the var list, without executing an action
    Result := FastReplace_ReturnTo87(ASyncObj.FFrame.frClickerActions.vallstVariables.Strings.Text);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_GetResultedDebugImage then
  begin
    Result := '';
    if not Assigned(ASyncObj.FBmp) then
    begin
      Result := 'Error: Output bitmap not assigned in server handler.';
      Exit;
    end;

    ASyncObj.FBmp.PixelFormat := pf24bit;

    if ASyncObj.FErrCode <> 0 then
    begin
      ErrMsg := 'Err: ' + IntToStr(ASyncObj.FErrCode);
      ASyncObj.FBmp.Width := ASyncObj.FBmp.Canvas.TextWidth(ErrMsg) + 10;
      ASyncObj.FBmp.Height := 15;
      ASyncObj.FBmp.Canvas.Font.Color := clRed;
      ASyncObj.FBmp.Canvas.TextOut(5, 1, ErrMsg);
      ASyncObj.FFrame.memLogErr.Lines.Add('Can''t send debug bmp, because the addressed frame is not set at level ' + ASyncObj.FParams.Values[CREParam_StackLevel]);
    end
    else
    begin
      ASyncObj.FBmp.Width := ASyncObj.FFrame.frClickerActions.imgDebugBmp.Width;
      ASyncObj.FBmp.Height := ASyncObj.FFrame.frClickerActions.imgDebugBmp.Height;
      ASyncObj.FBmp.Assign(ASyncObj.FFrame.frClickerActions.imgDebugBmp.Picture.Bitmap); //ASyncObj.FBmp.Canvas.Draw(0, 0, ASyncObj.FFrame.frClickerActions.imgDebugBmp.Picture.Bitmap); //using Canvas, requires the device context to be available (a.k.a. Canvas.Handle)

      if ASyncObj.FParams.Values[CREParam_Grid] = '1' then
      begin
        ASyncObj.FBmp.Canvas.Draw(ASyncObj.FFrame.frClickerActions.imgDebugGrid.Left,
                                  ASyncObj.FFrame.frClickerActions.imgDebugGrid.Top,
                                  ASyncObj.FFrame.frClickerActions.imgDebugGrid.Picture.Bitmap);
        ASyncObj.FFrame.memLogErr.Lines.Add('Added grid to debug bmp..');
      end;

      if ASyncObj.FFrame <> frClickerActionsArrMain then
              ASyncObj.FFrame.memLogErr.Lines.Add('Sending debug bmp of: ' + IntToStr(ASyncObj.FBmp.Width) + ' x ' + IntToStr(ASyncObj.FBmp.Height) + '  from Frame at level ' + IntToStr(ASyncObj.FFrame.StackLevel));
      frClickerActionsArrMain.memLogErr.Lines.Add('Sending debug bmp of: ' + IntToStr(ASyncObj.FBmp.Width) + ' x ' + IntToStr(ASyncObj.FBmp.Height) + '  from Frame at level ' + IntToStr(ASyncObj.FFrame.StackLevel));
    end;

    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_GetSearchAreaDebugImage then
  begin
    Result := '';
    if not Assigned(ASyncObj.FBmp) then
    begin
      Result := 'Error: Output bitmap not assigned in server handler.';
      Exit;
    end;

    ASyncObj.FBmp.PixelFormat := pf24bit;

    if ASyncObj.FErrCode <> 0 then
    begin
      ErrMsg := 'Err: ' + IntToStr(ASyncObj.FErrCode);
      ASyncObj.FBmp.Width := ASyncObj.FBmp.Canvas.TextWidth(ErrMsg) + 10;
      ASyncObj.FBmp.Height := 15;
      ASyncObj.FBmp.Canvas.Font.Color := clRed;
      ASyncObj.FBmp.Canvas.TextOut(5, 1, ErrMsg);
      ASyncObj.FFrame.memLogErr.Lines.Add('Can''t send search area debug bmp, because the addressed frame is not set at level ' + ASyncObj.FParams.Values[CREParam_StackLevel]);
    end
    else
    begin
      //if not Assigned(ASyncObj.FFrame.frClickerActions.frClickerFindControl.SearchAreaControlDbgImg) then  //take a screenshot anyway
        ASyncObj.FFrame.frClickerActions.frClickerFindControl.DisplayDebuggingImage;

      ASyncObj.FBmp.Width := ASyncObj.FFrame.frClickerActions.frClickerFindControl.SearchAreaControlDbgImg.Width;
      ASyncObj.FBmp.Height := ASyncObj.FFrame.frClickerActions.frClickerFindControl.SearchAreaControlDbgImg.Height;
      ASyncObj.FBmp.Assign(ASyncObj.FFrame.frClickerActions.frClickerFindControl.SearchAreaControlDbgImg.Picture.Bitmap); //ASyncObj.FBmp.Canvas.Draw(0, 0, ASyncObj.FFrame.frClickerActions.imgDebugBmp.Picture.Bitmap); //using Canvas, requires the device context to be available (a.k.a. Canvas.Handle)

      if ASyncObj.FFrame <> frClickerActionsArrMain then
              ASyncObj.FFrame.memLogErr.Lines.Add('Sending debug bmp of: ' + IntToStr(ASyncObj.FBmp.Width) + ' x ' + IntToStr(ASyncObj.FBmp.Height) + '  from Frame at level ' + IntToStr(ASyncObj.FFrame.StackLevel));
      frClickerActionsArrMain.memLogErr.Lines.Add('Sending search area debug bmp of: ' + IntToStr(ASyncObj.FBmp.Width) + ' x ' + IntToStr(ASyncObj.FBmp.Height) + '  from Frame at level ' + IntToStr(ASyncObj.FFrame.StackLevel));
    end;

    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_GetScreenShotImage then
  begin
    Result := '';
    if not Assigned(ASyncObj.FBmp) then
    begin
      Result := 'Error: Output bitmap not assigned in server handler.';
      Exit;
    end;

    ASyncObj.FBmp.PixelFormat := pf24bit;
    ASyncObj.FBmp.Width := Screen.Width;
    ASyncObj.FBmp.Height := Screen.Height;
    ScreenShot(0, ASyncObj.FBmp, 0, 0, ASyncObj.FBmp.Width, ASyncObj.FBmp.Height);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_GetCurrentlyRecordedScreenShotImage then
  begin
    Result := '';
    if not Assigned(ASyncObj.FBmp) then
    begin
      Result := 'Error: Output bitmap not assigned in server handler.';
      Exit;
    end;

    ASyncObj.FBmp.PixelFormat := pf24bit;
    DoOnGetCurrentlyRecordedScreenShotImage(ASyncObj.FBmp);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_LoadTemplateInExecList then
  begin
    Fnm := ASyncObj.FParams.Values[CREParam_FileName];
    RemoteState := ASyncObj.FFrame.ExecutingActionFromRemote;
    try
      ASyncObj.FFrame.ExecutingActionFromRemote := True;  //set to true, to prevent messageboxes
      ASyncObj.FFrame.LoadTemplate(Fnm, flMem, FInMemFileSystem);
    finally
      ASyncObj.FFrame.ExecutingActionFromRemote := RemoteState //restore, in case the server is running unattended
    end;

    frClickerActionsArrMain.memLogErr.Lines.Add('Loading template in main list from mem.');
    Result := CREResp_TemplateLoaded;
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_GetFileExpectancy then    //let the client know if the server expects missing files to be sent to
  begin
    case cmbFilesExistence.ItemIndex of
      0: Result := CREResp_FileExpectancy_ValueOnDisk;
      1: Result := CREResp_FileExpectancy_ValueFromClient;
      else
         Result := CREResp_FileExpectancy_ValueUnkown;
    end;

    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_RecordComponent then
  begin
    DoOnRecordComponent(StrToInt64Def(ASyncObj.FParams.Values[CREParam_Handle], -1), ASyncObj.FGPStream);
    Result := ''; //must be '', when responding with files
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ClearInMemFileSystem then
  begin
    FInMemFileSystem.Clear;
    Result := CREResp_Done;
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_SetVariable then
  begin
    ASyncObj.FFrame.SetActionVarValue(ASyncObj.FParams.Values[CREParam_Var], ASyncObj.FParams.Values[CREParam_Value]);
    Result := CREResp_Done;
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_TerminateWaitingForFileAvailability then
  begin
    TempStr := ASyncObj.FParams.Values[CREParam_TerminateWaitingLoop];
    frClickerActionsArrMain.memLogErr.Lines.Add('Terminating waiting loops on request... The waiting action(s) should fail because of missing files.  Loop type: ' + TempStr);

    if TempStr = CREParam_TerminateWaitingLoop_ValueSingle then
      FTerminateWaitForFileAvailability := True
    else
      if TempStr = CREParam_TerminateWaitingLoop_ValueMulti then
        FTerminateWaitForMultipleFilesAvailability := True
      else
      begin
        FTerminateWaitForFileAvailability := True;
        FTerminateWaitForMultipleFilesAvailability := True;
      end;

    frClickerActionsArrMain.memLogErr.Lines.Add('The waiting loops should be terminated (on request).');
    Result := CREResp_Done;
    Exit;
  end;

  //if ASyncObj.FCmd = '/' + CRECmd_MouseDown then  //implemented here, in UI thread, if MouseDownTControl calls Application.ProcessMessages;
  //begin
  //  MouseDownTControl(ASyncObj.FParams);
  //  Result := CREResp_Done;
  //  Exit;
  //end;
  //
  //if ASyncObj.FCmd = '/' + CRECmd_MouseUp then    //implemented here, in UI thread, if MouseDownTControl calls Application.ProcessMessages;
  //begin
  //  MouseUpTControl(ASyncObj.FParams);
  //  Result := CREResp_Done;
  //  Exit;
  //end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteClickAction then
  begin
    Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteClickActionAsString(ASyncObj.FParams)));
    Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteExecAppAction then
  begin
    Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteExecAppActionAsString(ASyncObj.FParams)));
    Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteFindControlAction then
  begin
    frClickerActionsArrMain.ExecutingActionFromRemote := True;
    frClickerActionsArrMain.FileLocationOfDepsIsMem := ASyncObj.FParams.Values[CREParam_FileLocation] = CREParam_FileLocation_ValueMem; //to load files from in-mem FS
    try
      frClickerActionsArrMain.StopAllActionsOnDemand := False;
      if frClickerActionsArrMain.StopAllActionsOnDemandFromParent <> nil then
        frClickerActionsArrMain.StopAllActionsOnDemandFromParent^ := False; //set this to avoid stopping child instances

      Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteFindControlActionAsString(ASyncObj.FParams, False)));
      Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    finally
      frClickerActionsArrMain.ExecutingActionFromRemote := False;
      frClickerActionsArrMain.FileLocationOfDepsIsMem := False;
    end;

    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteFindSubControlAction then
  begin
    frClickerActionsArrMain.frClickerActions.frClickerFindControl.UpdateBitmapAlgorithmSettings; //to hide grid
    frClickerActionsArrMain.ExecutingActionFromRemote := True;
    frClickerActionsArrMain.FileLocationOfDepsIsMem := ASyncObj.FParams.Values[CREParam_FileLocation] = CREParam_FileLocation_ValueMem; //to load files from in-mem FS
    try
      frClickerActionsArrMain.StopAllActionsOnDemand := False;
      if frClickerActionsArrMain.StopAllActionsOnDemandFromParent <> nil then
        frClickerActionsArrMain.StopAllActionsOnDemandFromParent^ := False; //set this to avoid stopping child instances

      Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteFindControlActionAsString(ASyncObj.FParams, True)));
      Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    finally
      frClickerActionsArrMain.ExecutingActionFromRemote := False;
      frClickerActionsArrMain.FileLocationOfDepsIsMem := False;
    end;

    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteSetControlTextAction then
  begin
    Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteSetControlTextActionAsString(ASyncObj.FParams)));
    Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteCallTemplateAction then
  begin
    frClickerActionsArrMain.ExecutingActionFromRemote := True;
    frClickerActionsArrMain.FileLocationOfDepsIsMem := ASyncObj.FParams.Values[CREParam_FileLocation] = CREParam_FileLocation_ValueMem; //to load files from in-mem FS
    try
      frClickerActionsArrMain.StopAllActionsOnDemand := False;
      if frClickerActionsArrMain.StopAllActionsOnDemandFromParent <> nil then
        frClickerActionsArrMain.StopAllActionsOnDemandFromParent^ := False; //set this to avoid stopping child instances

      Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteCallTemplateActionAsString(ASyncObj.FParams)));
      Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    finally
      frClickerActionsArrMain.ExecutingActionFromRemote := False;
      frClickerActionsArrMain.FileLocationOfDepsIsMem := False;
    end;

    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteSleepAction then
  begin
    frClickerActionsArrMain.StopAllActionsOnDemand := False;
    if frClickerActionsArrMain.StopAllActionsOnDemandFromParent <> nil then
      frClickerActionsArrMain.StopAllActionsOnDemandFromParent^ := False; //set this to avoid stopping child instances

    Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteSleepActionAsString(ASyncObj.FParams)));
    Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteSetVarAction then
  begin
    Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteSetVarActionAsString(ASyncObj.FParams)));
    Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    Exit;
  end;

  if ASyncObj.FCmd = '/' + CRECmd_ExecuteWindowOperationsAction then
  begin
    Result := CREResp_RemoteExecResponseVar + '=' + IntToStr(Ord(frClickerActionsArrMain.ActionExecution.ExecuteWindowOperationsActionAsString(ASyncObj.FParams)));
    Result := Result + #8#7 + FastReplace_ReturnTo87(frClickerActionsArrMain.frClickerActions.vallstVariables.Strings.Text);
    Exit;
  end;

  Result := 'unknown command';  //default if no command is recognized
  frClickerActionsArrMain.memLogErr.Lines.Add(Result + ': ' + ASyncObj.FCmd);
  ASyncObj.FErrCode := 2;
end;


constructor TSyncHTTPCmd.Create;
begin
  inherited Create;
  FBmp := nil; //init here, to avoid dangling pointers
  FErrCode := 0;
end;


procedure TSyncHTTPCmd.DoSynchronize;
begin
  FResult := frmClickerActions.ProcessServerCmd(Self);
end;


function ProcessServerCommand(ACmd: string; AParams: TStrings; AOutBmp: TBitmap; AGPStream: TMemoryStream): string;
var
  SyncObj: TSyncHTTPCmd;
begin
  try
    //ExecuteCommand requires a special handling with two parts: executing the actual command, then getting the debugging content
    if ACmd = '/' + CRECmd_ExecuteCommandAtIndex then
    begin
      SyncObj := TSyncHTTPCmd.Create;
      try
        SyncObj.FCmd := ACmd;
        SyncObj.FParams := AParams; //it's ok to pass the pointer, however, it may not be ok to modify the list
        SyncObj.FFrame := nil;  //will get assigned on the first sync call
        SyncObj.FErrCode := 0;

        SyncObj.Synchronize;

        if SyncObj.FErrCode = 0 then
        begin
          repeat                 //this loop executes in the context of server's thread
            Sleep(2);
          until not SyncObj.FFrame.ExecutingActionFromRemote;  //reset by timer

          SyncObj.FCmd := '/' + CRECmd_GetExecuteCommandAtIndexResult;
          SyncObj.Synchronize;    //process a local request
        end;

        Result := SyncObj.FResult;
      finally
        SyncObj.Free;
      end;

      Exit;
    end;

    if ACmd = '/' + CRECmd_TestConnection then
    begin
      Result := CREResp_ConnectionOK;
      Exit;
    end;

    if ACmd = '/' + CRECmd_MouseDown then
    begin
      MouseDownTControl(AParams);      //can be called from server thread, if it doesn't call Application.ProcessMessages
      Result := CREResp_Done;
      Exit;
    end;

    if ACmd = '/' + CRECmd_MouseUp then
    begin
      MouseUpTControl(AParams);
      Result := CREResp_Done;
      Exit;
    end;

    //default behavior
    SyncObj := TSyncHTTPCmd.Create;
    try
      SyncObj.FCmd := ACmd;
      SyncObj.FParams := AParams; //it's ok to pass the pointer, however, it may not be ok to modify the list
      SyncObj.FFrame := nil;  //will get assigned on the first sync call
      SyncObj.FErrCode := 0;
      SyncObj.FBmp := AOutBmp;
      SyncObj.FGPStream := AGPStream;

      SyncObj.Synchronize;

      Result := SyncObj.FResult;
    finally
      SyncObj.Free;
    end;
  except
    on E: Exception do
      Result := 'ProcessServerCommand exception: ' + E.Message;
  end;
end;


procedure TfrmClickerActions.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  GettingImage, GettingGPStream: Boolean;
  Bmp: TBitmap;
  GPStream: TMemoryStream;
  Cmd: string;
begin
  Cmd := ARequestInfo.Document;

  AResponseInfo.ContentType := 'text/plain'; // 'text/html';  default type

  if Cmd = '/' + CRECmd_GetListOfWaitingFiles then   //this has priority over other commands  (it is used with KeepAlive)
  begin
    FProcessingMissingFilesRequestByServer := True;  //reset by timer
    AResponseInfo.ContentText := GetListOfWaitingFiles;

    if AResponseInfo.ContentText <> '' then
      AddToLogFromThread('Requesting list of missing files. List: ' + AResponseInfo.ContentText);

    Exit;
  end;

  if Cmd = '/' + CRECmd_GetCompInfoAtPoint then
  begin
    AResponseInfo.ContentText := GetCompAtPoint(ARequestInfo.Params);
    Exit;
  end;

  GettingImage := False;
  if (Cmd = '/' + CRECmd_GetResultedDebugImage) or
     (Cmd = '/' + CRECmd_GetSearchAreaDebugImage) or
     (Cmd = '/' + CRECmd_GetScreenShotImage) or
     (Cmd = '/' + CRECmd_GetCurrentlyRecordedScreenShotImage) then
  begin
    Bmp := TBitmap.Create;
    GettingImage := True;
  end
  else
    Bmp := nil; //set here, in case ProcessServerCommand handles it

  GettingGPStream := False;
  if Cmd = '/' + CRECmd_RecordComponent then
  begin
    GPStream := TMemoryStream.Create;
    GettingGPStream := True;
  end
  else
    GPStream := nil;

  try
    AResponseInfo.ContentText := ProcessServerCommand(Cmd, ARequestInfo.Params, Bmp, GPStream);

    if GettingImage then
    begin
      if AResponseInfo.ContentText <> '' then
      begin
        Bmp.Width := Bmp.Canvas.TextWidth(AResponseInfo.ContentText) + 10;
        Bmp.Height := 20;
        Bmp.Canvas.Brush.Color := clWhite;
        Bmp.Canvas.Font.Color := $000000AA;
        Bmp.Canvas.TextOut(3, 2, AResponseInfo.ContentText);
        AResponseInfo.ContentText := ''; //reset this, to send the response in the proper format
      end;

      AResponseInfo.ContentType := 'image/bmp'; //'application/octet-stream';
      AResponseInfo.ContentDisposition := 'inline'; //display it in browser
      AResponseInfo.CharSet := 'US-ASCII';  //this is actually required, to prevent converting ASCII characters from 128-255 to '?'

      AResponseInfo.ContentStream := TMemoryStream.Create;
      try
        Bmp.SaveToStream(AResponseInfo.ContentStream);

        AResponseInfo.ContentLength := AResponseInfo.ContentStream.Size;
        //AddToLogFromThread('Sending bitmap of ' + IntToStr(AResponseInfo.ContentStream.Size) + ' bytes in size.');

        AResponseInfo.WriteHeader;
        AResponseInfo.WriteContent;
      finally
        AResponseInfo.ContentStream.Free;
        AResponseInfo.ContentStream := nil;
      end;

      Exit;
    end;

    if GettingGPStream then
    begin
      AResponseInfo.ContentText := '';
      AResponseInfo.ContentType := 'application/octet-stream';
      AResponseInfo.ContentDisposition := 'attachment';   //download by browser
      AResponseInfo.CharSet := 'US-ASCII';  //this is actually required, to prevent converting ASCII characters from 128-255 to '?'

      AResponseInfo.ContentStream := TMemoryStream.Create;
      try
        GPStream.Position := 0;
        AResponseInfo.ContentStream.CopyFrom(GPStream, GPStream.Size);

        AResponseInfo.ContentLength := AResponseInfo.ContentStream.Size;
        AddToLogFromThread('Sending stream of ' + IntToStr(AResponseInfo.ContentStream.Size) + ' bytes in size.');

        AResponseInfo.WriteHeader;
        AResponseInfo.WriteContent;
      finally
        AResponseInfo.ContentStream.Free;
        AResponseInfo.ContentStream := nil;
        AContext.Connection.Disconnect(True);
      end;

      Exit;
    end;
  finally
    if GettingImage then
      Bmp.Free;

    if GettingGPStream then
      GPStream.Free;
  end;
end;


procedure TfrmClickerActions.IdHTTPServer1CommandOther(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

  procedure RespondWithText(ErrMsg: string);
  begin
    AResponseInfo.ContentStream := TMemoryStream.Create;
    try
      AResponseInfo.ContentStream.Write(ErrMsg[1], Length(ErrMsg));
      AResponseInfo.ContentLength := AResponseInfo.ContentStream.Size;

      AResponseInfo.WriteHeader;
      AResponseInfo.WriteContent;
    finally
      AResponseInfo.ContentStream.Free;
      AResponseInfo.ContentStream := nil;
    end;
  end;

var
  Fnm, Msg: string;
  TempMemStream: TMemoryStream;
  ListOfFileNames, ListOfFileFound: TStringList;
  VerifyHashes: Boolean;
  i: Integer;
begin
  if ARequestInfo.CommandType <> hcPUT then
    Exit;

  if ARequestInfo.PostStream = nil then
  begin
    RespondWithText('Expecting a file.');
    Exit;
  end;

  //it's ok to handle filesystem-related requests from server thread

  if ARequestInfo.Document = '/' + CRECmd_SendFileToServer then
  begin
    Fnm := ARequestInfo.Params.Values[CREParam_FileName];
    if Trim(Fnm) = '' then
    begin
      RespondWithText('Expecting a valid filename.');
      Exit;
    end;

    TempMemStream := TMemoryStream.Create;
    try
      TempMemStream.CopyFrom(ARequestInfo.PostStream, ARequestInfo.PostStream.Size);
      FInMemFileSystem.SaveFileToMem(Fnm, TempMemStream.Memory, TempMemStream.Size);

      Msg := 'Received file: "' + Fnm + '"  of ' + IntToStr(TempMemStream.Size) + ' bytes in size.';
      AddToLogFromThread(Msg);
      RespondWithText(Msg);
    finally
      TempMemStream.Free;
    end;

    Exit;
  end;

  if ARequestInfo.Document = '/' + CRECmd_GetFileExistenceOnServer then
  begin
    VerifyHashes := ARequestInfo.Params.Values[CREParam_VerifyHashes] = '1';

    ListOfFileNames := TStringList.Create;
    ListOfFileFound := TStringList.Create;
    try
      ARequestInfo.PostStream.Position := 0;
      ListOfFileNames.LoadFromStream(ARequestInfo.PostStream);

      //AddToLogFromThread('List of files to be verified if exist in in-mem fs (' + IntToStr(ListOfFileNames.Count) + '):' + #13#10 + ListOfFileNames.Text);  //for debugging only
      //AddToLogFromThread('===================================== End of file names to be verified. ===============  DebugParam=' + ARequestInfo.Params.Values[CREParam_DebugParam]);

      if VerifyHashes then
      begin
        for i := 0 to ListOfFileNames.Count - 1 do
          ListOfFileFound.Add(IntToStr(Ord(FInMemFileSystem.FileExistsInMemWithHash(ListOfFileNames.Strings[i]))));
      end
      else
      begin
        for i := 0 to ListOfFileNames.Count - 1 do
          ListOfFileFound.Add(IntToStr(Ord(FInMemFileSystem.FileExistsInMem(ListOfFileNames.Strings[i]))));
      end;

      RespondWithText(ListOfFileFound.Text);
    finally
      ListOfFileNames.Free;
      ListOfFileFound.Free;
    end;

    Exit;
  end;
end;


procedure TfrmClickerActions.IdHTTPServer1Connect(AContext: TIdContext);
begin
  AContext.Connection.Socket.ReadTimeout := 3600000;   //if no bytes are received in 1h, then close the connection
end;


procedure TfrmClickerActions.IdHTTPServer1Exception(AContext: TIdContext;
  AException: Exception);
begin
  try
    if AException.Message <> 'Connection Closed Gracefully.' then
      AddToLogFromThread('Server exception: ' + AException.Message);
  except
  end;
end;


//using a polling timer, instead of sync-ing every request with UI
procedure TfrmClickerActions.tmrDisplayMissingFilesRequestsTimer(Sender: TObject);
const
  CRequestColor: array[Boolean] of TColor = (clGreen, clLime);
  CRequestFontColor: array[Boolean] of TColor = (clWhite, clBlack);
begin
  case cmbExecMode.ItemIndex of
    0:
    begin
      pnlMissingFilesRequest.Color := CRequestColor[False];
      pnlMissingFilesRequest.Font.Color := CRequestFontColor[False];
    end;

    1:
      if FProcessingMissingFilesRequestByClient then
      begin
        FProcessingMissingFilesRequestByClient := False;
        pnlMissingFilesRequest.Color := CRequestColor[True];
        pnlMissingFilesRequest.Font.Color := CRequestFontColor[True];
      end
      else
      begin   //displaying "False" on next timer iteration, to allow it to be visible
        pnlMissingFilesRequest.Color := CRequestColor[False];
        pnlMissingFilesRequest.Font.Color := CRequestFontColor[False];
      end;

    2:
      if FProcessingMissingFilesRequestByServer then
      begin
        FProcessingMissingFilesRequestByServer := False;
        pnlMissingFilesRequest.Color := CRequestColor[True];
        pnlMissingFilesRequest.Font.Color := CRequestFontColor[True];
      end
      else
      begin   //displaying "False" on next timer iteration, to allow it to be visible
        pnlMissingFilesRequest.Color := CRequestColor[False];
        pnlMissingFilesRequest.Font.Color := CRequestFontColor[False];
      end;
  end;
end;


procedure TfrmClickerActions.tmrStartupTimer(Sender: TObject);
begin
  tmrStartup.Enabled := False;

  //some startup code here
end;


procedure TfrmClickerActions.cmbExecModeChange(Sender: TObject);
const
  CClientExecModeInfoTxt: array[0..2] of string = ('off', 'on', 'off');
  CServerExecModeInfoTxt: array[0..2] of string = ('off', 'off', 'on');
  CClientExecModeInfoColor: array[0..2] of TColor = (clOlive, clGreen, clOlive);
  CServerExecModeInfoColor: array[0..2] of TColor = (clOlive, clOlive, clGreen);
var
  tk: QWord;
begin
  frClickerActionsArrMain.ExecutesRemotely := cmbExecMode.ItemIndex = 1;
  frClickerActionsArrExperiment1.ExecutesRemotely := (cmbExecMode.ItemIndex = 1) and chkSetExperimentsToClientMode.Checked;
  frClickerActionsArrExperiment2.ExecutesRemotely := (cmbExecMode.ItemIndex = 1) and chkSetExperimentsToClientMode.Checked;

  frClickerActionsArrMain.ExecutingActionFromRemote := False;        //prevent entering a waiting loop in PlayAllActions
  frClickerActionsArrExperiment1.ExecutingActionFromRemote := False;
  frClickerActionsArrExperiment2.ExecutingActionFromRemote := False;

  PageControlExecMode.ActivePageIndex := cmbExecMode.ItemIndex;

  try
    if cmbExecMode.ItemIndex <> 2 then  //it is local or client mode, then deactivate server if active
    begin
      cmbExecMode.Enabled := False;
      try
        if IdHTTPServer1.Active then    //switching from server to local or client mode
        begin
          IdHTTPServer1.Active := False;

          tk := GetTickCount64;
          repeat
            Application.ProcessMessages;
            Sleep(10);

            if GetTickCount64 - tk > GeneralConnectTimeout shl 1 + CFileProviderIterationInterval + 100 then
              Break; //a delay long enough, so the client module does not connect to the server module of the same app instance
          until False;
        end;

        chkServerActive.Checked := False;
      finally
        cmbExecMode.Enabled := True;
      end;
    end;

    if cmbExecMode.ItemIndex <> 1 then   //local or server
    begin
      if FPollForMissingServerFiles <> nil then
      begin
        frClickerActionsArrMain.memLogErr.Lines.Add('Stopping "missing files" monitoring thread for client mode.');
        FPollForMissingServerFiles.Terminate;

        cmbExecMode.Enabled := False;
        try
          tk := GetTickCount64;
          repeat
            Application.ProcessMessages;
            Sleep(10);

            if FPollForMissingServerFiles.Done then
            begin
              frClickerActionsArrMain.memLogErr.Lines.Add('Monitoring thread terminated.');
              Break;
            end;

            if GetTickCount64 - tk > 1500 then
            begin
              frClickerActionsArrMain.memLogErr.Lines.Add('Timeout waiting for monitoring thread to terminate. The thread is still running (probably waiting).');
              Break;
            end;
          until False;
        finally
          cmbExecMode.Enabled := True;
        end;

        FPollForMissingServerFiles := nil;
      end;

      if cmbExecMode.ItemIndex = 2 then
        IdHTTPServer1.KeepAlive := chkKeepAlive.Checked;
    end;

    if cmbExecMode.ItemIndex = 1 then //client
    begin
      GeneralConnectTimeout := StrToIntDef(lbeConnectTimeout.Text, 1000); //update GeneralConnectTimeout only after deactivating the server module

      frClickerActionsArrMain.RemoteAddress := lbeClientModeServerAddress.Text;
      frClickerActionsArrExperiment1.RemoteAddress := lbeClientModeServerAddress.Text;
      frClickerActionsArrExperiment2.RemoteAddress := lbeClientModeServerAddress.Text;

      if FPollForMissingServerFiles <> nil then
      begin
        cmbExecMode.ItemIndex := 0; //force local mode, for now, then let the user switch again later
        Sleep(100);
        PageControlExecMode.ActivePageIndex := cmbExecMode.ItemIndex;
        frClickerActionsArrMain.memLogErr.Lines.Add('Stopping "missing files" monitoring thread (again) for client mode. (If the execution mode keeps keeps going back to "Local", you might have to close the whole application).');
        try
          FPollForMissingServerFiles.Terminate; //terminate existing thread, so a new one can be created
        except
          on E: Exception do
            frClickerActionsArrMain.memLogErr.Lines.Add('Exception on stopping client thread. Maybe it''s already done: ' + E.Message);
        end;

        Exit;
      end;

      FPollForMissingServerFiles := TPollForMissingServerFiles.Create(True);
      FPollForMissingServerFiles.RemoteAddress := lbeClientModeServerAddress.Text;
      FPollForMissingServerFiles.ConnectTimeout := StrToIntDef(lbeConnectTimeout.Text, 1000);
      FPollForMissingServerFiles.AddListOfAccessibleDirs(memAllowedFileDirsForServer.Lines);
      FPollForMissingServerFiles.AddListOfAccessibleFileExtensions(memAllowedFileExtensionsForServer.Lines);
      FPollForMissingServerFiles.OnBeforeRequestingListOfMissingFiles := HandleOnBeforeRequestingListOfMissingFiles;
      FPollForMissingServerFiles.OnAfterRequestingListOfMissingFiles := HandleOnAfterRequestingListOfMissingFiles;
      FPollForMissingServerFiles.Start;

      frClickerActionsArrMain.memLogErr.Lines.Add('Started "missing files" monitoring thread for client mode.');
    end;
  finally
    lblClientMode.Caption := 'Client mode ' + CClientExecModeInfoTxt[cmbExecMode.ItemIndex];
    lblServerMode.Caption := 'Server mode ' + CServerExecModeInfoTxt[cmbExecMode.ItemIndex];
    lblClientMode.Font.Color := CClientExecModeInfoColor[cmbExecMode.ItemIndex];
    lblServerMode.Font.Color := CServerExecModeInfoColor[cmbExecMode.ItemIndex];
  end;

  Sleep(100); //prevent fast changing of running modes
end;


procedure TfrmClickerActions.chkServerActiveChange(Sender: TObject);
var
  s: string;
begin
  if chkServerActive.Checked then
  begin
    try
      IdHTTPServer1.DefaultPort := StrToIntDef(lbeServerModePort.Text, 5444);
      IdHTTPServer1.KeepAlive := chkKeepAlive.Checked;
      IdHTTPServer1.Active := True;

      s := 'Server is listening on port ' + IntToStr(IdHTTPServer1.DefaultPort);
      AddToLog(s);

      lblServerInfo.Caption := s;
      lblServerInfo.Font.Color := clGreen;
      lblServerInfo.Hint := '';
    except
      on E: Exception do
      begin
        lblServerInfo.Caption := E.Message;
        lblServerInfo.Font.Color := $000000BB;

        if E.Message = 'Could not bind socket.' then
        begin
          lblServerInfo.Caption := lblServerInfo.Caption + '  (hover for hint)';
          lblServerInfo.Hint := 'Make sure there is no other instance of UIClicker or other application listening on the port.';
          lblServerInfo.Hint := lblServerInfo.Hint + #13#10 + 'If there is another application, started by UIClicker in server mode, with inherited handles, it may keep the socket in use.';
        end;
      end;
    end;
  end
  else
  begin
    IdHTTPServer1.Active := False;
    lblServerInfo.Caption := 'Server module is inactive';
    lblServerInfo.Font.Color := clGray;
    lblServerInfo.Hint := '';
  end;
end;


procedure TfrmClickerActions.chkStayOnTopClick(Sender: TObject);
begin
  if chkStayOnTop.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;


procedure TfrmClickerActions.btnTestConnectionClick(Sender: TObject);
var
  RemoteAddress, Response: string;
begin
  RemoteAddress := lbeClientModeServerAddress.Text;
  Response := TestConnection(RemoteAddress);
  MessageBox(Handle, PChar('Server response: ' + Response), PChar(Application.Title), MB_ICONINFORMATION);
end;


procedure TfrmClickerActions.btnBrowseActionTemplatesDirClick(Sender: TObject);
var
  AOpenDialog: TSelectDirectoryDialog;
  s: string;
begin
  AOpenDialog := TSelectDirectoryDialog.Create(nil);
  try
    AOpenDialog.Filter := 'Clicker template files (*.clktmpl)|*.clktmpl|All files (*.*)|*.*';
    AOpenDialog.InitialDir := StringReplace(lbePathToTemplates.Text, '$AppDir$', ParamStr(0), [rfReplaceAll]);

    if AOpenDialog.Execute then
    begin
      lbePathToTemplates.Text := StringReplace(AOpenDialog.FileName, ExtractFileDir(ParamStr(0)), '$AppDir$', [rfReplaceAll]);
      FullTemplatesDir := lbePathToTemplates.Text;
      if FullTemplatesDir > '' then
        if FullTemplatesDir[Length(FullTemplatesDir)] = '\' then
        begin
          s := FullTemplatesDir;
          Delete(s, Length(s), 1);
          FullTemplatesDir := s;
        end;
    end;
  finally
    AOpenDialog.Free;
  end;
end;


procedure TfrmClickerActions.chkDisplayActivityChange(Sender: TObject);
begin
  tmrDisplayMissingFilesRequests.Enabled := chkDisplayActivity.Checked;
end;


procedure TfrmClickerActions.HandleOnBeforeRequestingListOfMissingFiles;  //client thread calls this, without UI sync
begin
  FProcessingMissingFilesRequestByClient := True;
end;


procedure TfrmClickerActions.HandleOnAfterRequestingListOfMissingFiles;   //client thread calls this, without UI sync
begin
  //FProcessingMissingFilesRequestByClient := False;  //let the timer reset the flag
end;


function TfrmClickerActions.HandleOnComputeInMemFileHash(AFileContent: Pointer; AFileSize: Int64): string;
begin
  Result := ComputeHash(AFileContent, AFileSize);
end;


function TfrmClickerActions.HandleOnFileExists(const FileName: string): Boolean;
begin
  Result := DoOnFileExists(FileName);
end;


function TfrmClickerActions.HandleOnTClkIniReadonlyFileCreate(AFileName: string): TClkIniReadonlyFile;
begin
  Result := DoOnTClkIniReadonlyFileCreate(AFileName);
end;


procedure TfrmClickerActions.HandleOnSaveTemplateToFile(AStringList: TStringList; const FileName: string);
begin
  DoOnSaveTemplateToFile(AStringList, FileName);
end;


procedure TfrmClickerActions.HandleOnSetTemplateOpenDialogInitialDir(AInitialDir: string);
begin
  DoOnSetTemplateOpenDialogInitialDir(AInitialDir);
end;


function TfrmClickerActions.HandleOnTemplateOpenDialogExecute: Boolean;
begin
  Result := DoOnTemplateOpenDialogExecute;
end;


function TfrmClickerActions.HandleOnGetTemplateOpenDialogFileName: string;
begin
  Result := DoOnGetTemplateOpenDialogFileName;
end;


procedure TfrmClickerActions.HandleOnSetTemplateSaveDialogInitialDir(AInitialDir: string);
begin
  DoOnSetTemplateSaveDialogInitialDir(AInitialDir);
end;


function TfrmClickerActions.HandleOnTemplateSaveDialogExecute: Boolean;
begin
  Result := DoOnTemplateSaveDialogExecute;
end;


function TfrmClickerActions.HandleOnGetTemplateSaveDialogFileName: string;
begin
  Result := DoOnGetTemplateSaveDialogFileName;
end;


procedure TfrmClickerActions.HandleOnSetTemplateSaveDialogFileName(AFileName: string);
begin
  DoOnSetTemplateSaveDialogFileName(AFileName);
end;


procedure TfrmClickerActions.HandleOnSetPictureOpenDialogInitialDir(AInitialDir: string);
begin
  DoOnSetPictureOpenDialogInitialDir(AInitialDir);
end;


function TfrmClickerActions.HandleOnPictureOpenDialogExecute: Boolean;
begin
  Result := DoOnPictureOpenDialogExecute;
end;


function TfrmClickerActions.HandleOnGetPictureOpenDialogFileName: string;
begin
  Result := DoOnGetPictureOpenDialogFileName;
end;

end.
