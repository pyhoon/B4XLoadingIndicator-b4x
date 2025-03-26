B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6.01
@EndOfDesignText@
'Version 1.00
#DesignerProperty: Key: Color, DisplayName: Color, FieldType: Color, DefaultValue: 0xFFFFFFFF
'#DesignerProperty: Key: IndicatorStyle, DisplayName: Style, FieldType: String, DefaultValue: Three Circles 1, List: Three Circles 1|Three Circles 2|Single Circle|Five Lines 1|Arc 1|Arc 2|PacMan
#DesignerProperty: Key: IndicatorStyle, DisplayName: Style, FieldType: String, DefaultValue: Three Circles 1, List: Three Circles 1|Three Circles 2|Three Circles 3|Single Circle|Follow Circles|Follow Circles 2|Five Lines 1|Five Ball|Ten Lines|Ten Circles|Arc 1|Arc 2|X Arc|PacMan|Square|Square Rounded
#DesignerProperty: Key: Duration, DisplayName: Duration, FieldType: Int, DefaultValue: 1000

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView 'ignore
	Private xui As XUI 'ignore
	Public IndicatorColor As Int
	Private index As Int
	Private cvs As B4XCanvas
	Public Duration As Int
	Private DrawingSubName As String
	Public Tag As Object
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	Tag = mBase.Tag : mBase.Tag = Me
  	IndicatorColor = xui.PaintOrColorToColor(Props.Get("Color")) 
	Dim style As String = Props.Get("IndicatorStyle")
	Duration = Props.Get("Duration")
	SetStyle(style)
	cvs.Initialize(mBase)
	MainLoop
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	cvs.Resize(Width, Height)
	MainLoop
End Sub

'Sets the indicator style. One of the following values:
'Three Circles 1, Three Circles 2, Single Circle, Five Lines 1, Arc 1, Arc 2, PacMan
Public Sub SetStyle(Style As String)
	DrawingSubName = "Draw_" & Style.Replace(" ", "")
End Sub

Private Sub MainLoop
	index = index + 1
	Dim MyIndex As Int = index
	Dim n As Long = DateTime.Now
	Do While MyIndex = index
		Dim progress As Float = (DateTime.Now - n) / Duration
		progress = progress - Floor(progress)
		cvs.ClearRect(cvs.TargetRect)
		CallSub2(Me, DrawingSubName, progress)
		cvs.Invalidate
		Sleep(10)
	Loop
End Sub

Public Sub Show
	mBase.Visible = True
	MainLoop
End Sub

Public Sub Hide
	mBase.Visible = False
	index = index + 1
End Sub

Private Sub Draw_ThreeCircles1 (Progress As Float)
	Dim MaxR As Float = (cvs.TargetRect.Width / 2 - 20dip) / 2
	Dim r As Float = 10dip + MaxR + MaxR * Sin(Progress * 2 * cPI)
	For i = 0 To 2
		Dim alpha As Int = i * 120 + Progress * 360
		'alpha = -alpha
		cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(alpha), cvs.TargetRect.CenterY + r * CosD(alpha), 7dip, IndicatorColor, True, 1dip)
	Next
End Sub

Private Sub Draw_ThreeCircles2 (Progress As Float)
	Dim MinR As Int = 5dip
	Dim MaxR As Int = cvs.TargetRect.Width / 2 / 3 - MinR -2dip
	For i = 0 To 2
		Dim r As Float = MinR + MaxR / 2 + MaxR / 2 * SinD(Progress * 360 - 60 * i)
		cvs.DrawCircle(MaxR + MinR + (MinR + MaxR + 2dip) * 2 * i, cvs.TargetRect.CenterY, r, IndicatorColor, True, 0)
	Next
End Sub

Private Sub Draw_SingleCircle(Progress As Float)
	For i = 0 To 2
		cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, cvs.TargetRect.CenterX * Progress, SetAlpha(IndicatorColor, 255 - 255 * Progress), True, 0)
	Next
End Sub

Private Sub SetAlpha (c As Int, alpha As Int) As Int
	Return Bit.And(0xffffff, c) + Bit.ShiftLeft(alpha, 24)
End Sub

Private Sub Draw_FiveLines1(Progress As Float)
	Dim MinR As Int = 10dip
	Dim MaxR As Int = cvs.TargetRect.Height / 2
	Dim dx As Int = (cvs.TargetRect.Width - 2dip) / 5
	For i = 0 To 4
		Dim r As Float = MinR + MaxR / 2 + MaxR / 2 * SinD(Progress * 360 - 30 * i)
		cvs.DrawLine(2dip + i * dx, cvs.TargetRect.CenterY - r, 2dip + i * dx, cvs.TargetRect.CenterY + r, IndicatorColor, 4dip)
	Next
End Sub

Private Sub Draw_Arc1 (Progress As Float)
	Dim p As B4XPath
	Dim r As Float = cvs.TargetRect.CenterX - 5dip
	If Progress < 0.5 Then
		p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -90, Progress * 2 * 360)
	Else
		p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -90, -(1 - Progress) * 2 * 360)
	End If
	cvs.ClipPath(p)
	cvs.DrawRect(cvs.TargetRect, IndicatorColor, True, 0)
	cvs.RemoveClip
End Sub

Private Sub Draw_Arc2 (Progress As Float)
	Dim p As B4XPath
	Dim r As Float = cvs.TargetRect.CenterX - 5dip
	If Progress < 0.5 Then
		p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -90, Progress * 2 * 360)
	Else
		p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -90, 360 - (Progress - 0.5) * 2 * 360)
	End If
	cvs.ClipPath(p)
	cvs.DrawRect(cvs.TargetRect, IndicatorColor, True, 0)
	cvs.RemoveClip
End Sub

Private Sub Draw_PacMan(Progress As Float)
	Dim DotR As Int = 5dip
	cvs.DrawCircle(cvs.TargetRect.Width - DotR - Progress * (cvs.TargetRect.CenterX - 10dip), cvs.TargetRect.CenterY, DotR, SetAlpha(IndicatorColor, 255 - 200 * Progress), True, 0)
	Dim p As B4XPath
	Dim angle As Int = 70 * SinD(Progress * 180)
	Dim cx As Int = cvs.TargetRect.CenterX - 5dip
	Dim cy As Int = cvs.TargetRect.CenterY
	Dim r As Int = cvs.TargetRect.CenterY - 5dip
	If angle = 0 Then
		cvs.DrawCircle(cx, cy, r, IndicatorColor, True, 0)
	Else
		p.InitializeArc(cx, cy , r, -angle / 2, -(360-angle))
		cvs.ClipPath(p)
		cvs.DrawRect(cvs.TargetRect, IndicatorColor, True, 0)
		cvs.RemoveClip
	End If
End Sub


' --------------------------- New ------------------------
' https://www.b4x.com/android/forum/threads/b4x-xui-b4xloadingindicator-loading-indicator.92243/

Private Sub Draw_ThreeCircles3 (Progress As Float)
	Dim MaxR As Float = (cvs.TargetRect.Width / 2 - 20dip) / 2
	Dim r As Float = 15dip + MaxR + MaxR * Sin(Progress * 1 * cPI)
	For i = 0 To 2
		Dim alpha As Int = i * 120 + Progress * 360
		cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(alpha), cvs.TargetRect.CenterY + r * CosD(alpha), 7dip, IndicatorColor, True, 1dip)
	Next
	cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.Centery, 7dip, IndicatorColor, True, 1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.Centery, r, IndicatorColor, False, 1dip)
End Sub

Private Sub Draw_TenCircles (Progress As Float)
	Dim r As Float = Min(cvs.TargetRect.Width,cvs.TargetRect.Height) / 2 - 8dip
	Dim B As Boolean = False
		
	For i = 0 To 9
		'Dim alpha As Int = i * 120 + Progress * 360
		Dim Alpha As Float = i * 36
		'cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha), 7dip, xui.Color_LightGray, True, 1dip)
		If Alpha > Progress * 360 And B = False Then
			cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD((i-1) * 36), cvs.TargetRect.CenterY + r * CosD((i-1)*36), 7dip, Bit.And(IndicatorColor, 0xAAffffff), True, 1dip)
			cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha), 8dip, IndicatorColor, True, 1dip)
			B = True
		Else
			cvs.DrawCircle(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha), 7dip, Bit.And(IndicatorColor, 0x55ffffff), True, 1dip)
		End If
	Next
End Sub

Private Sub Draw_TenLines (Progress As Float)
	Dim r As Float = Min(cvs.TargetRect.Width, cvs.TargetRect.Height) / 2
	Dim B As Boolean = False
	Dim Spess As Int = 6dip
		
	For i = 0 To 9
		'Dim alpha As Int = i * 120 + Progress * 360
		Dim Alpha As Float = i * 36
		
		If Alpha > Progress * 360 And B = False Then
			cvs.DrawLine(cvs.TargetRect.CenterX + r * SinD((i-1) * 36), cvs.TargetRect.CenterY + r * CosD((i-1) * 36), cvs.TargetRect.CenterX + (r / 2) * SinD((i-1) * 36), cvs.TargetRect.CenterY + (r / 2) * CosD((i-1) * 36), Bit.And(IndicatorColor, 0xAAFFFFFF), Spess)
			cvs.DrawLine(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha), cvs.TargetRect.CenterX + (r / 2) * SinD(Alpha), cvs.TargetRect.CenterY + (r / 2) * CosD(Alpha), IndicatorColor, Spess)
			B = True
		Else
			cvs.DrawLine(cvs.TargetRect.CenterX + r * SinD(Alpha), cvs.TargetRect.CenterY + r * CosD(Alpha), cvs.TargetRect.CenterX + (r / 2) * SinD(Alpha), cvs.TargetRect.CenterY + (r / 2) * CosD(Alpha), Bit.And(IndicatorColor, 0x55FFFFFF), Spess)
		End If
	Next
End Sub

Private Sub Draw_FollowCircles (Progress As Float)
	Dim r As Float = Min(cvs.TargetRect.Width,cvs.TargetRect.Height) / 2 - 8dip
	Dim X As Int = r * SinD(Progress * 360)
	Dim Y As Int = r * CosD(Progress * 360)
				
	cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip, IndicatorColor, True, 1dip)
	
	For i = 0 To 4
		X = r * SinD(Progress * 360 - i * (72 * Abs(Progress - 0.5)))
		Y = r * CosD(Progress * 360 - i * (72 * Abs(Progress - 0.5)))
		cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip - (i * 5dip / 5), Bit.And(IndicatorColor, 0x55ffffff), True, 1dip)
	Next
End Sub

Private Sub Draw_FollowCircles2 (Progress As Float)
	Dim r As Float = Min(cvs.TargetRect.Width, cvs.TargetRect.Height) / 2 - 8dip
	Dim X As Int
	Dim Y As Int

	cvs.DrawCircle(cvs.TargetRect.CenterX + (r * SinD(Progress * 360)), cvs.TargetRect.CenterY + (r * CosD(Progress * 360)), 7dip, IndicatorColor, True, 1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX + (r * SinD(Progress * 360 + 180)), cvs.TargetRect.CenterY + (r * CosD(Progress * 360 + 180)), 7dip, IndicatorColor, True, 1dip)
	
	For i = 0 To 4
		X = r * SinD(Progress * 360 - i * (72 * Abs(Progress - 0.5)))
		Y = r * CosD(Progress * 360 - i * (72 * Abs(Progress - 0.5)))
		cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip - (i * 5dip / 5), Bit.And(IndicatorColor, 0x55ffffff), True, 1dip)
		
		X = r*SinD(Progress * 360 + 180 - i * (72 * Abs(Progress - 0.5)))
		Y = r*CosD(Progress * 360 + 180 - i * (72 * Abs(Progress - 0.5)))
		cvs.DrawCircle(cvs.TargetRect.CenterX + x, cvs.TargetRect.CenterY + y, 7dip - (i * 5dip / 5), Bit.And(IndicatorColor, 0x55ffffff), True, 1dip)
	Next
End Sub

Private Sub Draw_FiveBall(Progress As Float)
	Dim MinR As Int = 5dip
	Dim MaxR As Int = (cvs.TargetRect.Height - 10dip) / 2
	Dim dx As Int = (cvs.TargetRect.Width) / 5
	
	For i = 0 To 4
		'Dim r As Float = MinR + MaxR / 2 + MaxR / 2 * SinD(Progress * 360 - 30 * i)
		'cvs.DrawLine(2dip + i * dx, cvs.TargetRect.CenterY - r, 2dip + i * dx, cvs.TargetRect.CenterY + r, IndicatorColor, 4dip)
		Dim r As Float = ((MaxR - MinR)  * SinD(Progress * 360 - 45 * i))
		cvs.DrawCircle((i + 0.5) * dx, cvs.TargetRect.CenterY - r, 7dip, IndicatorColor, True, 1dip)
	Next
End Sub

Private Sub Draw_XArc (Progress As Float)
	Dim r As Float = (Min(cvs.TargetRect.Width, cvs.TargetRect.Height) / 2) - 1dip
	Dim r2 As Float = 2 * r / 3
	Dim r3 As Float = r / 3
	Dim p As B4XPath
		
	p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r, -Progress * 360, 180)
	cvs.DrawPath(p, IndicatorColor, True, 1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r - 1dip, xui.Color_Transparent, True, 1dip)
	
	p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r2, Progress * 360, 180)
	cvs.DrawPath(p, IndicatorColor, True, 1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r2 - 1dip, xui.Color_Transparent, True, 1dip)
	
	p.InitializeArc(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r3, -Progress * 360, 180)
	cvs.DrawPath(p, IndicatorColor, True, 1dip)
	cvs.DrawCircle(cvs.TargetRect.CenterX, cvs.TargetRect.CenterY, r3 - 1dip, xui.Color_Transparent, True, 1dip)
End Sub

Private Sub Draw_Square (Progress As Float)
	Square(Progress, False)
End Sub

Private Sub Draw_SquareRounded (Progress As Float)
	Square(Progress, True)
End Sub

Private Sub Square (Progress As Float, Rounded As Boolean)
	Dim Rec As B4XRect
	Dim A As Int = Bit.And(0xFF, Bit.ShiftRight(IndicatorColor, 24))
	Dim R As Int = 0.5*Bit.And(0xFF, Bit.ShiftRight(IndicatorColor, 16))
	Dim G As Int = 0.5*Bit.And(0xFF, Bit.ShiftRight(IndicatorColor, 8))
	Dim B As Int = 0.5*Bit.And(0xFF, IndicatorColor)
	Dim top As Int = 5dip
	Dim left As Int = 5dip
	Dim Width As Int = cvs.TargetView.Width
	Dim Height As Int = cvs.TargetView.Height
		
	Rec.Initialize(0, 0, Width, Height)
	Dim RoundRec As B4XPath
	RoundRec.InitializeRoundedRect(Rec, 5dip)
	'cvs.DrawRect(Rec, xui.Color_ARGB(A, R, G, B), True, 1dip)
	cvs.DrawPath(RoundRec, xui.Color_ARGB(A, R, G, B), True, 1dip)
	Height = Height - top * 2
	Width = Width - left * 2
	
	If Progress <= 0.125 Then
		Rec.Initialize(left, top, left + Width * (0.5 + Progress * 4), top + Height / 2)
	Else If Progress <= 0.25 Then
		Rec.Initialize(left + Width * (Progress - 0.125) * 4, top, left + Width, top + Height / 2)		
	Else If Progress <= 0.375 Then
		Rec.Initialize(left + Width / 2, top, left + Width, top + Height * (Progress - 0.125) * 4)
	Else If Progress <= 0.5 Then
		Rec.Initialize(left + Width / 2, top + Height * (Progress - 0.375) * 4, left + Width, top + Height)	
	Else If Progress<=0.625 Then
		Rec.Initialize(left + Width * (0.625 - Progress) * 4, top + Height / 2, left + Width, top + Height)
	Else If Progress <= 0.75 Then
		Rec.Initialize(left, top + Height / 2, left + Width * (0.875 - Progress) * 4, top + Height)
	Else If Progress <= 0.875 Then
		Rec.Initialize(left, top + Height * (0.875 - Progress) * 4, left + Width / 2, top + Height)
	Else
		Rec.Initialize(left, top, left + Width / 2, top + Height * (1.125 - Progress) * 4)
	End If
	
	Dim RoundRec As B4XPath
	If Rounded Then
		RoundRec.InitializeRoundedRect(Rec, Min(Width, Height) / 2)
	Else
		RoundRec.InitializeRoundedRect(Rec, 5dip)
	End If
	'cvs.DrawRect(Rec, IndicatorColor, True, 1dip)
	cvs.DrawPath(RoundRec, IndicatorColor, True, 1dip)
End Sub