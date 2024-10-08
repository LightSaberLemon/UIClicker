{
    Copyright (C) 2024 VCC
    creation date: Oct 2022
    initial release date: 30 Oct 2022

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


unit TestUI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TestHTTPAPI, fpcunit, testregistry;

type

  TTestUI = class(TTestHTTPAPI)
  protected
    //procedure SetUp; override;
    //procedure TearDown; override;

    procedure StartAllUIClickerInstances;
    procedure ExecuteTemplateOnTestDriver(ATemplatePath, AFileLocation: string; AAdditionalExpectedVar: string = ''; AAdditionalExpectedValue: string = '');
    procedure ArrangeMainUIClickerWindows;
    procedure ArrangeUIClickerActionWindows;

    procedure LoadTestTemplateInClickerUnderTest(ATestTemplate: string);
    procedure RunTestTemplateInClickerUnderTest(ATestTemplate: string);
    procedure RunTestTemplateInClickerUnderTestWithDebugging(ATestTemplate: string);
    procedure RunTestTemplateInClickerUnderTestWithDebuggingAndStepInto(ATestTemplate, AExpectedStepOverCount: string; AStopAfterSteppingInto: string = '0');

    procedure PrepareClickerUnderTestToReadItsVars;
    procedure PrepareClickerUnderTestToLocalMode;
    procedure PrepareClickerUnderTestToClientMode;

    procedure DragAction_FromPosToPos(ASrcIdx, ADestIdx: Integer; const AActIdx: array of Byte);
    procedure AutoCompleteTextInConsoleEditBox(ATypedEditBoxContent, AFunctionNameToDoubleClick, AExpectedResult: string);
    procedure AddActionButton(AActionNameToSelect: string);
  public
    constructor Create; override;
  published
    procedure BeforeAll_AlwaysExecute;

    procedure Test_ExecuteTemplateRemotely;
    procedure Test_ExecuteTemplateRemotely_WithLoopedCall;
    procedure Test_ExecuteTemplateRemotelyWithDebugging;
    procedure Test_ExecuteTemplateRemotelyWithDebugging_WithLoopedCall;
    procedure Test_ExecuteTemplateRemotelyWithDebugging_AndStepInto;
    procedure Test_ExecuteTemplateRemotelyWithDebugging_WithLoopedCall_AndStepInto;
    procedure Test_ExecuteTemplateRemotelyWithDebugging_AndStepIntoThenStop;
    //procedure Test_ExecuteTemplateRemotelyWithDebugging_WithLoopedCall_AndStepIntoThenStop;

    procedure Test_FindColorErrorFromGradientOnServer_ErrorLevel_SuccessVerbose_NoUpdate;
    procedure Test_FindColorErrorFromGradientOnServer_ErrorCount_SuccessVerbose_NoUpdate;

          //remote execution is disabled for these tests, because the action is not updated, on the server side, by the searching algorithm
          //when/if implemented, these tests should pass
    //procedure Test_ExecuteTemplateRemotely_FindColorErrorFromGradientOnServer_ErrorLevel_SuccessVerbose;
    //procedure Test_ExecuteTemplateRemotely_FindColorErrorFromGradientOnServer_ErrorCount_SuccessVerbose;

    procedure Test_DragAction_FromPos0ToPos4;
    procedure Test_DragAction_FromPos4ToPos0;
    procedure Test_DragAction_FromPos1ToPos4;
    procedure Test_DragAction_FromPos4ToPos1;

    procedure Test_ExecuteTemplateRemotelyWithDebugging_WithLoopedCall_AndStepIntoThenStop;
    procedure Test_ExecuteTemplateRemotelyWithDebugging_ToVerifyIfCallTemplateWorksAfterStopping;

    procedure TestAutoComplete_EmptyEditBox;
    procedure TestAutoComplete_PartialFunctionNameOnly;
    procedure TestAutoComplete_FullFunctionNameOnly;
    procedure TestAutoComplete_VarAssignmentToPartialFunctionNameOnly;
    procedure TestAutoComplete_VarAssignmentToFullFunctionNameOnly;
    procedure TestAutoComplete_VarAssignmentToEmpty;
    procedure TestAutoComplete_VarAssignmentToNumericConstantAndThenDifferentSelection;
    procedure TestAutoComplete_VarAssignmentAndBlanksToPartialFunctionNameOnly;
    procedure TestAutoComplete_VarAssignmentAndBlanksToFullFunctionNameOnly;

    procedure TestAddActionButton_HappyFlow;

    procedure AfterAll_AlwaysExecute;
  end;

{
  This test application uses a second instance of UIClicker, called TestDriver, from TestDriver directory,
  which clicks and types on UIClicker-under-test, to test its UI.
  Depending on desired features, TestDriver may have to be up to date, but nonetheless, in an working state.
  When testing client-server mode, a second pair of UIClicker instances will be required.
  Depending on test, a single TestDriver may be enough to drive two UIClicker-under-test instances.

  This test app is expected to run from UIClicker\Tests\UI
  Other requirements:
  - The UIClicker-Under-Test (client) should allow sending files from \TestDriver\ActionTemplates dir
  - The UIClicker-Under-Test (client) should be configured to connect to 127.0.0.1:5444

  Possible connection diagram:
                             +---- connects to ---------------------------------------------------------+ (read results)
                             |                                                                          |
                             |                                                                         \|/  (temporary in server mode 35444, after executing test template, to provide its vars to UIClickerUITest)
  UIClickerUITest (this app)-+---- connects to ---> TestDriver_1(in server mode) ----- clicks on ----> UIClicker-Under-Test(in client mode or local mode)
                             |                      25444                                                  |
                             |                                                                             | connects to
                             |                                                                             |
                             |                                                                            \|/
                             +---- connects to ---> TestDriver_2(in server mode) ----- clicks on ----> UIClicker-Under-Test(in server mode)
                             |                       15444                                              5444    /|\
                             |                                                                                   |
                             +---. connects to --.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---+ (read results)
}


const
  CTestDriver_ServerPort_ForServerUnderTest = '15444';
  CTestDriver_ServerPort_ForClientUnderTest = '25444';
  CServerUnderTestServerPort = '5444';
  CClientUnderTestServerPort = '35444'; //this is a temporary mode, while UIClickerUITest reads the test results, then sets it back to client mode

  CTestServerAddress = 'http://127.0.0.1:' + CServerUnderTestServerPort + '/';                                //UIClicker-under-test server
  CTestClientAddress = 'http://127.0.0.1:' + CClientUnderTestServerPort + '/';                                //UIClicker-under-test client in server mode
  CTestDriverServerAddress_Server = 'http://127.0.0.1:' + CTestDriver_ServerPort_ForServerUnderTest + '/';    //UIClicker driver  (a different instance of UIClicker, which drives UIClicker-under-test)
  CTestDriverServerAddress_Client = 'http://127.0.0.1:' + CTestDriver_ServerPort_ForClientUnderTest + '/';    //UIClicker driver

  CMinErrorLevelKeyword = 'level';
  CMinErrorCountKeyword = 'count';
  CMinErrorMsgBoxBtn_NoUpdate = 'False';
  CMinErrorMsgBoxBtn_YesUpdate = 'True';


implementation


uses
  ClickerActionsClient, ClickerUtils, {UIActionsStuff,} AsyncProcess, Expectations, Forms, IniFiles;


var  //using global vars instead of class fields, to avoid recreating the objects on every test
  FTestDriverForServer_Proc, FTestDriverForClient_Proc, FServerAppUnderTest_Proc, FClientAppUnderTest_Proc: TAsyncProcess;
  FTemplatesDir: string;
  FIsWine: Boolean;


constructor TTestUI.Create;
begin
  inherited Create;
  TestServerAddress := CTestServerAddress;
end;


//procedure TTestUI.SetUp;
//begin
//  inherited;
//end;
//
//procedure TTestUI.TearDown;
//begin
//  inherited;
//end;


function CreateUIClickerProcess(AExe, AParams: string): TAsyncProcess;
begin
  Result := TAsyncProcess.Create(nil);
  Result.Executable := AExe;
  Result.Parameters.Text := StringReplace(AParams, #32, #13#10, [rfReplaceAll]);
  Result.CurrentDirectory := ExtractFileDir(AExe);
  Result.InheritHandles := False;
  Result.Execute;
end;


procedure SetUIClickerWindowPosition(APathToIni: string; AMainLeft, AMainTop, AActionsLeft, AActionsTop: Integer);  //useful, to preview the interaction
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(APathToIni);
  try
    Ini.WriteInteger('MainWindow', 'Left', AMainLeft);
    Ini.WriteInteger('MainWindow', 'Top', AMainTop);
    Ini.WriteInteger('ActionsWindow', 'Left', AActionsLeft);
    Ini.WriteInteger('ActionsWindow', 'Top', AActionsTop);
  finally
    Ini.Free;
  end;
end;


procedure TTestUI.StartAllUIClickerInstances;
const
  CDisplayTabsOptions: string = ' --AutoSwitchToExecTab Yes --AutoEnableSwitchTabsOnDebugging Yes';
  CSkipSavingSettings: string = ' --SkipSavingSettings Yes';
var
  PathToTestDriver, PathToAppUnderTest: string;
  ServerParams, ClientParams, AppUnderTestServerParams, AppUnderTestClientParams: string;
begin
  PathToTestDriver := ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\UIClicker.exe'; //this should be a stable version of UIClicker
  PathToAppUnderTest := ExtractFilePath(ParamStr(0)) + '..\..\UIClicker.exe';

  {$IFDEF UNIX}
    FIsWine := False;
  {$ELSE}
    FIsWine := {DirectoryExists('Z:\home') and} DirectoryExists('Z:\media') and DirectoryExists('Z:\etc'); //assume this is running on Wine
  {$ENDIF}

  ServerParams := '--SetExecMode Server --ExtraCaption Driver.Server --ServerPort ' + CTestDriver_ServerPort_ForServerUnderTest + CDisplayTabsOptions;
  ClientParams := '--SetExecMode Server --ExtraCaption Driver.Client --ServerPort ' + CTestDriver_ServerPort_ForClientUnderTest + CDisplayTabsOptions;
  AppUnderTestServerParams := '--SetExecMode Server --ExtraCaption ServerUnderTest --ServerPort ' + CServerUnderTestServerPort + CSkipSavingSettings + CDisplayTabsOptions;
  AppUnderTestClientParams := '--SetExecMode Client --ExtraCaption ClientUnderTest --ConnectsTo http://127.0.0.1:' + CServerUnderTestServerPort + '/' + CSkipSavingSettings + CDisplayTabsOptions;

  if FIsWine then
  begin
    SetUIClickerWindowPosition(ExtractFilePath(PathToTestDriver) + 'Clicker.ini', 700, 50, 970, 270);
    Sleep(100);
    FTestDriverForServer_Proc := CreateUIClickerProcess(PathToTestDriver, ServerParams + ' --UseWideStringsOnGetControlText Yes');
    Sleep(1000);

    SetUIClickerWindowPosition(ExtractFilePath(PathToTestDriver) + 'Clicker.ini', 1040, 50, 1000, 300);
    Sleep(100);
    FTestDriverForClient_Proc := CreateUIClickerProcess(PathToTestDriver, ClientParams + ' --UseWideStringsOnGetControlText Yes');
    Sleep(1000);

    SetUIClickerWindowPosition(ExtractFilePath(PathToAppUnderTest) + 'Clicker.ini', 10, 50, 10, 330);
    Sleep(100);
    FServerAppUnderTest_Proc := CreateUIClickerProcess(PathToAppUnderTest, AppUnderTestServerParams + ' --UseWideStringsOnGetControlText Yes');
    Sleep(1000);

    SetUIClickerWindowPosition(ExtractFilePath(PathToAppUnderTest) + 'Clicker.ini', 360, 50, 30, 490);
    Sleep(100);
    FClientAppUnderTest_Proc := CreateUIClickerProcess(PathToAppUnderTest, AppUnderTestClientParams + ' --UseWideStringsOnGetControlText Yes');
    Sleep(1000);
  end
  else
  begin
    FTestDriverForServer_Proc := CreateUIClickerProcess(PathToTestDriver, ServerParams);
    FTestDriverForClient_Proc := CreateUIClickerProcess(PathToTestDriver, ClientParams);
    FServerAppUnderTest_Proc := CreateUIClickerProcess(PathToAppUnderTest, AppUnderTestServerParams);
    FClientAppUnderTest_Proc := CreateUIClickerProcess(PathToAppUnderTest, AppUnderTestClientParams);
  end;
end;


procedure TTestUI.ExecuteTemplateOnTestDriver(ATemplatePath, AFileLocation: string; AAdditionalExpectedVar: string = ''; AAdditionalExpectedValue: string = '');
const
  CSecondExpectedErrMsg = 'Action condition is false.';
var
  Response: string;
  ListOfVars: TStringList;
  CallTemplateOptions: TClkCallTemplateOptions;
begin
  CallTemplateOptions.TemplateFileName := ATemplatePath;
  CallTemplateOptions.ListOfCustomVarsAndValues := '';
  CallTemplateOptions.EvaluateBeforeCalling := False;
  CallTemplateOptions.CallTemplateLoop.Enabled := False;
  CallTemplateOptions.CallTemplateLoop.Direction := ldInc;
  CallTemplateOptions.CallTemplateLoop.EvalBreakPosition := lebpAfterContent;

  Response := FastReplace_87ToReturn(ExecuteCallTemplateAction(CTestDriverServerAddress_Client, CallTemplateOptions, False, False, AFileLocation));

  ListOfVars := TStringList.Create;
  try
    ListOfVars.Text := Response;
    try
      Expect(ListOfVars).WithItem('$ExecAction_Err$').OfValue('', 'No error Allowed in test driver.');
    except
      on E: Exception do
        Expect(ListOfVars).WithItem('$ExecAction_Err$').OfValue(CSecondExpectedErrMsg, 'No error Allowed in test driver.');
    end;

    if AAdditionalExpectedVar <> '' then
      Expect(ListOfVars).WithItem(AAdditionalExpectedVar).OfValue(AAdditionalExpectedValue, 'Additional variable mismatch.');
  finally
    ListOfVars.Free;
  end;
end;


procedure TTestUI.ArrangeMainUIClickerWindows;  //These "arrange windows" calls will have to be replaced with modifying the UIClicker ini files, before executing. This will be required to run tests on Wine.
begin
  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\ArrangeMainUIClickerWindows.clktmpl', CREParam_FileLocation_ValueDisk);
end;


procedure TTestUI.ArrangeUIClickerActionWindows;
begin
  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\ArrangeActionWindowsUnderTest.clktmpl', CREParam_FileLocation_ValueDisk);
end;


procedure SetVariableOnTestDriverClient(AVarName, AVarValue: string; AEvalVarBefore: Boolean = False);
var
  SetVarOptions: TClkSetVarOptions;
  SetVarResult: TStringList;
  RawResult: string;
begin
  SetVarOptions.ListOfVarNames := AVarName;
  SetVarOptions.ListOfVarValues := AVarValue;
  SetVarOptions.ListOfVarEvalBefore := Chr(48 + Ord(AEvalVarBefore));

  SetVarResult := TStringList.Create;
  try
    RawResult := ExecuteSetVarAction(CTestDriverServerAddress_Client, SetVarOptions);
    SetVarResult.Text := FastReplace_87ToReturn(RawResult); //this is the test "driver" for client 25444
    Expect(SetVarResult).WithItem(AVarName).OfValue(AVarValue, 'Expected a particular var value.');
  finally
    SetVarResult.Free;
  end;
end;


procedure WaitForDriverStartup;
var
  TestResult: string;
  tk: QWord;
begin
  tk := GetTickCount64;
  repeat
    TestResult := TestConnection(CTestDriverServerAddress_Client, False);
  until (TestResult = CREResp_ConnectionOK) or (GetTickCount64 - tk > 3000);
end;


procedure TTestUI.BeforeAll_AlwaysExecute;
begin
  StartAllUIClickerInstances;

  WaitForDriverStartup;

  try
    if FIsWine then
    begin
      GeneralConnectTimeout := 10000;
      SetVariableOnTestDriverClient('$IsAdminOnWine$', '  [Is admin]');
      Application.MainForm.Caption := Application.MainForm.Caption  + '  $IsAdminOnWine$';
    end
    else
      SetVariableOnTestDriverClient('$IsAdminOnWine$', ''); // a single #13#10 results in an empty string item in a TStringList. Still, better send '', to allow the expectation to match ''. UIClicker should convert this one '', into a new line.
  except
    on E: Exception do
      raise Exception.Create('Please verify if UIClicker is built for testing (including the test driver). ' + E.Message);
  end;

  ArrangeMainUIClickerWindows;      //Setting window position from ini file, works on Wine. Setting from UIClicker does not (yet).
  Sleep(500);                       //these sleep calls should be replaced by some waiting loops
  ArrangeUIClickerActionWindows;
  Sleep(500);

  FTemplatesDir := ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\';
end;


procedure TTestUI.LoadTestTemplateInClickerUnderTest(ATestTemplate: string);
begin
  SetVariableOnTestDriverClient('$TemplateToLoad$', FTemplatesDir + ATestTemplate);
  ExecuteTemplateOnTestDriver(FTemplatesDir + 'LoadCallerTemplateIntoAppUnderTest.clktmpl', CREParam_FileLocation_ValueDisk); //this loads BasicCaller into test client (the one which is in client mode)
end;


procedure TTestUI.RunTestTemplateInClickerUnderTest(ATestTemplate: string);
begin
  LoadTestTemplateInClickerUnderTest(ATestTemplate);
  ExecuteTemplateOnTestDriver(FTemplatesDir + 'PlayAllActionsFromAppUnderTest.clktmpl', CREParam_FileLocation_ValueDisk);
end;


procedure TTestUI.RunTestTemplateInClickerUnderTestWithDebugging(ATestTemplate: string);
begin
  LoadTestTemplateInClickerUnderTest(ATestTemplate);
  ExecuteTemplateOnTestDriver(FTemplatesDir + 'PlayAllActionsFromAppUnderTestWithDebugging.clktmpl', CREParam_FileLocation_ValueDisk);
end;


procedure TTestUI.RunTestTemplateInClickerUnderTestWithDebuggingAndStepInto(ATestTemplate, AExpectedStepOverCount: string; AStopAfterSteppingInto: string = '0');
begin
  SetVariableOnTestDriverClient('$ExpectedStepOverCount$', AExpectedStepOverCount); //how many times to click "Step Over" in the called template
  SetVariableOnTestDriverClient('$StopAfterSteppingInto$', AStopAfterSteppingInto);
  LoadTestTemplateInClickerUnderTest(ATestTemplate);
  ExecuteTemplateOnTestDriver(FTemplatesDir + 'PlayAllActionsFromAppUnderTestWithDebuggingAndSteppingInto.clktmpl', CREParam_FileLocation_ValueDisk);
end;


procedure TTestUI.PrepareClickerUnderTestToReadItsVars;
begin
  //Set $ExtraCaption$ variable in Client Driver, to 'ClientUnderTest', which is required by SetExecutionModeOnAppUnderTest.clktmpl
  SetVariableOnTestDriverClient('$ExtraCaption$', 'ClientUnderTest');    //even after executing SetExecModeToServer.clktmpl, the caption should stay 'ClientUnderTest'
  SetVariableOnTestDriverClient('$ListeningPort$', CClientUnderTestServerPort);
  ExecuteTemplateOnTestDriver(FTemplatesDir + 'SetExecModeToServer.clktmpl', CREParam_FileLocation_ValueDisk);
end;


procedure TTestUI.PrepareClickerUnderTestToLocalMode;
begin
  //Set $ExtraCaption$ variable in Client Driver, to 'ClientUnderTest', which is required by SetExecutionModeOnAppUnderTest.clktmpl
  SetVariableOnTestDriverClient('$ExtraCaption$', 'ClientUnderTest');    //even after executing SetExecModeToServer.clktmpl, the caption should stay 'ClientUnderTest'
  ExecuteTemplateOnTestDriver(FTemplatesDir + 'SetExecModeToLocal.clktmpl', CREParam_FileLocation_ValueDisk);
end;


procedure TTestUI.PrepareClickerUnderTestToClientMode;
begin
  //Set $ExtraCaption$ variable in Client Driver, to 'ClientUnderTest', which is required by SetExecutionModeOnAppUnderTest.clktmpl
  SetVariableOnTestDriverClient('$ExtraCaption$', 'ClientUnderTest');    //even after executing SetExecModeToServer.clktmpl, the caption should stay 'ClientUnderTest'
  ExecuteTemplateOnTestDriver(FTemplatesDir + 'SetExecModeToClient.clktmpl', CREParam_FileLocation_ValueDisk);
end;


procedure TTestUI.Test_ExecuteTemplateRemotely;
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTest('BasicCaller.clktmpl');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('1');  //this var is initialized to 0 in BasicCaller.clktmpl
  finally
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_ExecuteTemplateRemotely_WithLoopedCall;
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTest('BasicLoopedCaller.clktmpl');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('10');  //this var is initialized to 0 in BasicCaller.clktmpl
  finally
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_ExecuteTemplateRemotelyWithDebugging;
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTestWithDebugging('BasicCaller.clktmpl');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('1');  //this var is initialized to 0 in BasicCaller.clktmpl
  finally
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_ExecuteTemplateRemotelyWithDebugging_WithLoopedCall;
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTestWithDebugging('BasicLoopedCaller.clktmpl');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('10');  //this var is initialized to 0 in BasicCaller.clktmpl
  finally
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_ExecuteTemplateRemotelyWithDebugging_AndStepInto;
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTestWithDebuggingAndStepInto('BasicCaller.clktmpl', '1');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('1');  //this var is initialized to 0 in BasicCaller.clktmpl
  finally
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_ExecuteTemplateRemotelyWithDebugging_WithLoopedCall_AndStepInto;
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTestWithDebuggingAndStepInto('BasicLoopedCaller.clktmpl', '10');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('10');  //this var is initialized to 0 in BasicCaller.clktmpl
  finally
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_ExecuteTemplateRemotelyWithDebugging_AndStepIntoThenStop;
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTestWithDebuggingAndStepInto('BasicCaller.clktmpl', '1', '1');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('0');  //this var is initialized to 0 in BasicCaller.clktmpl
  finally                                                      //expecting 0 if stopped
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_ExecuteTemplateRemotelyWithDebugging_WithLoopedCall_AndStepIntoThenStop;
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTestWithDebuggingAndStepInto('BasicLoopedCaller.clktmpl', '10', '1');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('0', '$VarToBeIncremented$ should be reset to 0.  $DbgPlayAllActions$ is ' + GetVarValueFromServer('$DbgPlayAllActions$'));  //this var is initialized to 0 in BasicCaller.clktmpl
  finally                                                      //expecting 0 if stopped
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_ExecuteTemplateRemotelyWithDebugging_ToVerifyIfCallTemplateWorksAfterStopping;  //this is a combination of above AndStepIntoThenStop and WithLoopedCall_AndStepIntoThenStop
begin
  PrepareClickerUnderTestToClientMode;

  TestServerAddress := CTestDriverServerAddress_Client;
  RunTestTemplateInClickerUnderTestWithDebuggingAndStepInto('BasicCaller.clktmpl', '1', '1');
  RunTestTemplateInClickerUnderTestWithDebuggingAndStepInto('BasicLoopedCaller.clktmpl', '10', '1');
  PrepareClickerUnderTestToReadItsVars;

  Sleep(500);

  TestServerAddress := CTestClientAddress;
  try
    //connect to ClientUnderTest instance, which is now running in server mode and read its variables
    Expect(GetVarValueFromServer('$VarToBeIncremented$')).ToBe('0', '$VarToBeIncremented$ should be reset to 0.  $DbgPlayAllActions$ is ' + GetVarValueFromServer('$DbgPlayAllActions$'));  //this var is initialized to 0 in BasicCaller.clktmpl
  finally                                                      //expecting 0 if stopped
    TestServerAddress := CTestDriverServerAddress_Client; //restore
  end;
end;


procedure TTestUI.Test_FindColorErrorFromGradientOnServer_ErrorLevel_SuccessVerbose_NoUpdate;
begin
  TestServerAddress := CTestDriverServerAddress_Client;

  PrepareClickerUnderTestToLocalMode;
  RunTestTemplateInClickerUnderTest('FindColorErrorFromGradientOnServer.clktmpl');

  SetVariableOnTestDriverClient('$SearchResult$', 'False');
  SetVariableOnTestDriverClient('$CalcItem$', 'Calculate minimum color error ' + CMinErrorLevelKeyword + ' to match bitmap...');
  SetVariableOnTestDriverClient('$ExpectedColorErrorMsg$', 'A color error ' + CMinErrorLevelKeyword + ' found');
  SetVariableOnTestDriverClient('$MsgBoxButtonEval$', CMinErrorMsgBoxBtn_NoUpdate);

  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\FindMinErrorLevel.clktmpl',
                              CREParam_FileLocation_ValueDisk,
                              '$SearchResult$',
                              'True'
                              );
  PrepareClickerUnderTestToReadItsVars;
end;


procedure TTestUI.Test_FindColorErrorFromGradientOnServer_ErrorCount_SuccessVerbose_NoUpdate;
begin
  TestServerAddress := CTestDriverServerAddress_Client;

  PrepareClickerUnderTestToLocalMode;
  RunTestTemplateInClickerUnderTest('FindColorErrorFromGradientOnServer.clktmpl');

  SetVariableOnTestDriverClient('$SearchResult$', 'False');
  SetVariableOnTestDriverClient('$CalcItem$', 'Calculate minimum color error ' + CMinErrorCountKeyword + ' to match bitmap...');
  SetVariableOnTestDriverClient('$ExpectedColorErrorMsg$', 'A color error ' + CMinErrorCountKeyword + ' found');
  SetVariableOnTestDriverClient('$MsgBoxButtonEval$', CMinErrorMsgBoxBtn_NoUpdate);

  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\FindMinErrorLevel.clktmpl',
                              CREParam_FileLocation_ValueDisk,
                              '$SearchResult$',
                              'True'
                              );
  PrepareClickerUnderTestToReadItsVars;
end;


//procedure TTestUI.Test_ExecuteTemplateRemotely_FindColorErrorFromGradientOnServer_ErrorLevel_SuccessVerbose_NoUpdate;
//begin
//  TestServerAddress := CTestDriverServerAddress_Client;
//  PrepareClickerUnderTestToClientMode;
//  RunTestTemplateInClickerUnderTest('FindColorErrorFromGradientOnServer.clktmpl');
//
//  SetVariableOnTestDriverClient('$SearchResult$', 'False');
//  SetVariableOnTestDriverClient('$CalcItem$', 'Calculate minimum color error ' + CMinErrorLevelKeyword + ' to match bitmap...');
//  SetVariableOnTestDriverClient('$ExpectedColorErrorMsg$', 'A color error ' + CMinErrorLevelKeyword + ' found');
//  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\FindMinErrorLevel.clktmpl',
                              // CREParam_FileLocation_ValueDisk,
                              //'$SearchResult$',
                              //'True'
                              //);
//
//  SetVariableOnTestDriverClient('$MsgBoxButtonEval$', CMinErrorMsgBoxBtn_NoUpdate);
//
//  PrepareClickerUnderTestToReadItsVars;
//end;
//
//
//procedure TTestUI.Test_ExecuteTemplateRemotely_FindColorErrorFromGradientOnServer_ErrorCount_SuccessVerbose_NoUpdate;
//begin
//  TestServerAddress := CTestDriverServerAddress_Client;
//  PrepareClickerUnderTestToClientMode;
//  RunTestTemplateInClickerUnderTest('FindColorErrorFromGradientOnServer.clktmpl');
//
//  SetVariableOnTestDriverClient('$SearchResult$', 'False');
//  SetVariableOnTestDriverClient('$CalcItem$', 'Calculate minimum color error ' + CMinErrorCountKeyword + ' to match bitmap...');
//  SetVariableOnTestDriverClient('$ExpectedColorErrorMsg$', 'A color error ' + CMinErrorCountKeyword + ' found');
//  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\FindMinErrorLevel.clktmpl',
                            //  CREParam_FileLocation_ValueDisk,
                            //'$SearchResult$',
                            //'True'
                            //);
//
//  SetVariableOnTestDriverClient('$MsgBoxButtonEval$', CMinErrorMsgBoxBtn_NoUpdate);
//
//  PrepareClickerUnderTestToReadItsVars;
//end;


procedure TTestUI.DragAction_FromPosToPos(ASrcIdx, ADestIdx: Integer; const AActIdx: array of Byte);
const
  CActionNamesToDrag: array[0..4] of string = ('"ExecApp"', '"FindControl"', '"FindSubControl"', '"SetControlText"', '"Sleep"');
var
  i: Integer;
begin
  TestServerAddress := CTestDriverServerAddress_Client;
  LoadTestTemplateInClickerUnderTest('ActionsToDrag.clktmpl');

  PrepareClickerUnderTestToLocalMode;
  SetVariableOnTestDriverClient('$SearchResult$', 'False');
  SetVariableOnTestDriverClient('$SourceAction$', CActionNamesToDrag[ASrcIdx]);
  SetVariableOnTestDriverClient('$DestinationAction$', CActionNamesToDrag[ADestIdx]);

  for i := 0 to 4 do
    SetVariableOnTestDriverClient('$Act' +  IntToStr(i) + '$', CActionNamesToDrag[AActIdx[i]]);

  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\DragActionOnAppUnderTest.clktmpl',
                              CREParam_FileLocation_ValueDisk,
                              '$SearchResult$',
                              'True'
                              );
  PrepareClickerUnderTestToReadItsVars;
end;


procedure TTestUI.Test_DragAction_FromPos0ToPos4;
begin
  DragAction_FromPosToPos(0, 4, [1, 2, 3, 4, 0]);
end;


procedure TTestUI.Test_DragAction_FromPos4ToPos0;
begin
  DragAction_FromPosToPos(4, 0, [4, 0, 1, 2, 3]);
end;


procedure TTestUI.Test_DragAction_FromPos1ToPos4;
begin
  DragAction_FromPosToPos(1, 4, [0, 2, 3, 4, 1]);
end;


procedure TTestUI.Test_DragAction_FromPos4ToPos1;
begin
  DragAction_FromPosToPos(4, 1, [0, 4, 1, 2, 3]);
end;


procedure TTestUI.AutoCompleteTextInConsoleEditBox(ATypedEditBoxContent, AFunctionNameToDoubleClick, AExpectedResult: string);
begin
  TestServerAddress := CTestDriverServerAddress_Client;

  PrepareClickerUnderTestToLocalMode;

  if Pos('$', ATypedEditBoxContent) > 0 then
  begin
    SetVariableOnTestDriverClient('$AutoCompleteTextToType_Part1$', Copy(ATypedEditBoxContent, 1, Pos('$', ATypedEditBoxContent)));
    SetVariableOnTestDriverClient('$AutoCompleteTextToType_Part2$', Copy(ATypedEditBoxContent, Pos('$', ATypedEditBoxContent) + 1, MaxInt));
  end
  else
  begin
    SetVariableOnTestDriverClient('$AutoCompleteTextToType_Part2$', '');
    SetVariableOnTestDriverClient('$AutoCompleteTextToType_Part1$', ATypedEditBoxContent);
  end;

  SetVariableOnTestDriverClient('$FuncNameToDoubleClick$', AFunctionNameToDoubleClick);

  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\AutoCompleteTextOnAppUnderTest.clktmpl',
                              CREParam_FileLocation_ValueDisk,
                              '$Control_Text$',
                              AExpectedResult
                              );
  PrepareClickerUnderTestToReadItsVars;
end;


procedure TTestUI.TestAutoComplete_EmptyEditBox;
begin
  AutoCompleteTextInConsoleEditBox('', 'ExtractFileName(<PathToFile>)', '$ExtractFileName(<PathToFile>)$');
end;


procedure TTestUI.TestAutoComplete_PartialFunctionNameOnly;
begin
  AutoCompleteTextInConsoleEditBox('Get', 'GetActionProperties()', '$GetActionProperties()$');
end;


procedure TTestUI.TestAutoComplete_FullFunctionNameOnly;
begin
  AutoCompleteTextInConsoleEditBox('GetActionProperties', 'GetActionProperties()', '$GetActionProperties()$');
end;


procedure TTestUI.TestAutoComplete_VarAssignmentToPartialFunctionNameOnly;
begin
  AutoCompleteTextInConsoleEditBox('$a$=$Get', 'GetActionProperties()', '$a$=$GetActionProperties()$');
end;


procedure TTestUI.TestAutoComplete_VarAssignmentToFullFunctionNameOnly;
begin
  AutoCompleteTextInConsoleEditBox('$a$=$GetActionProperties', 'GetActionProperties()', '$a$=$GetActionProperties()$');
end;


procedure TTestUI.TestAutoComplete_VarAssignmentToEmpty;
begin
  AutoCompleteTextInConsoleEditBox('$a$=', 'GetActionProperties()', '$a$=$GetActionProperties()$');
end;


procedure TTestUI.TestAutoComplete_VarAssignmentToNumericConstantAndThenDifferentSelection;
begin
  AutoCompleteTextInConsoleEditBox('$Desktop_Width$=1920', 'Screen_Width$=1920', '$Desktop_Width$=1920$Screen_Width$=1920');
end;


procedure TTestUI.TestAutoComplete_VarAssignmentAndBlanksToPartialFunctionNameOnly;
begin
  AutoCompleteTextInConsoleEditBox('$a$ = $Get', 'GetActionProperties()', '$a$ = $GetActionProperties()$');
end;


procedure TTestUI.TestAutoComplete_VarAssignmentAndBlanksToFullFunctionNameOnly;
begin
  AutoCompleteTextInConsoleEditBox('$a$ = $GetActionProperties', 'GetActionProperties()', '$a$ = $GetActionProperties()$');
end;


procedure TTestUI.AddActionButton(AActionNameToSelect: string);
begin
  TestServerAddress := CTestDriverServerAddress_Client;
  LoadTestTemplateInClickerUnderTest('DuplicateActionFromAddActionButton.clktmpl');

  PrepareClickerUnderTestToLocalMode;
  SetVariableOnTestDriverClient('$ActionNameToSelect$', AActionNameToSelect);

  ExecuteTemplateOnTestDriver(ExtractFilePath(ParamStr(0)) + '..\..\TestDriver\ActionTemplates\AddActionButtonOnAppUnderTest.clktmpl',
                              CREParam_FileLocation_ValueDisk,
                              '$LastAction_Status$',
                              'Successful'
                              );
  PrepareClickerUnderTestToReadItsVars;
end;


procedure TTestUI.TestAddActionButton_HappyFlow;
begin
  AddActionButton('GenerateAndSaveTree');
end;


procedure TTestUI.AfterAll_AlwaysExecute;
begin
  //the following instances should be terminated in this specific order:
  FClientAppUnderTest_Proc.Terminate(0);
  FServerAppUnderTest_Proc.Terminate(0);
  FTestDriverForClient_Proc.Terminate(0);
  FTestDriverForServer_Proc.Terminate(0);

  FreeAndNil(FClientAppUnderTest_Proc);
  FreeAndNil(FServerAppUnderTest_Proc);
  FreeAndNil(FTestDriverForClient_Proc);
  FreeAndNil(FTestDriverForServer_Proc);
end;


initialization

  RegisterTest(TTestUI);
end.

