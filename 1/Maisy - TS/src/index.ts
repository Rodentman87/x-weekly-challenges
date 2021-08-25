import fs from "fs";
import ansi from "ansi";
import { Track } from "./Track";

(async () => {
	const track = new Track(fs.readFileSync("./track.txt", "utf-8"));
	const cursor = ansi(process.stdout);
	cursor.hide();
	cursor.goto(1, 1);
	for (let i = 0; i < 1000; i++) {
		track.tick();
		console.log(track.renderTrack());
		cursor.goto(1, 1);
		await new Promise<void>((resolve) => {
			setTimeout(() => resolve(), 100);
		});
	}
	cursor.reset();
})();
