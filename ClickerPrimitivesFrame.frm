object frClickerPrimitives: TfrClickerPrimitives
  Left = 0
  Height = 260
  Top = 0
  Width = 399
  ClientHeight = 260
  ClientWidth = 399
  Color = clDefault
  Constraints.MinWidth = 399
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  DesignLeft = 86
  DesignTop = 85
  object pnlvstOI: TPanel
    Left = 0
    Height = 256
    Top = 0
    Width = 278
    Anchors = [akTop, akLeft, akBottom]
    BevelOuter = bvNone
    Caption = 'pnlvstOI'
    ClientHeight = 256
    ClientWidth = 278
    Color = 13500339
    Constraints.MinHeight = 208
    Constraints.MinWidth = 270
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    Visible = False
    object imgFontColorBuffer: TImage
      Left = 16
      Height = 16
      Top = 16
      Width = 16
      AutoSize = True
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        0000100000000100180000000000000300000000000000000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF
      }
      Visible = False
    end
  end
  object pnlPreview: TPanel
    Left = 280
    Height = 258
    Top = 0
    Width = 118
    Anchors = [akTop, akLeft, akRight, akBottom]
    Caption = 'Preview'
    ClientHeight = 258
    ClientWidth = 118
    ParentColor = False
    TabOrder = 1
    object PageControlPreview: TPageControl
      Left = 0
      Height = 258
      Top = 0
      Width = 119
      Anchors = [akTop, akLeft, akRight, akBottom]
      TabOrder = 0
      Options = [nboDoChangeOnSetIndex]
    end
  end
  object tmrReloadOIContent: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrReloadOIContentTimer
    Left = 208
    Top = 192
  end
  object imglstPrimitives: TImageList
    Left = 298
    Top = 90
    Bitmap = {
      4C7A090000001000000010000000C20200000000000078DAED98BF8B135110C7
      5F6B23D8588836418C95859D95A52006B5B7B00CDA5A06829C7F83606B132BC9
      816984D84408578851D063B1CA719CE6E0301CD63766969B38FB76DEEF4896CB
      0E7C79BB2FF399D937BBEFEDE6F5F77F43ACF513586E572F1F45A92A766FBBB1
      54685F25ECB68A6BAB628373FF44E73EFD1531A554F4713F71FE2EA412F8953D
      08BF5EAB28715E3A76C5D61989B5C5D07348AC2F6F6243F97AFC9B337E9A83B1
      E35FF5FCBF7230F07EBF35BB76B6DD6EE78AE1B32CCBD956AB05D3E95464CFEF
      9873F77A3D180E87798B0AE5718D9ECFE7309BCD0AEBB5C4EBEC783C864EA753
      A803F6F9B0923F8E83D7D1C663ADE8DAC9F018FBA43AEAB9B156E82B49AAA36E
      78BF269349A91FFBF0379BB97CF01AF4D8387E943A86BCE6B66BC4DFF87DE1DF
      74144717C62549F668F77A2EFE6DC8658B2BCD41CAE58A8B3EC8E23740ECF737
      B13B6FC1281BDF8486F55BDEC512CFF3A1B9F213CBF3531CE25D7963789D0DE1
      2556E279EB6275DEF79A7D79F2B9F9ECA251BE79A5F5C4945F67793EE46CF96D
      63E5BC347E57AD6CBC8B35F138077D58E2798BEF80C55AA20EB357406AFC59AC
      1F3F8F4BC27EEE87F2656D315CECDE87AD924C3124DFF7078FE164EFCEB2957C
      747FF225E931782C9B3FCAB4FE4ABE7A1CF27DFEF14941D44FFEA61C12ABC720
      DEE4E7922B8F0F6F8AE93B1689BD34BC5150484D74D6278E0F2BC521D697D385
      7330855DC7FFFF983DB0D0BD33FDD9F91F3952C793B2DFB8296CCA7EE926D429
      75FE5661FFCFF6FEB289F3EAD361906ABEE657C9A73CBF297616E63FDA856D80
      E69B935CD7DE013CF8FC1D1E7EFB02F77707D0CA5EC2DD1F2FE0D6D7A7B96ABE
      E6CF1ABFAEF98F5B86EB56C2FAB9E4714F74341A9564DA3F95F86EB75B52084F
      B271269EEF6B218FED72AFF7F498FB48F9C98FF2936F61DFF8F4DC87976A10C2
      A7E497C6EFE253EABF8AFB9FF2FCA53CFF29FA0BD537C59E
    }
  end
  object pmPreview: TPopupMenu
    Left = 328
    Top = 192
    object MenuItem_CopyToClipboard: TMenuItem
      Caption = 'Copy to clipboard'
      OnClick = MenuItem_CopyToClipboardClick
    end
  end
  object tmrDrawZoom: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmrDrawZoomTimer
    Left = 208
    Top = 128
  end
end
