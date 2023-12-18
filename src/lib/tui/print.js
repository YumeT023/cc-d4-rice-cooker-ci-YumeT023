export const printLogo = () => {
  console.log(
      `
   Y88b      / 888 888          e      888b    | Y88b    /
    Y88b    /  888 888         d8b     |Y88b   |  Y88b  / 
     Y88b  /   888 888        /Y88b    | Y88b  |   Y88b/  
      Y888/    888 888       /  Y88b   |  Y88b |    Y8Y   
       Y8/     888 888      /____Y88b  |   Y88b|     Y    
        Y      888 888____ /      Y88b |    Y888    /     
    `,
  );
};

export const printList = (items = []) => {
  if (items.length) {
    const decimal = items
        .map((str, index) => `${index + 1} - ${str.toString()}`)
        .join('\n');
    console.log(decimal);
    printNewline();
  }
};

export const printNewline = (times = 1) => console.log('\n'.repeat(times));

export const printObject = (header, object) => {
  printHeader(header);
  Object.keys(object).forEach((key) => {
    console.log(key, object[key]);
  });
};

export const printHeader = (header) => {
  console.log(header);
  console.log('------------------');
};

/**
 * @param {number} milliseconds
 * @return {{done: function(), start: function()}}
 */
export const createIntervalPrinter = (milliseconds) => {
  let time = 0;
  let intervalId = null;

  return {
    done: () => {
      intervalId && clearInterval(intervalId);
    },
    start: () => {
      intervalId = setInterval(() => {
        process.stdout.clearLine();
        process.stdout.cursorTo(0);
        process.stdout.write(`timer: ${time}ms`);
        time += milliseconds;
      }, milliseconds);
    },
  };
};
