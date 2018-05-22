## Notice
It is a Mac OS X theming project still under development. But good enough to be released for pratical use. There are  some places left undone. Here are several key issues:

* How to change the system font to LucidaGrande without any truncated text. (Unperfectly realization by  https://github.com/LumingYin/macOSLucidaGrande )
* ~~How to change the sidebar color to blue tint~~ ---> Sloved. Using a SIMUL plugin called FB eye™ Controller. **GLORIA !!**
* How to theme menu bar (give it a gradiant OR toggle the system default translucent for menu bar only, without affect other "Reduce transparency" effect )
* How to change Tag dots in Finder sidebar and context menu.



## How to install
0. download the whole repository.
1. The main files are those .car file in  `Resource-stable`. They should replace the system file in `/System/Library/CoreServices/SystemAppearance.bundle/Contents/Resources`. Search "Theme engine" for detailed information.
2. Check "Reduce transparency" in System Preference to see change in context menu.


3. Icon resources could be found in `elements`
   Many other icon/png/tiff need to be replaced mannually (if only you have time for that):

   `/System/Library/CoreServices/CoreTypes.bundle`

   `/System/Library/Input Methods/`

   `/System/Library/PreferencePans/`

   `/System/Library/PrivateFrameworks/CalendarUI/`

   `/System/Library/CoreServices/Menu Extras`

   `/System/Library/PrivateFrameworks/CoreWLANKit.framework/Versions/A/Resources/Assets.car`


## Preview

![Preview](/Users/siruili/Desktop/Collection/Cutup/DeviantArt/Aqua Capitan/Preview.png)



## TODO

AccessibilityAppearance.car: 打开辅助功能后的增加对比度之后的UI

小按钮的替换还没有完成：例如TextEdit.app富文本编辑时。