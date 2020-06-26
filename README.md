# Nextcloud+Docker+定時備份

## 描述
* nginx做Reverse Proxy
  * SSL證書申請、Renew
  * port管理
* Nextcloud
* MariaDB
* Jobber(Cron)
  * 定時Backup Docker volume
  * Backup完送至rsync server

## 設置指示
* 備份檔會儲存在主機的 /backup
* 請按照兩個sample檔建立env檔
* rsync ssh passwd 放在明碼/root/ssh.pas，chown root
* 移除docker-compose.yml中的 `letsencrypt-companion:environment:LETSENCRYPT_TEST=true`\
(此設定為測試的SSL證書。正式版有申請次數上限，最後上線時再移除)