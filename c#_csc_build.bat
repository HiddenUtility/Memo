@echo off

csc -target:library Reader.cs Writer.cs
csc Program.cs /reference:Reader.dll /reference:Writer.dll

rem ちなみに、/target:winexe を /target:exe にすると、コンソールアプリケーションになります。

cmd