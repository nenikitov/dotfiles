const SECOND = 1000;
const MINUTE = 60 * SECOND;
const HOUR = 60 * MINUTE;

/**
 * @param {number} n
 * @returns {number}
 */
export function seconds(n) {
  return SECOND * n;
}

/**
 * @param {number} n
 * @returns {number}
 */
export function minutes(n) {
  return MINUTE * n;
}

/**
 * @param {number} n
 * @returns {number}
 */
export function hours(n) {
  return HOUR * n;
}
