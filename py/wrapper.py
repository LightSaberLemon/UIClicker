#   Copyright (C) 2022 VCC
#   creation date: Jul 2022
#   initial release date: 26 Jul 2022
#
#   author: VCC
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"),
#   to deal in the Software without restriction, including without limitation
#   the rights to use, copy, modify, merge, publish, distribute, sublicense,
#   and/or sell copies of the Software, and to permit persons to whom the
#   Software is furnished to do so, subject to the following conditions:
#   The above copyright notice and this permission notice shall be included
#   in all copies or substantial portions of the Software.
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
#   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
#   OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import sys
import ctypes
import ctypes.wintypes  #without importing wintypes, python crashes when calling functions like TestConnectionToServerFunc
from ctypes.wintypes import LPCSTR, LPCWSTR, BYTE, BOOLEAN, LONG
from UIClickerTypes import *
from UIClickerTypes import TClickOptions

DllHandle = ctypes.CDLL("..\\ClickerClient\\ClickerClient.dll")  #CDLL is used for cdecl.   WinDLL is used for stdcall (and uses WINFUNCTYPE).

CMaxSharedStringLength = 10 * 1048576; #10MB


def GetInitClickerClient():
    InitClickerClientProto = ctypes.CFUNCTYPE(None)
    InitClickerClientParams = ()
    InitClickerClientFuncRes = InitClickerClientProto(("InitClickerClient", DllHandle), InitClickerClientParams)
    return InitClickerClientFuncRes


def GetDoneClickerClient():
    DoneClickerClientProto = ctypes.CFUNCTYPE(None)
    DoneClickerClientParams = ()
    DoneClickerClientFuncRes = DoneClickerClientProto(("DoneClickerClient", DllHandle), DoneClickerClientParams)
    return DoneClickerClientFuncRes
 

def GetSetServerAddress():
    #SetServerAddressProto = ctypes.CFUNCTYPE(None, ctypes.c_char_p) #the SetServerAddress function returns void
    SetServerAddressProto = ctypes.CFUNCTYPE(None, LPCWSTR)
    SetServerAddressParams = (1, "AAddress", 0),
    SetServerAddressFuncRes = SetServerAddressProto(("SetServerAddress", DllHandle), SetServerAddressParams)
    return SetServerAddressFuncRes

       
def GetGetServerAddress():
    GetServerAddressProto = ctypes.CFUNCTYPE(LONG, ctypes.c_char_p)
    GetServerAddressParams = (1, "AResponse", 0),
    GetServerAddressFuncRes = GetServerAddressProto(("GetServerAddress", DllHandle), GetServerAddressParams)
    return GetServerAddressFuncRes


def GetTestConnectionToServerAddress():
    TestConnectionToServerProto = ctypes.CFUNCTYPE(LONG, ctypes.c_char_p)
    TestConnectionToServerParams = (1, "AResponse", 0),
    TestConnectionToServerFuncRes = TestConnectionToServerProto(("TestConnectionToServer", DllHandle), TestConnectionToServerParams)
    return TestConnectionToServerFuncRes


def GetCreateNewTemplate():
    CreateNewTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR)
    CreateNewTemplateParams = (1, "ATemplateFileName", 0),
    CreateNewTemplateFuncRes = CreateNewTemplateProto(("CreateNewTemplate", DllHandle), CreateNewTemplateParams)
    return CreateNewTemplateFuncRes
    
        
def GetAddClickActionToTemplate():
    AddClickActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PClickOptions)
    AddClickActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "AClickOptions", 0),
    AddClickActionToTemplateFuncRes = AddClickActionToTemplateProto(("AddClickActionToTemplate", DllHandle), AddClickActionToTemplateParams)
    return AddClickActionToTemplateFuncRes


def GetAddExecAppActionToTemplate():
    AddExecAppActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PExecAppOptions)
    AddExecAppActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "AExecAppOptions", 0),
    AddExecAppActionToTemplateFuncRes = AddExecAppActionToTemplateProto(("AddExecAppActionToTemplate", DllHandle), AddExecAppActionToTemplateParams)
    return AddExecAppActionToTemplateFuncRes


def GetAddFindControlActionToTemplate():
    AddFindControlActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PFindControlOptions)
    AddFindControlActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "AFindControlOptions", 0),
    AddFindControlActionToTemplateFuncRes = AddFindControlActionToTemplateProto(("AddFindControlActionToTemplate", DllHandle), AddFindControlActionToTemplateParams)
    return AddFindControlActionToTemplateFuncRes


def GetAddFindSubControlActionToTemplate():
    AddFindSubControlActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PFindControlOptions)
    AddFindSubControlActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "AFindControlOptions", 0),
    AddFindSubControlActionToTemplateFuncRes = AddFindSubControlActionToTemplateProto(("AddFindSubControlActionToTemplate", DllHandle), AddFindSubControlActionToTemplateParams)
    return AddFindSubControlActionToTemplateFuncRes
    
    
def GetAddSetControlTextActionToTemplate():
    AddSetControlTextActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PSetControlTextOptions)
    AddSetControlTextActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "ASetControlTextOptions", 0),
    AddSetControlTextActionToTemplateFuncRes = AddSetControlTextActionToTemplateProto(("AddSetControlTextActionToTemplate", DllHandle), AddSetControlTextActionToTemplateParams)
    return AddSetControlTextActionToTemplateFuncRes


def GetAddCallTemplateActionToTemplate():
    AddCallTemplateActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PCallTemplateOptions)
    AddCallTemplateActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "ACallTemplateOptions", 0),
    AddCallTemplateActionToTemplateFuncRes = AddCallTemplateActionToTemplateProto(("AddCallTemplateActionToTemplate", DllHandle), AddCallTemplateActionToTemplateParams)
    return AddCallTemplateActionToTemplateFuncRes


def GetAddSleepActionToTemplate():
    AddSleepActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PSleepOptions)
    AddSleepActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "ASleepOptions", 0),
    AddSleepActionToTemplateFuncRes = AddSleepActionToTemplateProto(("AddSleepActionToTemplate", DllHandle), AddSleepActionToTemplateParams)
    return AddSleepActionToTemplateFuncRes


def GetAddSetVarActionToTemplate():
    AddSetVarActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PSetVarOptions)
    AddSetVarActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "ASetVarOptions", 0),
    AddSetVarActionToTemplateFuncRes = AddSetVarActionToTemplateProto(("AddSetVarActionToTemplate", DllHandle), AddSetVarActionToTemplateParams)
    return AddSetVarActionToTemplateFuncRes


def GetAddWindowOperationsActionToTemplate():
    AddWindowOperationsActionToTemplateProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LPCWSTR, LONG, BOOLEAN, LPCWSTR, PWindowOperationsOptions)
    AddWindowOperationsActionToTemplateParams = (1, "ATemplateFileName", 0), (1, "AActionName", 0), (1, "AActionTimeout", 0), (1, "AActionEnabled", 0), (1, "AActionCondition", 0), (1, "AWindowOperationsOptions", 0),
    AddWindowOperationsActionToTemplateFuncRes = AddWindowOperationsActionToTemplateProto(("AddWindowOperationsActionToTemplate", DllHandle), AddWindowOperationsActionToTemplateParams)
    return AddWindowOperationsActionToTemplateFuncRes


def GetAddFontProfileToFindSubControlAction():
    AddFontProfileToFindSubControlActionProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, LONG, PClkFindControlMatchBitmapText)
    AddFontProfileToFindSubControlActionParams = (1, "ATemplateFileName", 0), (1, "AActionIndex", 0), (1, "AFindControlMatchBitmapText", 0),
    AddFontProfileToFindSubControlActionFuncRes = AddFontProfileToFindSubControlActionProto(("AddFontProfileToFindSubControlAction", DllHandle), AddFontProfileToFindSubControlActionParams)
    return AddFontProfileToFindSubControlActionFuncRes


def GetPrepareFilesInServer():
    PrepareFilesInServerProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, ctypes.c_char_p)
    PrepareFilesInServerParams = (1, "ATemplateFileName", 0), (1, "AResponse", 0),
    PrepareFilesInServerFuncRes = PrepareFilesInServerProto(("PrepareFilesInServer", DllHandle), PrepareFilesInServerParams)
    return PrepareFilesInServerFuncRes


def GetGetListOfFilesFromClientInMem():
    GetListOfFilesFromClientInMemProto = ctypes.CFUNCTYPE(LONG, ctypes.c_char_p)
    GetListOfFilesFromClientInMemParams = (1, "AResponse", 0),
    GetListOfFilesFromClientInMemFuncRes = GetListOfFilesFromClientInMemProto(("GetListOfFilesFromClientInMem", DllHandle), GetListOfFilesFromClientInMemParams)
    return GetListOfFilesFromClientInMemFuncRes


def GetGetTemplateContentFromClientInMemAsString():
    GetTemplateContentFromClientInMemAsStringProto = ctypes.CFUNCTYPE(LONG, LPCWSTR, ctypes.c_char_p)
    GetTemplateContentFromClientInMemAsStringParams = (1, "ATemplateFileName", 0), (1, "AResponse", 0),
    GetTemplateContentFromClientInMemAsStringFuncRes = GetTemplateContentFromClientInMemAsStringProto(("GetTemplateContentFromClientInMemAsString", DllHandle), GetTemplateContentFromClientInMemAsStringParams)
    return GetTemplateContentFromClientInMemAsStringFuncRes
   
        
class TDllFunctions:
    def __init__(self):
        self.InitClickerClientFunc = GetInitClickerClient()
        self.DoneClickerClientFunc = GetDoneClickerClient()
        
        self.SetServerAddressFunc = GetSetServerAddress()
        self.GetServerAddressFunc = GetGetServerAddress()
        self.TestConnectionToServerFunc = GetTestConnectionToServerAddress()
        self.CreateNewTemplateFunc = GetCreateNewTemplate()
        
        self.AddClickActionToTemplateFunc = GetAddClickActionToTemplate()
        self.AddExecAppActionToTemplateFunc = GetAddExecAppActionToTemplate()
        self.AddFindControlActionToTemplateFunc = GetAddFindControlActionToTemplate()
        self.AddFindSubControlActionToTemplateFunc = GetAddFindSubControlActionToTemplate()
        self.AddSetControlTextActionToTemplateFunc = GetAddSetControlTextActionToTemplate()
        self.AddCallTemplateActionToTemplateFunc = GetAddCallTemplateActionToTemplate()
        self.AddSleepActionToTemplateFunc = GetAddSleepActionToTemplate()
        self.AddSetVarActionToTemplateFunc = GetAddSetVarActionToTemplate()
        self.AddWindowOperationsActionToTemplateFunc = GetAddWindowOperationsActionToTemplate()
        
        self.AddFontProfileToFindSubControlActionFunc = GetAddFontProfileToFindSubControlAction()
        
        self.PrepareFilesInServerFunc = GetPrepareFilesInServer()
        self.GetListOfFilesFromClientInMemFunc = GetGetListOfFilesFromClientInMem()
        self.GetTemplateContentFromClientInMemAsStringFunc = GetGetTemplateContentFromClientInMemAsString()
        
    def InitClickerClient(self):
        try:
            self.InitClickerClientFunc()
            return 'OK'
        except:
            return 'AV on InitClickerClient'
    
    
    def DoneClickerClient(self):
        try:
            self.DoneClickerClientFunc()
            return 'OK'
        except:
            return 'AV on DoneClickerClient'
        
    def SetServerAddress(self, Address):
        try:
            self.SetServerAddressFunc(Address)  #sending PWideChar, and converting to ANSI at dll
            return 'OK'
        except:
            return 'AV on SetServerAddress'
            
    
    def GetServerAddress(self):
        try:
            buffer = ctypes.create_string_buffer(10 * 1048576) # #(CMaxSharedStringLength)
            ResponsePtr = buffer[0] #ctypes.c_char_p(buffer[0])  #address of first byte in the buffer
            RespLen = self.GetServerAddressFunc(ResponsePtr)
            
            Response = ctypes.string_at(ResponsePtr, RespLen)
            return Response
        except:
            return 'AV on GetServerAddress'
            
            
    def TestConnectionToServer(self):
        try:
            buffer = ctypes.create_string_buffer(10 * 1048576) # #(CMaxSharedStringLength)
            ResponsePtr = buffer[0] #ctypes.c_char_p(buffer[0])  #address of first byte in the buffer
            RespLen = self.TestConnectionToServerFunc(ResponsePtr)
            
            Response = ctypes.string_at(ResponsePtr, RespLen)
            return Response
        except:
            return 'AV on TestConnectionToServer'
    
    
    def CreateNewTemplate(self, ATemplateFileName):
        try:
            CreateInMemFileResult = self.CreateNewTemplateFunc(ATemplateFileName)  #sending PWideChar, and converting to ANSI at dll
            return CreateInMemFileResult
        except:
            return 'AV on CreateNewTemplate'
    
    
    def AddClickActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AClickOptions):
        try:
            AddClickActionToTemplateResult = self.AddClickActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AClickOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddClickActionToTemplateResult
        except:
            return 'AV on AddClickActionToTemplate'
    
    
    def AddExecAppActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AExecAppOptions):
        try:
            AddExecAppActionToTemplateResult = self.AddExecAppActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AExecAppOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddExecAppActionToTemplateResult
        except:
            return 'AV on AddExecAppActionToTemplate'


    def AddFindControlActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AFindControlOptions):
        try:
            AddFindControlActionToTemplateResult = self.AddFindControlActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AFindControlOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddFindControlActionToTemplateResult
        except:
            return 'AV on AddFindControlActionToTemplate'
            
            
    def AddFindSubControlActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AFindControlOptions):
        try:
            AddFindSubControlActionToTemplateResult = self.AddFindSubControlActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AFindControlOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddFindSubControlActionToTemplateResult
        except:
            return 'AV on AddFindSubControlActionToTemplate'
            
            
    def AddSetControlTextActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, ASetControlTextOptions):
        try:
            AddSetControlTextActionToTemplateResult = self.AddSetControlTextActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, ASetControlTextOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddSetControlTextActionToTemplateResult
        except:
            return 'AV on AddSetControlTextActionToTemplate'

            
    def AddCallTemplateActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, ACallTemplateOptions):
        try:
            AddCallTemplateActionToTemplateResult = self.AddCallTemplateActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, ACallTemplateOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddCallTemplateActionToTemplateResult
        except:
            return 'AV on AddCallTemplateActionToTemplate'


    def AddSleepActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, ASleepOptions):
        try:
            AddSleepActionToTemplateResult = self.AddSleepActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, ASleepOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddSleepActionToTemplateResult
        except:
            return 'AV on AddSleepActionToTemplate'


    def AddSetVarActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, ASetVarOptions):
        try:
            AddSetVarActionToTemplateResult = self.AddSetVarActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, ASetVarOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddSetVarActionToTemplateResult
        except:
            return 'AV on AddSetVarActionToTemplate'


    def AddWindowOperationsActionToTemplate(self, ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AWindowOperationsOptions):
        try:
            AddWindowOperationsActionToTemplateResult = self.AddWindowOperationsActionToTemplateFunc(ATemplateFileName, AActionName, AActionTimeout, AActionEnabled, AActionCondition, AWindowOperationsOptions)  #sending PWideChar, and converting to ANSI at dll
            return AddWindowOperationsActionToTemplateResult
        except:
            return 'AV on AddWindowOperationsActionToTemplate'
           
            
    def AddFontProfileToFindSubControlAction(self, ATemplateFileName, AActionIndex, AFindControlMatchBitmapText):
        try:
            AddFontProfileToFindSubControlActionResult = self.AddFontProfileToFindSubControlActionFunc(ATemplateFileName, AActionIndex, AFindControlMatchBitmapText)  #sending PWideChar, and converting to ANSI at dll
            return AddFontProfileToFindSubControlActionResult
        except:
            return 'AV on AddFontProfileToFindSubControlAction'

    
    def PrepareFilesInServer(self, ATemplateFileName):
        try:
            buffer = ctypes.create_string_buffer(10 * 1048576) # #(CMaxSharedStringLength)
            ResponsePtr = buffer[0] #ctypes.c_char_p(buffer[0])  #address of first byte in the buffer
            RespLen = self.PrepareFilesInServerFunc(ATemplateFileName, ResponsePtr)  #sending PWideChar, and converting to ANSI at dll
            
            Response = ctypes.string_at(ResponsePtr, RespLen)
            return Response
        except:
            return 'AV on PrepareFilesInServer'
            
    def GetListOfFilesFromClientInMem(self):
        try:
            buffer = ctypes.create_string_buffer(10 * 1048576) # #(CMaxSharedStringLength)
            ResponsePtr = buffer[0] #ctypes.c_char_p(buffer[0])  #address of first byte in the buffer
            RespLen = self.GetListOfFilesFromClientInMemFunc(ResponsePtr)
            
            Response = ctypes.string_at(ResponsePtr, RespLen)
            return Response.decode('utf-8')
        except:
            return 'AV on GetListOfFilesFromClientInMem'


    def GetTemplateContentFromClientInMemAsString(self, ATemplateFileName):
        try:
            buffer = ctypes.create_string_buffer(10 * 1048576) # #(CMaxSharedStringLength)
            ResponsePtr = buffer[0] #ctypes.c_char_p(buffer[0])  #address of first byte in the buffer
            RespLen = self.GetTemplateContentFromClientInMemAsStringFunc(ATemplateFileName, ResponsePtr)  #sending PWideChar, and converting to ANSI at dll
            
            Response = ctypes.string_at(ResponsePtr, RespLen)
            return Response.decode('utf-8')
        except:
            return 'AV on GetTemplateContentFromClientInMemAsString'

DllFuncs = TDllFunctions()

print("InitClickerClient: ", DllFuncs.InitClickerClient())
try:
    print("TestConnectionToServer: ", DllFuncs.TestConnectionToServer())
    
    print("GetServerAddress: ", DllFuncs.GetServerAddress())
    
    print("SetServerAddress: ", DllFuncs.SetServerAddress('http://192.168.3.102:5444/'))
    print("GetServerAddress: ", DllFuncs.GetServerAddress())
    print("TestConnectionToServer after setting wrong address: ", DllFuncs.TestConnectionToServer())
    
    print("SetServerAddress: ", DllFuncs.SetServerAddress('http://127.0.0.1:5444/'))
    print("GetServerAddress: ", DllFuncs.GetServerAddress())
    print("TestConnectionToServer after setting a working address: ", DllFuncs.TestConnectionToServer())
    
    print("CreateNewTemplate: ", DllFuncs.CreateNewTemplate('VerifyClicking.clktmpl')) #creates a new template in dll's in-mem file system
    print("CreateNewTemplate: ", DllFuncs.CreateNewTemplate('VerifyClicking.clktmpl')) #the second call returns 1, because the file already exists
    
    ClickOptions = GetDefaultClickOptions()
    ClickOptions.XClickPointReference = TXClickPointReference.xrefVar
    ClickOptions.YClickPointReference = TYClickPointReference.yrefVar
    ClickOptions.XClickPointVar = '$SrcLeft$'
    ClickOptions.YClickPointVar = '$SrcTop$'
    ClickOptions.XOffset = '$XOffset$'
    ClickOptions.YOffset = '$YOffset$'
    print("AddClickActionToTemplate: ", DllFuncs.AddClickActionToTemplate('VerifyClicking.clktmpl', 'First', 0, True, '$a$==$b$', ctypes.byref(ClickOptions)))
    
    ExecAppOptions = GetDefaultExecAppOptions()
    ExecAppOptions.PathToApp = 'C:\\Windows\\Notepad.exe'
    ExecAppOptions.ListOfParams = 'SomeUnknownFile.txt'
    ExecAppOptions.WaitForApp = True
    ExecAppOptions.AppStdIn = 'NothingHere'
    ExecAppOptions.CurrentDir = 'C:\\Windows'
    ExecAppOptions.UseInheritHandles = TExecAppUseInheritHandles.uihYes
    print("AddExecAppActionToTemplate: ", DllFuncs.AddExecAppActionToTemplate('VerifyClicking.clktmpl', 'Second', 0, True, '$a$==$b$', ctypes.byref(ExecAppOptions)))
    
    FindControlOptions = GetDefaultFindControlOptions()
    print("AddFindControlActionToTemplate: ", DllFuncs.AddFindControlActionToTemplate('VerifyClicking.clktmpl', 'Third', 0, True, '$a$<>$b$', ctypes.byref(FindControlOptions)))

    MatchBitmapText = GetDefaultMatchBitmapText()
    print("AddFontProfileToFindSubControlAction: ", DllFuncs.AddFontProfileToFindSubControlAction('VerifyClicking.clktmpl', 2, ctypes.byref(MatchBitmapText)))
    
    MatchBitmapText.ForegroundColor = 'FF8800'
    MatchBitmapText.BackgroundColor = '223344'
    MatchBitmapText.FontName = 'Segoe UI'
    MatchBitmapText.FontSize = 9
    MatchBitmapText.Bold = True
    MatchBitmapText.Italic = True
    MatchBitmapText.Underline = False
    MatchBitmapText.StrikeOut = True
    MatchBitmapText.FontQuality = TFontQuality.fqCleartype
    MatchBitmapText.FontQualityUsesReplacement = True
    MatchBitmapText.FontQualityReplacement = '$TheQuality'
    MatchBitmapText.ProfileName = 'Second profile'
    print("AddFontProfileToFindSubControlAction: ", DllFuncs.AddFontProfileToFindSubControlAction('VerifyClicking.clktmpl', 2, ctypes.byref(MatchBitmapText)))
    
    FindSubControlOptions = GetDefaultFindSubControlOptions()
    print("AddFindSubControlActionToTemplate: ", DllFuncs.AddFindSubControlActionToTemplate('VerifyClicking.clktmpl', 'Fourth', 0, True, '', ctypes.byref(FindSubControlOptions)))
    print("AddFontProfileToFindSubControlAction: ", DllFuncs.AddFontProfileToFindSubControlAction('VerifyClicking.clktmpl', 3, ctypes.byref(MatchBitmapText)))
    
    SetControlTextOptions = GetDefaultSetControlTextOptions()
    print("AddSetControlTextActionToTemplate: ", DllFuncs.AddSetControlTextActionToTemplate('VerifyClicking.clktmpl', 'Fifth', 0, True, '', ctypes.byref(SetControlTextOptions)))
    
    CallTemplateOptions = GetDefaultCallTemplateOptions()
    print("AddCallTemplateActionToTemplate: ", DllFuncs.AddCallTemplateActionToTemplate('VerifyClicking.clktmpl', 'Sixth', 0, True, '', ctypes.byref(CallTemplateOptions)))
    
    SleepOptions = GetDefaultSleepOptions()
    print("AddSleepActionToTemplate: ", DllFuncs.AddSleepActionToTemplate('VerifyClicking.clktmpl', 'Seventh', 0, True, '', ctypes.byref(SleepOptions)))

    SetVarOptions = GetDefaultSetVarOptions()
    print("AddSetVarActionToTemplate: ", DllFuncs.AddSetVarActionToTemplate('VerifyClicking.clktmpl', 'Eighth', 0, True, '', ctypes.byref(SetVarOptions)))

    WindowOperationsOptions = GetDefaultWindowOperationsOptions()
    print("AddWindowOperationsActionToTemplate: ", DllFuncs.AddWindowOperationsActionToTemplate('VerifyClicking.clktmpl', 'Nineth', 0, True, '', ctypes.byref(WindowOperationsOptions)))


    print("PrepareFilesInServer: ", DllFuncs.PrepareFilesInServer('VerifyClicking.clktmpl'))
    
    print("GetListOfFilesFromClientInMem: ", DllFuncs.GetListOfFilesFromClientInMem())
    
    #print("GetTemplateContentFromClientInMemAsString: ", DllFuncs.GetTemplateContentFromClientInMemAsString('VerifyClicking.clktmpl'))
finally:
    print("DoneClickerClient", DllFuncs.DoneClickerClient())


