import {test, describe} from 'vitest';
import {RiceCooker} from '../lib/core/rice_cooker';
import {mockConsoleLog} from './util';

const newRiceCooker = () => new RiceCooker(20);

const newReadyRiceCooker = () => {
  const rc = newRiceCooker();
  rc.setIsLidOpen(true);
  rc.addRice(1);
  rc.addWater(0.5);
  rc.setIsLidOpen(false);
  rc.setIsPlugged(true);
  return rc;
};

describe('Rice Cooker', () => {
  test('Plug/Unplug, lid Open/Close', ({expect}) => {
    const log = mockConsoleLog();
    const rc = newRiceCooker();

    expect(rc.isPlugged).toBeFalsy();
    expect(rc.isLidOpen).toBeFalsy();

    rc.setIsPlugged(false);
    expect(log.mock.calls[0][0]).toEqual('[INFO] Rice cooker ' +
    'is already unplugged');

    rc.setIsLidOpen(false);
    expect(log.mock.calls[1][0]).toEqual('[INFO] Lid ' +
    'is already closed');

    rc.setIsPlugged(true); // plugs rc
    expect(rc.isPlugged).toBeTruthy();

    rc.setIsLidOpen(true);
    expect(rc.isLidOpen).toBeTruthy();
    expect(log.mock.lastCall[0]).toEqual('[RECOMMENDATION] Begin by placing ' +
    'raw food now');
  });

  test('Food cup', ({expect}) => {
    const rc = newRiceCooker();
    const log = mockConsoleLog();

    expect(rc.riceCup).toBe(0);
    expect(rc.waterCup).toBe(0);

    rc.addRice(3);

    expect(log.mock.lastCall[0])
        .toEqual('[HINT] consider opening the lid of the inner pot');

    rc.setIsLidOpen(true);
    rc.addRice(2.5);
    rc.addWater(1.5);

    expect(rc.riceCup).toEqual(2.5);
    expect(rc.waterCup).toEqual(1.5);

    rc.addRice(0.5);

    expect(log.mock.lastCall[0]).toEqual(
        '[RECOMMENDATION] You\'re already good to go',
    );

    expect(rc.riceCup).toBe(3);
  });

  test('Cook', async ({expect}) => {
    const rc = newReadyRiceCooker();
    const log = mockConsoleLog();

    try {
      await rc.cook(false);
    } catch {/* Empty */}

    expect(log.mock.lastCall[0]).toEqual(
        '[RECOMMENDATION] You can get the ready-to-serve cook now',
    );
  });
});
