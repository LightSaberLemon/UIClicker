{
    Copyright (C) 2022 VCC
    creation date: Dec 2019
    initial release date: 26 Jul 2022

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

unit ClickerActionsClient;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ClickerUtils, Graphics;


type
  TClientThread = class(TThread)
  private
    FLink: string;
    FResult: string;
    FDone: Boolean;
    FConnectTimeout: Integer;
    FStreamForServer: TMemoryStream;
    FResponseStream: TMemoryStream;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean {$IFDEF FPC}; const StackSize: SizeUInt = DefaultStackSize {$ENDIF});
    property Link: string read FLink write FLink;
    property Result: string read FResult;
    property Done: Boolean read FDone;
    property ConnectTimeout: Integer read FConnectTimeout write FConnectTimeout;
  end;


const
  CDefaultNoTemplate = 'NoName.clktmpl';

const
  CREParam_ActionIdx = 'ActionIdx';
  CREParam_StackLevel = 'StackLevel';
  CREParam_IsDebugging = 'IsDebugging';
  CREParam_Grid = 'Grid';
  CREParam_FileName = 'FileName';
  CREParam_FileLocation = 'FileLocation';
  CREParam_VerifyHashes = 'VerifyHashes';

  CREParam_X = 'X';
  CREParam_Y = 'Y';
  CREParam_Handle = 'Handle';

  CREParam_FileLocation_ValueDisk = 'Disk';
  CREParam_FileLocation_ValueMem = 'Mem';

  CREParam_DebugParam = 'Dbg';
  CREParam_Var = 'Var';
  CREParam_Value = 'Value';

  CRECmd_TestConnection = 'TestConnection';
  CRECmd_ExecuteCommandAtIndex = 'ExecuteCommandAtIndex';
  CRECmd_GetExecuteCommandAtIndexResult = 'GetExecuteCommandAtIndexResult';
  CRECmd_ExitTemplate = 'ExitTemplate';
  CRECmd_GetAllReplacementVars = 'GetAllReplacementVars';
  CRECmd_SendFileToServer = 'SendFileToServer';
  CRECmd_LoadTemplateInExecList = 'LoadTemplateInExecList';
  CRECmd_GetFileExpectancy = 'GetFileExpectancy';
  CRECmd_GetFileExistenceOnServer = 'GetFileExistenceOnServer';
  CRECmd_GetListOfWaitingFiles = 'GetListOfWaitingFiles';
  CRECmd_GetResultedDebugImage = 'GetResultedDebugImage'; //the image from the debugging tab, resulted after executing FindSubControl
  CRECmd_GetScreenShotImage = 'GetScreenShotImage';
  CRECmd_GetCurrentlyRecordedScreenShotImage = 'GetCurrentlyRecordedScreenShotImage';
  CRECmd_GetCompInfoAtPoint = 'GetCompInfoAtPoint';
  CRECmd_RecordComponent = 'RecordComponent';
  CRECmd_ClearInMemFileSystem = 'ClearInMemFileSystem';
  CRECmd_SetVariable = 'SetVariable';

  CRECmd_ExecuteClickAction = 'ExecuteClickAction';
  CRECmd_ExecuteExecAppAction = 'ExecuteExecAppAction';
  CRECmd_ExecuteSetControlTextAction = 'ExecuteSetControlTextAction';
  CRECmd_ExecuteFindControlAction = 'ExecuteFindControlAction';
  CRECmd_ExecuteFindSubControlAction = 'ExecuteFindSubControlAction';
  CRECmd_ExecuteCallTemplateAction = 'ExecuteCallTemplateAction';
  CRECmd_ExecuteSleepAction = 'ExecuteSleepAction';
  CRECmd_ExecuteSetVarAction = 'ExecuteSetVarAction';
  CRECmd_ExecuteWindowOperationsAction = 'ExecuteWindowOperationsAction';

  CREResp_ConnectionOK = 'Connection ok';
  CREResp_RemoteExecResponseVar = '$RemoteExecResponse$';
  CREResp_FileExpectancy_ValueOnDisk = 'OnDisk';           //the server expects that templates and bmps to exist on disk
  CREResp_FileExpectancy_ValueFromClient = 'FromClient';   //the server expects that templates and bmps to be received from client
  CREResp_FileExpectancy_ValueUnkown = 'Unkown';           //default response when the option is not handled by server
  CREResp_ReceivedFile = 'Received file';
  CREResp_TemplateLoaded = 'Loaded';

  CREResp_ErrParam = 'Err';
  CREResp_ErrResponseOK = 'OK';
  CREResp_Done = 'Done';
  CREResp_HandleParam = 'Handle';
  CREResp_TextParam = 'Text';
  CREResp_ClassParam = 'Class';
  CREResp_ScreenWidth = 'ScreenWidth';
  CREResp_ScreenHeight = 'ScreenHeight';
  CREResp_CompLeft = 'CompLeft';
  CREResp_CompTop = 'CompTop';
  CREResp_CompWidth = 'CompWidth';
  CREResp_CompHeight = 'CompHeight';


function TestConnection(ARemoteAddress: string): string;
function WaitForServerResponse(ATh: TClientThread; ACallAppProcMsg: Boolean = True): Boolean; //used for requests with custom waiting
function SendTextRequestToServer(AFullLink: string): string;
//function SendFileToServer(AFullLink: string; AFileContent, AResponseStream: TMemoryStream; ACallAppProcMsg: Boolean = True): string; overload; //expose this only if needed
function SendFileToServer(AFullLink: string; AFileContent: TMemoryStream; ACallAppProcMsg: Boolean = True): string; overload;

function ExitRemoteTemplate(ARemoteAddress: string; AStackLevel: Integer): string;  //called by client, to send a request to server to close a tab
function GetAllReplacementVars(ARemoteAddress: string; AStackLevel: Integer): string;
function GetDebugImageFromServer(ARemoteAddress: string; AStackLevel: Integer; AReceivedBmp: TBitmap; AWithGrid: Boolean): string; //returns error message if any
function SendTemplateContentToServer(ARemoteAddress, AFileName: string; var ACustomACSActions: TClkActionsRecArr): string;
function SendLoadTemplateInExecListRequest(ARemoteAddress, AFileName: string; AStackLevel: Integer): string;
function GetServerFileExpectancy(ARemoteAddress: string): string;
function GetFileExistenceOnServer(ARemoteAddress: string; AListOfFiles, AListOfResults: TStringList; AListOfFilesIncludesHashes: Boolean; ADebugParam: string = ''): string; overload;
function GetFileExistenceOnServer(ARemoteAddress: string; AFileName: string; AFileIncludesHash: Boolean; ADebugParam: string = ''): Boolean; overload;

function GetScreenShotImageFromServer(ARemoteAddress: string; AReceivedBmp: TBitmap): string; //returns error message if any
function GetCurrentlyRecordedScreenShotImageFromServer(ARemoteAddress: string; AReceivedBmp: TBitmap): string; //returns error message if any
function GetCompInfoAtPoint(ARemoteAddress: string; X, Y: Integer): string;
function RecordComponentOnServer(ARemoteAddress: string; AHandle: THandle; AComponentContent: TMemoryStream): string;
function ClearInMemFileSystem(ARemoteAddress: string): string;
function SetVariable(ARemoteAddress, AVarName, AVarValue: string; AStackLevel: Integer): string;

function ExecuteClickAction(ARemoteAddress: string; AClickOptions: TClkClickOptions): string;

procedure GetListOfUsedFilesFromLoadedTemplate(var AClkActions: TClkActionsRecArr; AListOfFiles: TStringList);
function SendMissingFilesToServer(ARemoteAddress: string; var AClkActions: TClkActionsRecArr): string;
function SetClientTemplateInServer(ARemoteAddress, AFileName: string; var AClkActions: TClkActionsRecArr; AStackLevel: Integer; ASendFileOnly: Boolean = False): string;


var
  GeneralConnectTimeout: Integer;  //using a global var for this timeout, instead of passing it through all functions
  GeneralClosingApp: Boolean;      //same as GeneralConnectTimeout. This var is set by a form, on destroy.

implementation


uses
  IdHTTP, Forms, ClickerTemplates, InMemFileSystem;


{TClientThread}


procedure TClientThread.Execute;
var
  IdHTTPClient: TIdHTTP;
begin
  try
    IdHTTPClient := TIdHTTP.Create;   //an already created object should be used for "KeepAlive" connections
    try
      IdHTTPClient.ConnectTimeout := FConnectTimeout;
      IdHTTPClient.ReadTimeout := 3600000; //40000;  //1h instead of 40s, to allow debugging or other long Find(Sub)Control waits
      IdHTTPClient.UseNagle := False;

      if FStreamForServer <> nil then
      begin
        FStreamForServer.Position := 0;
        IdHTTPClient.Put(FLink, FStreamForServer, FResponseStream);
        FResult := '';
      end
      else
      begin
        if FResponseStream = nil then
          FResult := IdHTTPClient.Get(FLink)
        else
          IdHTTPClient.Get(FLink, FResponseStream);
      end;
    finally
      IdHTTPClient.Free;
    end;
  except
    on E: Exception do
      FResult := 'Client exception: ' + E.Message;
  end;

  FDone := True;
end;


constructor TClientThread.Create(CreateSuspended: Boolean {$IFDEF FPC}; const StackSize: SizeUInt = DefaultStackSize {$ENDIF});
begin
  inherited Create(CreateSuspended, StackSize);
  FDone := False;
  FResult := '';
  FStreamForServer := nil;
  FResponseStream := nil;
end;


//Set ACallAppProcMsg to False when calling from a different thread
function WaitForServerResponse(ATh: TClientThread; ACallAppProcMsg: Boolean = True): Boolean;
var
  tk: QWord;
begin
  tk := GetTickCount64;
  repeat
    if GeneralClosingApp then
      Break;

    if ACallAppProcMsg then
      Application.ProcessMessages;

    if GeneralClosingApp then
      Break;

    Sleep(2);
  until ATh.FDone or (GetTickCount64 - tk >= 3600000); //1h   a big timeout is required, because of processing stacks

  Result := ATh.FDone;
end;


function SendTextRequestToServer(AFullLink: string): string;
var
  Th: TClientThread;
begin
  Th := TClientThread.Create(True);   //without using thread, the client blocks both this UI and the server's UI, because it doesn't read  - some sort of deadlock
  try
    Th.FLink := AFullLink;
    Th.FConnectTimeout := GeneralConnectTimeout;

    Th.Start;

    WaitForServerResponse(Th);
    Result := Th.FResult;
  finally
    Th.Free;
  end;
end;


function SendGetFileRequestToServer(AFullLink: string; AStream: TMemoryStream): string;
var
  Th: TClientThread;
begin
  Th := TClientThread.Create(True);   //without using thread, the client blocks both this UI and the server's UI, because it doesn't read  - some sort of deadlock
  try
    Th.FLink := AFullLink;
    Th.FConnectTimeout := GeneralConnectTimeout;

    Th.FResponseStream := AStream;
    Th.Start;

    WaitForServerResponse(Th);
    Result := Th.FResult; //IntToStr(Stream.Size); //if debugging, and returning Stream.Size, make sure this result is not used to test for an error message

    AStream.Position := 0;
  finally
    Th.Free;
  end;
end;


function SendGetBmpRequestToServer(AFullLink: string; ABmp: TBitmap): string;
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    Result := SendGetFileRequestToServer(AFullLink, Stream);
    Stream.Position := 0;
    ABmp.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;


//Returns client-side errors in Result and server-side errors in AResponseStream.
function SendFileToServer(AFullLink: string; AFileContent, AResponseStream: TMemoryStream; ACallAppProcMsg: Boolean = True): string; overload;
var
  Th: TClientThread;
begin
  Th := TClientThread.Create(True);   //without using thread, the client blocks both this UI and the server's UI, because it doesn't read  - some sort of deadlock
  try
    Th.FLink := AFullLink;
    Th.FConnectTimeout := GeneralConnectTimeout;

    Th.FStreamForServer := AFileContent;
    Th.FResponseStream := AResponseStream;
    Th.Start;

    WaitForServerResponse(Th, ACallAppProcMsg);
    Result := Th.FResult; //IntToStr(Stream.Size); //if debugging, and returning Stream.Size, make sure this result is not used to test for an error message
  finally
    Th.Free;
  end;
end;


//wrapper over the other SendFileToServer function, which returns all types of errors in result
function SendFileToServer(AFullLink: string; AFileContent: TMemoryStream; ACallAppProcMsg: Boolean = True): string; overload;
var
  ResponseStream: TMemoryStream;
begin
  ResponseStream := TMemoryStream.Create;
  try
    Result := SendFileToServer(AFullLink, AFileContent, ResponseStream, ACallAppProcMsg);

    if Result = '' then
    begin
      ResponseStream.Position := 0;
      SetLength(Result, ResponseStream.Size);
      ResponseStream.Read(Result[1], ResponseStream.Size);
    end;
  finally
    ResponseStream.Free;
  end;
end;


//function ExecuteRemoteActionAtIndex(ARemoteAddress: string; var ACustomACSActions: TClkActionsRecArr; AActionIndex, AStackLevel: Integer; AVarReplacements: TStringList; AIsDebugging: Boolean): Boolean;


function TestConnection(ARemoteAddress: string): string;
begin
  Result := SendTextRequestToServer(ARemoteAddress + CRECmd_TestConnection);
end;


//used while debugging, to close templates which open automatically
function ExitRemoteTemplate(ARemoteAddress: string; AStackLevel: Integer): string;  //called by client, to send a request to server to close a tab
begin
  Result := SendTextRequestToServer(ARemoteAddress + CRECmd_ExitTemplate + '?' +
                                    CREParam_StackLevel + '=' + IntToStr(AStackLevel));
end;


function GetAllReplacementVars(ARemoteAddress: string; AStackLevel: Integer): string;
begin
  Result := SendTextRequestToServer(ARemoteAddress + CRECmd_GetAllReplacementVars + '?' +
                                    CREParam_StackLevel + '=' + IntToStr(AStackLevel));
end;





function GetDebugImageFromServer(ARemoteAddress: string; AStackLevel: Integer; AReceivedBmp: TBitmap; AWithGrid: Boolean): string; //returns error message if any
var
  Link: string;
begin
  Link := ARemoteAddress + CRECmd_GetResultedDebugImage + '?' +
                           CREParam_StackLevel + '=' + IntToStr(AStackLevel) + '&' +
                           CREParam_Grid + '=' + IntToStr(Ord(AWithGrid));

  Result := SendGetBmpRequestToServer(Link, AReceivedBmp);
end;


function SendTemplateContentToServer(ARemoteAddress, AFileName: string; var ACustomACSActions: TClkActionsRecArr): string;
var
  Link: string;
  FileName: string;
  FileContentMem: TMemoryStream;
begin
  if AFileName = '' then
    FileName := CDefaultNoTemplate
  else
    FileName := AFileName;  //use the currently loaded FileName

  Link := ARemoteAddress + CRECmd_SendFileToServer + '?' +
                           CREParam_FileName + '=' + FileName;
                           //maybe, add here a parameter to decide if the file should be saved to disk (on server side)

  FileContentMem := TMemoryStream.Create;
  try
    GetTemplateContentAsMemoryStream(ACustomACSActions, FileContentMem);
    Result := SendFileToServer(Link, FileContentMem);
  finally
    FileContentMem.Free;
  end;
end;


function SendLoadTemplateInExecListRequest(ARemoteAddress, AFileName: string; AStackLevel: Integer): string;
var
  Link: string;
  FileName: string;
begin
  if AFileName = '' then
    FileName := CDefaultNoTemplate
  else
    FileName := AFileName;  //use the currently loaded FileName

  Link := ARemoteAddress + CRECmd_LoadTemplateInExecList + '?' +
                           CREParam_StackLevel + '=' + IntToStr(AStackLevel) + '&' +
                           CREParam_FileName + '=' + FileName;

  Result := SendTextRequestToServer(Link);
end;


function GetServerFileExpectancy(ARemoteAddress: string): string;
begin
  Result := SendTextRequestToServer(ARemoteAddress + CRECmd_GetFileExpectancy + '?' + CREParam_StackLevel + '=0'); //stack level is needed for protocol only
end;


function GetFileExistenceOnServer(ARemoteAddress: string; AListOfFiles, AListOfResults: TStringList; AListOfFilesIncludesHashes: Boolean; ADebugParam: string = ''): string;
var
  Link: string;
  MemStream: TMemoryStream;
  RespStream: TMemoryStream;
  TempListOfFileResults: string;
begin
  Link := ARemoteAddress + CRECmd_GetFileExistenceOnServer;
  Link := Link + '?' + CREParam_VerifyHashes + '=' + IntToStr(Ord(AListOfFilesIncludesHashes)) +
                 '&' + CREParam_DebugParam + '=' + ADebugParam;

  MemStream := TMemoryStream.Create;
  RespStream := TMemoryStream.Create;
  try
    AListOfFiles.SaveToStream(MemStream);
    Result := SendFileToServer(Link, MemStream, RespStream);

    if Result = '' then   //no errors on client side, so return content
    begin
      RespStream.Position := 0;
      SetLength(TempListOfFileResults, RespStream.Size);
      RespStream.Read(TempListOfFileResults[1], RespStream.Size);

      AListOfResults.Text := TempListOfFileResults;
    end;
  finally
    MemStream.Free;
    RespStream.Free;
  end;
end;


function GetFileExistenceOnServer(ARemoteAddress: string; AFileName: string; AFileIncludesHash: Boolean; ADebugParam: string = ''): Boolean; overload;
var
  ListOfFiles, ListOfResults: TStringList;
begin
  ListOfFiles := TStringList.Create;
  ListOfResults := TStringList.Create;
  try
    ListOfFiles.Add(AFileName);

    Result := GetFileExistenceOnServer(ARemoteAddress, ListOfFiles, ListOfResults, AFileIncludesHash, 'OneFile_' + ADebugParam) = '';
    Result := Result and (ListOfResults.Count > 0) and (ListOfResults.Strings[0] = '1');
  finally
    ListOfFiles.Free;
    ListOfResults.Free;
  end;
end;


function GetScreenShotImageFromServer(ARemoteAddress: string; AReceivedBmp: TBitmap): string; //returns error message if any
var
  Link: string;
begin
  Link := ARemoteAddress + CRECmd_GetScreenShotImage + '?' + CREParam_StackLevel + '=0'; //stack level is needed for protocol only

  Result := SendGetBmpRequestToServer(Link, AReceivedBmp);
end;


function GetCurrentlyRecordedScreenShotImageFromServer(ARemoteAddress: string; AReceivedBmp: TBitmap): string; //returns error message if any
var
  Link: string;
begin
  Link := ARemoteAddress + CRECmd_GetCurrentlyRecordedScreenShotImage + '?' + CREParam_StackLevel + '=0'; //stack level is needed for protocol only

  Result := SendGetBmpRequestToServer(Link, AReceivedBmp);
end;


function GetCompInfoAtPoint(ARemoteAddress: string; X, Y: Integer): string;
begin
  Result := SendTextRequestToServer(ARemoteAddress + CRECmd_GetCompInfoAtPoint + '?' +
                                    CREParam_X + '=' + IntToStr(X) + '&' +
                                    CREParam_Y + '=' + IntToStr(Y));
end;


function RecordComponentOnServer(ARemoteAddress: string; AHandle: THandle; AComponentContent: TMemoryStream): string;
begin
  Result := SendGetFileRequestToServer(ARemoteAddress + CRECmd_RecordComponent + '?' +
                                       CREParam_StackLevel + '=0' + '&' +
                                       CREParam_Handle + '=' + IntToStr(AHandle),
                                       AComponentContent);
end;


function ClearInMemFileSystem(ARemoteAddress: string): string;
begin
  Result := SendTextRequestToServer(ARemoteAddress + CRECmd_ClearInMemFileSystem + '?' +
                                    CREParam_StackLevel + '=0');
end;


function SetVariable(ARemoteAddress, AVarName, AVarValue: string; AStackLevel: Integer): string;
begin
  Result := SendTextRequestToServer(ARemoteAddress + CRECmd_SetVariable + '?' +
                                    CREParam_StackLevel + '=' + IntToStr(AStackLevel) + '&' +
                                    CREParam_Var + '=' + AVarName + '&' +
                                    CREParam_Value + '=' + AVarValue);
end;


function ExecuteClickAction(ARemoteAddress: string; AClickOptions: TClkClickOptions): string;
begin
  Result := SendTextRequestToServer(ARemoteAddress + CRECmd_ExecuteClickAction + '?' +
                                    CREParam_StackLevel + '=0' + '&' +   //use the main editor
                                    'XClickPointReference' + '=' + IntToStr(Ord(AClickOptions.XClickPointReference)) + '&' +
                                    'YClickPointReference' + '=' + IntToStr(Ord(AClickOptions.YClickPointReference)) + '&' +
                                    'XClickPointVar' + '=' + AClickOptions.XClickPointVar + '&' +
                                    'YClickPointVar' + '=' + AClickOptions.YClickPointVar + '&' +
                                    'XOffset' + '=' + AClickOptions.XOffset + '&' +
                                    'YOffset' + '=' + AClickOptions.YOffset + '&' +
                                    'MouseButton' + '=' + IntToStr(Ord(AClickOptions.MouseButton)) + '&' +
                                    'ClickWithCtrl' + '=' + IntToStr(Ord(AClickOptions.ClickWithCtrl)) + '&' +
                                    'ClickWithAlt' + '=' + IntToStr(Ord(AClickOptions.ClickWithAlt)) + '&' +
                                    'ClickWithShift' + '=' + IntToStr(Ord(AClickOptions.ClickWithShift)) + '&' +
                                    'ClickWithDoubleClick' + '=' + IntToStr(Ord(AClickOptions.ClickWithDoubleClick)) + '&' +
                                    'Count' + '=' + IntToStr(AClickOptions.Count) + '&' +
                                    'LeaveMouse' + '=' + IntToStr(Ord(AClickOptions.LeaveMouse)) + '&' +
                                    'MoveWithoutClick' + '=' + IntToStr(Ord(AClickOptions.MoveWithoutClick)) + '&' +
                                    'ClickType' + '=' + IntToStr(Ord(AClickOptions.ClickType)) + '&' +
                                    'XClickPointReferenceDest' + '=' + IntToStr(Ord(AClickOptions.XClickPointReferenceDest)) + '&' +
                                    'YClickPointReferenceDest' + '=' + IntToStr(Ord(AClickOptions.YClickPointReferenceDest)) + '&' +
                                    'XClickPointVarDest' + '=' + AClickOptions.XClickPointVarDest + '&' +
                                    'YClickPointVarDest' + '=' + AClickOptions.YClickPointVarDest + '&' +
                                    'XOffsetDest' + '=' + AClickOptions.XOffsetDest + '&' +
                                    'YOffsetDest' + '=' + AClickOptions.YOffsetDest
                                    );
end;


//==============================================================================
//list of bmp files for now, but it can include all other files, which have to be sent to server
procedure GetListOfUsedFilesFromLoadedTemplate(var AClkActions: TClkActionsRecArr; AListOfFiles: TStringList);
var
  i, j: Integer;
  TempStringList: TStringList;
begin
  for i := 0 to Length(AClkActions) - 1 do
    if AClkActions[i].ActionOptions.Action in [acFindControl, acFindSubControl] then
    begin
      TempStringList := TStringList.Create;
      try
        TempStringList.Text := AClkActions[i].FindControlOptions.MatchBitmapFiles;

        for j := 0 to TempStringList.Count - 1 do
          AListOfFiles.Add(TempStringList.Strings[j]);
      finally
        TempStringList.Free;
      end;
    end;
end;


procedure AddHashesToFileNames(AListOfFiles, AListOfFilesWithHashes: TStringList);
var
  i: Integer;
  Fnm, Hash: string;
begin
  for i := 0 to AListOfFiles.Count - 1 do
  begin
    Fnm := AListOfFiles.Strings[i];

    if FileExists(Fnm) then
      Hash := GetFileHash(Fnm)
    else
      Hash := '';

    AListOfFilesWithHashes.Add(AListOfFiles.Strings[i] + CDefaultInMemFileNameHashSeparator + Hash);
  end;
end;


//Sends this template and the bitmaps it might use.
function SendMissingFilesToServer(ARemoteAddress: string; var AClkActions: TClkActionsRecArr): string;
var
  ListOfUsedFiles, ListOfUsedFilesWithHashes, FileExistenceOnServer: TStringList;
  Link: string;
  i: Integer;
  FileContent: TMemoryStream;
begin
  ListOfUsedFiles := TStringList.Create;
  ListOfUsedFilesWithHashes := TStringList.Create;
  FileExistenceOnServer := TStringList.Create;
  try
    GetListOfUsedFilesFromLoadedTemplate(AClkActions, ListOfUsedFiles);
    AddHashesToFileNames(ListOfUsedFiles, ListOfUsedFilesWithHashes);

    Result := GetFileExistenceOnServer(ARemoteAddress, ListOfUsedFiles, FileExistenceOnServer, True, 'SendMissingFilesToServer with used files.');
    if Result = '' then
      for i := 0 to FileExistenceOnServer.Count - 1 do
        if FileExistenceOnServer[i] = '0' then
        begin
          Link := ARemoteAddress + CRECmd_SendFileToServer + '?' +
                                   CREParam_FileName + '=' + ListOfUsedFiles.Strings[i];

          FileContent := TMemoryStream.Create;
          try
            if FileExists(ListOfUsedFiles.Strings[i]) then
            begin
              FileContent.LoadFromFile(ListOfUsedFiles.Strings[i]);
              FileContent.Position := 0;
              Result := Result + 'Sending file: ' + ListOfUsedFiles.Strings[i] + ' -> ' +
                                 SendFileToServer(Link, FileContent) + #13#10;
            end
            else
              Result := Result + 'Cannot send non-existent file: ' + ListOfUsedFiles.Strings[i];
          finally
            FileContent.Free;
          end;
        end;
  finally
    ListOfUsedFiles.Free;
    ListOfUsedFilesWithHashes.Free;
    FileExistenceOnServer.Free;
  end;
end;


function SetClientTemplateInServer(ARemoteAddress, AFileName: string; var AClkActions: TClkActionsRecArr; AStackLevel: Integer; ASendFileOnly: Boolean = False): string;
var
  Hash: string;
  FileContentMem: TMemoryStream;
  FileNameWithHash: string;
begin
  Result := '';

  FileContentMem := TMemoryStream.Create;
  try
    GetTemplateContentAsMemoryStream(AClkActions, FileContentMem);
    Hash := ComputeHash(FileContentMem, FileContentMem.Size);
  finally
    FileContentMem.Free;
  end;

  FileNameWithHash := AFileName + CDefaultInMemFileNameHashSeparator + Hash;
  if not GetFileExistenceOnServer(ARemoteAddress, FileNameWithHash, True, 'SetClientTemplateInServer') then
  begin
    Result := SendTemplateContentToServer(ARemoteAddress, AFileName, AClkActions); //////////////// GetTemplateContentAsMemoryStream is called again in here
    if Pos(CREResp_ReceivedFile, Result) = 0 then
      Exit;
  end;

  if ASendFileOnly then
    Exit;

  Result := SendLoadTemplateInExecListRequest(ARemoteAddress, AFileName, AStackLevel);  //should return CREResp_TemplateLoaded for success
end;


initialization
  GeneralConnectTimeout := 1000;
  GeneralClosingApp := False;

end.

