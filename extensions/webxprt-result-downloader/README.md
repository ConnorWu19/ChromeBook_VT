# CBVT WebXPRT Result Downloader

This extension watches the interactive WebXPRT 4 result page. It downloads the CSV through Chrome's Downloads API when either of these appears:

1. WebXPRT's **Download results** link; or
2. a displayed seven-digit **Test ID**, from which it constructs the verified result-download URL.

The result page remains open, so the Toolkit's scheduled screenshot captures the displayed score.

## Install on the DUT

1. Open `chrome://extensions` in Chrome.
2. Enable **Developer mode**.
3. Select **Load unpacked** and choose this `webxprt-result-downloader` folder.
4. Keep the extension enabled while running WebXPRT 4.

Chrome saves the CSV using its configured Downloads location, normally `/home/chronos/user/MyFiles/Downloads` on the DUT.

The extension accepts only this WebXPRT 4 result URL shape:

`https://www.principledtechnologies.com/benchmarkxprt/webxprt/2021/wx4_build_3_7_3/resultdownlaod.php?c=<Test_ID>&testtype=1`
