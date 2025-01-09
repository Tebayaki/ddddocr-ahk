#Include <ddddocr>

; 滑块识别
ui := Gui()
ui.AddPicture(, "img/slide_target_1.png")
background := ui.AddPicture("ys", "img/slide_background_1.jpg")
ui.Show()

det := DdddOcrSlideMatch()
result := det.slide_match("img/slide_target_1.png", "img/slide_background_1.jpg")
frame(background.Hwnd, result.x1, result.y1, result.x2, result.y2)

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