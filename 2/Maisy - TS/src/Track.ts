import chalk from "chalk";
import stringLength from "string-length";

export enum Directions {
	UP = "N",
	DOWN = "S",
	LEFT = "W",
	RIGHT = "E",
}

export class Track {
	// Store the track state and upcoming instructions
	track: string[][];
	instructions: string[];
	cartX: number = 0;
	cartY: number = 0;

	// Store some info about the current instruction
	currentInstructionDirection: Directions;
	lastInstructionDirection: Directions;
	currentInstructionCount: number;

	// Extra meta info
	originalInstLength: number;
	done: boolean = false;

	constructor(instructions: string) {
		this.originalInstLength = instructions.length;
		this.instructions = instructions.split(" ");
		this.loadNextInstruction();
		this.track = [this.makeEmptyRow(3)];
		this.track[0][0] = "╔";
	}

	makeEmptyRow(length: number) {
		return " ".repeat(length).split("");
	}

	tick() {
		// Move
		switch (this.currentInstructionDirection) {
			case Directions.UP:
				this.cartY--;
				break;
			case Directions.DOWN:
				this.cartY++;
				if (this.cartY > this.track.length - 1) {
					// Add a new row to the track if we've gone too far
					this.track.push(this.makeEmptyRow(this.track[0].length));
				}
				break;
			case Directions.LEFT:
				this.cartX--;
				break;
			case Directions.RIGHT:
				this.cartX++;
				if (this.cartX > this.track[0].length - 1) {
					// Add a new row to the track if we've gone too far
					this.track.forEach((row) => row.push(" "));
				}
				break;
		}
		// Place track
		switch (this.track[this.cartY][this.cartX]) {
			case "═":
			case "║":
				this.track[this.cartY][this.cartX] = "╬";
				break;
			default:
				this.track[this.cartY][this.cartX] = this.isMovingHorizontal()
					? "═"
					: "║";
				break;
		}
		this.currentInstructionCount--;
		// Check instruction
		if (this.currentInstructionCount === 0) {
			// Grab next instruction
			if (this.instructions.length < 1) {
				this.track[0][0] = "╔"; // Make sure the upper left corner stays correct
				this.currentInstructionCount = 0;
				this.done = true;
				return;
			}
			this.loadNextInstruction();
			// Turn track under us into a corner
			switch (this.currentInstructionDirection) {
				case Directions.UP:
					this.track[this.cartY][this.cartX] =
						this.lastInstructionDirection === Directions.LEFT ? "╚" : "╝";
					break;
				case Directions.DOWN:
					this.track[this.cartY][this.cartX] =
						this.lastInstructionDirection === Directions.LEFT ? "╔" : "╗";
					break;
				case Directions.LEFT:
					this.track[this.cartY][this.cartX] =
						this.lastInstructionDirection === Directions.UP ? "╗" : "╝";
					break;
				case Directions.RIGHT:
					this.track[this.cartY][this.cartX] =
						this.lastInstructionDirection === Directions.UP ? "╔" : "╚";
					break;
			}
		}
	}

	isMovingHorizontal() {
		return (
			this.currentInstructionDirection === Directions.LEFT ||
			this.currentInstructionDirection === Directions.RIGHT
		);
	}

	loadNextInstruction() {
		this.lastInstructionDirection = this.currentInstructionDirection;
		const next = this.instructions.shift();
		const dir = next?.substr(0, 1);
		const len = next?.substring(1);
		switch (dir) {
			case "E":
				this.currentInstructionDirection = Directions.RIGHT;
				break;
			case "W":
				this.currentInstructionDirection = Directions.LEFT;
				break;
			case "S":
				this.currentInstructionDirection = Directions.DOWN;
				break;
			case "N":
				this.currentInstructionDirection = Directions.UP;
				break;
		}
		this.currentInstructionCount = parseInt(len!);
	}

	getCartChar() {
		switch (this.currentInstructionDirection) {
			case Directions.UP:
				return "^";
			case Directions.DOWN:
				return "v";
			case Directions.LEFT:
				return "<";
			case Directions.RIGHT:
				return ">";
		}
	}

	addBox(input: string) {
		const length = stringLength(input.split("\n")[0]); // Get length using string-length to deal with ansi escape and other stuffs
		const top = "┌" + "─".repeat(length) + "┐";
		const rows = input.split("\n").map((row) => {
			return "│" + row + "│";
		});
		const bottom = "└" + "─".repeat(length) + "┘";
		return top + "\n" + rows.join("\n") + "\n" + bottom;
	}

	renderTrack(noCart: boolean = false) {
		const instructions =
			this.currentInstructionDirection +
			this.currentInstructionCount +
			" " +
			this.instructions.join(" ");

		// Pad the instruction string with spaces to clear out the old line
		const paddedInstructions =
			instructions + " ".repeat(this.originalInstLength - instructions.length);

		const trackString = this.track
			.map((row, y) => {
				return row
					.map((cell, x) => {
						if (this.cartX === x && this.cartY === y && !noCart)
							return chalk.red(this.getCartChar());
						return cell;
					})
					.join("");
			})
			.join("\n");

		return this.addBox(paddedInstructions) + "\n" + this.addBox(trackString);
	}
}
