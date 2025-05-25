# FaceTracking and Overlay

FaceTracking and Overlayは、iOSのARKitを使用して、顔のトラッキングとオーバーレイを行うアプリケーションです。
取得したデータはリアルタイムで可視化し、ファイルへの書き出しが可能です。

# pythonディレクトリ以下での操作

> [!IMPORTANT]
> このプロジェクトのPythoのバージョンは3.10です。
> Pythonのバージョンが3.10以外の場合、動作しない可能性があります。

## ディレクトリの移動

```sh
$ cd python
```

## 仮想環境を作成

```sh
$ python -m venv .venv
```

## 仮想環境をアクティベート

```sh
$ . .venv/bin/activate
```

## とりあえず必要そうな依存関係を入れる

```sh
$ pip install -r requirements.txt
```

## 端末からのファイルの取得

アプリを起動した端末で、ファイルアプリを開いて、facetracking-and-overlayフォルダを開くと、端末のストレージに保存されているファイルが見えます。
その中からデータの取得を起こった時間のファイルを指定して、AirDropやメールなどで送信してください。
