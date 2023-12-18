import {waitOrAbort} from '../tui/prompt.js';
import {DEFAULT_RICE_COOKER_CAPACITY_CUP} from './constants.js';
import {getEstimatedCookDurationByFoodCupSeconds} from './cooking.js';
import {getRecommendedWaterToRice} from './rice_to_water_ratio.js';

/**
 * This class simulates the behavior of a real rice cooker
 */
export class RiceCooker {
  #isPlugged;
  #isLidOpen;
  #riceCup;
  #waterCup;
  #cooked;
  capacity;

  /**
   * @param {number} capacity
   * @constructor
  */
  constructor(capacity = DEFAULT_RICE_COOKER_CAPACITY_CUP) {
    this.#isPlugged = false;
    this.#isLidOpen = false;
    this.#waterCup = 0;
    this.#riceCup = 0;
    this.#cooked = false;
    this.capacity = capacity;
  }

  /**
   * @param {boolean} isPlugged
   */
  setIsPlugged(isPlugged) {
    if (isPlugged === this.#isPlugged) {
      console.log('[INFO] Rice cooker is already ' +
      this.#getTextualStatus().main);
      return;
    }
    this.#isPlugged = isPlugged;
  }

  /**
   * @param {boolean} isOpen
   */
  setIsLidOpen(isOpen) {
    if (this.#isPlugged) {
      console.log('[DANGEROUS] You shouldn\'t touch the lid when the rice ' +
      'cooker is plugged');
    }
    if (isOpen === this.#isLidOpen) {
      console.log('[INFO] Lid is already ' + this.#getTextualStatus().lid);
      return;
    }
    this.#isLidOpen = isOpen;
    this.logRecommendation();
  }

  /**
   * @return {{main: string,lid: string}}
   */
  #getTextualStatus() {
    return {
      main: this.#isPlugged ? 'plugged' : 'unplugged',
      lid: this.#isLidOpen ? 'opened' : 'closed',
    };
  }

  /**
   * recommends different things like: cup of water
   */
  logRecommendation() {
    if (this.#cooked) {
      console.log('[RECOMMENDATION] You can get the ready-to-serve cook now');
      return;
    }

    if (this.#isLidOpen) {
      if (!this.#riceCup) {
        console.log('[RECOMMENDATION] Begin by placing raw food now');
      } else {
        const water = getRecommendedWaterToRice(this.#riceCup);
        console.log('rec', water, 'actual', this.#waterCup);
        if (water !== this.#waterCup) {
          console.log('[RECOMMENDATION] For the actual cup of rice ' +
          water + ' cup of water is the ideal for a well cooked rice:D');
        } else {
          console.log('[RECOMMENDATION] You\'re already good to go');
        }
      }
    }
  }

  /**
   * Get the ready to serve food
   */
  getCooked() {
    if (!this.#isLidOpen) {
      console.log('[HINT] consider opening the lid of the inner pot');
      return;
    }
    this.#cooked = false;
    this.#riceCup = 0;
    this.#waterCup = 0;
  }

  /**
   * place raw food in the inner pot
   * @param {number} riceCup
   */
  addRice(riceCup = 0) {
    if (!this.#isLidOpen) {
      console.log('[HINT] consider opening the lid of the inner pot');
      return;
    }
    this.#riceCup += riceCup;
    this.logRecommendation();
  }

  /**
   * @param {number} waterCup
   */
  addWater(waterCup = 0) {
    if (!this.#isLidOpen) {
      console.log('[HINT] consider opening the lid of the inner pot');
      return;
    }
    this.#waterCup += waterCup;
    this.logRecommendation();
  }

  /**
   * Begin cooking
   * @param {boolean} realtimeTimerLog
   */
  async cook(realtimeTimerLog = true) {
    const timeMilliS =
        getEstimatedCookDurationByFoodCupSeconds(this.#riceCup) * 1_000;

    const cancelled = await waitOrAbort(timeMilliS, function onStart() {
      console.log('Cooking..., [WARN] for your security, don\'t ' +
      'try to cancel');
    }, realtimeTimerLog);

    if (cancelled) {
      console.log('[DANGEROUS] Do not use this option ' +
        'too often for your security');
      return;
    }

    this.#cooked = true;
    this.logRecommendation();
  }

  /**
   * @return {boolean}
   */
  get isReadyToServe() {
    return this.#cooked;
  }

  /**
   * @return {boolean}
   */
  get isPlugged() {
    return this.#isPlugged;
  }

  /**
   * @return {boolean}
   */
  get isLidOpen() {
    return this.#isLidOpen;
  }

  /**
   * @return {number}
   */
  get riceCup() {
    return this.#riceCup;
  }

  /**
   * @return {number}
   */
  get waterCup() {
    return this.#waterCup;
  }
}
