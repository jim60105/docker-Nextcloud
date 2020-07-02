# Nextcloud+Docker+定時備份

## 架構
nginx做Reverse Proxy ─ SSL證書申請、Renew\
│ ┌ MariaDB資料庫\
├ Nextcloud\
└ Jobber(Cron)\
　├ 定時Backup Docker volume\
　└ Backup完送至rsync server

## 說明
* 備份檔會儲存在主機的 `/backup`
* 請參考 `*.env_sample` 建立 `*.env`
* rsync ssh passwd 明碼放在 `/root/ssh.pas`，chown root
* Jobber會運行`shellScript/backup.sh && shellScript/upload.sh `，請參考 `upload.sh_sample` 建立 `upload.sh`
* 正式發佈前移除 `.env` 中的 `LETSENCRYPT_TEST=true`\
此設定為SSL測試證書\
正式版有申請次數上限，務必在測試正常、最後上線前再移除

### img圖片縮址和DNS設定
img網域的縮址如下:\
`https://img.domain.com/OOXX` = \
`https://nextcloud.domain.com/index.php/apps/sharingpath/<NEXTCLOUDUSERNAME>/Public/OOXX`

### Cloudflare設定
推薦使用Cloudflare做DNS和Cache設定\
Cloudflare Worker是img縮址的主要邏輯\
CDN的SSL設定如此是為了讓Let's Encrypt能成功訪問\
DNS Record有三條，一條A指向SERVER_IP，另倆CNAME指向A Record

Cache只設定於cloud和img倆網域上，nextcloud網域direct用做日常操作，以免Cache造成回應錯誤，
而分享時使用cloud網域和img網域，可以節省主機流量，Cloudflare能夠抓住近99%

* DNS
	* A: `nextcloud.domain.com` → SERVER_IP (DNS Only)
	* CNAME: `cloud.domain.com` → `nextcloud.domain.com` (Proxied)
	* CNAME: `img.domain.com` → `nextcloud.domain.com` (Proxied)
* SSL/TLS
	* Always Use HTTPS: **Off**
	* HTTP Strict Transport Security (HSTS): **Disabled**
	* Automatic HTTPS Rewrites: (Can enable if needed)
* Caching
	* Caching Level: Standard
* Worker
	* 建一個Worker，內容為`Cloudflare/worker.js`
	* Route `img.domain.com` 至此Worker
* Page Rule
	1. `*domain.com/.well-known/acme-challenge*`
		* **Disable Everything**
		* Cache Level: Bypass
	1. `nextcloud.domain.com/index.php/apps/sharingpath/<NEXTCLOUDUSERNAME>/Public/*`
		* Disable Security
		* Browser Integrity Check: Off
		* SSL: Full
		* Browser Cache TTL: a year
		* Cache Level: Cache Everything
		* Edge Cache TTL: a month
		* Automatic HTTPS Rewrites: On
		* Disable Performance
	1. `https://cloud.maki0419.com/*`
		* SSL: Full
		* Rocket Loader: Off
		* Cache Level: Cache Everything
		* Automatic HTTPS Rewrites: On
		* Disable Apps

### Nextcloud設定
1. 安裝應用程式: Sharing Path\
※**注意**: Sharing Path會開啟「以路徑直鏈訪問公開檔案」功能，雖然方便，但會導致路徑可猜的資安問題\
故**建議此Nextcloud只存放低敏感度資料**
1. 右上角「設定→個人-分享→Sharing Path」，勾上Enable sharing path
1. 「設定→管理-分享」，勾選以下項目
	* 允許 apps 使用分享 API
	* 允許使用者透過連結分享
		* 允許公開上傳
	* 允許使用者名稱自動補齊在分享對話框
	* 允許這台伺服器上的使用者發送分享給其他伺服器
	* Search global and public address book for users 
1. 在Nextcloud根目錄新增Public資料夾，此資料夾開啟外部唯讀分享，做為分享的根目錄
1. Public資料夾下放做為img網域的favicon.ico，即`Public/favicon.ico`
