//Fill these
const NextCloudUserName = "";
const SourceHost = "img.domain.com";
const TargetHost = "nextcloud.domain.com";

const picExt = [
  "ico",  //This is needed for favicon
  "jpg",
  "png",
  "gif",
  "jpeg",
  "bmp",
  "tiff",
  "mp4",
  "svg"
]

function isPic(pathname) {
  let p = pathname.split(".");
  let ext = p[p.length - 1];
  return (picExt.indexOf(ext.toLowerCase()) >= 0);
}

//Entrypoint
addEventListener('fetch', async event => {
  event.respondWith(handleRequest(event))
});
function handleRequest(event){
    let url = new URL(event.request.url);

    //Bypass SSL Challenge and other .well-known
    if (url.pathname.indexOf("well-known") >= 0) {
      return fetch(event.request);
    }

    //Remove Facebook fbclid
    if (null != url.searchParams.get("fbclid")) {
      url.searchParams.delete("fbclid");
    }

    //Remove sourcePath followed by complete targetHostHost
    if (url.pathname.indexOf("sharingpath/" + NextCloudUserName) > 0 && url.hostname == SourceHost) {
      return fetch(new URL(url.pathname, "https://" + TargetHost));
    }

    //Pass to target if it is picture
    if (isPic(url.pathname)) {
      let path = url.pathname;
      return fetch(new URL("index.php/apps/sharingpath/" + NextCloudUserName + "/Public/" + url.pathname, "https://" + TargetHost), {
        headers: {
          'Cache-Control': 'public, max-age=31536000'
        }
      })
    }

    return new Response('Not found', { status: 404 });
}