const puppeteer = require('puppeteer');
const { PuppeteerScreenRecorder } = require('puppeteer-screen-recorder');
const { PassThrough } = require('stream');
const fs = require('fs');

(async () => {
  const htmlFilePath = process.argv[2];
  const recordingDuration = parseInt(process.argv[3], 10);
  const options = JSON.parse(process.argv[4] || '{}');

  if (!htmlFilePath || isNaN(recordingDuration)) {
    console.error('Missing or invalid arguments. Usage: node record.js "<html_file_path>" <recording_duration>');
    process.exit(1);
  }

  const htmlContent = fs.readFileSync(htmlFilePath, 'utf8');

  const browser = await puppeteer.launch(options);
  const page = await browser.newPage();
  await page.setContent(htmlContent, { waitUntil: 'networkidle0' });

  const recorder = new PuppeteerScreenRecorder(page, {
    followNewTab: false,
    fps: 25,
    recordDurationLimit: recordingDuration
  });

  const pipeStream = new PassThrough();
  pipeStream.pipe(process.stdout);

  await recorder.startStream(pipeStream);

  await new Promise(resolve => setTimeout(resolve, recordingDuration * 1000));

  await recorder.stop();
  await browser.close();
})();
