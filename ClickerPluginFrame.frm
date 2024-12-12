object frClickerPlugin: TfrClickerPlugin
  Left = 0
  Height = 240
  Top = 0
  Width = 674
  ClientHeight = 240
  ClientWidth = 674
  TabOrder = 0
  DesignLeft = 86
  DesignTop = 85
  object imgPlugin: TImage
    Left = 8
    Height = 24
    Hint = 'Plugin settings and debugging.'#13#10#13#10'Debugging points are added through plugin code, when lines contain calls to DbgPoint function (implemented in plugins).'#13#10'These are high-level points, where the debugger can can stop the plugin execution.'#13#10'They are displayed by orange-yellow arrows, next to the lines, containing the DbgPoint call.'#13#10'The debugger will stop to these points only if they are set as breakpoints. To set them as breakpoints, please click on the arrows.'#13#10'A debugging point, set as breakpoint, displays an orange disk next to the arrow. To disable the breakpoints, please click again on the arrows.'#13#10#13#10'The list of debugging points is generated at plugin compilation time by the ClkDbgSym.exe tool and saved in .DbgSym files, next to plugins.'#13#10'These files are automatically updated by UIClicker when users set or reset breakpoints.'
    Top = 0
    Width = 24
    AutoSize = True
    ParentShowHint = False
    Picture.Data = {
      1754506F727461626C654E6574776F726B477261706869638903000089504E47
      0D0A1A0A0000000D49484452000000180000001808020000006F15AAAF000000
      017352474200AECE1CE90000000467414D410000B18F0BFC6105000000097048
      597300000EC300000EC301C76FA8640000031E49444154384FADD56B48536118
      07F0F3BEF31604214514F8A1823E4444DB4C52E7DCDCC53B162961E672228150
      7E51BA9822A16251614AEA2C49C4442D5486CDA1566ADA5299E18EA4A9ACBC61
      59999A8B6ED84EEFFB9E439B731B7DF0E1618CF3707E3CEFFF1C368AD9A4720E
      351AABB28D49D974626967FEC7A50FDC55B7E504D29B1FC559B6C5303EA86399
      2D693A2537705B4EA02BC633518C4F34E3CD5A4ADA7766618A9BB92E27505167
      5624E315C578B3569CEE0037705B4E2014CA29A32082F1445CE42FEF72432137
      705B18BA3378F5F49020D9244CA6852ADA1F7544B75F38E3812CC5EC56157D24
      85B49A0E409D4207688DF5ECCDF685A1BCFE54D91294AD40F94F9E82E1294913
      C8239CF164578BC2CD0557D9798BBDD9BE30946B504BA761D802942D43F92A54
      FCC61C111184F72216CB79A3760DF5A8A593403A05A53330EC33E664DFA07C8D
      DB2E9C6C6727BA8672BAD4121390BC065233445CD81C947D21DB7D878A3FB6D5
      FE71AEA10E75A801C8B4DB55ED47E58D7ED277847B0FB9E07EF014D675C12148
      6F7E98658C4F3728BBCD7A1B94D190905413F272B4C7CA58972D4B275B84D237
      D8B205F7755D70C71E0815162FF6A409B37B46674D1C34313366B55A314BEA72
      4B1A3EE908B005F78970169E7C0D6E0CAE962E457761C8A12E6955E23E106A04
      EB83E3C9169D075741DE580CE5D6A75FA857AD5896D177F41955B95FFC14887B
      000A4EF28A70A350FA9670F338B888E67D6C70888B36EF3299873828BB2125B8
      0CC4DCDD7BB62AE6B8E690A81988B4C0BF06F8D711AE1F48868184069271889F
      C334BCDD5A90FF2423B14B78A255506DC0E7B241812514EAA0722AA89A0ABC4F
      2597C9872607E616A78A7499F2E61DE2E7207490AC86829B009AF69BE82EF464
      501304D73A087729157A6DE7F2EA123B4675B14915D2815713F772C169F41872
      A80D5009252AF0B5FF552C6C3B874E1AF21870C1BDF86F08754E6D3A3B36CF8F
      2B2A7607D751C14D3838511B103F039A3617D0F97BF187F328FB3E98E93930D6
      8B46A9C5B1FC7C8A7F9DE2DFA0F8C514BF0C082A8046E702422F641FDDE5D0EC
      E946CCC30ED7513BFD3BC0D02614C3FC05928FA62344F8FD290000000049454E
      44AE426082
    }
    ShowHint = True
  end
  object vstPluginDebugging: TVirtualStringTree
    Left = 8
    Height = 191
    Top = 32
    Width = 660
    Anchors = [akTop, akLeft, akRight, akBottom]
    Colors.UnfocusedSelectionColor = clGradientInactiveCaption
    DefaultText = 'Node'
    Font.CharSet = ANSI_CHARSET
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Quality = fqDraft
    Header.AutoSizeIndex = 0
    Header.Columns = <    
      item
        Color = clGradientInactiveCaption
        MaxWidth = 200
        MinWidth = 80
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus, coEditable]
        Position = 0
        Text = 'Line no'
        Width = 80
      end    
      item
        MaxWidth = 70000
        MinWidth = 70000
        Position = 1
        Text = 'Code'
        Width = 70000
      end>
    Indent = 4
    ParentFont = False
    ScrollBarOptions.AlwaysVisible = True
    StateImages = imglstPluginDebugging
    TabOrder = 0
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnBeforeCellPaint = vstPluginDebuggingBeforeCellPaint
    OnGetText = vstPluginDebuggingGetText
    OnPaintText = vstPluginDebuggingPaintText
    OnGetImageIndex = vstPluginDebuggingGetImageIndex
    OnMouseUp = vstPluginDebuggingMouseUp
  end
  object spdbtnStopPlaying: TSpeedButton
    Left = 160
    Height = 25
    Hint = 'Ctrl-Shift-F2'
    Top = 2
    Width = 107
    Caption = 'Stop                  '
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF15008815008815008815008815008815008815
      0088150088150088150088150088150088150088150088FFFFFFFFFFFFC9AEFF
      241CED241CED241CED241CED241CED241CED241CED241CED241CED241CED241C
      ED241CED150088FFFFFFFFFFFFC9AEFF241CED1D12E71D12E71D12E71D12E71D
      12E71D12E71D12E71D12E71D12E71D12E7241CED150088FFFFFFFFFFFFC9AEFF
      241CED1D12E7241CED241CED241CED241CED241CED241CED241CED241CED1D12
      E7241CED150088FFFFFFFFFFFFC9AEFF241CED1D12E7241CED3E34EF3E34EF3E
      34EF3E34EF3E34EF3E34EF241CED1D12E7241CED150088FFFFFFFFFFFFC9AEFF
      241CED1D12E7241CED3E34EF3E34EF3E34EF3E34EF3E34EF3E34EF241CED1D12
      E7241CED150088FFFFFFFFFFFFC9AEFF241CED1D12E7241CED3E34EF3E34EF3E
      34EF3E34EF3E34EF3E34EF241CED1D12E7241CED150088FFFFFFFFFFFFC9AEFF
      241CED1D12E7241CED3E34EF3E34EF3E34EF3E34EF3E34EF3E34EF241CED1D12
      E7241CED150088FFFFFFFFFFFFC9AEFF241CED1D12E7241CED3E34EF3E34EF3E
      34EF3E34EF3E34EF3E34EF241CED1D12E7241CED150088FFFFFFFFFFFFC9AEFF
      241CED1D12E7241CED3E34EF3E34EF3E34EF3E34EF3E34EF3E34EF241CED1D12
      E7241CED150088FFFFFFFFFFFFC9AEFF241CED1D12E7241CED241CED241CED24
      1CED241CED241CED241CED241CED1D12E7241CED150088FFFFFFFFFFFFC9AEFF
      241CED1D12E71D12E71D12E71D12E71D12E71D12E71D12E71D12E71D12E71D12
      E7241CED150088FFFFFFFFFFFFC9AEFF241CED241CED241CED241CED241CED24
      1CED241CED241CED241CED241CED241CED241CED150088FFFFFFFFFFFFC9AEFF
      C9AEFFC9AEFFC9AEFFC9AEFFC9AEFFC9AEFFC9AEFFC9AEFFC9AEFFC9AEFFC9AE
      FFC9AEFFC9AEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    }
    Visible = False
    ShowHint = True
    ParentShowHint = False
    OnClick = spdbtnStopPlayingClick
  end
  object spdbtnContinuePlayingAll: TSpeedButton
    Left = 272
    Height = 25
    Hint = 'Resume playing.'
    Top = 2
    Width = 107
    Caption = 'Continue All     '
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FFFFFF000000
      000000000000000000FFFFFFFFFFFF000000000000000000000000FFFFFFFFFF
      FF000000000000000000FFFFFF0000004CB1224CB1224CB122FFFFFFFFFFFF00
      0000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB122000000FFFFFFFFFFFF000000FFFFFFFFFF
      FF000000FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB122FFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB122FFFFFFFFFF
      FF000000FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB1224CB1224CB1224CB1224CB122000000FFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1
      224CB122FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB1224CB1224CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1
      224CB1224CB122FFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB1224CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1224CB1
      22000000FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB1224C
      B1224CB1224CB1224CB122FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF4CB122
      4CB1224CB1224CB1224CB1224CB1224CB1224CB122FFFFFF000000FFFFFFFFFF
      FF000000FFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB1224CB1224CB12200
      0000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000
      4CB1224CB1224CB122FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFF
      FF000000FFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFF00
      0000000000000000000000FFFFFFFFFFFF000000000000000000
    }
    Visible = False
    ShowHint = True
    ParentShowHint = False
    OnClick = spdbtnContinuePlayingAllClick
  end
  object spdbtnStepOver: TSpeedButton
    Left = 384
    Height = 25
    Hint = 'Moves past the current debug point.'
    Top = 2
    Width = 107
    Caption = 'Step Over        '
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00B7D400B7D400B7D4FFFFFFFFFFFF00
      0000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00B7D4
      00B7D400B7D400B7D400B7D400B7D4000000FFFFFFFFFFFF000000FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF00B7D400B7D400B7D400B7D400B7D400B7D400
      B7D400B7D4FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00B7D4
      00B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D4FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF00B7D400B7D400B7D400B7D400B7D400B7D400
      B7D400B7D400B7D400B7D400B7D400B7D4FFFFFFFFFFFFFFFFFFFFFFFF00B7D4
      00B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7
      D400B7D4FFFFFFFFFFFFFFFFFF00B7D400B7D400B7D400B7D400B7D400B7D400
      B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D4FFFFFFFFFFFF00B7D4
      00B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7
      D400B7D400B7D4FFFFFFFFFFFF00B7D400B7D400B7D400B7D400B7D400B7D400
      B7D400B7D400B7D400B7D400B7D400B7D400B7D4FFFFFFFFFFFFFFFFFF00B7D4
      00B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7D400B7
      D4FFFFFFFFFFFFFFFFFFFFFFFF00B7D400B7D400B7D400B7D400B7D400B7D400
      B7D400B7D400B7D400B7D4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00B7D4
      00B7D400B7D400B7D400B7D400B7D400B7D400B7D4FFFFFF000000FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF00B7D400B7D400B7D400B7D400B7D400B7D400
      0000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      00B7D400B7D400B7D4FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
      0000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    }
    Visible = False
    ShowHint = True
    ParentShowHint = False
    OnClick = spdbtnStepOverClick
  end
  object lblMsg: TLabel
    Left = 8
    Height = 15
    Top = 223
    Width = 18
    Anchors = [akLeft, akBottom]
    Caption = 'File'
    ParentColor = False
    Transparent = False
  end
  object lblPluginDebugging: TLabel
    Left = 36
    Height = 15
    Top = 9
    Width = 95
    Caption = 'Plugin debugging'
  end
  object spdbtnScrollToCurrentLine: TSpeedButton
    Left = 496
    Height = 25
    Hint = 'Brings current line into view'
    Top = 2
    Width = 147
    Caption = 'Scroll to current line'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000C9AEFFB0E4EF
      B0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4
      EFB0E4EFB0E4EFC9AEFF4CB1224CB1224CB1224CB122B0E4EFB0E4EFB0E4EFB0
      E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFFFFFFFFFFFFF
      FFFFFF4CB122B0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4
      EFB0E4EFB0E4EFB0E4EF1DE6B51DE6B51DE6B54CB122000000000000000000B0
      E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EF1DE6B51DE6B5
      1DE6B54CB122B0E4EFB0E4EF000000B0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4
      EFB0E4EFB0E4EFB0E4EFFFFFFFFFFFFFFFFFFF4CB122B0E4EFB0E4EF000000B0
      E4EFB0E4EFB0E4EFB0E4EF4CB1224CB1224CB1224CB1224CB122FFFFFFFFFFFF
      FFFFFF4CB122B0E4EFB0E4EF000000B0E4EFB0E4EFB0E4EFB0E4EF4CB122FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4CB122B0E4EFB0E4EF000000B0
      E4EFB0E4EFB0E4EFB0E4EF4CB122FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF4CB122B0E4EFB0E4EF000000B0E4EF000000B0E4EFB0E4EF4CB122FFFF
      FFFFFFFFFFFFFFFFFFFF4CB1224CB1224CB1224CB122B0E4EFB0E4EF000000B0
      E4EFE8A200000000B0E4EF4CB122A449A3A449A3A449A3A449A3B0E4EFB0E4EF
      B0E4EFB0E4EFB0E4EFB0E4EF0000000000000000000000000000004CB122A449
      A3A449A3A449A3A449A3B0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0
      E4EFE8A200000000B0E4EF4CB122FFFFFFFFFFFFFFFFFFFFFFFFB0E4EFB0E4EF
      B0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EF000000B0E4EFB0E4EF4CB122FFFF
      FFFFFFFFFFFFFFFFFFFFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0
      E4EFB0E4EFB0E4EFB0E4EF4CB122FFFFFFFFFFFFFFFFFFFFFFFFB0E4EFB0E4EF
      B0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EF4CB1224CB1
      224CB1224CB1224CB122C9AEFFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0
      E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFB0E4EFC9AEFF
    }
    ShowHint = True
    ParentShowHint = False
    OnClick = spdbtnScrollToCurrentLineClick
  end
  object spdbtnGoToPrevDbgPoint: TSpeedButton
    Left = 648
    Height = 13
    Hint = 'Go to previous debug point.'
    Top = 2
    Width = 20
    Glyph.Data = {
      36020000424D3602000000000000360000002800000010000000080000000100
      2000000000000002000000000000000000000000000000000000FFFFFF00FFFF
      FF00096BFFFF241CEDFF241CEDFF241CEDFF241CEDFF241CEDFF241CEDFF241C
      EDFF241CEDFF241CEDFF241CEDFF096BFFFFFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00241CEDFF2693FFFF2693FFFF2693FFFF2693FFFF2693FFFF2693FFFF2693
      FFFF2693FFFF2693FFFF2693FFFF241CEDFFFFFFFF00FFFFFF00FFFFFF00FFFF
      FF000EC9FFFF241CEDFF096BFFFF277FFFFF277FFFFF277FFFFF277FFFFF277F
      FFFF277FFFFF096BFFFF241CEDFF0EC9FFFFFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000EC9FFFF241CEDFF096BFFFF277FFFFF277FFFFF277FFFFF277F
      FFFF096BFFFF241CEDFF0EC9FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000EC9FFFF241CEDFF096BFFFF277FFFFF277FFFFF096B
      FFFF241CEDFF0EC9FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000EC9FFFF241CEDFF096BFFFF096BFFFF241C
      EDFF0EC9FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000EC9FFFF241CEDFF241CEDFF0EC9
      FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000EC9FFFF0EC9FFFFFFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
    }
    ShowHint = True
    ParentShowHint = False
    OnClick = spdbtnGoToPrevDbgPointClick
  end
  object spdbtnGoToNextDbgPoint: TSpeedButton
    Left = 648
    Height = 13
    Hint = 'Go to next debug point.'
    Top = 14
    Width = 20
    Glyph.Data = {
      36020000424D3602000000000000360000002800000010000000080000000100
      2000000000000002000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000EC9FFFF0EC9FFFFFFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000EC9FFFF241CEDFF241CEDFF0EC9
      FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000EC9FFFF241CEDFF096BFFFF096BFFFF241C
      EDFF0EC9FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000EC9FFFF241CEDFF096BFFFF277FFFFF277FFFFF096B
      FFFF241CEDFF0EC9FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000EC9FFFF241CEDFF096BFFFF277FFFFF277FFFFF277FFFFF277F
      FFFF096BFFFF241CEDFF0EC9FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000EC9FFFF241CEDFF096BFFFF277FFFFF277FFFFF277FFFFF277FFFFF277F
      FFFF277FFFFF096BFFFF241CEDFF0EC9FFFFFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00241CEDFF2693FFFF2693FFFF2693FFFF2693FFFF2693FFFF2693FFFF2693
      FFFF2693FFFF2693FFFF2693FFFF241CEDFFFFFFFF00FFFFFF00FFFFFF00FFFF
      FF00096BFFFF241CEDFF241CEDFF241CEDFF241CEDFF241CEDFF241CEDFF241C
      EDFF241CEDFF241CEDFF241CEDFF096BFFFFFFFFFF00FFFFFF00
    }
    ShowHint = True
    ParentShowHint = False
    OnClick = spdbtnGoToNextDbgPointClick
  end
  object imglstPluginDebugging: TImageList
    BkColor = clWhite
    DrawingStyle = dsTransparent
    Left = 264
    Top = 80
    Bitmap = {
      4C7A050000001000000010000000F60000000000000078DAED95CD09C2401085
      ADC00A3C0A36611F1E2DC5BB57FB104FDE3DA6012BF02A8205F864220BCBBAC6
      CCBC5D8C3A8181B0C9F732991F1E80113C3C3CFE2E6E682F5A673A394362DCD8
      F4026BD508DC6C65D328C95B34525EAB91E3351A3578267FB67E0CCFF49F995F
      667F3E1D43D9FFDDE942F5AF046FD14879AD468ED768D4E099FCD9FA31BCEFFF
      6FFA7FB305968B6B1B72DF973F1E80FDE6711EFB8B9CC9B377FE23EFCDD7CFDE
      2A67F2ACCB3F25CFF8BB397FEEF26FF9D7576C885A3C933F5BBF98D7F68F991F
      DFFFE1FA7F9FFEE578CDFCE4FC4733BFA97F6AF727F56FEDFE96E499FCD9FA59
      F79F9D9F6FDCFF3BF00A73DD
    }
  end
  object tmrRequestLineNumber: TTimer
    Enabled = False
    OnTimer = tmrRequestLineNumberTimer
    Left = 408
    Top = 80
  end
  object tmrColorLabel: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrColorLabelTimer
    Left = 544
    Top = 80
  end
end
