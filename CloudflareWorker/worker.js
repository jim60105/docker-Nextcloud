//Fill these
const NextCloudUserName = "";
const TargetHost = "cloud.domain.com";
const SourceHost = "img.domain.com";

const picExt = [
  "jpg",
  "png",
  "gif",
  "jpeg",
  "bmp",
  "tiff",
  "ico",  //This is needed for favicon
  "mp4",
  "svg"
]

function isPic(pathname) {
  let p = pathname.split(".");
  let ext = p[p.length - 1];
  return (picExt.indexOf(ext.toLowerCase()) >= 0) ? true : false;
}

//Entrypoint
addEventListener('fetch', async event => {
  event.respondWith(function (event) {
    let url = new URL(event.request.url);

    //Bypass SSL Challenge and other .well-known
    if (url.pathname.indexOf(".well-known") >= 0) {
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
  });
});