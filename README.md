# cloudwatch

自作カスタムメトリクス集

注意: スクリプト中のパスは Amazon Linux のものとなっています。CentOS など他の OS で利用される場合は適時修正してご利用ください。

## [mysql-thread.sh](https://github.com/torut/cloudwatch/blob/master/bin/mysql-thread.sh)

MySQL のスレッド数をチェックするカスタムメトリクスです。
仕組み的には mysqladmin status を実行してそこからスレッド数を取得します。

### 設定項目

* AWS_CREDENTIAL_FILE<br />
  AWS の AccessKey と SecretKey を記載したファイルの path<br />
  credential.example を credential にリネームして必要な箇所を書き換えてください。
* AWS_REGION<br />
  インスタンスがあるリージョン<br />
  東京リージョンなら ap-northeast-1 です。<br />
  それ以外の場合は下記の参考資料を参考に書き換えてください。
* mysqladmin_cmd<br />
  mysqladmin コマンドの path
* mysqladmin_opt<br />
  mysqladmin コマンドのオプション
  * MySQL User<br />
    MySQL のユーザー
  * MySQL User Password<br />
    MySQL User で指定したユーザーのパスワード<br />
	パスワードが不要の場合は -p も含めて削除してください。

### 利用方法
```
$ cd /home/ec2-user/bin
$ git clone git://github.com/torut/cloudwatch.git
$ cd ./cloudwatch
$ cp ./credential.example ./credential
$ vi ./credential
  AWS AccessKey, SecretKey を設定します。
$ chmod 600 ./credential
  他のユーザーから参照されないように読み込み権限を変更します。
$ vi ./bin/mysql-thead.sh
  AWS_CREDENTIAL_PATH, AWS_REGION, mysqladmin_cmd, mysqladmin_opt などを設定します。
$ chmod 700 ./bin/mysql-thread.sh
  他のユーザーから MySQL のパスワードを参照されないように読み込み権限を変更します。
$ ./bin/mysql-thread.sh
  AWS Management Console の CloudWatch のところで Custom Metrics の MySQL にデータが登録されているか確認して下さい。
$ crontab -e
> */5 * * * * ~/bin/cloudwatch/bin/mysql-thread.sh
  crontab に5分毎に実行するように設定します。
```

## [nginx-active_connection.sh](https://github.com/torut/cloudwatch/blob/master/bin/nginx-active_connection.sh)

Nginx の接続数をチェックするカスタムメトリクスです。
仕組み的には Nginx status を取得してそこから接続数を取得します。

### 設定項目

* AWS_CREDENTIAL_FILE<br />
  AWS の AccessKey と SecretKey を記載したファイルの path<br />
  credential.example を credential にリネームして必要な箇所を書き換えてください。
* AWS_REGION<br />
  インスタンスがあるリージョン<br />
  東京リージョンなら ap-northeast-1 です。<br />
  それ以外の場合は下記の参考資料を参考に書き換えてください。
* nginx_status_url<br />
  Nginx status の URL

### Nginx status の設定

Nginx で http_stub_status が有効なことを確認して下さい。
`$ /usr/sbin/nginx -V`
で表示される configure arguments に **--with-http\_stub\_status** が含まれていることを確認して下さい。

nginx.conf で status の設定
下記の例だと http://localhost/stauts でアクセスできるようになります。
```
location /status {
    stub_status on;
    access_log off;
    auth_basic off;
    allow 127.0.0.1;
    deny all;
    break;
}
```

### 利用方法
```
$ cd /home/ec2-user/bin
$ git clone git://github.com/torut/cloudwatch.git
$ cd ./cloudwatch
$ cp ./credential.example ./credential
$ vi ./credential
  AWS AccessKey, SecretKey を設定します。
$ chmod 600 ./credential
  他のユーザーから参照されないように読み込み権限を変更します。
$ vi ./bin/nginx-active_connection.sh
  AWS_CREDENTIAL_PATH, AWS_REGION, nginx_status_url などを設定します。
$ chmod 700 ./bin/nginx-active_connection.sh
  他のユーザーから 参照されないように読み込み権限を変更します。
$ ./bin/nginx-active_status.sh
  AWS Management Console の CloudWatch のところで Custom Metrics の Nginx にデータが登録されているか確認して下さい。
$ crontab -e
> */5 * * * * ~/bin/cloudwatch/bin/nginx-active_connection.sh
  crontab に5分毎に実行するように設定します。
```

## 連絡先
Issue: [GitHub](https://github.com/torut/cloudwatch/issues)


## 参考資料
### リージョンリスト
|コード        |名前                                        |
| ------------ | ------------------------------------------ |
|ap-northeast-1|アジアパシフィック（東京）リージョン        |
|ap-southeast-1|アジアパシフィック（シンガポール）リージョン|
|ap-southeast-2|アジアパシフィック（シドニー）リージョン    |
|eu-west-1     |欧州（アイルランド）リージョン              |
|sa-east-1     |南米（サンパウロ）リージョン                |
|us-east-1     |米国東部（バージニア北部）リージョン        |
|us-west-1     |米国西部（北カリフォルニア）リージョン      |
|us-west-2     |米国西部（オレゴン）リージョン              |

