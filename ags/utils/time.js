const second = 1000;
const minute = 60 * second;
const hour = 60 * minute;

/**
 * @param {number} n
 * @returns {number}
 */
export function seconds(n) {
  return second * n;
}

/**
 * @param {number} n
 * @returns {number}
 */
export function minutes(n) {
  return minute * n;
}

/**
 * @param {number} n
 * @returns {number}
 */
export function hours(n) {
  return hour * n;
}
