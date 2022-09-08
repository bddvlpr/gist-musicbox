import { runWorker } from "./worker";

(() => {
  runWorker();
  setInterval(
    () => runWorker(),
    Number(process.env.TIME_INTERVAL) || 1000 * 60 * 30
  );
})();
