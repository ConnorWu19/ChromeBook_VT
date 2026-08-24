const RESULT_ORIGIN = "https://www.principledtechnologies.com";
const RESULT_PATH = "/benchmarkxprt/webxprt/2021/wx4_build_3_7_3/resultdownlaod.php";

function isWebXprtResultUrl(rawUrl) {
  try {
    const url = new URL(rawUrl);
    return url.origin === RESULT_ORIGIN &&
      url.pathname === RESULT_PATH &&
      /^\d+$/.test(url.searchParams.get("c") || "") &&
      url.searchParams.get("testtype") === "1";
  } catch (_) {
    return false;
  }
}

chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
  if (message?.type !== "downloadWebXprtResult" || !isWebXprtResultUrl(message.url)) {
    return;
  }

  chrome.downloads.download(
    {
      url: message.url,
      conflictAction: "uniquify",
      saveAs: false,
    },
    (downloadId) => {
      if (chrome.runtime.lastError) {
        sendResponse({ ok: false, error: chrome.runtime.lastError.message });
        return;
      }

      console.info("CBVT started WebXPRT result download", downloadId);
      sendResponse({ ok: true, downloadId });
    },
  );

  return true;
});
