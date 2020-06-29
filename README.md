# Nextcloud+Docker+定時備份

## 描述
* nginx做Reverse Proxy
  * SSL證書申請、Renew
* Nextcloud
* MariaDB
* Jobber(Cron)
  * 定時Backup Docker volume
  * Backup完送至rsync server

## 設置指示
* 備份檔會儲存在主機的 `/backup`
* 請參考 `*.env_sample` 建立 `*.env`
* rsync ssh passwd 明碼放在 `/root/ssh.pas`，chown root
* 正式發佈前移除 `app.env` 中的 `LETSENCRYPT_TEST=true`\
(此設定為測試SSL證書。正式版有申請次數上限，務必在最後上線前再移除)