import Gameboy from 'serverboy'
import path from 'path'
import fs from 'fs'

const gameboy = new Gameboy()

const file_path = path.resolve(__dirname, './game.gba')
const rom = fs.readFileSync(file_path);

gameboy.loadRom(rom)

export default gameboy