# Abstract

```
基本的にどのランタイムをターゲットにするかで環境変わる

WPE .NET 5以降
    donetcore で開発できる。
    ほとんどの人がランタイム入れてくれてないので、サーバーサイドむけかなぁ

.NET Framework 4系

windows7以降ならほとんどの人が持っているラインタイム
多くの人に使ってもらうならこれかな

ネイティブ c/c++
https://qiita.com/cubeundcube/items/93c210f8516c9468f5e5



VSCodeもBuildToolsもhttps://visualstudio.microsoft.com/ja/downloads/
からGET出来る。



```

# NET5以降
```
スケルトン生成
ターミナルにてdotnet new wpfを実行すると、カレントフォルダに、空のウインドウを表示するプロジェクトのファイル群が自動生成される。
（ちなみにwpfの部分はconsoleとかwinformsにも出来る。）

リリースビルド時にデバッグ情報が入らないようにする
プロジェクトファイル（.csproj）の<PropertyGroup>タグ内に、下記の要素を追加。
<DebugType Condition="'$(Configuration)' == 'Release'">none</DebugType>

発行
ターミナルにて下記コマンドを実行。
dotnet publish -c:Release -r:win10-x86 -p:PublishReadyToRun=true -p:PublishSingleFile=true --self-contained:false

それぞれのスイッチの意味は

-c:Release … リリースビルド
-r:win10-x86 … ターゲットをWindows 10 32bitにする（64bitアプリを作る場合は-r:win10-x64にする）
-p:PublishReadyToRun=true … 事前コンパイル方式にする、つまり初回から起動が速くなる
-p:PublishSingleFile=true … 出力ファイルを1つのexeファイルにまとめる
--self-contained:false … ランタイムを含めない
なお、--self-contained:trueにしてさらに-p:IncludeNativeLibrariesForSelfExtract=trueも加えると、ランタイム込みの単一exeが爆誕するが、サイズはえらいことになる。

下記json

{
	"version": "2.0.0",
	"tasks": [
		{ "（中略、下記追加）": "" },
		{
			"label": "publish(x86)",
			"command": "dotnet",
			"type": "process",
			"args": [
				"publish",
				"-c:Release",
				"-r:win10-x86",
				"-p:PublishReadyToRun=true",
				"-p:PublishSingleFile=true",
				"--self-contained:false",
			],
			"problemMatcher": "$msCompile"
		},
		{"（追加ここまで）": ""}
	]
}

```


# NET4以前
```
スケルトン作成
ターミナルにて dotnet new wpf を実行したのち、プロジェクトファイルを修正。

<Project Sdk="Microsoft.NET.Sdk">を<Project Sdk="Microsoft.NET.Sdk.WindowsDesktop">に変更
<TargetFramework>net5.0-windows</TargetFramework>を<TargetFramework>net47</TargetFramework>に変更
net47の部分は「TFM」というらしく、一覧表がMS公式のページに載っている。もちろんBuildToolsのインストール時に、該当バージョンのTargeting Packをインストールしておく必要がある。

また、割と新しめの名前空間（System.Net.Httpとか）を使おうとすると「存在しません」とか言われて怒られるので、プロジェクトファイルの<PropertyGroup>タグと同じ階層に下記を追加する。

  <ItemGroup>
    <Reference Include="System.Net.Http"/>
  </ItemGroup>


プロジェクトファイルの一例

<Project Sdk="Microsoft.NET.Sdk.WindowsDesktop">

  <PropertyGroup>
    <OutputType>WinExe</OutputType>
    <TargetFramework>net47</TargetFramework>
    <UseWPF>true</UseWPF>
    <DebugType Condition="'$(Configuration)' == 'Release'">none</DebugType>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="System.Net.Http"/>
  </ItemGroup>

</Project>

デバッグ
「実行」→「構成の追加」→「.NET Core」で、「launch.json」は作られるが、「tasks.json」が作られないので、「ターミナル」→「タスクの構成」と進み「テンプレートから tasks.json を生成」「.NET Core」を選択していき、「tasks.json」を生成させる。
「launch.json」がそのままでは動かないので、下記を修正。

"type"の値を、"coreclr"から"clr"に変更（2か所あると思う）
"program"の値を、"${workspaceFolder}/bin/Debug/net47/（プロジェクト名）.exe"に変更
プロジェクト名（.csprojの拡張子の前の部分）が「net47test」の場合、「launch.json」は下記のようになる。

下記launch.jsonの例


{
	"version": "0.2.0",
	"configurations": [
		{
			"name": ".NET Core Launch (console)",
			"type": "clr",
			"request": "launch",
			"preLaunchTask": "build",
			"program": "${workspaceFolder}/bin/Debug/net47/net47test.exe",
			"args": [],
			"cwd": "${workspaceFolder}",
			"console": "internalConsole",
			"stopAtEntry": false
		},
		{
			"name": ".NET Core Attach",
			"type": "clr",
			"request": "attach",
			"processId": "${command:pickProcess}"
		}
	]
}

```