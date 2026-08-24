const RESULT_PATH = "/benchmarkxprt/webxprt/2021/wx4_build_3_7_3/resultdownlaod.php";
const downloadedResultUrls = new Set();

function isWebXprtResultUrl(url) {
  return url.origin === "https://www.principledtechnologies.com" &&
    url.pathname === RESULT_PATH &&
    /^\d{7}$/.test(url.searchParams.get("c") || "") &&
    url.searchParams.get("testtype") === "1";
}

function buildResultUrl(testId) {
  const resultUrl = new URL(RESULT_PATH, "https://www.principledtechnologies.com");
  resultUrl.searchParams.set("c", testId);
  resultUrl.searchParams.set("testtype", "1");
  return resultUrl;
}

function findDisplayedTestId() {
  const pageText = document.body?.innerText || "";
  const testIdMatch = pageText.match(/\btest\s*id\b\s*(?:[:=#-]\s*)?(\d{7})\b/i);
  return testIdMatch?.[1] || null;
}

function requestResultDownload(resultUrl, source) {
  if (downloadedResultUrls.has(resultUrl.href)) {
    return;
  }

  downloadedResultUrls.add(resultUrl.href);
  chrome.runtime.sendMessage(
    { type: "downloadWebXprtResult", url: resultUrl.href },
    (response) => {
      if (chrome.runtime.lastError || !response?.ok) {
        downloadedResultUrls.delete(resultUrl.href);
        console.warn("CBVT could not download the WebXPRT result.", chrome.runtime.lastError || response?.error);
        return;
      }

      console.info(`CBVT started WebXPRT result download from ${source}.`, resultUrl.href);
    },
  );
}

function discoverCompletedResult() {
  for (const anchor of document.querySelectorAll("a[href]")) {
    let resultUrl;

    try {
      resultUrl = new URL(anchor.href, window.location.href);
    } catch (_) {
      continue;
    }

    if (!isWebXprtResultUrl(resultUrl)) {
      continue;
    }

    requestResultDownload(resultUrl, "the Download results link");
    return;
  }

  const testId = findDisplayedTestId();
  if (testId) {
    requestResultDownload(buildResultUrl(testId), `displayed Test ID ${testId}`);
  }
}

const resultLinkObserver = new MutationObserver(discoverCompletedResult);
resultLinkObserver.observe(document.documentElement, {
  childList: true,
  characterData: true,
  subtree: true,
});
discoverCompletedResult();
