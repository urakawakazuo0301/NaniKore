# アプリケーション名
ナニこれ？

# アプリケーション概要
付属品を、写真で分かりやすく一元管理できるアプリ

# URL

https://nanikore-app.onrender.com/

# テスト用アカウント

アドレス：test@test.com  
パスワード：test1234

# 利用方法
## アイテム登録
1.トップページのヘッダーにある《新規登録》ボタンをクリックし、新規登録を行う  
2.トップページの《アイテム登録》ボタンをクリックし、アイテム登録を行う（画像は3枚まで）

[![アイテム登録](https://github.com/urakawakazuo0301/NaniKore/blob/main/public/images/thumbnail.png)](https://drive.google.com/file/d/1r8XVpcXJibg0BWYTo--skHOtWeXXQ1tj/view?usp=drive_link)

## アイテム検索
1.トップページのフォームから条件を絞り、検索結果を表示する（条件を絞らなければ全アイテムの表示、名前と備考欄はフリーワード検索可能）

[![アイテム検索](https://github.com/urakawakazuo0301/NaniKore/blob/main/public/images/thumbnail.png)](https://drive.google.com/file/d/1vskOWh_JzmYHsHbm-GVWJUAMyBGBvU93/view?usp=sharing)

## アイテム編集・削除・使用済み/未使用の切り替え
1.検索結果のアイテムをクリックすると、そのアイテムの詳細画面に遷移する  
2.アイテム詳細画面には《編集》《削除》《使用済み/未使用》ボタンがあり、《編集》ボタンをクリックするとアイテムの詳細を編集できる  
3.《削除》ボタンをクリックすると、アイテムを削除できる（削除前にアラート表示が出る）  
4.《使用済み/未使用》ボタンをクリックすると、そのアイテムの検索結果一覧画面に《使用済み》か《未使用》かどうか表示できる

[![アイテム編集・削除・使用済み/未使用の切り替え](https://github.com/urakawakazuo0301/NaniKore/blob/main/public/images/thumbnail2.png)](https://drive.google.com/file/d/1KHgJliht1HgJqnzwzXt8kmmEL3MvzD0V/view?usp=sharing)

# 画面遷移図
![プレビュー](https://github.com/urakawakazuo0301/NaniKore/blob/main/Nanikore1.drawio.svg)

# ER図
![プレビュー](https://github.com/urakawakazuo0301/NaniKore/blob/main/NaniKore2.drawio.svg)

# テーブル設計

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| nickname           | string | null: false |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false |

### Association

 - has_many :items


## items テーブル

| Column            | Type       | Options     |
| ----------        | ---------- | ----------- |
| name              | string     | null: false |
| category_id       | integer    | null: false |
| quantity_id       | integer    | null: false |
| notes             | text       |             |
| color_id          | integer    |             |
| used              | integer    |             |
| user              | references | null: false, foreign_key: true |

### Association

 - belongs_to :user

# アプリケーションを作成した背景

先日、自宅のイスが壊れた際に、付属のネジを探そうとしましたが、思っていた場所に見当たらず、結局家中を探し回る羽目になりました。  
その時、もし付属品を写真で管理できるアプリがあれば、何年も使わずに保管している付属品でもすぐに見つけられるのに、と感じました。  
そこで、このアプリの制作を決意しました。  
ただ写真で保存するだけでなく、フリーワード検索や数量、色など、さまざまな条件で簡単に付属品を探し出せる工夫も取り入れています。

# 実装予定の機能
- ユーザー共有機能
- 画像のスライドショー
- フォームのポップアップ表示
- パスワードを再設定できるようにする

# 開発環境
- HTML
- CSS（TailWindCSS）
- JavaScript（Stimulus.js・FontAwesome）
- Ruby on Rails（Active Storage・Devise）

# 工夫した点
1つ目は、アイテム登録や編集時に写真を複数枚登録でき、さらにプレビュー表示機能を実装したことです。  
付属品はすぐに使うこともあれば、長期間保管する場合もあります。そのため、1枚だけでなく、最大3枚まで写真を保存できるようにしました。  
また、誤って別のアイテムの写真を登録することを防ぐために、プレビュー機能を追加し、登録の利便性と正確性を向上させています。 

2つ目は、ドラッグ＆ドロップ機能を実装したことです。  
このアプリは、スマホやタブレットでの使用を主に考えており、携帯性と機動性を重視しています。  
しかし、アプリ導入時には多くのアイテムを一括で登録する場面も想定されます。  
そこで、ドラッグ＆ドロップ機能を実装し、効率的に登録作業を進められるようにしました。  
パソコンでは既存の画像を簡単に登録でき、スマホやタブレットではデバイスのカメラを起動して画像を登録できる仕組みになっています。

3つ目は、使用済み／未使用の切り替えボタンを実装したことです。  
アイテムは一度使用しても、その後も引き続き使う場合があります。  
しかし、数カ月や数年後にアイテムが必要になった時、使用済みかどうかを忘れてしまうことがあるでしょう。  
そこで、使用後にアイテムを削除するのではなく、使用済みに切り替えてデータを保持することで、必要な時に明確な情報を確認できるようにしました。