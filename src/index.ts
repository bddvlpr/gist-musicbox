import { runWorker } from "./worker";

(() => {
  runWorker();
  setInterval(() => runWorker(), 1000 * 60 * 30);
})();
