import Readline from 'node:readline';
import {scheduler} from 'node:timers/promises';
import {createIntervalPrinter} from './print.js';

export const rl = Readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

// now, I can listen to Stdin keypress
Readline.emitKeypressEvents(process.stdin);

/**
 * @param {string} query
 * @param {function(string)} cb
 */
export function prompt(query, cb) {
  rl.question(`${query}\n> `, (answer) => {
    cb(answer);
  });
}

/**
 * Promise-based prompt.
 * @param {string} query
 * @return {Promise<string>}
 */
export function promptAsync(query) {
  return new Promise((resolve) => {
    prompt(query, resolve);
  });
}


/**
 * @param {number} milliseconds
 * @param {function()?} onStart
 * @return {Promise<boolean>} if it's cancelled or not
 */
export const waitOrAbort = async (milliseconds, onStart) => {
  // scheduler.wait(milliseconds);
  rl.setPrompt('Press any key to cancel: ');
  const interval = createIntervalPrinter(100);
  const ac = new AbortController();
  const signal = ac.signal;

  return await new Promise((resolve) => {
    const abort = () => {
      rl.pause();
      ac.abort();
      interval.done();
      console.log('\n');
    };

    process.stdin.once('keypress', abort);

    // start
    onStart && onStart();
    rl.prompt();
    interval.start();

    scheduler.wait(milliseconds, {signal})
        .then(() => {
          rl.pause();
          resolve(false);
          interval.done();
          process.stdin.off('keypress', abort);
        })
        .catch(() => resolve(true));
  });
};
