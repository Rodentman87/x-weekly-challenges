import chalk from "chalk";

export enum Directions {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

export class Track {
	track: string[][];
	cartX: number = 0;
	cartY: number = 0;
	cartDirection: Directions = Directions.RIGHT;

	constructor(track: string) {
		this.track = track.split("\n").map((str) => str.split(""));
	}

	tick() {
		switch (this.cartDirection) {
			case Directions.RIGHT:
				this.cartX++;
				break;
			case Directions.LEFT:
				this.cartX--;
				break;
			case Directions.UP:
				this.cartY--;
				break;
			case Directions.DOWN:
				this.cartY++;
				break;
		}
		switch (this.track[this.cartY][this.cartX]) {
			case "╚":
				this.cartDirection =
					this.cartDirection === Directions.LEFT
						? Directions.UP
						: Directions.RIGHT;
				break;
			case "╝":
				this.cartDirection =
					this.cartDirection === Directions.RIGHT
						? Directions.UP
						: Directions.LEFT;
				break;
			case "╗":
				this.cartDirection =
					this.cartDirection === Directions.RIGHT
						? Directions.DOWN
						: Directions.LEFT;
				break;
			case "╔":
				this.cartDirection =
					this.cartDirection === Directions.LEFT
						? Directions.DOWN
						: Directions.RIGHT;
				break;
		}
	}

	renderTrack() {
		return this.track
			.map((row, y) => {
				return row
					.map((cell, x) => {
						if (this.cartX === x && this.cartY === y) return chalk.red("c");
						return cell;
					})
					.join("");
			})
			.join("\n");
	}
}
