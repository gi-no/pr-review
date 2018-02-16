# pr police

## セットアップ

### gemのインストール

```
$ gem install clockwork
$ gem install dotenv
$ gem install slack-incoming-webhooks
$ gem install business_time
```

### 環境変数の設定

```
$ cp .env.example .env
$ cp slack_users_example.rb slack_users.rb
```

`.env`、`slack_users.rb`の値を環境に合わせて変更してください。

### 起動

```
clockwork clock.rb
```
