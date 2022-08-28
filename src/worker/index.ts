import dotenv from "dotenv";
import LastFm from "@toplast/lastfm";
import { createStarBar } from "./chart";
import { GistBox } from "gist-box";

const runWorker = async () => {
  console.log(`Running worker at ${new Date().toISOString()}`);
  dotenv.config();
  const lastFmApi = new LastFm(process.env.LASTFM_API_KEY || "");

  const { toptracks } = await lastFmApi.user.getTopTracks({
    user: process.env.LASTFM_TARGET_USER || "",
    period: "7day",
  });

  const maxPlays = toptracks.track.reduce(
    (max, track) => Math.max(max, Number(track.playcount)),
    0
  );

  const trackSummary = toptracks.track.slice(0, 100).map((track) => {
    return `${createStarBar(Number(track.playcount), maxPlays)} (${
      track.playcount
    }x) **${track.name}** by ${track.artist.name}`;
  });

  const box = new GistBox({
    id: process.env.GIST_TARGET || "",
    token: process.env.GIST_API_KEY || "",
  });

  await box.update({
    filename: process.env.GIST_TARGET_NAME || "",
    content: `${trackSummary.join("  \n")}  \nUpdated last at ${new Date()}`,
  });
  console.log(`Worker finished at ${new Date().toISOString()}`);
};

export { runWorker };
