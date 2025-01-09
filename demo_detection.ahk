#Include <ddddocr>

; 目标检测
det := DdddOcrDetection()
loop files "img/detection_*.jpg" {
    result := det.detection(A_LoopFilePath)

    ui := Gui()
    pic := ui.AddPicture(, A_LoopFilePath)
    ui.Show()
    for bbox in result 
        frame(pic.Hwnd, bbox.x1, bbox.y1, bbox.x2, bbox.y2)
    WinWaitClose(ui)
    ui.Destroy()
}

frame(hwnd, x1, y1, x2, y2) {
    hdc := DllCall("GetDC", "ptr", hwnd, "ptr")
    if hdc {
        old_brush := DllCall("SelectObject", "ptr", hdc, "ptr", DllCall("GetStockObject", "int", 5, "ptr"), "ptr")
        old_pen := DllCall("SelectObject", "ptr", hdc, "ptr", DllCall("CreatePen", "int", 6, "int", 4, "uint", 0xffffff), "ptr")
        DllCall("Rectangle", "ptr", hdc, "int", x1, "int", y1, "int", x2, "int", y2)
        DllCall("DeleteObject", "ptr", DllCall("SelectObject", "ptr", hdc, "ptr", old_brush, "ptr"))
        DllCall("DeleteObject", "ptr", DllCall("SelectObject", "ptr", hdc, "ptr", old_pen, "ptr"))
        DllCall("ReleaseDC", "ptr", hdc)
    }
}