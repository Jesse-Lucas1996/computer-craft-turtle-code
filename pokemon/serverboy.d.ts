declare module 'serverboy' {
  /**
   * Keymap constants for gameboy controls
   */
  export interface KeyMap {
    RIGHT: 0;
    LEFT: 1;
    UP: 2;
    DOWN: 3;
    A: 4;
    B: 5;
    SELECT: 6;
    START: 7;
  }

  /**
   * Valid key codes for gameboy input
   */
  export type KeyCode = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7;

  /**
   * Valid key names for gameboy input
   */
  export type KeyName = 'RIGHT' | 'LEFT' | 'UP' | 'DOWN' | 'A' | 'B' | 'SELECT' | 'START';

  /**
   * Game Boy ROM data type
   */
  export type ROM = Uint8Array | ArrayBuffer | number[];

  /**
   * Save data type
   */
  export type SaveData = number[] | Uint8Array;

  /**
   * Screen image data - array of pixel data
   */
  export type ImageData = number[];

  /**
   * Audio buffer data
   */
  export type AudioBuffer = number[];

  /**
   * Memory data type
   */
  export type Memory = number[];

  /**
   * Game Boy emulator interface
   */
  export default class Interface {
    /**
     * Static keymap reference
     */
    static KEYMAP: KeyMap;

    /**
     * Create a new gameboy emulator interface
     */
    constructor();

    /**
     * Load a ROM into the emulator
     * @param ROM - The ROM data to load
     * @param saveData - Optional save data to restore
     * @returns true if ROM was loaded successfully
     */
    loadRom(ROM: ROM, saveData?: SaveData): boolean;

    /**
     * Emulate a single frame
     * @param partial - DEPRECATED - whether to render entire screen or just changed bits
     * @returns Image data for the frame
     */
    doFrame(partial?: boolean): ImageData;

    /**
     * Press multiple keys at once
     * @param keys - Array of key codes or key names to press
     */
    pressKeys(keys: (KeyCode | KeyName)[]): void;

    /**
     * Press a single key
     * @param key - Key code or key name to press
     */
    pressKey(key: KeyCode | KeyName): void;

    /**
     * Get array of currently pressed keys
     * @returns Array of pressed key states
     */
    getKeys(): boolean[];

    /**
     * Get the current screen data
     * @returns Current screen image data
     */
    getScreen(): ImageData;

    /**
     * Get a block of memory
     * @param start - Starting memory address (default: 0)
     * @param end - Ending memory address (default: memory length - 1)
     * @returns Memory data array
     */
    getMemory(start?: number, end?: number): Memory;

    /**
     * Get audio buffer data
     * @returns Audio buffer
     */
    getAudio(): AudioBuffer;

    /**
     * Get save data
     * @returns Current save state data
     */
    getSaveData(): SaveData;

    /**
     * Set memory data
     * @param start - Starting memory address
     * @param data - Data to write to memory
     */
    setMemory(start: number, data: number[]): void;
  }

  /**
   * Keymap constants
   */
  export const KEYMAP: KeyMap;
}
