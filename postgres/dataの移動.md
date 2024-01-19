# windows版postgresのdataフォルダ移動方法

- 現在のdataがあるディレクトリを移したい場所にコピーする`-D"C:\ProgramFiles\...\data"`   
- w + r で `services.msc`をサービスを起動(まだ消さない)   
- 該当となる`postgres`をサービス停止
- w + r で `regedit`を起動 　　
- `コンピューター\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\****`の該当するpostgresを選択　　
- `ImagePath`を編集　`-D"C:\ProgramFiles\..."`の部分を変更したいPath箇所に変更   
- サービスから`postgres`をサービス開始   
- psql等でデータ移っているか確認  
- 元のdataは削除してOK
