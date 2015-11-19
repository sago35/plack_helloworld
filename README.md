# plack_helloworld
plackで昔っぽい掲示板もどきを作成

## 使い方

```
# 実行
$ plackup sample.psgi

# 以下のURLにアクセスする
http://localhost:5000/
```

## コードについて

以下で/post向けと/向けをdispatchする。
`Plack::Builder`だと大げさすぎるらしいですが、perl鍋内の時間でやりくりするので選ぶ時間が無かった。

```perl
use Plack::Builder;

builder {
    mount "/post", => $post;
    mount "/", => $app;
}
```
