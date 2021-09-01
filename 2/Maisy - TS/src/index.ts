import fs from "fs";
import ansi from "ansi";
import { Track } from "./Track";

(async () => {
	const track = new Track(fs.readFileSync("./instructions.txt", "utf-8"));
	const cursor = ansi(process.stdout);
	console.clear();
	cursor.hide();
	while (!track.done) {
		cursor.goto(1, 1);
		track.tick();
		console.log(track.renderTrack());
		await new Promise<void>((resolve) => {
			setTimeout(() => resolve(), 100);
		});
	}
	cursor.goto(1, 1);
	console.log(track.renderTrack(true));
	cursor.reset();
	cursor.show();
})();
