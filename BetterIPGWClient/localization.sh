ibtool --generate-strings-file zh-Hans.lproj/zh.strings zh-Hans.lproj/MainStoryboard_iPhone.storyboard
ibtool --generate-strings-file en.lproj/en.strings en.lproj/MainStoryboard_iPhone.storyboard
ibtool --strings-file en.lproj/en.strings --write en.lproj/MainStoryboard_iPhone.storyboard zh-Hans.lproj/MainStoryboard_iPhone.storyboard 
