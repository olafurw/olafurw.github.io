---
layout: post
title: Taking a 'Screenshot' of an application with OpenCV
tags: [c++, opencv, windows]
comments: false
---

I've been writing more bots recently and this function has always been quite useful. It has evolved over time and it's not in any way perfect but it has been a solid soldier in the wars I have used it in.

It takes a HDC and converts it to a OpenCV material.

Getting the HDC is just a matter of

```cpp
HWND window = FindWindow(NULL, locGameWindowName);
HDC hwindowDC = GetDC(window);
```

Before you do anything, those 2 lines should be called before your while(true){} loop. You might have access problems a few minutes into the runtime if you do not. (I actually don't know why, I tried googling it but with no success)

But anyways here's the function if it can help anyone. The sizes are global in this case but that's only because I copied it from a project where I'm still messing with the structure of everything.

This function can be put into your main loop to be called every frame to fetch the new frame data from the application you are capturing from.

Please yell at me on Twitter if there are any major problems with this, I've had this thing run for hours quite smoothly.

```cpp
bool
WindowToMaterial(
    HDC         aWindowDC,
    cv::Mat&    aMaterial)
{
    HDC hwindowCompatibleDC = CreateCompatibleDC(aWindowDC);
    if (!hwindowCompatibleDC)
    {
        return false;
    }

    if (!SetStretchBltMode(hwindowCompatibleDC, COLORONCOLOR))
    {
        DeleteDC(hwindowCompatibleDC);
        return false;
    }

    HBITMAP hbwindow = CreateCompatibleBitmap(aWindowDC, locWindowWidth, locWindowHeight);
    if (!hbwindow)
    {
        DeleteDC(hwindowCompatibleDC);
        return false;
    }

    BITMAPINFOHEADER bi;
    bi.biSize = sizeof(BITMAPINFOHEADER);
    bi.biWidth = locWindowWidth;
    bi.biHeight = -locWindowHeight;
    bi.biPlanes = 1;
    bi.biBitCount = 32;
    bi.biCompression = BI_RGB;
    bi.biSizeImage = 0;
    bi.biXPelsPerMeter = 0;
    bi.biYPelsPerMeter = 0;
    bi.biClrUsed = 0;
    bi.biClrImportant = 0;

    if (!SelectObject(hwindowCompatibleDC, hbwindow))
    {
        DeleteObject(hbwindow);
        DeleteDC(hwindowCompatibleDC);
        return false;
    }

    if (!StretchBlt(
            hwindowCompatibleDC, 
            0, 0, 
            locWindowWidth, locWindowHeight, 
            aWindowDC, 
            0, 0, 
            locWindowWidth, locWindowHeight, 
            SRCCOPY))
    {
        DeleteObject(hbwindow);
        DeleteDC(hwindowCompatibleDC);
        return false;
    }

    aMaterial.release();
    aMaterial.create(locWindowHeight, locWindowWidth, CV_8UC4);

    if (!GetDIBits(
            aWindowDC, 
            hbwindow, 
            0, 
            locWindowHeight, 
            aMaterial.data, 
            (BITMAPINFO *)&bi, 
            DIB_RGB_COLORS))
    {
        aMaterial.release();
        DeleteObject(hbwindow);
        DeleteDC(hwindowCompatibleDC);
        return false;
    }

    DeleteObject(hbwindow);
    DeleteDC(hwindowCompatibleDC);

    const bool success = aMaterial.cols > 0 && aMaterial.rows > 0;
    if (!success)
    {
        aMaterial.release();
    }

    return success;
}
```